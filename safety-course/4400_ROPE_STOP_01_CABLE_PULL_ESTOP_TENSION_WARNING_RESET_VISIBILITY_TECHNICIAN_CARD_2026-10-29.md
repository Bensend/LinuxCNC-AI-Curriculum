# 4400-ROPE-STOP-01 — Cable-pull E-stop technician field card

**2026-10-29 | OPEN-BOOK / UNSCORED | NO LIVE-MACHINE TEST AUTHORIZED**

Read [the original Rockwell/Schmersal source audit](../research/4400_ROPE_STOP_01_ROCKWELL_SCHMERSAL_PULL_WIRE_TENSION_BREAK_RESET_VISIBILITY_OEM_AUDIT_2026-10-29.md) after 2530 E-stop span/reset and 4400-RST-01 power-return/fresh restart.

## One-minute mental model

A cable-pull E-stop is **complementary emergency stopping**, not a moving guard, maintenance isolator, standstill sensor or machine clearance detector. Four separate things must be true: the rope can be reached and actuated along its actual span; the selected switch reports pull/break correctly; independent safety logic and physical final elements stop/hold the hazard; and reset is deliberate, visible/verified, and never itself a start command.

**Rockwell Lifeline 5 February 2026 manual, Tables 6–7:** GREEN with amber flashing tension warning may still mean safety outputs ON. **Do not call this perfect cable health.** Broken/not-tensioned cable instead reports safety outputs OFF. **Schmersal ZQ700 September 2021 manual:** correctly tensioned cable holds NC contacts closed; pull or break activates a latched stop, released only after cause and tension are checked. Never transfer one family's length, cable force, contact, timing or reset assumptions to the other.

## Paper scenarios and expected discriminators

1. **A conveyor operator sees green status plus amber flashing tension.** Do not silently ignore it or tell the operator the rope is fully healthy. In the cited Rockwell model the safety outputs can remain ON; preserve a maintenance/inspection warning and qualified correction path. No live intervention while people are exposed.
2. **A cable is cut behind a conveyor.** Verify the exact selected switch and downstream safety circuit detect loss of tension as a stop demand; a disconnected ordinary CNC input or HMI alarm is not sufficient. Actual installation UNKNOWN.
3. **A reset button is around a blind corner.** The cited Rockwell manual requires visibility of the whole rope or inspection along its length before and after reset. Even that is not proof that all personnel are clear; derive machine-specific zone-clear and separate fresh-start conditions.
4. **A technician wants to pull the rope while the press brake is running to “test safety.”** Do not conduct an ad hoc personnel-exposed test. Obtain qualified, separately authorized and physically isolated test procedures, independent safety evidence and residual-risk controls first.
5. **A conveyor stops but a suspended load can fall.** An E-stop command does not establish mechanical holding; require the independent physical safe-state proposition and qualified evidence for the load.

## Low-friction design review

Keep the rope reachable and unobstructed, label its span and reset location, use the selected OEM's tension spring/anchors/guides, expose maintenance warnings before nuisance trips tempt bypass, and make legitimate adjustment/inspection easier than defeating the device. Provide an unambiguous separate start control. A fixed guard is still required where the risk assessment calls for prevention of contact with moving parts.

## Record without operating

For an actual installation, obtain exact OEM/model/edition, passive photographs of cable routing and reset visibility where safe, selected safety-controller input/final-element diagrams, maintenance records and a qualified validation plan. **Do not open cabinets, pull ropes, move machinery, or change wiring merely to fill this card.**

**Evidence:** OEM statements DOC-CONFIRMED; human-factor consequence INFERENCE; installed machine and physical performance UNKNOWN; TEST-CONFIRMED none. **G0/G1 HOLD; external evaluator OPEN.**
