# 4400-SETUP-01 — Inch mode is not permission to work in the die space

**Status:** learner-facing, NON-GRADUATED, 2026-10-25. Source: [OSHA original interpretation audit](../research/4400_OSHA_DIE_SETTING_MINOR_SERVICING_INCH_MODE_VS_LOTO_SOURCE_AUDIT_2026-10-25.md). Prerequisites: 2520 hazard/SRS, 2580 hydraulic safety, BLOCK-01 ram support, LOTO-TEAM-01 group protection.

## Practical lesson
A press brake may need small powered alignment movements during setup. That does not mean the entire tooling-change job is an energized operation. Divide the job by *exposure* and *energy state*:

**HANDS-ON TOOLING** — people may contact the hazardous die/ram region; requires task-specific physical energy isolation, stored-energy control, load support and verification, not merely normal LinuxCNC STOP, key-selected INCH or dual-hand jog.

**POSITIONING/TESTING** — if motion is truly necessary, follow an authorized temporary LOTO interruption with all personnel out of danger, tools cleared, qualified safeguarding, and a bounded motion plan. Return to deenergized, locked and verified hands-on state before anyone reenters. No one gets a 'quick jog' exemption while another worker remains exposed.

**ROUTINE MINOR PRODUCTION SERVICE** — only a narrow, fully evidenced exception can apply if the task is during normal production, routine, repetitive, integral and has effective alternative protection. A setup/die change is not made exempt by calling it 'minor' or 'frequent'.

## Independent failure mechanisms to name
- Hydraulic valve leakage/failed component or trapped pressure may move the ram without a commanded jog.
- Gravity-loaded ram and an upper die can descend/fall even with the electrical feed isolated.
- Ordinary mode/key/HMI or PLC output may be mis-set, fail, or be actuated by another person.
- A two-hand device may protect an operating cycle yet not prevent a suspended die from falling during hands-on work.
- A protective function may be bypassed in a setup mode; its actual configuration must be examined, not assumed.

## Make compliance practical
Install/organize easy-to-use physical ram support and die-retention fixtures; position lockable isolators and group lockbox access where technicians actually work; distinguish two visible states **TEST (no personnel exposure)** and **SERVICE (isolated/verified)**; use a short, readable re-isolation checklist; make the guards quick to reinstall and difficult to leave defeated. The safety case must be established by actual design and verification, not by a reassuring UI.

## Cross-machine transfer
On a lathe, tool change may expose chuck/clamp energy; on a mill, tool changer/spindle; on a plasma table, stored electrical/pressure energy; on a robot, gravity and reach-through. The task-specific exception analysis transfers; a hydraulic power-press interpretation is **not** a blanket authorization for these machine classes.

## Evidence and hold
**DOC-CONFIRMED** indexed OSHA 2005/2006/2008 interpretations and 1910.147(f)(1). **INFERENCE** human-factors workflow. **UNKNOWN** selected machine and physical safe-state proof. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none. No independent evaluator, PL/SIL calculation or physical validation. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. No personnel-exposed operation.
