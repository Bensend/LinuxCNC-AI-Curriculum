# Safety curriculum checkpoint — 25E0 validation/commissioning next

UTC checkpoint: 2026-09-23T19:48Z

## Durable state

- 25D0 syllabus audit is complete. The only material gap found was the explicit low-cost guard-interlock architecture; it is now closed by `research/25D0_GUARD_INTERLOCK_LOW_COST_COMPARISON_2026-09-23.md`.
- 25D0 has a canonical learner route/release gate and a separate no-solution evaluator handoff. Status is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.
- 25E0 is active. `research/25E0_VALIDATION_COMMISSIONING_ENTRY_2026-09-23.md` is the canonical syllabus entry.
- Pilz manufacturer guidance supports validation as the lifecycle check that implemented protective measures and safety functions satisfy requirements; SICK material supports test-plan-based physical/fault testing and measured stopping-time evidence for safeguard-distance validation.
- Earlier 25E0 muting/override/intentional-exception artifacts are preserved and should be integrated as specialist commissioning/change-control cases rather than treated as the whole 25E0 syllabus.
- No executable compute is justified. No GitHub-hosted runner is to be used.

## Exact next work

1. Build an SRS-to-validation matrix with representative E-stop, guard/interlock, STO/coast, fluid-power and reset/restart functions. For each row require precondition, stimulus/fault, physical proposition, evidence/measurement, acceptance criterion and revalidation trigger.
2. Add adversarial commissioning cases in which software/command/status evidence appears healthy while the physical safe-state proposition fails.
3. Trace stopping-time measurement and safeguard-position revalidation, including lifecycle drift such as brake wear, without inventing a universal test interval or margin.
4. Reconcile existing exceptional-mode/muting/override artifacts into validation of entry eligibility, alternate protective strategy, bounded persistence, exit/fault behavior and production return.
5. Develop proof-test/inspection interval reasoning from the actual latent failure and manufacturer/integrity assumptions; do not call routine maintenance a proof test unless it exposes the assumed failure.
6. Preserve 2520–25D0 external gates without contamination.
7. Freeze executable compute only for a concrete unresolved question that authoritative/static reasoning cannot answer; target `[self-hosted, openpressbrake]` only.
