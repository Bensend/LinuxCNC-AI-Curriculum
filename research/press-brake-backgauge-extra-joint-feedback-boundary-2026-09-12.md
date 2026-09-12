# Press-brake backgauge — extra-joint feedback / completion boundary

Date: 2026-09-12
Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`
Course context: dependency-safe 3600 preparation; F02 fresh-AI transfer remains information-separated

## Why this follow-up exists

The prior `at_position` witness inventory correctly identified the available joint/HAL fields, but a production completion contract also needs to distinguish **an observable LinuxCNC field** from **a feedback value that LinuxCNC itself still treats as authoritative after extra-joint homing**.

## Official documentation cross-check

Current LinuxCNC `motion(9)` documentation states that `num_extrajoints` joints participate in homing, but after homing control is transferred to `joint.N.posthome-cmd`, the motor feedback value is ignored by LinuxCNC motion, and the extra joint must be managed by an independent planner/controller (typically `limit3`).

Official references inspected 2026-09-12:

- https://linuxcnc.org/docs/html/man/man9/motion.9.html
- https://linuxcnc.org/docs/master/html/man/man9/motion.9.html

This is **DOC-CONFIRMED** for the documented extra-joint contract. It means a production backgauge design must not treat post-home LinuxCNC joint feedback/following-error semantics as if they were the same as an ordinary kinematic joint's closed-loop truth.

## Community cross-check

A LinuxCNC forum example from Dewey Garrett describes extra joints as homed normally and then independently position-controlled, with commands derived and constrained using `limit3`; the example emphasizes that the post-home controller owns the independent position command rather than ordinary kinematics:

- https://forum.linuxcnc.org/38-general-linuxcnc-questions/37632-custom-kinematics

This is **COMMUNITY-REPORTED** support for the architecture pattern, not an independent safety or physical-accuracy proof.

## Pinned-source relationship

The pinned `control.c` path already traced in the preceding backgauge work writes the extra-joint motor command from `posthome_cmd + motor_offset` after homing. `motion.c` exports the post-home command input separately from ordinary joint pins. Together with the documented feedback-ignored rule, the ownership boundary is:

`application planner/controller -> joint.N.posthome-cmd -> homed gate -> motor-pos-cmd`

while post-home completion/health truth needed by the application must come from the application-owned planner/controller and whatever independent drive/encoder validity witnesses are actually available for the machine.

## Correction to completion-language precision

Do **not** teach:

> `joint.N.pos-fb` or ordinary LinuxCNC following-error state alone proves that a post-home extra joint reached the requested backgauge target.

Use the narrower contract:

> LinuxCNC supplies reference state and the post-home command handoff. The independent extra-joint controller owns post-home planning and must supply/retain the feedback-validity and completion witnesses used by the application. A GUI-level `at_position` indication should consume that controller's coherent completion/health state plus application command-episode identity.

The PB-BG-003 experiment therefore intentionally models `position_agrees` and health as abstract commissioned lower-layer witnesses rather than inventing motor behavior or using ordinary LinuxCNC following error as post-home truth.

## Failure / uncertainty implications

- A healthy numeric `posthome-cmd` says what was requested, not whether the mechanism physically reached it.
- A homed state establishes the LinuxCNC reference lifecycle, not continuing encoder truth after control transfers to the independent post-home controller.
- A slow GUI should not reconstruct completion from separately polled numeric fields when the lower-level controller can instead publish a coherent/latching state.
- Physical encoder truth, switch repeatability, drive diagnostic coverage, stall detection, tolerances and safety-related stopping remain machine/commissioning questions and are not inferred here.

## Evidence ledger

| Claim | Class | Scope |
|---|---|---|
| Extra joints home under LinuxCNC, then use `posthome-cmd` and an independent planner/controller | DOC-CONFIRMED + SOURCE-CONFIRMED | documented/current + pinned source architecture |
| LinuxCNC motion ignores the extra joint's motor feedback after homing | DOC-CONFIRMED | documented extra-joint contract; do not generalize to ordinary joints |
| `limit3` is a typical independent post-home planner | DOC-CONFIRMED + COMMUNITY-REPORTED | architecture pattern, not a mandatory implementation |
| Application command-episode identity is still needed to distinguish same-target/replayed completion | SOURCE-GROUNDED INFERENCE, PB-BG-003 pending test | application integration layer |

## Next checkpoint

Audit PB-BG-003 only against its already-frozen Gates A–J. If it passes, retain the narrower conclusion that episode identity prevents enumerated stale-completion/replay errors in a synthetic state contract. Do not upgrade it into a claim about physical backgauge accuracy or LinuxCNC post-home feedback truth.
