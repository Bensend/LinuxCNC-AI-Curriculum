# Primary safety checkpoint — validation evidence classes

Date: 2026-09-20T17:54Z

## Completed

Added:
- `safety-course/ROCKWELL_ENABLING_SWITCH_FAULT_INJECTION_AND_FUNCTIONAL_PROOF_TEST_LIFECYCLE_2026-09-20.md`
- `safety-course/SAFETY_VALIDATION_EVIDENCE_CLASS_AND_RETURN_TO_SERVICE_MATRIX_2026-09-20.md`

Current main was checked before work. Lane B had moved into muting/override authority, so this primary lane avoided duplicating that branch.

## Durable result

Rockwell SAFETY-AT055 provides a manufacturer-directed assembled-function fault-injection test: while jogging, deliberately short an enabling-switch channel to its test source; external contactors must de-energize, diagnostics must indicate the condition, and reset/restart must remain unavailable with the fault. The same checklist deliberately removes the safety-I/O network connection and expects contactor de-energization.

The curriculum now separates four validation evidence classes:

A. normal-demand functional test;
B. deliberate abnormal-operation/fault-injection test;
C. quantitative physical performance test;
D. periodic functional/proof test.

Freeze:
- `TESTED != VALIDATED` unless evidence class and acceptance criterion are named.
- `HAPPY-PATH PASS != FAULT RESPONSE VALIDATED`.
- `FAULT-INJECTION PASS != PHYSICAL PERFORMANCE ACCEPTED`.
- `PHYSICAL PERFORMANCE PASS != PERIODIC PROOF-TEST PROGRAM DEFINED`.
- `REPLACEMENT COMPLETE != RETURN TO SERVICE AUTHORIZED`.

Proof-test intervals and required injected faults remain architecture/application specific. Do not copy Rockwell example intervals or fault sets into OpenPressBrake.

## Compute

No executable verification was justified. No GitHub-hosted runner was used. No self-hosted compute was needed.

## Exact next work

Apply the four-class matrix to one complete manufacturer/OEM return-to-service procedure after a safety-related change. Prefer a procedure that traverses multiple evidence classes and ends with explicit safeguard restoration/requalification and production reauthorization. If no such integrated source is available, rotate to another high-value safety branch rather than synthesizing an OEM procedure.

Before continuation, re-read current main and Lane B so concurrent work is not duplicated.
