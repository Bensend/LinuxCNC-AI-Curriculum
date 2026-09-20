# Safety-input multi-fault safe-output and restart disposition study

Date: 2026-09-20

## Question

Can current manufacturer documentation close the Lane-B checkpoint with more than a single deliberate short: multiple field-fault classes, explicit safe-output behavior, and explicit reset/restart disposition?

## Evidence

### Rockwell SMAT safety instruction — DOC-CONFIRMED

Current Rockwell Studio 5000 safety-instruction documentation for the Safety Mat (SMAT) instruction provides a concrete fault table and timing behavior. Documented fault classes include Channel A shorted to power; Channel B shorted to power; both channels shorted to power; combinations of one channel shorted to power while the other is shorted to ground/open; and individual channel short-to-ground/open conditions.

For an open-circuit example, Rockwell documents that Output 1 de-energizes when the circuit opens, the diagnostic delay runs, a fault is generated, the wiring fault is corrected, and an OFF-to-ON Reset transition resets the fault. The instruction then completes its CVT test and requires the reset/start condition before Output 1 energizes under the documented manual-restart example.

A Channel-A-to-Channel-B short is interpreted as the safety mat occupied and Output 1 is de-energized.

Evidence class: DOC-CONFIRMED. This is manufacturer instruction behavior, not physical OpenPressBrake validation.

### Rockwell DCS/DCST/RIN restart semantics — DOC-CONFIRMED

Rockwell's redundant/dual-channel safety instructions separately establish that a discrepancy/inconsistent-input fault prevents the safety output from becoming active while the fault is present. Clearing requires the offending condition to be corrected and a reset transition. For manual restart, output authorization is a separate event after valid channel state is restored.

The DCST instruction adds a functional-test requirement. With Manual Cold Start, Output 1 does not energize merely because input status becomes valid after controller power-up/mode transition or after an input-status fault clears: the safety device must first be tested. Manual restart then requires the configured reset transition while enabling conditions are valid.

Rockwell also cautions that automatic restart is only appropriate where unsafe conditions cannot result or reset is performed elsewhere in the safety circuit.

### Rockwell line-conditioning guidance — DOC-CONFIRMED

Rockwell states that safety I/O pulse-test/monitoring failures drive the offending point to its safe state and report the failure. It explicitly requires application logic to latch I/O failures and ensure proper restart behavior. The documented example resets a latched fault only after the fault is repaired and a reset edge occurs, preventing a stuck reset from silently producing automatic restart.

### SICK Flexi Soft hardware diagnostics — DOC-CONFIRMED

Current SICK Flexi Soft hardware documentation lists test-output/input faults including short to 24 V, cross-circuit wiring faults, cable breaks on pressure-sensitive mats, and defective testable sensors. Recovery requires correcting/replacing the faulty wiring/device and then driving the affected dual-channel input to its documented safe combination or resetting module voltage. This independently confirms that diagnostic recovery semantics depend on both fault removal and a defined recovery state/action rather than mere disappearance of a diagnostic bit.

## Durable conclusions

`FIELD FAULT DETECTED != FAULT SOURCE IDENTIFIED WITHOUT TOPOLOGY KNOWLEDGE`.

`FAULT DETECTED != ONLY A DIAGNOSTIC BIT CHANGED`; manufacturer examples explicitly drive/de-energize the safety output or affected I/O point to a safe state.

`FAULT PHYSICALLY REMOVED != FAULT LATCH CLEARED != REQUIRED DEVICE TEST/CYCLE COMPLETE != MANUAL RESET COMPLETE != OUTPUT REAUTHORIZED`.

`INPUT STATUS VALID AFTER COLD START/FAULT CLEAR != SAFETY DEVICE FUNCTIONALLY TESTED != OUTPUT AUTHORIZED`.

`RESET SIGNAL PRESENT != VALID RESET EDGE != FAULT REPAIRED != SAFE RESTART`.

The previous test-source-separation conclusion remains: two nominal channels do not prove cross-short diagnostic independence; topology and test-source assignment matter.

## Safety-course implication

A reusable safety-input commissioning matrix should enumerate at least: open circuit, short to supply, short to ground where applicable, cross-channel short, channel discrepancy, invalid I/O status/connection, reset held/stuck, cold-start restoration, and required device cycling/functional test. Each row must identify expected safe output state, diagnostic witness, correction, latch/reset behavior, and what separate action is required before hazardous motion can regain authority.

Do not translate these Rockwell/SICK behaviors into a claim that ordinary LinuxCNC HAL or the normal FPGA controller is safety-rated. LinuxCNC may display/log diagnostic state, but personnel-safety authority remains in the independent safety architecture and its physical final elements.

## Information-gain decision

The checkpoint's bounded target is satisfied: current manufacturer documentation provides multiple fault classes plus explicit safe-output and restart/recovery disposition. Further generic input-fault-table searching is now information-gain limited unless a new source adds materially different physical validation or failure masking evidence.

Rotate subsequent work to another high-value 4000 safety branch rather than manufacturing an executable lab for already documented instruction semantics.

## Sources

- Rockwell Automation, Studio 5000 Logix Designer, Safety Mat (SMAT), current online help (accessed 2026-09-20).
- Rockwell Automation, Studio 5000 Logix Designer, Dual-Channel Input Stop / Dual-Channel Input Stop with Test / Redundant Input, current online help (accessed 2026-09-20).
- Rockwell Automation, Studio 5000 Logix Designer, Input and Output Line Conditioning, current online help (accessed 2026-09-20).
- SICK, Flexi Soft Modular Safety Controller Hardware operating instructions, 8012478/1T57/2025-07-30.

## Compute

No executable lab was justified. No GitHub-hosted or self-hosted compute was used.
