# 2530 Information-Separated Competency Handoff

Purpose: permit an independent/fresh evaluator to test **E-stop systems from first principles** without placing a hidden solution in learner-readable repository state.

This file contains the protocol and scoring surface only. It is not an answer key.

## Evaluator challenge requirements

Choose a machine/cell scenario not used as the worked solution in the learner-facing 2530 material. The scenario must contain at least:

- two materially different hazardous-energy or motion mechanisms;
- at least two E-stop actuators or a reasoned multi-location/span question;
- one final element whose electrical command state does not by itself prove the required physical safe state;
- one credible single fault and one common-cause or latent-fault challenge;
- reset/rearm and ordinary production-start behavior;
- enough ordinary LinuxCNC/PLC/FPGA integration to test authority boundaries;
- at least one intentionally missing physical datum that the learner must leave UNKNOWN rather than invent.

The evaluator may use authoritative standards/manufacturer documentation to define the challenge. Do not expose the evaluator's expected solution before learner precommitment.

## Learner deliverables

The learner must, without seeing the hidden evaluation solution:

1. define the hazardous event(s) and E-stop physical safe-state proposition(s);
2. explain why E-stop is complementary protection rather than the entire risk-reduction strategy;
3. define the required E-stop span(s) from hazard coupling and identify interface hazards;
4. choose or defer the stop/reaction architecture based on machine physics rather than slogan/topology;
5. identify input, wiring, logic, output/final-element and common-cause faults;
6. explain what dual channels, test pulses/discrepancy diagnostics, EDM/feedback and force-guided contacts do and do not prove;
7. separate actuator release, safety reset/rearm, personnel-clear proposition and production-start authorization;
8. analyze retained Cycle Start / production demand and power-cycle/recovery behavior;
9. allocate LinuxCNC/ordinary FPGA to request/status/diagnostic roles without granting it independent personnel-safety authority;
10. define a machine-level validation plan including physical stopping/energy-state evidence and post-maintenance revalidation;
11. explicitly mark unsupported stopping time/distance, hydraulic/pneumatic behavior, PL/SIL, DC, reliability or final-element facts UNKNOWN.

## Critical-fail conditions

A response cannot pass if it materially relies on any of these:

- treating the presence of an E-stop as completion of primary risk reduction;
- claiming that E-stop universally means immediate removal of all machine energy;
- choosing Category 0/1/2 without the physical/process evidence needed for the actual machine;
- treating two input channels as two independent physical witnesses without dependency analysis;
- treating healthy EDM as proof of unrelated physical machine state;
- allowing E-stop release/reset alone to restart hazardous production motion;
- treating a LinuxCNC software E-stop latch, HAL state, ordinary FPGA state or ordinary network as the sole personnel-safety authority;
- inventing missing machine-specific stopping, hydraulic/pneumatic, PL/SIL, diagnostic-coverage or reliability facts;
- transferring a manufacturer's published rating from one documented application to a lookalike circuit without establishing the application assumptions.

## Scoring dimensions

Score each dimension independently as `PASS`, `PARTIAL`, or `FAIL`, with evidence:

- hazard and proposition definition;
- E-stop scope/complementary-protection understanding;
- span-of-control reasoning;
- machine-physics/stop reasoning;
- fault and diagnostic reasoning;
- final-element/physical-proof reasoning;
- reset/rearm/restart reasoning;
- human-factors/defeat resistance;
- LinuxCNC/ordinary-control authority boundary;
- validation/revalidation quality;
- evidence discipline and correct use of UNKNOWN.

Overall PASS requires no critical fail and no material safety-reasoning gap hidden by terminology.

## Information-separation procedure

1. Evaluator privately selects the scenario and expected evidence/critical observations.
2. Learner receives only the scenario, allowed public sources and deliverables.
3. Learner precommits its answer/artifact.
4. Only after precommitment may evaluator evidence/expected observations be compared.
5. Preserve score and corrections without publishing a reusable hidden answer before the gate is complete.
6. If evaluator independence cannot be maintained, mark the gate OPEN and continue another safety-course branch under `WORK_SELECTION_POLICY.md`.

## Status

Protocol ready. External/fresh execution remains OPEN. This artifact does not graduate 2530 by itself.
