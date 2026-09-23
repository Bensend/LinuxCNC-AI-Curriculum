# 25F0 — machine safety capstone contract

## Purpose

Apply the same safety-engineering method across machine classes without flattening their different hazards into one generic circuit. The capstone is a transfer test: can a learner move from hazard boundary to validated architecture while keeping normal LinuxCNC control, safety-related control and physical energy control distinct?

## Mandatory capstone package

Every machine-class case must contain:

1. machine and lifecycle boundary;
2. hazardous energy/motion inventory;
3. hazardous-event map and foreseeable human exposure;
4. risk-reduction hierarchy before control-system design;
5. plain-language safety functions and SRS IDs;
6. physical safe-state proposition for every safety function;
7. authority allocation: normal LinuxCNC/FPGA, diagnostics/monitoring, independent safety-related control, final physical energy/motion elements;
8. sensor/logic/final-element architecture with dependencies and common-cause candidates;
9. fault analysis including at least broken/open paths, stuck/welded final elements, loss of power, restart, latent faults and machine-specific energy faults;
10. guarding/presence-sensing and human-factors review where exposure exists;
11. setup, recovery, maintenance and isolation strategy;
12. validation matrix derived from the SRS, including physical evidence and revalidation triggers;
13. maintenance/proof-test reasoning tied to named latent failures;
14. residual-risk and UNKNOWN register;
15. explicit safe-to-operate threshold: if minimum attended-operation safeguards cannot be established, testing/operation remains isolated or remote with people outside the danger zone.

## Machine-class differences that must remain explicit

- **Mill/VMC:** spindle/tool ejection, axis motion, enclosure/door access, ATC and stored pneumatic/hydraulic energy.
- **Lathe:** rotating workholding/workpiece, chucking, spindle coast, turret/axis motion and ejection/entanglement exposure.
- **Plasma/laser table:** process energy, fumes/fire, high voltage or optical hazards as applicable, gantry motion and process-specific protective enclosure/zone assumptions.
- **Router:** spindle/tool, gantry, workholding/vacuum, dust/fire and access patterns.
- **Robot/custom kinematics:** multi-axis reach, unexpected path, trapped/crush spaces, mode/setup enabling and protected-space occupancy.
- **Press brake:** ram/beam motion, pinch/crush zone, stored hydraulic/gravity energy, tooling/workpiece interaction, setup/maintenance restraint and safeguarding appropriate to the operation. Do not invent a hydraulic truth table, stopping distance, pressure threshold or integrity target.
- **Saw/feed/indexing cell:** cutting element, stock/workpiece movement, clamps/feeders, partial-cycle recovery and protected-space occupancy.

## Cross-machine architecture rule

Do not copy a safety function merely because two machines both have an E-stop, guard or STO input. Re-derive the physical proposition from the hazardous event. A drive torque-off function that is adequate for one horizontal spindle may be inadequate for a gravity-loaded axis or a machine with hazardous coast.

## Human-factors gate

For each capstone ask: what routine production, setup, clearing, cleaning or maintenance action will tempt a person to defeat this safeguard? Redesign inconvenience where practical. A safeguard that predictably rewards bypass is not finished merely because its wiring is correct.

## LinuxCNC boundary

LinuxCNC may request stops, inhibit ordinary commands, display safety status, log events and assist diagnostics. It must not silently become the sole personnel-safety authority. Safety-related control and physical final elements remain independently justified.

## First capstone selection

Start with a **mill/VMC** as the broad baseline because it combines hazardous spindle coast, enclosed access, multi-axis motion, toolchanging and auxiliary stored energy without requiring the machine-specific hydraulic assumptions of a press brake. Use that baseline to prove the capstone template, then transfer it to lathe, robot/cell and press brake cases. Press-brake depth remains a priority later, but its machine-specific hydraulic and stopping facts stay UNKNOWN until evidence exists.

## Exact next work

Build the mill/VMC capstone hazard/energy boundary and SRS skeleton. Use authoritative manufacturer/standards evidence for guard access, spindle/motion stopping and stored-energy propositions. Do not assign PL/SIL or numeric stopping distance absent a complete risk/integrity basis. No compute is justified yet.
