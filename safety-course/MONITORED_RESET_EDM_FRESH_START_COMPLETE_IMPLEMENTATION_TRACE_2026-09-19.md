# Monitored reset + EDM + fresh ordinary START — complete implementation trace

Date: 2026-09-19

## Purpose

Close the Lane-B evidence gap between reset anti-tie-down, external final-element feedback, and ordinary process restart authority using a professional implementation rather than treating these as one Boolean permission.

## Evidence classification

### DOC-CONFIRMED — Rockwell Guardmaster E-stop string application

Rockwell `SAFETY-AT059` documents a complete E-stop safety function using a Guardmaster single-input safety relay and two 100S safety contactors.

The implementation establishes the following chain:

1. An E-stop demand interrupts both monitored channels.
2. The safety relay opens its safety contacts and de-energizes K1/K2; hazardous motion coasts to a stop (stop category 0 in this specific application).
3. N.C. auxiliary contacts from both safety contactors are placed in the reset path. A welded safety contact holds the corresponding N.C. auxiliary contact open and therefore prevents reset.
4. The relay is configured for monitored manual reset. Reset is accepted only when the E-stop inputs are restored, both contactors are properly de-energized, and the reset pushbutton is deliberately pressed and released.
5. The documented reset pulse must not be too short or held too long; the application specifically identifies this as preventing unintentional reset and reset-button tie-down.

Source: Rockwell Automation, `E-stop String Safety Function Application Technique`, publication SAFETY-AT059, current public copy retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at059_-en-p.pdf

### DOC-CONFIRMED — Rockwell CENTERLINE MCC implementation

Rockwell `MCC-AT007D-EN-P` provides the missing ordinary-start separation in a real motor-control implementation.

The safety controller monitors E-stop status and contactor feedback. After the safety circuit is reset, only the safety contactor is allowed to energize. Forward/reverse process contactors remain under ordinary application control. Rockwell explicitly requires the motor start command to drop when the safety circuit opens and remain off until the safety circuit has been reset **and a new start command is issued**. The same implementation uses N.C. auxiliary feedback in the safety reset path and individual N.O. auxiliary feedback for contactor diagnostics.

Source: Rockwell Automation, `CENTERLINE Low Voltage Motor Control Centers Functional Safety`, publication MCC-AT007D-EN-P, August 2023, current public copy retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/mcc-at007_-en-p.pdf

### DOC-CONFIRMED — controller instruction behavior

Current Rockwell ESTOP instruction documentation exposes `Circuit Reset Held On`: in manual-reset mode, if reset is already asserted when both safety channels become active, the held-on prompt is asserted and does not clear until reset is released. Faulted input inconsistency likewise blocks Output 1 until the offending condition is corrected and a fault-reset transition occurs.

Source: Rockwell Studio 5000 Logix Designer ESTOP instruction documentation, retrieved 2026-09-19: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/emergency-stop--estop-.html

## Frozen lesson

`PROTECTIVE CONDITION RESTORED != EXTERNAL FINAL ELEMENT PROVED DE-ENERGIZED != RESET ACTUATOR HEALTHY != VALID RESET TRANSITION != SAFETY CIRCUIT REARMED != ORDINARY PROCESS START`

`WELDED CONTACTOR -> EDM/FEEDBACK NOT READY -> RESET REFUSED`

`RESET HELD/TIED DOWN -> MONITORED RESET REFUSED`

`SAFETY RESET ACCEPTED -> SAFETY CIRCUIT READY`, **not** `PROCESS START`.

A stale process START must not survive a safety demand and become motion merely because safety authority later returns. In the CENTERLINE implementation the ordinary start command must drop with the safety circuit and a **new** start command is required after reset.

## What this proves physically — and what it does not

The contactor auxiliary feedback proves the designed switching-device state sufficiently to gate reset in these implementations. It does **not** by itself prove that every hazardous energy source is absent, that a gravity load is retained, that hydraulic pressure is safe, or that actual stopping performance remains within the machine-specific validated limit.

Therefore:

`EDM PASS != HAZARDOUS ENERGY ABSENT != PHYSICAL STOP PERFORMANCE PROVED`.

The Rockwell E-stop example's stop-category-0/coast behavior is application-specific and must not be transferred to OpenPressBrake.

## OpenPressBrake transfer rule

This is an architectural lesson, not a machine-specific design claim. OpenPressBrake may use the pattern only after its actual hazards, safety final elements, feedback topology, reset location/semantics, hydraulic state, personnel-clear requirements, and stopping validation are established. Ordinary LinuxCNC/HAL or the normal FPGA must not be promoted to sole personnel-safety authority merely to implement the fresh-start interlock.

## Explicit UNKNOWNs

OpenPressBrake reset device, reset edge/timing semantics, EDM topology, individual final-element feedback, personnel-clear architecture, hydraulic final-element truth table, safe pressure/load state, PL/SIL/category/DC/CCF, stopping distance/time and press-brake-specific production-start semantics remain UNKNOWN until machine-specific evidence or engineering establishes them.

## Next evidence target

Continue into a professional implementation that combines this reset/EDM/fresh-start discipline with a **physical hazardous-state witness** beyond auxiliary contact state: actual standstill/speed, brake/load retention, hydraulic safe state, or measured stopping performance. Prefer a source that includes injected welded/stuck final-element failure and documents the recovery/re-proof sequence after repair/replacement.
