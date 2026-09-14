# Active Curriculum Session State

Session start UTC: `2026-09-14T20:38:18Z`
Session end UTC: `2026-09-14T20:50:54Z`
Actual elapsed: **12.6 minutes**
Status: **CLOSED — 3400 generic Motion-DOUT boundary source-closed; 3500 native kinematics failure path and Tormach ROS2/HAL drive-authority path advanced.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. This session did not reopen, repoll or rescore closed prerequisite work.

## Active branch

Active 3000 work is now **3500 — Robots / Custom Kinematics**.

Latest checkpoint: `checkpoints/3500-next-2026-09-14b.md`.

The prior `checkpoints/3500-next-2026-09-14.md` remains authoritative background and already promoted ROS/ROS2 to a major 3500 subtrack. Checkpoint B adds the new native-kins and Tormach field-authority evidence.

3400 is paused at `checkpoints/3400-next-2026-09-14d.md`. 3300 remains open at its bounded source stops, 3200 remains intentionally paused, and 3600 remains at its branch-local information-gain stop.

## Durable work completed

Created:

- `research/3400-motion-dout-transition-source-closeout-2026-09-14.md`
- `checkpoints/3400-next-2026-09-14d.md`
- `research/3500-robots-custom-kinematics-foundation-2026-09-14.md`
- `research/3500-kinematics-failure-propagation-2026-09-14.md`
- `research/3500-tormach-hal-ros-control-realtime-loop-source-trace-2026-09-14.md`
- `research/3500-za6-drive-enable-zero-error-brake-authority-source-trace-2026-09-14.md`
- `research/3500-za6-joint-command-quickstop-source-trace-2026-09-14.md`
- `checkpoints/3500-next-2026-09-14b.md`

Updated `PROGRESS.md` to make 3500 the active 3000 branch and preserve the newer ROS/ROS2 priority already present in the repository.

## 3400 source closeout

Pinned LinuxCNC Motion source established that already-applied custom `motion.digital-out-NN` state is not generically cleared by program Abort or Motion Disable. The upstream Task E-stop sequence uses Motion Abort, spindle off, Disable and IO/amp actions but exposes no custom-DOUT reset. A queued future synchronized DOUT is a different state and may disappear when TP is aborted.

Therefore a custom M64/M65 drawbar/auxiliary output cannot be treated as an Abort/E-stop cleanup primitive. Exact physical terminal state at process shutdown remains hardware/driver/external-circuit specific. The proposed generic DOUT transition lab is dropped as duplicate evidence.

## 3500 native kinematics

Pinned LinuxCNC source established:

- switchkins changes should use synchronized `G12.1/G13.1`; the raw HAL switch path is deprecated because interpreter lookahead can retain stale kinematics;
- kinstype persists across program end/Abort;
- `genserkins` uses an iterative Jacobian inverse seeded from current/supplied joints;
- Jacobian inversion failure or iteration exhaustion returns inverse failure;
- coordinated/teleop realtime inverse failure or non-finite joint output sets Motion error and requests disable;
- resulting joint soft limits remain a separate downstream backstop;
- `scarakins` explicitly carries elbow branch state and clamps its cosine argument, leaving a bounded reach-boundary validation target.

## 3500 Tormach ROS2/HAL implementation

At `tormach/hal_ros_control@506a3d109cb306e1d1cdb70f24440bde1159b256`, the HAL realtime function owns:

`controller_manager.read -> update -> write`.

The ROS executor runs in a separate userspace thread. The generic HalSystemInterface copies HAL feedback into ros2_control state and ros2_control commands back to HAL command pins. Its generic activate/deactivate and `CM_OK=0` path do not explicitly drive command pins to a safe value, so downstream field authority had to be traced.

At `tormach/tormach_za_ros2_drivers@b58078aac3004f3932079ea7228ab0432cf8ac18`, drive START/STOP is explicitly separate from controller ownership. Before drive START, `zero_error()` publishes a one-point trajectory equal to current joint feedback and waits until command-feedback error is within 0.001 rad. START then waits for device-manager state feedback plus `goal_reached`, with timeout/fault handling.

Homing separately manipulates Inovance brake-function SDO state, asserts a per-joint home request, waits for success/error/timeout, zeroes command error, then restores normal brake behavior. Per-joint HAL plumbing inserts joint limits and realtime command shaping between ros2_control and EtherCAT.

The EtherCAT path also exposes a cross-drive quick-stop rule: when any drive faults, the drive-safety chain forces the CiA-402 quick-stop bit low across drive control words before they reach EtherCAT. This is operational fault containment, not proof of safety-rated STO.

## Remaining 3500 gap

Runtime stale-command containment is not yet fully closed. The new source shows enable-time command reconciliation and drive-fault quick-stop, but not what happens if `hal_control_node`/controller-manager simply stops updating while EtherCAT and drives remain otherwise healthy.

Exact next work is preserved in `checkpoints/3500-next-2026-09-14b.md`: trace `hw_device_mgr`/lcec command freshness/watchdog behavior and current JointTrajectoryController cancel/deactivate/hold semantics before deciding whether an RRBot/ZA6 stale-command experiment adds independent evidence.

## Adversarial / lab state

- 3400 Motion-DOUT closeout: **7/7 passed**.
- 3500 native foundation: **8/8 passed**.
- 3500 inverse-failure propagation: **6/6 passed**.
- Tormach HAL realtime-loop trace: **8/8 passed**.
- ZA6 drive-state/brake trace: **8/8 passed**.
- ZA6 quick-stop/command pipeline trace: **7/7 passed**.

No lab was run. `LAB_COMPUTE_LOG.md` remains unchanged at the preserved exact-recorded total of **338.56 minutes (5.64 h)**.

Overlap: **No overlap.** Previous canonical session ended `2026-09-14T19:42:32Z`; this session began `2026-09-14T20:38:18Z`, **55m46s later**.
