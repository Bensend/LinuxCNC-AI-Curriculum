# Safety course session checkpoint — 2026-09-16

- Session start UTC: `2026-09-16T23:36:19Z`
- Session end UTC: `2026-09-16T23:40:28Z`
- Actual elapsed: `4.2 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — newest durable prior safety checkpoint ended 2026-09-16T21:36:30Z.
- Priority executed: professional maintenance/setup/service-mode architectures, safeguard defeat resistance, enabling devices, mode selection, restart prevention, and OpenPressBrake/LinuxCNC authority boundary.
- Compute: NONE. No GitHub-hosted Actions minutes consumed; no question justified self-hosted execution.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

Created `safety-course/SETUP_SERVICE_MODE_AND_BYPASS_RESISTANCE_2026-09-16.md`.

Key results:
1. Setup/service mode is a safety architecture/state change, not `guard_bypass = true`.
2. Pilz evidence establishes exclusive deliberate operating-mode selection, selection separate from machine operation, safe mode evaluation and authorization patterns.
3. SICK evidence establishes three-position enabling-device behavior and special-mode dangerous-function permission only under controlled reduced-risk conditions.
4. SICK Safe Stationary Machine evidence treats enabling-device release, excessive Service-mode speed, mode-selector/safety-switch faults and EDM faults as reasons to enter/remain in the safe state.
5. Pilz PNOZ documentation reinforces that safeguard restoration must not be allowed to cause unexpected automatic restart.
6. Pilz access-management evidence adds retained personal key/transponder and multi-person restart-prevention concepts; this is directly useful where a single reset station cannot establish that a large cell is empty.
7. OpenPressBrake/LinuxCNC boundary: ordinary HMI may request/display mode and normal control may adapt, but ordinary LinuxCNC/HAL/FPGA cannot be the sole personnel-safety mode selector, enabling channel, guard override, or restart authority.
8. Human-factors rule strengthened: if routine calibration/setup drives technicians to defeat a guard, redesign the setup workflow/safeguarding where feasible; do not institutionalize bypass.

## Exact next work

1. Find a modern CNC press-brake example exposing setup/adjustment mode together with laser/light-curtain behavior, foot/enabling controls and hydraulic safety-valve authority.
2. Find a complete servo machine-tool special-mode implementation combining mode selection, guard state, enabling switch, safe motion (SLS/SDI/SOS/STO as applicable), final elements and restart logic.
3. Trace one multi-person automated-cell retained-key/key-in-pocket implementation through final-element restart permission.
4. Continue preserving UNKNOWN for any machine-specific safe speed, stopping distance, PL/SIL, hydraulic state or press-brake mode behavior not established by evidence/calculation.

## LESSON_LOG safe-append status

`LESSON_LOG.md` is known from the active safety checkpoint to exceed the connector's safe complete-fetch envelope; available write action is whole-file replacement rather than atomic append. It was therefore not overwritten from incomplete content. Preserve this row for the repository's safe append mechanism:

`| 2026-09-16 | Safety course — setup/service mode and bypass resistance | 2026-09-16T23:36:19Z | 2026-09-16T23:40:28Z | 4.2 | PROFESSIONAL SPECIAL-MODE FOUNDATION ADDED | Modern press-brake setup-mode + servo safe-motion implementation | No overlap; no compute. |`
