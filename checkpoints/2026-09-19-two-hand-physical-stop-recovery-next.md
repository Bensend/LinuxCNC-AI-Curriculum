# Safety checkpoint — two-hand physical stop/recovery

Date: 2026-09-19

Added `safety-course/TWO_HAND_PRESS_PHYSICAL_STOP_AND_RECOVERY_TRACE_2026-09-19.md`.

Rockwell professional press evidence now joins two-hand simultaneity/continuous actuation to external safety contactors and, in a pneumatic press implementation, early-release motion interruption plus deliberate Reset -> two-hand recovery -> both-buttons-release -> fresh-cycle sequence. Lazer Safe press-brake evidence separately establishes the necessary physical stopping-time/distance witness boundary.

Do not merge these into an invented hydraulic press-brake topology. Frozen boundary: `TWO-HAND SAFETY OUTPUT FALSE != FINAL ELEMENT PHYSICALLY SAFE != RAM STOPPED != STOP PERFORMANCE VALID`.

No compute used or justified.

Next: seek a press-brake-specific OEM/guarding implementation exposing two-hand device -> independent safety evaluator -> actual hydraulic final elements -> release during hazardous closing -> measured stopping/reach witness -> fault/recovery -> production reauthorization. If unavailable, preserve UNKNOWN and rotate to another open safety module rather than synthesize machine facts.
