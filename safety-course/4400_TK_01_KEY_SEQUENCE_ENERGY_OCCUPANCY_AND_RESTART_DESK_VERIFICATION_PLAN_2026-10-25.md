# 4400-TK-01 — Key-exchange safety case: desk verification and adversarial fault model
**2026-10-25 | DOCUMENTARY / NO-ENERGY / NON-GRADUATED | not an executable safety controller**

## Scope and safety question
A multi-gate trapped-key arrangement may force a particular key sequence. What additional evidence would be needed to establish **safe entry**, **continued protection while workers remain inside**, and **no automatic restart**? This plan is a review contract, not a selected-machine circuit, proof-test permission or certified performance calculation.

Source anchors: [Castell X Issue 7](../research/4400_CASTELL_X_DOLD_STS_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEY_AND_LOTO_SOURCE_AUDIT_2026-10-25.md), [DOLD personal keys](../research/4400_CASTELL_X_DOLD_STS_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEY_AND_LOTO_SOURCE_AUDIT_2026-10-25.md), [BEMF Issue 3](../research/4400_CASTELL_BEMF_MOTOR_STANDSTILL_AUTO_RESET_VS_HYDRAULIC_LOAD_SOURCE_AUDIT_2026-10-25.md), [Fortress LOK variants](../research/4400_FORTRESS_LOK_LOCK_MONITOR_VS_PROCESS_ONLY_AND_ESCAPE_CONTACT_VARIANTS_AUDIT_2026-10-25.md) and OSHA 1910.147. All manufacturer behaviors apply **only** to cited editions/configurations.

## Safety propositions: never collapse them
Define documentary propositions, not software bits:
- **K** = selected key exchange mechanically constrains the specified access-key sequence.
- **I** = every relevant hazardous energy source has been isolated by a suitable physical device.
- **E** = residual/stored energy has been discharged, restrained or rendered safe and independently verified.
- **G** = guard integrity and access containment are adequate for the hazard and maintenance task.
- **P** = every exposed person has a reliable personal exclusion/escape/accountability mechanism.
- **H** = independent final elements hold dangerous loads, including gravity-driven Y1/Y2 motion where applicable.
- **R** = after area clearance, independent safety rearm plus deliberate **new** ordinary start are required.

A key-exchange example may provide evidence for **K**. It does **not** prove **I,E,G,P,H,R**. A motor-back-EMF release may provide a configured motor-sensing condition; it does not prove **E/H**. A closed guard input may provide one signal, but a Fortress unmonitored process-locking variant can leave its NC actuator circuit closed while the solenoid is unlocked. No amount of normal LinuxCNC status changes these independent physical propositions.

## No-energy review gates and witness evidence
| Gate | Documentary question | Required evidence / fail action |
|---|---|---|
| D0 — selected scope | Which exact machines/axes/gates/people are protected? | Hazard-zone plan, access/use modes, as-built revision; unknown => HOLD |
| D1 — energy map | Are all electrical, hydraulic, pneumatic, gravity, vacuum, thermal and process sources included? | Qualified energy-zone/isolator list, residual sources, downstream coupling; missing => HOLD |
| D2 — key plan | Are input/output key counts and exchange order correct for each access? | Exact OEM model, code/serial, key map, no undocumented duplicates; mismatch => HOLD |
| D3 — hardware defeat | Can actuator/lock/guard be removed, shimmed, struck or bypassed? | Mounting, separate door stops, hinge alignment, key-control/inspection records; deficiency => HOLD |
| D4 — physical isolation | Does key release truly require physical energy isolation, not only control-circuit OFF? | Restricted wiring/hydraulic drawings and qualified deenergized continuity/mechanical evidence; unknown => HOLD |
| D5 — residual hold | Can a suspended load or trapped pressure move with main power OFF? | Selected independent hydraulic/gravity restraint and verification design; unknown => HOLD |
| D6 — occupancy | Can one worker return an access key while another is inside? | Per-person safety key/lock, group LOTO, inside escape and visibility; unknown => HOLD |
| D7 — motor sensing | Does BEMF actually sense hazardous motor/load through selected drive wiring? | Motor topology, broken-wire/reset config, sensor-to-load path; no universal standstill inference |
| D8 — guard lock | Does exact lock monitor locking or only actuator/key position? | Fortress/EUCHNER/Pilz variant-specific terminal map and power-loss behavior; no lookalike substitution |
| D9 — rearm | Can key return or power restoration resume retained motion? | Independent reset/EDM, area-clear procedure and new CNC start; ambiguity => HOLD |
| D10 — maintenance | Can a technician isolate, temporarily position and re-isolate without bypass? | OSHA-covered personal/group LOTO, handover and test/position procedure; absent => HOLD |
| D11 — validation | Is there qualified protected physical witness and independent competency evidence? | G0/G1 preconditions, signed plan, residual risk and results; NOT RUN is not PASS |

