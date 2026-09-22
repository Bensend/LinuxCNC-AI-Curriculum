# Safety Verification / Validation Matrix

Use one row per requirement/proposition/fault claim. Never fill an unavailable physical result with an assumption.

| ID | HZ | PROP | SF | FLT/ARCH | Requirement / acceptance source | Activity type | Test / analysis | Expected result | Evidence needed | Physical/human required? | Result | Evidence class | Finding / revalidation trigger |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| V-001 |  |  |  |  |  | DESIGN-VERIFY / FUNCTION-VALIDATE / FAULT-VALIDATE / PHYSICAL-PROOF / RECOVERY-VALIDATE / CHANGE-REVALIDATE |  |  |  | YES/NO | NOT-RUN / PASS / FAIL / UNKNOWN | SOURCE / DOC / TEST / COMMUNITY / INFERENCE / UNKNOWN |  |

## Rules

1. Trace every row backward to a requirement and forward to evidence.
2. Separate design verification from integrated application validation.
3. A calculation/tool report can support the row it actually addresses; it cannot substitute for unrelated physical proof.
4. State the acceptance source before the test. Do not choose a limit after seeing the result.
5. If stopping time, distance, pressure, force, load holding, geometry, exhaust state, or another physical criterion is machine-specific and not established, mark it `UNKNOWN`.
6. For fault tests, identify the fault hypothesis and required detection/reaction timing. Do not claim generic diagnostic coverage from one injected fault.
7. For recovery tests, include retained/held ordinary demands and asymmetric power/network recovery where applicable.
8. For maintenance/change, identify which prior evidence becomes stale and why.
9. Record configuration/revision identity with the evidence package.
10. Temporary commissioning bypasses/test measures must be separately tracked and proven removed before exposed operation.

## Suggested row families

- SRS/design trace and review
- safety-input behavior and discrepancy/fault behavior
- safety logic/configuration
- output/final-element behavior and monitoring
- physical safe-state measurement/proof
- common-cause/dependency loss
- normal startup/shutdown
- abnormal fault mode
- reset/rearm/fresh start
- power/network/reintegration recovery
- mode transition/setup/enabling
- simultaneous safety-function demand
- maintenance/change revalidation
- temporary commissioning measure removal
