# 4400 — LinuxCNC feed-inhibit versus jogging: documented version drift, not a safety function
**2026-10-24 | DOC-CONFIRMED versioned documentation; SOURCE-CONFIRMED pinned new-jog command-gating divergence; TEST NOT RUN**

## Question
Would a LinuxCNC feed-inhibit HAL pin reliably stop all jog motion during guard-open setup? The official manual pages **disagree across version surfaces**. Neither interpretation creates a personnel-safety function.

## Original official documentation inspected
- LinuxCNC **2.7 motion(9)**: https://www.linuxcnc.org/docs/2.7/html/man/man9/motion.9.html , section PINS, motion.feed-inhibit.
- LinuxCNC **current documentation motion(9)**: https://linuxcnc.org/docs/html/man/man9/motion.9.html , section MOTION PINS, motion.feed-hold/feed-inhibit/jog-inhibit/jog-stop.
- LinuxCNC **HALUI current manual**: https://linuxcnc.org/docs/html/man/man1/halui.1.html , jogging and feed-override inputs.
- These are **published docs**, not source inspected at a pinned LinuxCNC commit. The unversioned documentation endpoint is moving; its exact source commit and behavior remain unverified.

## Side-by-side evidence
| Surface | What the manual explicitly says | Claim class |
|---|---|---|
| LinuxCNC 2.7 motion.feed-inhibit | Inhibits jogs as well as programmed feed/rapid; spindle-synchronized move can finish first | DOC-CONFIRMED, 2.7 documentation only |
| Current motion.feed-inhibit | Applies to G-code commands, **not jogs**; spindle-synchronized move can finish first | DOC-CONFIRMED, current manual only |
| Current motion.feed-hold | Applies to G-code commands, **not jogs** | DOC-CONFIRMED |
| Current motion.jog-inhibit | Inhibits initiation of joint/axis jogging | DOC-CONFIRMED |
| Current motion.jog-stop | Requests stop of active jog following configured acceleration | DOC-CONFIRMED |
| Current motion.jog-stop-immediate | Requests immediate stop of active jog | DOC-CONFIRMED; physical stop distance NOT established |
| HALUI jog pins | Provide ordinary joint/axis jog requests and speed scaling | DOC-CONFIRMED |
| Whether behavior changed at a specific LinuxCNC commit | **SOURCE-CONFIRMED** for two pinned command acceptance paths; exact first-changing commit UNKNOWN | TEST NOT RUN |

## Why this matters
An integrator copying a 2.7 HAL example into a current LinuxCNC build could incorrectly assume feed-inhibit also suppresses a jog pendant. The discrepancy could be a real behavior change, documentation correction or other version-dependent condition. **Do not silently choose one explanation.** Check the installed LinuxCNC revision and trace/test the actual behavior **without exposure**.

Even if the pin does inhibit every motion request in a specific build, HAL commands, feed overrides, E-stop UI flags and jog-speed sliders are ordinary control paths. They cannot replace independent safety-rated speed/stop/holding/guard functions or energy isolation. A command-level immediate stop is not proof that a high-inertia spindle or gravity ram has physically stopped.

## Bounded source-tracing task (frozen, not run)
At the actual selected LinuxCNC commit, inspect motmod motion command processing, HAL pin declaration, jog planner paths and state transitions for feed-inhibit, jog-inhibit and jog-stop. Compare a pinned 2.7 tag to the selected current revision. A question-driven **local-only** nonhazardous simulated fixture could then predeclare: G-code running, continuous jog active, and spindle-synchronized move; observe exact state and pin behavior with no personnel in any hazard. Do not run merely because compute is available. No current installed version, harness or authoritative runtime exists here, so no lab is justified.

## Practical design
The safety controller owns the mode/guard/enabling/overspeed response and independent final elements; LinuxCNC receives permission to issue ordinary jog commands **only as an additional convenience layer**. Mode exit and fault remove permission regardless of stale LinuxCNC command state. No safe speed, physical stopping, gravity holding, PL/SIL, pressure or stop time is asserted.


## Pinned source trace (read-only, no runtime)
**LinuxCNC v2.7.15:** src/emc/motion/control.c lines 397–427 computes net_feed_scale, forcing zero when feed_inhibit is asserted subject to enables mask. src/emc/motion/command.c lines 655–695 in EMCMOT_JOG_CONT rejects a new jog when net_feed_scale < 0.0001; lines 722–754 similarly gate EMCMOT_JOG_INCR. See [v2.7.15 command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.7.15/src/emc/motion/command.c#L655-L695) and [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.7.15/src/emc/motion/control.c#L397-L427). **SOURCE-CONFIRMED** for these command acceptance paths; not proof that an already moving axis physically stops.

**LinuxCNC master pinned commit 062dc7c097693bb68e76192516cd92878dd5ecdf (retrieved 2026-10-24):** src/emc/motion/control.c lines 428–490 still computes net_feed_scale and zeroes it on feed_inhibit; src/emc/motion/command.c lines 837–858 handles EMCMOT_JOG_CONT by checking motion enable and **separate jog_inhibit HAL pin**, with no net_feed_scale gate at that location; EMCMOT_JOG_INCR lines 908–920 likewise checks jog_inhibit. src/emc/motion/motion.c lines 526–529 registers feed_hold, feed_inhibit and jog_inhibit separately. See [pinned command.c](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/command.c#L837-L858), [control.c](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/control.c#L428-L490), and [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/motion.c#L524-L529).

**Call flow:** motion.c HAL pin registration -> control.c periodic feed-scale calculation -> command.c jog command acceptance -> free trajectory planner. v2.7.15 gates new JOG_CONT/JOG_INCR on net_feed_scale; pinned master gates on jog_inhibit. **SOURCE-CONFIRMED** command-gating divergence. Exact first-changing commit, all jog entry paths, already-active jog behavior and runtime remain unverified. This retires the vague hypothesis that only manual wording changed, but does not establish any safety-rated stop. No new compute justified.


### Additional source discriminator: joint wheel jog is not the keyboard-jog path
In the **same pinned master** src/emc/motion/control.c lines **1125–1185**, the joint jogwheel path reads jjog_counts, checks free/teleop state and jjog_enable, then **checks emcmotStatus->net_feed_scale < 0.0001** before accepting a wheel-count delta. This is a separate path from command.c EMCMOT_JOG_CONT/INCR, which checks jog_inhibit. See [pinned wheel-jog code](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/control.c#L1125-L1185). The current manual's broad "feed-inhibit applies to G-code commands, not jogs" therefore **cannot be applied uncritically to every joint jog entry path**: the source contains a feed-scale guard on joint wheel jog. Whether feed_inhibit actually drives net_feed_scale to zero in every wheel-jog state depends on the enables mask and must not be asserted without tracing that state; neither existing jog motion nor physical stopping was tested. **SOURCE-CONFIRMED path distinction, UNKNOWN complete runtime behavior**. Do not conflate wheel jog, keyboard/halui jog, axis jog, or G-code feed.
