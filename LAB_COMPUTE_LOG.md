# Laboratory Compute Ledger

This ledger tracks actual GitHub Actions / Codespaces laboratory compute separately from conversational study time.

The first-draft curriculum budget is approximately **120 total lab hours**, with a working ceiling near **8 lab hours/day** over the expected 14–15 day first-draft window. This is a ceiling, not a target.

## Recording rule

For every laboratory workflow that materially belongs to the curriculum, append one row after authoritative job metadata is available. Use actual job start/end timestamps when available. Do not estimate runtime from lesson duration or workflow queue time.

If a run is cancelled, times out, is harness-invalid, or fails substantively, still record the compute it consumed. Duplicate/retried runs must each be counted. A workflow that was queued but never executed should record zero compute and explain why.

| Date | Module / Lab | Workflow run | Job ID | Job start UTC | Job end UTC | Compute min | Outcome | Evidence classification / notes |
|---|---|---:|---:|---|---|---:|---|---|

## Running totals

Keep these totals current whenever new rows are added:

- **Total lab compute used:** 0.0 h + unbackfilled historical usage
- **Remaining from 120 h first-draft allowance:** unknown until historical backfill
- **Current-day lab compute:** 0.0 h + unbackfilled historical usage

## Immediate backfill queue

The following recent authoritative jobs are known and should be the first exact-runtime backfill entries once job start/end timestamps are available:

- T02-019 — workflow `34179865160`, job `101916590952`, successful, accepted test evidence.
- T03-020 — workflow `34182846956`, job `101925247534`, successful workflow and repository exit code `0`; behavioral gates still require reconciliation before TEST-CONFIRMED status.

Do not use workflow `created_at`/`updated_at` envelope duration as billable job compute when exact job timestamps can be obtained later.

## Historical backfill rule

The repository already contains laboratory activity predating this ledger. Do not invent historical runtime. Backfill prior runs only from authoritative GitHub Actions job timestamps or equivalent preserved metadata. Mark incomplete historical coverage explicitly until reconciled.

Backfill should prioritize runs that materially affected curriculum conclusions and repeated/timeout runs that may dominate compute cost. Exact total coverage is preferable, but missing historical data must not block current curriculum progress.

## Efficiency use

Use this ledger together with `LESSON_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` to compare:

- substantive study minutes;
- actual lab compute minutes;
- graduated competency;
- blind external-evaluation score;
- transfer/retention score;
- failed or invalid experiment cost.

Compute consumption is a cost measurement, not evidence of learning by itself.
