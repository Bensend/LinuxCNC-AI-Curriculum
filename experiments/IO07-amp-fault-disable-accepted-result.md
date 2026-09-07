# IO07 accepted result — amplifier fault to software disable

## Scope

This result accepts the corrected headless LinuxCNC amplifier-fault experiment for **IO07 — hardware enable and fault patterns**. It exercises LinuxCNC software/HAL state transitions at pinned upstream revision `8bf4605ae81042248add031e94c77300406e0413`.

It does **not** test HostMot2 packet/register delivery, physical amplifier behavior, STO, torque-removal time, electrical fail states, or functional-safety performance.

## Reproducible run

- Curriculum source commit: `93cc5f7bfb60de7441a368e0200811d0eb4ef751`
- Workflow run: `34076164338`, attempt 1
- Workflow artifact: `linuxcnc-lab-010-io07-amp-fault-disable-34076164338-1`
- Lab script: `lab-jobs/010-io07-amp-fault-disable.sh`
- Lab exit code: **0**
- Lab UTC finish: `2026-09-07T02:28:21Z`

The overall GitHub workflow showed failure only because the later **Commit readable results back to repository** step failed. The lab execution itself returned zero and the final workflow guard `Fail workflow if lab job failed` succeeded. Therefore the workflow conclusion must not be mistaken for the experiment conclusion.

## Preconditions verified

The experiment did not begin fault interpretation until it had proved:

1. the LinuxCNC runtime, `io07-amp-fault` signal, and realtime sampler were visible;
2. `motion-controller` executed before the fault-source component `or2.0`, and `or2.0` before `sampler.0` in `servo-thread`;
3. normal command-path machine enable had produced the baseline:
   - `motion.motion-enabled = TRUE`
   - `joint.0.amp-enable-out = TRUE`
   - `joint.0.amp-fault-in = FALSE`
   - `joint.0.faulted = FALSE`
   - `joint.0.error = FALSE`;
4. `or2.0.out` was the sole writer of the injected `io07-amp-fault` signal feeding `joint.0.amp-fault-in` and sampler pin 0.

## Realtime observation

A 500-sample, five-boolean realtime capture was taken in the same servo thread. The sampler reported **0 overruns**.

Observed sample analysis:

```text
baseline=34
injected=466
exact_fault_cycle=2
core_disable=465
later_error_clear=463
```

Definitions used by the test:

- `baseline`: fault input=0, faulted=0, error=0, motion-enabled=1, amp-enable=1
- `exact_fault_cycle`: fault input=1, faulted=1, error=1, motion-enabled=0, amp-enable=0
- `core_disable`: fault input=1, faulted=1, motion-enabled=0, amp-enable=0
- `later_error_clear`: fault input=1, faulted=1, error=0, motion-enabled=0, amp-enable=0

The experiment therefore captured the predicted transient state directly in realtime: after amplifier-fault assertion, at least two sampled servo periods simultaneously contained `faulted=1`, `error=1`, `motion-enabled=0`, and `amp-enable=0`.

The later asynchronous final state was:

```text
amp-fault-in=TRUE
faulted=TRUE
error=FALSE
motion-enabled=FALSE
amp-enable=FALSE
```

This demonstrates why userspace polling of `joint.0.error` was an invalid oracle for the transient: the error indication can clear after the controller has disabled motion while `joint.0.faulted` remains asserted.

## Diagnostic channel

LinuxCNC's error channel produced:

```text
ERROR joint 0 amplifier fault
```

The diagnostic therefore agrees with the injected source and realtime state transition.

## Reconciliation with source call flow

The accepted runtime result agrees with the pinned source trace:

`joint.0.amp-fault-in`
→ `process_inputs()` samples JOINT_FAULT
→ `check_for_faults()` marks fault/error and clears desired enabling
→ `set_operating_mode()` disables active joint/motion state
→ `output_to_hal()` publishes disabled outputs/status.

The sample ordering also explains the short-lived `joint.0.error=1` observation: state fields do not need to remain asserted forever for the disable transition to be real.

## Evidence classification

**TEST-CONFIRMED**, narrowly: on the pinned LinuxCNC userspace simulation and this configuration, an asserted `joint.0.amp-fault-in` from an enabled baseline causes the expected LinuxCNC software/HAL disable transition and amplifier-fault diagnostic.

Still only **SOURCE/DOC/EXTERNAL-HARDWARE dependent**, not test-confirmed here:

- propagation through HostMot2 or Ethernet;
- amplifier input electrical state;
- drive output-stage reaction;
- STO behavior;
- torque removal or stop time;
- safety integrity, diagnostic coverage, or PL/SIL performance.

## Adversarial lesson

A red GitHub Actions badge is not automatically a failed experiment. Conversely, a zero lab exit code is only meaningful because this harness proved its baseline, injection wiring, realtime sample ordering, exact transient condition, zero overruns, and diagnostic. Infrastructure outcome and experiment outcome must be evaluated separately.
