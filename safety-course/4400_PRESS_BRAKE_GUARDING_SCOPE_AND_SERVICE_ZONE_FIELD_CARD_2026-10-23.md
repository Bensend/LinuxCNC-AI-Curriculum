# 4400 — Press-brake safeguarding scope and service-zone verification field card
**Open-book, non-blind technician/designer exercise | 2026-10-23.** Paper exercise only; no fault injection, machine operation or personnel exposure authorized.

Read the [source applicability audit](../research/4400_PRESS_BRAKE_OSHA_SCOPE_SAFE_DISTANCE_AND_MAINTENANCE_TRANSFER_AUDIT_2026-10-23.md), the [selected-machine physical witness intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md), OSHA 1910.217(a)(5), OSHA directive CPL 02-01-025 and OSHA 1910.147(d)(5)–(6). Record each answer as `DOC-CONFIRMED`, `INFERENCE` or `UNKNOWN` with a source or machine evidence request. Do not grade against a hidden key.

## Field scenario
A shop has retrofitted a hydraulic press brake with LinuxCNC, a normal FPGA controller, front optical guarding and a foot pedal. A helper sometimes holds long sheet stock; the backgauge moves independently. The maintenance screen displays **Pump Off**, **Pressure 0**, **Guard Healthy** and **Reset Ready**. No as-built hydraulic diagram, load-holding validation, guard geometry, selected standard edition or safety-controller functional test has been supplied.

The operator wants to perform a short custom bend while the guard is inconvenient. The technician wants to reach under the raised ram to replace tooling, then energize a valve briefly to check it. The designer cites a 1986 OSHA six-inch letter, a 1997 four-inch directive, and a 1910.217 mechanical-power-press stop-distance example.

### Ten challenge decisions — record the proof needed
| Case | Proposed shortcut | Decide what is established and name the next independent evidence |
|---|---|---|
| 1 | Apply 1910.217 mechanical-press clutch/brake provisions directly to the hydraulic press brake. | Machine-class applicability and actual guarding rule. |
| 2 | Select six inches because an OSHA 1986 letter prints it. | Historical source status and the letter's editorial correction. |
| 3 | Select four inches from the 1997 directive as a universal optical sensor-to-die distance. | Narrow safe-distance exception versus installed sensor positioning. |
| 4 | Assume custom/short-run work automatically permits an unguarded bend. | Feasibility, production conditions, helper, supervision, procedures and current site requirements. |
| 5 | Regard a front optical beam as covering the helper's sheet sweep and rear backgauge. | Mode-specific reach and hazard map, installed field geometry. |
| 6 | Treat LinuxCNC machine-off and FPGA inhibit as energy isolation. | Actual isolating devices and their independent verification. |
| 7 | Trust one zero-pressure HMI value to prove safe tooling access beneath the ram. | Actual port/zone mapping, trapped pilot/accumulator pressure, independent physical ram restraint. |
| 8 | Treat a safety relay reset as both restart authorization and proof the ram is held. | Independent physical hold and new deliberate ordinary start after reset. |
| 9 | Perform a powered valve check while the technician stands at the die. | Qualified temporary test plan, personnel clearance, containment, return to isolation; no test on this card. |
| 10 | Make the optical guard removable because the operator keeps bypassing it for long sheets. | Human-factor redesign that retains validated coverage, helper visibility, safe setup access and simple reinstallation. |

## Empty selected-machine intake / witness handoff
| Proposition | Selected proof artifact (must be supplied) | Current state |
|---|---|---|
| Scope / site applicability | Machine and task identity; OSHA/state/ANSI/Type-C edition; current competent applicability review | UNKNOWN |
| `PHY-STOP` | Independently witnessed stop response for every exposed mode and geometry | UNKNOWN |
| `PHY-HOLD` | Physical ram/load restraint or independently qualified load-holding proof under credible failures | UNKNOWN |
| `PHY-ACCESS` | Guard/laser installation, reach, sheet sweep and rear/side access; muting/blanking changes | UNKNOWN |
| `PHY-ESCAPE` | Actual physical exit under power/fault conditions without relying on HMI | UNKNOWN |
| `PHY-ENERGY` | Walkdown of isolation devices, pressure zones, accumulators, mechanical blocking and reaccumulation checks | UNKNOWN |
| `PHY-RESTART` | Safety reset does not create motion; retained command cleared; fresh intentional start and independent motion witness | UNKNOWN |

**Service-zone witness checklist (to be populated only by qualified staff with as-built drawings):** list every exposed zone; exact component/order code and physical tag; energy source and direction; isolator; physical restraint; pressure/test point and which side of which valve it observes; potential alternate/reaccumulating feed; method of verifying isolation without entering the hazard; personnel accountable; authorized return-to-service procedure. Never equate “one gauge reads zero” with “all zones safe.”

## Expected reasoning and adversarial review (open-book)
A defensible answer identifies the OSHA 1910.217(a)(5) exclusion **without claiming no safeguarding duty**, uses 1910.212 and task-specific energy-control authority, treats the 1986 and 1997 distances as **dated and differently scoped**, and refuses any generic distance without the installed machine's risk assessment and protective-device validation. It separates an ordinary LinuxCNC request, safety-related control function, physical final element and independent load/energy witness.

The learner must explicitly mark all seven selected-machine propositions UNKNOWN. A correctly reasoned **HOLD** is a successful result, not a failed exercise. Record one redesign that makes safe loading/tool change faster and easier than removing the guard, plus a review trigger for any changed guard, mode, valve or tooling.

**Stop line:** No evidence here authorizes personnel-exposed hazardous operation, entry beneath an unsupported ram, bypassing an installed guard, or energizing a hydraulic system for a demonstration. If basic safe-to-operate conditions are absent, any development activity must be isolated/remote with people outside the hazard zone and residual risk documented.

## Evidence integrity and next work
This is a new learner exercise, not one of the six missing exact historical archive files. `TEST-CONFIRMED`: none. `SOURCE-CONFIRMED` LinuxCNC code: none newly inspected. `DOC-CONFIRMED`: official OSHA sources identified in the companion audit. `INFERENCE`: failure paths and human-factors design responses. `UNKNOWN`: all installed machine facts, test acceptance limits, ratings, distances and physical validation. External 2520–25F0 blind/fresh gates remain independent and open.
