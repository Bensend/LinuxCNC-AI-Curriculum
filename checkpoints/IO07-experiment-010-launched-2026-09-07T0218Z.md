# IO07 checkpoint — experiment 010 launched

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Durable state

- `lab-jobs/010-io07-amp-fault-disable.sh` was added in curriculum commit `7afcdff5a5fb12e082aee8477827a1c491795f63`.
- The pre-launch `lab-results/LATEST.md` was still the accepted HM01 `009` result, run `34038328272`; therefore no prior IO07 result existed in the repository at launch.
- The runner selector was inspected before implementation: a push changing exactly one `lab-jobs/*.sh` selects that job, removes inherited `LATEST.*` before execution, writes run/SHA/job metadata, and publishes only a fresh result if the job reaches result generation.
- IO07 adversarial exam and correction pass are committed in `exams/IO07-adversarial-exam.md` and `guides/IO07-adversarial-corrections.md`; the source/safety reasoning passed independently of the lab.

## Experiment gates

The new job requires all of the following before it can pass:

1. normal LinuxCNC command path establishes `motion.motion-enabled=TRUE` and `joint.0.amp-enable-out=TRUE`;
2. `or2.0.out` is the sole writer of `io07-amp-fault`, connected to `joint.0.amp-fault-in`;
3. injection makes `joint.0.amp-fault-in` TRUE;
4. `joint.0.faulted` and `joint.0.error` become TRUE;
5. `motion.motion-enabled` and `joint.0.amp-enable-out` become FALSE;
6. LinuxCNC output contains the joint-0 amplifier-fault diagnostic;
7. metadata identifies this fresh job and pinned curriculum/source state.

The post-clear state is captured diagnostically but is not allowed to erase or weaken the core pass gates.

## Evidence boundary

Even a complete PASS is only TEST-CONFIRMED for the LinuxCNC software/HAL state transition in the headless simulation. It cannot establish HostMot2 delivery, FPGA behavior, drive reaction, STO, physical torque removal, electrical fail state, realtime physical reaction time, or functional-safety compliance.

## Exact resume action

Inspect the first fresh `010` result commit/artifact. Do not infer success from workflow launch. If it passes, reconcile every gate against the source call flow, write the accepted-result artifact and fresh-AI handoff, update `PROGRESS.md`, and graduate IO07 if no new blocking contradiction appears. If it fails, classify whether the failure is a harness defect or a substantive contradiction before any rerun; materially correct the harness rather than weakening the gates.
