# Lane B checkpoint — multi-zone E-stop span and restart authority

Date: 2026-09-19

## Durable result

Added `safety-course/MULTIZONE_ESTOP_SPAN_OF_CONTROL_AND_RESTART_AUTHORITY_TRACE_2026-09-19.md`.

Professional evidence now shows a real five-zone automotive line where a safety interruption stops the relevant zone while unaffected zones remain operational, plus manufacturer guidance requiring intentional local release/reset of the initiating E-stop and separate restart authority.

Freeze:

**E-STOP SPAN OF CONTROL != ENTIRE MACHINE BY DEFAULT.**

**ZONE LABEL != VALIDATED SAFETY ZONE.**

**ORDINARY SOFTWARE/HMI ZONE != SAFETY-RATED SPAN-OF-CONTROL IMPLEMENTATION.**

**E-STOP DEVICE RELEASED != SAFETY RESET COMPLETE != AREA CLEAR != FINAL ELEMENT PROVED != ORDINARY START.**

## Validation consequence

Commissioning must challenge each E-stop-to-final-element mapping and the intended zone boundary, including wrong-zone/swapped-input/output cases. HMI indication is not a physical stop witness. Intentionally unaffected zones should be checked against the documented span rather than assuming plant-wide shutdown.

## Evidence status

DOC-CONFIRMED: Pilz reset/restart interpretation; Rockwell five-zone automotive implementation; Rockwell zone-named safety-input/permissive architecture; Rockwell ordinary MCR logic explicitly not a substitute for E-stop capability.

TEST-CONFIRMED: none for OpenPressBrake. Machine-specific OpenPressBrake zone boundaries, E-stop locations, hydraulic reactions, stop categories, final elements, area-clear logic and stopping performance remain UNKNOWN.

## No-compute decision

No executable lab was justified; remaining questions are physical architecture/risk-assessment/commissioning facts. No GitHub-hosted Actions compute was used.

## Exact next Lane-B work

Prefer a commissioning/validation source that explicitly tests wrong-zone mapping or demonstrates `specific E-stop -> intended final elements -> physical stop witness -> reset/area-clear -> separate fresh START`, especially where adjacent zones remain live. If source gain stalls, rotate to the primary hydraulic post-service proof branch or another open safety module.
