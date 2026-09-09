# D01 — Community evidence: tandem homing is not continuous runtime geometry authority

D01's source/runtime question must not be blurred with the separate LinuxCNC gantry-homing feature.

## Community pattern

LinuxCNC community discussions consistently describe negative `HOME_SEQUENCE` tandem/gantry joints as a synchronized homing/squaring mechanism: each side can independently find its home condition, then the pair completes the final move in synchronization. Examples:

- LinuxCNC Forum, **Problem with Gantry Homing** (2018): the observed behavior was clarified as one side finishing its switch operation, waiting for the other, and then both performing the final move together.
- LinuxCNC Forum, **Pnncof Tandem Y axis problem** (2019): community guidance describes the two Y sides homing independently to their switches and then completing the final squaring move together; the same thread emphasizes that normal axis motion becomes available after homing.
- LinuxCNC Forum, **command to home Y axis**: documented/community guidance warns that joint-mode jogging of negative-`HOME_SEQUENCE` synchronized joints is disallowed because independent jogging can rack the gantry.

These are useful operational clues, not substitutes for pinned source or laboratory evidence.

## D01 teaching boundary

A successful tandem homing sequence establishes a configured reference relationship at the completion of homing. It does **not** by itself prove that:

- both joints remain mechanically aligned throughout later motion;
- both encoders retain trustworthy coupling to their physical sides;
- Cartesian axis feedback continuously cross-validates duplicated joint feedback;
- hydraulic/mechanical load sharing is stable;
- a later apparently correct world-coordinate Y value authenticates physical squareness.

D01 therefore treats **homed/squared at reference time** and **continuously authenticated coupled geometry** as different claims. The latter requires runtime joint-level evidence or independent physical/safety mechanisms appropriate to the machine.

## Relation to the frozen experiment

D01-002 intentionally homes the duplicated-coordinate fixture only to obtain valid world-coordinate motion. Its discriminating evidence begins afterward: duplicate-only feedback is perturbed while the principal path remains clean. The experiment asks whether ordinary Cartesian feedback hides that disagreement and whether joint-level following-error authority still revokes motion.

This distinction prevents a common architecture error: using successful gantry homing as an argument that a single Cartesian feedback value can subsequently serve as continuous tandem-alignment proof.
