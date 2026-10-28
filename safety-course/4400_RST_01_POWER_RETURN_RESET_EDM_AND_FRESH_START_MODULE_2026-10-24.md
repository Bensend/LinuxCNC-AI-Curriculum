# 4400-RST-01 — Power return, safety reset, EDM and deliberate new start
**4000 safety engineering | 2026-10-24 | SOURCE-READING / NOT GRADUATED / NO PHYSICAL VALIDATION**

## Prerequisites and source route
Read 2520 hazard-to-SRS, 2530 E-stop, 2540 relays/final elements, 2580 hydraulic/gravity, 2590 access and 4400-CFG-01 program identity versus physical proof. Then study the [original Pilz/Rockwell reset/EDM audit](../research/4400_RESET_POWER_RETURN_EDM_WELDED_CONTACTOR_OEM_SOURCE_AUDIT_2026-10-24.md) and the [SICK EDM fault-reset indexed-text caveat](../research/4400_SICK_EDM_ERROR_RESET_UNEXPECTED_SWITCH_ON_MANUFACTURER_INDEXED_AUDIT_2026-10-24.md). Work the [18 paper scenarios](4400_POWER_RETURN_EDM_RESET_TECHNICIAN_CARD_2026-10-24.md) and the [blank selected-machine witness](4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md).

## Objective
A fresh AI engineer must separate (1) protective-device restoration, (2) safety fault acknowledgment, (3) monitored feedback eligibility, (4) safety-output rearm, (5) independently established physical stop/hold, and (6) **deliberate fresh normal motion start**. The learner must explain why a reset edge or a successful HMI startup is not equivalent to any other proposition, and how power interruption and feedback faults expose those boundaries.

## Authority model
```text
Guard/E-stop/sensor -> qualified independent safety input logic
                       -> selected safety reset + EDM interlock
                       -> safety outputs -> qualified final elements
                                              -> PHYSICAL energy/motion effect
LinuxCNC / normal FPGA -> normal motion request, diagnostics and operator UI only
Operator: safeguard restored -> independently verify safe conditions
          -> separate deliberate normal-cycle start (never reset-as-start)
Service: task-specific physical isolation + stored-energy controls (not a reset)
```
This is a **conceptual review model**, not selected wiring. Safety reset may restore permission for a safety circuit to energize; a distinct fresh start is required wherever the hazard assessment demands it. A safety relay cannot by itself guarantee the machine's entire stop, hold, isolation, guarding or absence of occupants.

## Key source-backed distinctions
- **DOC-CONFIRMED — Pilz PNOZ X3P 20899-EN-13:** automatic start can reactivate on restored safeguard input; monitored start has a distinct start circuit/wait. Original OEM explicitly warns to prevent unexpected restart externally. The auxiliary contact 41–42 is not a safety contact; Y32 is status. Relay self-diagnostics have on/off-cycle limitations.
- **DOC-CONFIRMED — Rockwell CI 440R-IN046, 2012:** AM mode lacks edge detection and can rearm when reset circuit and safety inputs are already closed at power-up. MM mode requires a particular closure/reopening interval; this is **device-specific**, not a generic debounce recommendation.
- **DOC-CONFIRMED — Rockwell DI 440R-IN037, 2011:** cross-fault detection varies with single-channel, three-wire and four-wire input topology; a 'dual-channel' label alone does not establish detection.
- **DOC-CONFIRMED manufacturer-indexed only — SICK Flexi Soft 2024/2023 EDM manuals:** an EDM Error reset while Control=1/feedback=0 can reenable block outputs; manufacturer warns against undesirable switch-on and specifies Control=0 for reset. Original PDFs could not be opened by the reader; do not silently upgrade to directly inspected source.
- **UNKNOWN:** selected OpenPressBrake safety-controller family, wiring, final elements, power-return response, Y1/Y2 gravity hold, safe state and achieved PL/SIL.

## Adversarial fault-path matrix
| Trigger | Misleading shortcut | Required discriminator |
|---|---|---|
| 24 V loss and return while pedal remains pressed | 'Safety relay rebooted green, resume' | Power-up rearm mode; fresh-start latch; physical hold and pedal release/new action |
| Reset pushbutton shorted high | 'Input is high so operator reset it' | Selected monitored-reset transition/timing and wiring; do not bypass |
| One contactor remains welded | 'EDM fault prevents all danger' | Actual output/final element state **now** and qualified isolation, not only future rearm inhibition |
| Feedback auxiliary wired to wrong device | 'EDM closed = all outputs dropped' | Device identity, positively guided/mirror feedback suitability, physical mapping |
| HMI combines Clear Faults and Start | 'One click is convenient' | Independent safety reset authorization; separate fresh normal start; no retained command |
| Guard restored with worker inside | 'Interlock says closed' | Whole-body access/escape/visibility, occupancy clearance and reset location |
| Safety PLC program checksum correct | 'Software matches, therefore safe' | Independent field wiring, terminal state, final element and physical validation |
| Two safety outputs deenergize, ram descends | 'Power removed is always safe' | Qualified hydraulic hold/gravity restraint and stored-energy hazard assessment |

