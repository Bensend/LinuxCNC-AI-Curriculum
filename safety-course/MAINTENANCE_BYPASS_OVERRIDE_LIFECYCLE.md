# Maintenance Bypass / Override Lifecycle

Session start: 2026-09-16T08:36:38Z

## Purpose
Teach the difference between an engineered, bounded safety-related maintenance mode and improvised defeat of a safeguard. A bypass is not made acceptable merely by calling it maintenance, putting it behind an HMI password, or logging it.

## Evidence discipline
- **DOC-CONFIRMED:** Pilz Key-in-pocket is an engineered maintenance-safeguarding architecture: authorized people authenticate, their IDs remain in a safe list while they are in the danger zone, and restart permission is withheld until the list is empty. Pilz also calls for a blind-spot check for large plants without an overall view.
- **DOC-CONFIRMED:** Rockwell GuardLogix documentation warns that overriding a safety fault transfers the burden to proving continued safe operation; safety I/O replacement guidance requires functional testing and authorization before return to use.
- **INFERENCE:** Therefore a generic `maintenance_bypass` Boolean in ordinary LinuxCNC/HAL or the normal OpenPressBrake FPGA is not, by itself, a defensible personnel-safety architecture.
- **UNKNOWN:** Required PL/SIL/category, permissible maintenance modes, safe speeds/forces, stopping distance, hydraulic safe state, and exact validation interval remain machine/risk-assessment specific unless separately established.

## Four boundaries that must remain distinct
1. **Normal control:** LinuxCNC commands motion/process functions and may request a maintenance/setup mode.
2. **Monitoring/diagnostics:** LinuxCNC/FPGA/HMI may display bypass status, reason, owner, timeout, device state and faults.
3. **Safety-related control:** independently determines whether the defined maintenance mode is permitted and what protective functions remain effective.
4. **Physical energy control:** contactors, STO, valves, brakes, isolation devices, blocks/pins or other mechanisms actually remove, prevent or constrain hazardous energy as required by the task.

No software status bit proves that physical hazardous energy is absent.

## Lifecycle contract
A legitimate engineered override must have an explicit lifecycle rather than an indefinite `bypass=true` state.

`production_protection_valid -> maintenance_request -> authorization_valid -> task_scope_valid -> alternate_protection_valid -> override_active -> maintenance_task -> override_exit_request -> primary_protection_restored -> functional_validation_passed -> deliberate_reset/rearm -> production_allowed`

Any invalid transition fails closed for hazardous production. Power loss, reboot, communications loss, controller replacement, corrupted retained state, timeout, or loss of alternate protection must not silently recreate production permission.

## Required design questions
Before allowing any override, the learner must state:
- Which exact protective function is being suspended or modified?
- Why is suspension necessary for this task?
- Which hazards remain while it is suspended?
- What alternate protective measure controls each remaining hazard?
- Who is permitted to authorize the mode, and how is authorization distinguished from ordinary operator access?
- What physical indication makes the altered protection state obvious at the hazard zone?
- Can the machine enter ordinary automatic production while the override remains active? The default answer must be no.
- What terminates the override: task completion, key removal, mode change, timeout, power cycle, gate state, personnel accounting, or another defined event?
- What must be physically inspected/functionally tested before production protection is accepted again?

## Human-factors contract
The safe maintenance path should be easier than improvised defeat. Provide accessible isolation points, captive/managed keys where appropriate, clear setup controls, usable enabling devices, local indication, sensible reset locations, and a restoration checklist. If legitimate service work routinely requires tape, magnets, jumpers, hidden PLC edits, permanently held reset buttons, or repeated nuisance trips, treat that as an engineering defect rather than predictable operator misconduct.

A conspicuous indication is necessary but not sufficient: a flashing `BYPASS ACTIVE` banner cannot substitute for alternate protection or physical energy control.

## Adversarial evaluator cases
1. **Jumpered guard switch:** technician bridges a guard input to jog from inside. Reject: improvised defeat with no bounded alternate-protection contract.
2. **Passworded HMI bypass:** supervisor password sets a normal PLC/HAL bit. Reject as safety authority; authorization does not create a safety function.
3. **Engineered setup mode:** safety controller permits only the defined setup function while a valid enabling device and task-specific constraints remain effective. Potentially acceptable only to the extent supported by the machine risk assessment and validated implementation.
4. **Forgotten bypass:** maintenance ends but bypass remains latched. Production must remain inhibited; restoration and functional validation are required.
5. **Power cycle during bypass:** system restarts. It must not infer `production protection restored` from reboot/default state.
6. **Controller replacement:** replacement starts with defaults. Treat previous validation/configuration as invalid until identity/configuration and safety function are verified.
7. **Bypassed sensor replaced:** new device is installed. Do not clear the bypass merely because communications return; perform the required functional test and authorize return to use.
8. **Alternate protection fails:** enabling device, personnel-key accounting, guard lock, speed monitoring, or other task-specific alternate measure faults. Remove the associated hazardous-operation permission.
9. **Production pressure:** operator requests a permanent bypass because a guard causes nuisance stops. Reject the bypass; fix alignment, process access, diagnostics or safeguard design so correct use is practical.
10. **Remote bypass request:** network/HMI command requests override from outside the work area. Treat it only as a request; safety-related authorization and local/task-state conditions remain authoritative.

## Machine-family transfer
- **Mill/lathe:** opening a guard for setup does not prove spindle standstill; maintenance mode must preserve the safeguards required for the allowed setup task.
- **Plasma:** disabling an access device does not prove torch/high-voltage/pneumatic hazards are absent.
- **Press brake:** bypassing an optical/protective device does not establish safe ram force, speed, stopping behavior or hydraulic state. Those remain machine-specific until proven.
- **Robot/cell:** teach/setup permission does not prove the cell empty and does not replace enabling-device, access, speed/separation or other validated measures.

## Minimum-safe-to-operate rule
If the required task cannot be performed with a defined and validated protective architecture, do not operate with people exposed to the hazard. Experimental operation, if genuinely necessary, must be isolated/remote with people outside the danger zone and residual risk stated explicitly.

## Verification checklist
Before returning to production, verify at minimum: bypass/override state cleared; original protective device physically restored; wiring/actuator/guard condition correct; required functional test passes; diagnostics are normal; retained/remote commands cannot recreate the override; reset/rearm is deliberate; ordinary start remains separate; and the evidence record identifies configuration/version changes that invalidate earlier validation.

## Sources
- Pilz, Key-in-pocket / access management documentation, accessed 2026-09-16: https://www.pilz.com/en-GB/access-management
- Rockwell Automation, GuardLogix 5570 Controllers User Manual 1756-UM022D-EN-P, safety fault override warning.
- Rockwell Automation, GuardLogix safety I/O replacement guidance, accessed 2026-09-16: functional testing and authorization are required after replacement.
