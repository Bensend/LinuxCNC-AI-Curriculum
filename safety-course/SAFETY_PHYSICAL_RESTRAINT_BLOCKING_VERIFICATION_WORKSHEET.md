# Physical Restraint / Blocking Verification Worksheet

Status: 4000 safety-course engineering worksheet

## Purpose

Prevent a common category error: treating 'energy removed' as equivalent to 'hazardous motion physically impossible.' Elevated members, gravity loads, springs, flywheels, accumulators and trapped pressure can remain hazardous after ordinary drive/pump commands are removed.

`SOURCE-CONFIRMED`: OSHA 1910.147(d)(5) requires potentially hazardous stored/residual energy to be relieved, disconnected, restrained or otherwise rendered safe, and requires continued verification when hazardous reaccumulation is possible. OSHA Appendix A gives examples including capacitors, springs, elevated machine members, flywheels, hydraulic systems and pressure, with methods such as grounding, repositioning, blocking and bleeding down.

This worksheet uses that evidence as a hazardous-energy-control teaching baseline. It does not establish the exact method, capacity or legal applicability for a particular home-shop machine.

## Four proofs

Do not collapse these into one checkbox:

1. **Command proof** — normal control is not requesting hazardous motion.
2. **Energy-source proof** — applicable sources are physically isolated/controlled.
3. **Stored-energy proof** — residual/reaccumulating energy is relieved or restrained.
4. **Load/restraint proof** — the hazardous member/load is physically prevented from reaching a person if another layer fails.

LinuxCNC/HAL/FPGA state can contribute to proof 1. It cannot by itself satisfy proofs 2–4.

## Installed-machine inventory

For every hazardous member/load record:

| Field | Installed evidence |
|---|---|
| Member/load | `UNKNOWN` until inspected |
| Hazardous direction(s) | `UNKNOWN` |
| Gravity contribution | `UNKNOWN` |
| Spring/flywheel contribution | `UNKNOWN` |
| Hydraulic/pneumatic stored energy | `UNKNOWN` |
| Reaccumulation path | `UNKNOWN` |
| Normal holding device | `UNKNOWN` |
| Safety-related holding/blocking device | `UNKNOWN` |
| Maintenance restraint/block | `UNKNOWN` |
| Rated capacity / allowed position | `UNKNOWN` |
| Approved contact/support points | `UNKNOWN` |
| Verification method | `UNKNOWN` |
| Removal/transfer sequence | `UNKNOWN` |

## Restraint acceptance questions

A restraint is not accepted merely because it fits under the load. Verify from machine/design evidence:

- Is it intended for this maintenance function?
- Can it carry the applicable static and credible dynamic load?
- Is the support path structurally valid at the actual contact points?
- Can the member slip, rotate, kick out or bypass the restraint?
- Can another actuator or axis load the restraint unexpectedly?
- Is there trapped pressure or spring force that changes when the restraint is installed/removed?
- Can energy reaccumulate behind a blocked member?
- Is the restraint conspicuous and difficult to forget?
- Is its installed state independently visible/verifiable?
- Does removing it require an explicit transfer to another proven load-holding function?

If capacity, support geometry or load path is unknown, classify the exposed task **NOT CLEARED**. Do not invent a block rating from machine tonnage or cylinder pressure.

## Press-brake challenge

A press-brake ram is stopped, pump command is off, proportional command is zero and the HMI reads zero pressure. A technician plans to work below the ram without a verified mechanical restraint.

Classification: **NOT CLEARED**.

Reasoning: those observations do not establish the gravity/load-retention path. Determine the installed hydraulic holding architecture and maintenance restraint requirements from machine evidence. If those facts cannot be established, exposed work beneath the ram should not proceed.

## Mill/vertical-axis challenge

A vertical CNC axis is servo-disabled. The brake-status bit says engaged.

Classification: **INSUFFICIENT PHYSICAL PROOF**.

Reasoning: a command/status bit does not prove the brake mechanically holds the installed load, nor does it establish the maintenance blocking procedure. Identify the physical load path and manufacturer/machine procedure before exposed work.

## Robot/cell challenge

Robot drives are STO and a suspended end-effector/load remains elevated.

Classification: **STO DOES NOT BY ITSELF PROVE GRAVITY RESTRAINT**.

Reasoning: torque prevention and load retention are separate questions. Determine brake/load-support behavior and maintenance restraint requirements from installed evidence.

## Hydraulic challenge

A cylinder is mechanically blocked but an accumulator can recharge pressure behind the blocked piston.

Classification: **BLOCKING DOES NOT ELIMINATE REACCUMULATION**.

Reasoning: keep physical restraint and stored/reaccumulating-energy control as separate proofs. Continued verification may be necessary until the reaccumulation path is eliminated or the task ends.

## Restraint transfer gate

Removing a block/restraint is a safety-relevant state transition.

Before removal, document:

1. Why removal is required.
2. Which physical function takes over the load.
3. Evidence that the takeover function is available and appropriate.
4. Personnel clearance from the possible motion path.
5. Energy state required to perform the transfer.
6. How stale normal-control commands are prevented from causing motion during the transfer.
7. What observation proves transfer succeeded.
8. What happens if the takeover function does not prove healthy.

`test complete != safe restraint removal`

`pressure indication normal != load path proved`

`brake command on != brake mechanically proved`

## Human-factors review

If the approved restraint is heavy, inaccessible, slow to install, easy to misplace or incompatible with common service positions, treat that as an engineering defect that creates bypass pressure. Prefer designs that provide:

- a dedicated storage location at the machine;
- obvious correct orientation/contact points;
- captive/keyed features where practical;
- easy inspection;
- a visible installed/not-installed state;
- service access that does not require defeating unrelated safeguards;
- a restoration sequence that is easier to follow than improvise around.

Do not solve poor usability by normalizing work beneath an unrestrained hazardous member.

## Return-to-service reconciliation

Before release, account for:

- all temporary blocks/restraints;
- any machine-native maintenance support;
- temporary hydraulic/pneumatic plugs or caps;
- disconnected or overridden brakes/valves;
- diagnostic jumpers/forces;
- guards removed to install the restraint;
- sensors/feedback disturbed during work;
- configuration changes made for testing;
- physical evidence that the production load-holding path is restored.

A forgotten restraint can itself create a new hazard on restart. Removal therefore belongs inside controlled restoration, not informal cleanup.

## OpenPressBrake boundary

Do not assign the ordinary OpenPressBrake FPGA or LinuxCNC the job of proving a personnel-protection restraint is physically installed unless an independent safety architecture explicitly and validly uses such sensing. Ordinary control may display restraint status, service instructions or diagnostic evidence, but personnel-safety authority remains separate.

## Information-gain stop

The next OpenPressBrake-specific step requires actual machine evidence: hydraulic schematic, ram/load geometry, installed holding valves, any OEM maintenance blocks/restraints, accumulator/storage behavior and safety wiring. Until then, those fields remain `UNKNOWN` and exposed operation/maintenance states that depend on them are not cleared by this worksheet.
