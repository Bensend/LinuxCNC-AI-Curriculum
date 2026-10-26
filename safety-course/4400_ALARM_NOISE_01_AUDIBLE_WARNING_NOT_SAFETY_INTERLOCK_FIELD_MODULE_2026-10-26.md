# 4400 ALARM-NOISE-01 — audible warning, noise exposure and independent safe-state field module
**2026-10-26 | PUBLIC OPEN-BOOK TRANSFER / NON-GRADUATED**

## Objective and prerequisites
Distinguish (A) machine pre-cycle advisory, (B) covered employee emergency-action alarm, (C) occupational noise exposure and (D) independently allocated personnel-safety function. Read [original OSHA/NIOSH/WERMA audit](../research/4400_ALARM_NOISE_01_OSHA_NIOSH_WERMA_PERCEPTIBILITY_AND_AUTHORITY_AUDIT_2026-10-26.md), [2520 entry route](2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md) and [cumulative safety package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md). A machine buzzer or LinuxCNC/HMI alarm bit is **not** a guard, presence detector, independent stop, gravity-load hold, or maintenance isolator.

## 8 public technician scenarios — all UNSCORED
For each, record hazard boundary, warning purpose, evidence needed, safe action now, failure path, stale/change triggers and which independent protection must remain effective if the signal fails. Do not claim a blind score.
1. A 24 V stack light buzzer sounds during an idle demonstration, but is inaudible during plasma extraction. A supervisor says its catalog is “90 dB at 1 m.”
2. A helper wears hearing protection and does not hear a press-brake pre-cycle chime. A proposed fix is to remove PPE during bending.
3. An HMI shows “alarm active,” but a service technician has turned the buzzer's 82/90 dB selector to the quiet position.
4. A cell uses a single siren pattern for fire evacuation, guard-open notification and automatic-cycle ready. A new employee mistakes its meaning.
5. A lathe door is open; a 10-second pre-start sound is proposed in place of the door safety function because “everyone will move away.”
6. A machine becomes quieter after a retrofit, but a new acoustic enclosure blocks the operator's sightline to the only strobe.
7. A team wants to replace a quieter multi-modal warning with a louder horn; no occupational noise assessment or worker-location map exists.
8. Power is restored after a warning-device fault; a control program retains the previous cycle request. The HMI announces “ready,” but no fresh deliberate start is recorded.

## 10 documentary/desk verification gates — all NOT RUN
| Gate | Documentary question / required artifact | State |
|---|---|---|
| AN-G1 | Exact machine and alarm variant/revision/voltage/volume setting known? | NOT RUN |
| AN-G2 | Distinguish pre-cycle warning, emergency-action alarm and hearing-conservation roles by applicable scope? | NOT RUN |
| AN-G3 | Identify all exposed stations, blind spots, hearing/PPE/accessibility needs and relevant modes? | NOT RUN |
| AN-G4 | Map expected background noise and existing calibrated survey/dosimetry provenance? | NOT RUN |
| AN-G5 | Establish exact acoustic device ratings without extrapolating 1 m nameplate to reception? | NOT RUN |
| AN-G6 | Show independent guards/presence/stop/final-element/ram hold effective if warning silent? | NOT RUN |
| AN-G7 | Show power-loss, open-wire, muted/failed device and contradictory HMI indication handling? | NOT RUN |
| AN-G8 | Show warning meanings/priorities are distinct, trained, understandable and not nuisance-prone? | NOT RUN |
| AN-G9 | Show fresh-start/zone-clear and service LOTO do not depend on warning timer or HMI status? | NOT RUN |
| AN-G10 | Identify owner of qualified site verification, change triggers, hold decision and private evidence? | NOT RUN |

## Low-friction safe design
Prefer physically guarded hazard boundaries, an independent safety-rated function where justified, and a visible, maintainable signal that does not require the operator to defeat hearing protection or silence nuisance alarms. Reduce noise at source, put signals where they can be perceived and serviced, label distinct meanings, and treat an inaccessible alarm volume selector or obstructed strobe as a design defect. **No live hazardous fault injection with people exposed.**

## Evidence / release
**DOC-CONFIRMED:** exact OEM/regulatory/research scope in linked audit. **INFERENCE:** design patterns. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **UNKNOWN:** installed equipment, worker perception, noise dose, independent Y1/Y2 stop/hold, pressure/guards and PL/SIL. Eight scenarios UNSCORED, ten gates NOT RUN. [Independent unseen evaluator handoff](../evaluation/4400_ALARM_NOISE_01_INDEPENDENT_UNSEEN_PERCEPTION_AND_AUTHORITY_HANDOFF_2026-10-26.md) PREPARED/NOT RUN; no hidden answer or self-score. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
