# Safety input distinct-test-source to final-element trace

Date: 2026-09-19
Lane: B — independent safety input / field wiring diagnostics

## Question

What can a professional implementation actually prove from two physical safety contacts through field-wiring diagnostics, discrepancy handling, deliberate recovery, and final-element monitoring—and what remains unproved about the physical hazard?

## Evidence chain

### 1. Two channels need independent diagnostic stimulus where cross-channel detection is claimed

**DOC-CONFIRMED — Rockwell GuardLogix ESTOP example.** Rockwell's current ESTOP instruction documentation gives a two-channel E-stop wiring/programming example and assigns IN0 to pulse-test source T0 and IN1 to pulse-test source T1. The documentation explicitly describes the inputs as independently pulse tested for the shown Category 4 example.

Source: Rockwell Automation, Studio 5000 Logix Designer, `Emergency Stop (ESTOP)` instruction documentation, accessed 2026-09-19.

**DOC-CONFIRMED — Rockwell PointMax safety I/O.** A pulse-test output associated with a safety input diagnoses field wiring/input circuitry and can detect shorts between an input and positive supply and between signal lines. Rockwell explicitly states that a short between two input channels cannot be detected when those channels use the same test output.

Source: Rockwell Automation, PointMax Safety I/O, `Safety Input Modules in CIP Safety Systems`, accessed 2026-09-19.

**Frozen distinction:**

`TWO CHANNELS != TWO INDEPENDENT DIAGNOSTIC STIMULI != CROSS-CHANNEL FAULT DETECTABLE`.

A design that accidentally assigns both channels to one test source can preserve two logical input bits while losing a specific cross-short diagnostic. Channel count alone therefore cannot be used as evidence of the claimed diagnostic coverage.

### 2. Input agreement and discrepancy diagnosis are separate from pulse-test wiring health

**DOC-CONFIRMED — GuardLogix input operation.** Rockwell distinguishes module-level dual-channel discrepancy checking from controller safety-instruction discrepancy checking. It warns that when inputs are configured as a dual point type and also monitored by dual-channel safety instructions, the instruction cannot itself detect discrepancy faults; the choice changes where diagnostic information exists.

Source: Rockwell Automation, GuardLogix 5580 safety reference, `Input Operation`, accessed 2026-09-19.

**DOC-CONFIRMED — POINT Guard I/O.** The 1734 safety-I/O manual documents equivalent/complementary pair discrepancy timing. A discrepancy-time value of 0 ms does not declare a discrepancy fault indefinitely, although a cycle-inputs-required condition can still force evaluated status safe. It also warns that module discrepancy configuration masks discrepancies that controller safety instructions would otherwise diagnose.

Source: Rockwell Automation publication 1734-UM013R-EN-P, February 2024.

**Frozen distinction:**

`PULSE TEST HEALTHY != CHANNELS AGREE != DISCREPANCY DIAGNOSTIC LOCATED/ENABLED CORRECTLY`.

Commissioning must verify not only that a disagreement removes safety authority, but also that the intended diagnostic layer actually reports/latches the fault rather than silently moving that responsibility elsewhere.

### 3. Fault recovery is not the same as reset/rearm

**DOC-CONFIRMED — ControlLogix safety I/O fault latching.** Rockwell documents a `ResetFault` behavior in which a latched safety-input fault is released on a rising edge only after the underlying fault has been removed.

Source: Rockwell Automation publication 1756-UM013B-EN-P, October 2019.

**DOC-CONFIRMED — GuardLogix ESTOP.** The ESTOP instruction only permits its safety output when both channels satisfy the required state and the required reset action is completed. Rockwell's automatic-reset warning separately requires measures against unexpected/unintended startup.

**Frozen distinctions:**

`FAULT CONDITION REMOVED != FAULT LATCH CLEARED != SAFETY FUNCTION RESET/REARMED != ORDINARY MACHINE START`.

A maintenance action that repairs a cable or restores two matching inputs must not be allowed to turn a stale LinuxCNC START/JOG/ENABLE request into fresh hazardous-motion intent.

