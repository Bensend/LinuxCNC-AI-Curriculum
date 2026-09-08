# Laboratory Compute Ledger

This ledger tracks actual GitHub Actions / Codespaces laboratory compute separately from conversational study time.

The first-draft curriculum budget is approximately **120 total lab hours**, with a working ceiling near **8 lab hours/day** over the expected 14–15 day first-draft window. This is a ceiling, not a target.

## Recording rule

For every laboratory workflow that materially belongs to the curriculum, append one row after authoritative job metadata is available. Use actual job start/end timestamps when available. Do not estimate runtime from lesson duration or workflow queue time.

If a run is cancelled, times out, is harness-invalid, or fails substantively, still record the compute it consumed. Duplicate/retried runs must each be counted. A workflow that was queued but never executed should record zero compute and explain why.

| Date | Module / Lab | Workflow run | Job ID | Job start UTC | Job end UTC | Compute min | Outcome | Evidence classification / notes |
|---|---|---:|---:|---|---|---:|---|---|
| 2026-09-08 | T02-019 Task execution-state/precondition | `34179865160` | `101916590952` | 2026-09-08T02:23:07Z | 2026-09-08T02:26:37Z | 3.5 | PASS | Accepted TEST-CONFIRMED T02 evidence; authoritative job timestamps. |
| 2026-09-08 | T03-020 NML ack vs semantic result | `34182846956` | `101925247534` | 2026-09-08T03:14:56Z | 2026-09-08T03:18:31Z | 3.6 | PASS | Accepted TEST-CONFIRMED T03 evidence after gate reconciliation; authoritative job timestamps. |
| 2026-09-08 | T04-021 GUI status freshness | `34186879941` | `101936899842` | 2026-09-08T04:24:31Z | 2026-09-08T04:27:41Z | 3.2 | PASS | Accepted TEST-CONFIRMED T04 evidence; authoritative job timestamps. |
| 2026-09-08 | T05-022 startup freshness gating attempt 1 | `34189716347` | `101945103662` | 2026-09-08T05:12:01Z | 2026-09-08T05:15:45Z | 3.7 | HARNESS INVALID | Exit 24. `GStat.__init__()` and tested `update()` were both blocked; implementation also drifted from frozen fixed-unavailable policy premise. No behavioral verdict. |

## Running totals

Keep these totals current whenever new rows are added:

- **Exactly backfilled lab compute:** 14.0 min (0.23 h)
- **Total lab compute used:** 0.23 h + unbackfilled historical usage
- **Remaining from 120 h first-draft allowance:** unknown until historical backfill
- **Current-day exactly backfilled lab compute (2026-09-08):** 14.0 min (0.23 h) + unbackfilled same-day historical usage

## Immediate backfill queue

No known T02-T05 authoritative jobs remain in the immediate queue as of the T05-022 attempt-1 reconciliation. Add T05-022 attempt 2 after its authoritative Actions job start/end timestamps become available.

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
