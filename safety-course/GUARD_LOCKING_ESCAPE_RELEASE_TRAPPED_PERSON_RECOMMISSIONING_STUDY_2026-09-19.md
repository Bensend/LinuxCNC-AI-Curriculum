# Guard locking, escape release, trapped-person and recommissioning study

Date: 2026-09-19
Lane: independent safety curriculum B

## Why this branch

The primary lane is currently advancing hydraulic press-brake two-hand reach/stopping evidence. This branch intentionally uses different devices, evidence, and files: accessible guard locking, trapped-person escape, lockout, and recommissioning authority.

## Evidence

### Pilz — safety locking architecture
Evidence class: **DOC-CONFIRMED**.

Pilz distinguishes process guard locking from personnel-protection guard locking. For personnel protection, unlocking is conditional on the hazardous machine function having ceased; accessible safeguarded spaces can require an escape release so a person accidentally locked inside can stop/escape. Pilz also states restart is not possible while the gate is open and guard locking is not restored.

Sources:
- Pilz, `Safety locking device` technical explanation.
- Pilz, `Safety switches with guard locking for gates`.

### Pilz PSENmlock DHM escape release
Evidence class: **DOC-CONFIRMED**.

The PSENmlock DHM operating manual provides a particularly useful complete recovery detail. Operating the inside escape release mechanically unlocks the gate and drives safety outputs 12/22 low. Recommissioning is not described as merely closing the door: the manual requires returning the escape-release control, acknowledging the stop signal in the controller, and performing an escape-release function test by qualified personnel.

Source: Pilz `PSEN_ml_sa_DHM_Op_Man__1005457-EN-05`, section 4.9.1.

### SICK TR110 Lock
Evidence class: **DOC-CONFIRMED**.

SICK documents both power-to-release and power-to-lock guard-locking principles. For power-to-release, loss of magnet power leaves the guard locked; SICK explicitly warns this can trap people and directs the designer to avoid closing the guard with people inside or use an escape-release variant. TR110 also separately monitors door and locking state through safety outputs.

Source: SICK TR110 Lock operating instructions `8023119/1K8B/2023-09-15`, section 4.4.1.

### SICK safe-machinery guidance
Evidence class: **DOC-CONFIRMED**.

SICK distinguishes three manual unlocking concepts that must not be conflated: emergency release from outside without tools, auxiliary release from outside using a tool/key for malfunction handling, and escape release from inside without tools so a person can leave the protected area.

Source: SICK `Guide for Safe Machinery`, 2024-03-13.

## Frozen architecture boundaries

`GUARD CLOSED != GUARD LOCKED != LOCKING SAFETY FUNCTION VALID`

`LOCKING SOLENOID COMMANDED != LOCK MECHANICALLY ENGAGED != LOCK STATE SAFELY MONITORED`

`HAZARDOUS MOTION COMMAND OFF != HAZARD CEASED != GUARD MAY BE UNLOCKED`

`ESCAPE RELEASE OPERATED != ORDINARY DOOR REQUEST`

`ESCAPE RELEASE RESTORED != SAFETY FUNCTION RECOMMISSIONED != PRODUCTION AUTHORITY RESTORED`

`AUXILIARY RELEASE != EMERGENCY RELEASE != ESCAPE RELEASE`

`POWER FAILURE != UNIVERSALLY SAFE UNLOCK`: the locking principle and trapped-person hazard matter.

## OpenPressBrake architecture lesson

LinuxCNC/HAL and the ordinary FPGA may request access and display door/lock diagnostics, but they must not become the sole personnel-safety authority deciding that hazardous motion has ceased and an access guard may safely unlock. The credited safety path must own the personnel-protection decision and its final elements.

An accessible enclosure also creates a different hazard from a small non-enterable cover: a person can remain inside after the exterior guard appears closed. Escape/restart prevention therefore belongs in the hazard architecture rather than being treated as a convenience accessory.

## Failure-path / commissioning worksheet

1. Demand access while hazardous motion/energy has not reached the validated safe condition: personnel-protection locking must not release merely because ordinary control requests the door.
2. Remove control power from a power-to-release lock with a person inside: verify the chosen architecture does not create an unaddressed trapping hazard.
3. Operate the inside escape release: verify physical egress is possible and the safety path transitions to its defined non-production state.
4. Restore the escape-release handle without performing the documented recommissioning sequence: production authority must not be assumed merely from mechanical restoration.
5. Close the gate while the lock has not safely engaged: hazardous production must remain inhibited.
6. Simulate disagreement between door-closed and lock-monitored state: diagnose the disagreement and withhold the credited hazardous function.
7. Use an auxiliary/manual service release: verify it is not mislabeled or relied upon as trapped-person escape unless the actual device/application supports that claim.
8. Power cycle the controller while the gate is closed but escape/recommissioning state is unresolved: do not infer personnel clear or production-ready from startup state alone.
9. Hold stale LinuxCNC START/JOG/CYCLE intent through guard/escape recovery: safety restoration must not accidentally manufacture fresh ordinary motion authority unless the validated machine-specific restart design explicitly permits it.
10. After service/replacement of the guard-locking device, exercise the actual door, lock monitoring, escape release, safety reaction, and restart inhibition before crediting the function again.

## Evidence status

- **DOC-CONFIRMED:** professional devices distinguish guard closed, guard locked, escape release, and controller/recommissioning state.
- **DOC-CONFIRMED:** an inside escape release can directly unlock an accessible guard and force safety outputs low.
- **DOC-CONFIRMED:** at least one professional implementation requires stop acknowledgement plus a qualified functional escape-release test before recommissioning.
- **INFERENCE:** OpenPressBrake should preserve these state separations if an accessible locked guard is ever credited.
- **UNKNOWN:** whether OpenPressBrake requires personnel-protection guard locking at all.
- **UNKNOWN:** required locking principle, guard geometry, access time, hazardous overrun, escape-release topology, reset location, personnel-clear method, PL/SIL/category/DC/CCF, and machine-specific restart semantics.

## Compute decision

No simulation or executable test is justified for this evidence step. Software compute cannot prove physical egress, locking force, actual hazardous overrun, or person-clear conditions. No GitHub-hosted runner is used.

## Next independent evidence target

Find a complete professional accessible-cell implementation exposing `access request -> independent safety evaluator -> physical hazardous-state witness -> guard unlock -> person enters -> inside escape/lockout or retained-person protection -> guard close/lock -> personnel-clear/restart interlock -> safety reset/rearm -> application-specific ordinary production authority`, preferably with a documented power-loss or trapped-person commissioning test. Do not assign OpenPressBrake-specific timing, locking force, or restart behavior until measured/validated.