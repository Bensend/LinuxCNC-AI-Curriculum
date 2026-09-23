# 2580 information-separated competency handoff

## Purpose

This file is for an independent/fresh evaluator. It intentionally contains no hidden solution and must not be converted into a learner-readable answer key before the learner commits its response.

## Evaluation contract

Present one novel hydraulic or pneumatic machine scenario containing at least four of the following, without announcing which are the traps:

- stored accumulator or trapped-volume energy;
- gravity or externally driven load;
- monitored directional/shutoff valve;
- nominally redundant electrical channels sharing a hydraulic/pneumatic final element;
- hose/fitting or cylinder/seal failure;
- safe-exhaust hardware with a potentially trapped downstream volume;
- maintenance access requiring positive restraint;
- reset/repressurization/restart sequence;
- a pressure sensor whose location witnesses only part of the circuit;
- a replacement component with plausible but unproven equivalence.

Do not supply machine-specific pressure thresholds, stopping times, PL/SIL, diagnostic coverage, leakage rates or component capabilities unless those facts are deliberately part of the evidence package.

## Required learner deliverable

Require the learner to provide:

1. the physical safe-state proposition;
2. an energy/path inventory;
3. the chain `command -> safety-related control -> final element -> fluid state -> load state -> physical safe state`;
4. the narrow proposition supported by each diagnostic witness and the proposition it does not prove;
5. single/common failure paths and dependencies;
6. electrical versus fluid-power versus mechanical risk-reduction allocation;
7. reset/rearm/repressurization/start behavior;
8. maintenance/exposed-person release decision;
9. explicit UNKNOWNs and required evidence; and
10. LinuxCNC/FPGA authority boundary.

## Scoring dimensions

Score independently for:

- physical-energy reasoning;
- architecture/dependency reasoning;
- diagnostic-evidence discipline;
- fault coverage;
- lifecycle/reset/restart reasoning;
- maintenance/human-factors reasoning;
- uncertainty discipline;
- safety-authority boundary; and
- diagnostic efficiency/clarity.

## Critical failures

A response is not competent if it relies on any of these as a complete safety proof without additional evidence:

- pump/electrical power removed;
- valve command changed;
- valve-position feedback alone;
- one low pressure indication;
- electrical channel count;
- component PL/SIL marking;
- ordinary LinuxCNC/HAL/FPGA state;
- procedure-only maintenance control where credible hazardous load motion remains.

## Information separation

Record the learner's complete response before revealing or constructing the evaluator's expected diagnosis. If the evaluator already exposed the expected answer to the learner, mark the result non-blind and exclude it from blind competency metrics.

After commitment, reconcile important findings against applicable circuit/component documentation and physical evidence. A novel transfer retest should change the machine surface or energy path rather than merely renaming components.
