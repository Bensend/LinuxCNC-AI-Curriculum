# Module Template

## Identity
- Module ID:
- Course level: 1000 | 2000 | 3000+
- Title:
- Status: planned | research | source-reading | experiment | exam | corrections | graduated
- Prerequisites:
- Unlocks:
- LinuxCNC revision(s):
- Last verified:

## Learning Objective
State what another AI engineer must be able to explain, locate, trace, test, and modify after completing this module **at this course level**.

## Course-Level Scope
State what depth belongs in this module now and what kinds of deeper questions should normally be promoted rather than allowed to block graduation.

## Questions to Answer
List concrete implementation questions before research begins. Mark questions essential to current-level graduation when known.

## Official Documentation Pass
Record terminology, documented behavior, configuration, guarantees, and explicit limitations. Preserve citations/URLs.

## Community / Forum Pass
Record useful field reports, developer explanations, failure cases, misconceptions, and unresolved claims. Treat these as investigation leads until verified.

## Source Inventory
| Path | Symbols / structures | Why it matters | Depth |
|---|---|---|---|

Depth: inventory | normal | deep

## Function / Symbol Guides
For each significant symbol record source path, purpose, callers/callees, inputs, outputs/state mutation, execution context, invocation frequency, control flow, failure behavior, timing assumptions, related structures, HAL-visible consequences, configuration dependencies, tests/examples, evidence classification, and useful next symbols.

## Call Flows
Document important end-to-end paths. Include entry point, thread/process context, important intermediate state, hardware/HAL boundary where applicable, and failure branches.

## Claims Ledger
| Claim | Classification | Evidence | Version scope | Confidence | Verification needed |
|---|---|---|---|---|---|

## Experiments
For each experiment record objective, exact revision, environment, setup, commands, expected result, observed result, artifacts/logs, conclusion, and discrepancies.

For repeated failures, count materially similar attempts. After at most three similar failed/stalled attempts, explicitly choose: **ESSENTIAL NOW / PROMOTE / DROP**. Do not blindly rerun.

## Failure Modes
Describe realistic failures, detection path, propagation, externally visible behavior, recovery, and unknowns.

## Adversarial Exam
Questions must require source navigation and reasoning rather than memorized definitions. Include at least one misleading premise, one version-sensitive question, one failure-path trace, and one small code/configuration change task.

## Corrections
Record what the exam or experiments showed was wrong/incomplete in the guide and how it was corrected.

## Handoff Test
A fresh AI should be able to use only the module artifacts plus referenced LinuxCNC source to perform the capabilities required at this course level, recognize explicit uncertainty, and avoid inventing missing behavior.

## Higher-Level Promotion / Uncertainty Queue

Every module must leave this section, even when empty.

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks current graduation? |
|---|---|---|---|---|---|---|

Destination normally means `2000`; use `3000` only when evidence shows the topic is genuinely specialized/expert-level. Record here:

- unresolved questions;
- documentation-only claims worth stronger verification;
- source-only claims worth experimental verification;
- failed/inconclusive/deferred experiments;
- version-sensitive behavior;
- conflicting evidence;
- assumptions accepted to continue;
- safety/reliability implications needing deeper study;
- adversarial/fresh-AI weaknesses;
- useful discoveries outside current-level scope.

Promotion is not a graduation failure unless the unresolved item could materially invalidate a core conclusion, downstream prerequisite, evidence validity, or important safety/reliability conclusion.

## Open Questions / Spawned Current-Level Modules
Dependencies that cannot responsibly be hand-waved **at the current course level** become explicit prerequisites/spawned modules. Valuable deeper questions belong in the promotion queue instead.

## Graduation Sufficiency Decision
State why the evidence is sufficient for this course level and identify every remaining uncertainty that was promoted. Do not require exhaustive resolution when it belongs at a higher level.

## Graduation Evidence
- [ ] Current course level and scope explicitly defined
- [ ] Official docs reviewed
- [ ] Community knowledge reviewed
- [ ] Source inventory sufficient for current level
- [ ] Significant functions/symbols traced to current-level depth
- [ ] Important call flows documented
- [ ] Claims ledger reconciled sufficiently for current level
- [ ] Reproducible experiments run where materially useful
- [ ] Repeated experiment failures classified ESSENTIAL NOW / PROMOTE / DROP
- [ ] Failure modes documented
- [ ] Adversarial exam passed
- [ ] Corrections incorporated
- [ ] Fresh-AI handoff test passed
- [ ] Higher-level promotion/uncertainty queue updated
- [ ] Remaining uncertainty does not invalidate current-level graduation
