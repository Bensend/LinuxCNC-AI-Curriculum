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
| 2026-09-09 | C06-030 authoritative attempt 1 | `34298423081` | `102299966701` | 2026-09-09T01:15:05Z | 2026-09-09T01:18:16Z | 3.2 | HARNESS INVALID | Opaque-reference HAL API incompatibility prevented `hm2_test` readiness before P0; frozen Gates A-H unscored. |
| 2026-09-09 | C06-030 authoritative attempt 2 | `34299295015` | `102302593867` | 2026-09-09T01:28:01Z | 2026-09-09T01:31:16Z | 3.3 | HARNESS INVALID | Opaque handle slots remained outside HAL shared memory; `data_ptr_addr not in shared memory`; no P0-P6 behavior. |
| 2026-09-09 | C06-030 authoritative attempt 3 | `34302451216` | `102312063998` | 2026-09-09T02:15:00Z | 2026-09-09T02:15:09Z | 0.2 | HARNESS INVALID | Nested source-rewriter syntax failure before LinuxCNC execution; triggered ESSENTIAL NOW redesigned-fixture cycle. |
| 2026-09-09 | C06-036 clean fixture preflight | `34306117465` | `102323048875` | 2026-09-09T03:11:06Z | 2026-09-09T03:15:02Z | 3.9 | PREFLIGHT PASS | Non-authoritative clean pattern-15 compile/load/object proof; exact fixture patch retained; frozen P0-P6 unscored. |
| 2026-09-09 | C06-037 redesigned behavioral attempt 1 | `34306570963` | `102324397610` | 2026-09-09T03:17:52Z | 2026-09-09T03:21:20Z | 3.5 | HARNESS INVALID | `halsampler` failed `hal_stream_attach` before atomic observation; zero rows. Gate-A prerequisites reached; behavioral Gates B-H unscored. |
| 2026-09-09 | C06-038 sampler-ready behavioral attempt 2 | `34306960420` | `102325539319` | 2026-09-09T03:23:55Z | 2026-09-09T03:27:30Z | 3.6 | HARNESS INVALID | Sampler-owned HAL objects existed, disproving the simple early-load race, but userspace `halsampler` still failed `hal_stream_attach` before P0. |
| 2026-09-08 | C03-025 attempt 1 | `34226127383` | `102060512004` | 2026-09-08T12:27:03Z | 2026-09-08T12:31:22Z | 4.3 | HARNESS INVALID | First C03 authoritative-family attempt; no accepted behavioral verdict. Exact job timestamps backfilled 2026-09-09. |
| 2026-09-08 | C03-025 attempt 2 | `34227719033` | `102065820535` | 2026-09-08T12:42:57Z | 2026-09-08T12:46:39Z | 3.7 | NOT ACCEPTED STANDALONE | In-process clip drove state; preserved as consumed compute, not final accepted evidence. Exact job timestamps backfilled 2026-09-09. |
| 2026-09-08 | C03-025 accepted attempt 3 | `34228231147` | `102067547546` | 2026-09-08T12:49:03Z | 2026-09-08T12:53:28Z | 4.4 | PASS | Accepted C03 evidence; exact job timestamps backfilled 2026-09-09. |
| 2026-09-08 | C04-026 attempt 1 | `34231940180` | `102079994732` | 2026-09-08T14:03:27Z | 2026-09-08T14:07:44Z | 4.3 | HARNESS INVALID | SyntaxError before valid behavioral execution. Exact job timestamps backfilled 2026-09-09. |
| 2026-09-08 | C04-026 attempt 2 | `34243768815` | `102119299104` | 2026-09-08T19:06:42Z | 2026-09-08T19:10:22Z | 3.7 | PASS / FOLLOW-UP REQUIRED | Behavioral run passed its harness; later C04 continuation resolved the source-transition issue. Exact job timestamps backfilled 2026-09-09. |
| 2026-09-09 | C08-051 diagnostic trace preflight | `34327928519` | `102389431379` | 2026-09-09T08:13:43Z | 2026-09-09T08:17:36Z | 3.9 | PREFLIGHT PASS | Non-authoritative collector/order/trace-validity proof; 31 producer overruns coexisted with retained contiguous tags `[0,1,2]`; C08 frozen gates unscored. |
| 2026-09-09 | C08-052 authoritative diagnostic discrimination | `34328731569` | `102392025784` | 2026-09-09T08:22:16Z | 2026-09-09T08:26:07Z | 3.9 | PASS | Accepted TEST-CONFIRMED C08 evidence; unchanged Gates A-J all passed; artifact `10094968899`. |
| 2026-09-09 | X01-001 preflight attempt 1 | `34411511393` | `102666749355` | 2026-09-09T22:18:06Z | 2026-09-09T22:22:01Z | 3.92 | HARNESS INVALID | First artifact audit exposed the harness/array setup defect; no accepted behavioral verdict. Exact job timestamps backfilled 2026-09-10. |
| 2026-09-09 | X01-001 preflight attempt 2 | `34416110919` | `102681240404` | 2026-09-09T23:15:34Z | 2026-09-09T23:19:09Z | 3.58 | HARNESS INVALID | Zero-padded sampler pin-name correction was still required; no accepted behavioral verdict. Exact job timestamps backfilled 2026-09-10. |
| 2026-09-10 | X01-001 preflight attempt 3 | `34420657736` | `102695115020` | 2026-09-10T00:17:29Z | 2026-09-10T00:21:08Z | 3.65 | NOT ACCEPTED / OLD ORACLE FALSIFIED | Third attempt led to the three-attempt ESSENTIAL NOW reconciliation and X01-002 material redesign; not accepted as recorder-loss evidence. Exact job timestamps backfilled 2026-09-10. |
| 2026-09-10 | X01-002 redesigned preflight | `34428664862` | `102719239856` | 2026-09-10T02:14:36Z | 2026-09-10T02:19:03Z | 4.45 | PREFLIGHT PASS | Artifact `10133717168`; validly exercised redesigned producer-overrun + deterministic-payload-gap oracle; frozen authoritative gates unscored. |
| 2026-09-10 | X01-002 authoritative wrapper attempt 1 | `34432706789` | `102731363601` | 2026-09-10T03:16:39Z | 2026-09-10T03:16:47Z | 0.13 | HARNESS INVALID | Python source-rewrite SyntaxError before LinuxCNC/P0; no behavioral evidence and Gates A-J unscored. |
| 2026-09-10 | X01-002 authoritative accepted run | `34436256547` | `102741829103` | 2026-09-10T04:12:20Z | 2026-09-10T04:16:18Z | 3.97 | PASS | Artifact `10136342576`; independent raw-artifact audit passed frozen Gates A-J 10/10 including predeclared 10,000-row P5. |
| 2026-09-10 | X02-001 preflight attempt 1 | `34454522362` | `102797694203` | 2026-09-10T08:19:20Z | 2026-09-10T08:24:03Z | 4.72 | HARNESS INVALID | Setup-order defect allowed sampler records before intended enable; `depth-before=11`; no behavioral verdict. |
| 2026-09-10 | X02-001 corrected preflight | `34459587342` | `102813964655` | 2026-09-10T09:15:01Z | 2026-09-10T09:19:07Z | 4.10 | PREFLIGHT PASS | Artifact `10145085665`; independent recorder audit and frozen Gates A-J 10/10; non-authoritative validation only. |
| 2026-09-10 | X02-001 authoritative accepted run | `34465218660` | `102832088115` | 2026-09-10T10:16:52Z | 2026-09-10T10:20:34Z | 3.70 | PASS | Artifact `10147333312`; complete nested raw traces independently parsed; frozen Gates A-J 10/10. |

## Running totals

Keep these totals current whenever new rows are added:

- **Exactly backfilled lab compute:** 146.22 min (2.44 h)
- **Total lab compute used:** 2.44 h + unbackfilled historical usage
- **Remaining from 120 h first-draft allowance:** unknown until historical backfill
- **Current-day exactly backfilled lab compute (2026-09-10):** 24.72 min (0.41 h) + unbackfilled same-day historical usage

## Immediate backfill queue

C03-025 and C04-026 are now backfilled from exact GitHub Actions job timestamps.

C05-029 attempts 1–7, C06 work through C06-038, C08-051/C08-052, X01-001 attempts 1–3, X01-002, and X02-001 preflight/authoritative attempts are exactly accounted. Later C06 runs after C06-038 and C07 laboratory runs remain historical backfill work where exact job metadata has not yet been integrated and must not be silently included in the exact totals above.

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