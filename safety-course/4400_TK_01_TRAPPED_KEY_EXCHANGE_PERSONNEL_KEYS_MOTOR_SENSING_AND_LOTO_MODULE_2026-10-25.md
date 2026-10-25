# 4400-TK-01 — Trapped-key access is a sequence, not an all-energy/occupancy certificate
**4000 safety curriculum | 2026-10-25 | SOURCE READING / NON-GRADUATED**

## Prerequisites and learning outcome
Prerequisites: 2520 hazard/SRS, 2580 isolation, 2590 guards, 4400-GUARD-01 escape/auxiliary release, 4400-BLK-01 gravity restraint/LOTO, 4400-RST-01 reset/EDM, 4400-CELL-01 whole-body occupancy. Fresh learner must trace a real OEM mechanical key sequence, identify its precise claim, distinguish personal access keys from servicing lockout, identify BEMF motor sensing versus load movement, and design a usable independent energy/occupancy/fresh-start boundary.

Original research: [Castell X + DOLD STS + OSHA audit](../research/4400_CASTELL_X_DOLD_STS_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEY_AND_LOTO_SOURCE_AUDIT_2026-10-25.md) and [Castell BEMF motor sensing audit](../research/4400_CASTELL_BEMF_MOTOR_STANDSTILL_AUTO_RESET_VS_HYDRAULIC_LOAD_SOURCE_AUDIT_2026-10-25.md). Practice and blank evidence: [TK-01 technician card](4400_TRAPPED_KEY_ACCESS_PERSONNEL_AND_ENERGY_TECHNICIAN_CARD_2026-10-25.md).

## Hazard boundary and four layers
| Layer | What it establishes if designed/validated correctly | What it does NOT establish |
|---|---|---|
| **Mechanical key exchange** | Specified isolator/access key ordering; source Castell X Issue 7 | Actual contacts/valves, every energy source, no persons inside |
| **Personnel exclusion / escape** | Correctly designed personal key/lock prevents rearm while its holder is inside; DOLD STS example | Everyone actually has a key, no duplicated keys, escape is accessible |
| **Energy isolation and physical holding** | Qualified isolation, discharge, restraint and verification of each hazardous source | That a motor winding reads zero, or a PLC green bit |
| **Independent safety rearm + fresh start** | Safety eligibility after deliberate reset, then new normal command | Automatic motion on returning keys, prior CNC queue safety |

### Selected-machine design transaction (DESIGN INFERENCE, not safety software)
1. **Prepare:** identify people, doors, all electrical/hydraulic/pneumatic/gravity sources, downstream shared machine zones, residual motion and maintenance task. Freeze correct lock/key register and documented isolation boundaries.
2. **Stop and isolate:** initiate the risk-assessed safe stop; physically isolate **all** relevant sources, relieve or restrain stored energy, verify actual safe state. Motor stop/BEMF, CNC feedhold or E-stop alone is insufficient.
3. **Exchange:** only after selected isolation is valid, remove primary key, trap it at exchange box and release the correct access keys. Any missing, spare, duplicated or unaccounted key blocks approval.
4. **Enter:** use selected access key and personal key/lock for **each** exposed worker or equivalent qualified arrangement; confirm accessible inside escape and no hazardous trapped zone. Key return is not a personnel-count sensor.
5. **Service:** follow OSHA-covered maintenance energy control, individual/group lockout, test/position/re-isolate and shift-change accountability where applicable; never treat an operational access key as automatic substitute for personal LOTO.
6. **Leave and rearm:** physically inspect every area and tool, reconcile personnel and keys, close/verify guards, restore independent safety eligibility and fault feedback, then require a deliberate **new** normal LinuxCNC start. No queued-motion resumption from key return alone.

