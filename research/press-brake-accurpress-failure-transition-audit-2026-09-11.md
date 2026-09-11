# Accurpress press-brake — failure/abort transition audit

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 PUBLIC SOURCE ANALYSIS**
Public source attachment: `press_2022-04-25.comp`
URL: https://forum.linuxcnc.org/media/kunena/attachments/723/press_2022-04-25.comp
Related thread: https://forum.linuxcnc.org/30-cnc-machines/42100-pressbrake-cnc-control-setup-questions

## Question

Does the mature public Accurpress cycle component implement explicit terminal transitions for process timeout, operator abort, pedal release, interlock loss and pressure fault, or does it merely expose some of those signals?

This is a direct check against `research/press-brake-generic-failure-ownership-matrix-2026-09-11.md`.

## Source inventory

The inspected 2022 component declares:

- ram/axis position command and physical feedback pins;
- `up` and `down` pedal inputs;
- `abort` input described as “Abort current operation and stop all motion”;
- `interlock` input described as allowing the cycle;
- pressure and maximum-pressure inputs;
- a realtime state machine covering idle, auxiliary positioning, ram approach, bend, bottom/tweak, return, pressure-limit, homing and jogging states.

Evidence class: **SOURCE-CONFIRMED for the public component attachment**. Exact pairing with the adjacent HAL remains unproven, as documented in the prior 2022 stabilization audit.

## Terminal-transition audit

### `abort` pin: declared, but not executed

The public source declares:

```c
pin in bit abort "Abort current operation and stop all motion";
```

A complete inspection of `FUNCTION(_)` finds no read or branch on `abort`.

**Conclusion:** the pin description promises an abort concept, but the shown implementation does not implement it. This is a concrete example of why pin names/descriptions are not behavior evidence.

Classification: **SOURCE-CONFIRMED GAP**.

### `interlock`: only checked while idle

In state 0, the source checks `interlock != 1` and returns without starting a cycle. No corresponding interlock check appears in approach state 5, bend state 6, bottom state 7, return state 8, pressure-limit state 9, homing states 10–13 or jog states 20–23.

**Conclusion:** the component uses `interlock` as a start authorization while idle, not as an explicit mid-cycle abort/fault transition.

Classification: **SOURCE-CONFIRMED**.

Safety boundary: this does not establish whether an external hardwired safety chain removes drive/valve authority independently. The component source alone cannot be used to claim safety behavior either way.

### `up`: operational return/abort gesture in the ram cycle

State 5 (moving down to work) and state 6 (bending) both treat `up` as an operator abort gesture: set target to the top position, transition to state 8, and return from the realtime invocation. State 7 similarly uses `up` to begin return.

This is a real terminal transition for the active downward process state, but it is an **operator/process command**, not a generic fault channel and not evidence of a safety-rated stop.

Classification: **SOURCE-CONFIRMED**.

### pedal release: pause/hold semantics, not a fault

- State 5: if `down` is released, commanded ram velocity is set to zero while the state remains approach.
- State 6: if `down` is released before target, velocity is set to zero; if target is already reached, state advances to the bottom/tweak state 7.
- State 8: if `up` is released during retract, return velocity is set to zero.

**Conclusion:** pedal release is modeled as a hold/pause or state-selection input, not as a latched process fault.

Classification: **SOURCE-CONFIRMED**.

### pressure exceedance: explicit ordinary-control fault state

Before the state switch, `pressure > max_pressure` forces the target to `top_position` and sets state 9. State 9:

- transitions toward ordinary return state 8 after pressure drops to or below the limit;
- commands upward return only while `up` is asserted;
- otherwise commands zero ram velocity.

This is the strongest explicit fault-like process transition in the component. It is ordinary realtime control logic only; it does not establish a certified overpressure protective function.

Classification: **SOURCE-CONFIRMED ORDINARY-CONTROL RESPONSE**.

### process timeout: absent

The component has no elapsed-time state, timeout pin/parameter, state-entry timestamp, countdown, or branch that terminates an approach/bend/return/homing operation because a success condition failed to arrive within a bounded time.

