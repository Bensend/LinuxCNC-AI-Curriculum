# 4400 safety continuation — ROPE-PULL-01 and ENV-01, OEM evidence to physical/evaluator handoff

**UTC start:** 2026-10-26T16:39:27Z, recorded from UTC system clock before substantive work and [durably committed](2026-10-26T163927Z-session-start-safety.md). **UTC end/elapsed:** capture immediately before ending and safely append `LESSON_LOG.md` with current complete blob SHA. **Overlap:** previous logged curriculum session ended 2026-10-26T15:50:14.265Z; start gap **49.21 minutes**, no known same-curriculum overlap; unrelated work not independently excluded.

## Governing state

Read `START_HERE.md` first; mission, `LEVEL_ORDER.md`, `WORK_SELECTION_POLICY.md`, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, `PROGRESS.md`, latest 15:38Z safety checkpoint, `SAFETY_COURSE_RESEARCH.md`, learner index/design package, `evaluation/BLIND_FEEDBACK_PROTOCOL.md`, `evaluation/FEEDBACK_SCORE_LOG.md`, `LAB_COMPUTE_LOG.md` and last `LESSON_LOG.md`. **1000, 2000, F02 and 3000 formally GRADUATED/CLOSED.** Primary active 4000/4400 safety course; external 2520–25F0 competency evaluation OPEN. No qualified private OpenPressBrake Stage A A–G evidence newly obtained. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**

## Six original durable engineering artifacts

1. [ROPE-PULL-01 original Rockwell Lifeline 5 February 2026 / Schneider XY2CE 2017 / narrow OSHA source audit](../research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md); later deepened with original OEM p. 10 standard diagnostic tags and p. 11 mixed OSSD/voltage-free-contact series.
2. [ROPE-PULL-01 practical 12 PUBLIC PAPER cases UNSCORED / 10 documentary gates NOT RUN](../safety-course/4400_ROPE_PULL_01_WHOLE_SPAN_ACCESS_TENSION_WARNING_AND_RESTART_FIELD_MODULE_2026-10-26.md).
3. [ROPE-PULL-01 independent unseen evaluator handoff PREPARED / NOT RUN](../evaluation/4400_ROPE_PULL_01_INDEPENDENT_UNSEEN_CABLE_COVERAGE_HANDOFF_2026-10-26.md).
4. [ENV-01 original nVent HOFFMAN / Rittal / Rockwell exact relay environmental source audit, later HSE/OSHA corroboration](../research/4400_ENV_01_NVENT_RITTAL_ROCKWELL_CONDENSATION_ENCLOSURE_SAFETY_BOUNDARY_AUDIT_2026-10-26.md).
5. [ENV-01 eight PUBLIC PAPER cases UNSCORED / eight documentary gates NOT RUN](../safety-course/4400_ENV_01_CONDENSATION_COOLANT_INGRESS_AND_SAFE_RETURN_FIELD_CARD_2026-10-26.md).
6. [Cross-branch common-cause physical-access → safety-input → final-element architecture review](../safety-course/4400_ROPE_ENV_COMMON_CAUSE_PHYSICAL_ACCESS_TO_SAFETY_CONTROLLER_ARCHITECTURE_REVIEW_2026-10-26.md).

**Six originals total, 20 public PAPER scenarios UNSCORED, 18 documentary gates NOT RUN, one independent evaluator handoff PREPARED/NOT RUN.** No hidden evaluator oracle inspected, no blind score, no self-scoring. All five initial original files independently re-fetched, five internal relative links across three distinct targets verified; sixth integration artifact and new index links should be rechecked before ending. `CURRICULUM.md`, `PROGRESS.md`, `SAFETY_COURSE_RESEARCH.md`, learner index and cumulative Safety Design Package updated through **§§11HQ–11HR**.

## Distinct substantive findings and provenance

**ROPE-PULL-01 (DOC-CONFIRMED exact OEM):** Rockwell 440E-IN008H Feb 2026 original pp. 5–6 (p. 5 screenshot inspected): green+amber flashing low/high tension warning **with safety outputs ON**; cable cut/slack or pulled outputs **OFF**. Exact spring, supports, pulleys, all-direction full-span proof, reset visibility and thermal behavior are product-specific. Schneider XY2CE original 2017 has different end-spring and guide rules, NC safety contacts vs NO indication, and separate machine start after local reset. Rockwell pp. 9–11 (original p. 10/11 screenshots inspected): 432ES `Data` and controller input tags are **standard/non-safety-rated**; disabled electronic keying for troubleshooting; exact OSSD-only series example up to PLe versus mixed voltage-free-contact example maximum PLd depending on installation. **No PL assigned to OpenPressBrake.** Narrow OSHA construction/power-generation/marine conveyor provisions not universal press-brake law.

**ENV-01 (DOC-CONFIRMED exact manufacturer/regulator):** nVent HOFFMAN original p. 9 explains rapid cabinet cooling creating suction at gaskets and internal condensation/corrosion even with high-IP construction; Rittal official dew-point heater function; Rockwell exact MSR126.1T IP40 housing, IP20 terminals and minimum IP54 mounting enclosure. HSE UK guidance (agricultural scope) confirms electrical control shorts can cause unexpected operation; OSHA 1910.303(b)(6) and 1910.305(e)(1) establish deteriorating-agent/moisture-control duties in applicable general-industry settings. **INFERENCE:** selected circuit may experience shared wet common-cause faults; actual failure polarity **UNKNOWN**. No claim that a wet safety relay always turns ON or OFF.

