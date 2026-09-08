# C05-028 attempt 2 — ACCEPTED TEST-CONFIRMED result

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Frozen plan: `experiments/C05-028-feedback-freeze-plan.md`

Harness-only correction commit: `347b282edd70c02a171e3144204231eb2ffd3814`

Authoritative workflow: `34247942092`

Authoritative job: `102134660105`

Recorded lab interval: `2026-09-08T15:56:22Z`–`2026-09-08T16:02:53Z`

Inner exit: `0`

## Verdict

**HARNESS VALID — ACCEPTED — TEST-CONFIRMED.**

The correction changed only how the already-linked sensor selector was driven (`sets` on the sampled signal rather than `setp` on the linked pin) and validated the userspace freeze capture as one finite scalar. Frozen Gates A–H, gains, phase durations, thresholds, topology, `Kc=0.5`, and interpretation boundaries were unchanged.

## Evidence reconciliation

The authoritative run retained the raw realtime trace and process logs. Reported evidence included:

- realtime samples: `5194`;
- sampler overruns: `0`;
- phase 1 samples: `1016`;
- phase 2 samples: `2005`;
- phase 3 samples: `1000`;
- retained realtime trace SHA-256: `484fe1d204216c6cb643e9eb7a77f82f379a796f226ea1b3f796933c5c779ba2`;
- phase-1 `max(abs(measured_B-true_B))`: `0`;
- frozen capture: `1.120037`;
- phase-2 `max(abs(measured_B-freeze_value))`: `0`;
- phase-2 measured-B span: `0`;
- phase-2 true-B span: `13.881798 in`;
- phase-2 maximum `abs(true_B-measured_B)`: `13.994518 in`;
- phase-2 disagreement arithmetic residual: `0`;
- phase-2 correction arithmetic residual: `0`;
- phase-2 PID-B error residual: `4.4408920985e-16`;
- phase-3 `max(abs(measured_B-true_B))`: `0`.

The run printed `gate-A=PASS` through `gate-H=PASS`, `C05-028 overall=PASS`, and `gate-H-cleanup=PASS`.

## Frozen-gate reconciliation

### Gate A — provenance/topology: PASS

The run identified the pinned upstream tree and printed the frozen realtime function order with plant updates preceding sensor transformation, control arithmetic, PID calculation, and sampler capture.

### Gate B — evidence validity: PASS

The raw trace was durably retained, `5194 >= 2500` parseable samples were recorded, decisive phases each exceeded 500 rows, sample progression passed the analyzer, and sampler overruns were zero.

### Gate C — scored configuration integrity: PASS

Scored rows preserved `Kc=0.5`, both toy plant gains at `1.0`, normal sensor selection in phases 1/3, frozen sensor selection in phase 2, and a constant phase-2 freeze value.

### Gate D — normal measurement truth inside the fixture: PASS

The final phase-1 measurement identity residual was exactly zero.

### Gate E — frozen measurement while independent toy state continues moving: PASS

Measured B remained exactly constant at the frozen value while toy true B moved `13.881798 in`; maximum true/measured separation reached `13.994518 in`, far beyond the frozen `0.10 in` threshold.

### Gate F — controller arithmetic uses measured feedback: PASS

Measured-disagreement and `Kc` correction residuals were exactly zero. PID-B error matched `command_B-measured_B` to numerical precision (`4.44e-16`). The controller therefore reacted to the presented frozen measurement, not to hidden access to toy true B.

### Gate G — measurement-path recovery: PASS

Returning the mux to the true-B path restored exact measurement/true-state identity in the final phase-3 window.

### Gate H — boundary/cleanup: PASS

The run preserved the required interpretation boundary and bounded cleanup.

## What this proves

Within this deterministic LinuxCNC/HAL fixture, a feedback path can present a perfectly frozen value while an independently modeled plant state continues changing substantially. Downstream disagreement, cross-correction, and PID error calculations use the feedback value they are wired to receive; they do not infer an unobserved plant truth.

## What this does not prove

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
controller reaction to bad measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor fault handling
```

This test also does not establish a final stale-feedback detector, stop policy, hydraulic/mechanical synchronization law, or safety function.

## C05 continuation

C05-028 satisfies the frozen-feedback evidence requirement. C05 still requires deterministic scale and jump/offset fault evidence, scoring of the already-frozen adversarial exam, a fresh-AI novel-scenario handoff, and promotion/counterfactual review before 1000-level graduation.
