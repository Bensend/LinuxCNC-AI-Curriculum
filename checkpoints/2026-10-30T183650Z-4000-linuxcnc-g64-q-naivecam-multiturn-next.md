# 2026-10-30T18:36:50Z — LinuxCNC-first 4000 implementation checkpoint
**NON-GRADUATED source audit | owner priority supersedes prior safety-first queue | no compute**

## Recovered governance
START_HERE read first. MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind protocol/score and compute ledger read. 1000/2000/F02 and completed 3000 remain GRADUATED/CLOSED. The owner explicitly redirected this hourly curriculum to **LinuxCNC implementation/internals first**, with safety as a cross-cutting constraint rather than routine module queue. Earlier safety-first PROGRESS/checkpoints remain historical, not current priority. The latest prior active checkpoint was 2026-10-30T17:35:46Z USB pendant INPUT-04. No external blind result or authoritative lab runtime added.

## Work and evidence
- [Source-level G64 Q audit](../research/4400_LINUXCNC_G64_Q_NAIVECAM_MULTI_TURN_DXF_POST_SOURCE_AUDIT_2026-10-30.md): pinned stable v2.9.10 and 2026-10-30 development `master`; userspace canonical `chained_points`/Q simplification versus TP P tolerance; last-tag behavior; G0/feed/M62 flush boundaries; G17 arc shortcut drops multi-turn count magnitude. Upstream issue #222 reports 15-turn helix becoming a straight plunge; **not reproduced here**.
- [Practical CAD/CAM post handoff](../guides/4000-linuxcnc-g64-q-cam-post-validation-2026-10-30.md) distinguishes DXF geometry, nesting/CAM, interpreter/canonical, realtime/physical control and independent safety.
- Development-only `[RS274NGC] G64_DEFAULT_TOLERANCE` / `G64_DEFAULT_NAIVETOLERANCE` and `G64 R` compared against stable; do not assume portable defaults.
- [Shared DXF discovery](../research/shared-dxf-cad-cam-discovery-2026-09-14.md) linked to new source evidence. Predecessor [PATH-BLEND-01](../research/4400_PATH_BLEND_01_LINUXCNC_2910_G64_G0_CLEARANCE_AND_STOP_MODE_SOURCE_AUDIT_2026-10-28.md) preserved; no duplicate safety competency or 3000 reopening.

## Status and compute
SOURCE-CONFIRMED static paths, DOC-CONFIRMED upstream documentation, COMMUNITY-REPORTED issue #222; TEST-CONFIRMED **none**. No builds, simulation, workflows, physical tests or machine operation; **zero GitHub-hosted and zero self-hosted compute**. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Local runner dispatch and physical isolation UNKNOWN; no test justified merely to consume compute. OpenPressBrake G0/G1 HOLD; independent 2520–25F0 external evaluation OPEN; no personnel-exposed hazardous operation authorized. No new evaluator score or release claim.

## Precise next work
1. Select highest-value open **LinuxCNC internals** question, not routine safety expansion. First candidate: QtPlasmaC `M190` material-selection and `M3/M5`/THC process sequencing from current official docs, inspectable HAL/NGC/Python source and a real config; distinguish CAM post from LinuxCNC execution authority. Check 3300 closed evidence before claiming novelty.
2. Alternative: inspect an actual open-source DXF parser's LWPOLYLINE bulge/INSERT transform and compare against the shared geometry contract, with pinned revision and one bounded semantic question. No product build.
3. If a regression fixture for G64 multi-turn is newly justified, predeclare exact canonical observable and require proven physical isolation plus self-hosted `[self-hosted, openpressbrake]` access. Never use hosted Actions.
4. Preserve graduated 3000, safety-course evidence, independent physical/evaluator gates. Do not re-open them without new material evidence. Update PROGRESS and safe-append LESSON_LOG with actual UTC end/elapsed/overlap on completion; leave automation enabled.

## Same-session source-depth continuation — QtPlasmaC M190/M66
[Development-pinned M190/M66 material handoff audit](../research/4400_LINUXCNC_QTPLASMAC_M190_M66_MATERIAL_HANDOFF_SOURCE_AUDIT_2026-10-30.md) follows M190 Python `halcmd` transactions, QtVCP material-change callbacks, `motion.digital-in-03`, QtPlasmaC G-code filter and official M66 `#5399=-1` timeout contract. Source establishes silent in-try script failure handling and non-fail-closed M66 wait semantics, but not actual GUI callback timing or physical torch state. **Next priority** is a bounded source-only cross-version QtPlasmaC installed-config comparison, or a clearly justified isolated M190 failure-state fixture once runner isolation/access is proven. No runtime or release evidence. No compulsory CAM product build.
