# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, and **C04** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C05 — feedback sensor failure modes**, state **CORRECTIONS / EXPERIMENT**.

C05 has accepted TEST-CONFIRMED C05-028 frozen-feedback evidence and a **10/10** adversarial exam. It is not graduated because frozen C05-029 scale/jump verification still needs one harness-valid result, followed by fresh-AI transfer and promotion/counterfactual review.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons.

## C05 retained causal/safety boundary

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
wrong measured scale != proven physical scale change
measurement jump != proven physical position jump
controller reaction to corrupted measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor-fault handling
```

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary artifacts: `guides/C05-feedback-sensor-failure-research.md`, `call-flows/C05-true-state-to-faulted-feedback.md`, `experiments/C05-028-feedback-freeze-plan.md`, `experiments/C05-029-scale-jump-plan.md`.

### C05-028 — TEST-CONFIRMED

Accepted attempt 2 workflow `34247942092`, job `102134660105`, result `results/C05-028-attempt-2-accepted.md`: 5194 realtime samples, zero overruns, frozen measured-B span 0 while toy true-B moved 13.881798 in, max true/measured separation 13.994518 in, arithmetic residuals at floating-point zero, recovery exact. Frozen Gates A–H PASS.

### C05-029 — frozen wrong-scale + jump/offset experiment

Frozen before implementation: `normal_B=true_B`, `scaled_B=1.20*true_B`, `jumped_B=true_B+0.50 in`. Gates A–H, gains, thresholds, phase durations and transforms may not be retuned after observation.

Attempts 1–3 were harness-invalid; after the three-attempt rule C05-029 was classified **ESSENTIAL NOW** and the observation transport was materially redesigned. Attempts 4–7 in the concurrent-reader family were also harness-invalid for staging or cross-FIFO termination/alignment reasons. Attempt 7 authoritative workflow `34256658628`, job `102164080412`, source `5fba233b8dee0dca10df8ef224e75af565f16e1a`, artifact `10068261174` reached the LinuxCNC fixture, passed provenance/topology, homed, entered MDI, published phase 1, and reported zero sampler overruns, but exited 1 before behavioral analysis. Reconciliation: `results/C05-029-attempt-7-reconciliation.md`.

The concurrent split-FIFO exact-join family is now **retired** under the repeated-attempt investigation-control rule. No more sleep/drain/reader-kill timing patches are justified. Zero FIFO overruns do not establish identical retained terminal sample sets across two independent userspace readers.

## Exact next-work checkpoint

1. Inventory only the quantities required to score frozen C05-029 Gates A–H and verify whether they fit one pinned LinuxCNC `sampler` channel.
2. Document a single-row realtime field map. Prefer one sampler FIFO so all decisive fields are one atomic servo-cycle record and cross-FIFO alignment disappears from the evidence chain.
3. If the fields cannot fit, design a realtime packing/reduction layer whose outputs are themselves atomically sampled; do not return to split-FIFO timing patches.
4. Preserve frozen Gates A–H and every behavioral value unchanged; preserve the raw trace before analyzer exit and retain explicit overrun evidence.
5. Only after the transport design is source-audited, implement and launch one authoritative run. No interpolation, nearest-neighbor matching, row deletion, or phase relabeling is allowed.
6. If harness-valid/pass, commit accepted result, execute fresh-AI transfer and promotion/counterfactual audit, and graduate C05 only if those pass. If harness-valid/behavioral failure, retain falsification without retuning.
7. After C05 graduation advance to **C06 — communication/watchdog fault handling**.
8. Backfill C05-029 attempt 6/7 compute from authoritative job timestamps; C03/C04 historical backfill remains queued but does not block C05.
