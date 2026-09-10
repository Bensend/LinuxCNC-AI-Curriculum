# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02**, **E20**, and now **X01** are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs. The current learner must not self-certify any of those handoffs.

**X01 — recorder perturbation and long-duration retention:** authoritative X01-002 workflow `34436256547`, job `102741829103`, retained artifact `10136342576`, passed frozen Gates A–J **10/10** after independent raw-artifact inspection. The frozen adversarial exam subsequently passed **20/20**, including all critical traps. The corrected X01 contract explicitly treats producer overrun + deterministic sampled payload discontinuity as recorder-loss evidence; contiguous `halsampler -t` tags alone are not a complete producer-loss oracle for the pinned/tested model. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is prepared but intentionally UNSCORED by this learner.

**X02 — synchronized multi-surface diagnostics is the highest-priority unblocked technical module and is now SOURCE/CALL-FLOW active.** Pinned source tracing at `8bf4605ae81042248add031e94c77300406e0413` now establishes the generation chain from realtime motion status through Task publication to Python `linuxcnc.stat().poll()`. `call-flows/X02-multi-surface-status-publication.md` records the durable trace. X02 inherits X01's evidence-validity boundary: correlation is not trustworthy for intervals where recorder producer health, witness continuity, lifecycle, provenance, or thread order cannot establish usable coverage.

F02 remains blocked by completion/acceptance of S02, E20 and X02. S02/E20/X01 graduation labels remain pending their genuinely fresh handoffs, but independent technical work may continue where the dependency graph requires technical acceptance rather than fresh-handoff graduation.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. Do not inspect evaluator-hidden answers from the learner role merely to satisfy cadence.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns. `results/D01-006-authoritative-evidence-and-exam.md` records Gates 10/10 PASS and adversarial exam 20/20 PASS.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. Authoritative workflow `34395556653`, artifact `10121464851`, passed frozen Gates A–J 10/10; frozen exam 20/20. Fresh-AI handoff remains required.

## E20 technical closure / handoff pending

Independent authoritative workflow `34399792261`, artifact `10123146331`, passed frozen Gates A–J 10/10; frozen adversarial exam 20/20. Transport recovery, HostMot2 watchdog/physical-I/O authority and machine authorization remain explicitly separate. `evaluation/E20-fresh-ai-handoff-packet.md` is READY / NOT YET EVALUATED.

## X01 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source inspection establishes `sampler.c::sample()` as a scheduled realtime producer that snapshots inputs and attempts `hal_stream_write()`. FIFO-full failure drops the recorder record and increments `sampler.N.overruns`. `sampler_usr.c::main()` is the userspace reader. The pinned exported `sampler.N.sample-num` pin is not the value source used by `halsampler -t`; `-t` prints the stream sequence returned by `hal_stream_read()`.

### Lineage correction

X01-001 reached the three-attempt ceiling. Attempt 3 demonstrated that FIFO saturation/producer overruns can coexist with contiguous `-t` tags, falsifying the old loss oracle. The experiment was explicitly classified **ESSENTIAL NOW / MATERIAL REDESIGN**. X01-002 froze producer-overrun + deterministic payload-cycle discontinuity as the loss oracle and retained `-t` only as successful-stream ordering evidence.

X01-002 preflight workflow `34428664862`, job `102719239856`, artifact `10133717168`, validly exercised the redesigned model. Exact job runtime: 267 s = 4.45 min.

The first authoritative wrapper attempt, workflow `34432706789`, job `102731363601`, failed before LinuxCNC/P0 because nested Python triple-quote construction caused a `SyntaxError`. Exact job runtime: 8 s = 0.13 min. `results/X01-002-authoritative-attempt-1-wrapper-reconciliation.md` preserves the HARNESS INVALID classification; Gates remained unscored.

The wrapper-only correction launched authoritative workflow `34436256547`. Its job `102741829103` ran 238 s = 3.97 min and retained artifact `10136342576` (`sha256:b7a8d68eaae7633bdd5a890519b70fdd7f5abf7b1eaa27a332b9d7ac7bc74960`). Independent raw-artifact inspection established:

