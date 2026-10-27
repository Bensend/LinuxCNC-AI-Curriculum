# 4400-AIR-CLEAN-01 — cleaning task authority and exposure crosscut
Date: 2026-10-27 | Status: documentary architecture review, NOT physical validation.

## Four independent safety propositions
| Proposition | Ordinary CNC/FPGA may do | Independent authority / physical witness required |
|---|---|---|
| Hazardous motion stopped and restart inhibited | Request M5/M9, report state, log commands | Guard/interlock/stop chain and actual machine physical safe state as justified by risk assessment; deliberate fresh restart |
| Cleaning air not capable of hazardous unexpected discharge in exposed service | Command solenoid OFF | Appropriate lockable isolation, trapped-pressure bleed and verification at the relevant zone |
| Cleaning nozzle does not present excessive dead-ended pressure or flying-chip hazard | Select recipe/timer | Actual nozzle/relief geometry, less-than-30-psi static dead-end cleaning requirement in OSHA scope, physical chip guarding/PPE/bystander protection |
| Worker not exposed to unacceptable mist/noise | Command extraction and display warning | Selected capture/LEV and occupational-exposure assessment; representative noise dose, not HMI fan bit or supplier single-point dBA |

## Foreseeable defeat review
- Operator removes chip shield because it blocks tool access -> redesign shield, fixture and vacuum route; use captive parts and fast cleanup rather than relying on a warning label.
- Operator tapes relief ports because the gun 'doesn't blow hard enough' -> choose task-effective vacuum/contained cleaning or a properly engineered alternative; replace tampered gun. A higher-flow nozzle still requires the static dead-end and chip-protection conditions.
- Technician mistakes M9 for isolation -> label service air isolator, provide accessible lockable shutoff/bleed, and make zero-energy verification easy. Do not confuse a normal output with a safety-rated pneumatic final element.
- OEM noise claim is used as workplace compliance proof -> record selected geometry/duty cycle and worker exposure assessment; OSHA 85 dBA action level is not 90 dBA PEL.

## Evidence and changes
**DOC-CONFIRMED** OSHA cleaning/dead-end/chip/PPE rule, MWF mist advice, OSHA 85/90 noise distinctions, LOTO scope; **INFERENCE** coupled failure paths; **UNKNOWN** actual nozzle, workpiece, worker positions, LEV, noise, as-built air lines and safety PLC. **TEST-CONFIRMED none**. Change of nozzle, shield, hose, compressed-air source, blow-off duty cycle, guard mode or extraction configuration invalidates dependent evidence pending review. **No physical safety credit**; G0/G1 HOLD. Cross-reference [primary audit](../research/4400_AIR_CLEAN_01_OSHA_DEADEND_CHIP_GUARD_MWF_NOISE_SOURCE_AUDIT_2026-10-27.md) and [12-case technician module](4400_AIR_CLEAN_01_DEADEND_PRESSURE_CHIP_SHIELD_MIST_AND_RESTART_FIELD_MODULE_2026-10-27.md).


## 2026-10-27 pinned source and OSHA field continuation
[Original pinned LinuxCNC M62/M63/M64/M65 source transfer](../research/4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md) establishes at revision 062dc7c097693bb68e76192516cd92878dd5ecdf that **M63 OFF is queued until a subsequent motion**. An illustrative M62 → G1 → M63 → program end without later motion is a **source-supported ordinary-control hazard hypothesis**, not a tested actual air valve: the queued OFF may never apply in that sequence, but Task end/abort and HAL/valve state were not traced here. M65 is immediate as received by motion, but **not** a safety isolator. [Original OSHA body-cleaning/taped-hose/drying enforcement delta](../research/4400_AIR_CLEAN_01_OSHA_FIELD_ENFORCEMENT_AND_BODY_CLEANING_DELTA_2026-10-27.md) adds a 1994 interpretation and 2011/2015 documented cases, with citation allegations distinguished from physical observations. Do not claim the maritime prohibition text is universally present in general industry. **No new cases/gates or evaluator score**; existing 12/12 remain UNSCORED/NOT RUN.
