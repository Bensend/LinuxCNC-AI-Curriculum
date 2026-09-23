# 25F0 — Robot/automated-cell safety capstone delta

Session start UTC: 2026-09-23T23:35:07Z

## Purpose and boundary

This begins the robot/automated-cell transfer from the mill and lathe capstones. It is a cell-level safety contract, not a universal robot circuit. Exact stop times/distances, separation distances, safe-speed values, PLr/SIL targets, proof-test intervals and device-specific integrity claims remain **UNKNOWN** until justified for the actual cell.

Evidence classes: **DOC-CONFIRMED**, **INFERENCE**, **UNKNOWN**.

## Authoritative anchors

- OSHA's robotics-safety guidance describes interlocked barrier guarding around the robot work envelope: opening a gate stops automatic robot and associated-machine operation, and restart requires gate closure plus reactivation of a control outside the barrier. **DOC-CONFIRMED.** Source: OSHA, `Guidelines For Robotics Safety`, STD 01-12-002.
- ABB's current OmniCore material describes manual robot interaction using dedicated safety hardware including emergency stop and a three-position enabling switch, and explicitly says completed-application compliance depends on correct integration, risk assessment, verification and validation. **DOC-CONFIRMED for supported ABB systems.**
- ABB's machine-safety guidance states that manual reset should be separate/deliberate, should not itself initiate motion or a hazardous situation, and should enable acceptance of a separate start command. **DOC-CONFIRMED as ABB's published ISO 13849 application guidance.**
- Rockwell's current safety-mat documentation identifies presence sensing within a guarded perimeter as a typical application. **DOC-CONFIRMED for that product family.** This demonstrates that gate closure alone need not be the only occupancy proposition available; it does not make safety mats universally required.

## Cell-specific boundary shift

A robot cell differs from the enclosed single machine because a person may pass fully through a perimeter gate and remain inside after the gate closes. The safety proposition therefore cannot collapse to `gate closed = cell empty`. The boundary also includes associated machinery and peripherals whose hazardous energy may remain even if robot motion is stopped.

**Freeze:** `PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY`.

**Freeze:** `ROBOT STOPPED != CELL SAFE STATE PROVED`.

**Freeze:** `ROBOT CONTROLLER SAFE STATE != PERIPHERAL MACHINE SAFE STATE`.

## SRS delta — first pass

### R-SF-01 — perimeter access

Opening a protected perimeter access point shall demand the defined cell safe state and prevent hazardous automatic operation. Gate restoration shall not itself restart hazardous operation. Where whole-body entry is possible, the design shall separately address the possibility that a person remains inside after the gate is restored.

### R-SF-02 — occupancy / restart eligibility

Where the protected space can conceal or contain a person, restart eligibility shall not be inferred solely from guard closure. The architecture shall provide a risk-derived means to establish safe restart conditions, such as appropriately designed reset location/visibility, trapped-person prevention/escape, presence sensing, key/lock procedures or another validated method appropriate to the cell.

A reset action establishes eligibility only; it is not the production start command.

**Freeze:** `SAFETY RESET COMPLETE != CELL OCCUPANCY CLEARED`.

### R-SF-03 — manual/setup operation

Where a person must work within or near the safeguarded space for teaching/setup/recovery, the alternate mode shall be deliberate and bounded and shall use the safety functions required by the actual robot/application. Dedicated enabling hardware is one proven industrial pattern. Ordinary HMI/jog software is not credited as the safety function merely because it limits a command.

**Freeze:** `SOFTWARE JOG LIMIT != SAFE MANUAL OPERATION PROVED`.

### R-SF-04 — associated machinery and tooling

The cell safe-state definition shall enumerate robot axes plus every associated hazardous-energy path: positioners, conveyors, clamps/grippers, pneumatic/hydraulic tooling, weld/process energy, machine tools, transfer mechanisms and upstream/downstream equipment as applicable. A robot stop demand shall not silently leave an independent peripheral hazard active.

### R-SF-05 — reset/restart

Safeguard restoration and manual reset shall not initiate hazardous motion. Reset location and procedure shall support the physical proposition needed for the protected space; where the operator cannot verify the whole space, additional occupancy/egress measures are required. Production start remains separate and deliberate.

### R-SF-06 — maintenance isolation

Production safety functions are not maintenance isolation. Servicing shall address robot drives, gravity/stored mechanical energy, peripherals, fluid power, process energy and any other hazardous source using task-appropriate isolation, dissipation/restraint and verification.

## Authority allocation delta

| Layer | May own | Must not be credited with |
|---|---|---|
| ordinary LinuxCNC/PLC/robot application logic | sequence, path/motion request, process commands, HMI, diagnostics | personnel-safety authority or proof that safeguarded space is empty |
| safety-related robot/controller functions | qualified stop/safe-motion/manual-mode functions within their documented architecture | peripheral safe state or cell-wide safety unless integrated/validated for it |
| independent/cell safety-related control | gate/presence/enabling evaluation, reset/restart gating, coordinated safety demands to cell equipment | facts beyond actual sensors/final elements |
| physical final elements | drive safety functions, contactors, brakes, valves, process-energy isolation devices | universal cell safe state from component presence |
| physical guarding/space | fence, gates, geometry, escape/egress, presence-sensing layout where used | occupancy truth merely because a gate is closed |

## Human-factor / defeat pass

- Put reset where it supports a deliberate protected-space check; do not solve poor visibility by making reset easier to press blindly.
- Teaching/setup must be practical with the intended enabling/safe-manual method. If routine programming requires defeating the gate, the workflow is defective.
- Cell recovery should identify which robot/peripheral is preventing rearm rather than presenting a generic safety fault that encourages bypass.
- Entry/exit and lock/key procedures must account for multiple people, not just the person who opened the gate.
- Restart logic must tolerate ordinary production pressure without rewarding a shortcut around the occupancy check.

## Residual UNKNOWN register

- actual cell stop times and separation distances;
- required safe-speed/limited-motion values;
- selected robot controller safety functions and their integrity claims;
- exact whole-body presence/egress strategy;
- peripheral safe states and energy-removal mechanisms;
- PLr/SIL targets and architecture;
- proof-test intervals and diagnostic coverage.

## Next work

Deepen the robot/cell case with manufacturer documentation for safeguarded-space entry, enabling-device/manual-mode behavior and coordinated peripheral safety, then create the explicit transferred/modified/new SRS matrix. After that, begin the press-brake capstone with gravity, hydraulic stored energy and point-of-operation hazards.