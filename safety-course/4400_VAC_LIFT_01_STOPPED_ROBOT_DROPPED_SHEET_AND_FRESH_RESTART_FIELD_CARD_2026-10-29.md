# 4400-VAC-LIFT-01 — The robot stopped, but did the sheet fall?
**2026-10-29 | public unscored technician practice, NOT a physical test, scored evaluation or permission to operate.**

Start with the [original Schmalz/Piab/OSHA source audit](../research/4400_VAC_LIFT_01_SCHMALZ_PIAB_POWER_LOSS_DROP_VS_SEALED_VACUUM_RETENTION_OEM_AUDIT_2026-10-29.md), then use this card as a desk review of a **hypothetical** robot sheet feeder or vacuum lifting cell. Do not claim any such gripper is installed on OpenPressBrake.

## One-minute mental model
A motion E-stop, vacuum pump command, retained payload, clear falling-object zone, maintenance isolation and permission to restart are **six different propositions**. The original Schmalz FMP(-S) 2019 manual warns of payload release on generator or pilot-air loss, including air loss from E-stop; Piab piSAFE/VSV describes conditional retention **for sealed applications**. Neither an HMI `VACUUM_OK` bit nor a stopped robot proves safe human access.

| What is visible | What it may tell you | What it does **not** establish |
|---|---|---|
| LinuxCNC/robot STOPPED | Ordinary motion command/status | Load cannot drop; other axes cannot move; safe access |
| Pump power OFF | Generator supply status | Vacuum preserved; cup sealed; physical hold |
| Vacuum switch TRUE | Local measured vacuum under its exact sensor conditions | All cups carry the load; no stale data; independent protection |
| Check valve fitted | A possible sealed-volume retention mechanism | A porous/warped part stays attached; certified machine-level PL/SIL |
| Guard OSSD clear | Its particular protective field not interrupted | No person in occluded drop zone; reset/restart allowed |
| Safety reset accepted | One safety-controller state transition | Load recovered, area cleared, or fresh motion start authorized |

## Eight unscored paper scenarios — identify hazard, authority, physical proof and recovery
1. An operator presses E-stop while a Schmalz FMP-S sheet gripper is carrying a plate. The robot drive stops, and the compressor safety dump exhausts pilot air. A supervisor says “the E-stop worked, so the sheet is safe.” Explain the two distinct physical hazards and the OEM limitation.
2. A Piab piSAFE VSV product page says it retains vacuum during power failure. The handled material is porous cardboard, not a sealed plate. What exact manufacturer and workpiece evidence is needed before claiming retention? Does the product page alone prove it?
3. Two vacuum switches read “good” but share one manifold and a single cable/24-V supply. Can these be counted as two independent load-holding final elements? Explain common-cause and stale-status paths.
4. The robot is stopped but the sheet remains suspended above a maintenance access door. Someone proposes an automatic blow-off command when E-stop is reset. Trace why **reset**, **payload release**, **hazard clearance**, and **new start** cannot be collapsed.
5. A sheet becomes oily and bows under acceleration; only the outer suction cups remain sealed. A single pressure sensor still reads high vacuum. What should the physical proof plan examine besides sensor state?
6. A technician must replace a cup directly beneath a suspended workpiece. Identify the minimum safe-to-service boundary; explain why “pump off” and “check valve present” are not maintenance isolation.
7. A cell uses an ordinary LinuxCNC output to keep a vacuum solenoid energized during a safety stop. What failure occurs if the CNC host or its output power fails? Which decisions must remain outside ordinary CNC software?
8. A shop repeatedly defeats the interlocked guard because retrieving fallen sheets requires crawling inside the robot's fenced drop zone. Propose a **low-cost human-factors redesign** that reduces exposure rather than telling operators to follow a harder procedure.

## Blank reviewer worksheet (copy only for a selected machine)
`Machine ID/revision | Handling task/modes | Load/workpiece/height | Drop-zone geometry | Gripper/pump/valve/cup option and OEM document | Electrical-loss behavior | Pilot-air-loss behavior | Seal/partial-cup failure | Independent safety logic | Physical retention/landing mechanism | Guard/access | Isolation/service restraint | Reset vs new start | Qualified witness ID | UNKNOWN/STALE/HOLD`

**Stop rule:** If credible load retention or exclusion of all people from the drop zone is not established, the machine is **not safe for personnel-exposed operation**. Do not perform a deliberate load-drop test, energize the machine, enter the hazard zone, or bypass a guard to complete this card. Any future experimental operation needs independent approval and remote/isolated execution with no exposed personnel.

**Competency status:** public practice only, no answer key, no independent evaluator or machine evidence. 2520/2580/2590/25F0 external gates OPEN; OpenPressBrake G0/G1 HOLD.

## Two adjacent material-handling transfer prompts (unscored)
The [2026 Eclipse Optimag E/P magnetic-lifter original-source audit](../research/4400_MAG_LIFT_01_ECLIPSE_2026_POWER_LOSS_HOLD_WLL_CONFLICT_AND_RELEASE_INTERLOCK_OEM_AUDIT_2026-10-29.md) contrasts a **bistable permanent magnet** with vacuum adhesion. These are different physical mechanisms, not interchangeable parts.
9. A magnet remains ON after power is isolated. The operator says LOTO has removed every hazard. Explain the retained magnetic field, suspended load and positive-support/release boundary.
10. A vendor's 2026 Optimag E PDF headline says 600 kg, while its Performance box and listed standard models top out at 400 kg. A painted, thin sheet is proposed. What exact OEM and physical evidence must be obtained, and why is neither number a selected-machine safe load?

## Original Piab manual release-path challenge (unscored)
11. The central piSAFE VSV manual (©2024, printed p.23) warns that unequal daisy-chained release hoses can make cups release at different times. A robot is stopped and the plate is over a conveyor. Does STOPPED plus an ordinary `RELEASE_DONE` HMI bit prove the plate cannot pivot/peel? What physical support, selected release plumbing, guarded drop zone and qualified witness would be required? Its printed p.30 `<0.75 kPa/min toward 10 mL` leak specification is **not** a full-sheet hold-time guarantee.
