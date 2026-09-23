# 2540 — Information-separated competency evaluator handoff

## Information-separation rule

This file defines the evaluator contract only. It intentionally contains no hidden scenario, expected answer, scoring key tied to a particular scenario, or learner-readable solution.

The evaluator must choose or construct a machine scenario not already solved in the learner-facing 2540 artifacts. Keep decisive scenario facts and the expected analysis hidden until the learner has committed its answer.

## Scenario requirements

Use a machine where at least two layers can be confused, for example electrical switching plus hazardous motion, a drive safety function plus gravity/inertia, or fluid-power switching plus trapped/stored energy.

Include at least five of these conditions:

- a final-element fault such as welding/sticking/failure to actuate;
- feedback whose diagnostic scope is narrower than the machine safe-state proposition;
- an application/load suitability issue;
- a common final element or common-cause dependency;
- a maintenance/replacement/configuration change;
- a reset/restart trap;
- stored energy or continued motion after command removal;
- a published component PL/SIL/PFH capability that tempts rating transfer;
- ordinary LinuxCNC/HAL/FPGA status/control that tempts authority transfer.

Do not require unavailable proprietary data or make the learner guess numerical machine physics.

## Learner precommitment

Before revealing expected analysis, require the learner to submit:

1. the physical safe-state proposition;
2. a chain of `command -> diagnostic witness -> final element -> hazardous energy -> physical safe state`;
3. dangerous single/latent/common-cause faults;
4. exact scope and limitation of each diagnostic witness;
5. missing evidence explicitly marked `UNKNOWN`;
6. maintenance/change impacts;
7. reset/rearm/restart behavior;
8. validation evidence required before attended operation;
9. a clear statement of the ordinary LinuxCNC/FPGA versus independent safety-authority boundary.

Record the precommitment before exposing evaluator expectations.

## Evaluation dimensions

Score independently on:

- proposition separation;
- fault-mechanism reasoning;
- diagnostic-scope discipline;
- final-element and hazardous-energy reasoning;
- common-cause/dependency recognition;
- component-rating versus complete-function discipline;
- uncertainty/calibration;
- change/revalidation reasoning;
- reset/restart reasoning;
- safety-authority boundary;
- diagnostic efficiency and clarity.

## Critical failures

Treat these as central competency failures requiring correction before 2540 can be considered securely transferable:

- inventing PL/SIL/PFH, stopping time, pressure, DC, MTTFd or other absent application facts;
- `EDM healthy -> machine physically safe`;
- `STO active -> electrical isolation / standstill / gravity load held`;
- `valve position healthy -> downstream safe pressure`;
- `two logic channels -> two independent physical interruption paths` when both converge on one unanalysed final element;
- `component PL/SIL capability -> complete machine-function rating`;
- `same-looking replacement -> validation remains current`;
- granting ordinary LinuxCNC/HAL/FPGA logic independent personnel-safety authority without evidence.

## After precommitment

Only after the learner answer is durably recorded may the evaluator reveal its scenario-specific expected analysis and score the response. Classify misses by mechanism, make the minimum curriculum correction needed, then use a materially different transfer scenario. Preserve the blind-feedback protocol and do not place hidden benchmark answers in learner-readable curriculum files.

External execution remains OPEN until such evidence exists.
