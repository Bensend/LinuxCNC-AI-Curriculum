# Lane B checkpoint — EDM / contactor feedback boundary

Date: 2026-09-19

Completed independent study: `safety-course/EXTERNAL_DEVICE_MONITORING_CONTACTOR_FEEDBACK_PHYSICAL_STATE_BOUNDARY_STUDY_2026-09-19.md`.

Primary-lane overlap avoided: current primary work is OEM press-brake stop-time maintenance, hydraulic final-element replacement, ram/load witness, and machine-level revalidation. Lane B did not modify those files.

Durable freeze:

- SAFETY OUTPUT OFF != EXTERNAL CONTACTOR OPENED.
- CONTACTOR FEEDBACK AS EXPECTED != HAZARDOUS ENERGY PHYSICALLY REMOVED.
- EDM HEALTHY != DRIVE TORQUE ABSENT != HYDRAULIC PRESSURE SAFE != RAM PHYSICALLY STOPPED/RETAINED != PERSONNEL SAFE.
- RESET REQUESTED != EDM SATISFIED != SAFETY REARMED != ORDINARY PRODUCTION START AUTHORIZED.
- INPUT TEST-PULSE DIAGNOSTICS != OUTPUT/FINAL-DEVICE EDM.

No executable verification was justified. No GitHub-hosted runner was used.

Next Lane-B target: a complete professional implementation showing protective device -> independent evaluator -> two external final switching devices -> feedback -> deliberate one-device stuck/welded fault -> restart inhibited -> physical hazardous-state witness -> repair/replacement -> feedback and physical-function re-proof -> safety rearm -> fresh ordinary START. Prefer OEM/manufacturer schematic plus commissioning/fault procedure. Do not invent OpenPressBrake-specific contactors, timing, performance level, stop behavior, or physical acceptance thresholds.