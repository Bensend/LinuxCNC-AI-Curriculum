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

## Prediction Check
Record at least one prediction **before** inspecting the confirming evidence.

| Scenario | Predicted behavior | Independent evidence | Observed result | Match? | What changed in understanding? |
|---|---|---|---|---|---|

A post-hoc explanation does not satisfy this requirement.

## Adversarial Exam
Questions must require source navigation and reasoning rather than memorized definitions. Include at least one misleading premise, one version-sensitive question, one failure-path trace, and one small code/configuration change task.

## Corrections
Record what the exam or experiments showed was wrong/incomplete in the guide and how it was corrected.

## Handoff Test
A fresh AI should be able to use only the module artifacts plus referenced LinuxCNC source to perform the capabilities required at this course level, recognize explicit uncertainty, and avoid inventing missing behavior.

The handoff must include at least one **novel course-level scenario** not answered verbatim in the guide, and the fresh AI must reason through it correctly from the artifacts.

## Higher-Level Promotion / Uncertainty Queue

Every module must leave this section, even when empty.

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks current graduation? | Why promotion is safe |
|---|---|---|---|---|---|---|---|

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

Every promoted item must state why its absence does **not** prevent the current learning objective from being demonstrated.

## Counterfactual Promotion Test
Before graduation, answer explicitly:

> If every promoted item turned out differently from our current expectation, would any central claim taught by this module become wrong, would a downstream prerequisite become unreliable, would the evidence chain become invalid, or would an important safety/reliability boundary materially change?

- If **yes**, the affected item is not promotable and blocks graduation.
- If **no**, promotion may be legitimate if the minimum evidence floor below is satisfied.

## Re-Promotion Test for 2000+
A 2000-level module may not move an unresolved 1000-level item to 3000 merely because it remains difficult. Record the **new evidence** showing that the topic is genuinely specialized/expert-level, depends on advanced prerequisites, requires specialized/physical infrastructure, or was previously mis-scoped. Difficulty alone is insufficient.

## Open Questions / Spawned Current-Level Modules
Dependencies that cannot responsibly be hand-waved **at the current course level** become explicit prerequisites/spawned modules. Valuable deeper questions belong in the promotion queue instead.

## Graduation Sufficiency Decision
State why the evidence is sufficient for this course level and identify every remaining uncertainty that was promoted. Apply the counterfactual promotion test explicitly. Do not require exhaustive resolution when it belongs at a higher level, but do not promote merely to avoid difficult verification.

## Minimum Graduation Evidence Floor
A 1000-level module must satisfy every item below. Promotion cannot replace these requirements.

- [ ] Core mechanism identified and traced from actual source
- [ ] At least one behaviorally significant execution path traced end-to-end
- [ ] At least one independent verification beyond rereading source (bounded experiment, upstream test, reproducible runtime observation, validated fixture, or other independently checkable evidence)
- [ ] At least one representative failure/invalid-input path understood
- [ ] At least one predeclared prediction checked against independent evidence
- [ ] Fresh-AI handoff solved at least one novel course-level scenario
- [ ] No promoted item could overturn a central teaching
- [ ] No promoted item could invalidate a downstream prerequisite
- [ ] No promoted item could invalidate the evidence chain
- [ ] No promoted item could materially change an important safety/reliability boundary
- [ ] Every promoted item explains why promotion is safe

If physical hardware is unavailable, distinguish **independent verification required** from **physical verification required**. Hardware absence does not waive the evidence floor. Verify everything reasonably possible in software/source/test infrastructure and promote only the genuinely hardware-dependent remainder.

## Graduation Evidence
- [ ] Current course level and scope explicitly defined
- [ ] Official docs reviewed
- [ ] Community knowledge reviewed
- [ ] Source inventory sufficient for current level
- [ ] Significant functions/symbols traced to current-level depth
- [ ] Important call flows documented
- [ ] Claims ledger reconciled sufficiently for current level
- [ ] Minimum graduation evidence floor satisfied
- [ ] Reproducible experiments/independent verification completed where materially useful
- [ ] Repeated experiment failures classified ESSENTIAL NOW / PROMOTE / DROP
- [ ] Failure modes documented
- [ ] Prediction check completed
- [ ] Adversarial exam passed
- [ ] Corrections incorporated
- [ ] Fresh-AI handoff test passed with a novel scenario
- [ ] Higher-level promotion/uncertainty queue updated
- [ ] Counterfactual promotion test passed
- [ ] Remaining uncertainty does not invalidate current-level graduation

Governing principle: **Do not over-investigate to graduate. Do not promote to avoid investigating.**
