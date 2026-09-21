# 25E0 — Safeguard-Defeat / Commissioning-Shortcut Review Method

Session start: 2026-09-21T20:35:39Z

## Purpose

Turn foreseeable safeguard defeat into an engineering review, not a warning-label exercise. The method asks why a competent person would be tempted to bypass a protection, what safety proposition the shortcut destroys, how the design can remove the incentive, and what physical evidence is required before production return.

## Evidence basis

- **DOC-CONFIRMED — Pilz / ISO 14119 implementation guidance:** manipulation incentives include convenience, time/performance pressure, poor ergonomics and inadequate operating modes; the first response is to identify and reduce the incentive. Protection concepts and machine function should be developed together.
- **DOC-CONFIRMED — OSHA machine guarding guidance:** safeguarding should suit the operation; guarding that interferes with machine operation may encourage operators to override it.
- **DOC-CONFIRMED — ISO 14119 guidance:** interlocking devices should resist defeat in reasonably foreseeable ways; coded actuators, protected/concealed mounting and non-detachable fastening are examples when defeat incentive remains.
- **INFERENCE:** anti-tamper hardware is a second line of defense. If the legitimate setup, troubleshooting, cleaning or recovery workflow is intolerable, merely making defeat harder can move the shortcut elsewhere rather than remove it.

## Review record

For every safeguard or exceptional commissioning state, record all of the following. A missing safety-critical answer is `UNKNOWN`, not an implicit pass.

| Field | Required question |
|---|---|
| Task | What legitimate production/setup/service task is the person trying to accomplish? |
| Safeguard / safety proposition | What physical proposition does the protection establish? |
| Friction | What delay, visibility problem, reach problem, nuisance trip, restart burden, diagnostic opacity or repeated access makes correct use unattractive? |
| Foreseeable shortcut | What is the easiest likely defeat: spare actuator, tape, jumper, force, simulated input, service key left selected, ordinary speed override, defeated enabling device, muted scanner, parameter substitution? |
| Destroyed evidence | Which physical proposition becomes unproved even if the HMI/PLC signal still looks healthy? |
| Hazard consequence | What hazardous energy or motion can now coexist with access? |
| Incentive removal | Can the task be redesigned so correct safeguarding is easier/faster? |
| Defeat resistance | If incentive remains, how is casual/simple defeat made harder or detected? |
| Exceptional-mode boundary | If access with energy is genuinely necessary, what independent safety functions replace the normal safeguard? |
| Visibility | How does the operator/maintainer unmistakably know an exceptional state exists? |
| Persistence | Can the exceptional state survive logout, reboot, mode change, key removal, program reload or shift handoff? |
| Production-return clearance | What software forces, physical aids, simulation states, service modes and alternate parameters must be positively cleared? |
| Physical revalidation | Which field observations/tests re-establish the destroyed proposition? |
| Demand freshness | Can a Start/Jog/Cycle asserted before or during the exceptional state cause motion after clearance? If undocumented, mark UNKNOWN and use a conservative ordinary-control freshness gate without claiming it as personnel-safety authority. |

## Design hierarchy

1. **Remove the incentive.** Provide visibility, access, diagnostics, recovery and legitimate setup modes that let the task be done without defeating protection.
2. **Provide an engineered exceptional mode where necessary.** Reduced-risk setup/service operation needs its own validated safety architecture; a mode selector or LinuxCNC flag is not itself a safety function.
3. **Make simple defeat difficult.** Select/mount interlocks and protective devices so readily available objects or spare actuators do not trivially simulate the protected state.
4. **Detect exceptional state and carryover.** Persistent forces, jumpers, simulation, service modes and changed safety parameters belong in a production-readiness manifest.
5. **Require physical restoration evidence.** Clearing a software flag does not prove a guard, valve, brake, pressure path, speed monitor or other field proposition is restored.

## Human-factors acceptance rule

A safeguard that repeatedly obstructs a necessary normal task is an engineering defect to investigate. The acceptance question is not merely `Can the guard be bypassed?`; it is also `Does normal work predictably reward bypassing it?`

Freeze:

