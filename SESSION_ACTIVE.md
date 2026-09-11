STATUS CLOSED
SESSION_START 2026-09-11T21:12:36Z
SESSION_END 2026-09-11T21:24:25Z
ELAPSED_MIN 11.8
MODULE 3600 press-brake backgauge/operator modes — typed absolute positioning / extra-joint architecture
RESULT Source/documentation/community work changed the leading press-brake backgauge architecture from an ordinary-coordinate MDI/G53 assumption to an evidence-supported extra-joint path. Internal JOG_ABS was traced and retained as a jog-family mechanism; MDI/G53 was traced as the ordinary-coordinate alternative. Public Ursviken evidence uses six real extra joints and UI -> limit3 -> joint.N.posthome-cmd. Pinned control.c confirms posthome_cmd + motor_offset routes to motor-pos-cmd after homing. PB-BG-002 extra-joint typed-position contract is frozen before execution.
CHECKPOINT Implement the smallest deterministic PB-BG-002 harness exactly against frozen P0-P7/Gates A-J and retain invocation-level evidence. Do not add motor physics merely for depth. If execution exposes a LinuxCNC-specific ambiguity, resolve it from source/runtime before changing the frozen contract. F02 remains blocked on valid information-separated S02/E20/X01/X02 handoffs.
LESSON_LOG Timing row queued through TIMING_APPEND_REQUEST.txt for canonical append.
OVERLAP No overlap; previous canonical lesson ended 2026-09-11T20:19:24Z, 53m12s before this session start.
