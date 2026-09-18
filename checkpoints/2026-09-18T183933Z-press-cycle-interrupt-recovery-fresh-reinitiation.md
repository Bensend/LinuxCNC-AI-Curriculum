# Safety checkpoint — press cycle interrupt/recovery/fresh reinitiation

Date: 2026-09-18
UTC session: 2026-09-18T18:36:33Z -> 2026-09-18T18:39:33Z (3.00 min)

## Completed

Created `safety-course/PRESS_CYCLE_INTERRUPT_RECOVERY_FRESH_REINITIATION_TRACE_2026-09-18.md` at commit `193ec7b668eff7cfda633b4a8e3e8a264d4f837d`.

Professional Rockwell SAFETY-AT198 pneumatic-press evidence closes a useful gap left by the prior mechanical-press anti-repeat study: an interrupted cycle is not simply resumed. The documented recovery requires Reset press/release, deliberate two-hand recovery retraction, physical retracted state, then release of the two-hand control before a new cycle can be initiated. SAFETY-AT071 independently supports reset != run authority and invalid two-hand timing != valid initiation.

## Frozen result

`RESET ACCEPTED != PRODUCTION CYCLE AUTHORITY`.

`RECOVERY MOTION AUTHORIZED != PRODUCTION CYCLE RESUMED`.

`CYLINDER RETRACTED != NEXT CYCLE INITIATED`.

`TWO-HAND CONTROL STILL HELD AFTER RECOVERY != FRESH NEXT-CYCLE INITIATION`.

`SAFETY DEVICE RESTORED != INTERRUPTED CYCLE AUTOMATICALLY RESUMES`.

The pneumatic implementation is DOC-CONFIRMED. Transfer of the authority-state separation to OpenPressBrake is INFERENCE. OpenPressBrake hydraulic valve truth table, pressure/force/timing/stopping behavior, cycle definition and PL/SIL/category/DC remain UNKNOWN.

## Parallel-work reconciliation

After the substantive commit, main was re-read. No intervening overlapping commit appeared; the new artifact is directly above this session's start checkpoint and the prior Lane-B checkpoint. Shared `PROGRESS.md` was deliberately not rewritten.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Lesson log

Exact timing row was submitted via `TIMING_APPEND_REQUEST.txt` at commit `9c699a70ce16fc6d7d9a4f128636599355f5ccc1`; the repository's safe append workflow is the only intended writer of the large `LESSON_LOG.md` and targets `[self-hosted, openpressbrake]`.

## Precise next work

Find an actual hydraulic press or press-brake implementation exposing `fresh initiation -> downstroke -> protective interruption -> hydraulic safe reaction / physical motion witness -> deliberate recovery -> known physical position -> release/reinitiation -> next cycle`. Prefer a source that exposes the final hydraulic elements and interrupted-cycle behavior together. Do not import SAFETY-AT198 pneumatic valve/cylinder behavior into OpenPressBrake.
