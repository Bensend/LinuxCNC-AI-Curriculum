# BL-DEV-002 Transfer 01 — Immutable Learner Precommit

Date: 2026-09-09
Bank: development transfer
Level / competency: 1000 / motion following-error threshold retrieval and application
Blind status at commitment: VALID CANDIDATE — pinned implementation/oracle not inspected during this attempt before this commit.

## Challenge
At the pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, consider a joint configured with:

- `FERROR = 0.8`
- `MIN_FERROR = 0.04`
- joint velocity limit = `4.0` units/s

Evaluate two independent servo-cycle snapshots, assuming the joint is otherwise in the state where following-error checking applies:

- Snapshot A: `abs(vel_cmd) = 0.5` units/s and absolute command-feedback position error = `0.09` units.
- Snapshot B: `abs(vel_cmd) = 0.1` units/s and absolute command-feedback position error = `0.05` units.

Predict whether each snapshot exceeds the following-error limit and identify the mechanism. Do not inspect the pinned implementation until after this precommit is durable.

## Prediction / diagnosis
Snapshot A should **not** exceed the following-error limit. Snapshot B **should** exceed it.

## Mechanism believed responsible
The retained correction from BL-DEV-002 is that the allowed following error is velocity-scaled and then floored, not endpoint interpolation:

`allowed = max(MIN_FERROR, FERROR * abs(vel_cmd) / vel_limit)`

Therefore:

- A: scaled allowance = `0.8 * 0.5 / 4.0 = 0.10`; max with `0.04` remains `0.10`. Observed error `0.09 < 0.10`, so no following-error trip is predicted.
- B: scaled allowance = `0.8 * 0.1 / 4.0 = 0.02`; the `MIN_FERROR` floor raises allowance to `0.04`. Observed error `0.05 > 0.04`, so a following-error trip is predicted.

## Expected external observation
Pinned source should show the velocity-proportional `FERROR` expression combined with a `MIN_FERROR` lower bound. If an executable oracle is practical, snapshot A should remain below the computed threshold while snapshot B should cross it.

## Diagnostic path
After this commit, inspect the pinned motion source that computes the dynamic following-error limit and the branch comparing actual following error to that limit. Prefer the implementation over documentation wording.

## Plausible alternatives
A version could use endpoint interpolation, a different velocity measure, inclusive (`>=`) rather than strict (`>`) comparison, or clamp the scaling ratio before the floor. Any of those would require revising this prediction if present at the pinned revision.

## Falsifier
The primary hypothesis is falsified if pinned source does not compute the allowance as the maximum of `MIN_FERROR` and the velocity-scaled `FERROR`, or if the actual trip comparison changes either snapshot outcome.

Confidence: **95%**
Solve time: **0.6 min**
Resources consulted before commitment: learner-readable curriculum state only, including `evaluation/FEEDBACK_SCORE_LOG.md`; pinned motion implementation/oracle deliberately withheld until after commit.
