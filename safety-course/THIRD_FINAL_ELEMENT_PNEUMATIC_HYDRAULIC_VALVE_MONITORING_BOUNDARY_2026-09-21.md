# Third final-element family — pneumatic/hydraulic valve monitoring boundary

Session start: 2026-09-21T11:34:04Z

## Question

After the Siemens 3SK1 contactor/EDM case and Rockwell Safe Brake Control case, can authoritative valve-family evidence support a reusable claim about monitored valve disagreement, fault latching, reset, and restart freshness?

## Evidence

### SMC VP/VG residual-pressure release valves — DOC-CONFIRMED

SMC's current VP/VG product material describes a residual-pressure release valve with **main valve position detection**. SMC says the detection function is used to detect inconsistency between input signals and valve operation. For redundant Category 3/4 arrangements, one valve can release residual pressure if the other fails to operate. SMC also explicitly says the valve is only a component of a safety system and cannot by itself guarantee safety of the complete equipment.

Source: https://www.smcworld.com/newproducts/en-sg/vpvg/

This is strong evidence that valve-position feedback is a legitimate diagnostic witness, but it does not establish a universal timeout, latch, reset, or restart algorithm.

### Festo functional-safety guideline — DOC-CONFIRMED

Festo's functional-safety guideline states that diagnostics of a pneumatic safety sub-function must be able to monitor the safe state of the power-switching component. It distinguishes direct directional-valve monitoring, indirect valve monitoring, and process-based fault detection, and notes that other sensors such as flow or displacement sensors can be appropriate.

Source: Festo, *Guideline for functional safety*, 2022/02, p. 38: https://media.festo.com/media/3034_documentation.pdf

This is useful because it prevents collapsing `valve position` into `process safe state`: the diagnostic architecture may need a different witness depending on the safety sub-function and physical claim.

### Bosch Rexroth spool-position monitoring — DOC-CONFIRMED

Bosch Rexroth's spool-position-monitoring technical information documents explicit electrical error ranges and states that, after a persistent monitoring failure, the valve must be returned to the manufacturer; recalibration/resetting is factory work.

Source: Bosch Rexroth Oil Control, *Spool Position Monitoring Technical Data*, RE 18300-31/09.2022: https://apps.boschrexroth.com/products/compact-hydraulics/ch-catalog/pdf/RE18300-31.pdf

This reinforces that monitored position has a defined diagnostic boundary and that some failures are not operator-resettable.

### Bosch Rexroth STOM hydraulic safety manifold — DOC-CONFIRMED

Rexroth's current STOM material describes hydraulic STO as two-channel, position-monitored blocking of P1 to P2 and separately describes safe decompression through dual bypass valves. That separation matters: blocking the supply path and relieving downstream stored pressure are distinct physical functions.

Source: https://www.boschrexroth.com/en/us/blog/ih/safety-solved-how-sto-manifolds-deliver-critical-machine-protection-without-the-engineering-headaches-us/

## Evidence boundary / information-gain stop

The public authoritative sources found in this trace do **not** expose one complete valve safety-function state machine with all of the following together: disagreement timer, latched fault, exact reset edge semantics, and held-start behavior across recovery. Therefore this branch must not manufacture a universal valve algorithm or copy the Rockwell SBC/Siemens 3SK1 behavior into pneumatics/hydraulics.

The cross-family result is instead a stronger methodology rule:

1. Identify the commanded safety function.
2. Identify the actual final element(s).
3. Identify exactly what each feedback channel physically witnesses.
4. Identify any disagreement timing from the actual safety controller/function block, not from the valve's mere presence.
5. Trace whether the fault latches and what transition clears it.
6. Independently trace whether an already-present ordinary demand can become effective when permission returns.
7. Add process witnesses when position alone cannot establish the required physical condition.

## Durable freezes

- **VALVE POSITION FEEDBACK VALID != PRESSURE SAFE.**
- **VALVE POSITION FEEDBACK VALID != FLOW STOPPED.**
- **SUPPLY BLOCKED != STORED DOWNSTREAM ENERGY DECOMPRESSED.**
- **REDUNDANT VALVES != COMPLETE MACHINE SAFETY VALIDATION.**
- **MONITORED POSITION != UNIVERSAL RESET/RESTART SEMANTICS.**
- **A RESETTABLE ELECTRONIC FAULT != A RESETTABLE MECHANICAL/SENSOR FAULT.**
- **FINAL-ELEMENT FEEDBACK RECOVERED != FRESH ORDINARY START DEMAND.**

## OpenPressBrake curriculum implication

For press-brake hydraulic examples, teach separate witnesses for valve command, valve/spool state, pressure/energy state, and actual ram/motion state where the hazard analysis requires them. Do not invent a particular hydraulic truth table, pressure threshold, response time, PL/SIL, diagnostic coverage, or valve sequence without machine-specific design authority.

A LinuxCNC/FPGA controller may consume diagnostic status for ordinary-control gating and operator information, but personnel-safety authority remains in the independent safety architecture.

## Result

The requested third-family comparison reached a genuine public-source information-gain stop on detailed reset semantics while still yielding durable physical-witness rules. Rotate rather than repeatedly searching for a universal valve state machine.
