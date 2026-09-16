# Safety Reset Location, Blind-Spot Confirmation, and Remote-Reset Defeat Resistance

Date: 2026-09-16

## Purpose

This module follows the whole-body-access/trapped-person study. Its central rule is that **a cleared protective device is not evidence that an accessible safeguarded space is empty, and a reset request is not permission to start hazardous motion**.

The design must keep these states distinct:

`protective_device_clear` -> `whole_space_checked` -> `reset_request` -> `reset_accepted` -> `safety_permission` -> `ordinary_rearm` -> `start_request` -> hazardous operation.

A design that collapses these into one `safe`, `reset`, or `run` bit hides the exact failure paths that matter for whole-body access.

## Evidence ledger

### DOC-CONFIRMED — reset transition is a real safety-control event

Rockwell's GuardLogix Dual-Channel Input Stop with Test documentation states that with manual restart the Reset input is used only after both safety channels are active; it also notes that some safety standards require monitoring a transition of the reset input. This supports deliberate edge/sequence semantics rather than accepting a permanently asserted reset signal.

Source: Rockwell Automation, `Dual-Channel Input Stop with Test (DCST)` documentation, accessed 2026-09-16.

### DOC-CONFIRMED — automatic restart is application-dependent, not a universal default

Rockwell's Safe Operating Stop documentation distinguishes MANUAL and AUTOMATIC restart and explicitly cautions that Automatic Restart should only be used where the application determination shows it does not create unsafe conditions. It separately defines cold-start behavior after controller power or a mode change.

Source: Rockwell Automation, `Safe Operating Stop (SOS)` documentation, accessed 2026-09-16.

### DOC-CONFIRMED — safety-device clear and correct reset actions are separate conditions

Rockwell's DCST and DCSTL safety-instruction documentation describes output permission as dependent on active safety inputs **and** the correct reset actions. DCSTL additionally separates lock feedback and unlock request, reinforcing the wider course rule that one sensor/status bit must not stand in for all physical safety conditions.

Sources: Rockwell Automation DCST and DCSTL documentation, accessed 2026-09-16.

### DOC-CONFIRMED — whole-body access may require explicit blind-spot checking

The preceding curriculum artifact `WHOLE_BODY_ACCESS_TRAPPED_PERSON_RESTART_PREVENTION.md` records Pilz Key-in-pocket guidance that large plants without an overall view require a blind-spot check. This module inherits that evidence rather than treating a closed gate as proof of an empty space.

## Engineering contract

### 1. `protective_device_clear`

Means only that the relevant protective device currently reports its normal/clear condition according to its validated safety function. Examples may include a closed interlocked guard or an unbroken presence-sensing field.

It does **not** prove:

- nobody is inside a whole-body-access zone;
- all blind spots were inspected;
- every person/key/token is accounted for;
- hazardous energy is isolated;
- stored energy is dissipated;
- reset should be accepted;
- motion should restart.

### 2. `whole_space_checked`

This is evidence associated with the actual accessible space and the selected restart-prevention architecture. It may come from a validated presence-sensing arrangement, a personnel/key accounting system, a deliberate inspection procedure, or another engineered method appropriate to the machine.

Do not invent a universal implementation. Scanner geometry, occlusion, minimum object detection, blind spots, reach-over/reach-under paths, reflective behavior and required coverage are physical validation questions.

### 3. `reset_request`

A deliberate request to reset the safety function. A stuck, taped, software-forced, network-held, or continuously true reset must not silently satisfy a design that requires a deliberate transition.

A remote HMI button is not automatically equivalent to a correctly located physical reset station merely because the command arrives as the same Boolean value.

### 4. `reset_accepted`

Acceptance is conditional. At minimum the relevant safety demand/fault must have cleared and all required restart-prevention evidence must be valid. For whole-body-access systems this may include evidence beyond `guard_closed`.

Reset acceptance must not itself command hazardous motion.

### 5. `safety_permission`

This is the output of the independent safety-related control architecture after its required conditions are satisfied. It remains distinct from ordinary LinuxCNC enable/rearm/start state.

### 6. `ordinary_rearm` and `start_request`

LinuxCNC or the normal FPGA/controller may own ordinary machine rearm and start sequencing **after** the independent safety architecture permits operation. A stale pre-existing start/jog/cycle command must not become an accidental restart simply because safety permission returns.

## Reset-station placement reasoning

The course must teach placement as a hazard-observation problem, not as a universal distance number.

A reset station for a whole-body-access area should be evaluated against questions such as:

- Can the person performing the reset determine that the relevant danger zone is clear using the validated architecture/procedure?
- Are there blind spots, internal compartments, elevated platforms, pits, tooling, fixtures, robots, transfer mechanisms, or adjacent cells that defeat that assumption?
- Can a person inside the hazard zone actuate the reset in a way that defeats the intended external confirmation?
- Can a remote HMI/network client issue the same reset without the required observation/accounting step?
- Is the reset control so inconveniently placed that operators are likely to defeat, jumper, automate, or delegate it without checking the space?
- After reset, is a separate normal start action still required?

