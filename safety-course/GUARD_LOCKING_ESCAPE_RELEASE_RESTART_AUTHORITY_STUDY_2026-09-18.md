# Guard locking, escape release, and restart authority study — 2026-09-18

## Scope and parallel-lane selection

Lane B selected guard-locking/escape-release/restart authority because the primary safety lane's newest durable work is the dual-brake sequential-proof and masking branch. This file does not modify that gravity-axis evidence package and does not claim any OpenPressBrake guard geometry or stopping performance.

Evidence labels used here: **SOURCE-CONFIRMED**, **DOC-CONFIRMED**, **TEST-CONFIRMED**, **COMMUNITY-REPORTED**, **INFERENCE**, **UNKNOWN**.

## Why this boundary matters

A movable guard can have several distinct truths that are easy to collapse into one HMI bit:

**GUARD CLOSED != GUARD INTERLOCK VALID != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

For an accessible guarded space, an escape-release event adds another state transition that must not be treated as an ordinary door-open/door-close cycle.

## Professional evidence

### SICK — Guide for Safe Machinery and flexLock

**DOC-CONFIRMED.** SICK's Guide for Safe Machinery distinguishes release of guard locking by time control, automatic release based on absence of a dangerous machine condition, and manual release where the delay before release must exceed the hazardous-function stopping time. It separately distinguishes auxiliary release, emergency release, and escape release. Escape release is specifically manual unlocking without tools from within the protected area so a person can leave.

**DOC-CONFIRMED.** SICK flexLock states that manual unlocking causes the safe OSSDs to switch OFF and requires a stop command. It requires the escape release to be manually operable without tools from inside the hazardous area and installed so it cannot be operated from outside. After manual unlocking, a function check is required.

These facts establish that `unlock` is not merely a convenience command. Personnel-protection locking has a machine-state dependency, and manual/escape release changes the safety state.

### Pilz — PSENmlock

**DOC-CONFIRMED.** Pilz states that where hazardous overrun exists, the safety gate cannot be opened until hazardous machine movement has stopped, and restart is not possible until the gate is closed and locked.

**DOC-CONFIRMED.** Pilz PSENmlock provides an escape release for accessible gates. Its handle-module documentation says escape release directly unlocks the gate and drives safety outputs 12 and 22 LOW. Recommissioning then requires restoring the escape-release button, acknowledging the stop in the controller, and carrying out an escape-release function test by qualified personnel.

**DOC-CONFIRMED.** Pilz distinguishes product variants after escape release: power-reset versions require supply reset, while automatic-reset versions restore the device state after the escape release is restored and the safeguard is closed. This device reset behavior must not be confused with machine restart authority.

### Rockwell Automation — Guardmaster guard locking

**DOC-CONFIRMED.** Rockwell's 440G guard-locking manual states that escape release turns safety outputs OFF and creates a fault condition. The escape release must only be accessible from inside the safeguarded area, and Rockwell requires a manual functional test after installation and after maintenance/component changes.

**DOC-CONFIRMED.** A Rockwell 440G-LZ example delays unlocking after E-stop; the documented application explicitly says the risk assessment must determine adequate delay for the machine to reach a safe state before gate unlock. After leaving and closing the gate, a Reset is used to lock the gate and return toward production state.

## Frozen architecture rules

1. **GUARD CLOSED != GUARD LOCKED.** A closed-position witness is not proof that personnel-protection guard locking is engaged.
2. **STOP REQUESTED != HAZARD CEASED != UNLOCK AUTHORIZED.** Where guard locking protects against hazardous overrun, unlock authority must depend on the validated safety concept's safe-state/stop determination, not on LinuxCNC merely having issued STOP.
3. **ESCAPE RELEASE OPERATED -> SAFETY STATE CHANGES.** Escape release is an intentional emergency egress path, not an ordinary production door command.
4. **ESCAPE RELEASE RESTORED + GUARD CLOSED != PERSONNEL CLEAR != PRODUCTION RESTART.** Restoring the device cannot by itself prove that nobody remains inside an accessible space.
5. **DEVICE RESET != MACHINE RESET != ORDINARY START.** Manufacturer-specific device recovery may include power reset, automatic device reset, controller acknowledgement, or function check; none is fresh production motion intent by itself.
6. **LINUXCNC/HAL/ORDINARY FPGA MAY DISPLAY OR REQUEST; IT MUST NOT BE SOLE PERSONNEL-SAFETY AUTHORITY.** Ordinary control may request stop/unlock and consume safe diagnostics, but cannot manufacture the personnel-protection unlock/restart permissive from application state alone.

## Failure-path analysis

### A — LinuxCNC says stopped but physical hazardous state is not proved

`ordinary STOP -> LinuxCNC idle -> guard unlock request`

**INFERENCE:** If the safety concept requires hazardous overrun to cease before unlocking, application-idle state alone is insufficient. The safety-side release condition must use the validated stop/safe-state evidence for that machine.

OpenPressBrake stopping time, safe-speed/standstill method, hydraulic state, and guard-locking requirement are **UNKNOWN**.

