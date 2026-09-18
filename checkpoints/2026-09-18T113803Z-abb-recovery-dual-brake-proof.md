# 4000 safety checkpoint — ABB recovery + dual-brake independent proof

UTC start: 2026-09-18T11:36:11Z
UTC end: 2026-09-18T11:38:03Z
Elapsed: 1.87 minutes
Overlap: no overlapping write detected in the latest inspected checkpoint/files.

## Durable work

- `safety-course/ABB_SAFEMOVE_MANUAL_RECOVERY_ENABLING_AUTHORITY_TRACE_2026-09-18.md` — commit `9956e67c56a15d5e82fefa7a296f5b23d10581e0`.
- `safety-course/DUAL_BRAKE_INDEPENDENT_PROOF_AND_DIAGNOSTIC_CHAIN_2026-09-18.md` — commit `231d99fb6d277df4c3e961dd0fdb360d1ac31d62`.
- Safe LESSON_LOG append requested through `TIMING_APPEND_REQUEST.txt` in commit `ef671675192b0552481dbe5cbd0721d910dad7f8`; repository workflow targets `[self-hosted, openpressbrake]`.

## New freezes

`SAFETY VIOLATION CLEARED AT INPUT != SAFETY RECOVERY COMPLETE != ENABLING DEVICE RE-INITIATED != CORRECTIVE MOTION AUTHORIZED != SUPERVISED STATE RESTORED != AUTOMATIC/PRODUCTION AUTHORITY != FRESH ORDINARY START.`

`BRAKE 1 PASS + BRAKE 2 UNTESTED != DUAL-RETAINING PROOF.`

`BRAKE 1 PASS + BRAKE 2 PASS != COMMON-CAUSE ABSENCE.`

`TEST CONTROLLER SAYS OK != BRAKE HELD REQUIRED TORQUE` unless the movement/feedback chain used to decide pass/fail is itself adequate and validated.

## Evidence gain

ABB SafeMove supplies a same-machine professional recovery example: safety supervision violation -> manual mode where required -> three-position enabling-device re-initiation -> deliberate corrective jog -> restored supervised state. It preserves a useful separation between recovery motion authority and normal production authority.

Current SEW FCB 21 documentation supplies the dual-brake diagnostic insight: two brakes are tested separately, and an inadequately diagnosed encoder path can allow an `OK` test result despite excess movement. Siemens independently documents SBT support for up to two brakes. Kollmorgen explicitly requires individually testing mechanically coupled brakes without allowing another retaining element to impede/mask the test.

## Compute

No simulation, synthesis, build, benchmark or test suite was justified. No GitHub-hosted runner was used. The only workflow intentionally triggered is the repository's safe lesson-log append workflow, which is explicitly configured for `[self-hosted, openpressbrake]`.

## Precise next work

Find a professional implementation/manual that defines the reaction after **one of two required retaining elements fails proof**: safety latch/inhibit -> physical load-safe disposition -> repair prerequisites -> independent re-proof of the repaired element -> companion-element status/proof -> final-element authority restoration -> separate fresh ordinary production START. Prefer a complete machine/safety-function manual. Preserve degraded-production permission as UNKNOWN unless the machine-specific safety concept explicitly defines it.
