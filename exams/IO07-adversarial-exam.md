# IO07 — adversarial exam: hardware enable and fault patterns

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

This exam tests whether a fresh AI can reason across motion, HAL, HostMot2/output interfaces, drive faults, and the external safety boundary without inventing equivalence between them.

## Questions

1. **Call-chain trace.** Starting with a TRUE `joint.0.amp-fault-in` sampled while joint 0 is active and enabled, trace the pinned source path to the published FALSE `joint.0.amp-enable-out`. Name the significant functions/state transitions and identify the execution context.

2. **Misleading premise.** An operator observes `joint.0.amp-enable-out = FALSE` and says, “That proves the motor has no torque, so the E-stop is safe.” Explain precisely why the premise is invalid and list the additional boundaries that must be established before making a physical or functional-safety claim.

3. **Failure-path contrast.** An Ethernet HostMot2 board stops returning fresh input data and LLIO `io_error` becomes asserted. Must motion automatically see `joint.0.amp-fault-in = TRUE` in the next servo period? Explain from the module boundaries and give a safer debugging interpretation of an unchanged amp-fault HAL value.

4. **Same-cycle reasoning.** In the pinned `emcmotController()` ordering, why can a cleanly sampled amplifier fault cause motion/joint enable state to be published disabled in the same controller invocation? What observation-latency caveat remains for another HAL function or a userspace observer?

5. **Fault clear versus error recovery.** The external amplifier-fault source goes FALSE after the controller has disabled. Is it sound to assume the controller immediately re-enables the joint? Distinguish the sampled JOINT_FAULT state from latched/error/enable state and describe what should be observed rather than assumed.

6. **Downstream interface comparison.** Give one example each of how `joint.N.amp-enable-out` might ultimately control (a) a generic HostMot2/PWM-style output and (b) a Smart-Serial analog/servo interface. Explain why neither downstream command path by itself establishes STO.

7. **Version-sensitive question.** You find a historical forum post claiming a particular amp-fault recovery sequence. What evidence is required before applying it to this curriculum's pinned revision, and how should a real behavior difference be recorded?

8. **Bounded modification task.** You are asked to make a simulation stop motion when a synthetic drive alarm is asserted. Sketch a HAL arrangement with a single writer to `joint.0.amp-fault-in` that is suitable for a reproducible test. Include what baseline and post-injection assertions are required to distinguish a valid experiment from a false positive.

9. **Adversarial diagnostic scenario.** `joint.0.amp-fault-in = FALSE`, `joint.0.amp-enable-out = FALSE`, and the drive is physically still energized. Give a layered diagnostic sequence that avoids assuming either a LinuxCNC bug or a safe physical state.

10. **Safety boundary.** State the strongest conclusion the planned IO07 headless simulation may legitimately support if it passes every gate. Then state at least four conclusions it may not support.

## Passing standard

A passing answer must preserve all of these distinctions:

- motion/joint enable intent versus physical drive state;
- amplifier fault input versus HostMot2 transport/watchdog state;
- current sampled fault versus error/recovery state;
- HAL/output-module commands versus external STO/safety functions;
- source/simulation evidence versus physical timing/electrical/safety evidence.

Any answer equating a HAL bit, HostMot2 watchdog, software E-stop state, or ordinary drive-enable command with certified torque removal fails the safety portion regardless of the remaining score.
