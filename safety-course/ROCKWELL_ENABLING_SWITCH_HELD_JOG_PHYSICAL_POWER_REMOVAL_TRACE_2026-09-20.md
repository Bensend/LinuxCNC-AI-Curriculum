# Rockwell enabling switch — held-jog physical power-removal trace

Date: 2026-09-20
Active curriculum: 4000 safety course

## Question

Can a manufacturer implementation provide a stronger physical witness for setup-mode enabling-device behavior than contact-state descriptions alone, particularly the relationship between middle-position enable, a separate jog command, release/full-squeeze response, external contactors and hazardous motion?

## Manufacturer evidence

**DOC-CONFIRMED.** Rockwell Automation publication `SAFETY-AT067D-EN-P`, *Safety Function: Enabling Switch with Single-input and Dual-input Safety Relays*, provides a worked enabling-switch safety function with gate interlock, safety relay and external contactors K1/K2.

In enabling-switch mode with the gate open, the switch must be held in its middle position. A separate jog button restores power to the hazardous motion; releasing the jog button removes power. Releasing or fully squeezing the enabling switch from the middle position breaks the safety-monitoring circuits; the safety relay opens its safety contacts and de-energizes K1/K2. Rockwell states that the resulting hazardous motion coasts to a stop (Stop Category 0).

The publication also states that in the non-enabling-switch mode hazardous motion cannot be started until relevant safety inputs are safe and the Start button is pressed and released.

Source: Rockwell Automation, `SAFETY-AT067D-EN-P`, March 2016: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at067_-en-p.pdf

## Physical authority chain

This gives a more concrete chain than a generic `enable` bit:

**ENABLING SWITCH MIDDLE POSITION + SEPARATE JOG -> SAFETY RELAY OUTPUTS -> K1/K2 COILS -> POWER AVAILABLE TO HAZARDOUS MOTION.**

For the protective reaction:

**ENABLING SWITCH RELEASE OR FULL SQUEEZE -> SAFETY INPUT CIRCUITS OPEN -> SAFETY RELAY OUTPUTS OPEN -> K1/K2 DE-ENERGIZED -> POWER REMOVED -> HAZARDOUS MOTION COASTS TO STOP.**

Freeze:

- **MIDDLE-POSITION ENABLE != JOG COMMAND.**
- **JOG COMMAND != SAFETY PERMISSION.**
- **RELEASE/FULL SQUEEZE != SOFTWARE STOP REQUEST; THE WORKED SAFETY FUNCTION REMOVES POWER THROUGH EXTERNAL CONTACTORS.**
- **CONTACTORS DE-ENERGIZED != AXIS INSTANTLY STATIONARY; THE DOCUMENTED RESPONSE IS COAST TO STOP.**
- **RETURN TO ORDINARY/NON-ENABLING MODE != AUTOMATIC RESTART; RELEVANT SAFETY INPUTS MUST BE SAFE AND START IS A PRESS-AND-RELEASE ACTION.**

## Important limitation / apparent recovery difference

Rockwell's worked application says power is restored when the enabling switch is again in the middle position and the jog button is pressed after release/full squeeze. SICK's general machinery-safety guidance separately states that an enabling function must not reactivate while changing back from position 3 through position 2.

These statements must **not** be silently merged into a universal transition rule. The Rockwell application text does not, in the excerpted operating description, prove the detailed 3->2 transition semantics required by SICK's broader guidance. Treat exact post-panic re-entry behavior as implementation-dependent unless the evaluated device/controller documentation proves it.

Evidence classification for that reconciliation: **DOC-CONFIRMED DIFFERENCE / UNKNOWN UNIVERSAL IMPLEMENTATION DETAIL.**

## Acceptance-test gap

This worked application materially closes the physical final-element path for release/full squeeze and the separate jog authority. It still does not provide one explicit acceptance table instructing a commissioner to hold jog while deliberately exercising position 1, position 3, 3->2, mode exit, safeguard restoration, stale-command rejection and fresh production start while recording pass/fail observations.

That all-in-one acceptance sequence remains **UNKNOWN**.

## OpenPressBrake boundary

**INFERENCE.** The reusable lesson is architectural, not a mandate to copy K1/K2 or Stop Category 0 into a hydraulic press brake. OpenPressBrake's appropriate final safety elements, stopping category, safe speed, hydraulic state and stopping performance require machine-specific safety design and validation. LinuxCNC/normal FPGA must not be assigned the personnel-safety authority merely because it can issue jog commands or observe status.

## Compute

No simulation/build/test compute was required. No GitHub-hosted runner was used.
