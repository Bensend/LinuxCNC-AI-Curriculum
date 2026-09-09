# Blind External Feedback Score Log

This ledger tracks external-feedback performance without replacing detailed evaluator records.

| Challenge | Date | Bank | Level / competency | Blind valid? | Score /10 | Confidence | Solve min | Transfer score | Retention score | Primary error class | Curriculum/process action |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---|
| BL-DEV-001 | 2026-09-08 | development | 1000 / HAL same-thread ordering and stale-data propagation | YES | 10 | 92% | 0.48 | — | — | none | Baseline established. No immediate corrective transfer retest; sample a different mechanism next, and run a novel retention/development challenge after ~10 lessons or ~24 h as meaningful. |
| BL-DEV-002 | 2026-09-08 | development | 1000 / motion following-error threshold | YES | 9 | 88% | 0.8 | 10/10 (2026-09-09, BL-DEV-002-TRANSFER-01) | — | retrieval precision / exact formula | Transfer retest succeeded: learner retrieved `max(MIN_FERROR, FERROR*abs(vel_cmd)/vel_limit)` and applied the strict `>` trip comparison correctly on a novel numeric surface. Keep delayed retention separate rather than treating immediate transfer as long-term retention. |

## Rolling interpretation

Do not infer a study-method improvement from two baseline challenges plus one transfer retest. Compare multiple independent challenges at similar difficulty/competency level and inspect subscores, confidence calibration, transfer, retention, time, and compute together.

BL-DEV-002 originally showed strong behavioral prediction and safety-boundary retention but a source-formula precision miss. Its first novel transfer retest scored 10/10 at 95% confidence after the correction, providing evidence that the exact velocity-scaled-plus-floor mechanism is now retrievable. This does not yet establish delayed retention.

Track process changes separately so later analysis can compare performance windows without rewriting history.
