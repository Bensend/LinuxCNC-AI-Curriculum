# Safety checkpoint — Lane B manual reset release-edge authority

Date: 2026-09-18

## Completed

Created `safety-course/MANUAL_RESET_STUCK_INPUT_RELEASE_EDGE_AUTHORITY_STUDY_2026-09-18.md` at commit `9f6a9937a4a2fb8d61425784753b459db23a718d`.

The primary lane's newest durable work is `PRESS_CYCLE_INTERRUPT_RECOVERY_FRESH_REINITIATION_TRACE_2026-09-18.md`; Lane B deliberately selected a different evidence package and different files.

## Frozen result

`RESET INPUT HIGH != DELIBERATE RESET ACTION`.

`RESET BUTTON PRESSED != RESET ACCEPTED`.

`RESET ACCEPTED != HAZARDOUS MOTION AUTHORITY`.

`RESET ACCEPTED != FRESH START / JOG / CYCLE INTENT`.

ABB documentation confirms release/trailing-edge reset semantics and monitoring against too-short/too-long reset actuation. Schneider safety-controller documentation independently exposes blocked-reset and restart-interlock diagnostics. OpenPressBrake transfer remains INFERENCE; actual reset hardware, timing, safety architecture and performance claims remain UNKNOWN.

## Parallel-work reconciliation

Immediately before the substantive write, current main still ended at primary checkpoint `6d24f65b5ace31a7386e14401fe51624c3bcd233`. Immediately afterward, main showed Lane-B commit `9f6a9937a4a2fb8d61425784753b459db23a718d` directly above it. No overlapping primary write appeared. Shared `PROGRESS.md` was deliberately left untouched to avoid a shared-file collision.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a professional implementation exposing `reset required -> reset input stuck/shorted/held -> safety diagnostic -> outputs remain inhibited -> repair/release -> valid deliberate reset -> safety rearm -> separate fresh start`, preferably with wiring/function-block detail and final-element feedback. Do not duplicate the primary lane's press-cycle interrupt/recovery package.