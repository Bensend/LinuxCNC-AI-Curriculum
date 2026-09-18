# 4000 Safety Course — Gravity-Axis Brake-Proof Failure and Recovery Card

Session start UTC: 2026-09-18T07:35:24Z

## Purpose

Extend the existing SBC/SBT gravity-axis trace from proof testing into the failure/recovery boundary. This card is intentionally generic: it does **not** assign an OpenPressBrake brake topology, holding torque, test interval, motion tolerance, PL/SIL/category, or hydraulic truth table.

## Evidence classifications

### DOC-CONFIRMED — Siemens SBT detects inadequate holding capability from actual motion

Siemens SINAMICS S120 Safety Integrated documentation describes Safe Brake Test (SBT) as deliberately generating configurable torque against an applied brake and observing encoder actual values. If axis movement exceeds the parameterized tolerance, the brake is not considered capable of the specified holding torque and must be serviced or replaced.

Source: Siemens, *SINAMICS S120 Safety Integrated Function Manual*, 06/2020, section 5.2.12 Safe Brake Test (SBT), document 6SL3097-5AR00-0BP3.

### DOC-CONFIRMED — SBT fault recovery requires cause removal and safe acknowledgement

Siemens SINAMICS S210 operating documentation exposes SBT failure/status causes including actual axis speed being too high because a brake does not hold during the brake test. The documented remedy is to remove the fault cause, carry out a safe acknowledgement, and, where required, restart the brake test.

Source: Siemens, *SINAMICS S210 servo drive system Operating Instructions*, 12/2017, A5E41702836A AB, SBT diagnostic/fault entries.

### DOC-CONFIRMED — brake test is distinct from safe brake control

Siemens documentation treats SBT as a diagnostic test of holding torque; Safe Brake Control (SBC) is the function that safely controls a brake. Pilz independently describes SBC as safe control of an external spring-applied brake and notes that a safe brake test may be required to detect errors during operation, especially for gravity-loaded axes.

Sources: Siemens S120 Safety Integrated Function Manual above; Pilz, “Brake control,” current manufacturer technical documentation.

### DOC-CONFIRMED — detected safety-function faults require a defined reaction

Pilz's summary of EN/IEC 61800-5-2 states that identified faults or limit-value violations require defined reaction functions; in multi-axis systems the axis may report the violation while a higher-level safety controller coordinates stopping of the whole axis system.

Source: Pilz, “Requirement for functional safety (EN / IEC 61800-5-2).”

## Frozen evidence chain

**BRAKE COMMAND != BRAKE ENGAGEMENT != HOLDING CAPACITY PROVED != LOAD RETAINED.**

After a failed proof test:

**FAULT DETECTED != HAZARD PHYSICALLY CONTROLLED != FAULT CAUSE REMOVED != SAFE ACKNOWLEDGEMENT != PROOF RESTORED != SAFETY AUTHORITY RESTORED != FRESH ORDINARY START.**

A reset/acknowledgement is therefore not a repair, not proof that the brake has regained holding capacity, and not an ordinary motion command.

## Failure-to-recovery state model

1. **Proof challenge active** — the safety/drive system applies the defined brake test and observes the required witness.
2. **Proof failed** — movement or another documented SBT failure criterion invalidates the holding-capability claim.
3. **Hazard controlled** — the machine must reach a risk-assessed physical disposition that does not depend on the failed retaining element alone.
4. **Cause corrected** — repair/replacement/adjustment is completed as appropriate to the actual failure.
5. **Safe acknowledgement** — acknowledgement may clear the diagnostic latch only after prerequisites are satisfied; it does not itself establish holding capacity.
6. **Proof re-established** — where the machine's validated design requires it, the relevant proof/test must succeed before that retaining function is relied upon again.
7. **Safety authority eligible** — independent safety logic may again permit the normal controller to request operation.
8. **Fresh ordinary START** — LinuxCNC/HAL/FPGA must not convert a stale maintained motion/jog/enable request into motion merely because safety authority returned.

Steps 3, 6 and 7 are **design-specific** in a real machine. The cited Siemens material establishes the failed-brake diagnostic and safe-acknowledgement boundary but does not, by itself, define the physical safe disposition for every gravity axis.

## Two-retaining-element disagreement rule

If a vertical axis has two retaining elements, a passing element A does not erase failed/unknown evidence for element B when the risk assessment relies on both.

**A PROVED + B FAILED/UNKNOWN != TWO-ELEMENT RETENTION PROVED.**

Likewise, two command outputs are not necessarily independent retaining elements. Independence/common-cause claims require evidence about power, wiring, mechanics, control paths, diagnostics, mounting and failure modes.

## Mechanical + hydraulic disagreement rule

For a machine combining a mechanical brake with hydraulic load holding, neither witness substitutes for the other:

- brake proof does not prove hydraulic pressure absent or valves in their safe positions;
- valve-position feedback does not prove a mechanical brake's holding capacity;
- zero motor torque does not prove either retaining mechanism;
- a stationary load at one instant does not prove which mechanism is retaining it.

If continued personnel exposure depends on both paths, contradictory or missing evidence prevents the combined safe claim.

## Commissioning/adversarial challenges

1. Force the brake-test witness to indicate excessive motion. Verify hazardous automatic operation remains inhibited according to the validated safety design.
2. Attempt ordinary RESET/START while the brake fault remains. A normal-control command must not defeat the safety inhibit.
3. Remove the fault indication without restoring physical brake capability. Verify acknowledgement alone cannot become proof of holding capacity.
4. On a two-brake design, fail one brake while the other passes. Verify diagnostics and the machine-level safe claim follow the validated architecture rather than accepting “one good brake” by assumption.
5. On a mechanical-plus-hydraulic design, create disagreement between brake proof and hydraulic valve/pressure evidence. Verify the HMI preserves the disagreement instead of collapsing both into a generic SAFE bit.
6. Restore safety authority while an ordinary LinuxCNC jog/start/enable request is intentionally held TRUE. Verify a fresh ordinary start edge/action is required where the machine design calls for deliberate restart.
7. Remove normal controller communications during fault recovery. Verify the independent safety system does not need LinuxCNC to preserve the failed-proof inhibit.
8. Challenge loss of the encoder/proof witness itself. Missing proof evidence must not be silently interpreted as a passing brake.

## Minimum-safe-to-operate gate

If a gravity-loaded axis can fall into an occupied hazard zone and the retaining function required by the risk assessment has failed its proof test, or required proof is unavailable, **do not operate with people exposed to that hazard** until the failed function is corrected and the validated return-to-service evidence is re-established. Experimental movement needed for diagnosis must use an appropriately isolated/remote condition with people outside the danger zone and residual stored/gravity energy controlled.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC, HAL and the ordinary FPGA may display brake-test state, inhibit ordinary commands, record diagnostics and participate in normal restart sequencing. They are not thereby the personnel-safety authority. The safety-related brake control, proof evaluation, fault latch and physical retaining architecture must remain independent where required by the machine's safety design.

OpenPressBrake-specific brake hardware, hydraulic retaining elements, proof method, witnesses and return-to-service sequence remain **UNKNOWN** until the actual machine architecture is traced and validated.

## Next evidence target

Find one inspectable professional machine implementation that exposes a failed mechanical or hydraulic retaining-element proof through: **safety latch/inhibit -> physical load-safe disposition -> repair/reset prerequisites -> re-proof -> safety re-enable -> separate ordinary START**. Prefer a machine with two genuinely distinct retaining elements so disagreement and common-cause behavior can be traced without composing unrelated vendor examples.
