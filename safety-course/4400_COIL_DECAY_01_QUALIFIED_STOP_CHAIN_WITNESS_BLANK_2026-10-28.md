# 4400-COIL-DECAY-01 — Qualified stop-chain change witness (BLANK)
**2026-10-28 | INTERNAL ENGINEERING REVIEW TEMPLATE | ALL FIELDS UNVERIFIED / NOT RUN**

Read the [manufacturer-source investigation](../research/4400_COIL_DECAY_01_SUPPRESSION_DROPOUT_TIME_VS_CONTACT_LIFE_SOURCE_AUDIT_2026-10-28.md) and [technician card](4400_COIL_DECAY_01_QUIET_CONTACTOR_CAN_BE_SLOW_FIELD_CARD_2026-10-28.md). This is **not** a first-contact owner questionnaire, a live-test procedure, a machine approval or a substitute for a qualified safety validation plan. Restrict completed as-built machine drawings, serial numbers and personnel details to an approved private evidence location; public repository keeps only the blank.

## A. Scope and identity (documentary first)
| Required field | Evidence or approved private reference | State |
|---|---|---|
| Machine, hazard zone, specific safety-related control function and risk assessment | **UNKNOWN** | NOT REVIEWED |
| Authorized safety reviewer and approved change request | **UNKNOWN** | NOT REVIEWED |
| Independent safety controller, program identity/revision and safety-output channel(s) | **UNKNOWN** | NOT REVIEWED |
| K1/K2 or selected final element SKU, coil voltage, type and actual wiring | **UNKNOWN** | NOT REVIEWED |
| Suppression type: external diode / bidirectional / varistor / RC / active clamp / integrated electronics / other | **UNKNOWN** | NOT REVIEWED |
| Exact OEM manual, accessory compatibility, prior-versus-new revision and contact-life/EMC requirements | **UNKNOWN** | NOT REVIEWED |
| Normal LinuxCNC/FPGA role versus independent safety authority | **UNKNOWN** | NOT REVIEWED |
| Actual hydraulic/electrical/mechanical energy-removal and gravity-load-holding means | **UNKNOWN** | NOT REVIEWED |
| Guard/blanking/muting state, operator access and separate fresh restart | **UNKNOWN** | NOT REVIEWED |

## B. Time-and-physical-state evidence (not an instruction to energize)
**Only a qualified, independently approved test plan may populate observations.** Do not derive physical stop time from a single OFF bit, catalogue multiplier, PLC scan period or eventual EDM transition.

| Stage / observation | Exact evidence instrument or approved method | Timestamp / interval and uncertainty | State |
|---|---|---|---|
| Protective input actually changes state | UNKNOWN | UNKNOWN | NOT RUN |
| Independent safety logic/output changes state | UNKNOWN | UNKNOWN | NOT RUN |
| Coil terminal voltage/current changes; suppression/decay documented | UNKNOWN | UNKNOWN | NOT RUN |
| Main contact or safety-rated final element actually opens/changes | UNKNOWN | UNKNOWN | NOT RUN |
| Independently verified hazardous motion stops | UNKNOWN | UNKNOWN | NOT RUN |
| Gravity-loaded axis remains supported and all hazardous stored energy is controlled | UNKNOWN | UNKNOWN | NOT RUN |
| EDM/mirror diagnostic detects applicable selected faults | UNKNOWN | UNKNOWN | NOT RUN |
| Guard restoration, area-clear, safety rearm and deliberate *new* normal-cycle start | UNKNOWN | UNKNOWN | NOT RUN |

**Acceptance criteria:** UNKNOWN until derived by qualified machine-specific risk assessment, applicable standards, OEM data and approved validation. No invented milliseconds, stopping distances, hydraulic truth tables, PL/PFH, diagnostic coverage or pressure thresholds. A series-stage conceptual timeline is **not** necessarily a simple sum of catalogued maxima; overlaps, event definitions and physical energy must be evaluated for the selected system.

## C. Change/defeat review
| Question | Answer / reference | State |
|---|---|---|
| Can a generic replacement diode be fitted despite an OEM integrated suppressor? | UNKNOWN | NOT REVIEWED |
| Is the suppressor keyed/labeled to prevent an unapproved field substitution? | UNKNOWN | NOT REVIEWED |
| Can a person enter or remain in a blind/unguarded area while stop/hold is uncertain? | UNKNOWN | NOT REVIEWED |
| Could a maintenance shortcut (remove diode, bypass EDM, bridge guard) make a fault harder to detect? | UNKNOWN | NOT REVIEWED |
| Are all energy sources isolated and stored mechanical/hydraulic energy controlled for service? | UNKNOWN | NOT REVIEWED |
| Does an independent qualified reviewer accept the full physical safe-state evidence? | UNKNOWN | NOT REVIEWED |

## D. Gate
**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation until the independent safety architecture and physical stop/hold are qualified. Any later experimental operation must be isolated/remote, people outside the danger zone, residual risk explicit, and separately authorized. Independent 2520–25F0 evaluation remains OPEN. **No data entered here is an actual test result.**
