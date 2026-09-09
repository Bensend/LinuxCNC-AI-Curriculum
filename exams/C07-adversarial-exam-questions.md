# C07 — State-Machine Sequencing — 1000-level Adversarial Exam Questions

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **QUESTIONS FROZEN BEFORE AUTHORITATIVE C07-047 OUTPUT INSPECTION**.

This is an internal module adversarial exam, not a blind external-feedback-bank challenge. Answers and scoring must be committed separately after accepted experiment reconciliation. Do not alter these questions to fit C07-047 output.

## Q1 — Misleading premise: command means state
A controls engineer says: “Our HAL logic pulsed `halui.machine.on`, so the machine is ON. We can set the cycle-ready bit immediately after the pulse.” Evaluate the statement at the pinned revision. Trace enough of the request and returned-status paths to identify the earliest evidence that supports a logical `ON_CONFIRMED` state, and identify at least one source-grounded condition that can reject the request.

## Q2 — Failure path: blocked enable and stale authorization
A sequencer receives one operator start authorization while `motion.enable=false`. It emits one valid `halui.machine.on` edge, then `motion.enable` becomes true 500 ms later. The engineer proposes automatically advancing because “the original command is still the desired state.” Explain what HALUI does with the first request, what does *not* happen merely because `motion.enable` later becomes true, and what restart policy avoids converting stale precondition history into an implicit retry.

## Q3 — Active-state interruption
Assume Task/HALUI has reached machine ON and a higher-level sequencer has granted a non-safety-rated cycle permission. `motion.enable` then falls. Trace the important realtime and returned-status path far enough to explain how the higher-level sequencer should detect loss of achieved state. Should it key its transition primarily from the injected cause (`motion.enable`) or from achieved `halui.machine.is-on`, and why?

## Q4 — Abort / recovery state integrity
A fault path calls Task abort/off behavior during program execution. After the fault input is cleared, an engineer wants to reuse a pre-fault “start authorized” latch and continue the prior program/cycle automatically. Using the pinned Task abort behavior, identify what execution state is invalidated or resynchronized and explain why a fresh recovery authorization is an independent policy requirement rather than something proven by fault-input restoration.

## Q5 — Homing misconception / configuration sensitivity
A technician asserts: “E-stop always unhomes every joint, so after E-stop reset the state machine can simply home everything again; conversely, if LinuxCNC still says a joint is homed, its physical position is definitely valid.” Evaluate both halves. Include the `volatile_home` boundary and distinguish returned LinuxCNC homed state from independent physical-position truth.

## Q6 — Small bounded implementation task
Design a minimal generic HAL/custom-component state policy for machine ON and restart using these logical states: `WAIT_START`, `WAIT_ON_CONFIRM`, `ON_CONFIRMED`, `RECOVERY_REQUIRED`, `RECOVERY_WAIT_START`. Specify the exact events/observations that cause transitions, when the `halui.machine.on` request pulse is emitted, when cycle permission can be true, and how authorization is consumed. The design must have no hidden retry timer and must not infer success from its own output pin.

## Q7 — Version-sensitive reasoning
Current-master HALUI is observed to retain the same rising-edge helper pattern as the pinned revision. What may legitimately be inferred from that spot-check, and what still requires separate version-specific source or execution verification before claiming the entire C07 Task/Motion sequence is unchanged?

## Q8 — Safety boundary
A software-only test proves that a custom sequencer revokes cycle permission when LinuxCNC machine-ON status falls and requires a fresh authorization before recovering. Does this establish safe automatic restart of a hydraulic or servo machine? State what the test establishes and name the categories of physical/safety evidence that remain outside the fixture.

## Scoring plan

Score each question 0–2 for source/mechanism accuracy and required uncertainty/safety boundary. Maximum 16 points; normalize to 10.0. A 1000-level pass requires at least 14/16 and no zero on Q1, Q3, Q6, or Q8 because those questions exercise the central request/status, interruption, implementation, and safety competencies.