### Counterexamples to naive key authority
- Two workers share one door key; one exits and returns it while the other remains inside. Key sequence alone permits a false occupancy inference.
- An electrical motor isolator is keyed OFF while accumulator pressure or gravity remains; keys do not physically hold a hydraulic beam.
- A mechanical access lock has a spare key or defeated actuator; the exchange appears valid but access containment fails.
- A motor-sensing BEMF detects zero winding back EMF; a decoupled shaft or suspended hydraulic load can still move.
- A BEMF installer links X2–X3 for OEM-described broken-wire auto reset; do not confuse this with CNC start authorization or a universal safe reset.
- A safety key cannot be returned because guard alignment is difficult; address the guard hardware, not by defeating the key system.

### Machine-specific applications
**Press brake:** consider trapped-key protection for rear maintenance doors only if qualified hazard assessment supports it; independent Y1/Y2 stopping, ram gravity holding, stored hydraulic energy, rear backgauge and fresh start remain separate. **Mill/lathe:** BEMF may supervise a suitable motor, but spindle/tool coast, mechanical coupling and pneumatic drawbar remain distinct. **Robot/cell:** every person crossing whole-body entry needs protection from being locked in; shared cell reset must not restart a robot or conveyor. **Plasma/conveyor:** cutting energy, fume/torch sources, gravity/pneumatics and multiple drives may outlive motor OFF.

## Human factors and inexpensive design
Use mechanical exchange where long cable runs, multiple doors and harsh environments make it practical; choose clear key labeling and physical sequence map, easily operated correctly aligned hinged guards, personal key holders and padlock provisions, accessible inside escape, controlled spare-key cabinet, simple fault indication and easy reassembly. Audit the temptation to leave a key inserted, defeat a lock or hold a guard shut with a clamp: such behavior reveals a design/usability problem to fix, not a permission to bypass.

## Claim ledger and graduation
- **DOC-CONFIRMED:** Castell X Issue 7 exchange ordering and inspections; DOLD STS guide personal-key/fault mechanisms; Castell BEMF Issue 3 motor-sensing and topology-dependent broken-wire/auto-reset advice; OSHA 1910.147 servicing requirements.
- **SOURCE-CONFIRMED:** no new LinuxCNC source. Ordinary LinuxCNC/FPGA has **no personnel-safety authority**.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** proposed architecture and adversarial failures. **UNKNOWN:** installed key/BEMF system, key count/coding, full energy map, physical Y1/Y2 stop/hold, all-worker exclusion, selected PL/SIL, reaction/stopping and independent evaluation.
- **Status:** NOT GRADUATED. Selected evidence conditional only. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN. No people-exposed operation without independent qualified safety proof. Lab not justified: OEM sequence and fault boundaries resolved by source reasoning; actual selected machine evidence must be physically obtained by qualified team.

## Independent assessment
Learner-visible practice cases are **not blind competency scores**. A fresh independent evaluator must construct a new case with withheld solution, collect immutable prediction and confidence before reveal, then score according to the repository blind protocol. Do not read a hidden key to self-grade.

## TK-03 exact guard-lock variant extension — original Fortress manual
The [Fortress amGardpro LOK source audit](../research/4400_FORTRESS_LOK_LOCK_MONITOR_VS_PROCESS_ONLY_AND_ESCAPE_CONTACT_VARIANTS_AUDIT_2026-10-25.md) **DOC-CONFIRMS** distinct PTU/PTL power-loss behaviors, monitored versus unmonitored solenoid contacts, and SR/ZR/LR versus SE/LE escape-release contact transitions. The manufacturer explicitly says LOK is **not a mains isolator, E-stop or mechanical stop**. An unmonitored process-locking variant's NC actuator contacts can remain closed when the solenoid unlocks. A mechanically successful escape release can change different contacts depending on body configuration. A lookalike replacement is therefore not equivalent without exact part number, terminal/diagram and independent safety-function review. Manufacturer up-to-PLe/Cat4 claim is configuration-dependent. Add six [PAPER cases](4400_TRAPPED_KEY_ACCESS_PERSONNEL_AND_ENERGY_TECHNICIAN_CARD_2026-10-25.md); now 22 total, none scored. Selected hardware/physical proof UNKNOWN.
