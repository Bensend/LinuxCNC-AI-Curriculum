# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02**, **E20**, and now **X01** are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs. The current learner must not self-certify any of those handoffs.

**X01 — recorder perturbation and long-duration retention:** authoritative X01-002 workflow `34436256547`, job `102741829103`, retained artifact `10136342576`, passed frozen Gates A–J **10/10** after independent raw-artifact inspection. The frozen adversarial exam subsequently passed **20/20**, including all critical traps. The corrected X01 contract explicitly treats producer overrun + deterministic sampled payload discontinuity as recorder-loss evidence; contiguous `halsampler -t` tags alone are not a complete producer-loss oracle for the pinned/tested model. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is prepared but intentionally UNSCORED by this learner.

**X02 — synchronized multi-surface diagnostics is the highest-priority unblocked technical module and is SOURCE/CALL-FLOW active.** Pinned source tracing at `8bf4605ae81042248add031e94c77300406e0413` establishes the generation chain from realtime motion status through Task publication to Python `linuxcnc.stat().poll()`. `call-flows/X02-multi-surface-status-publication.md` records the durable trace. `research/X02-nml-freshness-community-doc-crosscheck.md` now records the official documentation/community freshness cross-check. X02 inherits X01's evidence-validity boundary.

F02 remains blocked by completion/acceptance of S02, E20 and X02. S02/E20/X01 graduation labels remain pending their genuinely fresh handoffs.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations.

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

## X02 source/call-flow checkpoint

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source tracing establishes realtime motion heartbeat publication, coherent Task-side shared-memory copying, Task `taskbeat` publication into aggregate `EMC_STAT`, and Python `stat.poll()` copying the latest NML status publication into its local object. Motion heartbeat and taskbeat are distinct generation witnesses owned by different loops; Python poll time is observer time, not realtime production time.

Official documentation independently defines `taskbeat` as the Task main-loop heartbeat, with rate determined by `[TASK]CYCLE_TIME`, and describes Python as polling the NML status channel. Current INI documentation describes TASK as communicating with UIs over NML and realtime motion over non-HAL shared memory. A 2021 community report that `peek()` may not yield a new status on every userspace poll is retained only as COMMUNITY-REPORTED evidence, not a timing guarantee.

Therefore a new Task generation may contain the same motion heartbeat, and multiple motion generations may occur between userspace observations. Nearest-wall-clock alignment alone cannot prove same-cycle or causal correspondence.

## Exact next-work checkpoint

1. Preserve S02, E20 and X01 as graduation-pending fresh-AI handoff; do not self-certify.
2. Continue X02 as highest-priority work.
3. Select a software-only status value with an objectively traceable production path at the pinned revision; trace it from realtime/HAL production through motion status, Task/NML publication, and Python exposure.
4. Then freeze X02-001 with a deterministic fixture. Python records `(observer monotonic time, taskbeat, motion heartbeat, selected status value)` while an independent X01-valid realtime/HAL recorder captures deterministic payload-cycle and recorder-health witnesses.
5. Deliberately exercise repeated observations of one Task generation, Task advance without assuming one-for-one motion advance, motion-generation skips between slower observations, and invalid recorder intervals.
6. Gates must use generation/witness relationships, never nearest-wall-clock matching as proof of simultaneity. Any unresolved recorder overrun, payload discontinuity, reader truncation, unknown topology/thread order, or provenance loss makes the interval unusable/uncertain for correlation.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
