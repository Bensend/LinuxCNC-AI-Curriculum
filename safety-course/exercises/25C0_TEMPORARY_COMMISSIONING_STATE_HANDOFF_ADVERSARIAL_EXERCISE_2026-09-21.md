# 25C0 adversarial exercise — temporary commissioning state and operator handoff

Date: 2026-09-21

## Purpose

Test whether a learner treats temporary commissioning states as a human-factors and return-to-service problem rather than relying on technician memory.

## Scenario

During machine commissioning, a technician temporarily simulates an ordinary process input so a sequence can be debugged before the field device is installed. The independent personnel-safety system remains separate and active. The debug sequence succeeds. The technician then selects the normal production mode and leaves for shift change. The HMI home page shows no obvious indication that the ordinary process input is still simulated.

A second technician sees the machine in production mode, sees no active safety fault, and proposes handing it to the operator.

## Learner task

Explain the disposition without assuming that the simulated ordinary input is itself a safety-rated signal.

Address:

1. Why does production mode not prove production configuration?
2. Why is `the safety system is healthy` insufficient evidence that temporary commissioning state is cleared?
3. What machine-readable inventory or restoration evidence should be sought?
4. How should production-cycle authority behave while a known production-incompatible force/simulation remains active?
5. What should another worker be able to see without navigating to a specialist diagnostic screen?
6. What if the platform cannot enumerate every temporary override reliably?
7. What restart/reset/reboot persistence questions must be answered?
8. What should happen if the original technician cannot explain whether the simulation remains necessary?
9. Why must an ordinary production inhibit not be mislabeled as an independent personnel-safety function?
10. What design change would make the safe/correct handoff easier than accidental release?

## Expected reasoning boundaries

A strong answer should preserve:

- **PRODUCTION MODE SELECTED != PRODUCTION CONFIGURATION RESTORED**;
- **SAFETY SYSTEM HEALTHY != TEMPORARY ORDINARY-CONTROL STATE CLEARED**;
- temporary states should be explicit, inspectable and conspicuous where practical;
- production authority should be blocked while a known production-incompatible temporary state remains active;
- if temporary-state enumeration is incomplete, release needs stronger configuration restoration/inspection rather than assumption;
- persistence across reset, reboot, reload and handoff must be understood;
- uncertainty about a production-incompatible temporary state means no production handoff until resolved;
- ordinary LinuxCNC/HMI/FPGA interlocks can prevent accidental production operation but are not thereby promoted to personnel-safety authority;
- human factors should favor automatic blocking and conspicuous indication over sticky notes, memory, or tribal knowledge.

## Evidence provenance

The concrete pattern is SOURCE-CONFIRMED from FANUC America's 2023 Simulate I/O training, which recommends a Production Check alarm to block automatic operation while simulation is active and a visible team indication. The generalized scenario and scoring rules are curriculum INFERENCE.

## Compute

No simulation is needed; this exercise evaluates architecture and handoff reasoning.
