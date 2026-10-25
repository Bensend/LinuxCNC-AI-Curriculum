# 4400-RESCUE-01 — Entrapment release, E-stop authority and deliberate rearm
**4000 safety implementation curriculum | 2026-10-25 | NON-GRADUATED / DOCUMENTARY | prerequisites: 2520, 2530, 2580, 2590, 25E0, 3600 archived press-brake learning**

## Learning outcome
Given a real press-brake manual and an unknown retrofit, distinguish **preventing motion**, **holding a gravity load**, **releasing a trapped person**, **isolating stored energy**, and **restarting deliberately**. Select the correct machine-specific standard family before assigning an acceptance criterion. Reject generic instructions that silently require rearming a hazardous machine.

## Source-first study
Read [original 4400-RESCUE-01 audit](../research/4400_PRESS_BRAKE_TYPE_C_SCOPE_AND_TRUBEND_ESTOP_RESCUE_CONFLICT_AUDIT_2026-10-25.md), [Cincinnati rescue/LOTO audit](../research/4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md), [selected-machine intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md), OSHA 1910.147, ANSI B11.3-2022 publisher scope and TRUMPF B35 2023 OEM manual. No claim is made about installed OpenPressBrake hydraulics or actual rescue behavior.

## Scope gate (must precede safety-function allocation)
1. Identify actual machine function, design/retrofit vintage, jurisdiction, exposure modes and ancillary equipment.
2. **DOC-CONFIRMED publisher:** ANSI B11.3-2022 is for power press brakes. ANSI B11.2's hydraulic-power-press scope excludes powered press brakes. ISO 16092-1 explicitly excludes press brakes; ISO 16092-3 is not an automatic press-brake-specific replacement. EN 12622 is a hydraulic press-brake scope in its European context. Verify actual adopted/required edition separately.
3. Do not import a generic hydraulic-press speed, support, guard or rescue requirement into a press brake by matching the word “hydraulic.”

## Physical propositions and authorities
| Proposition | What ordinary CNC can do | Independent authority and witness needed |
|---|---|---|
| STOP | Request/indicate stop | Actual hazard-specific stopping via selected safety system/final element and independent motion witness |
| HOLD | Display position | Gravity-safe holding under fault, physical load path/restraint and independent witness |
| RESCUE | Display approved instructions/status | Qualified person and approved **machine-specific** controlled release with and without power, including avoidance of second crush |
| ENERGY | Display gauge/valve state | Isolate/verify every relevant zone; account for accumulators, pilots, trapped and reaccumulating energy; mechanical restraint |
| ACCESS | Indicate guard | Physical safe access, guard/escape geometry and correct mode behavior |
| RESTART | Discard program requests on fault | Independent safety reset/rearm authority plus deliberate fresh start, no automatic retained-command movement |

## The OEM paradox to reason through
TRUMPF B35 B1161en 2023-05-01 states that E-stop disables the normal UP footswitch; the same manual's residual-risk table refers to that UP footswitch for trapped body parts. These statements are **both** OEM documentary observations. The correct response is **not** to invent an override or assume E-stop is wrong. Instead identify missing operating-state assumptions and obtain the exact qualified rescue path for this machine. Cincinnati's separate model-specific power/no-power release demonstrates why emergency response cannot be reduced to one universal button sequence.

## Practical architecture / no bypass incentive
Provide a visible exterior rescue-plan location, labeled qualified responder roles, accessible approved support/isolation resources, documented power-present/power-absent branches, and a safe rehearsal method without trapped people. Do not make rescuers choose between a blocked emergency path and an undocumented bypass. Avoid making safety authority dependent on a Windows UI, normal FPGA, web app, single gauge, or a remote network link. A human-accessible manual is a **supporting layer**, not a substitute for engineering and physically verified protection.

## Minimum operational threshold
Until selected stop, gravity hold, protective coverage, isolation and restart are demonstrated, **no operation with people exposed to the hazard**. Remote/isolated development needs separate qualified risk review, physical exclusion and residual-risk statement. A rescue document does not lower that threshold.

## Exercise, verification and independent assessment
Use [16-case technician card](4400_RESCUE_01_NO_ENERGY_TECHNICIAN_DECISION_AND_WITNESS_CARD_2026-10-25.md), [12-gate no-energy review](4400_RESCUE_01_12_GATE_NO_ENERGY_DESK_REVIEW_2026-10-25.md), and [fresh evaluator assignment](../evaluation/4400_RESCUE_01_FRESH_SCOPE_AND_ENTRAPMENT_TRANSFER_HANDOFF_2026-10-25.md). All paper cases are learner-visible, **not blind scores**. Physical VAL/PT NOT RUN; independent evaluation NOT RUN.

## Open questions / promotion
Actual OpenPressBrake rescue with/without power, hydraulic release direction, independent load restraint, required performance level, guard/UP state machine, egress and selected numerical criteria **UNKNOWN** and block selected-machine authorization. They cannot be promoted away to certify this machine. Curriculum source lesson remains NON-GRADUATED pending fresh independent transfer and selected evidence where applicable.