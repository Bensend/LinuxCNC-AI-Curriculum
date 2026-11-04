# MOTION-215 — Stable/development following-error parity and actual Mesa feedback topology

**Status:** 4000 NON-GRADUATED; SOURCE-CONFIRMED at two pinned revisions, no runtime or machine verification. **Scope:** distinguish an algorithmic change from a HAL API change; establish the source of the feedback entering motion.

## Decision and provenance

Compared [LinuxCNC v2.9.10 control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c) lines 447–487 with [development control.c at cdf957bd](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/emc/motion/control.c) lines 521–561. The relevant source excerpts were fetched directly from both pinned GitHub raw URLs in this session. Stable reads `*(joint_data->motor_pos_fb)`; development reads `hal_get_real(joint_data->motor_pos_fb)`. That is an **access API change**, not evidence of an added freshness check.

Both versions execute the same ordered logic: (1) copy motor feedback from HAL, (2) during index-search-wait when index-enable has dropped, substitute commanded position; otherwise subtract backlash filter and motor offset, (3) zero following error for homed extra joints or subtract feedback from command, (4) maintain the absolute high-water mark, (5) calculate `max_ferror * abs(vel_cmd) / vel_limit` when `vel_limit>0`, otherwise zero, (6) clamp to `min_ferror`, and (7) flag strictly when `abs(ferror)>ferror_limit`. Neither inspected block reads a timestamp, sequence number, packet-success status, or freshness pin. This is **parity for the inspected calculation only**; it is not proof of complete runtime/transport equivalence between releases.

## Concrete Mesa feedback provenance

Previously pinned [development 7i96S INI](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/7i96s.ini) and [HAL](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/hm2-servo-eth.hal), recorded with blob IDs in [MOTION-196](4400_LINUXCNC_MOTION_196_UPSTREAM_ENCODER_SERVO_HAL_INI_2026-11-03.md), configure three encoders, three PWM generators, **zero step generators**. X encoder.00.position connects to both joint.0.motor-pos-fb and pid.0.feedback; joint.0.motor-pos-cmd goes to pid.0.command; pid output goes to PWM value. Servo thread calls `hm2.read`, motion command handler, motion controller, PID, then `hm2.write`. In this example, ferror compares a command to **encoder-derived** feedback (with the motion compensation described above), not a stepgen accumulator. Y and Z use corresponding encoder channels. This proves *HAL signal provenance*, not physical encoder accuracy or timely arrival.

Contrast: [MOTION-195](4400_LINUXCNC_MOTION_195_MR1_MESA_TANDEM_FEEDBACK_AND_ORDER_2026-11-03.md) records a tandem stepgen-feedback topology, where the reported feedback is generated-step position, not independent axis motion. **The exact same ferror calculation therefore has different observability depending on HAL wiring.** Do not label `joint.N.motor-pos-fb` intrinsically independent, and do not infer stale packets from a small ferror.

## Reproducible disconnected inspection exercise

1. Fetch the two pinned control.c files above. Locate the blocks beginning at stable line 447 and development line 521. Compare each assignment and branch; classify the `hal_get_real` substitution separately from arithmetic.
2. From the pinned 7i96S HAL/INI, follow `[HAL] HALFILE`, `num_encoders=3 num_pwmgens=3 num_stepgens=0`, `hm2_7i96s.0.encoder.00.position`, `joint.0.motor-pos-fb`, `pid.0.feedback`, and `pid.0.output`. Verify that `hm2.read` precedes motion/PID and `hm2.write` follows.
3. Evaluate a purely analytical example: `vel_limit=10, vel_cmd=2, max_ferror=1, min_ferror=.01`, hence limit `.2`. For command 5.200 and adjusted feedback 5.000, equality does not flag; for command 5.201 it does. Repeat with a held 5.000 command and 5.000 feedback: no ferror even if an upstream read is absent.
4. Compare with the stepgen-feedback HAL topology in MOTION-195. Identify which faults each source can and cannot observe. No hardware motion is authorized by this exercise.

**Expected review outcomes:** identical inspected ferror mathematics across pinned versions; changed HAL accessor; encoder-vs-stepgen provenance distinguishable in the configs; no measured network-latency, watchdog, physical following-error, or safety conclusion.

## Evidence and dependency ledger

| Statement | Evidence class | Scope / caveat |
|---|---|---|
| Stable/development ferror calculation parity | SOURCE-CONFIRMED | Inspected control.c blocks only; broader behavior not compared |
| `hal_get_real` replaces direct pointer dereference | SOURCE-CONFIRMED | Accessor change; not proof of freshness semantics |
| Upstream 7i96S encoder to PID and joint feedback | CONFIG/SOURCE-CONFIRMED | Pinned dev sample, not physical test |
| Encoder feedback is guaranteed current each servo cycle | UNKNOWN | Requires transport-success/freshness observation |
| Generated-step feedback measures actual motor movement | FALSE as a general claim | FPGA accumulator is not external position sensor |
| Stale-read effect on physical machine | UNTESTED conditional | MOTION-213 source path, no cross-version runtime |
| Independent personnel safety | PRESERVED external authority | No change to physical gates |

Historical lab evidence must be checked by mechanism before new experiments. No tests, builds, compute, GitHub Actions or machine operations were performed. Graduated levels and blind evaluator separation remain unchanged.

## Next question

The calculation is now source-parity checked and the sample HAL feedback provenance was already established by MOTION-196. **Information-gain stop for repeating Mesa feedback examples.** Rotate to a new LinuxCNC realtime diagnostic mechanism: inspect `motion.servo.last-period`, `motion.servo.overruns` (if actually present at a pinned revision), and `hal_thread_t` scheduling statistics in pinned source/configs; establish exactly what a servo deadline miss means and does *not* mean for feedback freshness. Alternatively, inspect EtherCAT PDO validity and working-counter propagation with a pinned actual lcec implementation. Do not invent pin names; verify them in source before writing the next lesson.
