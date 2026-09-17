# Human-Factors Restart, Access, and Guarding Review — 2026-09-17

## Purpose

This module converts several professional safeguarding requirements into adversarial commissioning questions for LinuxCNC-based machines. It is deliberately separate from ordinary CNC/HAL/FPGA behavior. The objective is to make the safe operating path easier than bypassing safeguards and to catch designs that are logically plausible but operationally easy to defeat.

## Evidence classification

### DOC-CONFIRMED — reset is not machine start

SICK safety-scanner documentation states that after a protective device issues a stop command, the stopped state is maintained until reset; reset returns the protective device to monitoring readiness, and machine restart occurs only in a second step after a separate start command. Reset itself must not introduce movement or a dangerous situation. Automatic reset is only acceptable in special cases where people cannot remain in the hazardous area undetected or their absence is otherwise ensured.

Engineering consequence: `safety-reset`, `machine-start`, LinuxCNC machine-on, FPGA rearm, and actuator enable are distinct states/actions. Do not collapse them into one HMI button or one rising edge.

### DOC-CONFIRMED — reset location and sightline matter

SICK's machinery-safety guidance requires a manual reset device to be outside the hazard zone, inaccessible from within it, and positioned so the hazardous area can be completely overseen. SICK's sBot Stop instructions likewise require the reset pushbutton outside the hazardous area and outside the primary protective field.

Engineering consequence: a correctly wired reset button can still be a poor design if the operator cannot see the protected space. A remote touchscreen reset is not automatically acceptable merely because the safety controller receives a valid reset signal.

### DOC-CONFIRMED — accessible guards need escape/restart provisions

Pilz documents accessible guard-locking systems with an inside escape release and lockout provision preventing restart. Pilz also documents that personnel-protection guard locking should retain the safe locking state on loss of power through appropriate locking principles, and that accessible guarded spaces normally require an escape release or equivalent means for a trapped person to leave.

Engineering consequence: guard locking must be reviewed for both directions of failure: premature entry while hazardous motion persists, and trapping a person inside after entry. Loss of power is part of this review, not an afterthought.

### DOC-CONFIRMED — unlock command must be hazard-conditioned

Rockwell's DCSTL safety instruction distinguishes an unlock request from actual lock feedback and states that the hazard must not be present before the instruction issues an unlock command.

Engineering consequence: ordinary LinuxCNC/HAL may request access, but an HMI `unlock` command must not directly become guard-unlock authority where personnel protection depends on hazardous motion having ceased.

## Adversarial human-factors review

For every accessible hazardous area, answer these before exposed operation is cleared:

1. **RESET SIGHTLINE** — Can the person performing reset see the entire hazardous area that could contain a person? If not, what engineered presence-detection, trapped-key/key-in-pocket, zone-clearance, or equivalent architecture closes the blind spot?
2. **RESET REACHABILITY** — Can a person standing inside the protected area operate the reset device? If yes, the reset location is suspect unless a specifically validated architecture makes that condition safe.
3. **RESET/START SEPARATION** — Can reset alone initiate hazardous motion, restore actuator command, or cause a queued LinuxCNC command to execute? If yes, NOT CLEARED.
4. **STALE-COMMAND TEST** — After a protective stop, does a previously asserted foot pedal, cycle-start, jog, MDI command, HAL pin, network command, or FPGA command become effective merely because safety readiness returns? It must not silently restart the hazard.
5. **ACCESS REQUEST VS UNLOCK AUTHORITY** — Does ordinary control merely request access, while the safety architecture determines whether the hazard is absent and unlocking is permitted? If ordinary CNC software directly owns personnel-protection unlock authority, NOT CLEARED absent specific safety evidence.
6. **LOCK FEEDBACK** — Is actual guard-lock state independently observed where required, rather than inferred from the unlock/lock command?
7. **POWER-LOSS STATE** — What happens to the guard and hazardous energy if mains, safety 24 V, safety-controller power, CNC power, or network communication disappears independently? Record each case.
8. **ESCAPE** — If a person can enter and a guard can lock behind them, can they leave without depending on LinuxCNC, the HMI, Ethernet, or normal controller power?
9. **RESTART INHIBITION WHILE OCCUPIED** — What prevents another person outside from resetting/restarting while someone remains inside? Sightline alone may be inadequate for large/blind cells.
10. **DEFEAT INCENTIVE** — Does normal production or setup repeatedly require awkward guard removal, repeated nuisance resets, inaccessible controls, or other friction that predictably encourages operators to tape, wedge, spoof, or remove a safeguard? Treat this as a design defect to correct, not merely a training problem.
11. **DEFEAT DETECTION** — Are coded actuators, cross-fault detection, plausibility checks, monitored lock feedback, or other measures used where foreseeable manipulation matters? Do not assume a single guard input proves the physical guard is present.
12. **SERVICE MODE** — If access with energy present is legitimately required, is there an engineered setup/service mode with deliberate selection and reduced-risk behavior, rather than an undocumented bypass? If adequate risk reduction cannot be established, use isolation/blocking instead.
13. **RESTORATION** — After service, are temporary jumpers, forced inputs, bypass plugs, lifted wires, test firmware/configuration, mechanical blocks, and removed guards positively reconciled before return to production?

