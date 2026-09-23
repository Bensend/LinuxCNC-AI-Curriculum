# 2590 — learner entry map and release gate

## Status

**READY FOR EXTERNAL/FRESH EVALUATION — not self-graduated.**

This gate follows the governing 2590 syllabus: fixed/movable guards, interlocks, guard locking, coded/non-contact devices, foreseeable defeat, presence sensing, stopping-distance concepts, two-hand controls, enabling/hold-to-run controls, visibility/ergonomics and guard usability.

## Coverage audit

The existing 2590 artifacts collectively provide learner-facing coverage for every governing branch:

| Required competency | Coverage state |
|---|---|
| fixed vs movable safeguarding | covered in safeguard-selection map |
| interlock vs guard locking | covered with separate physical propositions |
| coded/non-contact sensing | covered, including coding not being defeat immunity |
| foreseeable defeat/bypass | covered with adversarial defeat cases and usability incentives |
| light curtains/scanners | covered as presence-sensing functions, not physical-stop proof |
| minimum distance/stopping time | covered symbolically; application stopping data remain UNKNOWN until measured |
| pass-through / person behind field | covered with occupancy/reset visibility boundary |
| two-hand control | covered with concurrence/monitoring and anti-tie-down reasoning |
| enabling/hold-to-run | covered with three-position Off-On-Off and restricted-mode boundary |
| visibility/ergonomics/usability | covered as design requirements, including reset visibility and defeat incentive |
| maintenance boundary | covered: production safeguard state is not maintenance energy isolation |
| LinuxCNC/FPGA authority | covered: ordinary control/diagnostics do not become personnel-safety authority |

No material learner-facing syllabus gap was found. Do not add notes merely to increase document count.

## Canonical learner route

A fresh learner should proceed in this order:

1. Start from the hazardous event and physical safe-state proposition, not from a favorite device.
2. Choose the safeguard class by access need, hazard persistence, stopping behavior and foreseeable use.
3. State exactly what the selected safeguard senses or restrains and what it does **not** prove.
4. Trace the safety function through sensor/device -> safety-related logic -> final element -> end of dangerous state.
5. For presence sensing, keep device response time separate from complete machine stopping time and preserve real application data as UNKNOWN until measured/validated.
6. Analyze reach-around, reach-over, pass-through, remaining-inside-zone, spare actuator/magnet, alignment, wiring and reset-location defeat paths.
7. Keep reset/rearm separate from machine start authorization.
8. For two-hand controls, reason about concurrence, release, anti-tie-down and protection of other persons, not merely two Boolean inputs.
9. For enabling controls, treat the middle position as permission only within a deliberately restricted operating mode; release and over-squeeze must return toward the protective state.
10. Perform a human-factors review: correct use, reinstallation, fault recovery and maintenance should be easier than bypass where practical.
11. Keep maintenance isolation/restraint separate from production safeguarding.
12. Keep LinuxCNC/HAL/ordinary FPGA logic in normal control and diagnostics unless independent evidence establishes a safety-rated role.

## Frozen propositions the learner must preserve

- GUARD CLOSED != DANGEROUS STATE ENDED.
- GUARD INTERLOCKED != GUARD LOCKED.
- GUARD LOCKED != APPLICATION-SUFFICIENT HOLDING FORCE PROVED.
- LIGHT CURTAIN INTERRUPTED != MACHINE PHYSICALLY STOPPED.
- PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY.
- DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME.
- SAFETY DISTANCE != A CATALOG CONSTANT.
- HIGH-CODING INTERLOCK != DEFEAT IMPOSSIBLE.
- TWO BUTTONS TRUE != VALIDATED TWO-HAND SAFETY FUNCTION.
- TWO-HAND PROTECTION OF ONE OPERATOR != PROTECTION OF EVERY PERSON WITH HAZARD ACCESS.
- ENABLING MIDDLE POSITION != UNRESTRICTED MOTION AUTHORITY.
- THREE-POSITION DEVICE != COMPLETE SETUP-MODE SAFETY FUNCTION.
- SAFETY RESET/REARM != MACHINE START AUTHORIZATION.
- PRODUCTION SAFEGUARDING != MAINTENANCE ENERGY ISOLATION.
- ORDINARY LINUXCNC/FPGA GUARD LOGIC != PERSONNEL-SAFETY AUTHORITY.

## Release test

A fresh evaluator should present a novel machine with at least two access modes and at least three plausible safeguarding choices. The learner must select and defend an architecture, identify defeat/pass-through paths, bound diagnostic claims, derive what stopping evidence is needed, define reset/restart behavior, and state when exposed operation is not justified.

The learner must not be supplied a hidden preferred architecture before committing its response. The information-separated evaluator handoff is `evaluation/2590_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`.

## Release decision

2590 has sufficient coherent learner-facing material for an external/fresh competency test. This is a release-to-evaluation decision, **not graduation**. Any external miss that exposes a central competency must feed a minimal correction and novel transfer retest before graduation.
