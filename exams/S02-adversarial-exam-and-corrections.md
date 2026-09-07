# S02 — Adversarial Watchdog Exam and Correction Key

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Module state when authored: EXPERIMENT

This exam tests whether a fresh AI can preserve failure-domain boundaries instead of treating every heartbeat, latch, FPGA watchdog, or external safety device as interchangeable.

## Exam

### 1. Stuck-high heartbeat

A HAL heartbeat input is TRUE continuously. `watchdog.enable-in` is TRUE, `watchdog.timeout-0` is 50 ms, and `watchdog.process` is scheduled normally. An engineer says, “The heartbeat is high, so the watchdog is healthy.” Is that correct? Explain what the component actually supervises.

### 2. Bite and spontaneous recovery

A heartbeat freezes long enough for `watchdog.ok-out` to become FALSE. The heartbeat then resumes toggling while `watchdog.enable-in` remains TRUE. Should `ok-out` recover automatically? State the required software re-arm sequence.

### 3. “Two watchdogs means twice the safety”

A design uses both `watchdog(9)` and a HostMot2 firmware watchdog. Both are serviced by logic whose execution ultimately depends on the same PC, LinuxCNC process set, servo scheduling, and power supply. The designer claims this automatically doubles diagnostic coverage and establishes a safety category. Identify the reasoning error.

### 4. HostMot2 bite means zero torque

A HostMot2 watchdog bites and the documented board I/O pins become high-impedance inputs. Can the AI conclude that every connected servo has zero torque? What additional layers must be known or measured before making a physical-state claim?

### 5. A timely but wrong command

LinuxCNC continues executing on schedule and services every watchdog, but a software defect produces a dangerous yet syntactically valid motion command every cycle. Which watchdogs discussed in S02 necessarily detect this? Why?

### 6. Timeout/order debugging

`watchdog.process` runs in a nominal 1 ms fast thread. `watchdog.set-timeouts` runs in a nominal 10 ms servo thread. An operator changes `watchdog.timeout-0`, then toggles enable. Why is it invalid to infer an exact physical reaction time simply from the configured timeout value? Name at least three timing/order influences.

### 7. `estop_latch` recovery

`estop_latch.0.fault-in` becomes TRUE and then returns FALSE. `ok-in` remains TRUE. Why can the latch remain Faulted even after the original fault disappears? What event is required for recovery?

### 8. Fresh-AI novel scenario

A machine has this chain:

`servo-thread health bit -> watchdog(9) -> estop_latch fault input -> LinuxCNC E-stop state`

The same PC loses scheduling for both the servo thread and the thread that executes `watchdog.process`. A separate external drive enable remains electrically asserted because it is not supervised outside that PC. A fresh AI is asked: “Will this architecture definitely remove torque?” Answer using failure-domain reasoning, and propose the minimum kind of evidence needed before making that claim.

### 9. Small HAL design modification

The current lab gates a toggling heartbeat through `and2`: setting one input FALSE freezes the downstream signal at FALSE. Suppose it were instead gated so the downstream signal freezes at TRUE. Would a correctly functioning `watchdog(9)` still be expected to bite? Explain without relying on the absolute level.

### 10. Evidence classification

A headless userspace lab successfully demonstrates heartbeat transitions, a bite after freezing, failure to recover on heartbeat resumption, and successful explicit re-arm. Classify what is TEST-CONFIRMED and list at least four things that remain outside the evidence.

---

# Correction / answer key

## 1

Incorrect. `watchdog(9)` supervises **transitions**. A signal stuck TRUE is just as dead as one stuck FALSE: no transition reloads the countdown, so an enabled/armed watchdog eventually clears `ok-out`.

## 2

No automatic recovery is expected. Once bitten, `process()` returns while `ok-out` is FALSE. `watchdog.set-timeouts` must observe an explicit `enable-in` FALSE→TRUE transition; restoring heartbeat transitions alone is insufficient.

## 3

The claim confuses multiplicity with independence. Multiple watchdog mechanisms can cover different failures, but shared CPU, scheduler, process, power, wiring, software logic, or communication paths create common-cause failures. Neither source code nor the mere count of watchdogs establishes diagnostic coverage, PL, SIL, or a safety category.

## 4

No. High impedance is a board-pin electrical configuration, not a universal actuator safe state. The result depends on pull-ups/pull-downs, breakout/interface circuitry, drive input logic, enable/STO wiring, stored energy, brakes/contactors, failure modes, and verified physical response. Physical measurement and machine-specific safety analysis are required.

## 5

None necessarily. A liveness watchdog can be satisfied by timely execution that is logically wrong. S02 watchdogs principally establish that expected transitions/servicing occur within their monitored failure domain; they are not command-validity or hazard monitors unless separate logic explicitly checks those properties.

## 6

The configured timeout is not a physical stop-time guarantee. Relevant influences include the `watchdog.process` thread period and scheduling/jitter, where in its cycle the last transition and expiry occur, `set-timeouts` thread period/order and when a new value/enable edge becomes visible, scheduler overruns, downstream propagation, transport/FPGA behavior, drive reaction, and mechanical stopping dynamics. The 1000-level source claim is qualitative timeout/re-arm behavior, not a certified response bound.

## 7

`estop_latch` intentionally latches the faulted state. Recovery requires healthy input conditions **and a reset rising edge**. Merely clearing `fault-in` does not erase the latched fault.

## 8

No definite torque-removal claim is possible. The proposed checker and heartbeat producer share the same scheduling failure domain, so the checker itself can stop executing. The unsupervised external enable can remain asserted. Evidence sufficient for a physical claim must extend outside the failed domain: e.g. an independently powered/scheduled hardware supervisor or safety function with specified fail state, verified wiring to the drive's appropriate inhibit/STO function, and machine-specific validation/measurement. A LinuxCNC HAL state alone is insufficient.

## 9

Yes. The component watches changes, not whether the frozen value is FALSE. Freezing at TRUE also stops transitions and therefore should eventually expire the countdown.

## 10

If every predeclared gate and harness-validity check passes, the lab TEST-CONFIRMS the exercised generic HAL `watchdog(9)` transition-timeout and explicit-rearm semantics at the pinned revision in that userspace laboratory. It does **not** confirm production realtime latency, exact worst-case timeout, HostMot2 FPGA bite behavior, board-pin voltage/current, external charge-pump behavior, drive torque removal, STO, stopping time, or functional-safety performance/certification.

## Graduation grading rule

S02 passes only if the fresh-AI answer preserves all of these boundaries:

- transition/liveness supervision is not command correctness;
- `watchdog(9)` is not `estop_latch(9)`;
- neither software component is the HostMot2 firmware watchdog;
- high-impedance I/O is not automatically a physical safe state;
- multiple watchdogs are not automatically independent;
- lab timing is not machine stopping time;
- physical functional-safety claims require evidence outside generic LinuxCNC software state.

Any answer that equates an OK heartbeat with machine safety, equates a HostMot2 bite with proven zero torque, or infers PL/SIL/category from these software mechanisms fails the module and requires correction.
