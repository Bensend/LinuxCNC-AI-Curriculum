# C01-023 attempt 1 reconciliation

## Disposition

**HARNESS INVALID — observation method can manufacture a one-servo-period apparent command difference.**

The frozen behavioral Gates A-H are unchanged.

## Authoritative run

- workflow: `34199237041`
- job: `101973964122`
- artifact: `10045220748`
- artifact digest: `sha256:66fa2611eef9fcebf61c68cc0497a6348f79dfb50ee46eab00f167fb6f48c688`
- triggering curriculum commit: `266d5d556861467497ebcf1d06a74c3ab219571a`
- pinned LinuxCNC SHA: `8bf4605ae81042248add031e94c77300406e0413`
- inner lab UTC: `2026-09-08T07:25:20Z` to `2026-09-08T07:28:39Z`
- exit code: `41`

Observed before exit:

```text
gate-A=PASS
gate-C=PASS
all-active-joints-homed=PASS
pre-move-inpos=PASS
gate-B=PASS
trace-samples=982
saw-nontrivial-both-joints=1
saw-moving-not-inpos=1
program-move-finished=1
max-abs-j1-j3-command-diff=0.001
max-abs-j1-command-feedback-loopback-diff=0.001
max-abs-j3-command-feedback-loopback-diff=0.001
error-count=0
gate-D=PASS
PREDICTION_FALSIFIED: duplicated Y joint commands diverged beyond frozen tolerance
```

The script exits at Gate E, before printing its raw CSV block and before the explicit Gate H proof, so attempt 1 cannot be accepted as a behavioral failure or pass.

## Why exit 41 is not valid evidence that inverse kinematics produced unequal duplicated commands

The harness samples the four decisive HAL values with four independent userspace calls:

```python
j1c=hv('joint.1.motor-pos-cmd')
j3c=hv('joint.3.motor-pos-cmd')
j1f=hv('joint.1.motor-pos-fb')
j3f=hv('joint.3.motor-pos-fb')
```

Those reads are sequential and have no same-servo-cycle snapshot guarantee. The fixture has a `SERVO_PERIOD = 1000000` ns (1 ms). During a moving trajectory, a servo update can occur between the `j1c` and `j3c` reads. Attempt 1's maximum apparent difference is exactly `0.001` machine unit. At the commanded 60 in/min = 1 in/s, one 1 ms servo period corresponds to exactly 0.001 in. The two command-to-feedback comparisons independently show the same 0.001 maximum signature, even though each feedback pin is directly net-connected to its own command signal in the fixture.

That is strong evidence that the userspace observation is temporally torn across servo updates. It is not evidence that `trivkins` assigned different values to the duplicated Y joints in one inverse-kinematics invocation.

Pinned source independently establishes the expected same-call assignment: `position_to_mapped_joints()` iterates mapped joints and assigns `pos->tran.y` to every joint in `Y_joints_bitmap`. It does not calculate a distinct Y value for the second mapped joint.

The frozen experiment itself explicitly requires *reliable* pin observation and says unreliable observation is HARNESS INVALID. Therefore attempt 1 is classified HARNESS INVALID rather than weakening the `1e-9` Gate E threshold or declaring LinuxCNC behavior falsified.

## Correction — preserve the gate, repair the measurement

Attempt 2 must preserve Gates A-H and the exact `1e-9` Gate E threshold. Replace the decisive sequential userspace `hal.get_value()` comparisons with a realtime same-thread snapshot:

1. load LinuxCNC's realtime `sampler` component with float channels for the relevant joint signals;
2. disable it before `addf`, add `sampler.0` to `servo-thread` **after** `motion-controller`, and net the existing joint 1/joint 3 command and loopback feedback signals into sampler pins;
3. begin draining the FIFO before enabling sampling so the FIFO does not fill with idle samples;
4. enable sampling for the coordinated move and preserve tagged samples using `halsampler` (or pinned Python HAL stream API if its provenance is proved);
5. calculate Gate E only from command values captured in the same sampler invocation/servo cycle;
6. retain direct independent endpoint-existence reads for Gate C, but do not use sequential userspace reads as the equality oracle;
7. preserve raw realtime sample data even on a failed behavioral gate, then perform controlled shutdown and Gate H evidence before returning the final lab exit code.

LinuxCNC's sampler architecture is specifically intended to capture HAL data in realtime and place same-invocation samples in a FIFO for userspace consumption. This removes the torn-read ambiguity without changing the behavioral prediction.

## Engineering lesson

A multi-channel control invariant such as `joint A command == joint B command` is a **simultaneous-state assertion**. Sequential userspace reads can turn a correct same-cycle invariant into a false disagreement whenever the producer updates between reads. For synchronization, anti-racking, following-error, or redundant-sensor work, the timestamp/sampling domain is part of the evidence contract.

This remains simulation/software evidence only. Equal same-cycle LinuxCNC command values do not prove equal physical positions, independent encoder correctness, hydraulic force balance, or safety-rated anti-racking protection.

## Exact checkpoint

Correct only the C01-023 observation harness as described above, keeping frozen Gates A-H unchanged. Run a single authoritative attempt 2 against the pinned build, preserve realtime same-cycle samples and cleanup evidence even on failure, then reconcile the original gates. Do not graduate C01 from attempt 1.