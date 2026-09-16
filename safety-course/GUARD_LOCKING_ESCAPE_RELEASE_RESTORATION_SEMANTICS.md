# Guard Locking, Escape Release, and Restoration Semantics

## Purpose

Teach guard locking as a personnel-protection architecture problem, not as a generic `door_locked` bit. This study separates guard-position monitoring, guard-lock monitoring, the lock's energy principle, escape/auxiliary release, hazardous-motion evidence, reset, and ordinary production rearm.

## Evidence vocabulary

Use the curriculum provenance labels exactly: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A product manual may establish how a specific device behaves. It does not establish the complete machine safety function, stopping time, safe unlock instant, required protective distance, hydraulic state, or suitability for OpenPressBrake.

## Authoritative source trace

### Rockwell 440G-LZ family

`SOURCE-CONFIRMED` — Rockwell Automation, *440G-LZ Guardmaster Guard Locking Switch User Manual*, publication 440G-UM001D-EN-P (Nov. 2021), distinguishes two lock-energy principles:

- **Power to Release:** the locking bolt is extended when the guard is closed/aligned; applying 24 V to the lock control withdraws the bolt. If power is removed while locked, the bolt remains locked; manual auxiliary release is required to unlock without power.
- **Power to Lock:** applying 24 V locks; removing that command unlocks. Loss of power while locked therefore unlocks the switch.
- In either type, the locking bolt does not extend without the actuator present.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440g-um001_-en-p.pdf

This is a crucial architecture choice, not a naming preference. A machine whose hazard persists after power loss cannot assume that a power-to-lock device remains a physical barrier after loss of electrical power.

### Rockwell 440G-MZ family

`SOURCE-CONFIRMED` — Rockwell's current 440G-MZ product documentation describes two models: Power to Release for personnel-safety applications and Power to Lock for machine-protection applications, with optional escape release for full-body-access applications.

Source: https://www.rockwellautomation.com/en-in/products/hardware/safety-products/440g-mz.html

`SOURCE-CONFIRMED` — Rockwell *Guardmaster Guard Locking Switch User Manual*, publication 440G-UM004H-EN-P (Feb. 2026), states that operating the escape release turns the safety outputs OFF and causes a fault condition. The escape release must be accessible only from inside the safeguarded area. After installation and after maintenance/component changes, a manual functional test of the escape release is required. Restoring the escape-release button does not silently restore normal operation; the device fault must be reset by the documented method.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440g-um004_-en-p.pdf

### EUCHNER CTP/TZ examples

`SOURCE-CONFIRMED` — EUCHNER documents its closed-circuit-current / power-to-unlock principle as spring-force locking with solenoid-force unlocking. Its escape release is intended for manual release from inside the danger zone without tools.

Sources:
- https://www.euchner.de/en-us/a/126912/
- https://www.euchner.de/en-us/a/095992/

`SOURCE-CONFIRMED` — EUCHNER separately describes an **auxiliary release** for access after malfunction/power failure, operated with a tool/key and protected against misuse. This is not the same human-factors function as an escape release intended for a person trapped inside the safeguarded space.

## Frozen architecture distinctions

Do not collapse these into one state:

1. **Guard physically closed** — geometry/actuator is in the closed position.
2. **Guard-position safety function satisfied** — the safety system has valid evidence that the guard position condition is satisfied.
3. **Guard lock physically engaged** — the locking mechanism is engaged.
4. **Guard-lock safety function satisfied** — the safety system has valid evidence of the required locked state.
5. **Hazardous motion/energy at the required safe condition** — separate evidence. A locked guard does not prove the machine has stopped; a stopped command does not prove the guard may be unlocked.
6. **Unlock permission** — produced by the personnel-safety architecture from the actual machine safety requirements, not merely by LinuxCNC requesting door access.
7. **Escape release operated** — emergency egress action from inside the safeguarded area; treat as a safety-significant state/fault requiring deliberate restoration.
8. **Auxiliary/manual release operated** — maintenance/recovery action; protect against casual use and require restoration/verification before production.
9. **Safety reset accepted** — clears a latched safety/fault state only after prerequisites are satisfied.
10. **Ordinary production rearm/start** — separate deliberate action after safety reset; never a side effect of closing/relocking the guard.

## Power-loss question

The learner must explicitly ask: **what happens to the physical lock when power is lost, and what hazards can still exist at that instant?**

A power-to-release lock tends to remain locked on loss of its release power, but that fact alone does not prove the machine is safe, that emergency egress is adequate, or that every application should use that principle. A power-to-lock device can unlock when power is removed; that may be appropriate for machine protection but is a critical failure-path question when the guard is relied on to prevent access to a persisting personnel hazard.

Machine-specific run-down time, hydraulic pressure decay, gravity hazard, stored mechanical energy, brake behavior, and safe-unlock timing are `UNKNOWN` until measured or otherwise evidenced for the actual machine.

## Authority separation for LinuxCNC/OpenPressBrake

