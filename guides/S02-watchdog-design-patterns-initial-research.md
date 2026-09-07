# S02 — Watchdog Design Patterns: Initial Research

Status: RESEARCH. This begins after S01 graduation and reuses HM08 without collapsing watchdog behavior into functional-safety claims.

## Documentation findings

Current HostMot2 documentation describes a firmware watchdog that is serviced by the normal HostMot2 `write` function. The documented default timeout is 5 ms. On a bite, board I/O pins are disconnected from module instances and become high-impedance inputs; firmware module state otherwise continues, including encoder counting and PWM/step generation internally. Clearing `watchdog.has_bit` is the documented recovery mechanism. This is **DOC-CONFIRMED** behavior and was already bounded by HM08 source analysis; it is not physical-board verification.

LinuxCNC also has a generic realtime `watchdog(9)` component. It monitors transitions on up to 32 heartbeat inputs. `process` clears `ok-out` when a heartbeat times out, and after timeout the monitoring logic requires `enable-in` to be cycled FALSE->TRUE before re-enabling. Documentation suggests `ok-out` may feed an external monitoring mechanism such as a charge pump. This is a different layer and mechanism from the HostMot2 firmware watchdog.

`estop_latch(9)` is explicitly documented as a **software ESTOP latch**. It starts Faulted, requires valid inputs plus a reset edge to enter OK, faults when `fault-in` asserts or `ok-in` drops, and can emit a toggling watchdog output while OK. Typical documentation wiring feeds its `ok-out` to `iocontrol.0.emc-enable-in`. Its name and example wiring do not establish a safety-rated physical E-stop function; S01's boundary remains controlling.

## Initial pattern taxonomy

1. **Host-interface liveness watchdog** — HostMot2 firmware detects missing host servicing and changes FPGA-board I/O ownership/state.
2. **HAL heartbeat supervision** — generic `watchdog(9)` detects a software heartbeat that stops transitioning and publishes an ordinary HAL `ok-out` state.
3. **Software fault latch / restart interlock** — `estop_latch(9)` combines fault/OK conditions with a deliberate reset edge and can drive the LinuxCNC external E-stop input.
4. **External hardware supervision** — an external device may consume a heartbeat/charge-pump signal and independently remove or inhibit energy. Its actual fail state and safety integrity are hardware- and design-specific and cannot be inferred from the HAL source alone.

## Immediate adversarial observations

- A watchdog can detect one class of liveness failure while missing logically wrong but still regularly executing software.
- A watchdog timeout value is not a physical stopping-time guarantee.
- Automatic watchdog recovery is a distinct policy question from detection. HostMot2 `has_bit` recovery and generic watchdog `enable-in` re-arm semantics must not be conflated.
- A heartbeat generated and checked inside the same failed dependency domain may provide little independent diagnostic coverage.
- “Fail safe” must name the actual output/energy state and failure assumptions. A high-impedance FPGA pin is not automatically a safe actuator state unless downstream circuitry makes it so.

## Source checkpoint

Next trace pinned source for `watchdog.comp` and `estop_latch.comp`, then connect those software patterns to the already-graduated HM08 HostMot2 watchdog path. Build a comparison matrix covering failure detected, execution domain, reset/re-arm semantics, externally visible output, common-cause weaknesses, and what each pattern cannot prove. Search representative LinuxCNC configurations for real watchdog/estop-latch/charge-pump wiring and use community reports only as failure-mode leads.