### B — Escape release used with a person inside

`escape release -> guard unlocks -> safety outputs OFF / stop path invoked -> person exits`

After the person exits:

`escape release restored -> guard closed/locked -> device recovery`

must not be shortened to:

`device healthy -> immediate motion`.

For an accessible enclosure, personnel-clear/restart-prevention requirements remain separate. Existing curriculum personnel-retention rules still apply.

### C — Escape release stuck or incompletely restored

A stuck release, broken linkage, or disagreement between lock/guard diagnostics must not be hidden by a simple `door closed` indication. The commissioning procedure must verify the physical escape mechanism and the safety outputs/diagnostics expected by the selected device.

### D — Power loss / restoration

Pilz documents different power-reset and automatic-reset device behaviors. Therefore **INFERENCE:** machine-level logic must not assume all guard locks recover identically after power restoration. The selected device's documented state machine is part of commissioning evidence.

### E — Stale ordinary START/JOG/CYCLE

If ordinary control had START/JOG/CYCLE asserted before guard opening or escape release, restoring guard-lock safety authority must not reinterpret that stale state as fresh operator intent. Require the machine's independent reset/rearm sequence and a separate fresh ordinary start action where applicable.

## Question-driven commissioning card

Do not execute these on a hazardous machine without the machine-specific validated procedure and safe test conditions.

1. Open-request while hazardous motion/state is still present: verify guard locking does not release merely because LinuxCNC reports idle.
2. Establish the documented safe unlock condition: verify unlock becomes eligible only through the safety-side condition defined for the machine.
3. Operate escape release from inside: verify the guard can be opened for egress and the expected safety outputs/state change occurs.
4. Attempt to operate escape release from outside: installation should prevent this where required by the device instructions.
5. Restore escape release but leave guard open: no production authority.
6. Close guard but leave escape release incompletely restored: no assumed healthy state; diagnose per device behavior.
7. Restore release and close/lock guard while a personnel-retention condition remains unresolved: no production restart.
8. Hold ordinary START/JOG/CYCLE before opening, then restore the safety chain: stale intent must not cause motion.
9. Remove/restore device power during the recovery sequence: verify actual product-specific reset behavior rather than assuming it.
10. After maintenance/change of the locking/escape hardware, perform the manufacturer-required functional check and preserve the result as commissioning/maintenance evidence.
11. Challenge lock-position versus guard-position disagreement. Do not collapse both into one `gate OK` bit.
12. Verify that an HMI `unlock requested`, `guard closed`, or `safety reset` indication is diagnostic only unless backed by the independent safety state it claims to represent.

## Provenance classification

- Manufacturer statements above: **DOC-CONFIRMED** from current/available SICK, Pilz, and Rockwell manufacturer documentation.
- Architecture freezes derived by combining those documented behaviors with the curriculum's independent-safety-authority rule: **INFERENCE** unless directly stated by a cited manufacturer.
- No bench, simulation, synthesis, or machine test was performed: no **TEST-CONFIRMED** claims are made.
- No forum/community claims are used: no **COMMUNITY-REPORTED** claims are made.
- OpenPressBrake-specific guard-lock requirement, guard geometry, stopping time, hazardous-overrun duration, safe-state witness, escape hardware, reset sequence, safety performance level/category/SIL, hydraulic state, and personnel-clear architecture remain **UNKNOWN**.

## Sources

- SICK, *Guide for Safe Machinery*, 2024-03-13, guard locking release methods and auxiliary/emergency/escape release distinctions.
- SICK, *flexLock Safety Locking Device Operating Instructions*, 2024-10-24, manual unlocking/escape-release behavior and post-unlock check.
- Pilz, PSENmlock safety-locking product/application documentation, hazardous-overrun guard-locking and reset variants.
- Pilz, *PSEN ml sa / DHM Operating Manual*, 1005457-EN-05, escape-release output state and recommissioning steps.
- Rockwell Automation, *Guardmaster Guard Locking Switch User Manual*, 440G-UM004H-EN-P, February 2026, escape-release fault/recovery and functional-test requirements.
- Rockwell Automation, *440G-LZ Guardmaster Guard Locking Switch User Manual*, 440G-UM001D-EN-P, November 2021, delayed unlock example and risk-assessment dependency.

## Compute decision

No executable verification was justified. This branch is a documentation/architecture question and was resolved from manufacturer evidence. No GitHub-hosted Actions or self-hosted runner compute was consumed.

## Precise next Lane-B checkpoint

Find a professional accessible-cell implementation that exposes the entire chain:

`hazardous motion -> stop request -> safety-side safe-state/standstill proof -> guard unlock -> bodily entry -> escape/restart-prevention state -> guard close/lock -> personnel-clear proof -> safety reset/rearm -> separate fresh ordinary START`.

Prefer an implementation that also documents one failed lock/escape-release diagnostic or power-cycle recovery path. If the primary lane begins advancing guard locking before the next Lane-B session, rotate instead to an independent safeguarding/maintenance evidence gap rather than touching its files.