# Safety Curriculum Lane B checkpoint — modification impact / revalidation scope

Date: 2026-09-20
Lane: independent safety curriculum Lane B
Durable work: `safety-course/MODIFICATION_IMPACT_ANALYSIS_AND_REVALIDATION_SCOPE_AUTHORITY_STUDY_2026-09-20.md`
Commit: `a7815433f0d815fbbac00a8b16b1f9692d431644`

## Parallel-work disposition

Primary lane's newest durable work is the four-class safety validation matrix plus enabling-switch abnormal-operation/proof-test evidence. Lane B deliberately did not edit those artifacts or continue enabling-device evidence. This checkpoint covers the separate lifecycle problem of choosing revalidation scope after a safety-related modification.

## Durable freezes

- **SAFETY LOGIC TESTED != FIELD WIRING VALIDATED != SENSOR/ACTUATOR MAPPING VALIDATED != COMPLETE SAFETY FUNCTION VALIDATED.**
- **CHANGE MADE != REVALIDATION SCOPE KNOWN.**
- **UNCHANGED FILE/CODE != UNCHANGED SAFETY FUNCTION.**
- **REPLACEMENT CONNECTED != REPLACEMENT CONFIGURED != PHYSICAL SAFETY FUNCTION VALIDATED != RETURN TO SERVICE.**
- **NORMAL DEMAND PASSED != ABNORMAL/FAULT RESPONSE VALIDATED.**
- **CHANGE COMPLETE != PREVIOUS VALIDATION STILL VALID != REVALIDATION SCOPE JUSTIFIED != AFFECTED TESTS PASSED != SAFEGUARDS REQUALIFIED != PRODUCTION AUTHORIZED.**

## Evidence disposition

Rockwell manufacturer documentation establishes active field-device validation, wiring/network fault testing, application-specific validation, modification impact analysis, scope-based revalidation, and post-safety-I/O-replacement validation before safety-rated use. No OpenPressBrake-specific PL/SIL, stopping value, hydraulic threshold, proof-test interval, or revalidation scope was inferred.

No executable verification was justified. No GitHub-hosted runner was used.

## Exact next Lane-B work

Find one authoritative OEM/manufacturer maintenance or modification procedure that names a concrete safety-related change and traverses as much of this chain as the source genuinely supports:

`change/repair -> affected-function identification -> field-device/final-element test -> representative abnormal/fault challenge where applicable -> quantitative physical recheck where the change can affect performance -> safeguard restoration/requalification -> explicit production release`

Prefer a press/press-brake or another high-energy machine. Do not treat generic “test machine operation” language as closure. If the primary lane begins the same evidence package, rotate to another independent safety branch before writing.