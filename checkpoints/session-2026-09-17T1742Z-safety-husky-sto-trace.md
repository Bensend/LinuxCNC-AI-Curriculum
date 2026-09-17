# Safety curriculum checkpoint — Husky ISVGC demand-to-STO trace

Date: 2026-09-17

## Session timing

Start UTC: 2026-09-17T17:34:19Z
End UTC: 2026-09-17T17:42:30Z
Actual elapsed: 8.2 min
Overlap: NO. Newest pre-session curriculum checkpoint ended with commit `9760d995` at 2026-09-17T16:52:03Z; this session start was more than 42 minutes later. A durable start marker was committed before substantive work as `6448ce98`.

## Durable work

- `f56ce722` — `safety-course/OEM_DEMAND_TO_FINAL_ELEMENT_TRACE_HUSKY_ISVGC_2026-09-17.md`
- `a71a94f6` — `safety-course/COMPACT_MINIMUM_SAFE_TO_OPERATE_COMMISSIONING_CARD_2026-09-17.md`

## Evidence gain

The Husky Altanium Individual Servo Valve Gate Controller manual exposes a professional implementation far enough to close the prior Lane-B gap:

- two-channel IMM safety-gate demand and two-channel IMM/cell E-stop demand;
- separate hardwired safety relays K1/K2;
- immediate relay contacts informing ordinary control of the safety demand;
- process-friendly ordinary-control command to close valve stems;
- time-released safety contacts invoking servo Safe Torque Off after the OEM-specific 0.6-s interval;
- HMI safety-signal diagnostics plus relay LED diagnostics;
- physical maintenance tests requiring movement to stop;
- separate subsequent machine start after safeguard restoration.

The 0.6-s delay and Category 3 / PL d claim are preserved strictly as Husky product-specific DOC-CONFIRMED evidence and are not generalized to OpenPressBrake.

Frozen architecture lesson: ordinary control may participate in a useful stop sequence after a safety demand, but independent safety hardware must still own the required final safety action unless the ordinary path itself is established as safety-related by the machine design.

The compact commissioning card was justified by the prior PROGRESS checkpoint's instruction to create it after one more complete-machine application. It includes explicit MODE INTEGRITY and FEEDBACK INTEGRITY gates, physical demand-to-final-element challenge, stored-energy/load-retention review, stale-command/rearm behavior, human-factors bypass pressure, documentation/change control, and qualitative CLEAR / RESTRICTED-REMOTE / DO-NOT-OPERATE decisions without inventing PL/SIL/timing/pressure values.

## Compute

None. No GitHub-hosted Actions minutes and no self-hosted compute were used; authoritative manufacturer documentation answered the questions.

## LESSON_LOG safe-append payload

The connector returned `LESSON_LOG.md` truncated, so the repository rule forbidding destructive replacement of an incompletely fetched large log was obeyed. The exact append row is preserved here for the repository's safe append mechanism rather than replacing the truncated log:

`| 2026-09-17 | 4000 safety — Husky ISVGC gate/E-stop demand-to-STO trace + minimum-operate card | 2026-09-17T17:34:19Z | 2026-09-17T17:42:30Z | 8.2 | OEM FINAL-ELEMENT TRACE CLOSED / COMMISSIONING CARD FROZEN | Trace a professional hydraulic vertical-axis/press implementation exposing blocking/dump/holding final elements, feedback, physical load result, reset and restart; rotate if public evidence stops before physical layer. | No overlap: previous checkpoint commit timestamp 2026-09-17T16:52:03Z. Husky manufacturer manual exposes gate/E-stop -> K1/K2 -> ordinary close command -> delayed STO -> physical stop; no compute consumed. |`

## Short-session continuation check

Because substantive work was under 15 minutes, a second coherent task was executed rather than ending after the source trace: the compact minimum-safe-to-operate commissioning card requested by the earlier progress checkpoint was completed and committed.

## Precise next work

Find a professional hydraulic vertical-axis, press, lift, or comparable gravity-loaded machine implementation that exposes the safety demand through safety logic to actual hydraulic blocking/dump/load-holding elements and, preferably, feedback/monitoring. Build the same demand-to-final-element matrix while distinguishing `remove pressure`, `prevent flow`, `hold load`, and `physically restrain load`. Do not invent a press hydraulic truth table. If public evidence ends at a generic valve symbol or safety-controller output, preserve UNKNOWN and rotate to another open safety branch.