This absence is especially notable because an April 3, 2021 developer comment in the same public thread explicitly suggested that the state machine should probably have timeouts and/or overload “escapes.” The later 2022 source implements an overload/pressure escape but still shows no generic process timeout mechanism.

Classification:

- **COMMUNITY-REPORTED DESIGN SUGGESTION (2021)** for the timeout/overload recommendation.
- **SOURCE-CONFIRMED ABSENCE (2022 attachment)** for a generic timeout mechanism in the inspected component.

### default/invalid state: diagnostics without a commanded safe transition

The `default` switch arm prints `RTAPI_MSG_ERR` for an unsupported state. It does not explicitly zero every output, move to a defined fault state, or latch an abort condition in the shown code.

Classification: **SOURCE-CONFIRMED**. Whether previously commanded downstream trajectory/velocity persists depends on the connected component semantics and is not inferred here without a dedicated runtime trace.

## Comparison against generic failure-ownership matrix

| Condition | Generic contract | Accurpress 2022 public component | Assessment |
|---|---|---|---|
| pedal released | PROCESS owns explicit state/hold behavior | explicit pause/hold behavior | **implemented** |
| operator requests return/abort | PROCESS owns explicit terminal transition | `up` transitions states 5/6/7 to return | **implemented for this operator gesture** |
| pressure exceeds ordinary limit | PROCESS/HYDRAULIC ordinary fault path | pre-switch guard -> state 9 | **implemented** |
| interlock absent before cycle | ordinary authorization blocks cycle start | idle state returns | **implemented** |
| interlock removed during active cycle | operation owner needs defined transition if software is responsible | no active-state branch | **not implemented in this component** |
| generic `abort` input | declared contract says stop current operation | pin never read | **declared but not implemented** |
| process success condition never occurs | operation owner needs explicit timeout/failure transition | no timing/timeout state | **not implemented** |
| invalid internal state | deterministic fault transition preferred | error log only | **diagnostic only in shown source** |

## Adversarial checks

### “The component has an `abort` pin, therefore it supports abort.”

Rejected. The pin is declared but never consumed in the realtime function. Interface presence is not executed behavior.

### “Interlock is wired, so interlock loss aborts a bend.”

Rejected for this component. The source checks interlock only in idle state 0. External electrical/safety behavior may still exist, but it is not proven by this code.

### “No timeout is needed because PID following error covers a stuck ram.”

Rejected as a generic claim. Following error and process timeout answer different questions. A process input/pressure event can fail to occur while position control itself remains healthy; conversely ferror can trip before a long semantic process timeout. Detector ownership must remain distinct.

### “Pressure state 9 proves the machine is safely protected from overload.”

Rejected. It proves only an ordinary software response in the inspected component. Sensor architecture, failure coverage, output safe state and functional-safety requirements are outside this evidence.

## Architecture lesson

The Accurpress evolution is now more specific than “custom components can work.” Its 2022 source shows a mixed maturity profile:

- physical feedback and realtime scheduling improved materially;
- pressure-limit escape became executable;
- operator pedal semantics are explicit;
- but the declared generic abort is unused, active-cycle interlock loss has no software transition, and generic process timeout remains absent.

This supports the 4600 rule that every press-cycle state should be reviewed as a **state + success condition + operator interruption + fault interruption + timeout + diagnostic reason**, rather than assuming a single global enable or pin description covers all paths.

## Precise next checkpoint

1. Trace whether the machine HAL surrounding this component provides an **external ordinary-control or hardwired removal path** for interlock/estop/drive enable, while keeping functional-safety claims separate unless the public evidence actually establishes them.
2. Build a state-by-state press-cycle transition template for future 4600 implementations: entry preconditions, success transition, pedal behavior, process timeout, motion/SYNC fault input, hydraulic fault input, machine-disable behavior, recovery permission and diagnostic reason.
3. Do not invent timeout durations or safety reaction times from this single-ram example.
4. Keep the M66 supervisory wait outside this fast process/fault path; run079 already shows both its non-realtime nature and a pinned Task stale-state defect after timeout.
