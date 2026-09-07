# S02 — Graduation Handoff

Status: **GRADUATED**
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Accepted lab: S02-012 workflow `34091326973`, source `888a06f985e02101f866a8c07ab866c2520316a3`

## What a fresh AI must know

S02 is not a lesson about “the LinuxCNC watchdog” as one thing. It is a lesson about **failure domains**.

### Generic HAL `watchdog(9)`

- supervises transitions on one or more software heartbeat inputs;
- `watchdog.process` decrements timeout state when transitions do not arrive;
- a bite clears `ok-out`;
- heartbeat resumption alone does not recover a bitten watchdog;
- `watchdog.set-timeouts` must observe `enable-in` FALSE→TRUE to re-arm;
- it is primarily liveness supervision, not proof that a command or machine state is logically correct.

### `estop_latch(9)`

- latches a software fault state;
- requires healthy inputs plus a reset rising edge to return to OK;
- produces a toggling watchdog output only while OK;
- can participate in LinuxCNC's E-stop/control chain, but its HAL state is not a safety certification.

### HostMot2 firmware watchdog

- is a distinct FPGA/board-side mechanism serviced by HostMot2 writes;
- on a documented bite, HostMot2 I/O pins are disconnected from module instances and become high-impedance inputs;
- that pin-mode change is not automatically proof of drive disable, STO, or zero torque.

### External supervision

Charge pumps, relays, drive enables, STO channels, brakes, contactors, and safety controllers belong to separate physical failure domains. They must be evaluated from their own schematics, manuals, measurements, diagnostics, and applicable safety requirements.

## Accepted experiment

The final S02-012 run used production LinuxCNC HAL components at the pinned revision. Its raw artifact returned exit 0 and passed every predeclared gate:

- initial disabled state;
- heartbeat source established;
- explicit enable rising-edge arm;
- healthy transitions maintain OK;
- frozen heartbeat bites;
- heartbeat resumption alone does not recover;
- explicit enable FALSE→TRUE re-arms.

Three earlier executions were classified HARNESS INVALID before any behavioral claim was accepted. The final hosted run required LinuxCNC's testing-only `LINUXCNC_FORCE_REALTIME=1` override and therefore proves software state-machine semantics only, not realtime latency or physical response.

## Fresh-AI competency test

A fresh AI graduates S02 only if it answers all of these correctly:

1. A heartbeat stuck TRUE is unhealthy because the watchdog monitors **transitions**, not a high level.
2. A bitten generic watchdog does not recover merely because transitions resume; explicit re-arm is required.
3. `watchdog(9)`, `estop_latch(9)`, HostMot2's FPGA watchdog, and an external safety/charge-pump circuit are separate mechanisms.
4. Multiple watchdogs are not automatically independent; shared CPU, scheduling, power, transport, or logic can create common-cause failure.
5. Timely execution can still carry a dangerous command; liveness is not command correctness.
6. HostMot2 high-impedance pins do not by themselves prove zero torque or a safe machine state.
7. A headless userspace PASS cannot be converted into a stopping-time, PL/SIL/category, or functional-safety claim.

Any answer that collapses those boundaries requires correction before downstream safety modules.

## Durable evidence

- `guides/S02-watchdog-source-and-design-guide.md`
- `experiments/S02-012-watchdog-heartbeat-plan.md`
- `experiments/S02-012-attempt1-harness-diagnosis.md`
- `experiments/S02-012-attempt2-runner-realtime-diagnosis.md`
- `experiments/S02-012-attempt3-halrun-lifecycle-diagnosis.md`
- `experiments/S02-012-watchdog-heartbeat-accepted-result.md`
- `exams/S02-adversarial-exam-and-corrections.md`
- `lab-jobs/012-s02-watchdog-heartbeat.sh`

## Next dependency

Proceed to **S03 — communication-loss behavior**. Start by tracing how a transport-specific failure becomes LLIO/HostMot2 `io_error`, what host read/write paths stop publishing or writing once that error is set, what HAL values can therefore remain stale, and how this differs from a HostMot2 watchdog bite or an external drive/safety fault.
