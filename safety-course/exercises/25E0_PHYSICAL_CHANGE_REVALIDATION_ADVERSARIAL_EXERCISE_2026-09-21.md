# 25E0 adversarial exercise — physical change and partial revalidation

Date: 2026-09-21

## Purpose

Test whether a learner can scope return-to-service evidence after a physical machine change without either (a) accepting software/configuration identity as proof of the machine or (b) mechanically repeating every possible safety test.

This is a generic educational scenario, not an OpenPressBrake procedure.

## Scenario

A hydraulic press brake has an existing validated safeguarding system. During maintenance:

- a damaged light-curtain mounting bracket is replaced;
- the emitter and receiver are physically realigned;
- no safety-program source file is edited;
- the safety controller reports the expected configuration/signature;
- the receiver indicates normal alignment;
- the press initializes normally;
- ordinary diagnostics show no active fault.

The technician proposes immediate production release because "nothing in the safety program changed and the curtain is green."

## Learner task

Without inventing a numerical safety distance or stopping-time limit, produce a return-to-service disposition that answers:

1. What safety function(s) can the bracket/alignment change affect?
2. Which evidence classes A/B/C/D are definitely invalidated, potentially invalidated, or plausibly retained? Explain each classification.
3. What does the controller signature prove, and what does it not prove?
4. What does the receiver/alignment indication prove, and what does it not prove?
5. What physical witness is needed before claiming the protective function is restored?
6. Under what condition would quantitative stopping/performance evidence need to be repeated or requalified?
7. What safeguard-geometry evidence must be restored?
8. If the machine-specific acceptance criterion is unavailable, what is the correct disposition?
9. After validation succeeds, does safety reset itself authorize production motion?
10. What human-factors question should be asked about the replacement bracket/alignment process?

## Expected reasoning boundaries for independent evaluation

Do not score on a single memorized sequence. Score whether the learner preserves these boundaries:

- physical safeguard geometry can invalidate evidence without a software change;
- configuration/signature identity is configuration evidence, not physical machine validation;
- alignment/status indication is not equivalent to challenging the protective field and witnessing the required machine response;
- A (normal-demand functional) evidence is affected because the physical protective-device path changed;
- C (quantitative performance) is affected if the physical change can alter the distance/geometry relationship or if current stopping performance is part of the applicable positioning method; the learner must not invent a criterion;
- B is not automatically invalidated in full merely because a bracket changed, but any fault-detection evidence dependent on the changed device/installation must be examined rather than assumed retained;
- D is not automatically due merely because maintenance occurred, but the periodic/proof-test program and OEM instructions must be checked for post-maintenance obligations;
- the installed safeguard geometry must be physically requalified against the current machine condition where applicable;
- failed or unavailable required acceptance evidence means no attended production release for the affected hazard; uncertainty is not permission;
- reset/rearm remains distinct from a fresh ordinary START;
- human factors include whether alignment/restoration is easy, unambiguous and resistant to predictable bypass/defeat.

## Adversarial follow-up variant

Change the scenario: the light curtain is untouched, but a hydraulic servo/proportional valve in the ram-control path is replaced with the correct part number and all software/configuration hashes remain identical.

Ask the learner to repeat the dependency analysis. A strong answer should shift attention away from protective-field geometry and toward affected hydraulic final-element response, direction/mapping, pressure/motion/holding or stopping-performance evidence required by the actual architecture. It must still refuse to invent the machine's hydraulic truth table or quantitative acceptance values.

## Evidence provenance

Built from the preserved Rockwell partial-revalidation/change-impact evidence, Siemens component-replacement acceptance evidence, ABB physical reduced-speed revalidation evidence, Rockford stopping/safeguard lifecycle evidence, Bosch Rexroth hydraulic recommissioning/final-element evidence, and current Haas HPB physical installation/alignment evidence.

The scenario and scoring boundaries are curriculum INFERENCE; underlying manufacturer facts retain their original evidence labels in their source studies.

## Compute

No simulation is needed. The unresolved question is reasoning/evidence scoping, not executable machine behavior.
