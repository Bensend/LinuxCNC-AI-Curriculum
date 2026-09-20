# Lane B checkpoint — emergency-stop span of control / reset authority

Date: 2026-09-20

## Completed

Independent Lane B added `safety-course/EMERGENCY_STOP_SPAN_OF_CONTROL_LOCAL_RESET_RESTART_AUTHORITY_STUDY_2026-09-20.md`.

Selection was made only after reading the curriculum authority files, active progress, safety-course inventory, recent commits, and the primary lane's newest durable CINCINNATI hydraulic work. The primary lane is advancing one-servo-at-a-time check-valve/safety-dump diagnostics and the unresolved press-brake retaining/load-proof bridge. Lane B therefore used a different device family and did not edit those files.

## Durable freeze

**E-STOP ACTUATOR RELEASED != EMERGENCY CONDITION RESOLVED != AFFECTED SPAN VERIFIED SAFE != SAFETY RESET/REQUALIFICATION COMPLETE != FRESH START AUTHORITY.**

**ONE E-STOP DEVICE RESET != ALL DEVICES IN THE RELEVANT SPAN RESET != ALL RELEVANT SAFETY FUNCTIONS READY.**

**GLOBAL HMI `ESTOP_OK` != EACH PHYSICAL ACTUATOR RELEASED != SAFETY EVALUATOR HEALTHY != FINAL ELEMENT SAFE != PHYSICAL HAZARD SAFE.**

**SPAN A RESET != SPAN B RESET != PLANT-WIDE PRODUCTION AUTHORITY.**

**E-STOP RESET != START.**

## Evidence gained

- `SOURCE-CONFIRMED`: ISO 13850:2015 public text establishes maintained emergency-stop state, intentional reset, start inhibition while active, reset-not-start, and emergency stop as complementary protection.
- `DOC-CONFIRMED`: IDEC's ISO 13850 guidance documents the default whole-machine span and the conditions for multiple identifiable spans.
- `DOC-CONFIRMED`: Pilz states that the initiating emergency-stop device is intentionally reset at that device and that reset only prepares for restart.
- `DOC-CONFIRMED`: SICK's 2026 Guide for Safe Machinery independently reinforces local/manual reset and reset-not-restart.
- `TEST-CONFIRMED`: none; no physical or executable test was performed.
- `COMMUNITY-REPORTED`: none used for safety claims.
- `INFERENCE`: LinuxCNC/HAL/ordinary FPGA may expose diagnostics and inhibit ordinary commands but must not be promoted to personnel-safety authority merely because it displays aggregate E-stop state.
- `UNKNOWN`: OpenPressBrake span count, actuator-to-hazard mapping, final elements, stop category/performance, reset location, personnel-clear method, and production restart sequence.

## Compute

No executable verification was justified. No GitHub-hosted runner was used. The self-hosted `[self-hosted, openpressbrake]` runner was unnecessary because the unresolved questions are architecture/documentation/physical-machine questions.

## Exact next Lane-B work

Find a complete professional machine/cell implementation showing:

`physical E-stop actuator -> explicitly documented span of control -> independent safety evaluator -> actual electrical/hydraulic/mechanical final elements -> physical hazard-state witness -> second-device/cross-span challenge -> local release/reset -> personnel/area-clear decision where applicable -> safety requalification -> stale ordinary-command challenge -> separate fresh production start`.

Prefer an OEM/integrator commissioning or fault procedure with more than one emergency-stop span and an explicit reason/boundary for the spans. Do not duplicate the primary hydraulic retaining/check-valve evidence package.
