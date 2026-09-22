# 2520 Adversarial Assessment — Hazard to Integrity Gate

Date: 2026-09-22

## Purpose

Test whether the learner can carry a safety problem from hazardous event to defensible integrity-method gate without inventing machine facts or substituting component ratings for machine-level proof.

## Scenario

A generic automated material-processing cell has:

- guarded full-body access;
- hazardous powered motion;
- a pneumatic workholding/tooling subsystem with stored energy;
- a safety controller with dual-channel guard inputs;
- a safety-rated drive function for one motion axis;
- a separate contactor/valve path affecting other hazardous energy;
- ordinary LinuxCNC + FPGA control for production sequencing;
- one shared 24 V field supply feeding several safety witnesses;
- maintenance/setup modes and an enabling device;
- no supplied stopping-time measurement, component failure-rate dataset, validated pneumatic truth table, PLr/SIL target, or type-C-standard decision.

The machine has just undergone maintenance on a guard bracket and a pneumatic valve assembly.

## Questions

1. Derive at least three distinct hazardous events. Do not write generic labels such as `moving parts`; identify exposure circumstance and hazardous consequence path.
2. For each event, state a physical safe-state proposition. Identify any proposition that cannot yet be made machine-specific from supplied evidence.
3. Derive the required safety functions, including trigger, reaction, safe state, operating-mode scope, reset/restart boundary and interface with ordinary control.
4. Show one composition conflict that can arise during transition between setup/enabling mode and automatic operation.
5. Build a fault-analysis slice for guard sensing, safety logic, final element and pneumatic/process state. Include at least one single fault, one latent fault and one common-cause fault.
6. Explain why two guard channels on the shared field supply are not automatically two independent evidence paths.
7. The safety controller reports healthy inputs and outputs after maintenance. What is still unproved?
8. The drive reports its safety function active. Is hazardous motion physically at the required state? State exactly what can and cannot be concluded without inventing evidence.
9. Select an integrity method for one safety function. What project information must be established before the selection/edition is frozen?
10. Can a required PLr or SIL be inferred from the dual-channel topology? Explain.
11. List the evidence categories needed to establish achieved integrity under an ISO 13849-style path. Do not invent values.
12. List the evidence categories needed under an IEC 62061-style path. Do not invent values.
13. A vendor advertises the safety controller as capable of PL e / SIL 3. Both outputs ultimately command one unmonitored final element. Can the complete safety function inherit the controller rating? Why not?
14. Give one systematic/specification fault that no amount of component PFHd/MTTFd arithmetic would repair.
15. Define the validation cases needed after the guard bracket and valve maintenance before exposed production operation.
16. The ordinary HMI says READY, all safety-network connections are healthy, and Cycle Start has remained held since before the maintenance outage. Define the allowed authority transition back to production.
17. Identify every supplied fact that is still `UNKNOWN` and would be unsafe to fabricate.
18. State the disposition if the required physical safe state cannot be established with people exposed.

## Pass criteria

A passing answer must:

- preserve `hazard -> PROP -> SF -> fault -> architecture -> integrity method -> evidence -> validation` traceability;
- keep ordinary LinuxCNC/FPGA outside personnel-safety authority;
- distinguish command/status evidence from physical/process proof;
- identify shared dependencies/common cause;
- refuse invented PLr/SIL, DC, MTTFd/PFH, stopping time, pneumatic truth table, proof interval or diagnostic-coverage values;
- separate reset/rearm from fresh production start demand;
- require maintenance-induced physical propositions to be re-proved where the maintenance invalidated prior evidence;
- recognize that a high-rated component cannot establish complete machine safety-function integrity by itself;
- state that exposed operation is not acceptable when the minimum physical safe-state threshold cannot be established.

## Deliberate traps

- `dual channel` presented as if it proves independence;
- certified controller presented as if it rates the whole machine;
- healthy network presented as if it proves physical state;
- safety-rated drive status presented as if it proves all hazardous energy removed;
- reset presented as if it authorizes start;
- retained Cycle Start presented as if it were a fresh post-recovery demand;
- numerical integrity calculation invited despite absent application data;
- post-maintenance electronic health presented as if it re-proves guard geometry and pneumatic state.

## Evaluator note

Do not reward confident invented numbers. Correct uncertainty handling is a core competency. A learner that refuses an unsupported value and names the evidence needed to resolve it demonstrates stronger safety engineering than one that produces a plausible-looking calculation from assumptions hidden as facts.
