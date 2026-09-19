# Lane B checkpoint — distinct test sources through final elements

Date: 2026-09-19
Substantive commit: `681be949a267292dbc91c9dd55de9b66ca6bdf3d`

## Completed

Added `safety-course/SAFETY_INPUT_DISTINCT_TEST_SOURCE_TO_FINAL_ELEMENT_TRACE_2026-09-19.md`.

The trace now joins professional manufacturer evidence for two physical channels, distinct pulse-test sources, the specific cross-short diagnostic lost by sharing a test source, discrepancy-diagnostic placement, latched input-fault recovery, deliberate reset/rearm, redundant safety outputs, and contactor EDM/final-element feedback.

Frozen distinctions:

- TWO CHANNELS != TWO INDEPENDENT DIAGNOSTIC STIMULI != CROSS-CHANNEL FAULT DETECTABLE.
- PULSE TEST HEALTHY != CHANNELS AGREE != DISCREPANCY DIAGNOSTIC LOCATED/ENABLED CORRECTLY.
- FAULT CONDITION REMOVED != FAULT LATCH CLEARED != SAFETY FUNCTION RESET/REARMED != ORDINARY MACHINE START.
- SAFETY LOGIC OUTPUT OFF != CONTACTOR COMMAND OFF != EDM PROVES CONTACTOR OPEN != PHYSICAL HAZARD ABSENT.

No executable verification was justified and no hosted or self-hosted compute was used.

## Short-session continuation check

The source trace was extended beyond the input diagnostic into redundant final-element/EDM evidence rather than stopping after the first PointMax/ESTOP source. A further professional Rockwell safe-motion trace was identified: SAFETY-AT201 uses safe encoder feedback to monitor SS1 deceleration and reaches STO at standstill, while SAFETY-AT200 provides separate guard/E-stop -> redundant contactor -> reset -> separate Start sequencing. This is useful evidence for the next pass, but it is not falsely merged into one machine-specific hydraulic truth table.

## Overlap

Immediately before checkpointing, the newest main commits were this Lane B session itself; no intervening primary-lane write appeared. Shared `PROGRESS.md` was intentionally not rewritten during this short parallel-lane run.

## Precise next work

Find or construct from one professional application family an inspectable end-to-end implementation exposing:

**distinct safety-input test sources -> cross-short/discrepancy diagnosis -> latched recovery -> safety stop output -> final-element feedback -> direct safe speed/standstill or other physical hazard witness -> access/rearm -> separate fresh ordinary START**.

Prefer a source that explicitly validates a wrong test-source assignment or field cross-short and then proves the physical hazard state. Do not treat EDM as physical standstill proof, and do not transfer motor safe-motion details into a hydraulic press-brake without machine-specific evidence.
