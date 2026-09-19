# Two-hand press physical-stop and recovery trace

Date: 2026-09-19

## Question

What does a professional press implementation establish beyond two-button simultaneity, and what must remain separate before that pattern is transferred to a press brake?

## Evidence

### Rockwell SAFETY-AT071 — two-hand control safety function

Evidence class: **DOC-CONFIRMED**.

Rockwell's published two-hand safety function wires two 800Z palm buttons through an MSR125 two-hand controller, E-stop/GSR safety relay and two 100S safety contactors. The two palm buttons must be operated within 0.5 s; removing either hand causes the safety contactors to turn off. The application note describes those contactors as removing power from the hazardous motion.

This is stronger than a software truth table: the safety function extends through independent safety evaluation to external final switching elements.

Source: Rockwell Automation, `SAFETY-AT071_-EN-E`, Safety Function: Two Hand Control.

### Rockwell SAFETY-AT198 — pneumatic press cycle interruption/recovery

Evidence class: **DOC-CONFIRMED**.

Rockwell's pneumatic-press application gives a complete process consequence for early two-hand release. If the two-hand buttons are released before full extension, cylinder motion is interrupted. Recovery is not automatic continuation: the operator must press/release Reset, use the two-hand control to retract the cylinder, then release the two-hand control before initiating the next cycle.

This establishes a useful authority sequence:

`valid two-hand demand -> hazardous stroke authority`

`release during protected portion -> motion interrupted`

`motion interrupted != cycle may resume from stale demand`

`reset transition -> deliberate two-hand recovery motion -> both controls released -> new cycle initiation`

Source: Rockwell Automation, `SAFETY-AT198A-EN-P`, Pneumatic Press Control via Guardmaster 440C-CR30.

### Lazer Safe Sentinel — press-brake physical stopping witness

Evidence class: **DOC-CONFIRMED**.

The Sentinel press-brake guarding installation manual separately demonstrates what a press-brake physical stop witness looks like. With light curtains it measures press-brake stopping time; with laser guarding it monitors stopping distance. Exceeding the configured limit causes emergency-stop action. A stopping-time error schedules a stopping test on the next stroke; normal operation proceeds only after a passing test, while a failed test is repeated.

This does **not** prove that a two-hand device is the protective device on that Sentinel configuration. It is used only to establish the physical-witness boundary required before claiming that release of a protective control has produced adequate press-brake stopping performance.

Source: Lazer Safe `LS-CS-M-067`, Sentinel Press Brake Guarding System Installation Manual, rev 1.15 (2024-02-02).

## Frozen distinctions

`BUTTON A ACTIVE + BUTTON B ACTIVE != VALID TWO-HAND DEMAND`

`VALID TWO-HAND DEMAND != FINAL ELEMENT ENERGIZED`

`FINAL ELEMENT DE-ENERGIZED != HAZARDOUS MOTION PHYSICALLY STOPPED`

`MOTION INTERRUPTED != STOPPING TIME/DISTANCE VALID`

`RESET != RECOVERY MOTION AUTHORITY != FRESH PRODUCTION CYCLE AUTHORITY`

`TWO-HAND RELEASE DURING HAZARDOUS PORTION -> SAFETY DEMAND` is a valid architecture pattern only when the machine-specific safety function requires continuous two-hand actuation and the final elements/physical stopping performance have been validated for that machine.

## Human-factors consequence

Two-hand controls protect by keeping the operator's hands committed to a known location during the protected hazardous portion. Defeating one button, permitting one hand to remain tied down, or placing the controls so the operator can reach the hazard defeats the intended protective principle. Therefore button logic alone is not sufficient: placement/reach, anti-tie-down, stopping performance and the actual hazard geometry belong to the validated safety function.

The safer implementation should make normal two-hand use convenient and defeat awkward. A control location that predictably encourages bridging, fixtures, or one-handed work is a design defect rather than merely an operator-training problem.

## OpenPressBrake boundary

No claim is made that OpenPressBrake requires two-hand controls, that 0.5 s is its required simultaneity value, or that any particular placement/safety distance is acceptable. No stopping time, stopping distance, hydraulic final-element topology, PL/SIL/category/DC/CCF or restart semantics are assigned.

Ordinary LinuxCNC/HAL or the normal FPGA controller may consume two-hand status for diagnostics/process coordination, but personnel-safety authority must remain in an independently justified safety architecture.

## Remaining evidence gap

Find a press-brake-specific OEM/guarding implementation that explicitly joins a two-hand protective device to its actual hydraulic safety final elements and measured stop/reach validation. Until then, do not splice the Rockwell pneumatic/electrical press topology onto a hydraulic press brake.

No simulation or executable lab is justified by this source question; machine-specific stop/reach validity requires authoritative design evidence and ultimately physical validation, not a synthetic software test.
