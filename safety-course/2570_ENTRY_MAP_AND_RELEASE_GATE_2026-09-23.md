# 2570 — Drives, STO, braking, and hazardous motion — entry map and release gate

## Status

**READY FOR EXTERNAL/FRESH EVALUATION.** This is not self-graduation.

## Learner route

1. Read `2570_DRIVES_STO_BRAKING_HAZARDOUS_MOTION_SOURCE_PREP_2026-09-23.md` for the base distinctions: drive enable, STO, coast/controlled stopping, electrical isolation, stored mechanical energy and the LinuxCNC authority boundary.
2. Read `2570_DRIVE_FUNCTION_PHYSICAL_PROPOSITION_MAP_2026-09-23.md` and trace every claimed state through command -> safety function -> diagnostic witness -> actuator/final element -> hazardous motion/energy -> physical safe-state proposition.
3. Work the spindle/high-inertia and vertical/gravity cases without inventing coast time, brake capacity, stopping distance or load behavior.
4. Work the ordinary-drive fallback case. Treat contactor power removal as its own architecture, not as a relabelled certified STO function. Account for switching duty, welded-contact feedback, stored DC-bus energy and restart behavior.
5. Attempt `2570_ADVERSARIAL_ASSESSMENT_DRIVE_SAFETY_2026-09-23.md` before seeing any evaluator-only scoring material.

## Syllabus coverage audit

The current learner route covers the named 2570 syllabus requirements:

- drive enable versus STO;
- removing torque versus stopping motion;
- coast versus controlled stopping, including SS1/SS2 distinctions;
- SOS / monitored standstill distinction from de-energization;
- brake command versus actual mechanical holding effect;
- gravity-axis and externally driven motion;
- spindle/high-inertia hazards;
- contactor removal versus integrated STO;
- stopped-state/diagnostic evidence boundaries;
- stored mechanical and electrical energy;
- ordinary-drive fallback architecture and limitations;
- reset/restart separation;
- maintenance isolation boundary;
- ordinary LinuxCNC/FPGA monitoring versus independent personnel-safety authority;
- machine-level validation requirement.

No additional learner-facing 2570 note is justified solely for coverage.

## Required physical-proposition boundaries

A competent learner must preserve all of these distinctions:

- STO active != shaft standstill.
- STO active != electrical isolation.
- torque removed != gravity/external-force restraint.
- STO != SS1 != SS2 != SOS.
- safe brake command != load physically restrained.
- safe monitored standstill != de-energized drive.
- contactor open != DC bus proved safe.
- diagnostic state != complete physical safe-state proof.
- safety reset != ordinary motion-start authorization.

## Release gate

2570 is ready for an information-separated evaluator when the learner can, on a novel drive/machine scenario:

1. state the hazardous-motion proposition that must be made true;
2. select or compare a plausible stopping/torque-inhibition architecture without selecting by acronym alone;
3. identify what each drive safety function actually establishes and what remains unproved;
4. identify gravity, inertia, stored energy and externally driven motion that survive torque inhibition;
5. separate diagnostic witnesses from physical proof;
6. keep maintenance isolation distinct from functional stopping;
7. preserve restart/rearm separation;
8. keep ordinary LinuxCNC/HAL/FPGA control outside sole personnel-safety authority; and
9. explicitly mark absent stopping time, brake capacity, safe distance, load behavior and integrity evidence UNKNOWN.

Critical failure includes inventing missing physical data, treating STO as isolation or standstill, assuming a brake command proves holding, or granting ordinary LinuxCNC software sole personnel-safety authority.

## Information-separation rule

Do not add evaluator solutions or expected answers to this learner-readable file. External evaluation remains branch-local and must not block progression to the next named safety module.