# 4000 Safety checkpoint — press-brake return-to-production chain

## Completed
- Added `safety-course/PRESS_BRAKE_POST_MAINTENANCE_STOPPING_PERFORMANCE_SAFEGUARD_AND_PRODUCTION_RELEASE_CHAIN_2026-09-20.md`.
- Rockford RHPS now closes the missing manufacturer-level before-production boundary: after any maintenance, function-test the press brake numerous times in all modes before allowing operator production, with point-of-operation safeguarding in place, adjusted, and operating properly.
- Combined with the existing RHPS stopping-performance lifecycle, stopping-dependent safeguards require quantitative stopping evidence and consequent safety-distance/physical safeguard requalification when that evidence has been invalidated.
- Added `safety-course/SAFETY_MAINTENANCE_CHANGE_TO_EVIDENCE_INVALIDATION_MATRIX_2026-09-20.md` to map representative maintenance changes to evidence classes A/B/C/D without mechanically retesting unrelated functions.

## Freeze
- MAINTENANCE COMPLETE != ALL-MODE FUNCTION TEST COMPLETE != PRODUCTION AUTHORIZED.
- ALL-MODE FUNCTION TEST != QUANTITATIVE STOPPING PERFORMANCE ACCEPTED when stopping-dependent safeguard evidence was invalidated.
- STOPPING PERFORMANCE ACCEPTED != SAFEGUARD PHYSICALLY REQUALIFIED.
- CONFIGURATION/IDENTITY RESTORED != REQUIRED PHYSICAL EVIDENCE RESTORED.

## Next work
Seek a manufacturer/OEM machine-level **partial-acceptance/change-impact matrix** that scopes post-change tests by affected safety function and includes hydraulic/mechanical final elements or safeguard geometry. Compare it to the new curriculum synthesis. Treat generic press-brake stop-time and generic drive-replacement searching as information-gain limited.

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
