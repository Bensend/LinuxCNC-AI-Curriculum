# Presence Monitoring, Rear-Access Protection, and Automatic-Restart Authority Boundary

Date: 2026-09-19

## Question

Does a professional cell implementation support the current restart-authority model far enough to join entry protection, a person remaining beyond the entry safeguard, inside-area/personnel-clear proof, safety reactivation, and production continuation? Is a separate fresh ordinary START universally required after the safety system becomes permissive again?

## Evidence classes

- `DOC-CONFIRMED`: manufacturer documentation or manufacturer-published application material.
- `INFERENCE`: engineering conclusion drawn from the cited evidence but not stated by the source.
- `UNKNOWN`: not established by the available evidence.

No runtime test was performed in this study.

## Professional implementation: Weidplas robot/injection-moulding cell

### Architecture and hazard boundary

`DOC-CONFIRMED` — Pilz documents an actual Weidplas cell in which a six-axis robot removes parts from an injection-moulding machine and places them on a conveyor. The problem was specifically to ensure that nobody remained inside the robot cell after the safety light curtain had been activated and the gate-locking devices acknowledged.

Source: Pilz, *A cell that's all-round safe*:
https://www.pilz.com/en-GB/products/success-stories/articles/242451

`DOC-CONFIRMED` — The implementation uses three PSENradar sensors with the existing PNOZmulti 2 configurable safety controller. The cell gates use PSENmlock safety locking devices.

`DOC-CONFIRMED` — Opening a gate or accessing the injection-moulding machine causes the robot to switch to a safe stop. The radar sensors then monitor the protected cell interior. The safeguards and robot are reactivated only after the radar system detects no further movement in the monitored cell for a defined period.

This closes an important chain that an entrance device alone cannot close:

`ENTRY / GATE SAFETY DEMAND -> ROBOT SAFE STOP -> PERSON MAY REMAIN INSIDE -> IN-CELL PRESENCE MONITORING -> DEFINED CLEAR-PERIOD CONDITION -> SAFEGUARDS/ROBOT REACTIVATED`

### What the source says about restart

`DOC-CONFIRMED` — Pilz states that, after the clear-period condition, the robot automatically travels to its start position and production can continue. The customer describes the solution as providing flexibility for automatic restart.

This is deliberately preserved because it falsifies an over-broad curriculum rule that *every* professional safety recovery on *every* machine class must always require a separate manual ordinary START after the safety-side permissive is restored.

### Important limitation

`UNKNOWN` — The public success story does not expose the complete PNOZmulti program, safety-output wiring, robot safety-interface wiring, reset logic, exact radar clear-period logic, final-element feedback, robot drive STO/safe-stop implementation, or the risk assessment that justifies automatic continuation.

`UNKNOWN` — The public source does not establish that the same automatic-restart strategy is acceptable for a press brake, hydraulic press, machine tool, or any other machine with materially different hazards.

## Independent manufacturer boundary: SICK sBot Speed

`DOC-CONFIRMED` — SICK's 2025 sBot Speed operating instructions provide the opposite configuration boundary for a freely accessible robot application: after infringement of the protective field, clearing the field does not restart the robot. The validation checklist requires the robot to remain at standstill until all fields are free, the safety system is manually reset, and the robot is manually restarted.

Source: SICK, *sBot Speed operating instructions*, publication 8022412/1TB3/2025-09-23:
https://www.sick.com/media/docs/7/57/957/operating_instructions_safe_robotics_area_protection_sbot_speed_en_im0077957.pdf

`DOC-CONFIRMED` — The same SICK manual separately defines requirements for an automatic-restart application. Among those requirements are that it must not be possible to walk behind the laser-scanner protective field, no people may be in the hazardous area during or after reset, and entry to the hazardous area must require crossing the scanner protective field.

This is strong evidence that restart behavior is an application safety-function property, not a generic consequence of `protective field clear`.

## General rear-access principle

`DOC-CONFIRMED` — Pilz's area-monitoring guidance says rear-access/encroachment protection is required where a person can remain behind an entrance safeguard; a 2D scanner can monitor the interior and prevent hazardous movement from restarting while anyone remains in its protected field.

