# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02** and **E20** are technically accepted at 2000 level and graduation-pending only their deliberately information-separated fresh-AI handoffs. The current learner must not self-certify either as fresh.

**X01 — recorder perturbation and long-duration retention is ACTIVE at 2000 level in EXPERIMENT.** X01-001 reached the three-attempt ceiling and was classified **ESSENTIAL NOW** after attempt 3 falsified the old forced-loss `halsampler -t` gap oracle. The materially redesigned lineage `experiments/X01-002-sampler-retention-redesign.md` was frozen before execution. Its first non-authoritative preflight is now running as workflow `34428664862`, job `102719239856`, from commit `09116c106fa0b164022c3b52da2a37bbd1739fe7`. The frozen loss oracle is deterministic payload-cycle discontinuity plus producer `sampler.0.overruns > 0`; `-t` continuity is retained only as successful-stream ordering evidence.

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

X01-002 materially redesigns only that falsified loss oracle while preserving the validated fixture family, timing/counts, recorder-health evidence, provenance, and the explicit recorder-loss versus source/control-execution distinction.

## Exact next-work checkpoint

1. Preserve E20 and S02 as graduation-pending fresh-AI handoff; do not self-certify.
2. Inspect only X01-002 workflow `34428664862`, job `102719239856`, and its retained artifact when complete.
3. Verify that P0–P4 actually exercise the frozen X01-002 model: baseline ordering/integrity and zero overruns; bounded stop/drain; P3 FIFO-full + producer overruns + deterministic payload-cycle discontinuity while the independent source counter advances; narrow/wide quantitative timing with zero overruns.
4. Treat `halsampler -t` continuity only as ordering of successful stream records at the pinned revision; do not restore it as a required loss oracle.
5. If the preflight is valid, record the actual job runtime in `LAB_COMPUTE_LOG.md` and launch a separate unchanged authoritative X01-002 run. If invalid, classify the defect without retuning frozen starvation duration, FIFO depth, bounded read count, stop tolerance, or Gates A–J.
6. X02 remains blocked until X01 produces an accepted recorder-integrity/perturbation contract. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
