# 4000 safety checkpoint — gravity-axis brake-proof recovery — 2026-09-18T07:39Z

## Session timing

Start UTC: 2026-09-18T07:35:24Z
End UTC: 2026-09-18T07:39:18Z
Elapsed: 3.9 min
Overlap: yes — a parallel Lane-B EDM feedback-short checkpoint committed at 2026-09-18T06:50:33Z before this session; this session deliberately avoided Lane-B field-I/O/EDM work and continued the independent gravity-axis retaining-element branch.

## Governance/current state

Read `START_HERE.md` first, then current mission/work-selection/level/progress state. Repository state confirms 1000/2000/3000 are closed and 4000 safety is the primary active priority. The latest parallel Lane-B work concerns EDM feedback shorts; it was not duplicated.

## Durable work

Created `safety-course/GRAVITY_AXIS_BRAKE_PROOF_FAILURE_RECOVERY_CARD_2026-09-18.md` in commit `d30250cc`.

The card extends the existing SBC/SBT trace from proof testing through failure and recovery. Manufacturer evidence supports that Siemens SBT deliberately challenges brake holding torque and detects excessive encoder-observed motion; Siemens S210 diagnostics require fault-cause removal and safe acknowledgement and may require the brake test to be restarted. Pilz independently distinguishes safe brake control from brake proof and requires defined reaction to detected safety-function faults/limit violations.

Frozen chain:

**FAULT DETECTED != HAZARD PHYSICALLY CONTROLLED != FAULT CAUSE REMOVED != SAFE ACKNOWLEDGEMENT != PROOF RESTORED != SAFETY AUTHORITY RESTORED != FRESH ORDINARY START.**

The card adds two-retaining-element and mechanical-plus-hydraulic disagreement rules, stale LinuxCNC command recovery challenges, missing-witness behavior, and a minimum-safe-to-operate gate. It explicitly leaves the machine-specific physical safe disposition and OpenPressBrake retaining topology UNKNOWN.

## Compute

No simulation/build/synthesis/benchmark/test compute was justified or used. No GitHub-hosted Actions minutes consumed. Any future bounded executable question must target `[self-hosted, openpressbrake]` only.

## LESSON_LOG safe-append state

`LESSON_LOG.md` remains a large shared append-only file. No safe append primitive is available through the current connector, so it was not reconstructed or overwritten from a truncated fetch. Append this exact row when a safe append/tail mechanism is available:

`| 2026-09-18 | 4000 gravity-axis brake-proof failure/recovery | 2026-09-18T07:35:24Z | 2026-09-18T07:39:18Z | 3.9 | BRAKE-PROOF FAILURE/ACKNOWLEDGEMENT/RE-PROOF BOUNDARY INTEGRATED | Find one same-machine implementation exposing failed retaining-element proof -> safety latch -> physical load-safe disposition -> repair/reset prerequisites -> re-proof -> safety re-enable -> separate START; prefer two distinct retaining elements. | Overlap with parallel Lane-B work acknowledged; avoided EDM/field-I/O branch. No lab compute consumed. |`

## Precise next work

Find a same-machine professional implementation exposing:

**failed mechanical/hydraulic retaining proof -> safety latch/inhibit -> physical load-safe disposition -> repair/reset prerequisites -> re-proof -> physical final-element re-enable -> separate ordinary START.**

Prefer two genuinely distinct retaining elements (for example mechanical plus hydraulic) so disagreement and common-cause behavior can be traced. If public evidence stops before physical load disposition or re-proof, preserve that link as UNKNOWN rather than composing unrelated systems.
