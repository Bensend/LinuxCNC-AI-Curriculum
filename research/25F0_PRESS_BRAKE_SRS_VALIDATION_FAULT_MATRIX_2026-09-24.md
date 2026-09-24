# 25F0 — Press-brake SRS-linked fault validation matrix

Session start UTC: 2026-09-24T02:35Z

## Purpose

Turn the professional architecture trace into validation cases without inventing a machine-specific hydraulic truth table. Each case distinguishes the safety demand, failed path, independent response, physical witness, residual hazardous-energy proposition, rearm/revalidation condition, and evidence class.

This is a curriculum/capstone matrix, not a commissioning specification for an unidentified machine.

## Evidence boundary

Current Fiessler AKAS-F + AKFH/AKFR documentation is `DOC-CONFIRMED` evidence that one professional architecture reads hydraulic valve-position transmitters, returns linked valve state to AKAS-F, and enables valve controls through five safe normally-open contacts. Valve enable is blocked for protective-field interruption, safety-door opening, E-stop, valve switching error, AKFH/R error, or AKAS-F error.

Bosch Rexroth's current press-brake package is `DOC-CONFIRMED` evidence that a servo-motor/four-quadrant-pump normal motion path can coexist with a separate safety block using end-position-monitored on/off valves.

HAWE EV2D is `DOC-CONFIRMED` product evidence for safety-related shutdown of press-brake valve control. It does not by itself establish the physical safe state of an arbitrary ram/beam.

Therefore the following remain separate propositions: controlled stop, actuation/supply inhibition, valve-state feedback, dump/decompression, load holding/gravity restraint, maintenance isolation, and physical standstill.

## SRS-linked fault cases