Source:
https://www.pilz.com/en-US/products/applications/area-guarding/area-monitoring

`DOC-CONFIRMED` — Rockwell's SC300 manual likewise limits configurations without an effective machine-side restart interlock to applications where the protective system cannot be stood behind.

Source: Rockwell Automation publication 442L-UM004C-EN-P (July 2020):
https://literature.rockwellautomation.com/idc/groups/literature/documents/um/442l-um004_-en-p.pdf

## Curriculum correction / freeze

The previous safety boundary remains valid:

**ACCESS DEVICE CLEAR != INSIDE AREA CLEAR != PERSONNEL CLEAR != RESTART AUTHORITY.**

But the following must **not** be taught as a universal machine-independent rule:

`SAFETY REARM -> ALWAYS REQUIRE A SEPARATE MANUAL ORDINARY START`

Professional implementations demonstrate at least two legitimate architecture families:

1. **Manual-reset + manual-restart family** — e.g. the cited SICK sBot Speed validation configuration. Clearing the field is insufficient; manual safety reset and manual robot restart remain distinct required actions.
2. **Risk-assessed automatic-restart/continuation family** — e.g. the Pilz/Weidplas cell, where dedicated in-cell safe presence monitoring establishes a defined clear condition before safeguards/robot reactivation and automatic return toward production.

Therefore freeze instead:

**PROTECTIVE DEVICE CLEAR != RESTART AUTHORITY. RESTART AUTHORITY MUST COME FROM THE MACHINE'S VALIDATED SAFETY-FUNCTION DESIGN.**

and:

**AUTOMATIC RESTART IN ONE VALIDATED ROBOT-CELL ARCHITECTURE != PERMISSION TO TRANSFER AUTOMATIC RESTART TO A PRESS BRAKE OR OTHER MACHINE CLASS.**

For OpenPressBrake curriculum work, retain the conservative separation of safety reset/rearm and fresh production initiation unless authoritative press-brake-specific evidence and the machine risk assessment establish otherwise. Ordinary LinuxCNC/HAL/normal FPGA logic must not manufacture personnel-clear authority merely because a gate/light curtain has returned clear.

## Human-factors consequence

Presence/rear-access sensing is valuable because it removes dependence on an operator remembering whether someone disappeared behind the entrance safeguard. Where the hazard geometry allows bodily entry, designing the system so that an entrance reset alone can restore hazardous motion is a poor human-factors architecture unless another validated means proves the hazardous area clear.

The safer path should be operationally easy: the safety system should retain the occupied state or directly monitor the interior rather than asking the operator to reconstruct occupancy from memory.

## Verification implications

A commissioning/validation plan for an accessible cell should challenge at least:

- entry-device demand while hazardous motion is active;
- actual safe reaction of the hazardous equipment;
- a person entering and remaining beyond the entry sensing plane;
- entry device returning clear while the person remains inside;
- inside-area sensor continuing to inhibit restart;
- blind spots/occlusion and the declared detection coverage;
- the actual configured clear-period/reset behavior;
- whether automatic restart is enabled, and if so, whether every precondition in the machine risk assessment is satisfied;
- for manual-restart architectures, proof that reset does not itself initiate hazardous motion and that the separate restart action is required;
- power-cycle/fault recovery without stale ordinary commands becoming unintended motion authority.

Do not assign numerical PL/SIL, scanner distances, clear times, stopping distances, or diagnostic coverage from this study to another machine.

## Next evidence target

Prefer a professional accessible cell or machine exposing the complete implementation from `entry/presence demand -> physical final-element safe reaction -> retained-person or in-area witness -> clear proof -> reset/rearm policy -> final-element proof -> manual or automatic production restart`, including the documented risk-assessment condition that selects manual versus automatic restart.

For the primary hydraulic press-brake lane, continue the higher-priority unresolved trace: `individual monitored hydraulic valve disagreement -> physical ram/load-safe disposition -> fault retention -> repair/replacement -> required valve/restraint/stop-performance re-proof -> safety reset/rearm -> press-brake-specific production initiation`.
