# Safety checkpoint — presence/reset/restart/trapped-person — 2026-09-17

- Session start UTC: `2026-09-17T21:38:39Z`
- Session end UTC: `2026-09-17T21:40:23Z`
- Actual elapsed: **1.7 min**
- Overlap status: **YES / parallel lane observed.** At session start `main` already contained Lane-B reset-visibility/restart-authority commits `6465ad11` and checkpoint `200821d7` created at 20:50Z. This run avoided duplicating that artifact and extended the branch into stand-behind/presence and trapped-person restart prevention.
- Compute: **NONE**. No GitHub-hosted Actions and no self-hosted compute; source/documentation reasoning fully answered the current questions.

## Durable work

1. `safety-course/PRESENCE_SENSING_RESET_RESTART_PROFESSIONAL_TRACE_2026-09-17.md` — SICK S300 + sBot Speed + Pilz evidence trace. Freezes `FIELD CLEAR != ZONE CLEAR != RESET != START` and preserves stand-behind/presence as a physical geometry problem.
2. `safety-course/TRAPPED_PERSON_RESTART_PREVENTION_DESIGN_CARD_2026-09-17.md` — practical design/commissioning card for perimeter entry, blind spots, personnel retention, stale ordinary-control state, and minimum-operate decisions.

## Evidence classes

- DOC-CONFIRMED: SICK S300 reset outside hazard, inaccessible from inside, full view; internal reset can restore OSSD while external restart interlock still prevents machine restart.
- DOC-CONFIRMED: SICK sBot Speed physical protective-field challenge stops robot; clearing field alone retains standstill until manual safety reset + manual robot restart; automatic-restart checklist separately requires no walk-behind of the protective field.
- DOC-CONFIRMED: Pilz Key-in-pocket guidance retains personnel identity while inside and requires sign-out before productive enable; large/no-overall-view plant guidance adds a blind-spot check.
- INFERENCE: OpenPressBrake must resolve stand-behind, reset visibility/span and retained-person behavior independently of LinuxCNC/HAL/normal FPGA command state.
- UNKNOWN: actual OpenPressBrake safeguard geometry, reset locations, rear/side access, presence coverage, personnel-retention architecture and exact final elements.

## Lesson-log safe append

`LESSON_LOG.md` remains a large shared file whose connector view cannot be safely reconstructed for whole-file replacement. No append primitive is exposed by the current GitHub connector. Per governance, it was **not overwritten from a partial fetch**. Safe-append payload preserved here:

`| 2026-09-17 | 4000 presence sensing + trapped-person restart prevention | 2026-09-17T21:38:39Z | 2026-09-17T21:40:23Z | 1.7 | SAFETY COURSE ACTIVE / PRESENCE-RESET BOUNDARY ADVANCED | Find a complete implementation exposing personnel-presence/restart prevention through safety logic to physical final-element re-enable; otherwise trace key-in-pocket/trapped-person logic deeper. | Parallel Lane-B reset study already on main before start; this run extended rather than duplicated it. No compute consumed. |`

## Short-session continuation check

Performed. The reset-location branch had already been advanced by the parallel lane, so this run immediately rotated to the distinct stand-behind/trapped-person branch and produced the second commissioning artifact rather than stopping at the first trace.

## Precise next work

Prefer a complete OEM/cell implementation exposing `entry/presence -> safety demand -> retained-person state -> reset -> final-element authority -> separate ordinary start`. If public evidence still stops before final elements, trace a trapped-key/key-in-pocket architecture into inspectable safety-controller logic and preserve the final-element gap as UNKNOWN rather than inventing it. The professional monitored hydraulic valve/fall-protection trace remains another high-value independent branch.