# Maintenance Bypass / Temporary Override Lifecycle

Status: curriculum architecture contract — 2026-09-15

## Purpose

Teach a machine-agnostic rule for temporary maintenance/test states without turning a convenience bypass into a hidden production mode. This artifact does **not** authorize any particular OpenPressBrake bypass and does not define machine-specific safe speed, force, pressure, stopping distance, or protective-device performance.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by an authoritative external source.
- **DOC-CONFIRMED** — supported by repository/manufacturer documentation but not independently tested here.
- **TEST-CONFIRMED** — demonstrated by a controlled test with preserved evidence.
- **COMMUNITY-REPORTED** — reported by practitioners/community sources.
- **INFERENCE** — engineering conclusion derived from evidence; must remain distinguishable from source text.
- **UNKNOWN** — evidence is insufficient. UNKNOWN never means safe.

## Source-backed boundary

**SOURCE-CONFIRMED — OSHA 29 CFR 1910.147(f)(1):** temporary removal of lockout/tagout and re-energization is allowed for the limited testing/positioning interval only through a defined sequence: clear tools/materials, remove employees from the machine/equipment area, remove energy-control devices under the required removal procedure, energize for testing/positioning, then de-energize and reapply energy-control measures before servicing continues.

**SOURCE-CONFIRMED — OSHA 2024 interpretation:** where servicing requires temporary energization for testing/positioning, employee protection must remain effective during the energized interval; the exception is limited to the time actually required for testing/repositioning and does not erase lockout/tagout requirements for the rest of the servicing activity.

**SOURCE-CONFIRMED — OSHA 1910.147(c)(4):** hazardous-energy procedures must define scope, purpose, authorization, rules, techniques, device placement/removal responsibility, and verification requirements.

**INFERENCE:** a software `bypass=true`, LinuxCNC HAL bit, FPGA register, HMI checkbox, password, key switch, or maintenance-mode flag is not by itself evidence that hazardous energy is controlled. A temporary control override and physical hazardous-energy isolation are different states.

## State model

Use explicit states rather than a generic BYPASS flag:

1. `NORMAL_PRODUCTION`
2. `MAINTENANCE_ISOLATED`
3. `TEST_POSITION_PREP`
4. `TEST_POSITION_ENERGIZED`
5. `RETURN_TO_ISOLATION`
6. `RESTORATION_VERIFICATION`
7. `FAULT_UNKNOWN`

`FAULT_UNKNOWN` is fail-closed with respect to production authority. Loss of the evidence needed to prove the current state must not silently select a more permissive state.

## Entry contract for temporary energized test/position mode

Before `TEST_POSITION_ENERGIZED`, the curriculum architecture requires a task-specific record containing:

- exact task and why energy is necessary;
- authorized responsible person/role;
- affected energy sources and which controls are temporarily restored;
- hazard-zone boundary for the energized interval;
- method that prevents people from being exposed to uncontrolled hazardous motion/energy;
- safeguards that remain effective;
- safeguards/functions intentionally unavailable or altered;
- allowed commands/motions/functions, expressed as a positive allow-list;
- prohibited commands/functions;
- explicit expiration/exit condition;
- indication presented locally at the machine;
- evidence required before return to maintenance isolation or normal production.

If these fields cannot be established, the state remains `MAINTENANCE_ISOLATED` or `FAULT_UNKNOWN`; convenience is not sufficient reason to energize.

## Authority separation

### Independent safety / physical energy control

Owns personnel-safety functions and physical energy-isolation status where applicable. Ordinary LinuxCNC, HMI, networking, or the normal FPGA controller must not forge this authority.

### Normal controller (LinuxCNC / FPGA)

May:
- request a bounded test function;
- enforce additional command allow-lists and stale-command clearing;
- display diagnostic state;
- refuse normal production while a maintenance/test state is active.

Must not:
- declare physical isolation proven;
- synthesize an independent safety permission from ordinary software state;
- automatically restore stale motion/valve commands after mode transitions;
- hide or auto-clear an active maintenance/test state merely because communications restart.

## Human-factors contract

A temporary override should be harder to forget than to notice.

Required design properties:

- unmistakable local indication while any maintenance/test override is active;
- indication describes **what is altered**, not merely `MAINT MODE`;
- production start is inhibited until restoration verification completes;
- power cycle, controller reboot, LinuxCNC restart, FPGA reconfiguration, network reconnect, or HMI restart must not silently convert a temporary override into normal production authority;
- test permissions are bounded to the minimum functions required for the stated task;
- temporary permissions expire or require deliberate renewal rather than remaining indefinitely latched;
- exit requires positive restoration evidence, not just clearing a software flag;
- the architecture should make correct restoration easier than leaving a defeated safeguard in place.

