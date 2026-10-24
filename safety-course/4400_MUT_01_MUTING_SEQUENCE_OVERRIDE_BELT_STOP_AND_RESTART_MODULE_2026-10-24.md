# 4400-MUT-01 — Muting is a temporary loss of protection, not a green-light authorization
**Level:** 4000 safety engineering | **Status:** SOURCE-READING / NOT GRADUATED | **Date:** 2026-10-24

## Prerequisites and objective
Use 2520 hazard/SRS, 2530 E-stop, 2540 final elements, 2590 optical safeguards, 25F0 machine capstones and 4400-ESPE-02 blanking. A fresh engineer must distinguish **muting**, **blanking**, **override**, **belt stop**, **safety reset**, **ordinary machine start** and **physical stop/hold**; recognize cross-OEM timer semantics and design an auditable recovery path for a jammed conveyor without normalizing defeat of guarding.

## Read in order
1. [SICK deTec4 HG original 2026 manual audit](../research/4400_SICK_DETEC4_HG_MUTING_BELT_STOP_OVERRIDE_TIMER_SOURCE_AUDIT_2026-10-24.md).
2. [Rockwell GuardLogix FSBM manufacturer help audit](../research/4400_ROCKWELL_FSBM_ZERO_TIMER_OVERRIDE_AND_RESTART_SOURCE_AUDIT_2026-10-24.md).
3. [IEC 62046:2026 publisher edition/scope gate](../research/4400_IEC_62046_2026_MUTING_WHOLE_BODY_STANDARD_EDITION_SCOPE_AUDIT_2026-10-24.md).
4. [Existing optical blanking module](4400_ESPE_02_BLANKING_RESOLUTION_AND_PRESS_BRAKE_LATE_DETECTION_MODULE_2026-10-24.md), [cumulative safety design package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md).

## Four independent layers
| Layer | Proper role | Unsafe shortcut |
|---|---|---|
| Normal control | LinuxCNC/FPGA requests conveyor/robot/press motion and displays status | LinuxCNC bit directly bypasses protective field or clears restart latch |
| Safety-related decision | Qualified muting sensor geometry/sequence/timing, protected-area occupancy, mode and reset; qualified controller | Assuming two ordinary proximity sensors or one PLC recipe tag means 'material not human' |
| Physical stop/hold | Independently qualified contactor/STO/valve/brake/ram support, plus guarding that prevents reach-around | Treating OSSD=OFF as proven gravity holding, or OSSD=ON as safe-to-start |
| Energy isolation | Lockable all-source maintenance isolation, stored energy control and verification | Using a muting override to enter for jam clearing or maintenance |

## Minimal reference state model — pedagogical, NOT a device truth table
- **PROTECTED:** ESPE actively monitors access; any unsafe intrusion requires a physically effective stop/hold.
- **MATERIAL-PASS:** qualified muting sequence and geometry permit *only material* passage, with bounded configuration-dependent time and independent physical side/rear protection.
- **MUTING-FAULT:** invalid sensor order, timeout, field change or diagnostics remove protective bypass; physical safe state must be established.
- **RECOVERY-OVERRIDE:** deliberately authorized temporary clearing of stuck material; clear sightline, outside-zone control, qualified hold-to-run where OEM requires, no person inside, and separate physical safe-motion/restart constraints.
- **RESET-REARM:** reset only restores eligibility after area clearance, sensors/configuration/final elements healthy; it does not consume a held LinuxCNC start command.
- **ISOLATED-SERVICE:** when a person must enter or reach into the hazard to clear a jam, apply task-specific energy isolation and mechanical restraint instead of muting.

This is a teaching abstraction; exact transitions differ between SICK deTec4 HG and Rockwell FSBM. Do not implement it as personnel safety in normal LinuxCNC/HAL/FPGA.

## Counterexamples that invalidate simplistic rules
1. SICK SP2 concurrence/total mute default is **24 hours**, not a presumed short interval; configured belt-stop can pause relevant timers while monitoring sensor changes.
2. Rockwell FSBM **0 disables** several timers. Zero does not mean immediate timeout.
3. SICK override can turn OSSDs ON while ESPE is blocked; Rockwell FSBM override can energize O1 even when Input Status false or faults exist. Both require precise manufacturer-specific recovery controls.
4. SICK consecutive override counter can reset on power-up; do not treat a counter as durable tamper control.
5. SICK's 50 ms sensor offset is limited to certain receiver-extension wiring; it is not a stop time or universal sensor tolerance.
6. SICK's belt-stop input can be delivered via IO-Link **for non-safety-related use**; such data is not independent evidence of stationary hazardous machinery.
7. IEC 62046:2026 explicitly revises muting and whole-body access topics, but its paid normative text was not inspected; avoid inventing new requirements.
8. An ESPE's normal OSSD response, any muting lamp and an operator's reset do not prove the **actual** final elements stopped or a person cannot be trapped behind the field.

## Worked transfer
**Robot pallet conveyor:** a large carton is stuck halfway through the gate. The operator can press a spring-return override from outside, but the robot's automatic job is still latched. Qualify (a) actual material/person separation and side-gap geometry, (b) occupancy and escape, (c) the OEM-specific override duration and actual mode, (d) independently verified safe physical stop/hold, (e) reset-edge and fresh-start interlock, and (f) safe jam-removal ergonomics. If the operator must enter, switch to isolated service, not override. **Press brake:** do not transplant conveyor muting to AKAS tool/ram muting; machine-specific protective geometry and Y1/Y2 load holding remain separate.

## Practice, release and uncertainty
Complete [18 paper cases](4400_MUTING_TIMEOUT_OVERRIDE_HUMAN_ENTRY_TECHNICIAN_CARD_2026-10-24.md); fill [blank as-built witness](4400_MUTING_AS_BUILT_STOP_HOLD_RESTART_BLANK_WITNESS_2026-10-24.md) only with qualified real-machine evidence. [Independent fresh-AI handoff](../evaluation/4400_MUT_01_FRESH_MUTING_TRANSFER_HANDOFF_2026-10-24.md) PREPARED / NOT ADMINISTERED / NOT SCORED.

**DOC-CONFIRMED:** original SICK February 2026 manual, official Rockwell FSBM help, IEC July 2026 public edition scope. **SOURCE-CONFIRMED:** none for safety logic. **TEST-CONFIRMED:** none. **INFERENCE:** human-factors, whole-body and bypass incentives. **UNKNOWN:** selected device, all effective settings, actual geometry, safety integrity, stop/hold, measured timing, external evaluator and adopted standard. **NOT GRADUATED**. Conditional IN-04w UNKNOWN; physical VAL/PT NOT RUN, G0/G1 HOLD, G3/G4 NOT AUTHORIZED, no personnel-exposed operation.

## Higher-level queue
Compare actual adopted IEC 62046:2026 clauses under lawful access; collect selected-machine as-built sensor/guard/override/final-element evidence. No generic simulation is warranted while source answers the logical question and machine hardware is unknown. Do not promote unknown physical safety into a release claim.
