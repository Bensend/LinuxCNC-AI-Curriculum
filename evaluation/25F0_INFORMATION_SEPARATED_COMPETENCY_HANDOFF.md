# 25F0 information-separated competency handoff

Status: evaluator contract only. Do not expose hidden expected answers to the learner before commitment.

## Evaluation goal

Test cross-machine safety-engineering transfer, not recall of the worked capstones. Give the learner a novel machine or hybrid cell whose hazards force it to combine motion, stored energy, process energy and human access reasoning.

## Scenario construction constraints

Use a machine/topology not used as the principal worked example. Good candidates include a saw/feed/indexing cell, router with vacuum workholding and dust extraction, grinding cell, or hybrid automated fixture with one gravity/stored-energy axis and one process hazard.

Include at least:

- one normal LinuxCNC/FPGA control path;
- one independent safety-related path/final element;
- one misleading healthy status indication;
- one shared dependency/common-cause candidate;
- one maintenance/setup task that changes the energy/access boundary;
- one power-restoration/restart condition;
- one machine-specific quantity or behavior that is intentionally not supplied and must remain UNKNOWN.

Do not provide an answer key, target PL/SIL, stopping distance, pressure/speed threshold, proof-test interval or hidden machine physics to the learner before commitment.

## Required learner output

Require the learner to produce:

1. machine/lifecycle boundary;
2. hazardous-energy and hazardous-event inventory;
3. hierarchy-based risk-reduction choices before control details;
4. plain-language SRS safety functions with physical safe-state propositions;
5. authority allocation across normal control, monitoring, independent safety-related control and final physical elements;
6. dependency/CCF analysis;
7. representative fault matrix including broken/open path, stuck final element, power loss/restoration, latent diagnostic failure and a machine-specific energy fault;
8. guarding/presence and human-factors/defeat review;
9. setup/recovery/maintenance isolation strategy;
10. SRS-derived validation cases naming physical witnesses rather than status bits;
11. UNKNOWN/residual-risk register and safe-to-operate threshold.

## Critical failures

Treat any of these as release-blocking:

- ordinary LinuxCNC/HAL/FPGA/HMI status becomes sole personnel-safety authority;
- a controller/drive/valve/network healthy bit is accepted as proof that the physical hazardous state ended;
- production interlock is substituted for maintenance hazardous-energy isolation/restraint without justification;
- copied STO/E-stop/guard architecture is accepted without re-deriving the physical proposition from the novel machine hazard;
- power restoration can initiate hazardous motion/process without the justified rearm/start sequence;
- a shared dependency is ignored while nominal channel count is used as proof of independence;
- unsupported stopping, hydraulic, pressure, speed, fume/fire, diagnostic-coverage or integrity facts are invented;
- exposed operation is released despite inability to establish the minimum physical safeguards.

## Scoring focus

Score mechanism understanding, transfer across machine classes, physical-vs-status evidence discipline, CCF recognition, maintenance/restart reasoning, uncertainty calibration and human-factors practicality. A cosmetically complete architecture that fails the physical-proposition boundary is not competent.

## Gate

25F0 remains **READY FOR EXTERNAL/FRESH EVALUATION** until a genuinely information-separated evaluator executes this contract and records the result under the repository blind-feedback protocol. Do not self-score from curriculum-authoring context.