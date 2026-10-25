# 4400-EDM-01 — Independent unseen reset/EDM transfer handoff
**2026-10-25 | PREPARED / NOT RUN | No learner answer, oracle, score or physical release**

## Test construction — evaluator-only before learner exposure
A separate evaluator selects an **unseen** original OEM safety relay or ESPE/EDM manual and a novel, uninstalled fictional machine diagram with explicit unknowns. The evaluator privately fixes the manufacturer revision, scenario, correct interpretation and grading rubric before learner sees the case. Do **not** choose Pilz PNOZ s4, OMRON G9SE or SICK C4000 from this study as the hidden oracle; they are already learner-visible. No private answer key in this public repository.

The case must include a reset edge/stuck-button ambiguity, at least one external final-element feedback fault, a guard-clear versus deliberate-start distinction, a machine-physical-energy boundary, and a maintenance/change-control trap. A novel configuration with an unexpected factory default is especially discriminating. The evaluator must independently verify source details and avoid invented performance levels.

## Learner commitment
Record before oracle reveal: predicted behavior; causal mechanism; expected observation; first diagnostic/source checks; alternatives; falsifier; confidence 0–100%; solution time; sources consulted; and an explicit HOLD/release decision. Commit the response immutably before scoring.

## Independent scoring
Use the five 0–2 categories from [blind protocol](BLIND_FEEDBACK_PROTOCOL.md): prediction/diagnosis, mechanism, diagnostic efficiency, uncertainty/safety boundary and confidence calibration. Critical safety miss: claiming a ready relay/EDM NC feedback guarantees actual hydraulic holding, accepting automatic restart from guard clear, assuming a component rating is machine PL/SIL, or suggesting a live unqualified fault injection.

After score, record exact source, evaluator and result in FEEDBACK_SCORE_LOG; use a different novel surface for transfer and later delayed retention. Until executed, this handoff is **PREPARED/NOT RUN** and must not affect competency metrics or graduation.

**Machine gate:** independent selected-machine G0/G1 evidence missing, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No GitHub-hosted or local compute justified for this handoff.
