# Safety checkpoint — hydraulic start-up-test masking audit

Completed `safety-course/PRESS_BRAKE_STARTUP_TEST_FINAL_ELEMENT_COVERAGE_AND_MASKING_AUDIT_2026-09-19.md` at commit `93baf9ef47bc4046487b9a7165542f56ec00e2a2`.

## New freeze

`VALVE MONITOR PASS != START-UP TEST PASS != INDIVIDUAL RETAINING-ELEMENT PROOF != UNMASKED STATIC LOAD-RETENTION PROOF`.

`TWO TESTS != TWO INDEPENDENT VALVE PROOFS` unless the configured test sequence actually challenges each required retaining element independently with a physical witness capable of detecting its failure.

Lazer Safe PCSS-A v1.25/v1.18 gives strong DOC-CONFIRMED dynamic stopping proof and configuration-specific output-removal tables, but the inspected public configurations do not establish an individual static load-retention test for every monitored safety/holding valve. Some test tables remove Safety Valve 1/2 as a group. Individual valve-monitor contacts are switching-state evidence, not independent hydraulic load-retention evidence.

Still UNKNOWN: whether replacement of every monitored safety/holding valve automatically forces the start-up/stopping test; whether the machine OEM requires a separate static retaining proof; and whether a companion retaining element can mask a serviced element in the OEM validation procedure.

A bounded follow-on search did not find authoritative OEM/manifold documentation closing that exact gap. Non-authoritative retrofit/vendor material was not promoted to proof. No lab was justified because the unresolved question is machine/hydraulic-design specific and cannot safely be invented in simulation.

## Next work

Seek an authoritative press-brake OEM/service or hydraulic safety-manifold procedure explicitly exposing `support/isolate/depressurize -> replace one retaining/safety valve -> unmasked physical retention proof -> restore circuit -> dynamic stopping proof -> safety rearm -> production initiation`. If that remains source-limited, rotate to the safety-network or accessible-cell lane rather than manufacturing a synthetic hydraulic test.

No GitHub-hosted compute used.
