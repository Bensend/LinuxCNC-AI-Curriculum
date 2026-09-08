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

- **Attempt 1** workflow `34250135965`, job `102142142268`: HARNESS INVALID because one stream exceeded LinuxCNC's per-sample item limit.
- **Attempt 2** workflow `34251568612`, job `102147037252`: HARNESS INVALID because wrapper-generation quoting failed before LinuxCNC ran.
- **Attempt 3** workflow `34251704209`, job `102147446647`, commit `7fb5624bfcd271e1103d31bde16571be872c9ec9`: **HARNESS INVALID**. LinuxCNC reached phase 1, FIFO 0 had zero overruns, but FIFO 1 was empty because the split transport deferred its userspace `halsampler` reader until after acquisition. Reconciliation: `results/C05-029-attempt-3-reconciliation.md`.

Three-attempt classification: **ESSENTIAL NOW**. Valid scale/jump evidence remains part of the 1000-level C05 evidence floor. Further work therefore uses a materially redesigned observation transport rather than another deferred-drain patch.

### C05-029 redesigned attempt 4 — RUNNING

Commit `5df6891c4c1b836d9813d58b6fb507ea6b8abaee`, workflow **`34252503889`**. The redesign runs two `halsampler` readers concurrently, one per FIFO, then exact-joins identical realtime sample numbers. Both raw traces, both overrun counters, and unchanged frozen behavioral gates remain required. No behavioral value was changed.

## Exact next-work checkpoint

1. Inspect only workflow `34252503889` until terminal; do not launch a duplicate while active.
2. Reconcile inner exit, both raw traces, both overrun counters, exact same-sample join, selector/config evidence, stdout/stderr, and frozen C05-029 Gates A–H.
3. If harness-valid/pass, commit accepted result, execute fresh-AI novel scenario and promotion/counterfactual audit, then graduate C05 only if those pass.
4. If harness-valid/behavioral failure, retain falsification without retuning.
5. If the materially redesigned transport itself is invalid, reconcile before deciding whether a new experiment family is required under the investigation-control rule.
6. After C05 graduation advance to **C06 — communication/watchdog fault handling**.
7. Backfill authoritative C03–C05 job runtimes in `LAB_COMPUTE_LOG.md`; invalid harness runs count.
