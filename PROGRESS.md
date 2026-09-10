# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02**, **E20**, and now **X01** are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs. The current learner must not self-certify any of those handoffs.

**X01 — recorder perturbation and long-duration retention:** authoritative X01-002 workflow `34436256547`, job `102741829103`, retained artifact `10136342576`, passed frozen Gates A–J **10/10** after independent raw-artifact inspection. The frozen adversarial exam subsequently passed **20/20**, including all critical traps. The corrected X01 contract explicitly treats producer overrun + deterministic sampled payload discontinuity as recorder-loss evidence; contiguous `halsampler -t` tags alone are not a complete producer-loss oracle for the pinned/tested model. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is prepared but intentionally UNSCORED by this learner.

**X02 — synchronized multi-surface diagnostics is the highest-priority unblocked technical module and is EXPERIMENT/PREFLIGHT active.** Pinned source tracing at `8bf4605ae81042248add031e94c77300406e0413` establishes the generation chain from realtime motion status through Task publication to Python `linuxcnc.stat().poll()`. `call-flows/X02-multi-surface-status-publication.md` records the publication trace; `research/X02-nml-freshness-community-doc-crosscheck.md` records documentation/community freshness evidence; `call-flows/X02-motion-type-cross-surface-witness.md` traces the software-only state witness; and `research/X02-generation-witness-adversarial-notes.md` records the correlation traps that must be rejected. X02 inherits X01's evidence-validity boundary.

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

`experiments/X02-001-multi-surface-generation-correlation-plan.md` was frozen before execution in commit `903036d31e8c1e4d114cf43878c96a4e789744d7`. Its P0-P4/Gates A-J remain unchanged. `lab-jobs/053-x02-001-multi-surface-preflight.sh` implements that contract using the upstream `tests/linuxcncrsh` software fixture, an independent deterministic realtime cycle witness, `motion.motion-type`, X01-valid `sampler` health/continuity evidence, and Python rows `(monotonic_ns, taskbeat, motion heartbeat, motion_type, status state)`. It deliberately requests fast/normal/slow Python observation rates and does not use nearest timestamps as a same-cycle oracle.

Preflight workflow `34454522362`, job `102797694203`, source commit `6eb541572e33168dac3e4eb67df3b01a62c02e85`, is active at this checkpoint. No behavioral gate is scored from workflow status alone; retained raw evidence must be independently inspected after completion.

## Exact next-work checkpoint

1. Preserve S02, E20 and X01 as graduation-pending fresh-AI handoff; do not self-certify.
2. Inspect **X02-001 preflight workflow `34454522362`, job `102797694203`, and its retained artifact/run directory only**.
3. Record actual job runtime and verify pinned commit/provenance, P0-P4 completion, recorder topology, exact 20,000-row realtime retention, zero producer overruns, deterministic payload and stream continuity, and the complete Python status trace.
4. Score only the preflight predicates against the already-frozen Gates A-J. Gates C/E may remain INCONCLUSIVE by contract. Workflow success alone is insufficient.
5. If execution fails before valid behavioral evidence, classify the defect as harness/provenance versus behavioral and use only a harness-only correction under the frozen three-attempt rule. Do not retune phases, rates, behavioral predictions, or gates after seeing output.
6. If the preflight is valid, launch a **separate unchanged authoritative X02-001 run** and independently inspect its retained raw artifact before acceptance.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
