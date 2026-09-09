# BL-DEV-002 Transfer 01 — Oracle Reveal and Score

Date: 2026-09-09
Precommit: `evaluation/BL-DEV-002-TRANSFER-01-precommit.md`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Blind validity: **VALID**. The learner precommit was committed before the pinned `control.c` oracle was inspected for this attempt.

## Oracle
Pinned `src/emc/motion/control.c` computes absolute following error, then:

1. if `joint->vel_limit > 0`, sets `joint->ferror_limit = joint->max_ferror * fabs(joint->vel_cmd) / joint->vel_limit`;
2. otherwise starts from zero;
3. floors the resulting limit to `joint->min_ferror` when it is smaller;
4. asserts the joint following-error flag only when `abs_ferror > joint->ferror_limit`.

This independently confirms the learner's retained mechanism and also resolves the comparison alternative: the pinned branch is strict `>` rather than `>=`.

## Snapshot scoring

- Snapshot A: dynamic allowance `0.8 * 0.5 / 4.0 = 0.10`, above the `0.04` floor. Error `0.09` is below `0.10`: **no trip**, matching prediction.
- Snapshot B: dynamic allowance `0.8 * 0.1 / 4.0 = 0.02`, raised by the floor to `0.04`. Error `0.05` is above `0.04`: **trip**, matching prediction.

## Score

- Prediction / diagnosis: 2/2
- Mechanism: 2/2
- Diagnostic efficiency: 2/2
- Uncertainty / safety boundary: 2/2
- Confidence calibration: 2/2

**Total: 10/10**
Precommit confidence: **95%**
Precommit solve time: **0.6 min**
Primary error class: **none**

## Transfer interpretation

The BL-DEV-002 retrieval correction transferred successfully to a different numeric surface problem. The earlier endpoint-interpolation mistake was not repeated. This is evidence that the exact velocity-scaled-plus-floor mechanism is now retrievable, but it does not by itself establish long-delay retention; keep the later retention checkpoint separate.