- **DIFFICULT TO BYPASS != LOW INCENTIVE TO BYPASS.**
- **LOW INCENTIVE != DEFEAT IMPOSSIBLE.**
- **INTERLOCK SIGNAL HEALTHY != GUARD PHYSICALLY EFFECTIVE if its actuator/sensor has been defeated.**
- **SERVICE MODE SELECTED != REPLACEMENT SAFETY FUNCTIONS VALIDATED.**
- **FORCE/JUMPER REMOVED != DESTROYED PHYSICAL PROPOSITION REVALIDATED.**
- **WARNING/INDICATION != RISK REDUCTION.**
- **PRODUCTION RETURN != EXCEPTIONAL STATE CLEARED alone.**

## Stress test A — hydraulic / gravity-axis press brake

Scenario: repeated troubleshooting requires seeing tooling/ram behavior. The full guard/interlock workflow is slow, visibility is poor, and a technician discovers that a spare guard actuator plus a normal LinuxCNC velocity limit makes diagnosis convenient.

Review:

- **Friction:** poor sightline and repeated reset/access cycle.
- **Shortcut:** spare actuator defeats guard; ordinary controller velocity setting is treated as `safe slow`.
- **Destroyed evidence:** closed-guard signal no longer proves physical separation. Ordinary commanded speed does not prove independently monitored safe speed. Neither proves the gravity-loaded ram is retained.
- **Machine-specific hazards:** gravity/load motion, hydraulic pressure and stored downstream energy remain separate propositions. No hydraulic truth table, safe speed or pressure threshold is inferred here.
- **Usability correction:** improve diagnostic visibility/access; provide a deliberate setup workflow only where the machine risk assessment supports it, with independent safety-rated enabling/protective functions appropriate to the actual machine rather than relying on LinuxCNC speed commands.
- **Defeat resistance:** appropriate coded/protected interlocking and control of spare actuators may reduce simple defeat, but do not substitute for the usable setup workflow.
- **Return evidence:** remove physical defeat aids and software exceptional states; verify actual guard/interlock operation; revalidate any affected safety monitoring/final-element/process witness; verify configuration identity and ordinary-demand freshness.
- **Minimum threshold:** if the necessary protective architecture cannot be restored, do not operate with personnel exposed. Any experimental motion must be isolated/remote with people outside the danger zone and residual risk stated.

## Stress test B — rotating spindle / robot cell

Scenario: frequent teaching or recovery requires entering a guarded cell. A user tapes an enabling device in its permissive position, leaves the service key selected and uses an ordinary software speed override because the proper teach workflow is cumbersome.

Review:

- **Friction:** cumbersome recovery/teaching sequence and repeated mode transitions.
- **Shortcut:** enabling device defeated, persistent service mode, ordinary speed command mistaken for safety monitoring.
- **Destroyed evidence:** enabling-device state no longer witnesses deliberate live human actuation; mode identity does not prove protective conditions; commanded reduced speed does not independently witness actual speed.
- **Machine-specific hazards:** rotating spindle run-down and robot stored/kinetic/gravity energy differ; a common review method must not collapse their physical acceptance criteria.
- **Usability correction:** make legitimate teach/recovery mode easy to enter and understand; require deliberate motion demand distinct from enabling; use independent safe-motion monitoring when the risk reduction depends on speed/position limits.
- **Defeat resistance:** use enabling hardware and mode-selection architecture resistant to easy persistent defeat, with conspicuous exceptional-state indication and controlled authorization.
- **Return evidence:** remove tape/aids and exceptional states, restore guard function, validate enabling-device behavior and any safety-rated motion monitor, clear production-readiness manifest, and require a post-transition ordinary command policy appropriate to the controller/application.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the normal FPGA may improve usability by providing clear setup UI, deliberate jog controls, conservative ordinary speed defaults, diagnostics, exceptional-state indication/logging and stale-demand cancellation. Those functions can reduce manipulation incentive. They do **not** acquire personnel-safety authority merely because they make the safe workflow easier.

## Production-return gate

Production return requires, at minimum, an explicit disposition of:

- physical guard/interlock defeat aids;
- software forces/bypasses and simulated witnesses;
- service/setup mode and authorization state;
- temporary jumpers and commissioning wiring;
- ordinary speed/parameter substitutions;
- safety configuration identity;
- affected physical safety-function revalidation;
- conspicuous exceptional-state indication clearance;
- ordinary demand freshness/restart behavior.

Any safety-critical `UNKNOWN` blocks the acceptance claim that depends on it.

## Outcome

The method survives both stress tests while the acceptance physics do not: a gravity/hydraulic axis requires different physical evidence from a rotating spindle or robot. This is the intended architecture — reusable review questions, machine-specific safety propositions and validation.
