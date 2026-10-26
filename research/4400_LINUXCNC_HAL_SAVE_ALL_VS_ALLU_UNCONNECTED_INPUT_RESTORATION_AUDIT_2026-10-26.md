# 4400-HAL-SNAPSHOT-01 — A successful HAL `save all` can omit disconnected input values

**2026-10-26 | SOURCE-CONFIRMED at LinuxCNC v2.9.10 and development `062dc7c097693bb68e76192516cd92878dd5ecdf` | DOC-CONFIRMED 2.9 halcmd(1) | no execution/physical evidence.**

## Predeclared question
Does a saved HAL snapshot include **every current input pin value**, especially an unconnected input that retained TRUE after `unlinkp`? If not, what is the precise difference between `save all` and `save allu`, and why is neither a validated personnel-safety configuration record?

## Source proof
- [Stable `src/hal/utils/halcmd_commands.cc`, blob `1899082`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/utils/halcmd_commands.cc), `do_save_cmd` ~2451–2522: the `all` and `allu` branches share component, alias, signal, net, parameter and thread serialization; **only** `allu` calls `save_unconnected_input_pin_values` (~2479–2481). Helper ~2788–2805 emits `setp` for **unconnected HAL_IN/HAL_IO** dummy values.
- [Pinned development `halcmd_commands.cc`, blob `3524191`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/utils/halcmd_commands.cc), `do_save_cmd` ~2116–2187: same `allu`-only branch ~2144–2146. Helper ~2445–2457 selects pins without a signal and HAL_IN/HAL_IO direction. **Two-revision source consistency**, not a claim for every LinuxCNC release.
- [Official LinuxCNC 2.9 halcmd(1)](https://linuxcnc.org/docs/2.9/html/man/man1/halcmd.1.html) documents that `allu` adds `unconnectedinpins`, while default/`all` omits it.
- [HAL-MUTATION-01 source trace](4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md) independently establishes that a disconnected scalar input's dummy initially inherits its last signal value.

## Causal configuration-drift counterexample
A process input is TRUE when a technician unlinks it; HAL copies TRUE to its unconnected dummy. The technician saves the current configuration using `save all` and labels the file “complete.” **SOURCE-CONFIRMED:** this output omits the unconnected input pin's `setp` value. If the machine is later reconstructed from only that file, the restored value depends on the component's initial/default behavior and other startup configuration—not a guaranteed recreation of the previous TRUE. `save allu` serializes the unconnected pin value, but **that is not evidence that the value is physically true or safe**.

**Do not infer automatic startup motion, a particular restored value, or a machine-specific failure** without the exact startup graph and runtime observation.

## Adversarial distinctions
1. **Snapshot coverage:** `all` versus `allu` differs in unconnected input value inclusion.
2. **Snapshot fidelity:** saved commands may not capture all userspace processes, external drive parameters, firmware, physical wiring, safety controller logic or machine-specific startup side effects.
3. **Safety integrity:** neither command validates independent safety functions, final-element condition, pressure-zone isolation, Y1/Y2 gravity holding, guarding or restart interlocks.
4. **Change control:** a successful command or hash proves only a file operation/identity; it does not prove as-built physical safety.
5. **Human factors:** a simple read-only topology report with missing-writer flags and a service restoration checklist is better than forcing operators to manually reconstruct undocumented permissives.

## Evidence ledger
| Claim | Class | Scope |
|---|---|---|
| `save all` excludes unconnected HAL_IN/HAL_IO dummy values | SOURCE-CONFIRMED / DOC-CONFIRMED | Pinned v2.9.10/development |
| `save allu` includes `setp` lines for unconnected input pins | SOURCE-CONFIRMED / DOC-CONFIRMED | Same revisions |
| A HAL snapshot is a complete machine safety configuration and physical witness | NOT ESTABLISHED | Independent safety controller, hardware and qualified verification required |
| Selected OpenPressBrake uses these commands or has a disconnected safety-related permissive | UNKNOWN | No private as-built evidence |
| Restoring either file causes automatic motion or a particular valve state | UNKNOWN | No runtime/physical test |
| Measured stop time, PL/SIL, Y1/Y2 hold, pressure isolation | UNKNOWN | No physical evidence |

## Engineering response and lab decision
During qualified **no-energy** service, preserve both versioned as-built HAL topology and independent safety-system configuration evidence; explicitly list writerless/unlinked inputs and default values. Compare actual installed state to approved baseline before returning to service, then independently verify physical safeguards and require fresh start. No simulated lab is needed to prove the narrow save-branch difference. A later bounded local-runner lab is justified only if a real reproducibility dispute arises; it would not authorize hazardous operation. **G0/G1 HOLD; evaluator NOT RUN; 0 hosted/local compute.**
