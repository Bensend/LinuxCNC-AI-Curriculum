# Protective-Field Selective-Stop Evidence Trace — SICK Sim-4-Safety

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Purpose

Study a professional manufacturer application in which different protective-field demands intentionally stop different hazardous movements, without inventing the unexposed final-element implementation. This is deliberately separate from the current diagnostic-annunciation branch and from OpenPressBrake-specific hydraulic/safety design.

## Evidence provenance

### SOURCE-CONFIRMED — SICK Sim-4-Safety application

SICK's Sim-4-Safety material describes an S3000 safety laser scanner combined with a Flexi Soft safety controller monitoring four protective fields around two neighboring tire-curing presses. The published application says the farther protective fields stop the loading-arm movement while allowing the press itself to continue, while nearer fields stop press movement. It also states that Press 1 may stop while Press 2 continues.

Sources inspected 2026-09-17:
- SICK, `Sim-4-Safety: worlds first safety design allows monitoring of up to four protective fields simultaneously`, 2013 manufacturer application article.
- SICK manufacturer video description, `Sim-4-Safety from SICK: Monitoring of up to four protective fields simultaneously`.

Evidence class: SOURCE-CONFIRMED for the stated application behavior. The public material is not a complete machine electrical/hydraulic drawing set.

### DOC-CONFIRMED — protective-device reset/restart boundary

SICK microScan3 operating instructions state that a restart interlock prevents automatic restart after an ESPE demand; reset returns the protective device to monitoring status and must not itself introduce movement. A separate start command follows reset. The same manual warns that a universal/diagnostic output must not be used for safety functions.

Source: SICK microScan3 operating instructions, section 4.4.6 Restart interlock, inspected 2026-09-17.

### DOC-CONFIRMED — field-selection authority is safety-relevant

SICK's published guidance on laser-scanner field sets warns that field selection itself is part of the safety function and should achieve the required safety integrity; ordinary PLC or single-channel selection can reduce the integrity of the overall function. This matters whenever a machine selects protective fields according to operating state.

Source: SICK machinery-safety technical article on common safety-laser-scanner setup errors, inspected 2026-09-17.

## End-to-end trace that public evidence supports

| Layer | Evidence-supported statement | Provenance |
|---|---|---|
| Hazard geometry | Two neighboring tire-curing presses have separately monitored hazardous areas/movements | SOURCE-CONFIRMED |
| Protective sensing | One S3000 monitors multiple simultaneous protective fields | SOURCE-CONFIRMED |
| Safety logic | Flexi Soft receives scanner safety information and configures shutdown paths/behavior | SOURCE-CONFIRMED |
| Far-field demand | Published example stops loading-arm movement | SOURCE-CONFIRMED |
| Near-field demand | Published example stops press movement | SOURCE-CONFIRMED |
| Adjacent-machine selectivity | One press may be stopped while the neighboring press continues | SOURCE-CONFIRMED |
| Reset/restart principle | Protective-device reset is not itself machine restart; separate start is required where restart interlock applies | DOC-CONFIRMED |
| Physical final elements | Exact contactors, drive safe-motion inputs, valves, hydraulic dump/blocking elements and feedback are not exposed by the inspected application material | UNKNOWN |
| Stopping performance | Actual machine stop time/distance and safety distance are not established by this trace | UNKNOWN |
| Performance level / SIL of complete tire-press installation | Not established from the inspected application material | UNKNOWN |

## Architecture lesson

The useful professional pattern is not `protective device tripped -> everything off`. It is:

`hazard-specific protective field -> safety-rated evaluation -> defined shutdown path for the hazardous movement within that field's span`.

A neighboring or otherwise unaffected process may continue only when the risk assessment and validated safety architecture support that span. Selectivity is therefore a safety-function design property, not an ordinary PLC productivity optimization.

This gives the curriculum a concrete counterexample to two bad simplifications:

1. **Every protective demand must always remove every machine output.** False as a universal rule; professional systems can have bounded safety-function spans.
2. **If ordinary control knows which zone is occupied, it may choose which safety path matters.** Unsafe assumption. Where field/mode selection affects the safety function, that selection requires an appropriately validated safety-related path.

## Protective-device demand versus E-stop

