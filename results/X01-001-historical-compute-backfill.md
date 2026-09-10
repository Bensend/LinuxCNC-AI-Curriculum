# X01-001 historical compute backfill

Date reconciled: 2026-09-10 UTC

## Purpose

The 2000-level critical path is currently blocked only by deliberately information-separated fresh-AI handoffs for S02, E20, X01, and X02. Per `PROGRESS.md`, historical compute/evidence-integrity maintenance remains useful unblocked work and must not be used to self-certify graduation.

This reconciliation integrates exact GitHub Actions **job** timestamps for the three X01-001 attempts that were previously listed as unbackfilled. Workflow envelope duration is not used.

## Authoritative metadata

| Attempt | Workflow | Job | Job start UTC | Job end UTC | Exact compute | Outcome classification |
|---|---:|---:|---|---|---:|---|
| X01-001 attempt 1 | `34411511393` | `102666749355` | 2026-09-09T22:18:06Z | 2026-09-09T22:22:01Z | 235 s = 3.92 min | HARNESS INVALID — first retained-artifact audit exposed harness/array setup defect; no accepted behavioral verdict. |
| X01-001 attempt 2 | `34416110919` | `102681240404` | 2026-09-09T23:15:34Z | 2026-09-09T23:19:09Z | 215 s = 3.58 min | HARNESS INVALID — zero-padded sampler pin-name correction was still required; no accepted behavioral verdict. |
| X01-001 attempt 3 | `34420657736` | `102695115020` | 2026-09-10T00:17:29Z | 2026-09-10T00:21:08Z | 219 s = 3.65 min | TEST FALSIFIED OLD ORACLE / NOT ACCEPTED — the third attempt forced the three-attempt reconciliation and X01-002 material redesign; X01-001 was not accepted as technical evidence for recorder-loss detection. |

Total exact X01-001 job compute: **669 s = 11.15 min**.

Of that total, **7.50 min** belongs to 2026-09-09 and **3.65 min** belongs to 2026-09-10.

## Ledger effect

Prior exactly backfilled total: **135.07 min**.

New exactly backfilled total after these three jobs: **146.22 min (2.44 h)**.

Prior exactly backfilled 2026-09-10 total: **21.07 min**.

New exactly backfilled 2026-09-10 total: **24.72 min (0.41 h)**.

Historical coverage remains incomplete for later C06 runs after C06-038 and C07 laboratory runs. Those must continue to be excluded from the exact total until authoritative job timestamps are reconciled.

## Integrity conclusion

This backfill changes only compute-accounting completeness. It does **not** change X01 technical acceptance, the X01-002 evidence chain, or the fresh-AI handoff requirement. S02, E20, X01, and X02 remain technically accepted but not fully graduated until genuinely information-separated handoff evaluation is completed.
