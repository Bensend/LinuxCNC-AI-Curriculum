# 4400 Technician field card — a green GuardLink indication is not a machine safe-state witness

**Training exercise, not permission to commission a real machine.** Scope: Rockwell GuardLink DG + ENETR examples in GLINK-AT001A (July 2023) and 440R-UM009E (February 2026). Confirm exact installed model, firmware, wiring and manufacturer revision before any real application. All machine-specific physical limits are UNKNOWN.

## Four questions before anyone is exposed

1. **What actually protects the person?** Identify `SF/PHY/SRS`, independent safety logic, final contactor/drive/valve/holding mechanism, and its physical witness. Do not credit a LinuxCNC HMI or ENETR status as the safety owner.
2. **Which command was used?** `Reset1` (relay reset request), `FaultReset` (relay power cycle), `GuardLinkx.FaultResetCmd` (tap/device power cycle), or `LockCmd`/`UnlockCmd` (locking request). They are not synonyms.
3. **What changed physically?** Guard geometry/locking, person location, spindle/ram/robot motion, trapped hydraulic/pneumatic/electrical energy, gravity restraint and downstream final elements are separate observations.
4. **Was anything replaced or bypassed?** Preserve change ID, exact catalog/firmware, fault history, restoration test and independently witnessed physical protection. An automatically recovered link is not a return-to-service certificate.

## Adversarial scenarios — answer with a reason, not a green light

| Situation | Tempting but wrong shortcut | Required engineering disposition |
|---|---|---|
| OSSD tap channels disagree for 3 s | '3 s is allowed stopping time' | Reject. This is a specific **diagnostic discrepancy window**, not stop performance. Investigate cause; physical stop proof separate. |
| EMSS tap opens channels 8 s apart | 'All devices are fine because within 10 s' | Reject universal claim. Product-specific simultaneity is not machine safety-function validation; selected hazard still demands prompt protective response. |
| GuardLink reports Operational, DG outputs OFF | 'Contradictory status means broken HMI' | Not necessarily: other safety inputs, feedback and reset can keep outputs OFF. Trace the complete authority chain. |
| `FaultResetCmd` clears a device fault | 'The machine is now safe and may auto-run' | Reject. Device power cycling is not deliberate safety rearm, physical safe state, occupancy proof or fresh ordinary start. |
| Same-type tap is hot-replaced and the link recovers | 'No post-replacement test needed' | Reject. Manufacturer describes link recovery, not maintenance energy control or revalidation of installation and hazard protection. |
| `UnlockCmd` to nonlocking tap briefly drops DG output | 'We can use this as a cheap stop' | Reject. 2026 manual documents firmware-dependent transient behavior; not a supported independent protective stop. |
| Robot-cell entry gate closes after worker walks inside | 'Closed guard means empty cell' | Reject. Whole-body-access occupancy/restart protection is separate. |
| Press brake rear gate locked; beam moves downward on lost power | 'Lock status proves safety' | Reject. Independently validate gravity/load holding and hydraulic energy; no exposed-person operation until established. |

## Minimal field record to fill, never pre-fill from this generic example

- Exact relay/interface/tap/safety-device catalog and firmware:
- GuardLink tap class (OSSD / EMSS / passive) and receiver/terminator:
- Safety-rated decision owner and physical final elements:
- Current fault code, time, tap and status; what diagnostics do **not** reveal:
- Electrical supply/pilot/common dependency and replacement history:
- Guard geometry, escape, stopping/holding and occupancy physical witnesses:
- Maintenance energy isolation / personal control method:
- `CHG-*` and `VAL/PT-*` acceptance evidence, operator-restart authorization:
- `UNKNOWN` or `BLOCKED` items and restriction (if minimum threshold unproved: **no personnel-exposed hazardous operation**):

## Good human-factors redesign

Use a clear per-tap fault display, visible root-cause and reset-type distinction, keyed/traceable replacement, easily restorable guards and an obvious safe maintenance path. Avoid an HMI 'reset everything' button that repeatedly power-cycles faults and discards evidence. A shorter downtime path is desirable only if it preserves independent safety authority and required physical verification.

**Evidence:** GLINK-AT001A pp. 3, 5, 7–9; 440R-UM009E pp. 6, 39, 62–65, 75. `DOC-CONFIRMED` for those product descriptions; `UNKNOWN` for installed-machine results; `TEST-CONFIRMED`: none.
