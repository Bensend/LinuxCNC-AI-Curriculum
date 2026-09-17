# Safety Lane B — contractor / visitor / temporary-personnel interface checkpoint — 2026-09-17

- Compute: NONE. No GitHub-hosted Actions minutes consumed; no executable question justified self-hosted compute.
- Status: CHECKPOINTED — safety course remains active.
- Parallel check: current main and newest commits were re-read immediately before durable work. Primary lane is advancing change-boundary/revalidation and shared-power common-cause analysis, with exact next work an OpenPressBrake safety power/common map. Lane B selected a different artifact, source package, and files.

## Durable work

Added `safety-course/SAFETY_CONTRACTOR_VISITOR_AND_TEMPORARY_PERSONNEL_INTERFACE_CARD.md` in commit `cff28172`.

Frozen rule:

`presence/access != task authorization != competence != isolation authority != safety reset authority != ordinary-control rearm authority != return-to-service release != START authority`

The card covers host/contractor procedure exchange, authorized/affected/visitor/temp role boundaries, group work, shift/personnel handoff, temporary energized testing interface, safeguard override restoration, and explicit reset/rearm/release/START separation. LinuxCNC/HAL/FPGA state remains ordinary-control evidence rather than personnel-safety authority.

## Evidence gain

- `SOURCE-CONFIRMED`: OSHA 29 CFR 1910.147(f)(2) requires the on-site and outside employers to inform each other of their respective LOTO procedures for covered outside servicing, and requires the on-site employer to ensure its employees understand/comply with restrictions and prohibitions of the outside employer's energy-control program.
- `SOURCE-CONFIRMED`: 1910.147(f)(3) requires equivalent group protection, responsibility/exposure-status control, coordination when multiple crews/groups are involved, and personal device participation by each authorized employee.
- `SOURCE-CONFIRMED`: 1910.147(f)(4) requires continuity of LOTO protection during shift/personnel changes and orderly transfer between off-going/oncoming employees.
- `SOURCE-CONFIRMED`: 1910.147(c)(7) distinguishes authorized, affected, and other-employee training/communication obligations.

These are kept bounded to hazardous-energy-control scope and are not promoted into machine-specific PL/SIL/DC, stopping, pressure, timing, hydraulic, or guard-geometry claims.

## Re-read after artifact commit

Current main was re-read after `cff28172`; no intervening primary-lane commit or overlapping file appeared.

## Exact next independent work

Build `safety-course/SAFETY_SAFEGUARD_DEFEAT_KEY_OVERRIDE_ACCESS_REGISTER.md` unless the primary lane enters that topic first. Cover issuance/recovery of safeguard keys, override tools, passwords and service credentials; named purpose and time bounds; alternate controls during authorized temporary use; restoration witness; shared/lost/duplicated credentials; abandoned overrides; production-pressure failure paths; and the rule that access control cannot substitute for an independent safety function.

If that overlaps current primary work, switch to a `SAFETY_GROUP_LOTO_MULTI_CREW_HANDOFF_FAILURE_PATH_WORKSHEET.md` focused on cross-crew ownership, exposure-status accounting, shift transfer, test/position cycles, and preventing gaps between electrical/hydraulic/mechanical isolation owners.
