# 4400-TK-01 — Technician practice and selected-machine witness (blank)
**2026-10-25 | PAPER / NOT BLIND / NOT TEST-CONFIRMED**

## 16 adversarial cases
For each, name the precise key/sensor proposition, a credible defeat or common-cause path, which independent physical or human check is needed, and the lowest-friction safer design. No invented pressure, distance, PL or stopping time.

1. An X box has three access keys. Two workers enter on one key; the first returns it.
2. All three access keys return, but one worker left tools inside the enclosure.
3. Isolation key is trapped at the X box; an accumulator remains charged.
4. Electrical isolator is keyed OFF while hydraulic ram descends under gravity.
5. An access key's spare is stored in an unlocked operator drawer.
6. Door hinge sag means key will not turn without pushing the guard; technician removes the actuator.
7. One personal key is issued for three simultaneous workers.
8. An inside worker discovers the only release handle is outside the fence.
9. A shift changes and the incoming technician assumes the prior worker is out because the main isolation key is at the panel.
10. A maintainer needs brief powered positioning while colleagues remain in the cell.
11. The BEMF key remains trapped on a reversing drive while winding connections change; installer proposes X2–X3 auto reset without examining the circuit.
12. BEMF indicates motor standstill but a conveyor belt coasts through a clutch/coupling.
13. BEMF green indication is used to claim that a pneumatic gripper cannot drop a payload.
14. A controller retains Start while a guard is open; all keys are returned after the guard closes.
15. A selected lock is replaced with a physically similar but differently coded/monitored model.
16. The machine uses an operational trapped key; maintenance team proposes skipping their personal LOTO locks.

## Selected-machine evidence intake — no authorization to energize
| ID | Qualified restricted as-built or protected witness | Status |
|---|---|---|
| TK-01 | Exact installed key exchange, isolation/access locks, serial/edition/coding and controlled spares | UNKNOWN |
| TK-02 | Every access gate, full-body occupancy path, escape provision, per-person key/lock count | UNKNOWN |
| TK-03 | All energy-isolating devices and their physically proven positions, residual pressure/gravity and hold | UNKNOWN |
| TK-04 | Selected BEMF if any: motor/winding/contactor/VFD/reversing topology, fault reset and sensor-to-load path | UNKNOWN |
| TK-05 | Key exchange sequence as-built, lock defeat/actuator/spare-key controls and independent fault feedback | UNKNOWN |
| TK-06 | Covered maintenance personal/group LOTO, test/position/re-isolate and shift transfer | UNKNOWN |
| TK-07 | Independent safety reset/EDM, physical final-element state, occupancy clearance and deliberate fresh start | UNKNOWN |
| TK-08 | Guard alignment, service ergonomics, nuisance defeat incentive and easy restoration | UNKNOWN |
| TK-09 | Qualified protected validation plan and observed result; independent evaluator score | NOT RUN |

If inventory proves no trapped-key/BEMF system, record **N/A with evidence**, not assumed absence. Even if N/A, independent OpenPressBrake Y1/Y2 stop/hold, hydraulic isolation, rear guarding and deliberate restart remain OPEN. G0/G1 HOLD; G3/G4 NOT AUTHORIZED. No physical fault injection or people-exposed operation.

## TK-03 six original-OEM variant transfer cases — PAPER ONLY
17. A Fortress PTU lock is replaced with a PTL device because the handle and connector fit; predict power-loss guard behavior and required evidence.
18. An unmonitored-solenoid NC actuator/key circuit remains closed after unlocking; why can a PLC/relay's "guard closed" bit mislead?
19. An SR escape release opens NC head contacts, but the replacement SE variant opens NC solenoid contacts; identify the terminal truth table to revalidate.
20. A LOK body takes repeated door impact because no separate guard stop is installed; explain the manufacturer warning and inexpensive remedy.
21. A technician leaves the auxiliary release tool installed for convenient entry; distinguish controlled recovery from foreseeable defeat.
22. The LOK part advertises up to PLe/Cat4; the team proposes removing the main isolator and hydraulic ram restraint. Explain why the OEM explicitly forbids the inferred substitution.

**Total 22 learner-visible PAPER cases.** None is a blind score, qualified machine test or safety authorization.

## 2026-10-30 original-source follow-through — TWO NEW unscored discriminators (not a second TK competency)
23. **OSHA 2021 group-lockout comparison:** Three authorized workers are replacing a pump. An operations employee isolates and locks all sources; a supervisor attaches their single lock to the lockbox and maintains a crew sign-in log, but no worker applies their own lock. Compare this with the May 21, 2021 OSHA letter's rejected Scenario 1 and accepted nested/satellite-lockbox Scenario 2. Identify what each worker must control for covered servicing, and how a trapped-key personnel key differs from an individual personal LOTO lock. [Original OSHA interpretation](https://www.osha.gov/laws-regs/standardinterpretations/2021-05-21); [source-delta audit](../research/4400_TRAPPED_KEY_01_FORTRESS_ISO14119_SEQUENCE_PERSONNEL_KEY_VS_GROUP_LOTO_SOURCE_AUDIT_2026-10-30.md).
24. **OEM device commissioning versus machine proof:** A Fortress amGardpro LOK gate passes key/actuator, contact and LED tests, but the installer has not inspected auxiliary-release custody or the manufacturer's p.16 maintenance interval. State the OEM 5,000-cycle / at-least-twice-annually inspection recommendation, identify physical escape/override tests reserved for qualified isolated conditions, and explain why these device checks do not prove independent ram/spindle stop or stored-energy isolation. [Original OEM p.15–16 addendum](../research/4400_TRAPPED_KEY_02_FORTRESS_2025_PTU_PTL_ESCAPE_OVERRIDE_AND_COMMISSIONING_OEM_AUDIT_2026-10-30.md).

These are **PUBLIC UNSCORED PAPER** exercises; no hidden evaluator answer, machine test, or changed G0/G1 HOLD. The 2026-10-25 TK-01/02/03 module remains the canonical teaching path.
