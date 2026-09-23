# 25D0 information-separated competency handoff

Status: evaluator contract only. Do not disclose hidden expected answers, preferred architecture, or scoring key to the learner before commitment.

## Evaluation goal

Test whether a fresh learner can choose a practical low-cost safety architecture by the physical hazard and failure path it closes, rather than by component count, catalog prestige or unsupported PL/SIL claims.

## Scenario construction

Create a novel small-shop or retrofit machine with at least three energy/hazard features chosen from motor/VFD motion, gravity/backdrive, hydraulic/pneumatic stored energy, movable guarding, stored electrical energy, or maintenance access. Include:

- one tempting very-cheap single-path solution;
- one plausible mid-cost improvement;
- one higher-cost component whose addition does not necessarily close the dominant hazard;
- one final-element failure;
- one common dependency capable of collapsing apparent redundancy;
- one power-loss/restoration case;
- one human-factors/bypass incentive;
- at least one machine-specific physical fact intentionally absent.

Use a topology different from the learner examples where practical. Do not reveal the intended architecture or fault ranking.

## Required learner outputs

The learner must:

1. define hazard/lifecycle boundary and physical safe-state proposition before choosing hardware;
2. rank the dangerous failure paths and state which one each proposed cost increment closes;
3. compare at least two architecture tiers without assuming more parts means more safety;
4. distinguish input diagnostics, final-element redundancy, feedback/EDM and physical safe-state evidence;
5. analyze broken/stuck/welded paths and at least one CCF/common dependency;
6. specify reset/rearm and power-restoration behavior separately from motion/cycle start;
7. if a drive is present, distinguish STO, standstill, electrical isolation and stored energy;
8. if fluid power is present, distinguish source isolation, decompression and load holding/restraint;
9. if guarding is present, distinguish guard closed/interlocked/locked from dangerous-state cessation and occupancy knowledge;
10. identify maintenance isolation/restraint separately from production safeguarding;
11. address bypass incentive, nuisance recovery, diagnostics and restoration usability;
12. preserve absent stopping time, pressure, integrity target, component lifetime/diagnostic data or other application facts as UNKNOWN;
13. refuse to convert component ratings into a machine PL/SIL claim without the complete evidence chain;
14. keep ordinary LinuxCNC/FPGA logic outside sole personnel-safety authority.

## Adversarial prompts to include

Use at least three, re-skinned:

- “The safety relay is PL e, so one downstream contactor is enough.”
- “EDM is healthy, therefore the motor is stopped and safe to enter.”
- “STO is active, therefore electrical maintenance can begin.”
- “The pump is off, therefore hydraulic pressure and gravity risk are gone.”
- “The coded guard switch says closed, therefore nobody can be inside and the hazard has ended.”
- “This architecture has twice as many relays, so it is safer.”
- “Automatic restart saves a reset button and is therefore the best low-cost option.”
- “A cheaper guard is acceptable even though operators routinely remove it for setup.”

## Critical failures

- selecting by price/component count without first defining the hazard and physical proposition;
- treating safety-module output, EDM, STO, guard status or dump command as direct proof of physical safe state;
- ignoring a welded/stuck final element or a common dependency that defeats nominal redundancy;
- conflating reset/rearm with motion authorization;
- inventing machine-specific stopping, pressure, PL/SIL/DC or lifetime values;
- treating production safeguarding as maintenance isolation/restraint;
- recommending attended operation when a basic minimum safe-to-operate threshold is not met;
- granting ordinary LinuxCNC/FPGA software sole personnel-safety authority.

## Scoring dimensions

Score separately: hazard/proposition definition, failure-path prioritization, cost-to-risk reasoning, fault/CCF completeness, diagnostic-boundary accuracy, energy-domain transfer, reset/restart reasoning, human-factors practicality, maintenance boundary, provenance/UNKNOWN discipline, and explanation quality.

## Gate

25D0 is READY FOR EXTERNAL/FRESH EVALUATION after its completed syllabus audit and canonical learner route. This handoff is not graduation evidence and must not be self-scored by the curriculum-authoring context.
