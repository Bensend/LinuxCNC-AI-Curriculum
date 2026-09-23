# Safety curriculum checkpoint — 25B0 failure analysis next

## Durable state

- 25A0 completed its syllabus audit/lifecycle gap fill and is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated, with learner route and information-separated handoff.
- 25B0 is active.
- `research/25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md` defines FMEA/FMEDA/fault-tree roles, fault classes, guarded-spindle fault tree, injection evidence rules and personnel-isolation constraints.
- `research/25B0_FAULT_INJECTION_MATRIX_2026-09-23.md` now spans power, wiring, sensor, logic, configuration, communication, output, final-element and physical-state faults; adds latent-fault and CCF examples; defines the source->reasoning->low-energy->isolated->remote-machine test hierarchy; and supplies five adversarial cases.
- No executable compute is justified; no GitHub-hosted compute is authorized or used.

## Exact next work

1. Turn the five adversarial cases into a scored-but-information-separated competency exercise without exposing expected solutions to the learner.
2. Strengthen 25B0 quantitative boundaries: explain when FMEDA/diagnostic-coverage arithmetic is justified and when missing source failure-rate/diagnostic data makes qualitative fault analysis the correct stopping point.
3. Add proof-test/latent-fault interval reasoning without inventing application intervals or failure rates.
4. Audit 25B0 syllabus coverage against `SAFETY_COURSE_RESEARCH.md`; fill only genuine learner-facing gaps.
5. Preserve claim provenance and the independent safety boundary.
6. Freeze executable compute only if a concrete implementation question remains unresolved after authoritative evidence and engineering reasoning; use `[self-hosted, openpressbrake]` only.

## Compute

No executable question is presently justified. Do not use GitHub-hosted runners.
