# Press final-element authority composition — 2026-09-18

Session start UTC: 2026-09-18T05:34:18Z

## Question
Can the existing professional press evidence be composed into a defensible end-to-end authority model without pretending that two different vendor implementations form one certified machine?

## Evidence

### SICK UE4457 press example — DOC-CONFIRMED
The UE4457 press application exposes E-stop/guard/protective-device inputs, reset, EDM/readback for press up/down, safety outputs to press up/down valves, and an interface to the standard press PLC. The standard PLC supplies Restart, closing-stroke, and opening-stroke signals; UE4457 returns Restart required and safety monitoring information. Existing course trace establishes the ordered separation of manual reset, restart handshake, Safety Enable, and ordinary Ram Up/Down authority.

Source: SICK UE4457 IP67 Operating Instructions, press-control example / logic programming, 2010-04-06.

### HAWE ePRAX — DOC-CONFIRMED
Existing course traces establish a different professional hydraulic press-brake implementation in which safety-related valve actuators QM2-QM5 have BG2-BG5 valve-position monitoring; the hydraulic architecture has explicit beam-holding and unintended-pressurization objectives, pressure witnesses, independently controlled Y axes, and configurations with deliberately stored hydraulic energy.

HAWE's current product documentation also states that ePRAX modular independently controls each cylinder with its own servomotor/drive and may use temporarily stored hydraulic energy for return motion. HAWE identifies reliable press-beam holding and safe monitoring of individual functions as press-brake requirements.

## Composition boundary
These are **two professional examples, not one certified architecture**. Therefore the course may compose the *reasoning obligations* but must not claim that SICK UE4457 + HAWE ePRAX is an approved combination.

The defensible generic chain is:

**protective demand -> independent safety logic -> reset/restart state -> safety output authority -> final-element command -> final-element feedback -> hydraulic path state -> pressure/energy witness -> load/motion state -> fresh ordinary START**

Every arrow requires implementation-specific evidence.

## Important distinction: command authorization versus physical proof

A safety controller can decide that a valve output may energize. That does not prove the valve moved.
A valve-position switch can prove the monitored element reached its documented state. That does not prove all parallel hydraulic paths are blocked.
A pressure transducer can witness pressure at its measurement point. That does not prove every chamber/accumulator is discharged.
A stationary beam proves only observed motion state over the observation interval; it does not by itself prove the intended holding element is carrying the load.
A successful reset/restart handshake proves neither personnel clearance nor absence of stored hydraulic/gravity energy.

Freeze:

**SAFETY AUTHORITY != FINAL-ELEMENT STATE != HYDRAULIC STATE != LOAD STATE != ENERGY ABSENT.**

## Dual-axis implication
For a common press beam with independently controlled Y1/Y2 hydraulic axes, a machine-level safe claim cannot be inherited from one healthy axis. The integrator must define and validate what combinations of valve-position feedback, axis position/speed evidence, pressure evidence, drive state, and physical load behavior are required for the claimed safety function. No discrepancy threshold or timing is inferred here.

Freeze:

**Y1 SAFE EVIDENCE + Y2 UNKNOWN/CONTRADICTORY EVIDENCE = MACHINE SAFE CLAIM NOT ESTABLISHED.**

## Reset/re-enable implication
After a safety demand clears, the architecture should make physical re-enable an ordered proof process rather than a single boolean:

1. protective conditions satisfy the safety design;
2. retained faults/discrepancies are resolved according to the safety design;
3. manual reset/restart handshake occurs where required;
4. safety authority becomes available;
5. final elements reach and report states consistent with that authority;
6. required pressure/energy/load witnesses are fresh and consistent;
7. only then may a **fresh** ordinary motion request initiate motion.

A maintained LinuxCNC/HAL/FPGA command that predates safety recovery is not fresh operator intent. Ordinary LinuxCNC/FPGA control may consume safety status and diagnostics, but must not become the sole personnel-safety authority.

## Adversarial commissioning challenges

- Force one final-element command/feedback disagreement and verify hazardous re-enable is denied/latches as the design requires.
- Make Y1 evidence healthy while Y2 feedback is missing/stale/contradictory; verify a common-beam safe claim is not asserted.
- Present plausible valve-position feedback with inconsistent pressure evidence; verify the system does not collapse the witnesses into one assumed truth.
- Remove electrical drive power while retaining documented hydraulic stored energy; verify the HMI does not report maintenance-safe merely from drive-off state.
- Hold an ordinary Ram Down/Jog command through a safety trip/reset; verify recovery does not reinterpret it as a new START.
- Restore feedback/network/power domains in different orders and require freshness before using diagnostic evidence.

## OpenPressBrake boundary — UNKNOWN
The actual OpenPressBrake hydraulic topology, safety valves, monitored positions, pressure-witness locations, accumulator/precharge state, Y1/Y2 discrepancy criteria, reset latch behavior, PL/SIL/category, stopping distance, timing, leakage allowance, and maintenance restraint are not established by these examples. They require installed-machine/design evidence and validation.

Until the actual machine establishes the minimum physical safety chain, operation with people exposed is not justified by LinuxCNC command inhibition or controller status alone; experimental operation must keep people outside the danger zone and state residual risk explicitly.

## Evidence classifications
- SICK press restart/EDM/valve-output architecture: DOC-CONFIRMED.
- HAWE ePRAX monitored hydraulic architecture and stored-energy characteristics: DOC-CONFIRMED.
- Cross-vendor authority chain above: INFERENCE, deliberately generic and bounded.
- OpenPressBrake-specific implementation values/topology: UNKNOWN.

## Compute
No simulation/build/synthesis/test compute was needed. This question was resolved by authoritative documentation and evidence reconciliation; no GitHub-hosted runner minutes were used.
