# C01-023 — duplicated-coordinate dual-joint command fan-out

## Freeze status

**FROZEN before harness implementation.** Gates below may not be weakened after execution begins. A harness defect may be corrected only with an explicit HARNESS INVALID diagnosis that preserves the behavioral gates.

## Objective

Independently verify the C01 source claim that a coordinated move on a duplicated `trivkins` world coordinate produces matching position commands for two distinct joints, while preserving separate joint-level HAL observability.

This is a software/simulation topology experiment. It does not claim physical actuator synchronization or functional safety.

## Revision / provenance

LinuxCNC source under test must be exactly:

`8bf4605ae81042248add031e94c77300406e0413`

The harness must print the checked-out commit and prove that the runtime executable/configuration came from that checkout/build.

## Fixture

Use the pinned upstream gantry-style mapping:

```ini
[KINS]
JOINTS = 4
KINEMATICS = trivkins coordinates=XYZY kinstype=BOTH
```

Y is represented by joint 1 and joint 3. The simulation may reuse/adapt upstream `configs/sim/axis/gantry/gantry.ini` and `lib/hallib/gantrysim.hal`, but the harness must expose the relevant runtime pins and not merely grep the files.

## Predeclared prediction

After the machine is placed in a state that permits coordinated motion and a nonzero Y world-coordinate move is commanded:

1. both `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` will change from baseline;
2. throughout the sampled coordinated segment, their commanded positions will match within a tight numerical tolerance because duplicated-coordinate inverse kinematics copies `pos->tran.y` to both mapped joints;
3. joint 1 and joint 3 will nevertheless remain distinct HAL objects with separately readable `motor-pos-cmd` and `motor-pos-fb` endpoints;
4. with the upstream direct loopback fixture, each feedback will follow its own command, but that equality is fixture behavior and must not be interpreted as proof of a two-plant synchronization controller.

## Required raw observations

Preserve at minimum:

- checked-out LinuxCNC SHA;
- exact INI/config path used;
- joint count and kinematics declaration;
- machine/task mode and homed state needed to justify coordinated motion;
- monotonic timestamped samples of:
  - Y/world command or an equivalent independent indication that the coordinated move is in progress;
  - `joint.1.motor-pos-cmd`;
  - `joint.3.motor-pos-cmd`;
  - `joint.1.motor-pos-fb`;
  - `joint.3.motor-pos-fb`;
- maximum absolute difference between joint 1 and joint 3 commanded positions during the decisive move;
- evidence that the two joint pin names resolve independently rather than by aliasing one single pin name;
- cleanup/shutdown evidence.

## Frozen gates

### Gate A — provenance

PASS only if the tested checkout is exactly the pinned SHA and the harness demonstrates that the LinuxCNC runtime/config came from that checkout/build.

### Gate B — duplicated-coordinate runtime topology

PASS only if the running fixture has four joints and the active kinematics configuration maps one Y coordinate to joint 1 and joint 3 using `trivkins ... kinstype=BOTH`. File text alone without a running fixture is insufficient.

### Gate C — distinct joint observability

PASS only if both joint 1 and joint 3 `motor-pos-cmd` and `motor-pos-fb` endpoints exist and are independently readable under distinct HAL names.

### Gate D — meaningful coordinated move

PASS only if the harness establishes coordinated/world motion and the sampled Y movement is nontrivial; a stationary equality of two zero-valued pins does not count.

### Gate E — duplicated command fan-out

PASS only if both joint command signals change materially and their maximum absolute difference during the decisive coordinated segment is <= `1e-9` machine units (or an equivalently strict tolerance justified by exact common-command representation).

### Gate F — loopback interpretation

PASS only if the harness verifies the expected per-joint feedback loopback **and explicitly reports** that this is an ideal fixture, not evidence of physical synchronization or plant agreement. If the runtime uses a different simulated plant, its relationship must be stated instead of silently assuming loopback.

### Gate G — no false second-joint/world-position inference

PASS only if the conclusion remains limited to command fan-out and separate joint observability. The experiment must not use the world Y readout alone as proof of joint 3 feedback/position truth.

### Gate H — controlled cleanup

PASS only if the launched LinuxCNC runtime is shut down and the harness does not leave a live process/HAL namespace that can contaminate a later run.

## Falsification

The source prediction is falsified if, with valid duplicated-Y configuration and a real coordinated Y move, joint 1 and joint 3 receive materially different `motor-pos-cmd` values. Such a result must trigger source/configuration reconciliation before C01 graduation.

If the move cannot be established, pins cannot be observed reliably, homing/world-mode state is ambiguous, or the fixture is not proven to be the pinned runtime, classify the attempt HARNESS INVALID rather than claiming a LinuxCNC behavioral failure.

## Safety boundary

All observations are software/simulation evidence. A matching pair of LinuxCNC joint commands does not prove two real actuators moved together, does not prove independent feedback correctness, and does not provide a safety-rated anti-racking function.
