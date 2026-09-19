# Dual-brake unmasked load proof and recovery trace

Date: 2026-09-19

## Question

Can a professional gravity-axis implementation prove each retaining brake mechanically rather than merely prove Safe Brake Control electrical switching, and what authority boundaries remain around failed-test recovery?

## Evidence

### DOC-CONFIRMED — SEW-EURODRIVE MOVISAFE CS..A, edition 05/2026

SEW assigns a brake under test to a safe digital output configured for SBC. When two brakes are configured, both safe outputs are assigned SBC, but the safe brake test does **not** collapse them into one combined test: F-DO00's brake is tested first, and only after that test succeeds is F-DO01's brake tested.

SEW's passive brake-test step is particularly important for the physical-proof boundary. The drive enters STO so the motor cannot generate supporting torque; the brake under test is loaded only by the machine's existing load torque and machine movement is monitored. With two brakes, SEW explicitly releases the companion brake while testing the selected brake, then reverses the arrangement for the second test.

This is direct professional evidence for an **unmasked individual retaining-function proof**: the healthy companion brake is intentionally prevented from hiding failure of the brake under test.

SEW also states that a safety encoder is required when the brake-test evaluation itself is used in a safety-related system. Therefore the motion witness is part of the proof architecture, not merely an ordinary diagnostic display.

### DOC-CONFIRMED — start inhibit / recovery authority

SEW's safety option has a distinct start-inhibit state. It activates STO and prevents automatic startup. Documented causes include parameterization during an active brake test, restoration of a parameter set after device replacement, and active safety/EDM-related faults. Clearing start inhibit requires a defined fault acknowledgement or power cycle depending on cause.

This supports a strict separation between `test/replacement activity` and `automatic motion authority`. It does **not** by itself prove an application-specific ordinary START sequence after every mechanical brake failure or replacement.

### DOC-CONFIRMED — Siemens cross-check

Siemens explicitly states that Safe Brake Control does not detect a mechanically worn or defective brake and directs the designer to Safe Brake Test for that defect class. Siemens SBT documentation also requires the brake not under test to remain open when testing another brake. This independently corroborates the electrical-control-versus-mechanical-proof boundary and the need to prevent companion-brake masking.

## Frozen authority chain

`SBC COMMAND/OUTPUT STATE != BRAKE MECHANICALLY APPLIED != BRAKE HOLDS MACHINE LOAD != MOTION WITNESS VALID != INDIVIDUAL BRAKE TEST PASS != ALL REQUIRED BRAKES TESTED/PASSED != START INHIBIT CLEARED != APPLICATION MOTION AUTHORITY`

For two credited retaining brakes:

`BRAKE A PASS + BRAKE B UNTESTED/FAIL/UNKNOWN != DUAL-BRAKE PROOF COMPLETE`

and

`BRAKE A TEST WITH BRAKE B STILL HOLDING != UNMASKED BRAKE A RETENTION PROOF`

A professional unmasked proof intentionally removes the companion brake's retaining contribution while the selected brake is loaded and actual movement is observed.

## Failure/recovery reasoning

If the first of two sequential tests fails, the evidence does not justify continuing to the second as though the retaining system were valid; SEW's documented sequence advances to brake 2 only after brake 1 succeeds. A failed required brake proof therefore leaves the required multi-brake proof incomplete.

Do not infer degraded production permission from the surviving brake. The documents studied here do not grant that authority.

Do not equate fault acknowledgement with repair. Acknowledgement/start-inhibit clearing changes controller state; it does not establish that a mechanically defective brake was repaired or that its retaining capacity has been re-proved.

## Human-factors implication

A commissioning/service UI should make the safe sequence easier than bypassing it: identify which brake is being tested, automatically release the companion only inside the controlled test sequence, expose the motion-witness result, latch failed/incomplete proof, and prevent ordinary automatic startup until the required proof set is complete. Ordinary LinuxCNC/HAL/FPGA control may display this state but should not manufacture personnel-safety authority from it.

## Explicit UNKNOWNs

- Whether the exact machine application requires a brake test automatically after mechanical brake replacement; the generic evidence here is insufficient to claim that universally.
- The required test torque, allowed movement, interval, PL/SIL/category/DC, and service sequence for OpenPressBrake or any other specific machine.
- Whether a previously passed companion brake must be re-tested after servicing the failed brake. This depends on the validated machine/service procedure and remains UNKNOWN without direct evidence.
- Application-specific ordinary restart/rearm steps after successful repair and re-test.

## Curriculum consequence

This closes the generic **individual retaining-element masking** question for a professional electromechanical gravity-axis architecture: unmasked physical proof is demonstrably implemented by releasing the companion brake, removing motor torque with STO, applying existing load torque to the selected brake, and monitoring motion.

It does **not** transfer this topology to hydraulic press brakes. Instead it provides a comparison standard for the unresolved hydraulic question: a claimed individual hydraulic retaining-valve proof must likewise demonstrate that another retaining element cannot silently carry the load while the element under test fails.

## Sources

- SEW-EURODRIVE MOVISAFE CS..A / MOVIDRIVE technology documentation, edition 05/2026: safe brake test start, F-DO assignment, passive brake test, encoder/safety encoder, start inhibit.
- Siemens SINAMICS Safety Integrated / Safe Brake Control documentation: SBC mechanical-defect limitation and Safe Brake Test behavior.
