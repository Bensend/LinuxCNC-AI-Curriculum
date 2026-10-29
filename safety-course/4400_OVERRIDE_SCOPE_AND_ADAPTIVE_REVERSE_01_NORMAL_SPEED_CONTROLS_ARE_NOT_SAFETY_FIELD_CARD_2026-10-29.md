# 4400 technician card — two ways a normal speed control can mislead

**2026-10-29 | open-book field review, NOT A BLIND EXAM, NOT MACHINE AUTHORIZATION**

Read the [pinned M48/M49/M51 source-document discrepancy](../research/4400_OVERRIDE_SCOPE_01_LINUXCNC_2910_M48_M49_M51_DOLLAR_SELECTION_SOURCE_DOC_CONFLICT_2026-10-29.md) and [M52 negative adaptive-feed trajectory source audit](../research/4400_ADAPTIVE_REVERSE_01_LINUXCNC_2910_M52_NEGATIVE_FEED_DIRECTION_AND_HOLD_SCOPE_SOURCE_AUDIT_2026-10-29.md). Continue from the [existing M53 feed/jog lesson](4400_FEED_JOG_01_NORMAL_MOTION_HOLD_VS_INDEPENDENT_STOP_REVIEW_CARD_2026-10-27.md); this card adds **override selection and direction**, not another generic stop lesson.

## Review A — two-spindle lathe
A setup program contains `M49 $1`. The builder expects spindle 1's speed-override slider to be disabled while spindle 0's remains enabled. A second attempt uses `M51 P0 $0` to disable spindle 0's slider.

**Source-derived answer:** In inspected LinuxCNC v2.9.10, the standalone `$` on M49 is not an accepted dollar consumer; the interpreter's word-use check predicts rejection. M49 without `$` disables feed and **all** spindle speed overrides. M51 with `$0` is also rejected by its explicit `<=0` guard, while M51 without `$` applies to all spindles. Do not silently rewrite a rejected command or infer that a speed slider controls actual spindle RPM. These are **SOURCE-CONFIRMED static paths, NOT RUN**.

**Operator-interface improvement:** Show per-spindle *override enabled*, *requested RPM*, *measured RPM (with freshness)* and *independent safety speed permission* as different labels. An ordinary override may be unavailable, ignored, or enabled without proving a physically safe speed. A spindle with hazardous chuck/tool energy still needs guarding and independently derived protective functions.

## Review B — adaptive feed on a plasma or wire-EDM table
A process sensor is connected to `motion.adaptive-feed`. A technician assumes `-0.2` means 20% feed in the normal direction, or that `M49` disables all feed effects.

**Source-derived answer:** When M52 is active, a negative value is a **reverse trajectory request**, not a slower positive feed. The motion code requests zero adaptive scale until the planner can change direction; the planner's own `tpIsMoving` criterion is **not a safety-rated standstill witness**. M49/M50's ordinary feed-slider enable and M52's adaptive-feed enable are separate source paths. **M52 P0 is not itself an explicit FORWARD direction command**: it clears the adaptive-enable flag, while the planner has separate reverse-direction state and separate clear/abort reset paths. The resulting queue/motion sequence is untested; do not assume reverse persists or disappears in every context. Synchronized/rigid-tap reverse activation has its own planner rejection; do not assume every queued segment can reverse. This is a static path prediction, not a measured machine reversal.

**Safer-by-default ordinary design:** If reverse is not part of the process, constrain and validate the producer to nonnegative values, with explicit stale/fault behavior and independent process-stop handling. If reverse is intended, show the requested direction, current ordinary trajectory direction, and state freshness; do not label negative feed simply as slow. Never use this software state for personnel-protective access or a safety stop.

## Stop/hold authority worksheet (answer without operating a machine)
For either review, fill in separately:

| Proposition | Normal software can report/request | Evidence still required for personnel safety |
|---|---|---|
| A speed override is enabled/disabled | Interpreter setting, normal status/HMI | Does not prove physical spindle speed, safe speed, or access |
| Adaptive reverse is requested/active | HAL input and normal TP state | Independent protection against hazardous path/energy |
| Feed scale is zero | Normal motion planner/feed input | Physical standstill, gravity load restraint, process energy state |
| A protective device is satisfied | Independent safety-system status, when qualified | Actual coverage, final-element behavior, physical stop/hold and deliberate restart |
| Maintenance energy is isolated | Work order or normal control status cannot prove it | Qualified isolation, verification, trapped-energy discharge/restraint |

**No unsafe shortcut:** Do not test the sign change or spindle selector on an energized machine to confirm a desk hypothesis. If physical evidence is genuinely required, isolate the work, use a separately approved qualified test procedure and keep people outside the danger zone. For OpenPressBrake, actual Pilz/AKAS, Y1/Y2 stop and gravity holding, guard, isolation and rearm remain **UNKNOWN**. **G0/G1 HOLD; no personnel-exposed hazardous operation.**

**Evidence:** SOURCE-CONFIRMED interpreter and motion/TP branches; DOC-CONFIRMED pinned LinuxCNC manual; INFERENCE human-factors failure paths; TEST-CONFIRMED none; selected machine UNKNOWN. This card is unscored practice and cannot satisfy 2520–25F0 external evaluator gates.