## Cross-machine application

### Press brake

Front protective devices, rear/side guards, foot controls, hydraulic safety valves, ram gravity/stored energy, and setup modes create different hazard boundaries. Clearing an optical protective device does not prove hydraulic final-element state or ram restraint. A setup mode that intentionally changes optical protection must not become a generic `guard bypass` mode.

### Mill / lathe

A door interlock may protect against spindle/chuck/tool hazards that persist after command removal. Unlock permission therefore depends on the actual hazard-control concept, not merely `spindle-command = 0`. A LinuxCNC spindle-stop bit is normal-control evidence, not physical standstill proof.

### Plasma / laser

Access protection and restart prevention must consider stored electrical energy, torch/laser enable, motion, fumes and ancillary equipment separately. One E-stop state does not prove every energy source is isolated.

### Robot / automated cell

Large or visually obstructed cells need explicit occupied-space/restart-inhibition strategy. A reset button with incomplete sightline is not repaired by adding a warning label. Escape and multi-person access need deliberate architecture.

## Minimum commissioning disposition

Each item is classified `CLOSED FROM EVIDENCE`, `NOT APPLICABLE`, or `UNKNOWN` for the actual machine. A safety-critical `UNKNOWN` keeps the affected exposed operating state **NOT CLEARED**.

If testing is still necessary to resolve an UNKNOWN, perform only a bounded test whose hazard is controlled independently. Where the basic minimum-safe-to-operate threshold cannot be met, do not operate with people exposed; use isolated/remote testing with people outside the danger zone and state residual risk explicitly.

## OpenPressBrake / LinuxCNC boundary

LinuxCNC and the normal FPGA may:

- display guard/safety state;
- request access or a normal stop;
- inhibit normal commands;
- provide diagnostics and event history;
- require their own explicit rearm after safety readiness returns.

They must not be treated as the sole personnel-safety authority for:

- validating a protected area is clear;
- deciding that a hazardous-energy state permits guard unlock;
- replacing safety-rated restart interlock;
- proving final-element state from commanded state alone;
- making a non-safety guard switch or HMI control safety-rated by software convention.

## Sources

- SICK, *Safety Guide for the Americas* — reset device location, visibility, deliberate reset behavior and requirement that protective devices be functional before reset.
- SICK, *S300 Mini Safety Laser Scanner Operating Instructions* — reset/restart separation and restrictions on automatic reset.
- SICK, *sBot Stop Operating Instructions* — reset pushbutton location outside the hazardous area/protective field.
- Pilz, PSENmlock / PSENmlock handle-module documentation — accessible guard escape release, restart lockout provision and guard-locking behavior.
- Rockwell Automation, *Dual Channel Input Stop with Test and Lock (DCSTL)* — lock request/feedback separation and hazard-conditioned unlock behavior.

## Evidence boundary

This module does **not** establish a machine-specific PL/SIL, stopping distance, safe speed, guard-lock release time, hydraulic pressure threshold, diagnostic coverage, or permissible setup behavior. Those remain machine/design-specific requirements requiring authoritative design evidence and/or validation.
