# M03 checkpoint — servo loopback experiment launched

Session start UTC: `2026-09-06T11:14:15Z`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Durable progress this lesson

- Completed the foundation one-period source call flow in `call-flows/M03-one-servo-period.md`.
- Confirmed `emcmotController()` order places `process_inputs()` before forward kinematics/fault/mode/planner/setpoint work and places `output_to_hal()` near the end.
- Located exact active-joint HAL feedback sampling: `joint->motor_pos_fb = hal_get_real(joint_data->motor_pos_fb)`.
- Located normal motor-command/output publication in `output_to_hal()`.
- Preserved the homing index-search exception and extra-joint output exception.
- Traced command-handler new-command recognition via command number versus command-number echo and preserved the nonblocking Task command-mutex boundary.
- Identified a discriminating property of pinned `tests/linuxcncrsh/lcncrsh_sim.hal`: its motor-command-to-feedback loopback should make post-controller `joint.0.pos-fb[n]` correspond to pre-update / prior-sample `motor-pos-cmd[n-1]` during ordinary zero-compensation motion.

## Experiment launched

- Lab: `lab-jobs/008-m03-servo-cycle-loopback.sh`
- Curriculum SHA that introduced lab: `10f187e8a33b741f9af5c12975150ddbb497af1a`
- GitHub Actions run: `34029848545`
- Job: `101477262140`
- State at checkpoint creation: `in_progress`

The lab instruments the canonical linuxcncrsh simulation with `sampler`, places `sampler.0` after `motion-controller`, samples the shared motor-command/feedback loopback signal plus `joint.0.pos-fb` and `joint.0.pos-cmd`, commands a slow MDI X move, and evaluates lagged versus same-sample numerical relationships.

## Acceptance gates

Do not promote runtime claims from workflow color alone. Require all of:

1. fresh metadata for run `34029848545` and source SHA `10f187e8...`;
2. actual `motion-command-handler < motion-controller < sampler.0` order;
3. zero sampler overruns;
4. at least 100 samples with changing motor command;
5. declared lag error bounds pass;
6. same-sample feedback error is materially larger than lagged error;
7. same-sample `joint.0.pos-cmd` and motor command agree under this zero-compensation configuration;
8. explicit successful-completion marker.

If the lab fails before these semantic observations, classify it HARNESS INVALID and correct only the demonstrated harness defect. If it reaches the observations but contradicts the source-derived prediction, preserve the artifact and investigate the model rather than weakening the test.

## Exact resume point

Inspect run `34029848545` / job `101477262140`. Do not launch a duplicate while it remains active. If valid, write an accepted-result artifact and promote only the canonical-loopback timing relationship to TEST-CONFIRMED, then proceed directly to the M03 adversarial exam, correction pass, fresh-AI handoff, and graduation sufficiency decision. If M03 graduates, HM01 is next on the critical path.
