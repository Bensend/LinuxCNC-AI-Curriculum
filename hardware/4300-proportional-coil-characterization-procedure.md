# Proportional-solenoid coil characterization procedure

Status: WORKING BENCH PROCEDURE — intended to close the remaining high-information electrical unknowns before clamp/loop simulation.

## Goal
For each proportional-valve coil family, obtain authoritative values for:
- cold DC resistance;
- hot/operating resistance or steady current;
- inductance/electrical time constant near the actual operating condition;
- current rise and decay behavior with the intended supply and clamp class.

Do not infer inductance from coil resistance or markings.

## Equipment
Minimum useful set:
- DMM;
- current-limited 24-V bench supply;
- oscilloscope;
- known low-value current shunt or current probe;
- LCR meter if available.

For energized tests, secure the hydraulic/mechanical system so coil actuation cannot create hazardous machine motion. The electrical test does not justify exposing people to ram/axis hazards.

## A. Resistance
1. Disconnect coil from machine electronics.
2. Measure lead-to-lead resistance with DMM after coil is at ambient temperature.
3. Record ambient temperature and coil identifier.
4. If practical, energize at normal operating current long enough to reach representative temperature, de-energize safely, and immediately remeasure resistance.
5. Record both cold and hot values; current-loop voltage headroom must work at the higher resistance.

## B. Inductance with LCR meter
If an LCR meter is available, measure L at more than one available test frequency (for example 100 Hz and 1 kHz) and record the meter frequency. Solenoid inductance can change with armature/spool position and magnetic state, so record whether the coil is mounted on its valve and the valve state. Treat this as a useful starting value, not automatically the final dynamic value.

## C. Dynamic L/R measurement — preferred design input
Use the actual coil on a current-limited 24-V supply with a properly rated switching device and a current shunt/probe. Do not use the future FPGA board for this first characterization.

1. Put a known current shunt in the measurement path or use a current probe.
2. Apply a voltage step to the coil while capturing coil current and coil voltage.
3. Keep the pulse short enough to avoid unintended hydraulic motion/overheating but long enough to see the exponential current rise.
4. Determine final current I_inf for that pulse and find the time at which current reaches 63.2% of I_inf. That time is approximately tau = L/R for a simple RL region.
5. Compute L approximately tau*R using the resistance appropriate to the test temperature.
6. Repeat at least several times and, if physically relevant, at representative valve/spool states. If L varies materially, retain a min/max envelope rather than one false-precision value.

## D. Decay/clamp characterization
After a safe initial diode-clamped test, repeat turn-off with candidate elevated clamp arrangements only after the switch/clamp voltage ratings are checked.

Capture simultaneously:
- coil current;
- MOSFET drain/switch-node voltage;
- 24-V rail.

For each clamp condition record:
- peak drain voltage including wiring overshoot;
- time from commanded OFF to 90%, 50% and 10% of initial current;
- ringing;
- clamp temperature for repeated operation if relevant.

The design target is not simply the fastest decay. Select enough decay voltage to meet hydraulic response while preserving substantial VDS margin and repetitive clamp-energy margin.

## E. Data record per coil family
Record:
- part/marking;
- cold R and temperature;
- hot R or hot steady current;
- LCR values/frequencies if available;
- dynamic tau and calculated L min/typ/max;
- supply min/nom/max used;
- current command range actually required by machine;
- desired/observed current rise time;
- desired/observed current fall time;
- clamp type/voltage and measured peak VDS;
- test date and instrument identifiers.

## Design handoff
Once R/L/current and desired fall-time envelope are known, return to `hardware/4300-proportional-current-driver-block.md` and freeze:
1. MOSFET VDS/SOA/avalanche margin;
2. clamp voltage and repetitive energy rating;
3. PWM frequency/current ripple;
4. ADC sample phase/rate;
5. loop gains and hardware overcurrent threshold.

Only after these values exist is loop/clamp simulation likely to add meaningful evidence.
