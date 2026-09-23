# Safety curriculum checkpoint — 25B0 failure analysis next

## Durable state

- 25A0 completed its syllabus audit and lifecycle/change-control gap fill and is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.
- 25A0 now has a canonical learner route and information-separated evaluator handoff.
- 25B0 is active.
- `research/25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md` defines FMEA/FMEDA/fault-tree roles, fault classes, a first guarded-spindle fault tree, fault-injection evidence rules, personnel-isolation constraints and initial freezes.
- No executable compute is justified; no GitHub-hosted compute is authorized.

## Exact next work

1. Build a machine-neutral fault-injection matrix across power, wiring, sensor, logic, communication, final element and physical state.
2. Add latent-fault and CCF examples showing why sequential single-fault testing can miss dangerous combinations.
3. Define a safe test-selection hierarchy: source inspection -> static reasoning -> low-energy model -> isolated simulation/bench -> guarded/remote machine test only when justified.
4. Add adversarial cases for frozen plausible feedback, welded output plus misleading feedback, stuck valve, corrupted parameter set and safety-network timeout.
5. Preserve claim provenance. Do not invent diagnostic coverage, failure rates, stopping time, pressure, PL/SIL or machine-specific safe-state facts.
6. Only freeze an executable lab if a concrete question remains unresolved after authoritative evidence and engineering reasoning. If justified, target `[self-hosted, openpressbrake]` only.

## Compute

No executable question is presently justified. Do not use GitHub-hosted runners.
