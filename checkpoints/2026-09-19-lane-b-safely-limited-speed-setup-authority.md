# Lane B checkpoint — safely limited speed / setup authority

Date: 2026-09-19

Completed independent Lane-B study: `safety-course/SAFELY_LIMITED_SPEED_SETUP_MODE_FEEDBACK_AND_STOP_AUTHORITY_STUDY_2026-09-19.md`.

Parallel-work check: immediately before the substantive commit, current main's newest primary durable safety work was `HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md` plus its progress/checkpoint commits. Lane B therefore did not continue two-hand-control, hydraulic holding-valve, or physical stop-distance files.

Freeze carried forward:

`LINUXCNC COMMANDED SLOW SPEED != SAFELY LIMITED SPEED != SAFE FEEDBACK VALID != ACCESS/SETUP MOTION AUTHORIZED != PHYSICAL STOP PROVED != PRODUCTION AUTHORITY`.

Also preserve:

`EACH AXIS BELOW ITS SPEED CEILING != MULTI-AXIS CRUSHING HAZARD CONTROLLED`.

No OpenPressBrake numeric safe speed, stopping time, delay, safety distance, hydraulic behavior or performance level was invented. No executable verification was justified; no GitHub-hosted or self-hosted runner compute was consumed.

Next Lane-B target: a complete professional implementation tracing `mode selection -> independent safe feedback -> SLS transition proof -> access release where applicable -> enabling device + deliberate jog -> overspeed/fault challenge -> documented safe stop -> actual final element -> physical motion witness -> correction/revalidation -> safety rearm -> fresh ordinary START`, preferably with schematic and commissioning procedure.