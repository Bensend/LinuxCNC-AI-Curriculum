# 4400-RAD-01 cross-OEM — Scanreco wired safety stop versus normal CAN/outputs
**Date:** 2026-10-24. **Evidence:** DOC-CONFIRMED manufacturer web descriptions; **not** an inspected product installation/operating manual or independent test. Do not transfer exact ratings or timings.

## Manufacturer sources
- [Scanreco G5 CAN receiver](https://scanreco.com/industrial-remote-controls/receivers/g5-can): manufacturer describes multiple safety-classified outputs and a dedicated dump-valve output active with a radio link, while ordinary machine commands are communicated via CAN. This is a product-page architecture claim, not a verified selected-machine wiring diagram.
- [Scanreco G5 MOSFET receiver](https://scanreco.com/industrial-remote-controls/receivers/g5-mosfet): manufacturer describes an active-when-operational **safety-classified stop output** distinct from ordinary MOSFET-driven digital/PWM outputs, with link-loss/battery/STOP conditions.
- [Scanreco OneGrip transmitter](https://scanreco.com/industrial-remote-controls/hand-held-transmitters/onegrip): manufacturer's technical table explicitly distinguishes certified STOP and some optional safety actuators from ordinary buttons, with customization-dependent ratings.

## Cross-manufacturer transferable mechanism (INFERENCE)
The safety-rated **radio STOP subsystem** and its dedicated receiver output are not equivalent to a normal CAN message or LinuxCNC HAL bit. A normal CAN timeout can assist process recovery and fault reporting but must not be credited as the machine's independent safety final element without exact certified end-to-end evidence.

Even a receiver output called *dump valve* is **not automatically safe for a gravity-loaded press-brake ram**. Dumping pressure can release a load; the selected hydraulic schematic, valve failure state and physically measured stop/hold must establish the correct action. The name of an output does not establish the safe state.

## Missing evidence
The current search did **not** inspect a complete Scanreco receiver installation manual, certification report, receiver wiring drawing or stop-time test. Therefore no specific Scanreco PL/SIL, latency, wire color, output polarity, reset sequence, dump-valve behavior or product compatibility is used as a design value. Selected installation UNKNOWN.

## Adversarial questions
1. If normal CAN frames stop but the safety output stays asserted, what stops the real actuator independently?
2. If the safety output deasserts but a gravity load descends, what holding function was missing?
3. If a radio transmitter is swapped, which party owns authorization and how is stale motion demand rejected?
4. If a standard relay/fieldbus diagnostic says STOP, is the safety terminal electrically and mechanically proven to have opened?
5. Can an installer mistake an ordinary PWM/MOSFET output for the certified STOP interface?

**Outcome:** architecture transfer only; no machine-specific acceptance, no test and no personnel-exposed operation.
