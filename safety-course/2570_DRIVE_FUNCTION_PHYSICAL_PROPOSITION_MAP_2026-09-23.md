# 2570 — Drive safety functions mapped to physical propositions

Session start: 2026-09-23T07:36:00Z

## Scope and evidence discipline

This lesson uses the Siemens SINAMICS S120 family as the concrete drive-safety example and an ABB published contactor emergency-stop architecture as evidence for the ordinary-drive fallback pattern. It is a teaching map, not a machine-specific certified design.

No machine-specific stopping time, brake torque, load behavior, safe distance, discharge time, PL or SIL is inferred here.

## Why the map matters

A safety-function name is useful only if the engineer can state the physical proposition it establishes and the propositions it does not establish.

The reasoning chain is:

`safety demand -> drive safety function -> controlled electrical/torque/brake behavior -> machine motion/energy consequence -> physical safe-state proposition -> validation evidence`

Skipping a link is how labels such as STO or SBC get mistaken for proof that a machine is physically safe.

## SINAMICS S120 function map

### STO — Safe Torque Off

**DOC-CONFIRMED:** Siemens exposes STO as a distinct integrated safety function.

Physical proposition supported under the documented drive architecture: torque-producing drive action is inhibited.

Does **not** by itself establish:
- shaft standstill;
- a bounded stopping time or distance;
- electrical isolation for maintenance;
- restraint of a gravity-loaded axis;
- removal of stored mechanical, hydraulic or pneumatic energy;
- personnel clearance from the hazard zone.

**Freeze:** TORQUE-PRODUCING CAPABILITY INHIBITED != MOTION PROVED STOPPED.

### SS1 — Safe Stop 1

**DOC-CONFIRMED:** Siemens distinguishes SS1 from STO. SS1 is a safe stopping process followed by the applicable torque-removal state rather than simply removing torque at the instant of demand.

Physical proposition supported only after the configured/validated stop sequence completes: a controlled stopping process is commanded/monitored according to the selected implementation before torque-producing capability is removed.

Does **not** automatically establish:
- that the machine's actual stopping distance is acceptable;
- that a mechanical brake can hold a vertical load;
- electrical isolation;
- that a guard may unlock at an arbitrary fixed time.

Actual stop time/distance remains `UNKNOWN` until applicable machine evidence exists.

### SS2 — Safe Stop 2

**DOC-CONFIRMED:** Siemens distinguishes SS2 from SS1 and STO. The intended distinction is a controlled safe stopping process followed by a monitored standstill state rather than torque removal as the final state.

Physical proposition supported under the configured architecture: the drive transitions through a controlled stop into a safety-monitored standstill condition.

Does **not** establish electrical isolation or eliminate externally stored energy. It also does not make an unverified brake or gravity load safe merely because motion is being monitored.

### SOS — Safe Operating Stop

**DOC-CONFIRMED:** SOS is a distinct monitored-motion function in the SINAMICS safety family.

Physical proposition: standstill position is safety-monitored while drive torque may remain available to maintain the state.

Consequences:
- SOS is not STO.
- A motor can remain energized while the safety function monitors that prohibited motion does not occur.
- Maintenance requiring electrical isolation cannot be justified by SOS.

**Freeze:** SAFE MONITORED STANDSTILL != DE-ENERGIZED DRIVE.

### SBC — Safe Brake Control

**DOC-CONFIRMED:** Siemens documentation states that SBC provides two-channel safety-related control of a closed-circuit holding brake and is executed with STO. Electrical faults such as a winding short or wire break can be detected under documented state-change conditions.

Siemens explicitly warns that SBC does not detect mechanical brake defects.

Physical proposition supported: the safety architecture provides the documented safe brake-command path.

Does **not** establish:
- adequate mechanical holding torque;
- actual brake friction condition;
- that the brake has physically restrained the load;
- stopping distance;
- absence of brake wear or mechanical failure.

**Freeze:** SAFE BRAKE COMMAND != MECHANICAL BRAKE EFFECT PROVED.

### SBT — Safe Brake Test

**DOC-CONFIRMED:** Siemens describes SBT as a diagnostic test that deliberately develops force/torque against the applied brake and observes whether motion stays within a parameterized tolerance. Current Siemens safety-related-brake documentation describes SBT as checking whether the brake provides the required braking effect/holding torque.

This is a stronger physical witness than brake-command state alone because the diagnostic challenges the brake mechanically.

It still does not establish permanent future brake health between tests. Test interval, required holding torque, load case and maintenance response belong to the actual SRS/validation plan.

**Freeze:** SUCCESSFUL BRAKE TEST != PERMANENT BRAKE HEALTH.

## Hazard trace A — spindle/coasting tool

Hazard: rotating spindle/tool remains hazardous after torque production is removed.

1. STO can remove torque-producing capability.
2. The spindle may coast because of inertia.
3. Therefore `STO active` is not the release proposition for access if dangerous rotation remains.
4. Possible architectures include a validated controlled safe stop, guard locking until a validated standstill condition, or another machine-specific protective measure.
5. LinuxCNC may display spindle speed/status or request a normal stop, but ordinary LinuxCNC evidence is not substituted for the independent safety function.

