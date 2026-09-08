# BL-DEV-002 learner precommit — motion following-error threshold

Status: **IMMUTABLE PRECOMMIT — oracle not yet inspected**

Date UTC: `2026-09-08`

Pinned LinuxCNC revision for later oracle inspection: `8bf4605ae81042248add031e94c77300406e0413`

Bank: development

Target competency: 1000-level motion/following-error reasoning and confidence calibration.

## Challenge packet visible to learner

Assume a linear joint is configured with:

- `FERROR = 1.0 in`
- `MIN_FERROR = 0.01 in`
- configured joint maximum velocity = `4.0 in/s`

During enabled motion, the commanded joint velocity magnitude is `2.0 in/s` and the instantaneous absolute command-versus-feedback position error is `0.30 in`.

Without inspecting the pinned implementation or an answer key first, predict whether LinuxCNC's ordinary joint following-error check should trip at that instant. State the mechanism you believe computes the active threshold, the approximate threshold, a direct source/diagnostic path to verify it, alternatives that could falsify the prediction, and the safety boundary.

## Learner response

### Prediction / diagnosis

**Prediction: no following-error trip at that instant**, assuming the 1000-level teaching retained in the curriculum is correct and the check is in its ordinary enabled-motion path.

### Mechanism

My recollection is that LinuxCNC does not use `MIN_FERROR` as a fixed threshold during all motion. It forms a velocity-dependent allowed following error between the configured minimum and maximum (`FERROR`) values. The intended rule is approximately linear with commanded velocity magnitude relative to configured maximum velocity, bounded by the configured maximum following error.

For `|v_cmd| = 2.0` and `v_max = 4.0`, the velocity fraction is `0.5`. If the interpolation is

`limit = MIN_FERROR + fraction * (FERROR - MIN_FERROR)`,

then the active limit is approximately

`0.01 + 0.5 * (1.0 - 0.01) = 0.505 in`.

The observed `0.30 in` error is below `0.505 in`, so I predict the ferror latch/check remains clear for this sample.

### Expected externally observable result

At this instant the joint should not newly fault solely because of the stated 0.30-inch following error. A lower commanded velocity with the same error could cross the velocity-dependent threshold and trip, while a higher velocity can permit a larger transient error up to the configured `FERROR` ceiling.

### Direct verification path

After this precommit is immutable, inspect the pinned motion source that computes each joint's following-error limit and compares command versus feedback. Verify:

1. which velocity quantity is used;
2. the exact interpolation/clamping formula;
3. whether the stated configuration fields map directly to the source variables assumed above;
4. any enable/free-mode/homing branches that bypass or modify the check.

An executable HAL/motion fixture would be a secondary oracle if source semantics are ambiguous.

### Plausible alternatives / falsifiers

This prediction is falsified if pinned source instead:

- applies `MIN_FERROR` as a fixed threshold at all velocities;
- compares 0.30 directly against `FERROR` without interpolation;
- uses a different velocity normalization that makes the active threshold below 0.30;
- or bypasses the expected interpolation in the relevant motion state.

### Safety / uncertainty boundary

Ordinary LinuxCNC following-error detection is machine-control fault handling, not evidence of a safety-rated position-monitoring function. Passing the software threshold does not prove the physical mechanism is safe or correctly positioned.

### Confidence

`88%`

### Solve time

`0.8 min`

### Resources consulted before precommit

- learner-readable curriculum knowledge already accumulated through the graduated motion/capstone modules;
- `START_HERE.md`, mission/progress/evaluation protocol for process rules;
- **not** the pinned implementation for this challenge and **not** any answer key/resolution.
