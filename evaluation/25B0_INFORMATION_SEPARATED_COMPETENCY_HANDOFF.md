# 25B0 information-separated competency handoff

Status: evaluator contract only. Do not expose hidden expected answers to the learner before commitment.

## Evaluation goal

Test whether a fresh learner can reason from safety propositions through faults, diagnostics, latent-fault exposure, CCF/dependencies, proof testing and physical safe-state evidence without converting a fault-injection checklist into an unsupported integrity claim.

## Scenario construction

Construct a novel machine safety function containing at least:

- two nominal channels or two nominal final elements;
- one diagnostic/feedback path;
- one latent dangerous failure possibility;
- one common dependency capable of defeating apparent redundancy;
- one configuration or communication fault;
- one physical final element whose actual state is not identical to its command bit;
- one proposed proof-test or inspection interval whose basis must be evaluated.

Use different product names/topology from the learner examples where practical. Do not disclose the intended failure tree or scoring key before learner commitment.

## Required learner outputs

The learner must:

1. state the physical safe-state proposition before choosing injections;
2. separate command, diagnostic, final-element and physical-machine evidence;
3. identify single-point, latent and common-cause/dependency faults;
4. explain what the first fault does to subsequent fault tolerance and restart permission;
5. distinguish automatic diagnostic test behavior from manual proof testing;
6. determine whether the proposed proof test can actually reveal the latent failure claimed;
7. refuse to infer DCavg from an unweighted percentage of injected cases;
8. refuse quantitative PFHd/PL/SIL arithmetic when required source inputs are absent;
9. identify what additional evidence would make a quantitative calculation defensible;
10. choose the lowest-risk test tier capable of resolving each remaining question;
11. preserve ordinary LinuxCNC/FPGA control as non-safety authority unless independent evidence establishes otherwise;
12. state UNKNOWN rather than invent machine stopping, pressure, failure-rate, proof-test interval, or diagnostic-coverage values.

## Adversarial prompts to include

Include at least three of these, re-skinned:

- a plausible-but-frozen sensor value while the physical hazard continues;
- a welded contactor whose auxiliary feedback is misleading;
- a stuck hydraulic/pneumatic final element after a correct electrical safe command;
- unchanged source logic but corrupted discrepancy/network-monitoring parameters;
- safety-network timeout with successful remote-output passivation but unproved physical final-element state;
- ten hand-selected fault injections of which seven are detected, followed by a request to report `70% DC`;
- a yearly inspection called a proof test even though its procedure never challenges the latent failure of interest.

## Critical failures

- accepting `fault detected` or `safe output bit` as physical safe-state proof;
- treating percentage of hand-selected injections detected as DCavg;
- inventing failure rates, B10d, beta/CCF, proof-test effectiveness or intervals;
- overlooking a common dependency because individual channel tests pass;
- allowing continued exposed operation with a known dangerous latent fault merely because redundancy still stopped the previous demand;
- using ordinary LinuxCNC/FPGA logic as sole personnel-safety authority;
- escalating to hazardous machine testing when source/static/low-energy evidence can answer the question.

## Scoring dimensions

Score separately: physical-proposition discipline, fault/dependency completeness, diagnostic-boundary accuracy, latent/proof-test reasoning, quantitative humility, safe test selection, restart/rearm reasoning, provenance/UNKNOWN handling, and explanation quality.

## Gate

25B0 may be marked READY FOR EXTERNAL/FRESH EVALUATION after its syllabus audit and canonical learner route are complete. This handoff alone is not graduation evidence and must not be self-scored by the curriculum-authoring context.
