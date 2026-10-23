# 4400 field card — two gates, one relay: diagnose what the circuit cannot see

**Learner practice, NOT BLIND / NOT RUN.** Based on `research/4400_SERIES_GUARD_INTERLOCK_FAULT_MASKING_AND_SELF_MONITORING_2026-10-22.md`. No physical-machine approval or simulated TEST-CONFIRMED result.

## Scenario

A generic robot cell has three frequently opened maintenance gates. Each has two passive NC contacts, with matching channels series-wired into one safety relay. A mechanic reports that a damaged gate A switch sometimes fails to trip, yet the relay appears normal after a second gate is opened and closed. A manager proposes a cheap fix: add three LinuxCNC inputs and keep the existing safety loop unchanged.

## Required technician response

1. **Freeze the operating boundary.** Do not rely on the existing chain for exposed-person operation while its safety proposition is disputed. Keep people out of the hazard zone; arrange remote/isolated investigation if justified.
2. **Map the physical chain.** Draw A/B/C contact pair, both series loops, each splice, receiver terminals, test-pulse sources and final-element path. Identify common supply, return and cable routing. Do not assume which contact is defective.
3. **Distinguish symptoms.** An input pair reading open means at least one path is open; it does not identify the guard. A healthy-looking pair after closure does not establish individual contact integrity. Record which selected receiver faults are latched and how reset works.
4. **Freeze a receiver-specific diagnostic question.** Under selected manufacturer's permitted safe bench conditions, does overlapping A/B opening mask a fault? Record predeclared expected states, required fault-injection constraints and the exact manual before any bounded lab. Do not deliberately bypass guards on an operating hazardous machine.
5. **Compare two corrective architectures.** Independently monitored inputs versus a supported self-monitoring cascade. Document exact product part numbers, interface and PFHd/diagnostic composition evidence; no “RFID = PL e machine” shortcut.
6. **Address human factors.** Label gate-specific diagnostics, correct sag/misalignment, provide accessible maintenance procedure and quick restoration, and keep reset outside with suitable visibility/presence protection. Avoid a service procedure that trains people to tape the switches.
7. **Trace the output.** A relay stop demand is not physical proof of motor standstill, robot restraint or absence of stored energy. Capture separate physical witnesses and maintenance LOTO.

## Fill-in evidence fields

| ID / question | Technician entry | Required proof / open restriction |
|---|---|---|
| `BND-/HAZ-/ENE-` access and energy | | |
| `SF-/PHY-` required guard/stop/occupancy proposition | | |
| `SRS-` fault-detection and restart requirement | | |
| `AUTH-` independent safety decision owner | | |
| `DEP-` series fault masking and common resources | | |
| `HF-` nuisance trip, poor diagnostics, bypass motivation | | |
| `ARC-` selected wiring/product alternative | | |
| `VAL-/PT-` receiver-specific safe verification and physical stop witness | | |
| `UNK-/RR-/CHG-` restrictions, change and revalidation | | |

**Instructor challenge:** A gate opens and the controller correctly drops its safety output. A hydraulic actuator still creeps under a gravity load. Which evidence is wrong? **Neither observation must be false**: the guard-demand proposition can be true while the physical safe-state proposition fails. Stop release/rearm and investigate final element, pressure and restraint; do not credit a controller indicator as a physical witness.

Sources: ISO/TR 24119:2015 public scope; Leuze “Moving guards”; ABB “EN ISO 14119 and Eden”; IFA/DGUV MaSeM. Exact URLs in linked research. Preserve UNKNOWNs and do not use this worked card as a sealed evaluator answer.

## Extra product-specific diagnostic trap — 432ES first-trip address

For a **separate Rockwell 432ES-IG3 application**, the official 432ES-UM001E-EN-P (June 2025) `DeviceTripAddress` tag identifies the device causing the first channel transition; subsequent device trips do not update that event address. **Question:** Gate A trips first, then gate B is opened for maintenance while the safety channel is already off. Can an HMI showing A's trip address prove B is closed? **No.** The event address is not an all-gates-live-state or occupancy witness. Trace the exact per-node tags and their validity for the selected 432ES configuration, and preserve independent restart/occupancy protection. Do not assume this tag or semantics exist in the different 440R-ENETR product. No live 432ES was tested. Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf .
