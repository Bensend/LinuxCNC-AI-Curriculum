# 2520 — Machine-Level SRS Derivation Exercise

Date: 2026-09-22
Prerequisites:
- `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`
- `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`

## Objective

Prove that the learner can move from hazards to a compact Safety Requirements Specification (SRS) and then derive validation cases from the requirements rather than from a parts list.

This is an educational generic machine. It intentionally omits design-specific PL/SIL targets, stopping times/distances, pressure thresholds and component selections. Those remain `UNKNOWN` until a real risk assessment/design establishes them.

## Scenario — automated cut/feed cell

The cell contains:
- electrically driven rotating cutting tool;
- electrically driven stock feed;
- pneumatic workholding/clamping;
- interlocked access gate permitting full-body access;
- E-stop devices outside the cell;
- automatic production mode;
- setup mode for a narrowly defined adjustment task using an enabling device;
- ordinary LinuxCNC/FPGA/HMI control for production sequencing;
- independent safety-related control authority;
- a common 24-V field supply feeding several safety witnesses.

Do **not** assume the cutter stopping time, clamp behavior on pressure loss, whether pressure must be retained or exhausted for every access task, guard-lock release criterion, or integrity target. The learner must expose those as `UNKNOWN` where they affect the design.

## Part A — boundary and hazard derivation

Produce a task/lifecycle table covering at minimum:
1. automatic production;
2. loading/unloading if exposure differs;
3. setup/adjustment;
4. jam/fault recovery;
5. cleaning/maintenance;
6. power loss/restoration.

For each task identify people, danger zone, hazardous energy/motion, initiating condition and harm mechanism.

Minimum hazards to consider, without assuming these are exhaustive:
- contact/entanglement/cutting with rotating tooling;
- crushing/shearing from stock feed;
- unexpected release/movement associated with pneumatic clamping or stored pressure;
- unexpected restart after gate closure, safety reset, mode change or power recovery;
- additional-person entry while setup protection is substituted;
- loss of common field power making multiple safety witnesses unavailable.

## Part B — hierarchy before safety controls

For each hazardous event record:
- inherently safer design possibility;
- technical protective measure if risk remains;
- residual-risk information/procedure after design and safeguarding.

Reject any answer that jumps from hazard directly to a safety PLC or E-stop without considering elimination/design measures.

## Part C — derive propositions and functions

Create at least four `PROP-*` and four `SF-*` records. At minimum address:
- emergency stop;
- gate/access;
- setup/enabling;
- process/clamping fault.

Each `SF-*` must contain:
- linked hazard;
- trigger;
- required reaction;
- linked physical safe-state proposition(s);
- applicable modes;
- response criterion or `UNKNOWN`;
- reset/restart behavior;
- power/communication/fault behavior;
- integrity target or `UNKNOWN`;
- dependencies;
- residual risk.

## Part D — composition matrix

Fill this matrix with actual derived IDs:

| Function | Auto | Setup | Recovery | Maintenance | Shared final elements | Shared dependencies | Conflicts/substitutions |
|---|---|---|---|---|---|---|---|
| `SF-*` | | | | | | | |

Then answer:
1. Which function(s) remain effective when the setup mode substitutes the gate's normal protective effect?
2. What protection detects/prevents additional-person exposure?
3. If E-stop and gate demand occur together, what physical propositions must both remain satisfied?
4. If clamp/process fault clears first, what prevents that from re-enabling production while the gate demand remains?
5. What happens if the common 24-V field supply disappears while ordinary LinuxCNC remains alive?
6. What happens when setup -> automatic occurs while Cycle Start is physically held?

## Part E — authority allocation

For each function build:

`HZ -> PROP -> SF -> input -> independent safety logic -> final element -> physical process -> EVID -> VAL`

In a separate column identify ordinary LinuxCNC/FPGA/HMI responsibilities. Acceptable ordinary roles include production sequencing, status display, diagnostics, non-safety stop requests and honoring safety-permissive status. Do not assign LinuxCNC/HAL sole personnel-safety authority merely because it can command the same actuator.

## Part F — evidence/proof plan

For every `PROP-*`, define:
- direct/indirect evidence;
- evidence source/witness;
- `DEP-*` dependencies;
- freshness/invalidation conditions;
- what condition makes evidence `UNAVAILABLE`, `STALE`, `FAILED` or `UNKNOWN`;
- when proof is required: continuous/on demand/commissioning/periodic/after change/after finding as applicable.

If the proposition cannot yet be proved because a physical fact is unknown, state the safe operational consequence. If that missing fact prevents a basic safe-to-operate threshold, attended operation with people exposed is not authorized; experimental work must be isolated/remote with residual risk stated.

## Part G — derive validation from the SRS

Create `VAL-*` cases for each `SF-*`. Every validation case must cite the requirement/proposition it proves.

Minimum combined cases:
1. normal gate demand during hazardous process;
2. E-stop during automatic operation;
3. gate demand + E-stop simultaneously;
4. setup mode with enabling device released and fully depressed;
5. attempt to enter setup without required mode authority;
6. transition setup -> automatic with a held ordinary start command;
7. process/clamp fault while gate is closed;
8. process/clamp fault clearing while gate remains demanded;
9. loss/restoration of common safety field power;
10. loss/restoration of ordinary LinuxCNC while independent safety remains powered;
11. final-element feedback mismatch/failure;
12. power restoration with all inputs apparently healthy but no fresh production demand.

Each `VAL-*` requires:
- initial state;
- stimulus/fault;
- expected independent safety reaction;
- expected physical proposition;
- expected ordinary-control behavior;
- acceptance criterion;
- evidence captured;
- reset/rearm/start sequence;
- unresolved `UNKNOWN`s.

## Part H — human-factors attack

Assume production personnel discover that setup mode is slow and jam recovery frequently requires walking between the gate and HMI.

The learner must propose a design response that makes legitimate recovery easier without globally bypassing safety functions. Consider reset/diagnostic placement, visibility, access geometry, localized recovery, enabling-device ergonomics, captive hardware and fault diagnostics. A proposal whose primary answer is `train operators not to bypass it` does not pass.

## Scoring rubric

Pass requires all of the following:
- hazards are task/event based rather than device nouns;
- hierarchy is applied before control selection;
- physical propositions are distinct from commands/status;
- safety functions are specified independently before composition;
- mode substitutions are narrow and explicit;
- simultaneous demands preserve all applicable physical propositions;
- common dependencies are reverse-traced;
- ordinary LinuxCNC/FPGA authority remains separate;
- `UNKNOWN` is used instead of invented physical/integrity values;
- validation cases derive from requirements;
- reset/rearm remains separate from fresh production start;
- human factors are treated as engineering input.

## Deliberate misleading premises

The evaluator should challenge the learner with these claims:
- `All four functions drop the same STO, so they are one safety function.`
- `The safety controller says the gate is healthy, so full-body access is clear.`
- `Setup mode is authorized, so bypassing E-stop and guard logic together is acceptable.`
- `The field supply returned and all inputs are green, so the old Cycle Start can resume.`
- `Use PLe everywhere to avoid doing the risk assessment.`

A correct learner rejects each premise and explains the missing requirement/evidence rather than merely saying it is unsafe.

## Next workflow question

After this exercise, audit the remaining course for the next real methodology gap. Candidate priority is **fault-analysis and diagnostic design before architecture/component selection**: derive credible single/common-cause/latent faults from the allocated function, decide which must be detected and when, and map diagnostics to actual propositions without treating diagnostic coverage as a substitute for physical validation.