## Adversarial fault cut sets (qualitative, not numerical)
- **Unsafe entry despite a correct key exchange**: at least one uncontrolled hazardous source or unrestrained stored energy exists outside the keyed isolation boundary (**K true, I/E/H false**). Countermeasure: source-by-source physical verification and independent load restraint.
- **False empty-cell claim**: one key is shared/duplicated, or a personal key is returned while someone remains inside (**K can be true, P false**). Countermeasure: per-person retention or equivalently validated whole-body presence/access arrangement.
- **False guard-locked claim**: unmonitored-solenoid actuator contacts remain closed after unlock, or a mechanical actuator is defeated (**status true, G false**). Countermeasure: exact variant contact proof and guard mechanics.
- **False standstill claim**: motor sensor shows zero while a decoupled load or gravity-driven ram moves (**motor condition true, H false**). Countermeasure: independent hazardous-load observation and holding.
- **False restart authorization**: key return restores control eligibility while an old CNC command persists (**K restored, R false**). Countermeasure: safety reset separated from a deliberate new start, retained queue cleared.
- **Escape failure**: lock requires external tool or cannot be released from inside despite whole-body entry (**P false**). Countermeasure: selected inside escape/personal key, routine usability checks.
- **Maintenance bypass**: a jammed guard/awkward key makes defeating the actuator easier than normal use. Countermeasure: redesign alignment, handles, captive hardware, fault feedback and key location rather than weakening safety.

## Documentary desk-review protocol
A qualified reviewer who has **not** authored the machine design should inspect the restricted as-built evidence without energizing equipment. For each gate: record source revision, component ID, claim classification, failure path, independent discriminator, remaining uncertainty, responsible engineer and HOLD/CONDITIONALLY SATISFIED decision. No physical test is authorized by this document. When a gate needs actual stop/hold/escape observation, freeze a separately approved protected test only after the risk assessment, isolation/remote exclusion, instrumentation and witness plan are signed. Do not manufacture tests to produce an attractive PASS.

## Cross-machine differences
A press brake requires Y1/Y2 hydraulic/gravity holding even if the motor is stopped. A lathe/mill requires spindle coast/tool/chuck containment and separate pneumatic release proof. A robot/cell needs per-person whole-body occupancy and cross-machine reset control. A conveyor/plasma table may have multiple drives, stored pneumatic/vacuum energy, hot/process hazards and long stopping distances. No numerical values or PL/SIL can be transferred from OEM examples.

## Human-factors acceptance
The safer process should be the natural workflow: a visible map at the exchange, correctly located personal keys, simple locked-out service path, aligned hinged guards, reachable inside release, no awkward key jiggling, fault messages that identify the blocking gate, controlled spares, and an easy deliberate restart after clearing the area. If technicians repeatedly bypass the sequence, treat that as a design deficiency requiring correction, not as evidence the guard is unnecessary.

## Evidence state
DOC-CONFIRMED only for original OEM/regulatory source scope. This desk model is **INFERENCE**. No SOURCE-CONFIRMED new LinuxCNC trace; no TEST-CONFIRMED selected machine, no independent score. Physical G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED; no people-exposed hazardous operation. Record conditional selected evidence under IN-04am, not as proof that any named device is installed.
