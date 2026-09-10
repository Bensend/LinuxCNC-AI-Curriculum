# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02** and **E20** are technically accepted at 2000 level and graduation-pending only their deliberately information-separated fresh-AI handoffs. The current learner must not self-certify either as fresh.

**X01 — recorder perturbation and long-duration retention is ACTIVE at 2000 level in EXPERIMENT / REDESIGN.** Its first clean-lineage preflight cycle reached the three-attempt ceiling. Attempts 1–2 were harness syntax/name defects. Attempt 3 executed the behavioral cases and falsified a frozen recorder-loss oracle: FIFO saturation produced producer overruns and missing deterministic payload cycles while the `halsampler -t` stream tags remained contiguous. `results/X01-001-preflight-attempt-3-three-attempt-reconciliation.md` classifies X01 as **ESSENTIAL NOW** and requires a materially redesigned, re-frozen experiment before further execution. No fourth materially similar attempt is permitted.

F02 remains blocked by completion/acceptance of S02, E20 and X02. X02 remains dependent on X01.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. Do not inspect evaluator-hidden answers from the learner role merely to satisfy cadence.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns. `results/D01-006-authoritative-evidence-and-exam.md` records Gates 10/10 PASS and adversarial exam 20/20 PASS.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. Authoritative workflow `34395556653`, artifact `10121464851`, passed frozen Gates A–J 10/10; frozen exam 20/20. Fresh-AI handoff remains required.

## E20 technical closure / handoff pending

Independent authoritative workflow `34399792261`, artifact `10123146331`, passed frozen Gates A–J 10/10; frozen adversarial exam 20/20. Transport recovery, HostMot2 watchdog/physical-I/O authority and machine authorization remain explicitly separate. `evaluation/E20-fresh-ai-handoff-packet.md` is READY / NOT YET EVALUATED.

## X01 three-attempt reconciliation

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source inspection established `sampler.c::sample()` as a scheduled realtime producer that snapshots inputs and attempts `hal_stream_write()`. FIFO-full failure drops the recorder record and increments `sampler.N.overruns`. `sampler_usr.c::main()` is the userspace reader. The pinned exported `sampler.N.sample-num` pin is not the sequence printed by `halsampler -t`; `-t` reads the HAL stream's implicit sequence.

Preflight attempt 3, workflow `34420657736`, artifact `10130835265`, finally exercised the behavioral fixture. Retained evidence included baseline overruns 0; stop/drain overruns 0 and final depth 0; forced-loss FIFO full with overruns 191 before drain and 202 afterward; deterministic source counter advancing 275 -> 458; narrow timing `servo-thread.time=173`, `tmax=2214`; wide timing `servo-thread.time=859`, `tmax=2546`; both timing cases had producer overruns 0.

The forced-loss trace's `-t` tags nevertheless remained contiguous while deterministic payload cycles were omitted. Therefore the original requirement that producer loss must create a userspace `overrun` marker or `-t` tag gap is invalid for this pinned behavior. Stream tags establish ordering of successful stream records, not necessarily every attempted producer sample.

The next frozen lineage must use deterministic payload-cycle discontinuity plus producer `sampler.0.overruns > 0` as the missing-record oracle and separately verify that the source/control-side cycle counter continues advancing. This is an experiment-model correction, not gate retuning to obtain a pass.

## Exact next-work checkpoint

1. Preserve E20 and S02 as graduation-pending fresh-AI handoff; do not self-certify.
2. Materially redesign X01 after the three-attempt ceiling. Reconcile the original X01-001 predicates/Gates A–J and freeze a new lineage before execution.
3. Forced-loss oracle: deterministic payload-cycle discontinuity + producer `sampler.0.overruns`; treat `halsampler -t` continuity only as successful-stream-record ordering evidence at the pinned revision.
4. Preserve FIFO health, raw trace, process status, topology/thread order, exact source revision and quantitative narrow-vs-wide timing evidence. Preserve the explicit recorder-loss versus control/source-execution distinction.
5. Only after the redesigned preflight exercises its frozen model successfully may a separate unchanged authoritative X01 run launch.
6. X02 remains blocked until X01 produces an accepted recorder-integrity/perturbation contract. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