## Restoration contract

Leaving temporary energized testing is a transition, not a button press.

1. Stop the test/position action and clear normal actuator commands.
2. De-energize/isolate as required for continuing service.
3. Reapply required energy-control measures before servicing resumes.
4. Restore every temporarily altered guard, interlock, safety device, configuration, jumper, key, software inhibit, or test fixture.
5. Verify restoration using evidence appropriate to the function; an HMI self-report is not sufficient proof for an independent physical safeguard.
6. Inspect the work area and establish that people are safely positioned before energy restoration.
7. Notify affected people as required by the applicable procedure.
8. Require a separate deliberate production start/rearm. Restoration must not replay a stale cycle-start, motion, PWM, valve-current, or other actuator command.

Any failed or missing restoration evidence routes to `FAULT_UNKNOWN`, not `NORMAL_PRODUCTION`.

## Audit record

For curriculum/test architectures, preserve:

- who/what requested the temporary state;
- task identifier/reason;
- entry time;
- altered functions;
- authorization evidence;
- each transition;
- faults/reboots/communication loss while active;
- exit time;
- restoration checks and results;
- final deliberate production-rearm event.

The audit trail is diagnostic evidence, not the safety function itself.

## Adversarial Safety Sandbox cases

1. **Forgotten override:** test completes but override remains asserted. Expected: production start denied; prominent indication persists.
2. **Controller reboot while active:** LinuxCNC/HMI/FPGA restarts during temporary test state. Expected: no automatic production authority and no stale command replay.
3. **Network reconnect:** communications return with an old queued actuator command. Expected: command discarded; explicit fresh request/rearm required.
4. **HMI flag forgery:** HMI reports `RESTORED=true` while independent safeguard feedback is missing. Expected: restoration fails.
5. **Over-broad permission:** task requests one bounded positioning function but controller exposes unrelated actuators. Expected: architecture/test fails.
6. **Expired test authority:** authorized test window/condition ends while energization remains requested. Expected: test authority removed into a defined safe/fault transition; no silent extension.
7. **Person enters hazard boundary:** required employee-clear/protective condition becomes false during energized testing. Expected: ordinary test command cannot override the applicable protective architecture.
8. **Maintenance resumes without re-isolation:** test ends and technician attempts service before energy controls are reapplied. Expected: state machine refuses `MAINTENANCE_ISOLATED` proof.
9. **Production requested before restoration:** cycle start arrives with a guard/interlock/test fixture still altered. Expected: production denied.
10. **Stale reset/start:** reset/start was held before restoration became valid. Expected: no automatic restart on restoration edge; require a fresh deliberate action.
11. **Power cycle hides indicator:** local HMI loses state while a physical/test alteration remains. Expected: state becomes UNKNOWN or is reconstructed from independent evidence; never assume normal.
12. **Bypass becomes routine:** repeated temporary-mode use is observed for ordinary production. Expected: curriculum flags an architecture/process defect requiring redesign rather than normalizing the bypass.

## Curriculum teaching rule

Do not teach `maintenance bypass` as a generic recipe for defeating a guard or safety function. Teach the lifecycle: identify why energized work is necessary, minimize and bound the temporary state, maintain effective protection, make altered conditions obvious, return to isolation when testing ends, prove restoration, and require a fresh production start.

## OpenPressBrake-specific UNKNOWNs

Remain UNKNOWN until machine evidence exists:

- which maintenance/test tasks truly require hydraulic/electrical energization;
- which existing ERMAK/PILZ functions can support any permissible test/position workflow;
- actual hydraulic stored-energy and gravity-restraint behavior;
- safe speeds/forces/pressures or stopping performance;
- exact guard/interlock topology and diagnostic coverage;
- whether any existing maintenance selector/key circuit is safety-related and how it is validated.

No value for these items should be inferred from this generic lifecycle.

## Next independent branch

Develop a **safety-function proof-of-restoration matrix**: for each generic safeguard class (guard/interlock, E-stop channel, final switching device feedback, hydraulic isolation/restraint, maintenance key/jumper, software configuration), distinguish command state, diagnostic indication, independent feedback, physical inspection/test, and the evidence required before production rearm. Keep it machine-agnostic until the actual OpenPressBrake circuit/hydraulic evidence is traced.

## Sources

- OSHA, 29 CFR 1910.147, especially (c)(4), (d), (e), and (f)(1): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- OSHA Lockout/Tagout eTool, Testing of Machines: https://www.osha.gov/etools/lockout-tagout/tutorial/testing-machines
- OSHA Standard Interpretation, 2024-10-21, LOTO feasibility and alternative methods: https://www.osha.gov/laws-regs/standardinterpretations/2024-10-21
