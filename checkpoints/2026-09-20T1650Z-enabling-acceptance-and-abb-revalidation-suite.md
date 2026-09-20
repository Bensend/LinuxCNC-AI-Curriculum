# Checkpoint — enabling-device acceptance and ABB post-replacement revalidation suite

Date: 2026-09-20

## Durable work

- `safety-course/ABB_KUKA_ENABLING_DEVICE_FUNCTION_TEST_AND_ANTI_DEFEAT_ACCEPTANCE_TRACE_2026-09-20.md`
- `safety-course/ABB_POST_REPLACEMENT_SAFETY_FUNCTION_SUITE_AND_PHYSICAL_REDUCED_SPEED_REVALIDATION_2026-09-20.md`

## Result

The narrow all-in-one enabling-device acceptance search remains source-limited, but ABB materially strengthened the evidence: its IRC5 maintenance manual contains an explicit three-position enabling-device function test with defined PASS/FAIL observations for center and full-squeeze states. Rockwell independently documents no safety-contact reclosure on 3->2 return for its GripSwitch implementation, and KUKA requires physical visual inspection for tape/foreign-body manipulation. Freeze: **FUNCTIONAL LOGIC TEST PASSED != DEVICE PHYSICALLY FREE OF DEFEAT**, and exact re-entry semantics remain implementation-specific.

The session then rotated rather than stopping. ABB's current maintenance lifecycle requires safety function tests after controller-component replacement. The suite separately exercises mode selection, enabling device, motor contactors, brake contactor, stop functions and reduced-speed control. Reduced speed is physically measured over known distance/time rather than accepted from configuration alone. Freeze: **COMPONENT REPLACED != CONFIGURATION RESTORED != SAFETY FUNCTIONS REVALIDATED != PRODUCTION AUTHORITY** and **REDUCED-SPEED MODE SELECTED != REDUCED SPEED PHYSICALLY PROVED**.

## Precise next work

Seek an OEM/manufacturer replacement acceptance record that explicitly connects a safety-related replacement to **deliberate field input challenge -> actual external final-element response -> reset/rearm -> fresh production start**. Avoid duplicating Lane B's current networked safety-I/O identity/configuration work. If bounded search produces only generic function-test language, checkpoint the source limit and rotate to another high-value safety branch.

The original all-in-one enabling-device target should only be reopened for genuinely stronger evidence covering held jog/inch, release, full squeeze, 3->2 recovery, setup exit, ordinary safeguard restoration and fresh production start in one manufacturer acceptance procedure.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
