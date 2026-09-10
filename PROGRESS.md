# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02** and **E20** are technically accepted at 2000 level and graduation-pending only their deliberately information-separated fresh-AI handoffs. The current learner must not self-certify either as fresh.

**X01 — recorder perturbation and long-duration retention is ACTIVE at 2000 level in EXPERIMENT.** X01-001 reached the three-attempt ceiling and was classified **ESSENTIAL NOW** after attempt 3 falsified the old forced-loss `halsampler -t` gap oracle. The materially redesigned lineage `experiments/X01-002-sampler-retention-redesign.md` is now preflight-validated from retained artifact `10133717168`: baseline and stop/drain integrity passed, forced FIFO saturation produced producer overruns plus a deterministic payload-cycle gap while `-t` tags remained contiguous, and quantitative timing evidence was retained with zero overruns. A separate authoritative X01-002 run is now active as workflow `34432706789` from commit `eaea57d58fb6c60e3ea30e1a6cc3e2f22a59101d`; P0–P4 are unchanged and P5 was predeclared at 10,000 retained narrow-config records before launch.

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

## X01 redesigned-preflight reconciliation

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source inspection established `sampler.c::sample()` as a scheduled realtime producer that snapshots inputs and attempts `hal_stream_write()`. FIFO-full failure drops the recorder record and increments `sampler.N.overruns`. `sampler_usr.c::main()` is the userspace reader. The pinned exported `sampler.N.sample-num` pin is not the sequence printed by `halsampler -t`; `-t` reads the HAL stream's implicit sequence.

X01-001 attempt 3 established the material redesign requirement: FIFO saturation and producer overruns coexisted with contiguous `-t` tags while deterministic payload cycles were omitted. X01-002 therefore uses payload-cycle discontinuity plus producer overruns as the recorder-loss oracle and treats `-t` only as successful-stream ordering evidence.

X01-002 non-authoritative workflow `34428664862`, job `102719239856`, artifact `10133717168`, completed successfully and was independently audited at the artifact level. P1 retained 2,000 contiguous payload/tag rows with zero overruns; P2 drained exactly 353 retained rows with zero overruns and landed at the frozen 3-cycle stop-boundary tolerance; P3 showed `full=TRUE`, overruns 191 -> 201, source counter 273 -> 456, zero consumer overrun markers, zero tag gaps, and one deterministic payload gap; P4 retained narrow/wide timing evidence with zero overruns. The preflight is VALID. Exact job runtime was 267 s = 4.45 min.

P5 was selected before authoritative launch at 10,000 retained records using `ffffb`, concurrent draining, zero producer overruns, contiguous successful-stream tags and payload cycles, with raw trace/health/provenance retained together. This is a bounded nominal ~10 s producer interval at the 1 ms fixture period, not a physical-hardware or deadline guarantee.

## Exact next-work checkpoint

1. Preserve E20 and S02 as graduation-pending fresh-AI handoff; do not self-certify.
2. Inspect only authoritative X01-002 workflow `34432706789`, its job metadata, and retained artifact when complete.
3. Verify unchanged P0–P4 behavior plus the predeclared P5 10,000-record sustained publication proof. Workflow success alone is not the oracle.
4. Score frozen Gates A–J only from the retained authoritative evidence. Treat `halsampler -t` continuity only as ordering of successfully retained stream records at the pinned revision; do not restore it as a required loss oracle.
5. Record exact authoritative job runtime in `LAB_COMPUTE_LOG.md`. The completed preflight `34428664862` consumed 4.45 min and is recorded in `results/X01-002-preflight-reconciliation.md`; canonical compute-ledger integration remains required if not yet present.
6. If authoritative X01-002 passes, finish X01 failure analysis/adversarial exam/fresh-AI handoff and decide graduation before unblocking X02. If it fails, classify the failure without retuning frozen P3 starvation duration, FIFO depth, bounded read count, stop tolerance, P5 count, or Gates A–J.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
