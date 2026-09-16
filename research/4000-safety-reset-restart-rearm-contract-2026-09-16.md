# 4000 Safety — Reset / Restart / Rearm Teaching Contract

Session start: 2026-09-16T02:36:00Z

## Scope

This artifact turns the safety-course reset/restart/rearm boundary into an explicit learner and evaluator contract. It is generic curriculum material, not a machine-specific safety design.

## Evidence ledger

- **DOC-CONFIRMED — Rockwell Guardmaster DG (440R-UM015J-EN-P, June 2025):** external output monitoring is checked after safety inputs are satisfied and before reset proceeds. Monitored manual reset requires a LO-HI-LO transition in a bounded interval. The manual explicitly warns that the reset function must not be used to start or restart the machine.
- **DOC-CONFIRMED — Rockwell Guardmaster safety relays (440R-UM013I-EN-P, July 2024):** monitored reset is performed on the trailing edge of a bounded reset pulse; example wiring places mechanically linked NC contactor-monitoring contacts in the reset/monitoring path.
- **DOC-CONFIRMED — Pilz ISO 13850 FAQ:** an actuated emergency-stop device is reset intentionally at the device that initiated the command; resetting the E-stop must not automatically restart the machine, but only prepare it for restart. Where the relevant operating range cannot be adequately checked from that position, additional restart/start provisions require risk assessment.
- **INFERENCE:** the curriculum should model reset acceptance, safety rearm, and ordinary machine start as separate transitions. This follows from the documented no-restart-on-reset boundary but does not assert one universal implementation for every machine.
- **UNKNOWN:** required reset locations, visibility, performance level/SIL/category, timing, stopping distance, hydraulic state, pressure thresholds, and restart interlocks for any specific machine remain design/risk-assessment dependent.

## State contract

The Safety Sandbox and written exercises must not collapse the following into one `safe` or `run` bit:

1. `safety_demand_active`
2. `physical_hazard_path_interrupted`
3. `external_device_feedback_valid`
4. `reset_input_state`
5. `reset_edge_or_sequence_valid`
6. `reset_accepted`
7. `safety_rearmed`
8. `normal_start_request`
9. `hazardous_motion_or_energy_commanded`

A learner must be able to explain why a transition in one state does not prove the others.

## Required sequence exercise

Baseline teaching sequence:

1. Hazardous operation is active under normal control.
2. A safety demand occurs.
3. Independent safety-related control removes permission/energy through the intended interruption architecture.
4. Feedback is evaluated for what it actually proves; LinuxCNC/FPGA status may be diagnostic evidence but is not silently promoted to personnel-safety authority.
5. The initiating condition/device is restored only after the hazard-triggering condition is addressed.
6. A deliberate reset action is evaluated. A held-high/stuck reset is not equivalent to a fresh monitored reset sequence where monitored reset is required.
7. Rearm is permitted only when the safety architecture's required conditions and external-device feedback are satisfied.
8. Rearm does **not** itself command hazardous motion or energy.
9. A distinct intentional normal-control start action is required before operation resumes.

## Adversarial evaluator vectors

A fresh learner must reason through at least these cases without assuming a machine-specific truth table:

| Case | Required conclusion |
|---|---|
| E-stop mechanically released | Release alone does not authorize restart. |
| Reset button held/stuck before demand clears | Must not be treated as equivalent to a deliberate fresh monitored-reset transition when monitored reset is required. |
| Reset accepted, no normal start request | Safety may be rearmed while hazardous operation remains uncommanded. |
| Normal start request remains latched across a safety demand | Architecture must not permit an unintended restart merely because the safety demand clears/rearms. |
| Control power disappears and returns | Power restoration must not be assumed to authorize hazardous restart; machine-specific restart behavior requires explicit design evidence. |
| One contactor remains welded | Feedback/rearm conclusion depends on the documented mirror/force-guided feedback architecture; coil-off is not proof that all hazardous power paths opened. |
| Feedback wire broken/open | Treat as a diagnostic/safety architecture fault according to the actual circuit; do not invent a universal polarity or response. |
| Ordinary auxiliary contact substituted for documented mirror feedback | Learner must reject the inference that it necessarily proves main power-pole state. |
| Maintenance bypass remains installed | Restoration to production requires deliberate bypass removal/verification; a bypass that is easy to forget is a human-factors design defect. |
| Guard routinely obstructs legitimate setup/maintenance | Do not solve by normalizing defeat; redesign the workflow/guarding so correct use is the easier path while preserving required protection. |

## Human-factors rules

- Reset/rearm controls should not create a convenient hidden path around a safeguard.
- A reset location and restart workflow must account for the ability to determine that people are not exposed to the relevant hazard; the exact arrangement is machine/risk-assessment dependent.
- Safeguards and bypass-removal steps that are predictably burdensome invite defeat. Treat recurring inconvenience as an engineering input, not merely an operator-discipline problem.
- Maintenance bypasses need conspicuous state indication and a restoration process designed so leaving the bypass active is harder than returning to the protected state.
- If minimum safe operation cannot be established, do not operate with people exposed to the hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk explicit.

## LinuxCNC boundary

LinuxCNC and the ordinary FPGA/controller may request normal machine functions and expose useful diagnostics. They must not be assigned independent personnel-safety authority merely because implementing reset/start sequencing there is convenient. Exercises must identify which layer owns each transition: normal control, monitoring/diagnostics, independent safety-related control, or physical energy interruption/removal.

## Evaluator scoring gates

Fail the exercise if the learner:

- equates E-stop release with restart permission;
- uses reset itself as the machine-start command without explicit architecture evidence;
- treats `coil_command = OFF` as proof of energy isolation;
- treats an arbitrary auxiliary contact as proof of main-contact opening;
- silently makes LinuxCNC/HAL/ordinary FPGA logic the personnel-safety authority;
- invents PL/SIL/category, stopping distance, hydraulic state, or machine-specific restart requirements;
- recommends routine safeguard bypass as the solution to an inconvenient safeguard.

Pass requires correct state separation, evidence labels, explicit UNKNOWNs, and a distinct normal-start transition after safety rearm.

## Next evidence work

1. Build a compact reset/restart/rearm failure-path matrix across press brake, mill, lathe, plasma, robot, and automated-cell examples while keeping machine-specific facts UNKNOWN unless sourced.
2. Add maintenance/bypass restoration patterns and adversarial cases to the safety syllabus/module artifacts.
3. Only prototype the Safety Sandbox state machine after the written state transitions answer a concrete unresolved question; do not run simulation merely to reproduce this documented logic.

No simulation/build/test compute was used in this session.