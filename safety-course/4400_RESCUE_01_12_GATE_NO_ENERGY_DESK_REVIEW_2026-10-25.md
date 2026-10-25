# 4400-RESCUE-01 — 12-gate no-energy rescue and standards-scope review
**2026-10-25 | engineering desk review; every selected-machine gate UNKNOWN / NOT RUN. No energized test authorized.**

| Gate | Evidence question | Reject if |
|---|---|---|
| R01 | Is the machine actually a press brake, with selected jurisdiction, edition and modification history? | Standard picked by “hydraulic” keyword alone. |
| R02 | Is the correct machine-specific Type-C standard selected, not ISO 16092-1 or B11.2 misapplied? | Press-brake scope exclusion ignored. |
| R03 | Are all people/hazard zones mapped (front, rear, sides, workpiece sweep, Y1/Y2, backgauge)? | Ram-only map. |
| R04 | Is the safety-related stopping function separate from ordinary LinuxCNC/FPGA stop request? | HMI bit treated as physical stop. |
| R05 | Is gravity/load holding independently credible during E-stop, power loss and hydraulic failure? | Static position alone. |
| R06 | Is the selected E-stop/guard/UP availability state chart supported by exact manuals, schematics and review? | Assumed universal UP-after-E-stop. |
| R07 | Is an approved, trained, accessible **power-available** rescue path documented without creating another crush? | Unreviewed safety reset or guard defeat. |
| R08 | Is an approved **power-unavailable** path documented with qualified restraint/support and no improvised pressure release? | Copying another OEM lifting/bleed sequence. |
| R09 | Are trapped hydraulic/gas/pilot zones, mechanical loads and reaccumulation accounted for? | One gauge/valve feedback considered enough. |
| R10 | Can rescuers access instructions and contact qualified responders if the panel PC and network are dead? | HMI-only instructions. |
| R11 | Does recovery require verified clear zones, restored guards, safety rearm and **new deliberate start**? | Reset triggers motion/retained command. |
| R12 | Is independent safe **unoccupied** physical validation planned only after IN-01..10 and approved exclusion? | Live human entrapment demonstration. |

## Desk-only fault challenges
- E-stop stops motion and disables UP; no documented alternative: **HOLD** until qualified rescue plan.
- Power restored while retained downstroke command exists: require independent fresh-start proof, not a LinuxCNC GUI flag.
- Rescuer opens a guard to approach the tool: validate access, secondary motion, load support and rescue authority separately.
- Fault causes zero main gauge but pressurized cylinder chamber remains: do not infer isolation.
- One standards document is quoted for a machine it explicitly excludes: quarantine acceptance criterion and reselect correct scope.

## Human factors and escalation
Use a visible, power-independent responder card with a revision ID and a single unambiguous escalation route. Make legitimate access/guard restoration and normal reset easier than bypass; never publish generic valve manipulation as a shortcut. A real emergency requires trained site response/emergency services and the machine-specific approved plan, not improvisation from this educational sheet.

## Outcome
**R01–R12: NOT REVIEWED for selected OpenPressBrake; G0/G1 HOLD; G3/G4 NOT AUTHORIZED; physical VAL/PT NOT RUN; independent evaluation NOT RUN.** No test or lab justified from source reasoning alone.