# 4400 transfer card — Guard locking is machine- and hazard-specific

**Status:** conceptual transfer exercise using manufacturer-source findings. This does not authorize any physical operation. Do not apply a generic safety-locked door solution to an open press-brake point of operation without a machine-specific risk assessment.

| Machine class | Example access hazard (INFERENCE, not a selected machine fact) | Why guard-locked or standstill bit may be insufficient | Additional independent evidence required |
|---|---|---|---|
| Mill / VMC | Spindle run-on, ATC mechanism, coolant pressure or gravity-held axis | Spindle motor zero-speed may not cover ATC or gravity; access may be possible before all hazards end | Hazard inventory per axis/process, actual stop/hold, toolchanger state, access geometry, separate restart |
| Lathe / turning center | Rotating chuck/workpiece inertia and coolant | Guard-unlock command or drive torque inhibit does not establish chuck standstill | Qualified spindle stop/access timing and any separate workholding/energy hazard |
| Press brake | Rear/side enclosure access, beam drift under gravity or trapped pressure | Pump-motor standstill does not prove ram restraint; a point-of-operation light curtain is not an enclosing locked door | Independent beam/ram holding and pressure-zone evidence, suitable safeguarding and maintenance blocking |
| Plasma / laser cell | Gantry motion, stored high voltage, fume/fire, process energy | Axis standstill does not prove cutting power safe, discharge complete or ventilation/fire hazards absent | Process-specific energy isolation, exhaust/fire risk control, access boundary, appropriate witnesses |
| Robot / automated cell | Multi-axis movement, whole-body entry, retained program start | One axis stopped does not cover all axes; field clear/door closed does not prove nobody remains inside | Full-space occupancy/escape, independent stop of all hazardous axes, retained-start inhibit, physical reset visibility |
| Feeder / automated transfer | Stored pneumatic/hydraulic energy, material fall, remote restart | Stopped main motor may leave pressure, gravity and neighboring actuator motion | Per-energy-zone isolation and hold, guarded access, separate rearm/start |

## Adversarial transfer prompts

1. A VMC spindle monitor reports zero but a pneumatic toolchanger remains charged. Which `ENE/PHY` remain open?
2. A press brake has a safety controller reporting the pump stopped but the beam drifts. Which proposition fails and what evidence takes precedence?
3. A robot cell's inside escape release is functional but the outside reset button cannot see a blind corner. Does a cleared light curtain permit restart?
4. A plasma cell has no axis motion but process high voltage is still present. Is 'standstill' an adequate safe-access criterion?

Expected reasoning: use separate `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/VAL/HF/CHG/UNK` IDs; avoid copying product example thresholds or ratings; require machine-specific evidence and keep people outside danger zones until minimum safe-to-operate protection is established.