**Integration:** visible red cable or green sensor cannot prove whole-span reach; standard diagnostic tag cannot prove safety-rated input; enclosure IP/temperature sensor cannot prove dry terminals; OSSD OFF cannot prove physical stop/hold. Normal LinuxCNC/HAL/FPGA may request/diagnose but never own personnel-safety authority. Exact independent safety controller/final elements, physical Y1/Y2 gravity hold and pressure isolation remain to be validated.

**Evidence:** SOURCE-CONFIRMED new LinuxCNC none; DOC-CONFIRMED above; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on; INFERENCE architectural human factors/failure paths; UNKNOWN selected OpenPressBrake rope device, cabinet, wiring, physical stop/hold, PL/SIL, evaluator.

## Compute and safety state

**0 GitHub-hosted Actions minutes; 0 local [self-hosted, openpressbrake] minutes.** No workflows dispatched, simulations, builds, synthesis, benchmarks, electrical/physical tests or independent evaluations. The local runner access blocker was not retested because no concrete lab question required compute. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` intentionally unchanged without authoritative new runtime/score. No proprietary machine data published. **No personnel-exposed hazardous operation authorized.**

## Precise next work

1. **Primary:** obtain qualified private Stage A A–G selected-machine evidence for independent Y1/Y2 stopping, gravity load holding, hydraulic isolation/LOTO, point-of-operation and rear guarding, maintenance access/escape and deliberate fresh restart. Keep proprietary schematics and serials out of public repo. G0/G1 HOLD until independently established.
2. **Independent evaluator:** perform an unseen, information-separated 2520–25F0 or ROPE-PULL-01 competency case with immutable learner precommitment before revealing hidden oracle and scoring. Public paper cases remain UNSCORED. No self-graduation.
3. **Branch-local stop:** ROPE-PULL-01 needs actual selected device/cable and independent full-span/physical witness; ENV-01 needs actual cabinet/component/environment and fault analysis. Without those, further same-source scenarios have low information gain. Rotate to a **genuinely distinct high-value open 4400 safety module**, not historical 3000 work.
4. **Compute:** only a frozen unresolved question justified by sources may use bounded `[self-hosted, openpressbrake]` runner. Never use GitHub-hosted Actions minutes. If local dispatch unavailable, record blocker and continue documentation/source work.
5. **Session completion:** recheck original/link integrity and append UTC end/elapsed/overlap to complete `LESSON_LOG.md` via current blob SHA; commit before exit. Do not disable the recurring curriculum.

## Short-session continuation check

After ROPE-PULL-01 original OEM audit and field module, source-deepened the exact **standard tag vs safety channel** and **OSSD-only vs mixed-contact series** distinctions, then rotated to a distinct **cabinet condensation/thermal-cycle** manufacturer/regulatory study, then wrote a cross-branch common-cause review. No synthetic lab or repeated 3000 work was manufactured. Both branches now await selected-machine/evaluator evidence.


## Later same-session RIG-01 rotation — update to final scope

The curriculum index contained no whole-machine transport/tip-over/foundation branch (earlier WILA rigging concerned **tooling**). Continued with a **third distinct safety branch** rather than generating more 3000 or repeating rope/condensation scenarios:
- [Original TRUMPF TruBend 2100 OEM quick-start and scoped OSHA forklift/crane audit](../research/4400_RIG_01_TRUMPF_PRESS_BRAKE_DELIVERY_LIFT_FOUNDATION_OSHA_SCOPE_AUDIT_2026-10-26.md).
- [RIG-01 practical eight public PAPER scenarios UNSCORED and eight documentary gates NOT RUN](../safety-course/4400_RIG_01_PRESS_BRAKE_TRANSPORT_FOUNDATION_AND_PRECOMMISSIONING_FIELD_MODULE_2026-10-26.md).

**DOC-CONFIRMED exact model:** unusual center of gravity, top frame lifting eyelets/armored rollers, complete Installation Manual required; **16,534-lb mass and 8-in direct concrete specification only for TruBend 2100**, not OpenPressBrake. **INFERENCE:** stage-gated qualified transport/floor/utility/guarded precommissioning. **UNKNOWN:** actual machine mass/CG/lift points/anchors, independent Y1/Y2 gravity holding, stop and hydraulic isolation. No lift, rigging calculation, energized/physical test, external evaluation or compute. Cumulative package now **§§11HQ–11HS**. **Final combined count: eight original artifacts; 28 public PAPER scenarios UNSCORED, 26 documentary gates NOT RUN, one external evaluator handoff PREPARED/NOT RUN.** Next priority remains qualified private Stage A A–G and independent evaluation; without it, rotate to another genuinely open safety branch.


## Final integrity and source review

After the RIG-01 rotation, independently re-fetched **all eight original artifacts** plus this checkpoint from `main`; parsed **17 internal relative Markdown links across those nine files**, resolving to **nine distinct existing repository targets**, with **zero broken links**. ROPE-PULL-01 original p. 5 and p. 10–11 Rockwell figures, ENV-01 nVent original p. 9 and TRUMPF TruBend 2100 one-page original were visually/source inspected. HSE and OSHA original public guidance added to ENV-01 with explicit scope. No additional compute or physical proof arose. Existing laboratory/evaluator ledgers unchanged. `LESSON_LOG.md` UTC end/elapsed/overlap must be appended with its complete current blob SHA immediately before exit; do not replace this instruction with a guessed end time.
