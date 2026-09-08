# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05 — custom operator interface patterns**, **C01 — simulated dual-actuator machine**, **C02 — independent feedback loops**, **C03 — explicit cross-coupling**, and **C04 — asymmetric actuator response** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is **C05 — feedback sensor failure modes**, state **CORRECTIONS / EXPERIMENT**.

C05 now has documentation/community/source analysis, a pinned function-order model, a frozen first experiment, a retained invalid first attempt, a harness-only correction, and a frozen adversarial exam. It is **not graduated** and has no TEST-CONFIRMED C05-028 behavioral result yet.

## Blind external-feedback state

### BL-DEV-001

Valid blind development baseline: **10/10, 92% confidence**. See:

- `evaluation/development/BL-DEV-001-precommit.md`
- `evaluation/development/BL-DEV-001-evaluation.md`

### BL-DEV-002

A second development challenge was immutably precommitted before inspecting the pinned oracle during the current C05 session.

Result: **VALID, 9/10, 88% confidence, 0.8 min**.

The behavioral prediction was correct, but the learner recalled LinuxCNC's following-error threshold as endpoint interpolation between `MIN_FERROR` and `FERROR`. Pinned `src/emc/motion/control.c` instead computes the inspected path as:

```text
ferror_limit = FERROR * abs(vel_cmd) / joint_vel_limit
ferror_limit = max(ferror_limit, MIN_FERROR)
trip when abs_ferror > ferror_limit
```

For the challenge values the exact limit is `0.5 in`, not `0.505 in`, and a `0.30 in` error does not trip.

Durable records:

- `evaluation/development/BL-DEV-002-precommit.md`
- `evaluation/development/BL-DEV-002-evaluation.md`
- `evaluation/FEEDBACK_SCORE_LOG.md`

Because this was a mechanism-precision miss, schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons rather than immediately repeating the same surface problem.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Accepted C01-023 proved same-cycle duplicated Y command equality in the deterministic fixture after correcting a sequential-userspace observation defect.

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

C02 established that two PID instances receiving a common command retain separate command/feedback/error/output state and can diverge under an asymmetric plant disturbance.

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

Accepted C03-025 showed that an explicit `Kc=0.5` relative-feedback coupler reduced deterministic simulated disagreement, after preserving two HARNESS INVALID phase-publication attempts.

Retained boundary:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

## C04 — asymmetric actuator response — GRADUATED 1000

C04 preserved a legitimate source-semantic falsification: directly changing PID `maxoutput` from a binding nonzero limit to zero can leave stale saturation telemetry at the pinned revision because the `limit_state` clear/update is inside the nonzero-`maxoutput` branch.

Source-corrected C04-027 used a deliberately huge finite nonbinding recovery sentinel so the explicit clear branch executed; authoritative workflow `34244865738`, job `102124147558`, artifact `10063683101`, source `4a9412e0d83dedfcd32bd6543cd0cf00231d40bf`, inner exit 0, Gates A-H PASS. The adversarial exam scored 10/10 and fresh-AI/promotion audits passed.

Retained boundaries:

```text
corrected command separation
!= available local actuator authority
!= achieved plant response
!= feedback convergence
```

```text
pid.saturated telemetry
must be interpreted with current maxoutput + enable + transition history + pinned source
!= self-authenticating proof of present physical saturation
```

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

Primary durable C04 records remain in `guides/`, `experiments/`, `results/`, and `evaluation/` under the C04 names.

## C05 — feedback sensor failure modes — CORRECTIONS / EXPERIMENT

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Research/source model

Current documentation and pinned source establish the observation model:

- encoder position is a scaled measurement product; raw counts remain separately observable;
- pinned `integ.comp` advances an independent deterministic toy plant as `out += gain * in * fperiod` when its function executes;
- pinned `mux4.comp` selects one float input and adds no plausibility diagnosis;
- pinned `scale.comp` computes `out = in * gain + offset` and adds no diagnosis.

C05 therefore explicitly separates **fixture/toy plant truth** from **measured feedback**.

Durable records:

- `guides/C05-feedback-sensor-failure-research.md`
- `call-flows/C05-true-state-to-faulted-feedback.md`
- `experiments/C05-028-feedback-freeze-plan.md`
- `evaluation/C05-adversarial-exam.md`

Frozen C05 local realtime order:

```text
motion command/controller
-> plant A/B update using prior-cycle PID effort
-> B sensor transformation / mux
-> measured disagreement + cross-correction
-> local PID A/B
-> realtime residual helpers
-> sampler
```

The resulting row can bind current toy plant state, selected measurement, controller arithmetic and newly calculated control output; that new output affects the next toy-plant update.

Retained boundary:

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
controller reaction to bad measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor fault handling
```

### C05-028 attempt 1 — HARNESS INVALID

Authoritative workflow `34246869855`, job `102131002815`, source commit `5f4f0a765f577921e4c338953e016213a3b59f25`, recorded interval `2026-09-08T15:46:15Z`–`15:49:34Z`, result commit `6081e494074c8b808d7882e36833b4de57f940bb`.

It failed before decisive behavioral phases with:

```text
pin 'c05-sensor-b.sel0': not writable
```

Root cause: `sel0` was intentionally connected to signal `c05-sensor-freeze` so selector state could be sampled in realtime, but the shell later tried to `setp` the linked pin. This is a harness configuration error, not sensor-behavior evidence.

Reconciliation: `results/C05-028-attempt-1-reconciliation.md`.

No frozen gate, numerical threshold, PID/plant gain, phase duration, or `Kc=0.5` value was changed.

### C05-028 attempt 2 — running authoritative correction

Harness-only correction commit: `347b282edd70c02a171e3144204231eb2ffd3814`.

Correction:

- drive the existing sampled selector **signal** with `halcmd sets c05-sensor-freeze`, rather than writing the linked mux pin;
- parse and validate the phase-0 userspace freeze capture as one finite scalar float;
- preserve frozen Gates A-H unchanged.

Authoritative workflow: **`34247942092`**.

Job: **`102134660105`**.

At the latest checkpoint the job is still executing its single selected lab job. **Do not launch a duplicate and do not make a TEST-CONFIRMED claim.**

## Exact next-work checkpoint

1. Inspect only workflow `34247942092`, job `102134660105` until it reaches a terminal state.
2. Reconcile the inner exit, raw realtime trace, stdout/stderr, selector/config rows and each unchanged C05-028 Gate A-H. Preserve evidence even if analysis fails.
3. If attempt 2 is HARNESS VALID and passes, commit an accepted C05-028 result and freeze the next scale/jump experiment before implementation using the same verified true-state/measurement observation model.
4. If attempt 2 is HARNESS VALID but fails a behavioral gate, preserve the failure as behavioral evidence; do not retune the frozen thresholds/gains after seeing it.
5. If attempt 2 exposes another genuine harness defect, document it explicitly before deciding whether another run is permitted under the retry/investigation rules.
6. C05 still requires deterministic **scale** and **jump/offset** fault evidence, the already-frozen adversarial exam, fresh-AI transfer, and promotion/counterfactual audit before graduation.
7. Backfill authoritative C03-C05 laboratory compute in `LAB_COMPUTE_LOG.md`, including invalid runs rather than hiding them.

## Laboratory compute / timing notes

`LAB_COMPUTE_LOG.md` is the authoritative compute ledger. C03 and later authoritative jobs still require complete backfill where missing. Invalid harness attempts count toward compute cost.
