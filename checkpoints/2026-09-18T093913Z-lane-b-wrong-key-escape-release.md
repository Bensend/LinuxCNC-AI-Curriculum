# Safety-course Lane-B checkpoint — wrong-key common cause and escape release

Date: 2026-09-18

## Session timing

- Start UTC: 2026-09-18T09:37:49Z
- End UTC: 2026-09-18T09:39:13Z
- Actual elapsed: 1.4 minutes
- Overlap status: parallel Lane-B work; newest durable repo state before selection was `47ca3b3`, while primary gravity-axis work remained at `5212f350`. This run did not modify primary gravity-axis artifacts.

## Governance/current state

Re-read `START_HERE.md`, `MASTER_MISSION.md`, `LEVEL_ORDER.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, newest commits/checkpoint and the active trapped-key Lane-B study. Closed 1000/2000/3000 state remains preserved; active level remains 4000 with safety-course priority.

## Durable work

- Added `safety-course/TRAPPED_KEY_WRONG_KEY_COMMON_CAUSE_AND_ESCAPE_RELEASE_STUDY_2026-09-18.md` in commit `fff06c7`.
- Added direct Fortress manufacturer evidence that duplicate key codes across adjoining systems are a safety-relevant common-cause/configuration risk.
- Added Fortress and EUCHNER evidence separating retained-person restart prevention from inside escape/anti-entrapment provisions.
- Added commissioning challenges for wrong keys, spare/override custody, lock replacement, power cycling with personnel inside, escape-release operation, and fresh-start separation.
- No lab, simulation, synthesis, benchmark, test suite or Actions compute used.

## Frozen lessons

`KEY PHYSICALLY FITS != KEY BELONGS TO THIS SAFETY SEQUENCE != UPSTREAM HAZARD STATE IS VALID != ACCESS IS SAFE.`

`PERSONNEL KEY RETAINED != PERSON CAN ESCAPE != GUARD CAN BE RELEASED FROM INSIDE != HAZARD ENERGY IS CONTROLLED.`

`ESCAPE RELEASE OPERATED != PERSONNEL RETENTION CLEARED != SAFETY RESET COMPLETE != ORDINARY START AUTHORITY.`

## LESSON_LOG safe-append state

The shared `LESSON_LOG.md` is large and was not safely available as a complete fetch in this connector session. Per governance, it was not reconstructed or overwritten from truncated content. Append-ready row:

`2026-09-18T09:37:49Z | 2026-09-18T09:39:13Z | 1.4 min | 4000 safety Lane B | wrong-key common-cause + escape-release/retained-person boundary | no compute | parallel/no primary-file overlap | fff06c7`

## Precise next independent work

Find a professional full-machine implementation or commissioning manual that explicitly tests **wrong key / spare key / escape release / retained-person state / guard restoration / reset / separate restart** together. If public evidence reaches an information-gain stop, rotate to another open safety module rather than infer machine behavior.

OpenPressBrake-specific trapped-key architecture, key codes, guard-locking principle, escape hardware, hydraulic topology, safe pressure, stopping distance, retained force and PL/SIL/category/DC remain UNKNOWN.