LinuxCNC and the ordinary OpenPressBrake FPGA may:

- request access/unlock as a normal-control intent;
- report guard/lock diagnostics to the HMI;
- inhibit ordinary cycle commands more conservatively than the safety system;
- record timestamps, faults, and maintenance events.

They may **not** be treated as the sole personnel-safety authority for:

- deciding that hazardous motion has ended;
- energizing a safety lock solely because a UI bit says `SAFE`;
- bypassing guard-position or lock monitoring;
- converting a communications/watchdog recovery into unlock permission;
- converting guard closure/relock into automatic restart.

A safe architecture can accept a normal-controller request while the independent safety function retains final authority to refuse release.

## Restoration sequence contract

Exact implementation is machine-specific, but curriculum reasoning must preserve this ordering relationship:

`hazard removed/controlled and independently witnessed -> release permitted -> guard may unlock/open`

After escape/auxiliary release or a guard-lock fault, return toward production must require evidence appropriate to the actual safety function. A generic teaching state model is:

`HAZARD_CONTROLLED -> ACCESS_PERMITTED -> GUARD_OPEN -> GUARD_CLOSED -> LOCK_ENGAGED -> SAFETY_CONDITIONS_VERIFIED -> SAFETY_RESET -> PRODUCTION_REARM`

This is not a machine truth table. It is a reasoning scaffold. Any state whose required physical evidence is unavailable remains `UNKNOWN` and must not be promoted to safe by command echo or HMI indication.

## Validation questions

For each guarded hazard, record:

- Why is guard locking needed instead of guard-position monitoring alone?
- What physical hazard can persist after the stop request?
- What independent evidence authorizes unlock?
- Which lock principle is used, and what happens on loss of power?
- Can a person become trapped inside? If yes, what egress function exists and from where is it operable?
- Can auxiliary/manual release be misused from outside? How is misuse made difficult and detectable?
- Are guard-position and lock-state evidence independent enough for the claimed safety function?
- What happens if the lock command changes but the physical lock feedback does not?
- What happens if the guard closes while start is held?
- What happens after escape release, auxiliary release, power cycle, communications recovery, or safety-controller reset?
- What physical/functional tests are required after installation, maintenance, adjustment, or replacement?

## Adversarial curriculum cases

1. **Power-to-lock loss of power:** hazardous run-down continues but the lock loses power. Learner must not assume the barrier remains locked.
2. **Locked therefore stopped:** lock feedback is valid while motion feedback is absent. Hazard state remains `UNKNOWN`.
3. **Stopped command therefore unlock:** LinuxCNC reports motion disabled but no independent safe-condition witness exists. Unlock claim fails.
4. **Escape release then instant restart:** escape release is restored and guard is reclosed. Automatic cycle continuation is rejected; fault/reset/rearm semantics remain separate.
5. **Escape release reachable from outside:** installation permits convenient external operation. Treat as a defeat path, not merely an operator-training issue.
6. **Auxiliary release left active:** maintenance used a tool release but restoration was never verified. Production rearm must be blocked by the validation process/state architecture.
7. **Held start during guard closure:** guard closes and locks while the start input remains asserted. Relock/reset must not itself create hazardous motion.
8. **Stale unlock request after reconnect:** LinuxCNC/network recovers with an old access request. Fresh normal intent does not substitute for current safety permission.
9. **Lock indicator equals lock proof:** HMI LED/diagnostic bit says locked but independent lock evidence is contradictory. Do not promote the display to physical proof.
10. **Device rating equals machine claim:** a SIL/PL-capable switch is selected. Learner must still leave whole-machine performance and suitability unclaimed until the complete function is validated.
11. **Replacement device changes energy principle:** a nominally similar switch changes power-to-release/power-to-lock behavior. Prior validation evidence is invalidated and change control is required.
12. **Hydraulic press assumption:** someone proposes a specific safe-unlock delay for OpenPressBrake without measured stopping/pressure/gravity evidence. Required answer is `UNKNOWN`, with a verification plan rather than an invented delay.

## Minimum learner conclusion

Guard locking is an access-control safety function layered on top of hazard control; it is not proof of hazard removal. Escape release, auxiliary release, lock feedback, safety reset, and production restart have different purposes and must remain distinguishable. The ordinary LinuxCNC/FPGA control plane may request and observe these states, but personnel-safety authority must not depend solely on ordinary software, network freshness, or a UI status bit.

## Evidence status

- Guard-lock energy-principle behavior above: `SOURCE-CONFIRMED` for the cited product families.
- Escape-release behavior and post-release fault/reset behavior: `SOURCE-CONFIRMED` for the cited 440G-MZ family.
- Separation of normal-control request from independent personnel-safety permission: `INFERENCE`, architecture rule derived from the curriculum safety boundary and source behavior.
- OpenPressBrake safe-unlock timing, stopping distance, hydraulic state, residual pressure, gravity behavior, and required performance level: `UNKNOWN` pending machine-specific evidence.
