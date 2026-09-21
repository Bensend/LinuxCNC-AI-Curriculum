# Safety course checkpoint — feedback recovery and restart freshness

Session start recorded: 2026-09-21T09:34:00Z.

## Durable result

The prior 25E0 reset/feedback branch now has explicit manufacturer failure/recovery semantics rather than only architectural separation. Siemens SIRIUS 3SK1 documentation states that a feedback-circuit error keeps the relay safe while the error persists, but a Start signal detected during that interval can cause start after the feedback error is eliminated. Siemens provides a specific interconnection to prevent automatic start on feedback-error correction.

New durable study: `safety-course/SIEMENS_3SK1_FEEDBACK_ERROR_HELD_START_AND_RESTART_INHIBIT_2026-09-21.md`.
New adversarial exercise: `safety-course/25E0_FEEDBACK_RECOVERY_HELD_START_ADVERSARIAL_EXERCISE_2026-09-21.md`.

Freeze: **FEEDBACK ERROR -> SAFE STATE != START REQUEST CANCELLED**, **FEEDBACK RESTORED != FRESH START**, and **EDM/FEEDBACK VALID != COMPLETE PHYSICAL SAFE-STATE PROOF**.

## Exact next work

Rotate to a different professional final-element implementation and look for explicit disagreement behavior with timeout/latching/manual-reset semantics, preferably drive STO feedback, safety valve/valve-terminal monitoring, brake monitoring or another contactor-monitor architecture. Determine whether recovery alone restores eligibility or whether a fresh reset transition is required.

Do not universalize the 3SK1 algorithm. For each implementation separately trace: protective demand -> safety output -> physical final element -> feedback witness -> mismatch/fault -> recovery -> reset/rearm -> ordinary fresh start.

Bound what each feedback signal physically proves. Prefer sources that expose a mismatch fault and recovery state machine, not another generic EDM wiring diagram. If that source path becomes repetitive, rotate to another open 25E0 safety implementation.

No compute was justified; no GitHub-hosted runner was used.
