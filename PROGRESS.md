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

Primary artifacts: `guides/C05-feedback-sensor-failure-research.md`, `call-flows/C05-true-state-to-faulted-feedback.md`, `experiments/C05-028-feedback-freeze-plan.md`, `experiments/C05-029-scale-jump-plan.md`, `guides/C05-029-single-row-observation-redesign.md`.

### C05-028 — TEST-CONFIRMED

Accepted attempt 2 workflow `34247942092`, job `102134660105`, result `results/C05-028-attempt-2-accepted.md`: 5194 realtime samples, zero overruns, frozen measured-B span 0 while toy true-B moved 13.881798 in, max true/measured separation 13.994518 in, arithmetic residuals at floating-point zero, recovery exact. Frozen Gates A–H PASS.

### C05-029 — frozen wrong-scale + jump/offset experiment

Frozen before implementation: `normal_B=true_B`, `scaled_B=1.20*true_B`, `jumped_B=true_B+0.50 in`. Gates A–H, gains, thresholds, phase durations and transforms may not be retuned after observation.

Attempts 1–7 were harness-invalid. The split-FIFO exact-join family is permanently retired under the repeated-attempt investigation-control rule.

Attempt 8 workflow `34261998718`, job `102181993196`, artifact `10070374620`, source `6406794f52f7e299705595de8c1d859235bb2d09` successfully exercised the redesigned **single 20-field realtime FIFO**: provenance/topology passed, the fixture homed and entered MDI, zero sampler overruns were reported, and 6,571 raw rows were retained. It is still **HARNESS INVALID** because the inherited analyzer generator deleted its closing `PY` here-document delimiter, so frozen analysis and cleanup never executed. Reconciliation: `results/C05-029-attempt-8-reconciliation.md`.

Attempt-8 raw evidence plus pinned source exposed a second observation boundary: pinned `src/hal/components/sampler_usr.c` serializes `HAL_REAL` with `%f`, limiting text to six fractional decimals and introducing roughly `1e-6` quantization into equations whose frozen residual threshold is `1e-9`. The threshold was not weakened. Source guide `guides/C05-029-single-row-observation-redesign.md` now requires an explicit observer-only `%f` -> `%.17g` build patch, with diff/hash evidence, while leaving realtime LinuxCNC/controller/fault behavior unchanged.

Attempt 9 workflow `34262965164`, job `102185236542`, artifact `10070659035` was **HARNESS INVALID** before configure because a nested generated Python observer block leaked Python syntax into shell. Attempt 10 workflow `34263179781`, job `102185951531`, artifact `10070739669` was **HARNESS INVALID** before configure because the observer shell was emitted as a Python raw string, leaving literal `\n` characters instead of shell line breaks. Reconciliations: `results/C05-029-attempt-9-reconciliation.md` and `results/C05-029-attempt-10-reconciliation.md`.

Attempt 11 is launched from `lab-jobs/040-c05-scale-jump-atomic-precision-final.sh`, source commit `374e4c159a18e340a70b014a375f8e1fe7edb04d`, authoritative workflow **`34263426729`**, job **`102186773618`**. It changes only the reproduced generator defect (`obs_shell` raw-string -> normal-string semantics); the one-FIFO field map, high-precision observer design, analyzer delimiter correction, frozen Gates A-H and all behavioral parameters are unchanged. At this checkpoint the job is still executing, so no C05-029 behavioral verdict is recorded and no duplicate should be launched.

## Exact next-work checkpoint

1. Inspect only workflow `34263426729`, job `102186773618` after completion; do not launch a duplicate while it is running.
2. Require the artifact to prove the exact pinned checkout plus an explicit observer-only `sampler_usr.c` diff/hash changing only `printf("%f")` to `printf("%.17g")` for `HAL_REAL` serialization.
3. Require one raw 20-field realtime FIFO trace, strictly increasing sample numbers, zero overruns, all phase/transition rows retained, and frozen Gates A–H unchanged.
4. If the run is harness-valid, reconcile the result against the already-frozen scale/jump equations and `1e-9` residual thresholds without retuning. A genuine behavioral failure remains falsifying evidence.
5. If harness-valid/pass, commit the accepted C05-029 result, execute fresh-AI transfer and promotion/counterfactual audit, and graduate C05 only if those pass.
6. After C05 graduation advance to **C06 — communication/watchdog fault handling**.
7. Backfill C05-029 attempts 8 onward compute from authoritative job timestamps; C03/C04 historical backfill remains queued and non-blocking.
