# Gravity-axis safe brake control and proof-test trace — 2026-09-18

Session start: **2026-09-18T06:37:33Z**

## Why this branch

The current primary press branch has already separated safety authority, monitored hydraulic final elements, pressure evidence and common-beam load state. Parallel Lane B is studying 24-V/output electrical fault containment. This trace deliberately takes the independent gravity-axis mechanical-retention branch: what must be proved when a suspended/gravity-loaded axis can fall even after motor torque is removed.

## Evidence ledger

### DOC-CONFIRMED — Siemens vertical-axis worked example

Siemens application example 109896030 (V1.0, 07/2024) describes a gravity-loaded vertical axis using SINUMERIK ONE Safety Integrated. Emergency Stop is dual-channel into SIMATIC ET 200SP and evaluated by an F-PLC. Safe brake management combines Safe Brake Control (SBC) and Safe Brake Test (SBT). For the documented Emergency Stop sequence the axis is first braked using SS2/SS2E; after the defined sequence STO is activated, pulses are cancelled and the brake closes. If a second external holding brake is present, it is controlled by a safe F-I/O output.

Source: Siemens, *Calculation examples for safety functions on a vertical axis*, Entry ID 109896030, V1.0, 07/2024.

### DOC-CONFIRMED — Siemens brake-management worked implementation

Siemens application example 109477754 states the physical problem directly: vertical or asymmetrically loaded axes can drop due to gravity after the drive is switched off. It documents SBC as two-channel control of a closed-circuit holding brake and states SBC is triggered with STO when configured. Its SBT does not merely test an electrical brake command: the drive applies a test torque against the closed brake and monitors axis movement. Movement during the test means the available holding torque must be treated as insufficient; the axis must be moved to a safe position and the brake checked/repaired.

Source: Siemens, *Safe Brake Test / Safe Brake Control*, Entry ID 109477754, 01/2018.

### DOC-CONFIRMED — Pilz safe-motion boundary

Pilz's safety compendium describes SBC as a safe output to an external mechanical, spring-applied brake and says SBC is normally initiated with STO. It separately warns that safe control of the brake is not sufficient evidence of the wearing mechanical brake's braking action; SBT is the mechanism that tests the brake and can stop the plant/report a fault on a negative result. Pilz's PMC material also states that gravity-loaded axes in SOS require a mechanically based braking concept.

Source: Pilz, *Safety Compendium*, Chapter 7 Safe motion; Pilz PMC drive-technology documentation.

### DOC-CONFIRMED — SEW control-versus-mechanics distinction

SEW-EURODRIVE's MOVISAFE CS..A brake-test documentation warns that faulty brake-control wiring or defective switching times can allow a gravity-loaded axis to fall. It requires safe brake control to use a safe digital output assigned to SBC, not the ordinary DB00 brake output, and treats brake release/application timing as part of the configured brake-test contract.

Source: SEW-EURODRIVE, *Brake Test Diagnostics Function with MOVISAFE CS..A*, document 27800261.

## Frozen engineering model

A gravity-axis safety claim must not collapse these layers:

**MOTION COMMAND REMOVED != MOTOR TORQUE REMOVED != BRAKE COMMANDED CLOSED != BRAKE ELECTRICALLY ACTUATED != BRAKE MECHANICALLY ENGAGED != REQUIRED HOLDING CAPACITY PROVED != LOAD PHYSICALLY RETAINED.**

SBC answers the safe-command/control side of the brake path. SBT can provide diagnostic evidence about mechanical holding capability when implemented according to the manufacturer's validated method. Neither term should be used as shorthand for the entire machine safety function.

### Why STO is not fall protection

STO prevents torque-producing energy in the drive; on a gravity-loaded axis, removing motor torque can expose rather than eliminate the gravity hazard. A vertical-axis architecture therefore needs an independently justified load-retention concept where the risk assessment requires it. This is especially relevant to press beams, Z axes, robot vertical axes, hoists and suspended fixtures.

### Why `brake output OFF` is not proof

A de-energized command can coexist with a wiring fault, brake-driver fault, incorrect switching timing, mechanical wear, contamination, excessive load, broken friction/mechanical parts or another failure that prevents required holding force. Electrical output diagnostics and mechanical holding proof are different evidence classes.