| Case | SRS link | Safety demand | Failed path / injected fault | Expected independent response | Required physical witness | Residual hazardous-energy proposition | Rearm / revalidation condition | Evidence class |
|---|---|---|---|---|---|---|---|---|
| PB-F01 stuck motion-permitting valve | SRS-PB-STOP, SRS-PB-GRAVITY, SRS-PB-FLUID | Protective device or E-stop requires removal/prevention of hazardous closing motion | One motion-permitting hydraulic element fails to reach its expected safe position | Independent safety chain removes its permits/outputs and detects disagreement where the selected architecture provides position monitoring; other independent final element(s) must perform their allocated function | Directly justified ram/beam motion/position witness plus product-specific valve-state evidence; pressure/load-holding witness if required by the SRS | A detected valve fault does **not** prove that the beam stopped, pressure dissipated, or gravity load is restrained | Latch fault where required; no rearm until failed element/path is corrected and the affected safety function is physically revalidated | `DOC-CONFIRMED` for Fiessler valve-position monitoring; physical machine response `UNKNOWN` until machine-specific evidence |
| PB-F02 false valve-position feedback | SRS-GEN-DIAG, SRS-PB-STOP, SRS-PB-GRAVITY | Safety logic depends on a valve-state proposition | Position transmitter/contact reports expected state while hydraulic element does not actually establish it | Architecture must not credit ordinary LinuxCNC/HMI indication as independent proof; additional independence/diagnostic strategy must come from the selected safety design | Independent physical motion/pressure/load witness appropriate to the SRS, not merely the same feedback bit | False feedback may leave hazardous flow/pressure/motion even while controller state appears healthy | Treat as validation failure; repair feedback/diagnostic architecture and repeat fault-injection/physical proof before release | Failure consequence `INFERENCE`; exact diagnostic coverage `UNKNOWN` |
| PB-F03 broken safety input/output channel | SRS-GEN-ESTOP, SRS-PB-POO, SRS-GEN-DIAG | E-stop/guard/protective-field demand | Open conductor or loss of one safety channel | Selected safety-related architecture should transition to its defined safe response or inhibit enable according to product design; ordinary LinuxCNC must not mask/override it | Physical final-element state and ram/beam response, plus channel fault indication if provided | Channel fault detection alone does not prove hazardous energy removed | Fault must prevent normal rearm where architecture requires; restore channel and repeat functional/physical validation | Product-specific behavior `DOC-CONFIRMED` only where manual supports it; generic result otherwise `UNKNOWN` |
| PB-F04 common electrical/control supply loss | SRS-GEN-POWER, SRS-PB-GRAVITY, SRS-PB-FLUID | Loss of safety/control power during hazardous or potentially hazardous state | Shared control supply disappears | Outputs should lose permission according to selected architecture, but loss of electrical command is not credited as hydraulic/gravity safe state | Beam motion/position, relevant valve states, pressure/holding state, and restart behavior after supply restoration | Gravity or stored fluid energy can remain after control power disappears | Power restoration must not initiate hazardous motion; rearm is deliberate and affected safe-state propositions are re-established | `INFERENCE`; exact machine behavior `UNKNOWN` |
| PB-F05 common pilot/hydraulic supply disturbance | SRS-PB-FLUID, SRS-PB-GRAVITY | Safety demand coincides with loss/change of pilot or hydraulic supply | Common pilot pressure or hydraulic supply falls outside intended state | Safety design must have an explicitly justified failure response; do not assume every valve moves safe on loss of pilot/pressure | Actual beam motion/holding, valve position where meaningful, pressure at relevant trapped/load-supported volumes | Supply loss can remove control authority while stored/gravity energy persists | No release until schematic/product evidence establishes fail behavior and machine validation proves it | `UNKNOWN` unless actual valve/manifold evidence exists |
| PB-F06 safety-output removal | SRS-GEN-ESTOP, SRS-PB-STOP | Independent safety controller removes final-element enable | Safety output opens but downstream actuator path is stuck/bridged | Safety controller indication is necessary evidence but insufficient; allocated downstream final elements must establish the physical response | Final-element electrical state plus physical ram/beam cessation/holding as required | `SAFETY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED` | Diagnose downstream discrepancy; revalidate final-element response before rearm/release | Architecture concept `DOC-CONFIRMED`; physical result machine-specific |
| PB-F07 mains/control-power restoration | SRS-GEN-POWER, SRS-GEN-RESET, SRS-PB-CYCLE | Power returns after interruption | Stored commands, pedal state, PLC/LinuxCNC state, or safety state differs at restart | Restoration alone must not cause hazardous cycle; independent safety rearm and separate cycle-start conditions remain required | Observe physical machine through restoration and deliberate rearm/start sequence | A healthy boot/status screen does not prove unexpected motion is impossible | Explicit reset/rearm then separate start; any unexpected motion is release-blocking and requires root-cause correction/revalidation | Generic requirement `DOC-CONFIRMED` from existing course evidence; exact machine behavior `TEST-CONFIRMED` only after machine test |
| PB-F08 trapped/accumulator pressure after shutdown | SRS-PB-FLUID, SRS-GEN-MAINT | Maintenance/tool-change access requires stored-energy control | Pump stopped and ordinary control disabled while trapped/accumulated pressure remains | Named isolation/dump/dissipation method plus verification; production safeguard is not substituted for maintenance energy control | Appropriately located pressure/energy verification and, where required, mechanical restraint; sensor location must match the trapped volume proposition | `PUMP OFF != FLUID ENERGY GONE`; low pressure at one point may not prove every trapped volume safe | Maintenance release only after isolation/dissipation/restraint verification; restore only under controlled recommissioning | Safety principle `DOC-CONFIRMED`; actual trapped-volume inventory `UNKNOWN` |
| PB-F09 gravity-loaded beam / loss of active holding | SRS-PB-GRAVITY, SRS-GEN-MAINT | Person may be exposed below/in tooling region | Active hydraulic/electrical holding disappears or is unavailable | Named machine-specific load-holding or mechanical-restraint safety function must carry the proposition; software zero command is irrelevant proof | Physical restraint/holding state and beam position/motion under defined validation conditions | `VALVE COMMAND OFF != HAZARDOUS DESCENT PREVENTED PROVED`; pressure state alone does not prove mechanical restraint | No personnel exposure until actual holding/restraint architecture and validation are established | Hazard proposition `INFERENCE`; actual gravity behavior and restraint design `UNKNOWN` |
| PB-F10 maintenance access inside die space | SRS-PB-TOOLCHANGE, SRS-GEN-MAINT | Person enters point-of-operation/die space for tooling/service | Normal optical safeguard bypassed, muted, obstructed, or inappropriate to task | Hazardous-energy isolation/dissipation and required mechanical restraint replace reliance on production guarding; ordinary LinuxCNC/FPGA control has no personnel-safety authority | Isolation verification, stored-energy verification, physical maintenance restraint where required, and controlled restoration | A stopped ram or clear light curtain does not prove safe maintenance state | Remove tools/restraints only under defined restoration procedure; revalidate safeguards affected by service/change | Existing course/OSHA principle `DOC-CONFIRMED`; exact restraint requirement machine-specific |
| PB-F11 common-cause bridge across nominally independent paths | SRS-GEN-DIAG, SRS-PB-FLUID, SRS-PB-GRAVITY | Any safety demand | Shared supply, wiring route, connector, manifold passage, contamination, software/configuration, or maintenance error defeats multiple channels | CCF must be identified at architecture/design review; channel count alone is not credited as independence | Evidence appropriate to shared dependency: schematics, physical inspection, fault injection where safe/justified, and physical machine response | Two channels/components may fail together if their dependency is shared | Correct dependency/segregation and repeat affected verification/validation; integrity claim remains `UNKNOWN` until justified | `INFERENCE` / design-analysis requirement |