**INFERENCE:** Where the safety concept relies on human visual confirmation, a reset control that can be operated without performing that confirmation defeats the intended evidence chain even if the reset input itself is electrically safety-rated. Exact placement and visibility requirements remain application/standard/design specific.

## Remote-reset threat model

Treat remote reset as a potential bypass path, not merely a UI convenience.

Adversarial cases:

1. HMI reset is reachable from a location with no view of a whole-body-access zone.
2. SCADA/API/network logic writes reset automatically when guards close.
3. A PLC/HMI tag remains true continuously and therefore masks the intended deliberate reset transition.
4. Controller reboot restores a retained reset/start request.
5. A technician temporarily adds a remote reset for commissioning and it remains enabled in production.
6. Multiple reset stations exist but only one supports the required observation/accounting procedure.
7. An operator asks for automatic reset because walking to the station is inconvenient.
8. Camera video is substituted for direct/validated confirmation without analyzing latency, field of view, blind spots, failure indication, frozen image, or authorization.

The safer path should also be the easier normal path: locate and design reset/inspection controls so legitimate operation is efficient without encouraging defeat. Repeated nuisance walking or awkward access that predictably causes bypass attempts is a design problem to solve, not merely an operator-discipline problem.

## Power-loss and reboot cases

Power restoration, safety-controller restart, LinuxCNC restart, FPGA restart and HMI restart must be analyzed independently.

Do not assume that rebooting any ordinary controller proves the protected space is empty. If personnel/accounting evidence is lost or becomes indeterminate, the restart-prevention architecture should fail closed until its defined recovery procedure establishes valid state again.

A normal-control reboot must not transform retained `start`, `jog`, `cycle-start`, or reset state into hazardous motion immediately when safety permission later returns.

## Machine-family transfer

### Mill / lathe enclosure

A simple interlocked door may be reach-in access or whole-body access depending on physical design. Do not generalize. If a person can enter and become hidden, `door_closed` cannot be taught as `space_clear`.

### Plasma / cutting cell

Fencing may surround a large travel envelope with gantry motion, torch energy and ancillary equipment. Reset placement must consider the actual accessible cell and occlusions, not merely the controller console.

### Robot / automated cell

Large cells commonly create blind spots and multiple access points. Personnel accounting, trapped-key/key-in-pocket patterns, presence sensing, reset stations and zone partitioning may all be relevant, but the exact architecture must be validated for the cell.

### Press brake

Do not import a robot-cell whole-body-access rule automatically. Many press-brake safeguarding tasks are point-of-operation/reach-in problems rather than entry into a fenced cell. If a particular installation does have rear/side whole-body access or an integrated cell, analyze that zone explicitly. Do not invent machine-specific stopping distance, hydraulic safe state, guard geometry or reset rule.

## Learner/evaluator cases

A learner should reject each unsafe shortcut and identify the missing evidence:

- "The gate switch says closed, so reset and restart automatically."
- "Put reset on the HMI so maintenance can do it from anywhere."
- "The safety PLC rebooted cleanly, therefore nobody can still be inside."
- "The scanner is clear, therefore the whole cell is empty" when its validated field does not cover the whole accessible volume.
- "Keep reset permanently high so operators do not need to press it."
- "After reset, restore the cycle-start bit that was active before the guard opened."

Expected reasoning must distinguish device clear, whole-space evidence, reset request/acceptance, safety permission, ordinary rearm and ordinary start.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the ordinary FPGA may:

- display safety status;
- inhibit ordinary commands;
- discard stale commands on safety loss;
- require normal-control rearm;
- log reset/restart events;
- provide diagnostics about which prerequisite is missing.

They must not be taught as the sole personnel-safety authority for declaring a whole-body-access space clear, accepting a safety reset, or bypassing required independent safety evidence.

## Unknowns that must remain explicit

- exact reset-station placement for any specific machine;
- whether direct line-of-sight is required or sufficient in a specific application;
- scanner/light-curtain field geometry and protective distance;
- safety category, PL, SIL or diagnostic coverage of a complete design;
- reset timing/debounce values;
- machine-specific stopping time or stored-energy decay;
- whether a specific press brake constitutes whole-body access at a given zone.

These require the applicable standards, validated safety design, manufacturer instructions and/or physical measurement.

## Practical minimum

If a whole-body-access hazard zone can contain a person after its access guard closes and the design has no defensible means to prevent restart while that person may remain inside, **do not operate the machine with people exposed to that hazard**. Experimental operation must keep people outside the danger zone through isolation/remote methods appropriate to the experiment, with residual risk stated explicitly.

## Next evidence branch

Study **lost personnel-key / administrative safety-state recovery**: fail-closed behavior after lost keys/tokens, corrupted or erased personnel accounting state, controller replacement/reboot, exceptional authorized list reset, and the boundary between an administrative recovery action and proof that the physical safeguarded space is actually empty.
