# 4400-TK-02 — Castell BEMF standstill sensing, wiring-change auto reset and gravity boundary
**Original manufacturer manual | 2026-10-25 | DOC-CONFIRMED exact product/edition; no runtime or physical test**

## Distinct unresolved question
Can a motor-back-EMF-based key release prove *all hazardous machine motion and load holding*? **No**. It measures an electrical-motor winding phenomenon in a specified circuit. It does not establish that a disconnected load, hydraulic ram, pneumatic actuator, conveyor, stored energy or other axis is stationary and supported.

## Direct original evidence
**Castell BEMF Motor Sensing Interlock**, *U-BEMF-001-E Issue 3*, seven-page original manual: https://www.sentricsafetygroup.com/us/wp-content/uploads/sites/2/2023/02/BEMFJan_23.pdf . Direct PDF read:
- **p.1**: key trapped during motor running; key switch OFF, movement detector detects zero movement, solenoid/green indication enables key release via button; released key opens access lock.
- **pp.2–3**: part of a complete system; installation by competent person, earth bonding, anti-tamper fasteners; six-month check of proper release conditions; manufacturer component PLe and B10d data (not system PL).
- **p.5, switched-winding/reversing/multispeed motor wiring**: an interruption of three-phase connections greater than two seconds may be detected as a broken wire; manual says configure auto reset (X2–X3 link) to avoid storing that fault. **This is product-specific wiring advice, not general permission for automatic machine restart.**
- **p.6, DC motor**: remanence voltage during rundown can be detected as broken wire; manual again describes auto reset for that fault. Motor/supply topology changes require renewed verification.

## Five independent propositions
1. **Electrical motor OFF request**: BEMF key switch operates the intended circuit. This does not by itself prove contacts/isolators are physically open or every source removed.
2. **Motor winding evidence**: zero-back-EMF detection according to the selected BEMF installation; sensor integrity, broken-wire handling and VFD/winding wiring matter.
3. **Mechanical load**: the actual hazardous shaft, tool, gearbox, belt, ram, payload or actuator is stationary. A motor can be at zero while another energy source moves the load; coupling faults can separate motor from load.
4. **Load held / residual energy**: brake, hydraulic valves, gravity restraint, accumulators and pressure zones remain a separate physical proposition.
5. **Restart**: releasing/returning the key and clearing a broken-wire fault are not permission for an automatic CNC cycle. Independent safety rearm, people exclusion and deliberate fresh normal start are separate.

## Adversarial failure-path questions
- A VFD is stopped but its connected motor is still coasting through an alternative drive path: does the exact BEMF wiring detect that? **UNKNOWN until selected wiring/validation**.
- A reversing contactor opens the sensed motor leads for >2 s while the load remains dangerous: OEM documents possible broken-wire fault. Do not infer the selected device's exact key-release response without configured relay/wiring inspection.
- Installer adds the OEM X2–X3 auto-reset link for the documented fault. Does this auto-restart LinuxCNC? **Not claimed**; trace safety relay reset versus CNC start separately. It changes fault-memory handling and therefore requires change control.
- A press brake motor has zero back EMF, but a ram descends under gravity or pressure. The motor signal cannot establish hydraulic load holding.
- A mill spindle motor is stopped, but tool or chuck is released by separate pneumatic energy. The BEMF does not prove retention.
- Green LED lights: verify key release, selected independent physical isolation and safe state rather than interpreting color as a whole-machine safety certificate.

## Practical architecture
Use BEMF only where its specified motor/winding detection and release function match the selected hazard. Confirm exact wiring diagram, motor topology, switch/isolator physical contacts, relay configuration, fault memory and intended access sequence. Combine with correct trapped-key access and personnel keys where whole-body entry exists, and with independent mechanical/hydraulic retention and stored-energy isolation. Make fault diagnostics intelligible and avoid automatic bypass to suppress nuisance alarms.

## Evidence and limitation
**DOC-CONFIRMED** original Issue 3 p.1/3/5/6 behavior, including auto-reset advice. **INFERENCE** cross-machine failure scenarios. **UNKNOWN** actual selected wiring, motor topology, BEMF reaction time, full-system PL/SIL, coupling, gravity holding, access occupancy, restart. **TEST-CONFIRMED none**. No LinuxCNC source or simulation needed to settle the documentation distinction; physical proof requires qualified protected machine-specific witness. No OpenPressBrake BEMF installation asserted. G0/G1 HOLD, G3/G4 NOT AUTHORIZED.
