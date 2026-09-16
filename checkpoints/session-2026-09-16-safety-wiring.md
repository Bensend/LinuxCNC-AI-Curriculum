# Safety wiring research session — 2026-09-16

- Session start UTC: `2026-09-16T15:32:15Z`
- Session end UTC: `2026-09-16T15:34:19Z`
- Actual elapsed: `2.06 min`
- Overlap status: `UNKNOWN` — no authoritative concurrent-session marker was available in the inspected state.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — continue next invocation.

## Durable work completed

- Added `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md`.
- Re-centered `PROGRESS.md` on complete professional E-stop/interlock wiring and explicit hazardous-energy boundaries.
- First reference set covers Pilz PNOZ X3.1 E-stop/guard + feedback-loop pattern, SICK deTec4/UE48 light-curtain + K1/K2 EDM pattern, Siemens SINAMICS STO energy-boundary distinction, and HAWE SAKB professional press-brake hydraulic architecture.
- Explicitly froze the home-shop maintenance rule: control/remove relevant hazards before work; when an unsafe/incomplete/bypassed machine is left unattended, make OUT OF SERVICE / DO NOT OPERATE state unmistakable; tag-out does not substitute for physical hazard control.

## Key evidence gained

1. Professional safety wiring must be traced through the final elements; stopping at a safety-relay contact or OSSD is incomplete.
2. SICK's reference architecture demonstrates OSSD1/OSSD2 -> safety relay -> K1/K2 with positively guided EDM feedback before restart.
3. Siemens explicitly distinguishes STO from electrical isolation: STO suppresses torque-producing drive pulses while the power unit/motor remain electrically connected.
4. HAWE's SAKB press-brake system shows why the electrical trace must cross into the hydraulic diagram: proportional directional valves, monitored holding/seated valves, pump path, anti-cavitation valves and Y1/Y2 cylinders are part of the actual hazardous-motion chain.

## Exact next work

1. Find a publicly inspectable **complete OEM press-brake electrical schematic/service manual** where E-stop, guards/light curtains, safety relay/PLC, reset, contactors/STO and hydraulic-valve safety outputs can be traced on one machine.
2. Pair it with that machine's hydraulic diagram and mark exactly what loses power, what is only torque/command inhibited, what hydraulic paths close/open, and what remains energized.
3. Repeat for a professional servo machine tool and an automated/robotic cell, then build a cross-machine comparison matrix.
4. Do not infer a press-brake E-stop valve truth table from component manuals; preserve it as UNKNOWN until an OEM or validated architecture supplies the missing machine-level evidence.

## LESSON_LOG append status

The required timing row is preserved here because the available GitHub connector exposes whole-file replacement but no atomic append operation. `LESSON_LOG.md` is a large ledger and was not completely fetched; overwriting it from truncated content would violate the repository's safe-append rule. Append this session timing to `LESSON_LOG.md` only when an atomic/safe append path is available.
