# Safety curriculum checkpoint — two-hand stop-performance lifecycle

Date: 2026-09-19

Substantive commit: `8803dd384387f837e3f0845d395031a5a40a48da`

Completed: `safety-course/PRESS_BRAKE_TWO_HAND_STOPPING_PERFORMANCE_LIFECYCLE_AUTHORITY_TRACE_2026-09-19.md`.

Evidence gain: OSHA explicitly treats stop-time measurement as applicable to hydraulic presses/press brakes and as a periodic way to verify that safeguard distance still corresponds to current stopping ability; IRSST hydraulic press-brake guidance independently makes reliable/repeatable ram stopping time a prerequisite to two-hand safeguarding. This closes the conceptual lifecycle boundary without importing mechanical-power-press formulas into a hydraulic brake.

Frozen boundary: `TWO-HAND INPUT LOGIC PASS != SAFETY OUTPUT PASS != HYDRAULIC FINAL-ELEMENT RESPONSE != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE RELIABLE/REPEATABLE != SAFEGUARD DISTANCE VALID != PRODUCTION AUTHORITY`; `COMMISSIONING STOP-TIME PASS != CURRENT STOP-TIME PROOF`.

No executable verification was justified. No GitHub-hosted Actions compute was used.

Next primary target remains the harder machine-specific hydraulic service chain already recorded in PROGRESS.md: holding/safety-valve service/replacement -> unmasked retaining-function proof -> physical ram/load witness -> pass/fail disposition -> stopping-performance re-proof where applicable -> safety reset/rearm -> press-brake production initiation. Also seek authoritative evidence defining when stop-time/safeguard-distance revalidation is mandatory after hydraulic stop-path service; do not invent a universal interval or trigger.
