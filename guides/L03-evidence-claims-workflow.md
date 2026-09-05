# L03 — Evidence / Claims Workflow

## Objective

Give a fresh AI engineer a repeatable method for turning LinuxCNC documentation, community reports, source inspection, and laboratory observations into claims that preserve provenance, version scope, uncertainty, and safety boundaries.

This guide operationalizes `SOURCE_POLICY.md`; it does not replace that policy.

## Evidence classes

### `SOURCE-CONFIRMED`
Use only when the behavior is directly supported by inspected source at an exact revision. Record the immutable commit, path, symbol/function or nearby code, and the behavioral conclusion. Do not silently extend a source-confirmed conclusion to another release.

### `DOC-CONFIRMED`
Use when official LinuxCNC documentation explicitly states the claim. Record page/title, URL, and version/document branch. Documentation establishes intended/public behavior but does not override contradictory implementation evidence; a contradiction becomes an explicit conflict.

### `TEST-CONFIRMED`
Use when a reproducible experiment observed the behavior. Retain exact LinuxCNC revision, lab job/configuration, environment, expected result, observed result, logs/artifacts and exit state. A test proves only the conditions it actually exercised.

### `COMMUNITY-REPORTED`
Use for developer/integrator/forum knowledge not independently verified here. Record the source and precise claim. Treat it as a lead for source inspection or experiment, not as implementation truth.

### `INFERENCE`
Use when evidence supports a reasoned conclusion but does not directly establish it. State the reasoning and what observation could falsify it.

### `UNKNOWN`
Use for unresolved behavior, conflicting sources, missing evidence, or a question whose relevant runtime/hardware condition cannot yet be reproduced.

## Required claim record

For a behaviorally significant claim, capture:

| Field | Requirement |
|---|---|
| Claim | Falsifiable behavioral statement, not vague prose |
| Class | One or more evidence classes above |
| Version scope | Exact commit(s), release/tag context where relevant |
| Evidence | Source path/symbol, doc URL, experiment, or community link |
| Confidence | High/medium/low with reason |
| Boundary | What this evidence does **not** prove |
| Conflict | Contradictory evidence, if any |
| Verification next | Smallest source read or experiment that would reduce uncertainty |

## Evidence-chain workflow

1. **Write the question before the conclusion.** Example: “What does the test harness do if a recognized HAL shared-memory segment remains after a test?”
2. **Establish documented intent and vocabulary.** This prevents source-reading terminology drift.
3. **Collect community failure reports.** Convert anecdotes into explicit hypotheses.
4. **Pin the exact source revision.** Never source-trace an unrecorded moving branch.
5. **Trace implementation.** Record entry point, calls, state, failure branch, execution context and version scope.
6. **State a prediction before an experiment.** This makes surprise visible instead of post-hoc rationalized.
7. **Run a bounded experiment.** Preserve full output and environment identity.
8. **Compare prediction to observation.** Promote, narrow, split, or reject the claim.
9. **Adversarially attack the claim.** Ask whether a different version, fallback mode, privilege state, stale process, or missing hardware could produce the same observation.
10. **Write the boundary.** Especially for realtime and safety-adjacent claims, state what was not tested.

## Conflict protocol

Never rewrite two disagreeing sources into a single smooth story without evidence. Instead preserve a conflict record:

- evidence A and its version/context;
- evidence B and its version/context;
- whether the difference is source, documentation, environment, or time/version dependent;
- strongest justified explanation, labeled `INFERENCE` if not direct;
- exact next action needed to resolve it.

### Worked example: stable vs development `runtests`

Question: does LinuxCNC's harness explicitly detect recognized stale shared-memory keys before and after each test?

- Development `8bf4605ae81042248add031e94c77300406e0413`: `SOURCE-CONFIRMED` yes for the inspected `scripts/runtests.in`; it defines shared-memory keys, checks before the suite, removes/counts leftovers after tests, and includes `SHMERR` in the summary.
- Stable `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`: that explicit path is absent from the inspected harness.

Correct conclusion: harness shared-memory hygiene is version-sensitive at these two revisions. Incorrect conclusion: “LinuxCNC always performs this cleanup” or “stable never cleans shared memory anywhere.” The latter would require broader source tracing or fault injection.

## Experiment interpretation rules

### Exit status is necessary but not sufficient
A zero exit proves the job/test's defined success condition completed. It does not prove every warning was harmless in every context or that unexercised failure paths work.

### Names do not establish runtime mode
A test/component name containing “realtime” is not evidence the host acquired realtime scheduling. Experiment `002` passed `realtime-math` while LinuxCNC reported POSIX non-realtime fallback. Runtime mode must be established independently.

### Cloud simulation is not machine qualification
Software/simulation experiments can confirm parsing, source flow, HAL behavior, component loading, test harness behavior and many fault paths. They cannot establish physical latency, fieldbus electrical behavior, hydraulic response, machinery safety, or safety-rated function without appropriate physical evidence and analysis.

### Negative source evidence is narrow
Failure to find behavior in one file does not prove the behavior cannot occur elsewhere. Record the inspected scope and search/trace needed before promoting an absence claim.

## Version comparison rule

When comparing stable and development:

- use exact immutable commits for both;
- use each checkout's own build system, generated files, environment scripts and test harness unless the experiment is explicitly about cross-version substitution;
- use an equivalent test definition where possible;
- preserve differences rather than normalizing them away;
- distinguish release-context differences from runner/environment differences.

## Fresh-AI handoff checklist

Before relying on a claim, another AI should be able to answer:

1. What exact behavior is asserted?
2. Which LinuxCNC revision(s) does it apply to?
3. Is the claim source-, doc-, test-, community-confirmed, inferred, or unknown?
4. Where is the evidence?
5. What conditions were actually exercised?
6. What conditions were not exercised?
7. Is there conflicting evidence?
8. What would falsify or narrow the claim?
9. What is the next source symbol or experiment if deeper certainty is required?

If those answers cannot be recovered from repository artifacts, the claim is not durable enough for later architecture work.

## Phase-0 validation

The current Phase-0 artifacts already demonstrate the workflow:

- a strict-shell integration failure was preserved and diagnosed rather than mislabeled a LinuxCNC compile failure;
- development source was pinned and reproducibly built;
- a representative upstream test was predicted, run and preserved;
- the non-realtime fallback narrowed the evidence boundary;
- stable source was pinned separately;
- source comparison identified a version-sensitive harness difference;
- a stable equivalent experiment was created without importing development harness behavior;
- an adversarial exam now tests whether a fresh agent respects those boundaries.

## Graduation evidence still required

L03 itself needs the Phase-0 adversarial exam/corrections result to show that the workflow prevents plausible evidence mistakes in practice. The stable `003` result must also be reconciled before Phase 0 is marked graduated.
