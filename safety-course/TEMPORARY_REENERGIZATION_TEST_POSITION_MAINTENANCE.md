# Temporary Re-Energization for Testing or Positioning During Maintenance

Status: durable safety-course module
Date: 2026-09-16

## Learning objective

Teach a fresh AI engineer to reason correctly about the hazardous transition in which an otherwise isolated machine must be temporarily energized to test or position equipment, without converting temporary energization into a general-purpose maintenance bypass.

## Governing boundary

**SOURCE-CONFIRMED — OSHA 29 CFR 1910.147(f)(1):** when lockout/tagout devices must be temporarily removed so a machine/component can be energized for testing or positioning, the required sequence is: clear tools/materials; remove employees from the machine/equipment area; remove LOTO devices under the required removal rules; energize and perform the test/positioning; then deenergize all systems and reapply energy-control measures before servicing/maintenance continues.

**SOURCE-CONFIRMED — OSHA 2024 interpretation:** this allowance is limited to the time actually required for testing/positioning. It is not permission to disregard LOTO during the remaining servicing task. OSHA further states that effective employee protection is required during energized testing/positioning, including machine guarding techniques where people cannot be removed from the danger area.

## State model

Do not model maintenance as a boolean `maintenance_mode`.

Use distinct states/claims:

1. `production_or_normal_control`
2. `shutdown_prepared`
3. `energy_isolating_devices_operated`
4. `personal/group_energy_control_applied`
5. `stored_energy_rendered_safe`
6. `isolation_verified`
7. `isolated_maintenance`
8. `test_need_declared`
9. `tools_materials_cleared_for_test`
10. `personnel_exposure_cleared_or_separately_protected`
11. `energy_controls_removed_under_authorized_procedure`
12. `bounded_energized_test_or_position`
13. `test_complete`
14. `all_systems_deenergized_again`
15. `energy_controls_reapplied`
16. `stored_energy_rechecked`
17. `isolation_reverified`
18. `isolated_maintenance_resumed`

A transition to state 12 invalidates the previous claim that the machine is isolated. Returning from state 12 to maintenance is therefore a new isolation cycle, not a software flag restoration.

## Frozen engineering rules

### 1. Re-energization is a bounded transition, not a bypass mode

`INFERENCE`: a design that leaves the machine energized while technicians alternate indefinitely between hands-on work and jog/testing has erased the protection boundary required by the sequence. Each return to exposed servicing requires deenergization, reapplication of energy control, management of stored/reaccumulating energy, and renewed verification appropriate to the task.

### 2. Stale commands must not survive the boundary

Before energized test authority is granted, ordinary motion/start requests that existed before the transition must be treated as stale unless an engineered safety/control design establishes otherwise. On leaving the energized test state, all ordinary motion requests should again be made non-authoritative.

LinuxCNC/HAL or an ordinary FPGA can help discard stale jogs, require a fresh deliberate command, expose diagnostics, and inhibit normal production commands. These are useful normal-control defenses. They do not replace the personnel-protection and energy-control authority.

### 3. The energized test may change the physical energy state

Positioning can raise a gravity load, compress a spring, charge a DC bus, pressurize an accumulator/trapped hydraulic volume, move a robot into a different gravity configuration, rotate a spindle/flywheel, or create thermal/process energy.

Therefore `previously safe stored-energy state` is not automatically reusable after the test. Reassess the energy map after each energized cycle.

### 4. A successful test is not evidence that subsequent servicing is safe

The test may prove only the tested functional claim. It does not prove isolation after the machine has been energized. The maintenance state must be re-established and reverified.

### 5. Repeated cycles are a human-factors design problem

If troubleshooting requires many isolation -> test -> isolation cycles, make the correct sequence physically and procedurally easy: accessible isolators, lock boxes, test points, gauges/bleeds, blocking provisions, clear local status, deliberate fresh-command controls, and predictable reset/rearm behavior. A cumbersome sequence that predictably encourages technicians to leave protection defeated is an engineering defect to address, not an excuse to silently collapse the states.

## Cross-machine examples

### Press brake

A technician may need to energize the machine to reposition the ram/backgauge or observe a fault. Do not invent the machine's hydraulic valve truth table, safe pressure, ram stopping distance, block capacity, or accumulator behavior. After positioning, gravity and trapped/reaccumulating hydraulic energy must be reconsidered before hands-on work resumes. `UNKNOWN` until machine-specific evidence exists.

### Mill/VMC

A test may require axis or spindle motion. A disabled spindle command is not isolation. Repositioning can change gravity exposure on a vertical axis and can leave drive DC-bus energy. Toolchanger/pneumatic stored energy may be independent of axis power.

### Lathe

A test may require spindle/index/turret/chuck operation. Rotational coast, chuck pressure, turret stored energy and auxiliary pneumatic/hydraulic energy are separate claims. A fresh jog/test command should not inherit a stale spindle command.

### Plasma table

