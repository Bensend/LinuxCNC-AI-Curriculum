# Safety curriculum checkpoint — 25A0 integration next

## Durable state

- 25A0 now has an end-to-end Siemens fail-safe-controller trace from CPU/internal diagnostics through F-DI, safety application, F-DQ and external final element.
- A field-fault matrix now compares dual dry-contact/test-pulse, OSSD and PNP/test-pulse patterns across opens, 24 V/0 V shorts, cross-shorts, timing disagreement, common mechanical defeat and diagnostic-pulse incompatibility.
- PROFIsafe black-channel evidence now separates sequence/monitoring, watchdog/time expectation, F-address and CRC mechanisms from ordinary network availability and from final-element physical success.
- An inspectable open assurance project is recorded as an evidence-practice example with explicit non-certification limitations.
- A machine-level adversarial case demonstrates that correct safety-PLC logic can still fail because of timing changes, CCF, unsuitable final-element feedback and hazardous coast-down.
- No executable compute is justified by the current evidence questions; no GitHub-hosted compute is authorized.

## Exact next work

1. Perform a 25A0 syllabus/competency coverage audit against the active safety-course syllabus. Fill only a material learner-facing gap.
2. Strengthen programmable-safety lifecycle/change-control coverage if the audit shows it is weak: configuration signatures/versioning, validated parameter changes, replacement hardware/firmware, proof-test/diagnostic assumptions, and revalidation triggers.
3. Add a compact learner exercise that forces separation of input diagnostic evidence, safety-program evidence, communication evidence, final-element evidence and physical safe-state proof.
4. If coverage is coherent, create the canonical 25A0 learner route and an information-separated evaluator handoff; mark READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating.
5. Immediately rotate to the next named safety-course module after 25A0 if its release gate is ready; preserve all existing external gates.

## Compute

Do not use GitHub-hosted compute. Current next questions remain documentation/reasoning questions. If a later executable question genuinely requires compute, use only `[self-hosted, openpressbrake]` and record authoritative runtime.