This source is valuable precisely because it does **not** justify treating the selective protective-field response as the machine's E-stop response.

The inspected SICK application establishes hazard-specific protective-field shutdown behavior. It does not expose the tire press's E-stop span, E-stop stop category, final elements, hydraulic energy behavior, reset locations, or restart logic. Therefore:

`PROTECTIVE-FIELD SPAN != E-STOP SPAN` unless machine-specific evidence proves they coincide.

A curriculum design review must trace each independently:

- protective field / guard demand;
- E-stop demand;
- mode-dependent safety demand;
- final elements affected by each;
- physical hazardous effect removed or controlled;
- feedback/diagnostics;
- reset and separate restart behavior.

## Failure-path challenges

1. **Far field entered; ordinary PLC suppresses loader command but safety shutdown path remains released.** Reject ordinary-command inhibition as sole personnel-safety authority.
2. **Near field entered; loader stops but press hazardous motion remains possible.** Reject if the validated near-field function is supposed to stop press motion.
3. **Wrong field selected for current machine state.** Treat field-selection correctness as safety-relevant where selection determines the protective function.
4. **Scanner reports clear but Flexi Soft safety data is stale/lost.** Do not preserve a reassuring last state; safety reaction follows validated communications behavior.
5. **Protective field clears and machine automatically resumes despite a required restart interlock.** Reject; reset/restart behavior must match the validated application.
6. **Reset button directly starts hazardous motion.** Reject; reset must not itself introduce movement where the documented restart-interlock model applies.
7. **Press 1 demand unnecessarily stops Press 2, causing repeated bypass pressure.** Investigate span design and usability; do not defeat protection merely for productivity.
8. **Press 1 demand fails to stop a shared hazardous mechanism crossing both zones.** Selective stopping is valid only if the actual hazard boundary supports the claimed independence.
9. **HMI says `ZONE SAFE` because the scanner field is clear.** Reject overclaim: clear sensing does not prove final-element state, stored-energy absence, or maintenance safety.
10. **Designer copies the Sim-4 architecture into OpenPressBrake and invents valves/contactors.** Reject. The application demonstrates a safety-architecture principle, not machine-specific hardware truth.

## LinuxCNC / FPGA boundary

For an OpenPressBrake-style architecture, LinuxCNC/HAL/FPGA may consume zone/safety status for normal command inhibition, diagnostics and operator guidance. They must not become the sole authority for a personnel-safety shutdown path merely because they can implement equivalent Boolean logic.

If future OpenPressBrake hazard analysis justifies multiple safety spans, the independent safety system must own or safely evaluate the inputs and final-element authority required for those spans. Exact spans remain UNKNOWN until the machine hazard analysis and physical implementation are established.

## Verification obligations for a future complete-machine trace

A stronger professional implementation artifact should expose, for each demand:

- named protective device and physical coverage;
- safety input wiring/protocol;
- safety logic/function block;
- exact final safety outputs;
- contactor/STO/safe-motion/valve/brake final elements;
- feedback/EDM or other physical-state witness;
- hazardous energy or motion actually controlled;
- unaffected hazards/processes and why they may remain active;
- reset location and visibility;
- restart interlock and separate start;
- response/stopping evidence where applicable;
- commissioning and periodic validation method.

Until those are visible, do not upgrade SOURCE-CONFIRMED application behavior into TEST-CONFIRMED physical-machine behavior.

## Curriculum freeze

**Safety-function span must follow the hazard boundary. Selective stopping can be professional and correct, but only when the safety-related sensing, selection, logic, final elements and validation support that exact span. Protective-device span and E-stop span are separate claims until machine evidence proves otherwise.**

## Deliberate UNKNOWNs

No OpenPressBrake-specific protective zones, E-stop span, hydraulic truth table, valve topology, pressure threshold, stopping distance/time, PL/SIL/DC, reset position, or final-element behavior is inferred here.

## Next independent work

Find a complete OEM/manufacturer implementation exposing both a protective-device demand and E-stop demand through the safety logic to physical final elements. Prefer a machine/cell manual or electrical/hydraulic drawing package over another application summary. Build a side-by-side demand-to-final-element matrix. If public evidence still stops at controller outputs, rotate to a different open safety branch rather than invent the missing physical layer.
