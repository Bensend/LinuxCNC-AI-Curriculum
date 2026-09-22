# 4000 Safety Checkpoint — Reintegration State Table / Black-Channel Common Cause

Date: 2026-09-22

## Additional work completed after prior checkpoint

- Added `safety-course/SAFETY_REINTEGRATION_RETURN_TO_SERVICE_STATE_TABLE.md` with explicit stages from faulted through transport recovery, safety-connection validity, device diagnostics, reintegration eligibility/completion, physical-proposition freshness, reset/rearm, and fresh ordinary demand.
- Added explicit evidence states `UNAVAILABLE`, `AVAILABLE-NOT-YET-ACCEPTED`, `FRESH`, `STALE`, and `UNKNOWN` so connection loss is not incorrectly treated as physical baseline change.
- Added `safety-course/25E0_BLACK_CHANNEL_SHARED_INFRASTRUCTURE_NOTE_2026-09-22.md` using Rockwell/ODVA CIP Safety and PI PROFIsafe professional evidence.
- Froze the distinction that shared standard network infrastructure can create common-cause communication/evidence unavailability while the end-to-end safety protocol remains the safety-communication mechanism; ordinary switches/routers are not thereby personnel-safety authorities.
- No executable compute was justified and no GitHub-hosted runner was used.

## Exact next work

1. Build the robot/automated-cell adversarial recovery exercise: safety communication returns while an auxiliary pneumatic/tooling hazard and personnel-clear proposition remain unresolved. Require separate `PROP/EVID/DEP/FIND/VAL` chains and fresh ordinary start.
2. Create one worked transient-connection ledger example showing `UNAVAILABLE` versus `STALE` evidence through loss/recovery and reverse `show where used` impact.
3. Trace professional evidence for an auxiliary-energy/final-element case in an automated cell (for example pneumatic dump/valve feedback or drive/brake state) without inventing machine-specific safe-state truth.
4. Review whether the accumulated recovery material should become a formal syllabus/module section or adversarial assessment rather than continuing to add narrow notes; if information gain is flattening, rotate to the highest-value open 4000 safety branch.
