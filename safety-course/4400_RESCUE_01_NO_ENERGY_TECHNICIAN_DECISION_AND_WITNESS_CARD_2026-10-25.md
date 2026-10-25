# 4400-RESCUE-01 — Technician decision card and blank witness
**Open-book PAPER only | 2026-10-25 | no live entrapment or energized rescue drills**

For each case classify the evidence, identify missing physical proposition, give safe disposition and name the responsible qualified reviewer. Do not perform any actuation.

| # | Adversarial statement or observation | Expected paper disposition |
|---|---|---|
| 1 | “ISO 16092-1 is a press standard, so it is the press-brake Type-C acceptance oracle.” | REJECT: ISO publisher explicitly excludes press brakes; identify correct machine-specific scope. |
| 2 | “ANSI B11.2 applies because our press brake uses hydraulics.” | REJECT: publisher scope excludes powered press brakes; B11.3 is the press-brake family. |
| 3 | “EN 12622 applies everywhere and every edition is identical.” | REJECT: confirm jurisdiction, adopted edition, actual machine and modification. |
| 4 | “E-stop was pressed, so press UP to release the person.” | REJECT as universal script: B35 manual disables normal UP in E-stop state. |
| 5 | “The B35 manual says UP for trapped body parts, so its E-stop must be defective.” | REJECT: conditional availability and rescue route unresolved; do not assert defect. |
| 6 | “Releasing E-stop is necessary; the responder can simply do it.” | STOP/ESCALATE: no approved machine-specific authority, hazard containment or fresh-start proof. |
| 7 | “The side door is open, so a rescuer can use the normal B35 UP pedal.” | REJECT: B35 OEM says normal UP is disabled by side/rear door condition. |
| 8 | “Loss of power means the hydraulic ram will rise safely when a valve is opened.” | REJECT: unknown topology, gravity, pressure, check/hold and support. |
| 9 | “We can follow Cincinnati's hydraulic port instructions on OpenPressBrake.” | REJECT: wrong machine/model/port; potential high-pressure injection and uncontrolled descent. |
| 10 | “A main pressure gauge reads zero; remove the trapped hand now.” | REJECT: no independent hold, clearance or all-zone pressure proof. |
| 11 | “If the beam is stationary, gravity holding is established.” | REJECT: need selected physical fault/hold witness and time basis. |
| 12 | “The HMI says rescue mode; it is therefore personnel-safe.” | REJECT: normal control state is not independent safety authority. |
| 13 | “Opening the guard and moving a backgauge is safe once the ram stops.” | REJECT: separate hazardous axes, zone-specific safeguards and release. |
| 14 | “After rescue, reset should resume the unfinished bend.” | REJECT: new deliberate authorization/start and retained-command suppression required. |
| 15 | “We will prove rescue by putting a volunteer's hand between tools.” | PROHIBITED: no live human entrapment testing. |
| 16 | “The emergency reference is only in the Windows HMI, which is dark in a power failure.” | DESIGN DEFECT: accessible external/offline approved instructions and qualified response needed. |

## Blank selected-machine witness (NOT RUN)
| Evidence ID | Owner | Needed selected artifact / safe witness | Current state |
|---|---|---|---|
| RES-IN-01 | Machine owner | Serial, actual press-brake type, control/guard options, modified as-built drawings | UNKNOWN |
| RES-SCOPE-01 | Qualified safety engineer | Applicable Type-C standard and edition/jurisdiction rationale | UNKNOWN |
| RES-SRS-01 | Safety designer | Hazard-specific stop/hold/rescue/access/energy/rearm requirements | UNKNOWN |
| RES-PWR-01 | Hydraulic/electrical designer | Approved controlled rescue **with** electrical power, independent safeguards and physical load control | UNKNOWN |
| RES-NOPWR-01 | Hydraulic/mechanical designer | Approved **without-power** rescue, support/rigging and residual-energy boundaries | UNKNOWN |
| RES-FAULT-01 | Independent reviewer | E-stop/door/guard/controller fault conditions versus availability of approved rescue means | UNKNOWN |
| RES-PHY-01 | Qualified independent tester | Safe unoccupied, externally observed proof plan; acceptance criteria; no human entrapment | NOT PLANNED / NOT RUN |
| RES-RR-01 | Safety owner | Recovery, responder training, new-start and reset authorization | UNKNOWN |

**No person-exposed hazardous operation until basic selected-machine safety is demonstrated.** No numerical rescue speed, load, pressure, stopping time, PL/SIL or valve sequence supplied.