Axis positioning may be needed while process energy is not. Keep motion-energy requirements separate from plasma/process ignition authority. Do not energize the cutting process merely because motion positioning requires power.

### Robot

Repositioning can substantially change gravitational potential and reachable hazard space. An energized setup architecture may require engineered safeguarding distinct from LOTO; do not assume ordinary LinuxCNC joint-enable or software speed limits are safety-rated.

### Automated cell

The cell may contain multiple independent energy sources and people/crews. Energizing one subsystem for test must not silently restore authority to unrelated conveyors, clamps, robots, feeders, or process equipment. Group/personnel accounting remains relevant across each transition.

## Adversarial failure cases

1. **Technician leaves a jog button held while the supervisor changes from isolated to test state.** Reject inherited authority; require a deliberate fresh command after the test state is valid.
2. **Remote HMI has a queued `cycle start`.** A network/UI command is not allowed to become an automatic first motion merely because energy returns.
3. **Test raises a ram and then the disconnect is opened.** Previous gravity/stored-energy evidence is stale; blocking/restraint and hydraulic state must be re-established for the new position.
4. **A group member returns to the cell while temporary energization is still active.** Administrative assumption is insufficient; personnel exposure must remain controlled by the applicable group/test procedure.
5. **Repeated troubleshooting leads someone to leave locks off between tests.** This is not an acceptable optimization; redesign the test workflow so repeated correct cycles are practical.
6. **Controller reboot occurs during test mode.** Do not restore energized-test permission from retained ordinary software state. Fail toward loss of normal motion authority and require the applicable physical/procedural state to be established again.
7. **Only the hydraulic pump is needed, but normal software enables all auxiliaries.** Minimize energized scope where architecture permits; unrelated hazard authority should not be restored merely for convenience.
8. **Test finishes successfully and technician immediately reaches into the machine.** Test completion is not re-isolation. Deenergize, reapply energy control, address stored energy, and verify before exposed maintenance resumes.

## Evidence-quality worksheet

For every proposed temporary-energization task record:

| Field | Required answer |
|---|---|
| Exact test/positioning need | Why energy is essential |
| Energy sources required | Electrical/hydraulic/pneumatic/mechanical/process |
| Energy sources not required | How they remain controlled |
| Tools/material clearing method | Physical/procedural evidence |
| Personnel exposure boundary | Removed from area or engineered protection |
| Who controls LOTO removal/reapplication | Authorized procedure |
| Fresh-command rule | How stale start/jog commands are defeated |
| Energized-test protection | Guarding/safeguarding/other justified protection |
| Changed stored-energy state | What can be created or reconfigured by the test |
| Test completion trigger | Objective bounded end of energized state |
| Re-isolation steps | All required isolating devices |
| Stored-energy handling after test | New state, not inherited assumption |
| Reverification method | Independent evidence appropriate to hazard |
| Group/personnel coordination | If more than one worker/crew is involved |
| Machine-specific unknowns | Explicit `UNKNOWN`, not invented numbers |

## Claim discipline

- `SOURCE-CONFIRMED`: OSHA 1910.147(f)(1) provides the five-step temporary testing/positioning sequence.
- `SOURCE-CONFIRMED`: OSHA says the temporary exception applies only for the limited time required for testing/positioning and does not permit ignoring LOTO during other servicing portions.
- `SOURCE-CONFIRMED`: OSHA states employee protection is still required during energized testing/positioning.
- `INFERENCE`: stale motion commands should be invalidated across this authority transition because retaining them can cause unintended motion when energy returns.
- `INFERENCE`: a positioning test can invalidate earlier stored-energy evidence by changing machine geometry or energy accumulation.
- `UNKNOWN`: machine-specific safe speeds, pressures, stopping distances, hydraulic truth tables, proof-test intervals, PL/SIL/category, diagnostic coverage, and residual-energy thresholds unless separately established.

## Fresh-AI handoff test

A fresh learner should reject this proposal:

> "Put the machine in maintenance mode, remove the locks once, leave the pump and drives on, jog as needed for the whole repair, then put the locks back on when finished. LinuxCNC prevents automatic cycle so it is safe."

Expected reasoning: the proposal collapses the required isolation/test/re-isolation transitions, treats ordinary LinuxCNC state as personnel-safety authority, provides no bounded energized-test interval, no personnel/exposure protection argument, no stale-command treatment, and no renewed stored-energy/isolation verification before hands-on maintenance resumes.

## References

- OSHA, 29 CFR 1910.147, especially (d), (e), and (f)(1), accessed 2026-09-16.
- OSHA Lockout/Tagout eTool, Testing of Machines, accessed 2026-09-16.
- OSHA Standard Interpretation, 2024-10-21, Lockout/Tagout Feasibility and "Alternative Methods".

No executable lab is justified by this module. The unresolved questions are machine/procedure-specific physical facts, not software behavior that simulation would responsibly establish.
