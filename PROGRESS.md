# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02, E20, X01, and X02 are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs.** The current learner must not self-certify those handoffs.

**X02 — synchronized multi-surface diagnostics:** authoritative workflow `34465218660`, job `102832088115`, artifact `10147333312`, passed frozen Gates A–J **10/10** after independent recursive artifact inspection and direct parsing of the retained raw traces. The separately frozen adversarial exam passed **20/20**, including all critical traps. `handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` is PREPARED / UNSCORED.

**F02 remains blocked pending genuinely fresh handoff completion for S02, E20, X01, and X02.** Do not bypass the transfer requirement merely because the technical evidence is strong.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. The current learner must not reveal evaluator-side hidden answers to accelerate them.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns. `results/D01-006-authoritative-evidence-and-exam.md` records Gates 10/10 PASS and adversarial exam 20/20 PASS.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. Authoritative workflow `34395556653`, artifact `10121464851`, passed frozen Gates A–J 10/10; frozen exam 20/20. Fresh-AI handoff remains required.

## E20 technical closure / handoff pending

Independent authoritative workflow `34399792261`, artifact `10123146331`, passed frozen Gates A–J 10/10; frozen adversarial exam 20/20. Transport recovery, HostMot2 watchdog/physical-I/O authority and machine authorization remain explicitly separate. `evaluation/E20-fresh-ai-handoff-packet.md` is READY / NOT YET EVALUATED.

## X01 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source inspection establishes `sampler.c::sample()` as a scheduled realtime producer that snapshots inputs and attempts `hal_stream_write()`. FIFO-full failure drops the recorder record and increments `sampler.N.overruns`. `sampler_usr.c::main()` is the userspace reader. The pinned exported `sampler.N.sample-num` pin is not the value source used by `halsampler -t`; `-t` prints the stream sequence returned by `hal_stream_read()`.

X01-001 reached the three-attempt ceiling and falsified the old stream-tag loss oracle. X01-002 materially redesigned the oracle to producer-overrun + deterministic payload-cycle discontinuity.

X01-002 preflight workflow `34428664862`, job `102719239856`, artifact `10133717168`, runtime 267 s = 4.45 min. First authoritative wrapper attempt `34432706789`, job `102731363601`, failed before LinuxCNC/P0 with a source-rewrite SyntaxError, runtime 8 s = 0.13 min. Corrected authoritative workflow `34436256547`, job `102741829103`, runtime 238 s = 3.97 min, artifact `10136342576`, passed frozen Gates A–J 10/10. P5 retained 10,000 contiguous deterministic rows with zero overruns. `exams/X01-adversarial-answers-and-score.md` records 20/20 PASS. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` remains PREPARED / UNSCORED.

**Technical sufficiency decision: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.**

## X02 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source/call-flow work establishes the publication chain from completed realtime motion status through coherent Task shared-memory copying, Task `EMC_STAT` publication, the NML/RCS status channel, and Python `linuxcnc.stat().poll()`. Motion `heartbeat` and Task `taskbeat` are distinct producer-owned generation witnesses. Python monotonic time is observer time, not producer-generation time. `motion_type` is a state witness, not a generation identifier.

`experiments/X02-001-multi-surface-generation-correlation-plan.md` was frozen before execution in commit `903036d31e8c1e4d114cf43878c96a4e789744d7`.

Preflight attempt 1, workflow `34454522362`, job `102797694203`, artifact `10143051352`, was **HARNESS INVALID** because setup-order allowed samples before intended enable (`depth-before=11`). No behavioral verdict was taken.

Corrected preflight, workflow `34459587342`, job `102813964655`, source commit `08bfb98c411d6d51abb6c72a6992dcb94ea2d290`, artifact `10145085665`, was a valid non-authoritative preflight and passed frozen Gates A–J 10/10.

The separate unchanged authoritative wrapper ran from source commit `717fdd0179006d7b5ee27c6a32a5bd8b39816728` as workflow `34465218660`, job `102832088115`, artifact `10147333312`. Exact job runtime was 222 s = **3.70 min**. Independent recursive artifact inspection confirmed the complete raw evidence nested under `run-34465218660-1/x02-053-preflight-evidence/`; the earlier shallow listing concern was therefore resolved rather than treated as a retention defect.

Independent parsing found:

- exactly **20,000** realtime rows;
- `depth-before=0`;
- producer overruns before/after = **0/0**;
- zero stream-tag gaps and zero deterministic payload-cycle gaps;
- **7,046** Python observations with no backwards Task or motion-heartbeat movement;
- **4,908** P1 adjacent observations with increasing observer time and unchanged `taskbeat`;
- **522** adjacent observations showing Task/motion generation deltas are not one-for-one;
- **2,126** equal-`motion_type` adjacent cases while at least one generation witness advanced;
- **93** P3 slow-observer adjacent pairs that skipped more than one producer generation, with representative Task/motion deltas near `(47,51)`, `(47,50)`, `(46,49)`;
- identical ordered nonduplicate HAL/Python motion-state sequences `[0,1,0,2,0,1,0,2,0]` without claiming same-cycle timestamp identity.

`results/X02-001-authoritative-audit-and-sufficiency.md` records frozen Gates A–J **10/10 PASS** and the counterfactual sufficiency review. `exams/X02-adversarial-exam.md` was frozen before answers in commit `b46ddbb0aa0420053701a56aae360e32115187f9`; `exams/X02-adversarial-answers-and-score.md` records **20/20 PASS**. No central correction was required. The exam reinforces that slow-consumer heartbeat jumps are skipped observations—not proof of skipped realtime execution—and equal state is never freshness evidence.

`handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` is **PREPARED / UNSCORED**. It contains a novel layered-diagnostics scenario and must be evaluated by a genuinely information-separated learner/evaluator.

**Technical sufficiency decision: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.**

## Compute checkpoint

`LAB_COMPUTE_LOG.md` now includes exact job timestamps for all three X02-001 runs. Exactly backfilled compute is 135.07 min (2.25 h), with 21.07 min (0.35 h) exactly backfilled for 2026-09-10 plus explicitly unbackfilled historical usage.

## Exact next-work checkpoint

1. Preserve S02, E20, X01, and X02 as technically accepted / fresh-handoff pending. Do not self-score any prepared fresh-AI packet.
2. Obtain genuinely information-separated fresh-AI evaluations for the four pending modules; record each result and perform only the minimal mechanism-level correction required by any miss.
3. Preserve the blind-evaluation separation for delayed retention and the sealed benchmark. Do not expose evaluator answers to the learner.
4. Once the prerequisite handoffs are valid, mark the corresponding modules fully graduated and activate **F02** according to the 2000-level dependency graph.
5. Until those external/fresh evaluations are available, useful unblocked work may include exact historical lab-compute backfill and repository/evidence-integrity maintenance, but must not be used to manufacture a self-certified graduation.
