# S04 — stale/frozen feedback adversarial exam and answer key

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

This exam tests reasoning from source and bounded evidence. It deliberately includes misleading premises and safety overclaims.

## Questions

### 1. Complete the representative failure chain

A normal active joint is moving. `joint.0.motor-pos-fb` becomes frozen while `joint.0.motor-pos-cmd` continues moving. Trace the source-level path from the frozen HAL input to externally visible disabled state. Name the major functions and the relevant HAL outputs.

### 2. Misleading premise: “unchanged means stale”

An operator observes that `joint.0.motor-pos-fb` has not changed for 500 servo cycles. The axis was commanded to remain stationary for the same interval. Does LinuxCNC following-error logic prove the feedback is stale? Explain exactly why or why not.

### 3. Threshold reasoning

Given `MIN_FERROR=0.010`, `FERROR=0.100`, joint velocity limit 1.0 unit/s, and current command velocity about 0.5 unit/s, describe the expected order of magnitude of the runtime following-error limit. Which observable should be treated as the actual oracle, and why should an experiment avoid relying only on rounded textual snapshots at the transition?

### 4. Failure-path reasoning

The following-error flag asserts. What does `check_for_faults()` do with that condition, and what later function removes active motion/joint enable? Why can a late asynchronous read of `joint.N.error` be weaker evidence than a realtime capture through the transition?

### 5. Special-case trap

Is `pos_fb = motor_pos_fb - corrections` universally true for every servo cycle? Name at least one source-level exception relevant to the S04 teaching and explain why it prevents over-generalizing the ordinary following-error model.

### 6. Version-sensitive reasoning

A later LinuxCNC revision changes the internal ordering of following-error evaluation but leaves the public documentation mostly unchanged. Which S04 claims can be carried forward directly, and which must be re-traced or re-tested before making revision-specific statements?

### 7. Debugging scenario

A closed-loop machine immediately develops large following error after enabling. The drive appears mechanically stationary. Give a bounded diagnostic sequence using LinuxCNC observables that can distinguish at least: command/feedback scaling mismatch, wrong servo-thread placement/delay, and genuinely frozen feedback. Do not assume that one symptom uniquely identifies the cause.

### 8. Bounded modification task

Design ordinary LinuxCNC diagnostic logic that improves observability of a potentially frozen encoder while an axis is expected to move. State the signals/conditions you would compare and the false-positive/false-negative limitations. Do not claim a safety rating.

### 9. Safety adversarial scenario

A simulated experiment proves that a moving frozen-feedback condition eventually produces `f-errored=TRUE`, `joint.error=TRUE`, `motion.motion-enabled=FALSE`, and `amp-enable-out=FALSE`. Can the integrator conclude that a real machine has achieved safe torque off or a validated emergency stop? What evidence is still missing?

### 10. Fresh-AI novel scenario

Two independent position channels A and B agree exactly and remain constant while the controller commands zero velocity. A separate heartbeat from channel B is still incrementing, while A has no freshness metadata. Rank what can and cannot be inferred about A and B, and identify which downstream curriculum module should own disagreement/redundancy logic.

## Answer key / grading rationale

### 1

Expected chain: `process_inputs()` samples `joint.N.motor-pos-fb`, derives `pos_fb`, calculates `ferror = pos_cmd - pos_fb`, derives the velocity-dependent `ferror_limit`, and sets the joint following-error flag when `abs(ferror) > ferror_limit`. `check_for_faults()` reports the joint following error, sets joint error, and clears internal enabling intent. `set_operating_mode()` removes joint/motion enable. `output_to_hal()` publishes at least `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

A strong answer distinguishes the ordinary active-joint case from special homing/extra-joint cases.

### 2

No. If command and feedback are equal and stationary, command-versus-feedback error can remain near zero indefinitely. Following error has no generic sample-age information. An unchanged value can represent either a truly stationary encoder or a frozen encoder; independent freshness/process evidence is needed to distinguish them.

This is a central S04 competency and a required adversarial control in S04-014.

### 3

At about half of velocity limit, the proportional tolerance is expected around half of `FERROR`, approximately 0.05 units, subject to the `MIN_FERROR` floor and exact runtime implementation. `joint.N.f-error-lim` is the runtime oracle. For strict crossing, a realtime predicate is stronger than rounded decimal text because both `f-error` and the limit may print as the same rounded value in the critical cycle while their internal binary values satisfy a strict inequality.

### 4

`check_for_faults()` converts the ferror flag into joint error and clears enabling intent. `set_operating_mode()` performs the disabling transition. Some state flags can be transient across servo cycles or subsequently transformed by state handling; a high-rate/realtime trace can establish temporal ordering that a late `halcmd getp` snapshot cannot.

### 5

No. During the homing index-search transition, the feedback handling can deliberately substitute command position around index capture. Homed extra joints also force following error to zero. Either example is sufficient if accurately bounded.

### 6

High-level documented semantics may remain a useful lead, but source-specific call order, exact flags, branches, and timing are revision-sensitive and must be re-traced. Any experiment result is revision-specific unless reproduced or shown applicable. Do not silently transfer pinned-source conclusions merely because public pin names remain unchanged.

### 7

A good sequence observes `joint.N.motor-pos-cmd`, `joint.N.motor-pos-fb`, `joint.N.f-error`, `joint.N.f-error-lim`, enable/error pins, and thread ordering/high-rate traces. Scaling mismatch usually produces a systematic magnitude/unit relationship. Wrong execution placement can produce a consistent cycle delay or stale publication relative to command. A frozen feedback channel remains numerically unchanged while command changes. The answer must keep these as hypotheses until evidence discriminates them.

### 8

Acceptable ordinary diagnostic patterns include: only when meaningful command velocity/motion is expected, require feedback to change by a bounded amount or require independent device heartbeat/timestamp progress; cross-check redundant sensors; latch/report disagreement after a time/velocity-dependent tolerance. The answer must discuss deadband/quantization, backlash/compliance, genuinely stalled mechanics, low-speed movement, communication staleness, and the fact that software diagnostic logic is not automatically safety-rated.

### 9

No. Those observations establish LinuxCNC software/control-state behavior only. They do not prove physical torque removal, STO wiring/function, contactor behavior, stopping time/distance, sensor diagnostic coverage, architecture category, PL/SIL, or validation of the complete safety function.

### 10

The incrementing heartbeat is positive evidence that B's freshness channel is active, subject to understanding how that heartbeat is generated and transported. Exact numerical agreement alone does not establish A freshness because A could be frozen at the same true stationary value. Neither proves safety-rated diagnostic coverage. Cross-channel disagreement/redundancy logic belongs primarily to **S05 — disagreement/redundancy monitoring patterns**, with fault injection methodology continuing into S06.

## Graduation use

A fresh AI passes S04 only if it can reason through the stationary-frozen ambiguity and rejects the safety overclaim without merely repeating that “following error catches frozen encoders.” The distinguishing competency is understanding **when mismatch is observable, when freshness is unidentifiable, and what extra evidence changes that conclusion**.
