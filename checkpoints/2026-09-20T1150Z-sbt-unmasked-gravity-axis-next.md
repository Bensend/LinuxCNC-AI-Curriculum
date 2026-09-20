# 4000 safety checkpoint — unmasked gravity-axis brake proof complete

UTC: 2026-09-20T11:50Z

## Completed

Added `safety-course/SINAMICS_SAFE_BRAKE_TEST_UNMASKED_GRAVITY_AXIS_PHYSICAL_PROOF_SEQUENCE_2026-09-20.md`.

Manufacturer evidence now closes the requested complete drive/gravity-axis sequence: Siemens SBT selects a specific brake, establishes suspended load, closes the selected brake, deliberately leaves the companion brake open, applies defined torque, observes encoder motion against a positional tolerance, faults on expected-state timeout, and uses an ordered test exit before ordinary setpoint authority returns.

Key freeze: **STO active != SBC command valid != brake mechanically healthy != required holding torque physically proved.**

## Exact next work

1. Primary: seek a complete hydraulic final-element physical sequence with monitored valve/spool position plus independent pressure and/or ram-motion witness, including mismatch timeout/fault, restart inhibition/requalification, and what separate physical performance test remains necessary.
2. Do not spend a session cataloging more STO/brake status bits; that branch is now information-gain limited unless a materially different physical proof appears.
3. If the hydraulic source path stalls, rotate immediately to the accessible-cell presence-sensing commissioning/validation lane in PROGRESS.md: geometry/blind area, deliberate stand-behind occupancy, reset visibility/location, stale-command challenge, final-element response, fresh restart.
4. Preserve OpenPressBrake-specific brake torque, tolerance, interval, topology and required PL/SIL as UNKNOWN until machine-specific engineering establishes them.
5. No compute is currently justified. If a later question genuinely requires runtime, use only `[self-hosted, openpressbrake]`; never GitHub-hosted runners.
