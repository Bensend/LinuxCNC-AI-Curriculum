# 2026-10-28T19:38:09.919Z — 4400-G28-G30-01 persistent rapid-reference and waypoint hazard; physical/evaluator next

## Authority and current state
- This session began **2026-10-28T19:32:03.912Z UTC**, recorded before substantive work after START_HERE first; mandatory governance, progress, safety syllabus/index/research/design, blind evaluation and lab ledgers inspected. Began with G38-PROBE-EDGE-01; rotated at **2026-10-28T19:38:09.919Z** after source-level G38 information-gain stop, per WORK_SELECTION_POLICY. Initial main `ff183096046ebd0f91228504d0c33485f517748d`; G38 commits `d0dd4f51a91af9a249391c4ebd1c063fadf87d31`, `e4200992ecafbc3f0ede451765b2561a82256ba8`, `9eb4c18bb3388e01af022d669c55498abc89b24b`.
- 1000, 2000, F02 and completed 3000 CLOSED. Primary 4400 SAFETY COURSE. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. Independent 2520–25F0 evaluator OPEN/NOT RUN; no new qualified restricted selected-machine Stage A A–G evidence.

## New safety source work
1. [G28/G30 pinned source audit](../research/4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md) → [technician card](../safety-course/4400_G28_G30_01_PREDEFINED_POSITION_IS_NOT_A_SAFE_RETREAT_FIELD_CARD_2026-10-28.md). LinuxCNC v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`: `Interp::convert_home` performs normal rapid to active-coordinate waypoint, then rapid to stored persistent machine reference 516x/518x, selecting only specified axes or all axes if none. G28.1/G30.1 **store**, not home; source and official docs explicitly distinguish these. Tool-change G30 optional; Z-first not automatic.
2. **SOURCE-CONFIRMED** exact path, persistence and indexer-first source; **DOC-CONFIRMED** official G28/G30 and TOOL_CHANGE_AT_G30; **INFERENCE** conditional fixture collision/false-safe-home operator misconception; **UNKNOWN** installed machine, reference, guard, physical stop/hold and actual collision. **TEST-CONFIRMED none; COMMUNITY-REPORTED none used.**
3. Novelty checked against canonical index/research/progress/design: no G28/G30 source predecessor; G38 and POS-TRUST/ATC are adjacent but distinct. Updated CURRICULUM, PROGRESS, research plan, safety index and cumulative design **§11LB**. No new scored competency, exam bank or owner questionnaire; no controller-board routine work.
4. **GitHub-hosted compute 0 min, self-hosted compute 0 min.** No workflows, simulations, builds, synthesis, benchmarks, machine tests or evaluator. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.

## Precise next work
1. Qualified restricted Stage A A–G as-built OpenPressBrake Pilz/AKAS/K1/K2/EDM, Y1/Y2 independent hydraulic stop and gravity hold, guarding, energy isolation, deliberate restart and qualified physical witness. Do not infer actual G28/G30 or G38 use on OpenPressBrake.
2. Information-separated 2520–25F0 evaluator with precommitment; public 25E0 challenge contamination warning. Never self-score.
3. If both gates unchanged, choose another genuinely nonduplicate 4400 safety mechanism from canonical index/research/progress/design. No speculative physical facts or generic lab merely for activity.
4. Immediately before ending, safely append **complete** LESSON_LOG from verified SHA, UTC end, elapsed minutes and overlap relative to previous curriculum end `2026-10-28T18:48:52.128Z` (other automations UNKNOWN). Commit and independently verify. Keep recurring curriculum enabled.


## Same-session M6 source follow-through
Direct tagged `Interp::convert_tool_change` L5565–5659 distinguishes optional ordinary spindle-stop command, optional Z-first quill-up, optional **direct** G30 reference traverse, then CHANGE_TOOL. **M6's direct G30 move is not G30 command's two-leg waypoint path**; corrected source-scope in audit and field card. No installed machine or physical stop/hold claims. The branch is source-sufficient; avoid a generic simulation.


## Cross-boundary adversarial review completion
Published [PROBE-RETREAT-COMPOSE-01](../safety-course/4400_PROBE_RETREAT_COMPOSE_01_FALSE_TOUCH_OFFSET_WAYPOINT_FAILURE_CHAIN_2026-10-28.md) as a non-graded documentary integration: source-confirmed G38.3 already-HIGH status and actual simulated G10 L20 consumer, hypothetical later G28 offset-sensitive first rapid. Explicit variants exclude M6 direct G30 and distinguish G28 no-axis behavior; no soft-limit bypass or observed collision claimed. This closes a coherent failure-path review without new lab or evaluator. Continue only for real new evidence; otherwise log and checkpoint.


## Homing-prerequisite source scope
Tagged Task `all_homed`, MDI/Auto checks and `NO_FORCE_HOMING` INI parsing inspected. Default MDI/Auto homed gate is real ordinary control; config can bypass it. G28/G30 do not themselves establish physical home. Cross-referenced existing POS-TRUST source lesson; no duplicate graded competency, no selected machine evidence.


## G53 inspectability alternative
Source checked tagged `Interp::find_ends` G53 branch and official G53 nonmodal machine-coordinate docs. A separately ordered, qualified machine-specific G53 normal retreat is easier to inspect than hidden mutable G28/G30 references, but is not collision-proof or independent safety; a combined G53 rapid is not Z-first. Integrated into G28 audit/card and cross-boundary review. No test, coordinates or machine claims.


## Same-session local-compute workflow guard
[Workflow trigger audit](../research/4400_LOCAL_COMPUTE_RUNNER_TRIGGER_GUARD_AUDIT_2026-10-28.md) directly identified two **legacy hosted** paths: `lab-runner.yml` (`ubuntu-latest`, manual + push on lab-jobs/workflow YAML) and `append-lab-compute.yml` (`ubuntu-latest`, push on append-request file). No trigger paths touched or jobs dispatched. `append-lesson-log.yml` and `pb-dxf-001.yml` use self-hosted label, but runner access UNKNOWN. Added WORK_SELECTION_POLICY guard against hosted dispatch/fallback; do not run a lab merely to check access. No LAB_COMPUTE_LOG change.


**Actions runtime cross-check:** latest ten workflow runs returned by repository API as of 2026-10-28T19:43Z were historical; newest created 2026-10-23T07:49:58Z. No current-session run appeared. No hosted/self-hosted compute used; no LAB_COMPUTE_LOG row.


## Reference-save source precision
Inspected tagged `Interp::convert_savehome`: G28.1/G30.1 persist coordinates calculated from interpreter `current_*` and offsets, with no independent physical sensor in that function. No universal claim that normal current position is wrong; physical trust still requires separate evidence. Added to G28 audit/card and design, linked POS-TRUST predecessor.

## Final documentary QA and short-session continuation decision
- Two new non-graduated source mechanisms (G38 no-error prestate and G28/G30 persistent reference/waypoint), one cross-boundary composition review, and one local-compute trigger audit were committed to `main`; canonical curriculum, research, progress, learner index, cumulative design §§11LA–11LB and WORK_SELECTION_POLICY integrated. No independent evaluator, selected-machine physical witness, new owner questionnaire or graded case bank.
- Validated **24 relative Markdown link occurrences across eight new/checkpoint artifacts**, resolving **17 unique existing repository targets**, **zero missing** (split checks to stay within connector call limits). Upstream source paths/line ranges were directly inspected at LinuxCNC `v2.9.10` and a newer pinned snapshot where relevant. No runtime tests or hosted/local compute.
- **Short-session continuation:** after G38 source trace, inspected actual upstream G38.3/`#5070` consumers and offset propagation; rotated to G28/G30; traced M6 direct G30, Task `NO_FORCE_HOMING` gate, G53 alternative, G28.1/G30.1 interpreter-derived storage, and integrated G38→G10→G28 adversarial failure chain. Audited legacy hosted workflow triggers and newest Actions runs. Both source branches are now at a justified information-gain stop absent machine-specific evidence or independent evaluation; next session should select a different safety mechanism if gates remain unchanged, not pad these branches with tests.
- **Evidence labels:** SOURCE-CONFIRMED pinned code and workflow YAML; DOC-CONFIRMED official G-code/INI docs; INFERENCE conditional false offsets/fixture collision and safer normal path; UNKNOWN installed OpenPressBrake machine, selected safety architecture, physical stopping/holding, runner dispatch availability; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation.
