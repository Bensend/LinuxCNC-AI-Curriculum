# Module Template

## Identity
- Module ID:
- Title:
- Status: planned | research | source-reading | experiment | exam | corrections | graduated
- Prerequisites:
- Unlocks:
- LinuxCNC revision(s):
- Last verified:

## Learning Objective
State what another AI engineer must be able to explain, locate, trace, test, and modify after completing this module.

## Questions to Answer
List concrete implementation questions before research begins.

## Official Documentation Pass
Record terminology, documented behavior, configuration, guarantees, and explicit limitations. Preserve citations/URLs.

## Community / Forum Pass
Record useful field reports, developer explanations, failure cases, misconceptions, and unresolved claims. Treat these as investigation leads until verified.

## Source Inventory
| Path | Symbols / structures | Why it matters | Depth |
|---|---|---|---|

Depth: inventory | normal | deep

## Function / Symbol Guides
For each significant symbol:

### `symbol_name`
- Source path:
- Purpose:
- Called by:
- Calls:
- Inputs:
- Outputs/state mutation:
- Execution context:
- Invocation frequency:
- Control flow:
- Failure/error behavior:
- Timing/realtime assumptions:
- Related structures:
- HAL-visible consequences:
- Configuration dependencies:
- Tests/examples:
- Evidence classification:
- Symbols to inspect next:

## Call Flows
Document important end-to-end paths. Include entry point, thread/process context, important intermediate state, hardware/HAL boundary where applicable, and failure branches.

## Claims Ledger
| Claim | Classification | Evidence | Version scope | Confidence | Verification needed |
|---|---|---|---|---|---|

## Experiments
For each experiment record objective, exact revision, environment, setup, commands, expected result, observed result, artifacts/logs, conclusion, and discrepancies.

## Failure Modes
Describe realistic failures, detection path, propagation, externally visible behavior, recovery, and unknowns.

## Adversarial Exam
Questions must require source navigation and reasoning rather than memorized definitions. Include at least one misleading premise, one version-sensitive question, one failure-path trace, and one small code/configuration change task.

## Corrections
Record what the exam or experiments showed was wrong/incomplete in the guide and how it was corrected.

## Handoff Test
A fresh AI should be able to use only the module artifacts plus the referenced LinuxCNC source to locate the subsystem, explain its behavior, reproduce experiments, diagnose a representative failure, and make a bounded change without inventing missing behavior.

## Open Questions / Spawned Modules
Any dependency discovered during study that cannot be responsibly hand-waved becomes an explicit prerequisite or spawned module.

## Graduation Evidence
- [ ] Official docs reviewed
- [ ] Community knowledge reviewed
- [ ] Source inventory complete
- [ ] Significant functions/symbols traced
- [ ] Important call flows documented
- [ ] Claims ledger reconciled
- [ ] Reproducible experiments run
- [ ] Failure modes documented
- [ ] Adversarial exam passed
- [ ] Corrections incorporated
- [ ] Fresh-AI handoff test passed
