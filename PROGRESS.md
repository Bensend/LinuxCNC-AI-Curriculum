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

### C05-029 materially redesigned concurrent-reader family

- **Redesigned attempt 4** workflow `34252503889`, job `102150101026`, commit `5df6891c4c1b836d9813d58b6fb507ea6b8abaee`: **HARNESS INVALID before LinuxCNC behavior** because the isolated generator root omitted inherited `028-c05-feedback-freeze.sh`.
- **Redesigned attempt 5** workflow `34252609192`, job `102150452717`, commit `c411b8e2622521c5124ec217159a88cea7a084be`, artifact `10066749535`: **HARNESS INVALID after LinuxCNC execution**. Both concurrent readers ran, but exact same-sample join rejected one terminal sample present only in FIFO A: `onlyA=[6564] onlyB=[]`. Root cause is the observation harness stopping `sampler.0` and `sampler.1` with two sequential userspace writes, allowing one servo cycle between writes. Reconciliation: `results/C05-029-attempt-5-reconciliation.md`.
- **Redesigned attempt 6** commit `daea4944fff7d979b1e991481e5be7a1ca375dd0`, workflow **`34256027036`**: **RUNNING**. Harness-only correction retains both concurrent userspace readers and the unchanged exact sample-number join, but replaces the two sequential per-sampler disable writes with one post-acquisition `halcmd stop`. Pinned source shows `halcmd stop -> do_stop_cmd() -> hal_stop_threads()`, so both sampler functions in the same servo thread cease at the realtime-thread boundary rather than at two independently timed userspace writes. Gates A–H and every behavioral value remain frozen.

## Exact next-work checkpoint

1. Inspect only workflow `34256027036` until terminal; do not launch a duplicate while active.
2. Reconcile inner exit, both complete raw traces, both overrun counters, exact identical-sample-number join, selector/config evidence, stdout/stderr, and every unchanged C05-029 Gate A–H.
3. If harness-valid/pass, commit accepted result, execute the already-required fresh-AI novel scenario and promotion/counterfactual audit, then graduate C05 only if those pass.
4. If harness-valid/behavioral failure, retain falsification without retuning.
5. If redesigned attempt 6 is harness-invalid, apply the repeated-attempt investigation-control rule to this redesigned family before any further laboratory run; do not silently patch-and-rerun.
6. After C05 graduation advance to **C06 — communication/watchdog fault handling**.
7. `LAB_COMPUTE_LOG.md` is backfilled through C05-029 attempt 5. Add attempt 6 from authoritative job timestamps after completion; C03/C04 historical backfill remains queued but does not block C05.
