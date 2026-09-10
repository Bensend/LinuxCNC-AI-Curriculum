# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02**, **E20**, and **X01** are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs. The current learner must not self-certify any of those handoffs.

**X01 — recorder perturbation and long-duration retention:** authoritative X01-002 workflow `34436256547`, job `102741829103`, retained artifact `10136342576`, passed frozen Gates A–J **10/10** after independent raw-artifact inspection. The frozen adversarial exam subsequently passed **20/20**, including all critical traps. The corrected X01 contract explicitly treats producer overrun + deterministic sampled payload discontinuity as recorder-loss evidence; contiguous `halsampler -t` tags alone are not a complete producer-loss oracle for the pinned/tested model. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is prepared but intentionally UNSCORED by this learner.

**X02 — synchronized multi-surface diagnostics is the highest-priority unblocked technical module and is EXPERIMENT/AUTHORITATIVE active.** Pinned source tracing at `8bf4605ae81042248add031e94c77300406e0413` establishes the generation chain from realtime motion status through Task publication to Python `linuxcnc.stat().poll()`. `call-flows/X02-multi-surface-status-publication.md` records the publication trace; `research/X02-nml-freshness-community-doc-crosscheck.md` records documentation/community freshness evidence; `call-flows/X02-motion-type-cross-surface-witness.md` traces the software-only state witness; and `research/X02-generation-witness-adversarial-notes.md` records the correlation traps that must be rejected. X02 inherits X01's evidence-validity boundary.

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

## X02 source/call-flow and experiment checkpoint

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source tracing establishes realtime motion heartbeat publication, coherent Task-side shared-memory copying, Task `taskbeat` publication into aggregate `EMC_STAT`, and Python `stat.poll()` copying the latest NML status publication into its local object. Motion heartbeat and taskbeat are distinct generation witnesses owned by different loops; Python poll time is observer time, not realtime production time.

Pinned `emcmodule.cc` independently resolves Python `stat.heartbeat` to `status.motion.heartbeat` and `stat.taskbeat` to `status.task.taskbeat`; its member descriptions identify servo-cycle versus Task-cycle ownership. Official documentation corroborates these meanings and the Python/NML polling model.

A concrete cross-surface witness is SOURCE-CONFIRMED: realtime `control.c` obtains `emcmotStatus->motionType` from `tpGetMotionType()`, publishes that same field to HAL `motion.motion-type`, Task `emcMotionUpdate()` copies it to trajectory status `motion_type`, and Python exposes `status.motion.traj.motion_type` as `linuxcnc.stat().motion_type`. This value is intentionally not treated as a generation identifier because it may remain unchanged across many cycles. It must be paired with motion heartbeat, taskbeat, and X01-valid recorder health/cycle witnesses.

`experiments/X02-001-multi-surface-generation-correlation-plan.md` was frozen before execution in commit `903036d31e8c1e4d114cf43878c96a4e789744d7`. Its P0–P4/Gates A–J remain unchanged.

Preflight attempt 1, workflow `34454522362`, job `102797694203`, artifact `10143051352`, was **HARNESS INVALID**. The sampler became runnable before its enable pin was cleared, yielding `depth-before=11` and setup-time records. No behavioral verdict was taken.

Corrected attempt 2, workflow `34459587342`, job `102813964655`, source commit `08bfb98c411d6d51abb6c72a6992dcb94ea2d290`, artifact `10145085665`, is **VALID NON-AUTHORITATIVE PREFLIGHT — frozen Gates A–J 10/10 PASS after independent raw-artifact inspection**. `results/X02-001-corrected-preflight-audit.md` records the audit. The valid realtime trace contains exactly 20,000 rows, `depth-before=0`, zero producer overruns, contiguous stream tags and deterministic payload cycles, and the HAL/Python ordered nonduplicate `motion_type` sequence is identical: `[0,1,0,2,0,1,0,2,0]`. P1 contains 5,203 same-taskbeat adjacent repeats with increasing observer time; P3 contains 93 adjacent slow-observer pairs skipping more than one producer generation, with typical task/motion heartbeat deltas around 47–51. Equal state while a generation witness advances occurs 2,136 times. These observations support the frozen generation-vs-observer distinction without any nearest-timestamp same-cycle claim.

A separate unchanged authoritative realization was launched by `lab-jobs/055-x02-001-multi-surface-authoritative.sh` from commit `717fdd0179006d7b5ee27c6a32a5bd8b39816728`. Workflow `34465218660`, job `102832088115`, was in progress at this checkpoint. The wrapper executes the validated 054 harness unchanged; its retained artifact must still be independently inspected before any X02 technical-acceptance claim.

## Exact next-work checkpoint

1. Preserve S02, E20 and X01 as graduation-pending fresh-AI handoff; do not self-certify.
2. Inspect **X02-001 authoritative workflow `34465218660`, job `102832088115` only** after it completes; do not infer acceptance from workflow status.
3. Download its retained artifact and independently verify exact LinuxCNC/frozen-contract provenance, P0–P4 completion, `depth-before=0`, exactly 20,000 retained realtime rows, zero producer overruns, +1 stream-tag continuity, +1 deterministic payload continuity, bounded stop/drain, and complete Python trace.
4. Score the same frozen Gates A–J. Do not alter rates, phases, witnesses, or behavioral predicates. Compare generation relationships, not nearest timestamps.
5. If the authoritative artifact passes, record X02 technical acceptance, then proceed to the curriculum-required adversarial exam/counterfactual sufficiency review and prepare—not self-score—any fresh-AI transfer required for graduation.
6. If the run fails, classify harness/provenance versus behavioral failure under the frozen three-attempt/redesign rules before any correction.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
