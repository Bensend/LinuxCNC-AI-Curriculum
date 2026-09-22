# 4000 Safety Curriculum Checkpoint — Fault Analysis / Diagnostic Design

UTC checkpoint: 2026-09-22T15:50Z

## Durable work completed

Added:

- `safety-course/2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`
- `safety-course/SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`

The new stage explicitly follows safety-function derivation/composition and precedes component selection/integrity arithmetic. It derives credible single, common-cause and latent faults from each allocated input/logic/final element/dependency; records effect on the required physical proposition; defines what must detect the fault and when; maps each diagnostic to the proposition it actually supports; defines diagnostic reaction/re-proof; and reverse-traces shared dependencies.

Professional anchors added include Pilz test-pulse short detection and Rockwell dual-channel discrepancy/input fault diagnostics. These are taught as specific diagnostic mechanisms, not universal proof of machine safety.

Stress tests cover the generic automated cut/feed cell and a generic gravity/fluid-power axis. Machine-specific valve truth tables, load-holding behavior, stopping criteria, diagnostic coverage, integrity targets and proof intervals remain `UNKNOWN` unless evidence establishes them.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Continue into architecture/integrity **requirements** from the completed fault analysis, before component arithmetic.
2. Teach architectural independence/diversity, diagnostic-path independence, final-element monitoring, common-cause controls and physical proof surfaces.
3. Distinguish fault tolerance, redundancy and diagnostic coverage; do not infer PL/SIL/Category or percentages from topology alone.
4. Stress-test the architecture method on the cut/feed cell and gravity/fluid-power example, including a shared-final-element/common-witness trap.
5. Add an adversarial case where all electronic diagnostics are healthy but the required physical process proposition is still unproved.
6. Preserve human-factors and independent-safety-authority rules.
