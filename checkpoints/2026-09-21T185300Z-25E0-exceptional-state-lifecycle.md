# 25E0 checkpoint — exceptional-state lifecycle and production carryover

Date: 2026-09-21

## Durable progress

- Added `safety-course/25E0_MAINTENANCE_BYPASS_FORCE_LIFECYCLE_AND_PRODUCTION_CARRYOVER_2026-09-21.md`.
- Added `safety-course/25E0_EXCEPTIONAL_STATE_CARRYOVER_ADVERSARIAL_EXERCISE_2026-09-21.md`.
- Rockwell evidence establishes a concrete professional distinction between disabled and removed safety forces: safety forces must be removed before safety lock/signature, and forcing an input overrides the actual field value.
- Rockwell FactoryTalk Security exposes distinct authorization for forcing safety tags.
- Siemens S7 Distributed Safety provides an independent lifecycle pattern: deactivated safety mode must be verifiable, indication/logging is recommended, transmitted safety-related data cannot simply be trusted as safely generated while deactivated, and return/changes are coupled to configuration/acceptance controls.
- Built a reusable exceptional-state manifest and production-readiness gate without inventing universal timeout or restart values.
- No executable compute was justified. No GitHub-hosted runner was used.

## New freezes

- `AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION`.
- `BYPASS/FORCE DISABLED != BYPASS/FORCE REMOVED` where the platform distinguishes them.
- `FORCED INPUT TRUE != FIELD INPUT PHYSICALLY TRUE`.
- `SAFETY MODE RESTORED != SAFETY FUNCTION REVALIDATED`.
- `SAFETY SIGNATURE MATCHES != FIELD HARDWARE VALIDATED`.
- `SERVICE KEY/PASSWORD PRESENT != PERSONNEL-SAFETY AUTHORITY`.
- `VISIBLE WARNING != ADEQUATE RISK REDUCTION`.
- `EXCEPTIONAL STATE CLEARED != FRESH ORDINARY START DEMAND`.
- `MAINTENANCE COMPLETE != PRODUCTION READY` until temporary-state clearance and impact-based revalidation are complete.

## Exact next work

Advance into **service/setup operating-mode architecture**. Trace at least two professional implementations that combine mode selection/access authorization with enabling-device/hold-to-run or safe/reduced-motion behavior and explicit return to automatic/production. Prefer one physical key/mode-selector implementation and one programmable safety implementation. Determine what mode authorization actually proves, what remains independent safety authority, and what happens to Start/Jog/Cycle requests asserted before/during the transition back to production.

Do not infer demand freshness or universal bypass timeout semantics. If the public documentation does not expose them, mark that boundary and continue to the next useful safety branch.
