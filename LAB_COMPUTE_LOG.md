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
| 2026-09-08 | C05-028 feedback-freeze attempt 1 | `34246869855` | `102131002815` | 2026-09-08T15:46:12Z | 2026-09-08T15:49:40Z | 3.5 | HARNESS INVALID | Selector pin was linked to a signal, then userspace attempted to write the linked pin directly; no decisive behavioral phase. |
| 2026-09-08 | C05-028 feedback-freeze attempt 2 | `34247942092` | `102134660105` | 2026-09-08T15:56:19Z | 2026-09-08T16:03:00Z | 6.7 | PASS | Accepted TEST-CONFIRMED C05-028 evidence; frozen feedback remained constant while independently sampled toy true-B moved. |
| 2026-09-08 | C05-029 scale/jump attempt 1 | `34250135965` | `102142142268` | 2026-09-08T16:17:27Z | 2026-09-08T16:21:38Z | 4.2 | HARNESS INVALID | Single sampler configuration exceeded LinuxCNC's supported per-sample item count; no behavioral verdict. |
| 2026-09-08 | C05-029 scale/jump attempt 2 | `34251568612` | `102147037252` | 2026-09-08T16:31:44Z | 2026-09-08T16:31:51Z | 0.1 | HARNESS INVALID | Wrapper/generator quoting failure before LinuxCNC behavior under test. |
| 2026-09-08 | C05-029 scale/jump attempt 3 | `34251704209` | `102147446647` | 2026-09-08T16:32:47Z | 2026-09-08T16:36:17Z | 3.5 | HARNESS INVALID | Deferred FIFO-1 userspace drain produced an empty secondary trace; triggered ESSENTIAL NOW redesign classification. |
| 2026-09-08 | C05-029 redesigned attempt 4 staging preflight | `34252503889` | `102150101026` | 2026-09-08T16:40:36Z | 2026-09-08T16:40:44Z | 0.1 | HARNESS INVALID | Isolated generator root omitted inherited `028-c05-feedback-freeze.sh`; LinuxCNC behavior did not run. |
| 2026-09-08 | C05-029 redesigned attempt 5 concurrent samplers | `34252609192` | `102150452717` | 2026-09-08T16:41:38Z | 2026-09-08T16:46:35Z | 5.0 | HARNESS INVALID | Both concurrent readers ran; exact join rejected one terminal sample present only in FIFO A (`onlyA=[6564]`), traced to independent userspace sampler-stop writes. |
| 2026-09-08 | C05-029 redesigned attempt 6 thread-stop | `34256027036` | `102161932242` | 2026-09-08T17:15:49Z | 2026-09-08T17:19:08Z | 3.3 | HARNESS INVALID | Single realtime-thread stop still left split-FIFO userspace retention/alignment unsuitable for the exact-join evidence contract; split transport remained non-authoritative. |
| 2026-09-08 | C05-029 redesigned attempt 7 quiescent drain | `34256658628` | `102164080412` | 2026-09-08T17:22:08Z | 2026-09-08T17:25:33Z | 3.4 | HARNESS INVALID | Reached fixture and phase 1 with zero reported overruns, but exited before frozen behavioral analysis; repeated cross-FIFO termination/alignment family retired. |

## Running totals

Keep these totals current whenever new rows are added:

- **Exactly backfilled lab compute:** 68.1 min (1.14 h)
- **Total lab compute used:** 1.14 h + unbackfilled historical usage
- **Remaining from 120 h first-draft allowance:** unknown until historical backfill
- **Current-day exactly backfilled lab compute (2026-09-08):** 68.1 min (1.14 h) + unbackfilled same-day historical usage

## Immediate backfill queue

Backfill C03-025 and C04-026 authoritative jobs from GitHub Actions metadata when convenient; they remain uncounted in the exact total above.

C05-029 attempts 1–7 are now exactly accounted. Add the single-atomic-sampler run from authoritative job timestamps after it completes.

No known T02-T05, C01, C02, or earlier C05 jobs through C05-029 attempt 7 remain in the immediate backfill queue.

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
