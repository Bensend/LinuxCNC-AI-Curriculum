# Safety curriculum Lane B checkpoint — 2026-09-18 07:48 CT

## Completed

Created `safety-course/GUARD_LOCKING_ESCAPE_RELEASE_RESTART_AUTHORITY_STUDY_2026-09-18.md` from independent SICK, Pilz, and Rockwell manufacturer evidence.

Frozen boundary:

**GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

Escape release changes the safety state. Restoring escape release and closing/locking the guard is not proof of personnel-clear and is not fresh ordinary START authority. Device reset, machine safety reset/rearm, and ordinary motion intent remain separate.

## Parallel-lane separation

Primary lane newest durable work at selection time was `safety-course/DUAL_BRAKE_SEQUENTIAL_PROOF_AND_MASKING_TRACE_2026-09-18.md` and associated progress/log commits. Lane B touched a new guard-locking evidence file plus this checkpoint and PROGRESS only; it did not edit the primary gravity-axis evidence package.

Main was re-read after the Lane-B substantive commit. No intervening overlapping primary write appeared before the progress/checkpoint updates.

## Evidence state

DOC-CONFIRMED: manufacturer behavior for personnel-protection guard locking, escape release, safe-output response, device recovery/function checks, and safe-state dependency before unlock.

INFERENCE: architecture rules separating application STOP/idle, safe unlock authority, personnel clear, safety reset/rearm, and fresh ordinary START.

TEST-CONFIRMED: none.

COMMUNITY-REPORTED: none used.

UNKNOWN for OpenPressBrake: actual guard-locking requirement, guard geometry, hazardous overrun/stopping time, safe-state witness, escape hardware, reset sequence, PL/SIL/category/DC, hydraulic state, and personnel-clear implementation.

## Compute

No executable verification was justified; no hosted or self-hosted compute was used.

## Exact next Lane-B work

Find a professional accessible-cell implementation exposing the complete chain:

`hazardous motion -> stop request -> safety-side safe-state/standstill proof -> guard unlock -> bodily entry -> escape/restart-prevention state -> guard close/lock -> personnel-clear proof -> safety reset/rearm -> separate fresh ordinary START`.

Prefer a source that also documents failed lock/escape-release diagnostics or power-cycle recovery. If the primary lane has moved into guard-locking work by then, rotate to another independent open safety artifact rather than duplicating it.