### 4. Safety output authority must be followed into the final elements

**DOC-CONFIRMED — Rockwell Safety Accelerator Toolkit.** Rockwell's safety output example uses redundant safety contactors with auxiliary feedback/EDM and separate safety outputs. The feedback exists to diagnose whether the commanded contactor state was achieved; it is not merely another copy of the output command.

Source: Rockwell Automation `Safety Accelerator Toolkit Quick Start`, IASIMP-QS005.

**DOC-CONFIRMED — Rockwell enabling-switch application.** SAFETY-AT055 shows an implementation in which an input is dedicated to the contactor monitoring circuit while separate safety outputs drive the contactor coils. This is concrete separation of command and feedback.

Source: Rockwell Automation SAFETY-AT055D-EN-P.

**Frozen distinction:**

`SAFETY LOGIC OUTPUT OFF != CONTACTOR COIL COMMAND OFF != CONTACTOR AUXILIARY/EDM PROVES OPEN != PHYSICAL HAZARD ABSENT`.

EDM proves the monitored switching proposition. It does not prove a ram stopped, hydraulic pressure dissipated, a gravity load retained, a spindle stopped, or another downstream physical hazard absent. A machine-specific physical witness is still required wherever the safety function depends on that proposition.

## Complete commissioning challenge

A commissioning exercise for a machine using two contact channels should trace and deliberately challenge this chain:

`physical contact A/B -> distinct test source A/B -> safety inputs -> field-wire pulse-test status -> channel agreement/discrepancy diagnosis -> latched fault handling -> deliberate safety reset/rearm -> safety outputs -> redundant final elements -> EDM/final-element feedback -> machine-specific physical hazard witness -> separate fresh ordinary START`.

Inject at least these conditions where the hardware supports safe testing:

1. open each channel independently;
2. short each input toward the relevant supply condition covered by the module diagnostics;
3. cross-short the two signal channels and prove that distinct test-source assignment detects the fault;
4. deliberately review the configuration counterfactual in which both channels share one test source and record that Rockwell says that cross-short can then be undetectable;
5. create channel discrepancy and verify where the fault is diagnosed (module or safety instruction);
6. repair the field fault but withhold fault reset/rearm;
7. clear the fault latch but withhold ordinary production START;
8. demand the safe output and independently challenge final-element feedback/EDM;
9. verify the actual machine-specific physical hazard witness separately from EDM;
10. hold/stage an ordinary LinuxCNC motion request across the safety recovery and verify that restored safety authority does not reinterpret it as fresh start intent.

Do not inject faults on an exposed hazardous machine. Where a minimum safe-to-operate condition cannot be established, testing must be isolated/remote with personnel outside the danger zone.

## OpenPressBrake boundary

**INFERENCE:** OpenPressBrake should use this as an architectural validation pattern, not as a copied safety rating. LinuxCNC and the normal FPGA may consume safety status for diagnostics and inhibit ordinary commands, but personnel-safety authority, safety-input diagnostic decisions, and safety final-element authority must remain independent where required by the machine risk assessment.

**UNKNOWN:** The exact OpenPressBrake safety input module, test-pulse timing, discrepancy time, diagnostic coverage, PL/SIL, hydraulic final-element topology, physical witness, stop time, and reset/rearm implementation remain machine/design-specific and must not be invented from the Rockwell examples.

## Result

The evidence closes the Lane-B gap that previously stopped at generic test-pulse behavior. There is now a professional trace spanning distinct diagnostic stimulus, field-wiring fault detection, discrepancy-location semantics, latched fault recovery, reset separation, safety outputs, and EDM/final-element feedback. The remaining gap is the machine-specific last meter: an implementation that joins this exact input-diagnostic chain to a direct physical hazard witness and proves the no-stale-start recovery behavior end to end.

No executable lab was justified. This question is answered more directly by authoritative manufacturer documentation than by simulation; no hosted or self-hosted compute was used.