### Brake testing is an intentional force challenge

The Siemens example demonstrates a valuable commissioning principle: proof of a holding brake can require deliberately applying a bounded test torque while monitoring movement. That is stronger evidence than checking a brake coil or auxiliary bit. The exact test torque, permissible movement, interval and pass/fail limits are device/application-specific and MUST NOT be invented for OpenPressBrake.

## Commissioning/fault-injection card

For a real gravity-axis implementation, challenge at least these separable claims where the selected equipment permits safe validation:

1. Demand a safety stop and verify the documented sequencing between controlled deceleration, brake application and STO; do not infer timing from signal names.
2. Interrupt or invalidate the ordinary brake command path and confirm the safety brake path remains the authority claimed by the design.
3. Challenge one brake-control channel/wiring path where the manufacturer's validation procedure permits it and verify detection/reaction.
4. Verify that brake-command state cannot be accepted as mechanical holding proof.
5. Execute the manufacturer's brake proof/test procedure and verify that insufficient holding capability produces the documented fault/restart inhibition.
6. Challenge stale ordinary LinuxCNC/HAL/FPGA motion requests across brake/safety recovery. Safety recovery must not reinterpret an old maintained command as fresh START authority.
7. For dual holding devices, verify the design's claimed independence and common-cause assumptions rather than counting two brakes as automatically redundant.
8. With drive torque removed, separately establish what physically retains the load. A stationary load during one observation is not sufficient proof of the intended retaining element.
9. For maintenance beneath/within a gravity hazard, do not substitute SBC/SBT/STO status for the task-specific physical blocking/restraint/isolation required by the machine's maintenance procedure.

## Human-factors rule

A brake proof test that is difficult, obscure, easy to skip or routinely blocks production without a practical recovery path will predictably be bypassed. Design the maintenance/commissioning workflow so required proof testing is easy to initiate, its result is obvious, a failed test inhibits hazardous operation, and repair/retest is simpler than defeating the test.

If required gravity-load retention cannot be demonstrated, the machine is **DO-NOT-OPERATE with people exposed to the fall/crush zone**. Experimental troubleshooting must keep people outside the danger zone and use appropriate isolation/remote methods.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the normal FPGA may request motion, display brake/safety diagnostics and obey a safety permissive. They must not be promoted to sole personnel-safety authority merely because they can sequence a brake output. The independent safety architecture owns the safety function and its required diagnostics. A LinuxCNC `joint.N.amp-enable-out = FALSE`, servo disable, watchdog trip or zero command is not evidence that a gravity-loaded axis is physically retained.

## OpenPressBrake UNKNOWN boundary

Do not infer from these professional examples that OpenPressBrake has or needs any particular number/type of mechanical brakes, SBC/SBT implementation, safe drive, test torque, test interval, stopping time, required PL/SIL/category/DC, permissible movement, brake capacity or hydraulic/mechanical restraint topology. Those require the actual machine hazard analysis, mechanics, selected components and validation evidence.

## Evidence status

- Manufacturer behavior above: **DOC-CONFIRMED**.
- General separation of command/control/mechanical holding layers: **INFERENCE grounded in the cited manufacturer architectures**.
- OpenPressBrake-specific brake architecture/performance: **UNKNOWN**.
- No new **TEST-CONFIRMED** claim was created in this session.

## Next evidence target

Find a complete professional vertical-axis or press implementation that exposes the failure/recovery path through:

**brake mechanical proof failure -> safety latch/inhibit -> physical load-safe disposition -> reset prerequisites -> brake re-enable -> separate fresh ordinary START.**

Prefer an implementation that also exposes a second holding element or hydraulic holding path so common-cause and disagreement behavior can be traced. If public evidence stops before physical load disposition, preserve that boundary as UNKNOWN rather than composing unrelated examples into a fictitious certified machine.

## Compute decision

No simulation/build/synthesis/benchmark/test was justified. The unresolved questions are manufacturer/application topology and physical validation questions. No GitHub-hosted Actions compute is authorized; any future bounded executable question must use `[self-hosted, openpressbrake]` only.