# C02-024 attempt 1 reconciliation

## Classification

**HARNESS INVALID for final acceptance.** This is not a behavioral failure of LinuxCNC PID and does not change frozen Gates A–H or their thresholds.

## Authoritative run

- Workflow: `34219392130`
- Job: `102038671214`
- Source commit: `fd7e812108f1161e2e575aad6b864b3dd04bdfcc`
- Repository result commit: `3297cc5b2805d387d8304a0c3c65a1ac70cbccaa`
- Inner exit: `43`
- Finished UTC: `2026-09-08T11:15:20Z`
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Useful evidence retained from the run

The run did exercise the intended two-loop topology and produced strong evidence for the main C02 prediction before the final disabled-loop check:

- 7,864 realtime sample numbers (`0..7863`) were observed.
- Phase 1: 1,011 samples.
- Phase 2 B-only disturbance: 2,015 samples.
- Phase 3 recovery: 1,511 samples.
- Phase 4 disable: 1,011 samples.
- Decisive shared-command span: `3.025` in.
- Baseline feedback-A span: `1.005547` in.
- Baseline feedback-B span: `1.004048` in.
- B-only plant disturbance produced maximum A/B feedback separation `0.6501`, error separation `0.6501`, and output separation `2.600399`; all 2,015 disturbance samples exceeded the frozen `1e-4` feedback-separation threshold.

This supports the prediction that a common command does not collapse two independent feedback/control states into one state.

## Why the attempt is invalid for acceptance

The final disabled-B check combined **userspace observation of PID enable state** with **realtime-sampled PID output**. Those observations are not guaranteed to describe the same servo cycle. The apparent `disabled-b-max-output-after-settle=5.046094` therefore cannot be used to falsify the pinned PID implementation, whose disabled branch forces its own output to zero and resets controller state.

The run also failed the evidence-retention requirement: the complete raw realtime sampler trace was not copied into the workflow artifact on the failing analysis path. A numerical summary without the underlying same-cycle records is not sufficient for the frozen Gate H claim.

The baseline `0.001499` A/B feedback separation is also interpreted with the documented servo staging boundary in mind: PID calculations precede both plant updates and the sampler observes post-plant values. It is not evidence of implicit cross-loop synchronization or its absence by itself.

## Correction, with frozen gates unchanged

Attempt 2 changes only observation/evidence mechanics:

1. Sample PID-A enable and PID-B enable as realtime `sampler` bit fields in the **same record** as command, feedback A/B, error A/B, output A/B, and phase.
2. Evaluate Gate H only on records proving `A enabled && B disabled` in that same servo observation.
3. Preserve the complete raw sampler trace, LinuxCNC stdout/stderr, and sampler stderr into the workflow workspace from the cleanup trap even when analysis exits nonzero.
4. Keep the B-only `1.0 -> 0.25` plant-gain disturbance and all frozen thresholds unchanged.

Correction implementation: `lab-jobs/024-c02-independent-feedback-disturbance-correction.sh`, commit `bca881e1788b6f704a2567e6185940e36c2317a3`.

## Durable engineering boundary

`shared command != shared feedback state != shared control effort != synchronized physical plant != safety-rated protection`

A software PID disable/output-zero observation is likewise not proof that asymmetric actuation of a real dual-actuator machine is safe.
