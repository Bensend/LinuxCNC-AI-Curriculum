# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05 — custom operator interface patterns**, **C01 — simulated dual-actuator machine**, **C02 — independent feedback loops**, **C03 — explicit cross-coupling**, and **C04 — asymmetric actuator response** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is **C05 — feedback sensor failure modes**, state **CORRECTIONS / EXPERIMENT**.

C05 now has accepted TEST-CONFIRMED frozen-feedback evidence, a **10/10** scored adversarial exam, a source-grounded scale/jump plan frozen before implementation, and retained invalid scale/jump harness attempts. C05 is **not yet graduated** because C05-029 still requires one valid scale/jump result plus fresh-AI transfer and promotion/counterfactual review.

## Blind external-feedback state

- **BL-DEV-001:** VALID, **10/10, 92% confidence**.
- **BL-DEV-002:** VALID, **9/10, 88% confidence**. The learner correctly predicted no following-error trip but imprecisely recalled threshold construction. Pinned `control.c` uses velocity-scaled `FERROR` followed by a `MIN_FERROR` floor. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons rather than repeating the same surface problem immediately.

Durable records are under `evaluation/development/` and `evaluation/FEEDBACK_SCORE_LOG.md`.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Retained boundary:

```text
same coordinated command
!= same observation instant
!= independent feedback agreement
!= same physical position
!= synchronized plant
!= safety-rated protection
```

## C02 — independent feedback loops — GRADUATED 1000

Retained boundary:

```text
shared command
!= shared feedback state
!= shared control error
!= synchronized physical plant
!= implicit cross-coupling
!= safety-rated disagreement protection
```

## C03 — explicit cross-coupling — GRADUATED 1000

Accepted C03-025 established reduced disagreement in its deterministic simulation with explicit `Kc=0.5` cross-coupling while preserving invalid phase-publication attempts.

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

## C04 — asymmetric actuator response — GRADUATED 1000

C04 preserved the pinned PID `maxoutput`/saturation-telemetry transition nuance and accepted the source-corrected experiment, adversarial exam, fresh-AI transfer, and promotion audit.

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

## C05 — feedback sensor failure modes — CORRECTIONS / EXPERIMENT

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Source / call-flow model

Pinned components establish:

- `integ.comp`: independent toy state advances as `out += gain * in * fperiod`;
- `scale.comp`: `out = in * gain + offset` with no plausibility diagnosis;
- `mux4.comp`: selects an input and provides no sensor-health semantics;
- local controller arithmetic therefore consumes the value wired as feedback, not hidden plant truth.

Frozen local order:

```text
motion command/controller
-> toy plant A/B update using prior-cycle PID effort
-> sensor transforms / mux
-> measured disagreement + cross-correction
-> PID A/B
-> residual helpers
-> realtime sampler
```

