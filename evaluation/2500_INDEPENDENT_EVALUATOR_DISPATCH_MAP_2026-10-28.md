# 2500 safety course — independent evaluator dispatch map
**2026-10-28 | execution-readiness / contamination-control index | NOT AN EVALUATION, NOT A GRADUATION**

## Why this exists
The canonical 2520–25F0 safety sequence has **14 existing information-separated evaluator handoffs** and no corresponding scored external attempts in [FEEDBACK_SCORE_LOG](FEEDBACK_SCORE_LOG.md). The course's original [blind protocol](BLIND_FEEDBACK_PROTOCOL.md) and [safety sandbox evaluator rubric](../safety-course/SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md) already define scoring and critical failures; this short index does **not** create another exam bank, hidden solution, rubric or permission to self-score. It makes the *actual dispatch surface* inspectable so the safety course does not mistake hundreds of documentary exercises for transfer evidence.

## Existing handoff inventory — verified on 2026-10-28
| Module | Existing evaluator handoff | Exposure / novelty disposition | Recorded gate |
|---|---|---|---|
| 2520 | [hazard → SRS → physical proof](2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2530 | [E-stop demand/stop/restart](2530_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2540 | [relays/contactors/final elements](2540_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2550 | [ISO 13849 integrity discipline](2550_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2560 | [IEC 62061/SIL method discipline](2560_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2570 | [drives/STO/standstill/holding](2570_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2580 | [hydraulic/pneumatic stored energy](2580_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 2590 | [guards/interlocks/occupancy](2590_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 25A0 | [programmable safety and safe communications](25A0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 25B0 | [faults, diagnostics, CCF and proof](25B0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 25C0 | [safeguard-defeat human factors](25C0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 25D0 | [cost-effective architecture selection](25D0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |
| 25E0 | [novel commissioning/validation/change-control evaluator contract](25E0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | **Protocol-only current dispatch; [historical public challenge](25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md) is practice / potential contamination** | OPEN / NOT RUN |
| 25F0 | [cross-machine safety capstone](25F0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) | Evaluator protocol; evaluator constructs a novel scenario | OPEN / NOT RUN |

**Specific contamination trap:** Unlike the other 13 primarily protocol/selection handoffs, [25E0](25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md) already publishes an explicit generic-machine **Challenge** in a learner-readable repository file. It contains no solution key, but a fresh learner may have seen or rehearsed the challenge. **Do not automatically count its exact public challenge as blind.** The evaluator must document learner exposure and select a materially novel commissioning/change scenario when the original is contaminated. This is an **inspection-confirmed public exposure risk**, not a claim that any actual learner was contaminated.

## 2026-10-29 dispatch repair — 25E0 fixed-question exposure closed at selection boundary

A [new protocol-only 25E0 handoff](25E0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md) requires a **different, evaluator-selected novel machine/change**, SRS-derived physical witnesses, independent precommitment, and safe fault-case selection. The [original 2026-09-23 public challenge](25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md) remains unchanged as historical practice except for an explicit non-blind warning. This fixes the *dispatch-surface risk*, **not** the missing independent score. The original 14 protocols were directly read on 2026-10-29; no hidden key was accessed. All 14 external gates remain OPEN/NOT RUN; G0/G1 remains HOLD. No physical tests, hosted/local compute or evaluation occurred.

## Minimum evaluator dispatch transaction
1. **Evaluator separate from learner:** evaluator chooses a genuinely unseen machine/variant, freezes the oracle and contamination check outside learner-readable Git; do not post hidden answers in this repository. Preserve the selected handoff ID, revision, versioned public sources, evaluator identity/role and challenge bank designation.
2. **Learner packet only:** release problem description, permitted source references, unknown physical data, allowed time/resources, deliverables and safety boundaries. Do not expose expected solution, source resolution, score, or rubric notes that encode the answer.
3. **Immutable learner commitment:** record response, confidence, alternatives, falsifiers, time and resource usage before oracle reveal. If this cannot be proved, mark **NON-BLIND** and do not count it toward blind competency.
4. **Independent score:** use the [global five dimensions /10](BLIND_FEEDBACK_PROTOCOL.md) and its required error class; the [safety-specific /28 scorecard](../safety-course/SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md) may be recorded **separately** with its automatic-fail gates. Do not merge incompatible scales or self-assign scores.
5. **Evidence and follow-up:** evaluator records objective oracle/source/test evidence and any invalid/contaminated attempt; only then update [FEEDBACK_SCORE_LOG](FEEDBACK_SCORE_LOG.md), create minimal mechanism-level correction, novel transfer retest and delayed retention retest. No physical machine fault injection is necessary to evaluate documentary reasoning.
6. **Graduation:** module gate changes only with valid independent evidence and its critical-fail check. A protocol, dispatch map, green document link or paper worksheet is not a PASS.

## Efficient execution order without changing prerequisites
A qualified evaluator may stage **one novel transfer challenge at a time**, initially sampling 2520 (hazard/SRS), 2580 (fluid energy), 25C0 (human factors), 25E0 (commissioning) and 25F0 (capstone) for broad failure-path coverage. This is an **INFERENCE scheduling suggestion**, not permission to skip the remaining nine gates or to claim whole-course graduation from five samples. Use each module's own handoff contract for required scenario conditions and critical failures. Preserve exact module score separately; do not optimize a benchmark by rehearsing its challenge.

## Evidence status / safety boundary
**SOURCE-CONFIRMED:** all 14 handoff files exist and 25E0 has a public Challenge heading; **DOC-CONFIRMED:** repository blind/evaluator protocols; **UNKNOWN:** availability of a genuinely independent evaluator, unseen oracle, learner exposure and actual future score; **TEST-CONFIRMED none**. The [historical 14:40Z 4400 checkpoint](../checkpoints/2026-10-28T144010Z-4400-phase-monitor-backfeed-physical-evaluator-next.md) is **not** the current-state authority; follow [START_HERE](../START_HERE.md), [progress](../PROGRESS.md) and the newest dated 4400 checkpoint for current state. The durable gate remains **G0/G1 HOLD**, independent 2520–25F0 evaluator OPEN. Do not use ordinary LinuxCNC/FPGA status as personnel-safety proof. No workflow, hosted compute, self-hosted compute or physical hazardous operation was used to prepare this index.
