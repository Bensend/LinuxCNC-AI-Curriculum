# PB-PREP-001 accepted P0/P1 preflight — independent audit

Date: 2026-09-10

## Scope

This audit promotes the latest PB-PREP-001 run only as **P0/P1 harness validation**. It does not reuse the preflight as P2-P7 behavioral evidence, rank architectures A/B/C, activate F02, satisfy any fresh-AI handoff, or support a physical press-brake safety/hydraulic recommendation.

## Provenance

- Frozen design contract: `experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md`
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Accepted runner source commit: `83fb0ccaa33405a8e27a661cd940b41cfe40c3e6`
- Retained result commit: `a3f742fca0b10146a05b9ceae89bc8c29a4934de`
- GitHub Actions run: `34540107164`
- GitHub Actions job: `103080625697`
- Result: successful

The accepted runner is `lab-jobs/066-pb-prep-001-rev1-oracle-corrected-preflight.sh`, which applies the revision-1 `SYNC_GAIN=1.0` delay-stability correction and aligns the analyzer oracle to that frozen gain without changing behavioral thresholds.

## Independent checks

The retained evidence reports the same 2,500-sample payload length for A, B, and C, with deterministic payload-cycle continuity and no gaps/noncontiguous cycles. Each fixture independently observes a nontrivial common duplicated-Y command step and preserves separate side feedback. Final-command instrumentation is present for every architecture.

The accepted construction also preserves the important causal fix from the earlier failed preflights: the +0.02 differential sign seed is applied only after homing/run enable. That prevents LinuxCNC homing from being asked to reconcile an intentionally displaced synthetic side. `e_diff_used` is retained from the same `prepare()` invocation that creates the correction request, removing the earlier ambiguity caused by sampling post-plant-update feedback.

The validated one-servo-cycle model is explicit: controller preparation runs before the stock PIDs, final limiting and plant update run afterward, and sampling runs last. The synthetic baseline plant is dimensionless and uses

`y_next = y + PLANT_ALPHA * ((gain * u_final) - y)`

with 1 ms servo period, baseline `PLANT_ALPHA=0.05`, baseline side gains 1.0/1.0, `U_MAX=2.0`, `DIFF_MAX=0.25`, stock/common proportional gain 6, and revision-1 `SYNC_GAIN=1.0`.

## Adversarial audit

The preflight would be invalid, not a behavioral failure, if any of the following occurred: pinned-source mismatch; wrong thread ordering; aliased Y1/Y2 feedback; missing common-command movement; sampler gaps/producer loss; seed applied before homing; sign correction derived from a post-update feedback row instead of the causal state; or absence of final-command witnesses. The accepted run passes the retained P0/P1 checks for those categories.

A subtle remaining boundary is important: the preflight only proves that the three software fixtures are wired coherently enough to proceed. It does **not** prove that P3/P4 disturbances discriminate the architectures, that P6 actually creates downstream-only saturation for B, that recovery is acceptable, or that disable/reset semantics meet the frozen P7 invariants. Those questions require a separate execution.

## Accounting note

Run/job identity is positively matched. This audit does not add compute minutes because the currently available Actions connector response confirms the job but does not expose exact job start/completion timestamps. Runtime must be backfilled only from an exact job interval; no run-envelope estimate is permitted.

## Promotion decision

**P0/P1 PREFLIGHT ACCEPTED. P2-P7 REMAINS NOT EXECUTED.**

Next work must freeze the remaining behavioral constants before any P2-P7 result is observed, then implement a separate behavioral runner that preserves the accepted P0/P1 topology and recorder requirements.
