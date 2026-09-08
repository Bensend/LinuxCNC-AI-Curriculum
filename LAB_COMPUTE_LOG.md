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
| 2026-09-08 | T05-022 startup freshness gating attempt 2 | `34193926426` | `101957458393` | 2026-09-08T06:16:10Z | 2026-09-08T06:20:17Z | 4.1 | PASS | Accepted TEST-CONFIRMED T05 evidence; frozen Gates A-H passed after source-grounded harness correction. |
| 2026-09-08 | C01-023 duplicated-joint fanout attempt 1 | `34199237041` | `101973964122` | 2026-09-08T07:25:17Z | 2026-09-08T07:28:45Z | 3.5 | HARNESS INVALID | Sequential userspace reads tore the simultaneous-state observation by one servo tick; no behavioral FAIL claim. |
| 2026-09-08 | C01-023 realtime-correction preflight | `34209095831` | `102005554568` | 2026-09-08T09:16:38Z | 2026-09-08T09:17:38Z | 1.0 | HARNESS INVALID | Shell-variable typo terminated before LinuxCNC behavior under test; preserved as implementation-preflight cost. |
| 2026-09-08 | C01-023 realtime same-cycle attempt 2 | `34209185893` | `102005842122` | 2026-09-08T09:17:36Z | 2026-09-08T09:22:19Z | 4.7 | PASS | Accepted TEST-CONFIRMED C01 evidence from published artifact `10049218375`; inner lab exit 0 and Gates A-H pass. Workflow envelope later failed during result-commit race with concurrent curriculum commits. |
| 2026-09-08 | C02-024 independent-feedback disturbance attempt 1 | `34219392130` | `102038671214` | 2026-09-08T11:11:44Z | 2026-09-08T11:15:20Z | 3.6 | HARNESS INVALID | Useful B-only divergence evidence, but Gate H mixed userspace enable observation with realtime output and the complete raw trace was not durably retained; no LinuxCNC behavioral FAIL claim. |
| 2026-09-08 | C02-024 same-cycle enable correction | `34224780695` | `102056118960` | 2026-09-08T12:12:29Z | 2026-09-08T12:15:58Z | 3.5 | PASS / PUBLICATION INCOMPLETE | Frozen behavioral Gates A-H passed, including 1,011 same-cycle A-enabled/B-disabled rows with B output zero, but complete raw trace was copied outside the workflow artifact path, so this was not the final accepted artifact. |
| 2026-09-08 | C02-024 retained-evidence final | `34225190610` | `102057466102` | 2026-09-08T12:16:54Z | 2026-09-08T12:20:47Z | 3.9 | PASS | Accepted TEST-CONFIRMED C02 evidence; full 8,335-row realtime trace and process logs retained under `lab-results/c02-024-evidence/`, artifact `10055529544`. |

## Running totals

Keep these totals current whenever new rows are added:

- **Exactly backfilled lab compute:** 38.3 min (0.64 h)
- **Total lab compute used:** 0.64 h + unbackfilled historical usage
- **Remaining from 120 h first-draft allowance:** unknown until historical backfill
- **Current-day exactly backfilled lab compute (2026-09-08):** 38.3 min (0.64 h) + unbackfilled same-day historical usage

## Immediate backfill queue

C03-025 workflow `34226127383` is active as this ledger revision is written. Add its authoritative job start/end/runtime after completion, including failed or harness-invalid compute.

No known T02-T05, C01, or C02 authoritative jobs remain in the immediate backfill queue.

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
