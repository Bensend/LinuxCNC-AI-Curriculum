# 4400 pinned LinuxCNC source audit — estop_latch held-high first-scan reset

**Pinned source:** upstream `LinuxCNC/linuxcnc` tag `v2.9.10`, inspected 2026-10-23. **SOURCE-CONFIRMED** source and generator behavior, **INFERENCE** conditional first-scan timeline; **TEST-CONFIRMED: none**. No machine-level safety authority.

## Source and immutable blob identifiers

- `src/hal/components/estop_latch.comp` Git blob `e95fabd323f3c7ccbc8a18146ddd93d6f7d70e20`: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/estop_latch.comp
- `src/hal/utils/halcompile.g` Git blob `ed605845e745a1d0be474fcf05e9746191cb2984`: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/utils/halcompile.g
- LinuxCNC 2.9 documented software latch: https://linuxcnc.org/docs/2.9/html/man/man9/estop_latch.9.html (manual may have version-dependent URL; source blobs above control).

## Significant execution path

1. The component declares `option data estop_data` and `typedef struct { int old_reset; } estop_data;` with default `ok_in=true`, `fault_in=false`, `ok_out=false`, `fault_out=true`. **SOURCE-CONFIRMED.**
2. `halcompile.g` emits instance allocation `hal_malloc(sz)` followed by `memset(inst, 0, sz)`, and locates `_data` after `struct __comp_state`. The private `old_reset` therefore starts at zero for a newly initialized instance in this generated path. **SOURCE-CONFIRMED.**
3. `FUNCTION(_)` evaluates `if (ok_in && !fault_in)`, then `if (reset && !data.old_reset)` to set `ok_out=1`, `fault_out=0`. It toggles the software watchdog only while `ok_out` is true in the no-fault branch. Otherwise it forces `ok_out=0`, `fault_out=1`. It always ends with `data.old_reset = reset`. **SOURCE-CONFIRMED.**
4. **INFERENCE / predeclared conditional trace:** if the first executed call samples `ok_in=1`, `fault_in=0`, `reset=1`, then zero-initialized `old_reset=0` makes that call satisfy the software edge test. The component's initial documented Faulted state does not establish that a human intentionally pressed reset *after* all machine hazards were cleared. A held-high reset does not by itself rearm after a subsequent fault because `old_reset` remains 1 until a low sample is observed.
5. The component is an ordinary LinuxCNC software ESTOP chain. No source above proves the physical E-stop contacts, safety-rated relay, contactor/drive/valve, load restraint, hydraulic energy, occupancy, stop time or external reset/restart behavior. **UNKNOWN / machine VAL NOT RUN.**

## Failure and adversarial reasoning

- First scan with held-high reset: `ok_out` may become true in the specified input condition. The relevant independent safety controller must own any required deliberate physical reset/rearm semantics; do not relabel this ordinary HAL component as safety-rated.
- Fault with held-high reset: `ok_out` trips false; subsequent clearing of fault does not create a fresh rising edge unless reset was observed low.
- Disconnected `ok_in` and `fault_in` default permissive; at least one genuine external fault source is required for the software chain to respond to an external fault.
- A toggling software watchdog is not an independent physical witness of safe torque removal, safe hydraulic load holding or maintenance isolation.

**Related learner worksheet:** `safety-course/4400_ESTOP_SOFTWARE_STATE_VS_PHYSICAL_PROPOSITION_WORKSHEET_2026-10-22.md`. This audit answers a source-only control question without a synthetic lab; no simulation or physical machine test was necessary or run. Do not infer cross-version behavior without inspecting the exact other revision.
