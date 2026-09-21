# 4000 safety continuation checkpoint — safeguard-defeat review method

Date: 2026-09-21

## Durable state

The setup-to-automatic branch has reached a useful bounded result. ABB RobotWare 8 gives a concrete professional start/restart interlock: safety violations, safety-related stops, operating-mode switches and controller restart lead to a guard-stop state; deliberate Reset is required to regain motors-on eligibility; program Start remains separate. Public evidence still does not establish a universal held ordinary Start/Jog/Cycle electrical/software algorithm.

The branch therefore rotated as directed to safe reduced-speed commissioning and safeguard-defeat human factors. KUKA Sunrise explicitly distinguishes ordinary T1 reduced velocity from safety-oriented velocity monitoring; FANUC DCS independently corroborates safety-rated position/speed monitoring as a separate function.

## Next substantive work

Create a reusable safeguard-defeat / commissioning-shortcut review method. Each row/case must capture:

1. intended safeguard/protective function;
2. foreseeable shortcut or defeat;
3. operational inconvenience or workflow pressure motivating the shortcut;
4. hazardous consequence and what safety proposition becomes unproved;
5. engineered usability correction that makes the legitimate safe path easier;
6. independent safety authority that must remain intact;
7. temporary-state/exceptional-state manifest item;
8. validation/fault-injection evidence needed before production return;
9. ordinary-demand freshness requirement;
10. residual UNKNOWNs requiring machine-specific risk analysis or measurement.

Stress-test the method against at least two unlike systems: (a) press-brake/hydraulic gravity-axis setup and (b) rotating spindle or robot cell. Do not invent safe speeds, stopping distances, hydraulic truth tables, PL/SIL targets, bypass timeouts or reset algorithms.

## Architecture boundary

LinuxCNC/normal FPGA may provide conservative speed defaults, deliberate jog semantics, indication/logging, configuration checks and stale-demand cancellation. Those are useful defense-in-depth and human-factors controls, not personnel-safety authority. If safe speed/position/energy state is required as a safety function, it must be established by the independent safety architecture and validated physical evidence appropriate to the machine.

## Compute

No lab is frozen. No simulation/build/test compute is justified by the current question. Continue source/methodology work; if a future concrete unresolved question requires compute, use only `[self-hosted, openpressbrake]`.