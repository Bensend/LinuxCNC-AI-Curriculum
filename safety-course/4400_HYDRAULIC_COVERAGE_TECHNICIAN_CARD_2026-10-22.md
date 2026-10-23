# 4400 technician exercise — Which valve is actually monitored?

**Status:** learner-facing exercise; no machine energization or physical tests. This is a reasoning exercise, not a safety approval.

A generic press-brake control package has a manufacturer's S-variant manifold with five specified monitored valve positions. Separate cylinder-base anti-cavitation valves have a documented `L` suffix. An HMI shows `all valves OK`, and a pressure transducer on a manifold port shows a low reading. The machine has an elevated beam, and a technician wants to enter the danger zone to inspect a cylinder connection.

## Questions

1. Name the **five valve categories** whose position monitoring is expressly identified in HAWE D 6335 p. 9. Does that list prove the separately supplied anti-cavitation valves are monitored? Explain the difference between `not in the documented list` and `known not monitored`.
2. What exactly does the NSV **L** suffix establish in D 6368 p. 6? Why can it not establish a leak rate or predicted ram motion?
3. Why are the p1/p2 numbers in D 6368 p. 8 unsuitable as unqualified SRS acceptance limits? What missing evidence would be required to adopt any machine-specific threshold?
4. List three reasons the low reading at one port cannot establish zero hazardous energy everywhere. What documentation would show whether the pressure port actually observes the volume being serviced?
5. A second independent beam-motion witness contradicts `all valves OK`. Which evidence proposition may remain credited? Which `PHY-*` proposition must be blocked? Is reset/rearm authorized?
6. What independent provisions are needed before personnel-exposed cylinder maintenance, separate from normal production E-stop, LinuxCNC disabled, and the SAKB valve-position indications?
7. A replacement NSV is fitted with a different suffix. Which `CHG`, `DEP`, `PHY`, `VAL`, and maintenance records must be reviewed? Why does a matching connector or pressure rating not prove replacement equivalence?
8. Design a *non-operational* evidence plan for selected-manifold identification, feedback coverage, gauge-tap mapping, independent beam restraint and continuing isolation verification. Mark every item that requires physical evidence `UNKNOWN` until obtained.

## Evidence/acceptance rubric

A correct answer distinguishes **DOC-CONFIRMED product statements** from **INFERENCE** and **UNKNOWN installed behavior**; credits only narrow monitored-valve/port propositions; never invents a hydraulic truth table, stopping distance, leakage rate or PL/SIL; retains gravity and stored-pressure hazards; preserves independent safety authority; blocks personnel-exposed operation if safe-state evidence is missing; and proposes service access that does not require guard defeat.

### Fresh-AI transfer case

A mill with a hydraulically released tool clamp reports `clamp sensor OK` while a separate pressure tap is low and tool retention is unproved. Transfer the same reasoning: name the sensor's target, the physical retained-tool proposition, alternate energy paths, independent witness, service isolation and unresolved facts. Do **not** import press-brake hydraulic assumptions into the mill.

## Sources

HAWE D 6335 (08-2025 rev 1.1) pp. 4–5, 9, 13–14; HAWE D 6368 (06-2026 rev 1.3) pp. 4, 6, 8, 24; OSHA 29 CFR 1910.147(d)(5)–(6). See companion research for direct URLs and provenance.
