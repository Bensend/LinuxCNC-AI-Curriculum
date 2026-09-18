# Accessible-cell safe-entry / restart-authority trace — 2026-09-18

Session start: 2026-09-18T13:33:06Z

## Question

What professional implementation evidence separates a request to enter an accessible safeguarded zone from proof that the hazard has ceased, permission to unlock, bodily entry, restart prevention, reset/rearm, and a later production start?

## Authoritative implementation trace

### Rockwell GuardLink / GuardLogix safety application — DOC-CONFIRMED

Rockwell Automation publication SAFETY-AT200B-EN-P (March 2026), *GuardLink Emergency Stop, Door Monitoring, and Door Unlock Via GuardLogix Safety Controller Safety Function Application Technique*, exposes an unusually useful portion of this chain in named safety logic.

The documented safety program distinguishes:

- `SafetyReset_REQD`: need for a safety reset;
- `SafetyIn_Ok`: safety inputs in run-ready state;
- `Safety_RunPerm`: conditions enabling safety outputs;
- `Safe_State`: conditions declaring the zone ready for safe entry;
- an unlock request that removes the safety run permissive;
- safe-state confirmation based on contactors being OFF for the configured timer interval before safe entry is declared;
- guard-lock feedback and reset behavior in the safety task.

The Rockwell DCSTL safety instruction independently documents the same architectural distinction: it monitors dual-channel stop inputs and lock feedback, accepts an unlock request, but does not issue unlock while the hazard is present. Its safety output requires both safety inputs in the required state and the required reset actions.

This is strong evidence that `unlock request` is not itself safe-entry proof and that guard locking belongs downstream of safety-side hazard-state reasoning rather than ordinary application convenience.

Sources:

- Rockwell Automation, SAFETY-AT200B-EN-P, March 2026, GuardLink Emergency Stop, Door Monitoring, and Door Unlock Via GuardLogix Safety Controller Safety Function Application Technique.
- Rockwell Automation Studio 5000 safety instruction reference, Dual Channel Input Stop with Test and Lock (DCSTL).

### Pilz accessible-gate evidence — DOC-CONFIRMED

Pilz documents personnel-protection guard locking for machines with hazardous overrun: the gate is not to open until hazardous machine movement has stopped, and restart is not possible until the gate is closed and locked. PSENmlock accessible-gate hardware can incorporate an inside escape release and a lockout bar for up to five personal padlocks to prevent unintended restart while people are inside.

Pilz also documents a separate key-in-pocket maintenance safeguarding architecture in which the plant cannot restart until the last registered person has left the danger zone.

These mechanisms provide distinct evidence domains: safe-to-unlock, physical escape, and retained-person/restart-prevention state are not interchangeable.

Sources:

- Pilz, PSENmlock handle-module / safety locking device documentation.
- Pilz, safety switches with guard locking documentation.
- Pilz PSS 4000 key-in-pocket release 1.25 documentation.

## Frozen authority ladder

**STOP/UNLOCK REQUEST != SAFETY OUTPUTS REMOVED != FINAL ELEMENTS OBSERVED OFF != SAFE-STATE/ENTRY CONDITION ESTABLISHED != GUARD UNLOCKED != PERSON ENTERED != PERSONNEL CLEAR != GUARD CLOSED != GUARD LOCKED != SAFETY RESET/REARM COMPLETE != FRESH ORDINARY START.**

The most important implementation rule is that a normal controller request can ask for access, but it must not manufacture the safety-side fact that the hazard has ceased. Likewise, guard-closed/locked status after access cannot manufacture the fact that no person remains in a blind accessible zone.

## OpenPressBrake / LinuxCNC boundary — INFERENCE

For a future OpenPressBrake implementation, LinuxCNC/HAL or the ordinary FPGA may legitimately:

- request stop/access/unlock;
- display lock, safe-state, retained-person, reset-required, and safety-permissive diagnostics;
- inhibit ordinary production sequencing when safety authority is absent;
- require a fresh ordinary production command after safety rearm.

They must not be the sole authority for:

- deciding that hazardous energy/motion has reached the safe-entry condition;
- deciding that a personnel-protection lock may release;
- remembering that a person remains inside an accessible blind zone;
- safety reset/rearm;
- final-element safety authority.

The physical safe-state witness is machine-specific. Rockwell's example uses contactor-off state plus a configured interval. That must **not** be copied as proof that a hydraulic press brake is safe: a press brake can retain hydraulic, gravity, accumulator, or mechanically stored energy after electrical contactors are off.

## Failure-path / adversarial review

Commissioning must challenge at least these cases:

1. Unlock requested while the safety-side safe-entry condition is false: guard must remain unavailable for personnel entry.
2. Ordinary controller says STOPPED while a safety final element or monitored hazard witness disagrees: ordinary state must not create unlock authority.
3. Guard opens and a person enters, then ordinary control/network power cycles: restart-prevention state must not silently disappear.
4. Escape release is used from inside: this changes the safeguarding state but is not personnel-clear, reset, or START.
5. Guard is reclosed and relocked while a person remains registered/retained inside: production authority remains absent.
6. Safety reset is attempted while personnel-clear evidence is absent or a required safety input/final-element proof is invalid: reset/rearm must not restore authority.
7. LinuxCNC START/JOG/DOWN/ENABLE was TRUE before access and remains TRUE after safety rearm: it must not be accepted as fresh production intent.
8. Lock feedback is stuck TRUE or contradictory to physical guard state: the discrepancy must not be collapsed into a simple `door closed` diagnostic.
9. Power is lost while unlocked/occupied and restored: power restoration is not personnel-clear, safety reset, or production start.
10. A personal lock/key/restart-prevention mechanism is bypassed because it is inconvenient: treat that inconvenience as an engineering defect to remove, not as an expected operator discipline problem.

## Minimum-safe-to-operate gate

Where bodily entry can hide a person from the restart station, do not permit operation with people exposed unless the implemented architecture provides a validated means to prevent hazardous restart while a person can remain inside. A door switch alone is not adequate evidence of personnel-clear after bodily entry.

If that minimum cannot be established, experimental operation must keep people outside the danger zone and use isolation/remote operation appropriate to the residual hazard.

## Evidence classification

- DOC-CONFIRMED: Rockwell safety-task separation of unlock request, run permissive, safe-state confirmation, lock feedback and reset; Pilz hazardous-overrun guard-locking, escape-release and restart-prevention products/functions.
- INFERENCE: the reusable authority ladder and LinuxCNC/OpenPressBrake allocation above.
- TEST-CONFIRMED: none in this study.
- COMMUNITY-REPORTED: none used.
- UNKNOWN: OpenPressBrake hazard-cessation witness, stopping/overrun time, hydraulic safe-state truth table, guard geometry, personnel-clear implementation, reset location/visibility, required PL/SIL/category/DC and any machine-specific timing.

## Next evidence target

Find a complete professional accessible-cell commissioning example that continues beyond `Safe_State -> unlock` through actual bodily-entry restart prevention and then documents `personnel-clear -> close/lock -> safety reset/rearm -> separate production START`, preferably including power-cycle and failed-lock/escape-release diagnostics. Preserve the Rockwell contactor/timer mechanism as implementation-specific rather than generalizing it to hydraulic machinery.