- P1: exactly 2,000 contiguous tags + deterministic payload rows, producer overruns 0;
- P2: stopped counter 373, residual depth 354, exactly 354 rows drained, terminal payload 370 within the frozen 3-cycle boundary, post-drain depth 0/overruns 0;
- P3: depth 64/full TRUE, overruns 192 before drain and 206 after, deterministic source counter 282 -> 473, zero consumer overrun markers, zero tag gaps, but one deterministic payload gap **79 -> 286**;
- P4: narrow/wide 2,000-row captures both had zero overruns; observed thread timing was retained without converting it into a production deadline guarantee;
- P5: the predeclared 10,000-row sustained narrow capture retained tags `0..9999`, unit-contiguous deterministic payload, producer overruns 0 and `full=FALSE`.

`results/X01-002-authoritative-evidence-review.md` scores frozen Gates A–J **10/10 PASS**. `call-flows/X01-sampler-recording-and-loss-boundary.md` records the source/call-flow boundary. The corrected guide no longer teaches clean `-t` continuity as sufficient producer-integrity evidence.

`exams/X01-adversarial-exam.md` was frozen before answers; `exams/X01-adversarial-answers-and-score.md` records **20/20 PASS**, all critical traps passed. The exam is not a fresh-AI handoff.

`handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is PREPARED / UNSCORED. X01 therefore has **technical acceptance**, not full graduation.

## X01 counterfactual promotion / sufficiency decision

Promoted/deferred items include deep HAL-stream memory-order proof, filesystem/power-loss durability, physical sensor simultaneity, safety-rated logging, and production-machine-specific deadline effects. If any of those differ from current expectations, they do not overturn X01's central 2000-level teaching: before attributing a diagnostic trace to machine/control behavior, separately establish recorder producer health, sampled witness continuity, userspace drain lifecycle, topology/provenance and function/thread ordering. None of the deferred items is being used as evidence that X01 already proves physical truth, durability, or safety.

**Technical sufficiency decision: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.**

## X02 source/call-flow checkpoint

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source tracing now establishes:

- realtime `control.c` completes `update_status()`, increments `emcmotStatus->heartbeat`, and commits status coherence with `tail = head`;
- userspace `usrmotReadEmcmotStatus()` copies shared motion status and accepts only `head == tail`, retrying a split read at most three times;
- `emcMotionUpdate()` maps the completed motion heartbeat into `EMC_STAT.motion.heartbeat`;
- Task increments `task_beat`, maps it into `EMC_STAT.task.taskbeat`, updates the aggregate status and publishes it with `emcStatusBuffer->write(emcStatus)`;
- Python `linuxcnc.stat().poll()` peeks the RCS status channel and memcpy-copies the published `EMC_STAT` into its local object.

Thus motion heartbeat and taskbeat are distinct generation witnesses owned by different loops. Python poll time is observer time, not realtime production time. A new Task generation can legitimately contain the same motion heartbeat; multiple motion generations can also occur between Task/Python observations. Wall-clock nearest-neighbor alignment alone is therefore insufficient evidence of same-cycle or causal correspondence.

## Exact next-work checkpoint

1. Preserve S02, E20 and X01 as graduation-pending fresh-AI handoff; do not self-certify.
2. Continue X02 as highest-priority work. Complete documentation/community cross-checks specifically for NML status freshness, heartbeat interpretation, and diagnostic correlation pitfalls.
3. Freeze X02-001 only after defining a deterministic cross-surface experiment that records `(observer monotonic time, taskbeat, motion heartbeat, selected status value)` from Python plus an X01-valid realtime/HAL payload-cycle witness.
4. The experiment must deliberately exercise different observation rates and predeclare gates for repeated Task publications, skipped motion generations, and invalid recorder intervals. Gates must use generation/witness relationships, not nearest wall-clock timestamps.
5. Carry forward X01 invalidity rules: any interval with unresolved recorder overrun, payload-cycle discontinuity, reader truncation, unknown topology/thread order, or provenance loss must be marked unusable/uncertain for correlation rather than silently interpolated into a machine-event narrative.
6. Record X01 preflight, invalid wrapper attempt and accepted authoritative runtime in `LAB_COMPUTE_LOG.md` if canonical ledger integration is not yet complete.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
