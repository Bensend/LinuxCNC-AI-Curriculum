# LinuxCNC joint amplifier authority call flow

Date: 2026-09-12
Status: **SOURCE-CONFIRMED 3600 SUPPORTING TRACE**
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Ground the press-brake actuator-authority lesson in LinuxCNC's own joint enable/fault path instead of treating `pid.enable`, `amp-enable-out`, physical drive state and brake state as interchangeable.

## Public HAL interfaces

Pinned `motion.9` documents:

- `joint.N.amp-enable-out`: TRUE if the amplifier for the joint should be enabled;
- `joint.N.amp-fault-in`: input to report an amplifier fault;
- `motion.enable`: when FALSE during enabled motion, motion stops and the machine is placed in machine-off state.

The standard `lib/hallib/servo_sim.hal` example explicitly connects `joint.N.amp-enable-out` to `pid_*.enable`. That means the stock PID's documented disable behavior—zero output and integrator reset—can naturally be aligned with LinuxCNC joint authority, but only when the HAL design actually makes that connection.

## Pinned source call flow

### 1. HAL amplifier fault becomes joint fault state

`src/emc/motion/control.c::process_inputs()` reads each active joint's `amp_fault` HAL input and sets or clears `JOINT_FAULT_FLAG`.

### 2. Fault checking revokes motion enabling

Later in the same servo-cycle controller sequence, `check_for_faults()` checks active enabled joints. A set joint fault:

- reports `joint %d amplifier fault` once;
- sets the joint error flag;
- sets `emcmotInternal->enabling = 0`.

The same function independently treats following error and hard limits as fault reasons. This keeps diagnostic cause separate even though they converge on motion disable.

### 3. Operating-mode transition disables joints

`set_operating_mode()` sees `enabling == 0` while motion is enabled and performs the disable transition:

- clears the coordinated trajectory planner;
- disables/freezes per-joint free planners;
- drains joint interpolators;
- clears each active joint's enable flag;
- cancels homing;
- aborts coordinate jogging;
- clears the motion-enable flag.

It intentionally does not erase the joint/motion error flag explaining why disable occurred.

### 4. Joint enable flag is published as `amp-enable-out`

Later in `emcmotController()`, LinuxCNC publishes `GET_JOINT_ENABLE_FLAG(joint)` directly to `joint.N.amp-enable-out`.

Thus a reported amplifier fault has a source-confirmed route to withdrawal of the joint's ordinary amplifier-enable request.

## Why this matters to a braked press-brake axis

The LinuxCNC path distinguishes at least four concepts:

1. LinuxCNC's request that a joint amplifier be enabled (`amp-enable-out`);
2. physical drive/amplifier state, which machine HAL may observe separately;
3. amplifier fault feedback (`amp-fault-in`);
4. any mechanical brake/hydraulic authority state outside stock motion.

Stock motion does not infer physical amplifier-running state merely because `amp-enable-out` is TRUE. Likewise, stock `pid` does not infer downstream actuator authority from its own output.

An application can deliberately couple these layers—for example, an in-tree historical Mazak configuration releases a Z brake from observed amplifier-running state—but that is machine HAL policy, not an automatic consequence of the joint command path.

## Timing/order note

`emcmotController()` calls `process_inputs()` before `check_for_faults()` and `set_operating_mode()`. The same controller invocation therefore reads the amp-fault input, marks the joint fault, decides to disable, and clears joint-enable state before the later HAL-output publication of `amp-enable-out`.

This is source-level ordinary-control timing, not a certified stopping-time or safety-response guarantee. Real hardware I/O read/write ordering, drive latency, contactor/brake mechanics and safety systems remain outside this claim.

## Adversarial checks

**Premise:** `joint.N.amp-enable-out == 1` proves the amplifier is physically running.  
Reject. It is LinuxCNC's enable request. Physical running/ready state requires separate evidence if needed.

**Premise:** `joint.N.amp-fault-in` and following error are equivalent fault signals.  
Reject. `check_for_faults()` preserves them as distinct diagnostic causes even though both can revoke motion enabling.

**Premise:** connecting `joint.N.amp-enable-out` to `pid.enable` automatically solves brake sequencing.  
Reject. It aligns controller enable/reset with LinuxCNC joint authority; it does not establish when a mechanical brake should release, how release is confirmed, or what delay/fault policy is appropriate.

## Curriculum consequence

The generic 3600 contract should carry explicit fields for requested joint/controller authority, observed downstream readiness, final command, feedback validity, and mechanical/hydraulic authority when the machine architecture needs them. Collapsing these into one `enabled` bit loses both diagnostic meaning and recovery provenance.

No new lab is warranted: this call flow is directly source-observable, and machine-specific timing would require real hardware or a specific drive/brake implementation rather than another generic simulation.