Retained boundary:

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
wrong measured scale != proven physical scale change
measurement jump != proven physical position jump
controller reaction to corrupted measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor-fault handling
```

Primary research records:

- `guides/C05-feedback-sensor-failure-research.md`
- `call-flows/C05-true-state-to-faulted-feedback.md`
- `experiments/C05-028-feedback-freeze-plan.md`
- `experiments/C05-029-scale-jump-plan.md`

### C05-028 feedback freeze — TEST-CONFIRMED

Attempt 1, workflow `34246869855`, job `102131002815`, is retained **HARNESS INVALID** because the shell attempted `setp` on an intentionally linked mux selector pin.

Corrected attempt 2:

- workflow **`34247942092`**;
- job **`102134660105`**;
- harness correction commit `347b282edd70c02a171e3144204231eb2ffd3814`;
- accepted-result commit `30507fa659648906c2ead0f26f9f488189baa678`;
- inner exit `0`;
- `5194` realtime samples, zero overruns;
- frozen measured-B span `0`;
- toy true-B span during freeze `13.881798 in`;
- max toy true/measured separation `13.994518 in`;
- disagreement and correction residuals `0`;
- PID-B error residual `4.44e-16`;
- recovery restored exact fixture identity;
- frozen Gates A–H **PASS**.

Verdict: **HARNESS VALID — ACCEPTED — TEST-CONFIRMED**.

Durable result: `results/C05-028-attempt-2-accepted.md`.

### C05 adversarial exam

The exam was frozen before valid experiment-result review and is now scored **10/10 PASS** in `evaluation/C05-adversarial-exam-scored.md` (commit `4c4997cd15d1ad2543fbe685aad0c916cc4ac071`).

### C05-029 wrong-scale + jump/offset — frozen experiment

Plan frozen before implementation: `experiments/C05-029-scale-jump-plan.md`, commit `1be32147f7240ea2075ad5f0b967de2866d35765`.

Frozen transformations:

```text
normal_B = true_B
scaled_B = 1.20 * true_B
jumped_B = true_B + 0.50 in
```

Frozen Gates A–H require retained realtime evidence, exact transform relationships, true-B movement under scale fault, an actual consecutive-sample realtime selector-edge proof for the `+0.50 in` jump, controller arithmetic tied to measured B, normal recovery, and the interpretation boundary above. No gain, threshold, phase duration, transform, or behavioral gate may be retuned after seeing a result.

#### C05-029 attempt 1 — HARNESS INVALID

Workflow **`34250135965`**, job **`102142142268`**, implementation commit `90a15ac75fc92d602b474b1e27965fe023183c5c`.

Runtime failed before behavioral phases because one sampler stream requested 23 values. LinuxCNC rejected it with `stream: ERROR: more than 21 items`. Current stream documentation limits one sample to twenty values. Reconciliation: `results/C05-029-attempt-1-reconciliation.md`, commit `7b6d485b7726fd082b42285039d4d62c6a5f9d8a`.

Correction strategy: preserve every frozen field by splitting them across two sampler FIFOs in the same servo thread, require zero overruns on both, retain both raw traces, and exact-join only identical tagged sample numbers.

#### C05-029 attempt 2 — HARNESS INVALID

Workflow **`34251568612`**, job **`102147037252`**, split-sampler commit `6a151ae686c034de7bb64b276c0d2fde452dec46`.

It failed immediately in the wrapper generator with a Python `SyntaxError`: an outer triple-single-quoted injected string accidentally contained inner triple-single-quoted strings. LinuxCNC and the behavioral experiment never ran. No behavioral conclusion is permitted.

#### C05-029 attempt 3 — authoritative quoting-only repair RUNNING

Commit: **`7fb5624bfcd271e1103d31bde16571be872c9ec9`**.

Workflow: **`34251704209`**.

Job: **`102147446647`**.

The only new change repairs the generator's outer quoting so the already-defined split-FIFO observation harness can execute. Frozen Gates A–H and all behavioral values remain unchanged. At this checkpoint the job is executing its single selected lab script. **Do not launch a duplicate and do not make a TEST-CONFIRMED claim until this exact run is terminal and reconciled.**

## Exact next-work checkpoint

1. Inspect only workflow `34251704209`, job `102147446647` until terminal.
2. Reconcile inner exit, both raw sampler traces, exact sample-number join, both FIFO overrun counters, selector/config evidence, stdout/stderr, and unchanged C05-029 Gates A–H.
3. If HARNESS VALID and passing, commit the accepted C05-029 result; then perform the required fresh-AI novel-scenario handoff and promotion/counterfactual audit. Graduate C05 only if those checks pass without weakening the safety/causal boundaries.
4. If HARNESS VALID but a behavioral gate fails, retain the falsification; do not retune the frozen gains, offsets, thresholds, phase durations, or gates after observation.
5. If another genuine harness defect occurs, retain and reconcile it before any further retry.
6. After C05 graduation, advance to **C06 — communication/watchdog fault handling** according to the Phase-10 dependency graph.
7. Backfill authoritative C03–C05 laboratory compute in `LAB_COMPUTE_LOG.md`; invalid harness runs count.

## Laboratory compute / timing notes

`LAB_COMPUTE_LOG.md` remains the authoritative ledger. Invalid attempts count toward compute cost rather than disappearing from the budget.
