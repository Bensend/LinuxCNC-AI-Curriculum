# 4400 — Common DC-bus backfeed, service isolation and restart: technician practice
**2026-10-24 | 14 PAPER SCENARIOS | NOT A BLIND EVALUATION | NO ENERGIZED STUDENT LAB**

Prerequisite: [original ABB/Rockwell source audit](../research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md) and [STO/DC-bus prior study](STO_CONTACTOR_DC_BUS_STORED_ENERGY_BOUNDARY_STUDY_2026-09-17.md). All source claims are **DOC-CONFIRMED only for the cited OEM models/revisions**; other installations UNKNOWN.

For each scenario state: (a) the physical hazard and energy path, (b) what ordinary status/feedback proves, (c) which independent isolation and verification proposition remains unproved, (d) the minimum safe practical response, and (e) whether the proposed operation may proceed. Do not compute imaginary voltages, thresholds or stopping times.

| ID | Scenario | Discriminating reasoning expected |
|---|---|---|
| CB-T01 | Two inverters share DC bus; A's local AC breaker is open, B remains supplied. | **INFERENCE:** A may still be energized via common bus; inspect exact DC topology, not only A's breaker. |
| CB-T02 | Both drives assert STO, Y1/Y2 press ram remains suspended. | STO is neither bus isolation nor gravity holding; two separate physical propositions remain. |
| CB-T03 | Regeneration OK signal goes low while DC bus meter/indicator is dark. | Rockwell readiness bit does not indicate bus-voltage presence or absence; qualified physical verification required. |
| CB-T04 | A regenerative spindle continues turning after input supply opens. | Mechanical energy can remain; motor type/topology determine generation and bus risk. |
| CB-T05 | A PM servo is backdriven by a falling counterweight after disconnect. | ABB documents PM motor generation; mechanical restraint and electrical isolation are distinct. |
| CB-T06 | Technician waits five minutes after opening a disconnect and immediately touches busbar. | ABB wait is not substitute for verified absence of voltage, and may not apply to other drives. |
| CB-T07 | Drive's main disconnect opens but transformer input busbars remain live. | ABB explicitly warns cabinet disconnect may leave upstream busbars energized. |
| CB-T08 | Separate 24 V auxiliary supply and brake resistor are installed. | Identify external supplies and dangerous brake circuit separately; do not infer isolation from main contactor. |
| CB-T09 | A capacitor extension module is added to an existing servo bus. | Revisit energy-storage map, discharge verification, and change control; module adds stored energy. |
| CB-T10 | Installer proposes connecting a replacement AC-input drive to an energized bus. | Product-specific precharge restrictions; Rockwell documents prohibited cases. Do not use a live demonstration. |
| CB-T11 | Inverter DC fuses are visible and technician assumes they are lockable disconnects. | Fuses protect circuits but do not by themselves establish selected isolating function. |
| CB-T12 | After zero-voltage check, another cabinet's DC feeder is re-enabled. | Source control and possible reaccumulation matter throughout work, not only initial reading. |
| CB-T13 | Normal CNC HMI reports “safe to service” from STO and bus-ready tags. | Diagnostic state is not independent personnel-safety authority; correct the HMI wording and architecture. |
| CB-T14 | Restart after maintenance: bus is ready, old CNC run request remains asserted. | Separate isolation release, deliberate safety rearm and **fresh motion start**; verify occupancy and final elements. |

**Practice answer discipline:** The third column is an openly published instructor cue, not a sealed oracle. A real external fresh-AI assessment must use a new topology, keep expected results hidden, require an immutable learner precommit, and score independently. No `TEST-CONFIRMED` claim or physical competency credit from these cases.

**Human factors:** A single clear energy-source diagram and labelled lockable devices are easier to use than guessing which of several hidden DC feeders is active. Provide OEM-approved safe test access for qualified personnel, not instructions for opening energized cabinets. No student is instructed to defeat guards, rotate motors, manipulate fuses, or measure live bus voltage.

**Machine applicability:** A shared DC bus on OpenPressBrake is **UNKNOWN**; if absent, mark device-specific field intake N/A but preserve the transferable lesson and verify actual installed energy sources. **G0/G1 HOLD; G3/G4 NOT AUTHORIZED** pending independent physical machine proof.