Required physical evidence before access release may include actual validated stopping behavior or safety-related standstill detection. Which is required is machine-specific.

## Hazard trace B — vertical/gravity axis

Hazard: a suspended or vertical load can descend when motor torque disappears.

1. STO removes the drive's torque-producing capability but does not neutralize gravity.
2. A holding brake may be part of the safety function.
3. SBC can provide a safety-related brake command path, but SBC alone does not prove mechanical holding effect.
4. SBT can provide diagnostic evidence about braking effect under its documented conditions.
5. Required brake capacity, test interval, allowable movement, redundancy and secondary restraint remain design-specific.

If those physical facts are unknown, exposed-person operation cannot be justified merely from STO/SBC status.

## Ordinary-drive fallback when certified STO is unavailable

ABB publishes an emergency-stop Category 0 example using contactors specifically for drives where built-in STO is unavailable. This supports the existence of the pattern; it does not make every contactor implementation equivalent or certified.

### Teaching architecture

`safety input(s) -> safety-related logic -> monitored contactor final element(s) -> drive/motor power path`

Normal LinuxCNC command/enable may cooperate with the stop but does not own the independent personnel-safety path.

### Design questions that cannot be skipped

**Contactor placement.** A line-side contactor removes source power to the drive, but stored DC-bus energy can remain after opening. A motor-side contactor has different drive/manufacturer restrictions and switching-duty consequences; arbitrary opening under load must not be assumed acceptable.

**Stored energy.** `Contactor open` does not prove `DC bus safe`. Maintenance isolation and hazardous-motion control are different propositions.

**Welded contacts and feedback.** Appropriate mirror/force-guided feedback can support detection of covered contactor failures. Auxiliary feedback is a witness to a defined contact relationship, not proof that the shaft stopped or that all energy is gone.

**Switching duty.** The selected final element must be suitable for actual voltage, current, utilization category, inrush, inductive behavior and expected switching frequency. A headline amp rating is insufficient.

**Restart behavior.** Restoration of power after a safety demand must not itself authorize hazardous restart. Safety reset/rearm and normal Cycle Start remain distinct events.

**Drive recovery.** The drive's power-up/recovery behavior must be analyzed so a retained normal command cannot produce unexpected motion after the safety path is restored.

### What this fallback can and cannot claim

It can teach how independent safety logic can remove drive/motor power using monitored final elements when integrated STO is absent.

It cannot claim equivalence to a particular certified STO implementation without complete component, architecture, reliability, fault, systematic and validation evidence.

**Freeze:** CONTACTOR POWER REMOVAL != INTEGRATED STO BY LABEL SUBSTITUTION.

**Freeze:** CONTACTOR OPEN != DC BUS PROVED SAFE.

**Freeze:** SAFETY RESET != NORMAL MOTION START AUTHORIZATION.

## Practical low-cost rule

For retrofit machines, the inexpensive path should still make the safe architecture easy to understand and difficult to bypass: a clearly separate safety chain, appropriately selected monitored final elements, explicit reset/restart behavior, and visible diagnostics. Do not hide personnel-safety authority inside ordinary LinuxCNC HAL because doing so is cheaper in wires.

If the machine lacks adequate evidence that hazardous motion is controlled, do not operate it with people exposed to the hazard. Experimental operation must be isolated/remote until the missing physical propositions are established.

## Evidence ledger

- SINAMICS S120 provides distinct STO, SS1, SS2, SOS, SBC and SBT functions: `DOC-CONFIRMED`.
- SBC is two-channel safety-related brake control and does not detect mechanical brake defects: `DOC-CONFIRMED`.
- SBT challenges brake effect/holding torque under documented conditions: `DOC-CONFIRMED`.
- ABB documents a contactor-based Category 0 emergency-stop architecture for drives without built-in STO: `DOC-CONFIRMED`.
- Actual spindle coast time, vertical-axis load behavior, brake capacity, contactor release time, DC-bus discharge time and safe distance for any particular machine: `UNKNOWN` until applicable evidence exists.
- Whether a particular retrofit architecture achieves a specified PL/SIL: `UNKNOWN` until the complete safety function is designed and evaluated.

## Authoritative sources

- Siemens, *Safety Integrated Commissioning Manual with SINAMICS S120*, including SBC/SBT behavior and warnings.
- Siemens, *Safety-related brake*, Operating Instructions, 08/2024, including SBC and SBT descriptions.
- Siemens, current SINAMICS S120 product documentation listing integrated safety functions.
- ABB, *How to implement an emergency stop, category 0, using ABB drives with a contactor*, 3AUA0000172867.

## Next evidence-gain step

Build the 2570 adversarial assessment around three superficially plausible but physically different machines: a high-inertia spindle, a gravity-loaded axis, and an ordinary VFD retrofit without certified STO. Force the learner to choose and defend the physical safe-state proposition, safety function, final element, diagnostic witness, reset/restart behavior and required validation evidence without inventing stopping/brake data.
