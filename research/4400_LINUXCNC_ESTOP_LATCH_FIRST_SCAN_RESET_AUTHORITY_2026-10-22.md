# 4400 — LinuxCNC `estop_latch`: a software reset edge is not a safety-authorized human reset

**Evidence:** pinned LinuxCNC upstream source at tag `v2.9.10`, inspected 2026-10-22. **SOURCE-CONFIRMED** for the specified component/generator, not a machine test, certification or personnel-safety design. No simulation is needed to establish this deterministic branch condition.

## Source trace and important corner case

1. `src/hal/components/estop_latch.comp`, blob `e95fabd323f3c7ccbc8a18146ddd93d6f7d70e20`, declares `pin in bit ok_in = true`, `fault_in = false`, `reset`, and outputs `ok_out = false`, `fault_out = true`, `watchdog`. It declares `option data estop_data` with `typedef struct { int old_reset; } estop_data;`.
2. Its `FUNCTION(_)` checks `if (ok_in && !fault_in)`, then `if (reset && !data.old_reset) { ok_out = 1; fault_out = 0; }`. It toggles the software watchdog while `ok_out` is true, and faults if `ok_in` is false or `fault_in` true. At the end of each call, it saves `data.old_reset = reset`.
3. `src/hal/utils/halcompile.g`, blob `ed605845e745a1d0be474fcf05e9746191cb2984`, generator lines **401–405** allocate component state + data with `hal_malloc`, explicitly `memset(inst, 0, sz)`, and point `inst->_data` into the zeroed allocation. Thus the `old_reset` data begins at zero for a newly exported instance in this pinned implementation.
4. **First-call counterexample:** if `reset` is already TRUE at the first function invocation, and `ok_in` is TRUE and `fault_in` FALSE, `reset && !old_reset` is TRUE because `old_reset` was initialized to zero. The software `ok_out` can transition TRUE without observing a low-to-high transition *after* the component began running. This is an input-sampling initialization property, not proof that a human deliberately operated a reset control after fault clearance.

The source declares `ok_in` default TRUE and `fault_in` default FALSE; its own documentation warns that at least one of these fault-source inputs must be connected for a fault to be signaled. A latch wired with neither input is not a complete external E-stop chain. **Documentation/source discrepancy:** the component description says `fault-en` in its permissive-default warning, but the actual declared input pin is `fault_in` (`fault-in` in HAL). Treat `fault-en` as a documentation typo, not a separate source-confirmed pin. This is **SOURCE-CONFIRMED** for the declared pin defaults and **DOC-CONFIRMED** for the warning, not a claim about any actual wiring.

The manual for `estop_latch(9)` describes a software E-stop latch with initial faulted state and rising-edge reset. The source trace narrows what **rising edge** means at startup: it compares the current sampled value with zero-initialized history. It does **not** prove the external button was previously low during a powered-up, observed interval.

## Version comparison (bounded)

The upstream `master` branch inspected on 2026-10-22 (moving ref; `estop_latch.comp` blob `f8b0e60b2784d6ca4c456fddd49e7308fa669795`, `halcompile.g` blob `a610bba80794cc33b5fc524fb80e094fa2900a76`) still uses `reset && !data.old_reset` and generated `memset(inst, 0, sz)`. The newer source writes outputs through `ok_out_set(...)` / `fault_out_set(...)`, rather than the pinned v2.9.10 direct assignments. This supports the **specific** edge/history observation on both inspected revisions; it does not prove identical behavior for all releases, HAL scheduling contexts or machine configurations.

## Truth table for the pinned function (logical prediction; not a lab result)

| First invocation inputs/history | Software outcome in this function | What it does not establish |
|---|---|---|
| `old_reset=0`, `reset=1`, `ok_in=1`, `fault_in=0` | `ok_out=1`, `fault_out=0`, watchdog toggles | Deliberate post-start human reset, independent safety reset, final element safe |
| `old_reset=0`, `reset=0`, `ok_in=1`, `fault_in=0` | `ok_out` remains default FALSE, `fault_out` TRUE | Future reset policy |
| `reset=1`, `ok_in=0` or `fault_in=1` | Fault branch sets `ok_out=0`, `fault_out=1` | Physical power isolation or held load |
| Subsequent `reset=1`, `old_reset=1`, `ok_in=1`, `fault_in=0`, `ok_out=0` | No new edge, remains faulted until an observed low then high | Fault is impossible to clear by some independent means |
| `ok_in`/`fault_in` both left unconnected with defaults | Neither default asserts a fault; reset edge may set `ok_out` | External E-stop fault coverage |

## Inspectable HAL example, not a safety design

The pinned `configs/by_interface/parport/plasma-thc-sim/estop.hal` (blob `9dd7ea33506a46dd3d637483e615afc7c0687afb`) loads `estop_latch`, schedules it in `base-thread`, connects `iocontrol.0.user-request-enable` to `estop-latch.0.reset`, `iocontrol.0.user-enable-out` to `estop-latch.0.ok-in`, and `estop-latch.0.ok-out` back to `iocontrol.0.emc-enable-in`. This **SOURCE-CONFIRMED configuration example** does not connect `fault-in` in that file. Its simulation role and surrounding config must not be interpreted as a personnel-safety circuit or proof of a physical E-stop input. The presence of an example HAL connection does not turn the software latch into a safety-rated final element.

## Consequence for a safety architecture

The documented typical HAL connection `iocontrol.0.user-request-enable -> estop_latch.reset` and `estop_latch.ok-out -> iocontrol.0.emc-enable-in` participates in **ordinary LinuxCNC software E-stop/status coordination**. The `io(1)` manual explicitly identifies the IO controller as **non-realtime** and its `emc-enable-in` as a signal that should be FALSE when an external E-stop exists. Neither the component nor its watchdog pin is a certified independent personnel-safety final element. The first-scan case is another reason not to use a HAL software reset as the sole safeguard against unexpected restart.

**Design allocation:** independently selected safety-related control must own the relevant E-stop, guard, reset/rearm, anti-restart and physical final-element actions. LinuxCNC may receive an externally verified status, inhibit ordinary commands, request controlled actions and report diagnostics. `reset accepted` is not `ordinary cycle start`, and `software watchdog toggling` is not `physical energy removed` or `ram held`.

## Adversarial verification plan

A **documentary/source review** already resolves the first-call logic; do not launch a lab merely to observe it. For a specific selected machine, trace actual HAL connections, startup ordering, input pull states, external safety controller and reset requirements. If a bounded test later becomes necessary for an unresolved selected interface, freeze a test question and run only on `[self-hosted, openpressbrake]` with no exposed person/hazard. A software-only fixture cannot establish achieved machine PL/SIL, stopping time, guarding or physical safe state.

## Provenance

- Source: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/estop_latch.comp (blob `e95fabd323f3c7ccbc8a18146ddd93d6f7d70e20`).
- Example config: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_interface/parport/plasma-thc-sim/estop.hal (blob `9dd7ea33506a46dd3d637483e615afc7c0687afb`).
- Generator: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/utils/halcompile.g (blob `ed605845e745a1d0be474fcf05e9746191cb2984`, lines 401–405).
- Official LinuxCNC 2.9 `io(1)` and `estop_latch(9)` documentation: https://www.linuxcnc.org/docs/devel/html/en/man/man1/iocontrol.1.html and https://linuxcnc.org/docs/devel/html/es/man/man9/estop_latch.9.html (devel pages are version-sensitive; source evidence here is pinned to v2.9.10).
