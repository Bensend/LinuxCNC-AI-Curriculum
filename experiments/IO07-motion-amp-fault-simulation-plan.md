# IO07 — bounded motion amplifier-fault simulation plan

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Exercise the production motion component without physical hardware and verify the software-level transition:

`joint.0.amp-fault-in: 0 -> 1` while motion is enabled -> `joint.0.faulted = 1`, `joint.0.error = 1`, `motion.motion-enabled = 0`, and `joint.0.amp-enable-out = 0`.

This experiment is intentionally narrower than drive/STO testing.

## Predicted result before execution

From pinned `control.c`, the fault input is sampled in `process_inputs()`, acted on by `check_for_faults()`, consumed by `set_operating_mode()`, and published by `output_to_hal()` during one invocation of `emcmotController()`. Therefore the observable disable should occur no later than the first motion servo invocation that samples the asserted HAL fault, plus HAL observer scheduling latency.

## Harness requirements

Use an existing userspace/simulation LinuxCNC configuration with at least one active joint. Avoid HostMot2 entirely for this experiment. The harness should:

1. start LinuxCNC headlessly with bounded startup/teardown;
2. establish controller enabled state and record baseline pins;
3. assert `joint.0.amp-fault-in` through a HAL signal/source pin that has a single writer;
4. wait a bounded number of servo periods;
5. capture `joint.0.faulted`, `joint.0.error`, `joint.0.amp-enable-out`, and `motion.motion-enabled`;
6. capture the emitted amplifier-fault diagnostic;
7. deassert the source and record that fault-input sampling clears `joint.0.faulted` while the controller remains disabled/error-latched until normal re-enable/recovery action;
8. preserve exact revision, configuration, commands, timestamps and raw output.

## Acceptance gates

PASS only if the fresh run proves all of:

- baseline controller/joint are enabled before injection;
- injected HAL source is demonstrably connected to `joint.0.amp-fault-in`;
- the faulted/error pins assert after injection;
- motion and amp-enable outputs deassert after injection;
- diagnostic text identifies joint amplifier fault;
- evidence is from the current run/revision rather than stale artifacts.

## Evidence boundary

A pass would be TEST-CONFIRMED only for LinuxCNC software/HAL state transitions in the simulation environment. It would not verify HostMot2 transport, physical drive disable, STO, torque-removal timing, contactors, or functional-safety performance.

## Next action

Implement this as the next numbered curriculum lab using the already hardened bounded headless harness pattern. Inspect existing workflow selectors/results first so no duplicate or stale run is launched.
