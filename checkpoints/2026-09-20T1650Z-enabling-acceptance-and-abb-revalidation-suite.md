# Checkpoint — enabling-device acceptance and post-replacement safety revalidation

Date: 2026-09-20

## Durable work

- `safety-course/ABB_KUKA_ENABLING_DEVICE_FUNCTION_TEST_AND_ANTI_DEFEAT_ACCEPTANCE_TRACE_2026-09-20.md`
- `safety-course/ABB_POST_REPLACEMENT_SAFETY_FUNCTION_SUITE_AND_PHYSICAL_REDUCED_SPEED_REVALIDATION_2026-09-20.md`
- `safety-course/SIEMENS_SAFETY_HARDWARE_REPLACEMENT_COMPLETE_ACCEPTANCE_AND_PHYSICAL_AXIS_MAPPING_TRACE_2026-09-20.md`

## Result

The narrow all-in-one enabling-device acceptance search remains source-limited, but ABB materially strengthened the evidence: its IRC5 maintenance manual contains an explicit three-position enabling-device function test with defined PASS/FAIL observations for center and full-squeeze states. Rockwell independently documents no safety-contact reclosure on 3->2 return for its GripSwitch implementation, and KUKA requires physical visual inspection for tape/foreign-body manipulation. Freeze: **FUNCTIONAL LOGIC TEST PASSED != DEVICE PHYSICALLY FREE OF DEFEAT**, and exact re-entry semantics remain implementation-specific.

The session then rotated rather than stopping. ABB's current maintenance lifecycle requires safety function tests after controller-component replacement. The suite separately exercises mode selection, enabling device, motor contactors, brake contactor, stop functions and reduced-speed control. Reduced speed is physically measured over known distance/time rather than accepted from configuration alone. Freeze: **COMPONENT REPLACED != CONFIGURATION RESTORED != SAFETY FUNCTIONS REVALIDATED != PRODUCTION AUTHORITY** and **REDUCED-SPEED MODE SELECTED != REDUCED SPEED PHYSICALLY PROVED**.

Siemens Safety Integrated adds a stronger replacement-specific acceptance layer: new safety hardware generates a `confirmation and functional test required` condition; acknowledgement requires commitment to complete function testing, and replacement acceptance includes encoder/actual-value checks, checksum/version documentation and deliberate bidirectional physical axis motion to verify safety-relevant actual-value sensing. A warm restart is only an intermediate event. Freeze: **NEW HARDWARE ACKNOWLEDGED != FUNCTION TEST COMPLETE != ACCEPTANCE REPORT COMPLETE != PRODUCTION AUTHORITY**, **CHECKSUM RECORDED != PHYSICAL AXIS MAPPING PROVED**, and **WARM START SUCCEEDED != SAFETY FUNCTION REVALIDATED**.

## Precise next work

The replacement branch now has strong configuration + physical mapping + function-test evidence. The remaining narrow gap is an OEM/manufacturer acceptance record that explicitly carries accepted safety functions through **reset/rearm -> stale-command rejection -> fresh ordinary production START**. Search for that only while it has plausible information gain; do not duplicate Lane B's networked safety-I/O identity/configuration work.

The original all-in-one enabling-device target should only be reopened for genuinely stronger evidence covering held jog/inch, release, full squeeze, 3->2 recovery, setup exit, ordinary safeguard restoration and fresh production start in one manufacturer acceptance procedure.

If both narrow targets remain source-limited, rotate to another high-value safety module rather than manufacturing a synthetic OEM sequence.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