## Adversarial commissioning cases

1. **Green valve feedback, moving beam:** controller sees expected valve feedback after protective-field interruption, but physical beam witness shows continued hazardous motion. Result: FAIL regardless of diagnostic screen.
2. **Safety output off, trapped pressure remains:** safety relay/drive output is de-energized, yet a relevant hydraulic volume remains pressurized. Result: actuation inhibition may have worked; maintenance safe state is not proved.
3. **Pump stopped, beam creeps:** normal servo/pump command is zero and pump is stopped, but beam position changes under gravity/load. Result: normal control stop is not the gravity safety function.
4. **Power-cycle looks clean, pedal remains asserted:** HMI and safety controller restart normally but an asserted cycle input can produce motion without a deliberate new start. Result: FAIL SRS-GEN-POWER/SRS-GEN-RESET/SRS-PB-CYCLE.
5. **One pressure sensor reads low, another trapped region remains energetic:** result: the sensor proposition was too narrow; revise the energy-boundary inventory and validation method.

## Validation discipline

For every machine implementation, convert these cases into a signed SRS validation record containing preconditions/mode, safe fault-injection method, expected physical response, instrumentation/witness, acceptance criterion, observed result, evidence artifact, correction, retest, and release decision.

Do not deliberately create a hazardous fault with personnel exposed. Where a fault test cannot be performed safely, use justified alternative verification and keep any unproved physical proposition explicit.

A successful controller diagnostic is never substituted for the physical proposition named by the SRS.

## Safe-to-operate threshold

If the actual press brake cannot establish point-of-operation protection, unexpected-restart prevention, required gravity/load holding, stored-fluid-energy control, and maintenance restraint/isolation for the real hydraulic/mechanical architecture, it should not be operated with people exposed to those hazards. Experimental operation must remain isolated/remote with people outside the danger zone and residual risk stated explicitly.

## UNKNOWN register retained

- exact spool/valve truth tables and fail states;
- gravity behavior of the actual beam/cylinders;
- accumulator and trapped-volume inventory;
- stopping time/distance and allowed limits;
- pressure/safe-speed thresholds;
- diagnostic coverage and CCF quantitative assumptions;
- PL/SIL/integrity target for the actual machine;
- proof-test interval;
- exact maintenance-block/restraint requirements.

## Next work

1. Perform a 25F0 capstone completeness audit against the cross-machine contract and safety syllabus.
2. Check whether plasma/cutting-machine transfer remains a genuine learner-facing gap; if so, add only the machine-specific delta rather than recreating closed 3000 manufacturing instruction.
3. Build the 25F0 canonical learner route and external information-separated evaluator handoff only after the audit finds no material gap.
4. Keep unsupported physical values and hydraulic behavior `UNKNOWN`; do not simulate merely to fill unknown cells.