## Human-factors engineering
A single 'Reset Everything' control is a predictable bypass hazard if it clears faults, rearms independent safety outputs and restarts a cycle. Prefer visibly separate, unambiguous **Acknowledge fault**, **Reset safety after area check**, and **Start new cycle** controls with machine-specific safeguards, good sight lines, accessible guard reinstallation and positive feedback about what remains blocked. A convenient HMI may *request* reset only when allowed by the selected certified safety architecture; it is not the safety authority. Avoid a nuisance reset procedure that encourages taped buttons, jumper links or EDM bypass. If the proper procedure is onerous, improve access, fault diagnostics and safe reset ergonomics rather than weaken the interlock.

## Selected-machine release gates
- **G0/G1 HOLD:** exact selected safety hardware, source/energy hazard boundary, power-return mode and independent start path not proven.
- **G2 NOT RUN:** qualified as-built wiring/feedback/final element, brownout/power restoration, held pedal, reset stuck, failed feedback, physical stop/hold and restart proof missing.
- **G3/G4 NOT AUTHORIZED:** no personnel-exposed operation. Experimental activity only isolated/remote with people outside the danger zone, after residual risks are addressed.
- **G5 HOLD:** maintenance/change-control, periodic proof testing and bypass detection not established.
- **External independent evaluation OPEN:** learner-readable paper cases are not blind scores.

## Bounded verification plan (not executed)
1. Obtain restricted selected drawings, component exact manuals, parameter printout and physical inventory; map all safety inputs, reset contacts, EDM feedback, output terminals, contactors/valves, hydraulic/structural holding and normal start paths.
2. Establish independent test acceptance criteria from the actual hazard assessment and OEM. Do not invent hydraulic truth tables, delays, pressures, stopping distances or PL/SIL.
3. Before any hazardous test, use qualified personnel and a safe remote/isolated setup with people outside the danger zone. Validate each power-return, held-command, fault-reset, contactor feedback and occupancy scenario by approved method; **do not deliberately create dangerous welded/shorted faults on an exposed machine**.
4. Capture raw evidence distinguishing controller input, safety logic, physical output, final element, ram/axis response and stored energy. Retest after changes and keep physical validation separate from ordinary software tests.
5. Record observed results, uncertainty and change-control dependency; only independent authorized reviewers may release gates.

## Promotion/uncertainty queue
| Open item | Class | Consequence | Priority | Gate |
|---|---|---|---|---|
| Exact installed safety relay/PLC and reset topology | UNKNOWN | Can change power-return and fault response | CRITICAL | Blocks selected-machine release |
| Physical Y1/Y2 stop, hold, gravity, guard and fresh-start behavior | UNKNOWN | Direct personnel hazard | CRITICAL | Blocks release |
| Full original SICK Flexi Soft EDM PDF and exact firmware variant | Indexed DOC only | Limits product-specific interpretation | MEDIUM | Blocks only that product-specific claim if selected |
| Novel independent fresh-AI evaluation | NOT RUN | No transfer competency evidence | HIGH | Blocks module graduation |
| Source-level LinuxCNC normal command retention under power return | Unneeded for safety authorization | May inform diagnostics but cannot prove safety | LOW | Does not justify compute now |

**Counterfactual:** If any unknown selected reset or hydraulic detail differs from expectation, the physical safety conclusion changes. Thus the module is **NOT GRADUATED** and selected operation is **NOT AUTHORIZED**. The general distinction between normal control, independent safety logic and physical energy control is supported by the original OEM sources.


## Source-confirmed LinuxCNC internal E-stop reset boundary (pinned revision)
The [pinned `062dc7c` HALUI→NML→Task→IOControl source trace](../research/4400_LINUXCNC_INTERNAL_ESTOP_RESET_HALUI_NML_IOCONTROL_SOURCE_TRACE_2026-10-24.md) is **SOURCE-CONFIRMED**, not physical validation. A rising `halui.estop.reset` sends an `EMC_TASK_SET_STATE::ESTOP_RESET` NML request; Task's `emcAuxEstopOff()` sets normal HAL `iocontrol.0.user-enable-out` and `user-request-enable` high. A **separate** `EMC_TASK_STATE::ON` path calls `emcTrajEnable()`. The names `estop` and `enable` do not confer safety integrity: these are userspace/Task normal-control signals, not independent contactor/valve/ram physical witnesses. Do not wire them as sole personnel-safety authority. No LinuxCNC program-autorestart claim is made; that question requires separate evidence.

## 2026-10-28 exact contactor/auxiliary variant addendum — EDM-MIRROR-01
[Original Schneider/Rockwell/Omron source audit](../research/4400_EDM_MIRROR_01_SCHNEIDER_ROCKWELL_OMRON_AUXILIARY_CONTACT_VARIANT_AND_REPLACEMENT_SOURCE_AUDIT_2026-10-28.md) demonstrates that **an NC feedback contact is not automatically a mirror contact**. Exact base/accessory SKU, approved mounting and physical association with the power poles are required. The original Suva 2022 100S-C certificate distinguishes irremovably factory-mounted 100S-F front auxiliaries from side-mounted auxiliaries whose installation and mirror function must be checked. Schneider lists specific mirror and non-mirror variants; the generic 'safety contactor' label and terminal number 21–22 are insufficient. Mirror is an asymmetric main-NO-to-NC constraint; it does not prove every inverse fault condition. A contactor/accessory replacement triggers CHG and revalidation of EDM mapping, feedback faults, actual energy interruption and physical safe state. Existing [RST blank witness](4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md) RST-03/04/07/11/12 is sufficient; no new exam bank, machine test or release. G0/G1 HOLD.
