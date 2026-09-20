# SINAMICS Safe Brake Test — Unmasked Gravity-Axis Physical Proof Sequence

Date: 2026-09-20

## Purpose

Close the current 4000 safety-course checkpoint with a complete manufacturer sequence that distinguishes drive safety command/status from physical gravity-axis retention proof.

## Evidence classification

- **DOC-CONFIRMED:** Siemens SINAMICS S120 Safety Integrated Function Manual, 06/2020, 6SL3097-5AR00-0BP3.
- **DOC-CONFIRMED:** Siemens D 21.3, January 2026, Safety Integrated function overview.
- **INFERENCE:** curriculum architecture conclusions explicitly marked below.
- **UNKNOWN:** OpenPressBrake-specific brake topology, required test torque, permitted position deviation, test interval, PL/SIL target, and whether a future OpenPressBrake axis needs one or two brakes.

## Manufacturer physical sequence

Siemens separates Safe Brake Control (SBC) from Safe Brake Test (SBT). SBC safely controls a de-energize-to-engage holding brake and is used with STO/SS1 to prevent gravity-driven motion after torque removal. Siemens explicitly warns that SBC does not detect mechanical brake faults such as worn linings. SBT is the separate diagnostic that applies torque to the closed brake and uses encoder-observed axis motion against a parameterized tolerance to determine whether the brake still provides the required holding torque.

The S120 sequence is especially useful because it exposes the masking control:

1. SBT is selected with pulses enabled and the brake(s) initially open; speed must be within the documented selection limits.
2. The drive determines the static suspended load while all brakes are open.
3. The test selects a specific brake, torque direction, and one of two parameterized test sequences. Each sequence has a test torque, duration, and permitted positional deviation.
4. Starting the test causes the selected motor brake to close, or requests closure of an external brake. Failure to reach the expected external-brake state within the manufacturer's 11 s window aborts with a fault.
5. With speed command zero, the controller ramps a defined torque against the closed selected brake.
6. The encoder supplies the physical axis-motion witness. Motion beyond the configured tolerance means the brake cannot provide the specified holding torque and must be serviced/replaced.
7. Critically, when one brake is being tested, the other brake must remain **open**. A healthy companion brake therefore cannot silently mask a weak tested brake.
8. The test can be interrupted; Siemens generates alarm A01782. Exiting SBT has an ordered deselection sequence and explicitly must not be collapsed into simultaneous STO/pulse-enable withdrawal.
9. Only after SBT is deselected does the original speed setpoint take effect again.

## What this closes

This is a complete professional gravity-axis witness chain:

**BRAKE TEST SELECTED -> STATIC SUSPENDED LOAD ESTABLISHED -> ONE BRAKE SELECTED -> COMPANION BRAKE HELD OPEN -> SELECTED BRAKE CLOSED/CONFIRMED -> DEFINED TEST TORQUE APPLIED -> ENCODER MOTION PHYSICALLY WITNESSED -> POSITION TOLERANCE PASS/FAIL -> ORDERED TEST EXIT -> ORDINARY SETPOINT RESTORED**

It proves why a brake-command or brake-feedback bit is not sufficient evidence of load retention.

## Durable freezes

**STO ACTIVE != GRAVITY LOAD RETAINED.**

**SBC COMMAND VALID != BRAKE MECHANICS HEALTHY.**

**BRAKE CLOSED FEEDBACK != REQUIRED HOLDING TORQUE PROVED.**

**BRAKE TEST REQUEST != TEST TORQUE APPLIED != LOAD PHYSICALLY RETAINED != TEST PASS.**

**TWO BRAKES PRESENT != EACH BRAKE INDIVIDUALLY PROVED.**

**BOTH BRAKES CLOSED DURING TEST != INDIVIDUAL BRAKE PROOF.** A companion retaining path can mask the brake under test; Siemens' SBT deliberately keeps the non-tested brake open during the active sequence.

**TEST ABORTED != TEST PASSED != PRODUCTION AUTHORITY.**

**BRAKE PERFORMANCE PASS != ELECTRICAL ENERGY ISOLATED.** SBT is an energized functional test, not lockout/tagout or maintenance isolation.

## OpenPressBrake/LinuxCNC boundary

A future OpenPressBrake gravity-axis implementation must not let ordinary LinuxCNC or the normal FPGA infer personnel safety from `STO`, `brake_command`, or `brake_feedback` alone. Those are useful diagnostic witnesses. If brake retention is safety-relevant, the safety architecture needs a validated physical performance proof appropriate to the actual axis and brake system.

The normal controller may request a test, display progress, record results, or inhibit ordinary production after a safety-system failure indication, but it must not become the sole personnel-safety authority merely for convenience.

Do not copy Siemens' numerical limits into OpenPressBrake. Test torque, duration, allowable movement, test interval, number of brakes, required category/PL/SIL, load state, and safe test geometry are design-specific and remain UNKNOWN until the actual machine architecture is established.

## Human-factors consequence

Make periodic brake proof easy and visible. A safety design that technically requires brake testing but makes the procedure obscure, slow, or dependent on hidden service knowledge invites skipped tests. The correct test should be easier than bypassing it, and a failed/aborted test should leave an unmistakable non-production state until the defined recovery/requalification is completed.

## Source provenance

1. Siemens, *SINAMICS S120 Safety Integrated Function Manual*, 06/2020, 6SL3097-5AR00-0BP3, Safe Brake Test section pp. 144-152 (PDF pages approximately 146-154). Key manufacturer facts: SBT applies configurable torque; encoder motion is compared with positional tolerance; brake close/open requests are supervised; non-tested brake remains open; ordered cancellation/deselection behavior.
2. Siemens, *Motion Control Drives D 21.3*, January 2026, Safety Integrated overview. Key distinction: SBC safely controls the brake but does not detect mechanical faults; SBT tests brake effectiveness by applying torque to the closed brake.

## Next evidence target

Do not continue generic STO/brake status-bit cataloging. Next seek a complete **hydraulic final-element** physical sequence with monitored valve position plus independent pressure and/or ram-motion witness, including command/status mismatch, timeout/fault disposition, restart inhibition, and a separate physical performance criterion. If that source path stalls, rotate to the accessible-cell presence-sensing commissioning lane already identified in PROGRESS.md.
