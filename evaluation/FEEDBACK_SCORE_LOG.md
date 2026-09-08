# Blind External Feedback Score Log

This ledger tracks external-feedback performance without replacing detailed evaluator records.

| Challenge | Date | Bank | Level / competency | Blind valid? | Score /10 | Confidence | Solve min | Transfer score | Retention score | Primary error class | Curriculum/process action |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---|
| BL-DEV-001 | 2026-09-08 | development | 1000 / HAL same-thread ordering and stale-data propagation | YES | 10 | 92% | 0.48 | — | — | none | Baseline established. No immediate corrective transfer retest; sample a different mechanism next, and run a novel retention/development challenge after ~10 lessons or ~24 h as meaningful. |
| BL-DEV-002 | 2026-09-08 | development | 1000 / motion following-error threshold | YES | 9 | 88% | 0.8 | — | — | retrieval precision / exact formula | Outcome correct, but learner recalled endpoint interpolation instead of pinned `max(MIN_FERROR, FERROR*abs(vel_cmd)/vel_limit)`. Preserve a minimal retrieval correction and run a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons. |

## Rolling interpretation

Do not infer a study-method improvement from two challenges. Compare multiple independent challenges at similar difficulty/competency level and inspect subscores, confidence calibration, transfer, retention, time, and compute together.

BL-DEV-002 shows strong behavioral prediction and safety-boundary retention but a source-formula precision miss. Treat that as a targeted retrieval weakness, not evidence that the whole study process regressed.

Track process changes separately so later analysis can compare performance windows without rewriting history.
