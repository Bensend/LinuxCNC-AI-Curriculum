# 4400 technician field card — brake fault, gravity holding and controlled lowering
Status: original OPEN-BOOK training exercise; not a sealed external exam, machine procedure, or authorization for hazardous testing
Prerequisite: [manufacturer-source brake/hydraulic scope audit](../research/4400_BRAKE_FAULT_TORQUE_RETENTION_AND_HYDRAULIC_LOAD_CONTROL_SCOPE_2026-10-23.md)

## Goal

A fresh learner must distinguish *commanded stop*, *retained drive torque*, *brake control*, *actual mechanical holding*, *controlled load lowering*, *maintenance isolation*, and *fresh restart*. Do not answer by asserting that a safety PLC, FPGA or LinuxCNC signal alone makes a machine safe.

## Five diagnostic scenarios (paper analysis only)

**Case 1 — suspended servo axis.** The safety controller requests a brake, but one brake-feedback input remains inconsistent. An operator suggests forcing STO immediately because any fault should remove power. Identify what Rockwell's documented SBC feedback-fault example actually does; distinguish TOR's last-state rule from a universal fallback. Describe the *second fault* (loss of drive power/torque) that can defeat a temporary motor-hold strategy.

**Case 2 — hydraulic press-brake beam.** The machine is fitted with a pilot-to-open check described as “load holding.” During a trial lowering motion the beam ratchets. A technician proposes a larger pilot signal and disabling the diagnostic. Explain why the Parker HAS manual does not qualify its PO check as a load-lowering valve, and why the actual cylinder circuit and controlled-lowering element must be established before any modification. Do not prescribe a pilot pressure or circuit change.

**Case 3 — brake-test request.** A drive commissioning screen offers Siemens S120 SBT. The operator assumes it is a passive inspection and starts it with personnel near the suspended axis. Identify what the manufacturer says the test physically does, which encoder and drive-energy conditions matter, and why this is not an ordinary safe-to-run lab. Can the same S120 SBT function simply be applied to SINAMICS HLA?

**Case 4 — lathe after STO.** The drive reports STO active and a shaft sensor reads zero. The chuck still has possible inertial motion because of an unverified belt/coupling. What is the hazardous element that must be witnessed, and why is the vertical-axis “retain motor torque” response not automatically appropriate?

**Case 5 — power return / maintenance.** After a power interruption the brake feedback returns plausible, the guard closes, and a LinuxCNC cycle-start bit remains high. A worker's personal maintenance lock is still applied to one isolator. Describe the independent authorization gates and why none may be bypassed by a green HMI indication.

## Open-book answer/evidence guide

| Case | Minimum defensible answer | Unacceptable shortcut |
| --- | --- | --- |
| 1 | Rockwell SBC's example keeps TOR unasserted if brake feedback fails before the torque-off transition; generally TOR retains the pre-fault state. A drive fault or power loss can eliminate this holding source, so actual independent load restraint/exclusion is necessary. | “Every brake fault forces STO” or “drive torque is a guaranteed safety brake.” |
| 2 | The Parker HAS-specific PO-check text calls it holding, not lowering, warns of ratcheting and scopes its use to horizontal/no-overrunning applications. Selected hydraulics, pilot/leakage/return paths, gravity and actual lowering control remain UNKNOWN. | “All pilot checks are banned” or “increase pilot pressure until it works.” |
| 3 | Siemens S120 FW5.2 SBT commands test torque against the applied brake, evaluates encoder displacement, and requires appropriate pulses and sequence. Test must be planned under protected exclusion; its manual states SBT unavailable for SINAMICS HLA. | “A software test has no physical motion risk” or “SBT proves every hydraulic ram.” |
| 4 | Prove actual spindle/chuck/workpiece stopped, not just motor torque removed or a potentially uncoupled shaft stopped. The relevant failure is stored rotational energy; do not transplant gravity holding strategy. | “STO equals standstill.” |
| 5 | Personal energy isolation remains in force; separately verify physical stopping/holding/energy and occupancy/escape, deliberate independent safety rearm, then require a fresh *ordinary* start episode. A retained bit cannot start motion after safety recovery. | “Feedback green -> auto resume” or “close guard -> restore production.” |

## Adversarial follow-up

For each case, name one common-cause failure that defeats two apparently independent indications, and one **physical** observation or inspection that would be needed for machine release. Classify every answer as DOC-CONFIRMED, INFERENCE or UNKNOWN. **Do not invent** test thresholds, safe brake torque, stopping distance, hydraulic pressure, safety performance level or fault-detection coverage.

## Human-factor redesign task

Sketch a service/production interface with visible reasons for hold, simple fault identification, safe access/escape, and a recovery route that does not require defeating an interlock. Explain how nuisance trips or unexplained wait times could encourage bypass, and how design should remove that incentive without weakening safety.

## Pass boundary

Pass the open-book lesson when the learner correctly explains all five cases and refuses to authorize personnel exposure without selected-machine physical evidence. This is a *teaching check only*, not an independent blind evaluation, functional-safety validation, physical test, or equipment release. No selected machine IN-01..10/VAL/PT was supplied.
