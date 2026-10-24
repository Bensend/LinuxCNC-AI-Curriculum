# 4400 — LinuxCNC feed-inhibit versus jogging: documented version drift, not a safety function
**2026-10-24 | DOC-CONFIRMED conflicting versioned documentation; SOURCE/TEST NOT CONFIRMED**

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
| Whether behavior changed at a specific LinuxCNC commit | **UNKNOWN**; no source diff or executable experiment this session | NOT SOURCE/TEST CONFIRMED |

## Why this matters
An integrator copying a 2.7 HAL example into a current LinuxCNC build could incorrectly assume feed-inhibit also suppresses a jog pendant. The discrepancy could be a real behavior change, documentation correction or other version-dependent condition. **Do not silently choose one explanation.** Check the installed LinuxCNC revision and trace/test the actual behavior **without exposure**.

Even if the pin does inhibit every motion request in a specific build, HAL commands, feed overrides, E-stop UI flags and jog-speed sliders are ordinary control paths. They cannot replace independent safety-rated speed/stop/holding/guard functions or energy isolation. A command-level immediate stop is not proof that a high-inertia spindle or gravity ram has physically stopped.

## Bounded source-tracing task (frozen, not run)
At the actual selected LinuxCNC commit, inspect motmod motion command processing, HAL pin declaration, jog planner paths and state transitions for feed-inhibit, jog-inhibit and jog-stop. Compare a pinned 2.7 tag to the selected current revision. A question-driven **local-only** nonhazardous simulated fixture could then predeclare: G-code running, continuous jog active, and spindle-synchronized move; observe exact state and pin behavior with no personnel in any hazard. Do not run merely because compute is available. No current installed version, harness or authoritative runtime exists here, so no lab is justified.

## Practical design
The safety controller owns the mode/guard/enabling/overspeed response and independent final elements; LinuxCNC receives permission to issue ordinary jog commands **only as an additional convenience layer**. Mode exit and fault remove permission regardless of stale LinuxCNC command state. No safe speed, physical stopping, gravity holding, PL/SIL, pressure or stop time is asserted.
