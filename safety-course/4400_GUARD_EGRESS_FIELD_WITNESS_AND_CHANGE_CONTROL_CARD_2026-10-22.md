# 4400 field card — Egress must be physically possible, not merely electrically indicated

**Design/verification worksheet only.** This is not a permission to run an exposed-person test. All acceptance criteria and hazard-specific limits must come from the actual machine risk assessment and selected component instructions.

## A. Identify the real installation

| Required item | Selected fact / source | Status |
|---|---|---|
| Machine/guard ID and hazard boundary (`BND/HAZ`) | | UNKNOWN |
| Guard lock full order, version, actuator and cable/release accessory | | UNKNOWN |
| Manufacturer manual edition and documented release mode | | UNKNOWN |
| Physical door direction, latch/hinge, stops, misalignment and loading | | UNKNOWN |
| Inside escape reachability and outside non-access | | UNKNOWN |
| Guard actuator tensile load under normal/faulted conditions | | UNKNOWN |
| Bowden routing, bend radius, attachment and wear if fitted | | UNKNOWN |
| Ordinary release request and independent safety-related unlock owner (`AUTH`) | | UNKNOWN |
| Guard state safety outputs versus monitoring outputs and receiver compatibility | | UNKNOWN |
| Relevant independent stopped/held/hazard-controlled physical witnesses | | UNKNOWN |
| Power loss and restoration with a person inside | | UNKNOWN |
| Manual-release reset/rearm and separate ordinary start | | UNKNOWN |

## B. Distinguish three transactions

| Transaction | Purpose | Evidence before action | Evidence after action | Must not substitute |
|---|---|---|---|---|
| Normal production access request | Prevent access until relevant hazards have ended, then allow ordinary access | Qualified independent safety stop/hold plus selected guard-unlock authority | Physical guard opening and restart prevention | LinuxCNC state or lock output alone |
| Inside escape/emergency release | Allow egress when ordinary access fails; release itself may trigger safety outputs OFF | Installed reachability and no-tool mechanical operation per selected device | Actual physical egress, machine protective response, release restoration check | OD state (may be undefined), automatic safe motion, maintenance isolation |
| Maintenance servicing | Control unexpected energization, stored energy and gravity/external loads | Actual isolators, worker protection, physical restraint, verified isolation, credible reaccumulation monitoring | Re-isolation after temporary test, worker release, inspection and controlled restart | E-stop, escape release, valve feedback or a single indicator |

## C. Adversarial witness conflicts

| Conflict to resolve before acceptance | Possible mechanism | Independent evidence to obtain |
|---|---|---|
| FO OFF and OL OFF, OD still ON | OD unspecified on manual release; diagnostic mismatch not proof of physical state | Physically established door/actuator/release condition |
| Release commanded, gate still stuck | Mechanical load, misalignment, damaged linkage or cable | Mechanical inspection/isolated function check under justified conditions |
| Guard closed/locked, person inside | Power-loss re-lock or incomplete occupancy protection | Egress/occupancy and independent restart-inhibit design |
| Guard output healthy, hazardous axis drifts | Output observes lock, not motion/holding | Independent relevant stop/hold/energy witness |
| Gauge zero, accumulator/ram still hazardous | Disconnected trapped zone, gas precharge, gravity | Selected hydraulic connectivity, stored-energy control, mechanical restraint |
| Reset accepted while ordinary start retained | Reset/start conflation | Deliberate reset edge and separate start validation |

## D. Change triggers and practical human factors

Create `CHG-*` and mark affected `VAL/PT` evidence `STALE` after switch substitution, actuator/bracket changes, guard hinge/latch movement, cable rerouting, controller input-filter changes, firmware/config updates, maintenance-release use, or significant damage. Revalidate only affected dependent propositions, not unrelated evidence.

Favor a hinged/captive, aligned guard with visible latch engagement, a clearly located escape control, simple reset instructions, and remote diagnostics that do not require defeating the guard. If safe access is slow or inconvenient, redesign the access workflow rather than relying on warnings. Keep manual-release tools/keys managed so bypass is not the easiest way to do normal work.

## E. Disposition

- [ ] DOCUMENTARY/SCHEMATIC REVIEW ONLY — physical evidence incomplete.
- [ ] ISOLATED PHYSICAL VALIDATION PLAN READY — machine-specific procedure, hazards and witnesses reviewed; **not yet executed**.
- [ ] MACHINE VALIDATION EVIDENCE REVIEWED — requires actual recorded results, independent reviewer and risk assessment; **cannot be checked from this generic worksheet**.

If basic protection/egress/holding is not established, no person-exposed hazardous operation. Remote/isolated experiments require people outside the danger zone and residual-risk controls.

Sources: EUCHNER 2124217-08-06/21 §§3, 6.8, 7.1–7.4, 10, 11; EUCHNER 2126290-08-07/24 §§2–3, 6.8; OSHA 29 CFR 1910.147(d)(5)–(6) and interpretation 2012-12-12. Source URLs and claim classes in accompanying research/ledger.
