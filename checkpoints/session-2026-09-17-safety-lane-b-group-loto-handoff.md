# Safety Lane B — group LOTO / multi-crew handoff — 2026-09-17

- Status: CHECKPOINTED — independent safety lane remains active.
- Starting main: `c8d74fb9`.
- Durable artifact commit: `264f3d0e`.
- Compute: NONE. No executable verification question justified self-hosted `[self-hosted, openpressbrake]` compute; no GitHub-hosted Actions minutes used.

## Governance and overlap check

Read `START_HERE.md`, `MASTER_MISSION.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `SOURCE_POLICY.md`, `PROGRESS.md`, current safety-course inventory, recent commits, and newest durable primary checkpoint before selection.

Primary lane newest durable work at session start was `c8d74fb9`, which completed the OpenPressBrake safety power/common map plus safeguard-override access register and explicitly named group-LOTO multi-crew handoff as the independent next branch. Lane B therefore did not touch the primary power/common-map or override-register files.

Immediately before the durable write, current main was re-read via recent commit history and remained `c8d74fb9`; no overlapping file or newer primary commit appeared. Immediately after the artifact write, current main was `264f3d0e`, with the prior primary commit still directly below it; no intervening overlapping commit appeared.

## Durable work

Added `safety-course/SAFETY_GROUP_LOTO_MULTI_CREW_HANDOFF_FAILURE_PATH_WORKSHEET.md`.

Frozen architecture rule:

> A group lockout is not merely a lockbox state. Protection depends on individual exposure accountability, verified isolation of every applicable hazardous-energy source, continuity across crew/shift changes, and an explicit controlled transition whenever testing or positioning temporarily requires energization.

The worksheet separates normal safeguarding, servicing hazardous-energy control, and ordinary LinuxCNC/HAL/FPGA control. It adds:

- job-level primary/overall coordinator and crew responsibility fields;
- electrical, hydraulic, stored-pressure, gravity/mechanical, pneumatic, drive-bus and external-feed energy-domain ownership;
- individual sign-on/sign-off and exposure accounting;
- shift/personnel handoff challenges;
- explicit reaccumulation checks;
- bounded test/position transition sequence;
- ten failure paths including cross-crew ownership gaps, inherited stale verification, informal energized servicing, stale ordinary-control state, absent-worker lock removal misuse, and HMI/safety diagnostics being mistaken for physical isolation proof;
- release sequencing that keeps LOTO release, independent safety reset, LinuxCNC/FPGA rearm, return-to-service release and START distinct.

## Evidence provenance

`DOC-CONFIRMED` claims are bounded to OSHA 29 CFR 1910.147 and OSHA interpretive/enforcement material. Machine-specific OpenPressBrake isolation points, accumulator behavior, ram restraint, discharge times, test/position procedure, group-lockbox implementation, personnel authorization and final restart witnesses remain `UNKNOWN`.

No PL/SIL/DC, pressure threshold, stopping distance, hydraulic truth table, discharge time or other physical machine fact was invented.

## Exact next independent work

Build `safety-course/SAFETY_ENERGIZED_TEST_POSITIONING_BOUNDARY_CHALLENGE_SET.md` **only if** the primary lane has not entered test/position or servicing-energy work by the next run. The challenge set should distinguish a legitimate bounded test/position transition from routine energized servicing, preserve employee-clearance/accountability requirements, force deenergization/re-isolation/reverification before exposure resumes, and challenge stale LinuxCNC/HAL/FPGA/drive commands after the test.

If the primary lane has entered that subject, switch to a distinct physical-restraint/blocking verification or safety-documentation branch rather than duplicate it.