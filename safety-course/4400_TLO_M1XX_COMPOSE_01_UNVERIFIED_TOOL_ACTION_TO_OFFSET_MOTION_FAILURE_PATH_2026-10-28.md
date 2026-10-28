# 4400-TLO-M1XX-COMPOSE-01 — Unverified custom M-code → ambiguous tool offset → normal motion
**2026-10-28 | Cross-machine adversarial engineering review | NOT A GRADED EXAM | NO TEST OR MACHINE CLAIM**

## Purpose and source basis
Connect two **distinct** exact-source mechanisms without inventing a physical accident. Read [M1xx process completion](../research/4400_M1XX_EXIT_01_LINUXCNC_2910_USER_MCODE_ZERO_EXIT_BACKGROUND_CHILD_AND_SAFETY_BOUNDARY_2026-10-28.md), [G43.2 axis-word modal-motion conflict](../research/4400_TLO_AXIS_01_LINUXCNC_2910_G432_AXIS_WORD_MODAL_MOTION_DOC_SOURCE_CONFLICT_2026-10-28.md), and [ATC physical retention](4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md). Pinned LinuxCNC v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`.

The **documented** M1xx example runs `halcmd setp` and unconditionally `exit 0`; the tagged HAL manual says `setp` fails for linked pins; Task treats zero process exit as DONE without checking actuator state. Separately, G43.2 axis words can inherit a previously active G0/G1 in the tagged interpreter despite official no-motion wording. Each source path is inspectable; the composed failure is **INFERENCE / NOT TEST-CONFIRMED**.

## Hypothetical sequence — all physical consequences UNKNOWN
| Stage | Normal-control observation | Fault hypothesis / discriminator | Independent safety requirement |
|---|---|---|---|
| 1. Tool/clamp action requested via M1xx | Task waits for external program | Which *actual registered executable* was selected from PROGRAM_PREFIX/USER_M_PATH? | Guard/physical restraint independent of shell |
| 2. HAL command attempted | Script may log success or error | If target pin linked, `setp` fails; unconditional `exit 0` can mask it | Physical clamp/tool retention must be verified separately |
| 3. Task sees child exit zero | M-code DONE | Task did **not** measure clamp force, pressure, mechanical capture or tool geometry | Do not grant access or motion permission from DONE |
| 4. Compensation requested with G43.2 axis words | Interpreter adds offset | Was G0/G1 modal? G90 or G91? cutter compensation off? valid feed? | Motion only after independently safe conditions; ordinary limits insufficient |
| 5. `convert_g` reaches motion | Potential traverse/feed command | Source predicts possible normal motion; exact runtime/canonical output **NOT RUN** | Independent protective stop/guard and energy-removal authority |
| 6. Abort or E-stop demanded | Task may signal direct M1xx PID | Background descendant and actuator physical state not proven by PID signal | Qualified independent stop, holding, isolation and fresh deliberate restart |

**No machine-specific assumption:** No installed M1xx, toolchanger, collet, Y1/Y2 valve, Pilz/AKAS configuration or press-brake operation is identified. An OpenPressBrake ram is not a CNC spindle/toolchanger; this is a transferable *authority-boundary* lesson only.

## Adversarial questions for a qualified design review (not a blind score)
- Could a command report DONE while the actuator is still moving, never moved, or is held only by hydraulic pressure? Which *independent* physical sensor/restraint closes that gap?
- Does a maintenance change link a previously unlinked HAL pin, change the first M1xx search-path match, alter the script's exit handling, or leave background work alive after the direct parent exits?
- Could a normal G-code offset line also request movement because of inherited modal motion? What versioned interpreter trace and isolated simulation would prove/disprove it without exposing personnel?
- Can a guard be replaced and reset easily without defeating it? Is the reset outside the hazard with sightline/occupancy assurance? Is a new cycle start deliberate rather than a consequence of status recovery?
- If an external script or controller crashes, what **physical** elements independently stop and hold the load? If unproved, mark **HOLD**, not “probably safe.”

## Practical design result
Use **four explicit states**: REQUESTED (command issued), OBSERVED (normal I/O/process feedback), SAFETY-PERMITTED (independently validated safety function), PHYSICALLY VERIFIED (qualified load/guard/energy evidence). Make tool/clamp verification and safe guard use part of the easiest normal workflow. Keep normal tool-offset editing separate from motion; do not rely on G43.2 axis syntax as nonmoving until the pinned isolated source/runtime conflict is resolved. Do not hide command errors with unconditional success exits.

**Evidence and disposition:** SOURCE-CONFIRMED individual LinuxCNC paths; DOC-CONFIRMED official examples and no-motion wording; INFERENCE composite; TEST-CONFIRMED none; COMMUNITY-REPORTED not used; UNKNOWN actual hardware, physical stopping and guarding. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** Independent 2520–25F0 evaluator OPEN. No workflow, lab, physical test, new exam bank, owner questionnaire or compute.
