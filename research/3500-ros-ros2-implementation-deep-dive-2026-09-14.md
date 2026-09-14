# 3500 — ROS / ROS 2 implementation deep dive

Date: 2026-09-14
Status: **DEEP IMPLEMENTATION SURVEY / MAJOR 3500 SUBTRACK**

## Purpose

ROS and especially ROS 2 are important enough to robotics that 3500 must treat them as a major implementation subtrack rather than an adjacent ecosystem note. The goal is not to turn the LinuxCNC curriculum into a generic ROS course. The goal is to understand, at source/config/field-implementation level, how ROS/ROS 2 planning, kinematics, frames, trajectory execution, hardware abstraction and cell orchestration can be combined with LinuxCNC/HAL-style deterministic machine control.

The course must distinguish **LinuxCNC proper**, **Machinekit/HAL**, **ROS 1**, **ROS 2**, **ros_control**, **ros2_control**, **MoveIt/MoveIt 2**, and **ROS-Industrial**. Do not casually call a Machinekit implementation a LinuxCNC implementation simply because they share HAL ancestry.

## High-level conclusion

The strongest implementation evidence found so far is the Tormach ZA6 architecture. It demonstrates a production-oriented pattern where:

`MoveIt 2 / ROS 2 planning -> ros2_control controller_manager -> HAL system interface -> realtime HAL -> EtherCAT / drives / feedback`

This architecture does **not** use LinuxCNC's G-code interpreter or LinuxCNC motion planner as the robot trajectory planner. Instead, `ros2_control` owns trajectory-controller execution while HAL provides the realtime hardware/control substrate. That is a fundamentally different architecture from native LinuxCNC robot control with `genserkins`/`pumakins` plus LinuxCNC motion.

For 3500, both architectures matter and must be compared honestly.

---

# 1. ROS 1 versus ROS 2

## ROS 1

Historical ROS/LinuxCNC and ROS/Machinekit experiments generally used one of these patterns:

1. ROS/MoveIt planned motion and streamed joint commands to HAL pins or a realtime bridge.
2. LinuxCNC/Machinekit provided servo loops, field I/O and hardware drivers.
3. Some experiments attempted to feed trajectories deeper into LinuxCNC/Machinekit through ringbuffers/NML-like mechanisms.
4. ROS-Industrial supplied robot descriptions, industrial-driver conventions, planning integrations and vendor controller interfaces.

The difficulty was not merely moving numbers between processes. The major problem was deciding who owned trajectory interpolation, kinematics, realtime deadlines, cancellation, faults and restart state.

## ROS 2

ROS 2 materially changes the implementation landscape because `ros2_control` is now a first-class hardware/control framework rather than the old ROS 1 `ros_control` model being an afterthought around a non-realtime ROS core.

Current `ros2_control` concepts that 3500 must understand include:

- `controller_manager`;
- lifecycle-managed hardware components;
- `hardware_interface::SystemInterface`, `ActuatorInterface` and `SensorInterface`;
- command versus state interfaces;
- `joint_state_broadcaster`;
- `joint_trajectory_controller`;
- controller switching;
- chained/cascade controllers;
- update-rate ownership;
- realtime-safe controller execution expectations;
- URDF/Xacro `<ros2_control>` hardware description;
- pluginlib hardware drivers;
- action-based trajectory execution and monitoring.

Current `joint_trajectory_controller` supports joint-space trajectories with timed waypoints and position/velocity/acceleration/effort interface combinations. It exposes action-based execution that can report success/failure/tolerance violations, which is significantly more appropriate for robot motion than fire-and-forget topic streaming.

---

# 2. Tormach ZA6 — primary real ROS 2 implementation

Primary repositories:

- `tormach/tormach_za_ros2_drivers`
- `tormach/hal_ros_control`
- associated `hw_device_mgr`

The official ZA6 ROS 2 repository contains:

- ZA6 URDF and meshes;
- tool/gripper descriptions;
- HAL hardware drivers;
- MoveIt configuration;
- bringup launch files;
- MoveIt Studio configurations, including a machine-tending configuration involving a Tormach PCNC 1100;
- Docker build/run infrastructure;
- real hardware and simulation modes.

The stack explicitly requires a Tormach controller with an RT_PREEMPT kernel and OS tuning for real hardware. EtherCAT is part of the hardware path.

### Hardware package

`za6_hardware` launches:

- the HAL realtime environment;
- EtherCAT (`lcec`) or simulated hardware drivers;
- `hw_device_mgr` for EtherCAT drive/device state;
- `hal_hw_interface`, which places a ROS 2 `controller_manager` into HAL;
- `hal_io`, which bridges ordinary HAL I/O to ROS topics.

Drive enable/fault state is deliberately separate from trajectory planning. ROS services expose drive enable/disable and error-zeroing, while the hardware/device manager owns detailed field-drive state.

This separation is important. `MoveIt says move` is not equivalent to `drives are electrically authorized and healthy`.

### `hal_ros_control`

The Tormach `hal_ros_control` project is the clearest bridge contract found so far.

Its `hal_control_node` runs `controller_manager::ControllerManager` in a realtime HAL thread. A complementary `HalSystemInterface` implements the ROS 2 `hardware_interface::SystemInterface` contract and creates HAL pins for the command/state interfaces declared in URDF.

Conceptually:

`ROS 2 joint command/state interface <-> HalSystemInterface <-> HAL pins <-> realtime HAL components/drivers`

`hal_io` is intentionally non-realtime and connects ordinary HAL values to ROS `std_msgs` topics. This is a useful boundary lesson: not every I/O bit needs to become part of the realtime trajectory loop.

The project includes a two-joint RRBot demo and supports runtime loading/switching of ROS 2 controllers.

### Maintenance status

`hal_ros_control` itself shows its latest visible commit in 2023, but the official ZA6 ROS 2 stack continued receiving hardware/ROS 2 fixes through 2025, including EtherCAT/HAL symbol fixes, drive-state behavior, startup NaN handling and `joint_trajectory_controller` compatibility. Therefore the architecture is not merely a dead 2020-era proof of concept, although dependency/version status must be checked before treating it as a current turnkey stack in 2026.

---

# 3. MoveIt / MoveIt 2 role

3500 must learn exactly what MoveIt provides and what it does not.

MoveIt 2 can own or contribute:

- robot model loading;
- planning scene;
- collision geometry;
- IK plugins;
- path planning;
- joint constraints;
- Cartesian path generation;
- trajectory generation;
- planning groups;
- multiple manipulators/groups;
- controller selection/interface through MoveIt controller managers;
- interactive visualization in RViz;
- motion execution through `ros2_control` trajectory controllers.

MoveIt does not magically provide a safe physical robot controller. Drive state, brakes, torque enable, safety PLC/relay, STO, fieldbus faults, encoder validity and machine-specific recovery remain separate concerns.

Current MoveIt controller documentation treats `ros2_control` as the normal execution path. MoveIt connects to `JointTrajectoryController` action interfaces, allowing planned trajectories to be sent to the active controller rather than directly commanding motor hardware.

## MoveIt Servo

MoveIt Servo is a separate important mode. It accepts high-rate joint-jog, Cartesian twist or pose commands and can produce joint trajectories. This is relevant for:

- joystick/SpaceMouse teleoperation;
- visual servoing;
- force-guided or sensor-guided incremental motion;
- interactive tool-frame jogging.

3500 must compare MoveIt Servo to LinuxCNC joint/world jogging and avoid assuming they are interchangeable. Servo-style reactive command streams raise latency, watchdog, frame and stop/recovery questions that differ from executing a preplanned trajectory.

---

# 4. TF / robot frames

ROS robot software depends heavily on URDF and TF/TF2 frame relationships. This deserves its own 3500 implementation lesson because LinuxCNC users often think primarily in machine coordinates, work offsets and tool offsets.

ROS/MoveIt concepts include:

- `world` / planning frame;
- robot base frame;
- link frames;
- flange frame;
- TCP/tool frame;
- work/object frames;
- sensor frames;
- dynamically published transforms;
- timestamped transforms.

The course must map these concepts carefully to LinuxCNC notions such as machine/world coordinates, kinematics coordinates, tool offsets and work coordinates without pretending the data models are identical.

A major failure class is **frame correctness with plausible motion**: the robot may move smoothly while the flange/TCP or work-object transform is wrong.

---

# 5. Four architectures 3500 must compare

## Architecture A — Native LinuxCNC robot

`G-code / LinuxCNC UI -> interpreter/task/motion -> LinuxCNC kinematics -> joint commands -> HAL -> drives`

Strengths:

- native LinuxCNC deterministic motion stack;
- direct compatibility with LinuxCNC HAL/hardware ecosystem;
- natural for machining/process paths already expressible as XYZABC G-code;
- fewer middleware layers.

Weaknesses:

- robotics planning/collision ecosystem is much thinner than MoveIt;
- reactive planning, planning scenes and complex cell tasks require custom work;
- multiple IK branches/singularity-aware planning are less feature-rich than dedicated robotics stacks.

## Architecture B — ROS 2 / MoveIt 2 + ros2_control + HAL

`MoveIt 2 -> FollowJointTrajectory / ros2_control -> realtime HAL bridge -> drives`

This is the Tormach ZA6 model.

Strengths:

- uses mainstream ROS 2 robot model/planning/control interfaces;
- integrates collision checking, planning scene, RViz, ROS sensors and robot-task ecosystem;
- trajectory execution has explicit action feedback/tolerance behavior;
- HAL can still provide robust field I/O and hardware drivers.

Weaknesses:

- bypasses LinuxCNC interpreter/motion planner;
- Machinekit HAL versus LinuxCNC HAL compatibility must not be assumed;
- more distributed state/lifecycle/version complexity;
- realtime and ordinary ROS nodes must be partitioned carefully.

## Architecture C — ROS planner streams joint targets into LinuxCNC/HAL servo layer

Historical LinuxCNC discussions often proposed:

`MoveIt/ROS -> joint targets -> HAL pins -> LinuxCNC/HAL PID/drive layer`

This can be conceptually simple but creates critical questions:

- who interpolates between targets?
- what timing jitter is acceptable?
- who owns limits and velocity/acceleration constraints?
- what happens on stale ROS commands?
- how is cancellation reconciled?
- how is following error separated from communications timeout?
- is LinuxCNC motion bypassed entirely?

Do not promote this architecture without answering those questions.

## Architecture D — ROS plans, LinuxCNC executes a durable program/path

`ROS/MoveIt/offline planner -> exported Cartesian path/G-code/job -> LinuxCNC native motion -> HAL`

This is attractive for machining, trimming, welding or dispensing tasks that do not require continuously reactive collision avoidance.

Strengths:

- LinuxCNC retains execution authority;
- generated artifact can be inspected/replayed;
- ROS does not need to stay alive during execution;
- easier recovery/provenance model.

Weaknesses:

- translation from MoveIt trajectory/poses to LinuxCNC program semantics is nontrivial;
- IK branch continuity and orientation interpolation must remain valid after translation;
- less suitable for sensor-reactive planning.

---

# 6. Realtime ownership

This is the most important implementation boundary.

ROS topics, DDS transport and ordinary Python nodes should not casually sit in the final servo loop. If ROS 2 owns low-level execution, the controller/update path must be designed around `ros2_control` realtime expectations or an equivalent bounded mechanism.

Tormach's architecture is instructive because it puts `controller_manager` inside a realtime HAL thread and uses HAL pins as the deterministic bridge to the machine hardware, while ordinary I/O bridging runs as userspace ROS nodes.

3500 should source-trace:

- exact `read -> controller update -> write` ordering;
- controller update frequency;
- command/state interface initialization;
- stale command behavior;
- trajectory cancel behavior;
- controller switching behavior;
- drive-fault propagation;
- ROS node failure versus realtime control-thread failure;
- EtherCAT watchdog/device-manager behavior;
- startup/shutdown sequencing.

---

# 7. External axes and multi-robot cells

ROS/MoveIt 2 can represent multiple planning groups and external axes more naturally than traditional single-path G-code systems, but execution architecture still matters.

3500 must study:

- robot on linear rail;
- rotary workpiece positioner;
- coordinated robot + positioner path;
- two robot arms in one planning scene;
- robot tending a LinuxCNC machine;
- independent versus synchronized mechanisms.

Tormach's repository contains a machine-tending MoveIt Studio configuration involving a ZA6 and PCNC 1100, making it a strong cell-level study target.

Do not assume MoveIt multi-group planning solves physical execution synchronization. Controller groups, clocks, field I/O, machine-cycle state and inter-controller handshakes still require explicit architecture.

---

# 8. ROS-Industrial

ROS-Industrial should be studied as the industrial integration layer, especially for:

- common robot driver conventions;
- vendor robot support;
- manufacturing process planning;
- industrial messages/interfaces;
- robot/CNC cell integration patterns;
- calibration and tooling workflows.

The curriculum should distinguish ROS-Industrial driver conventions from direct-drive retrofit architectures like Tormach HAL or universal-IRC-1. A ROS-Industrial driver often talks to a vendor's existing robot controller, whereas a LinuxCNC/HAL retrofit may replace much of that controller.

---

# 9. ROS 1 -> ROS 2 migration lesson

Do not teach ROS 1 as the preferred new architecture, but preserve it because:

- many important robot implementations and papers are ROS 1;
- terminology and packages evolved from ROS 1;
- old LinuxCNC/Machinekit bridge experiments explain architectural tradeoffs;
- real installations may still have ROS 1 dependencies.

The Tormach ZA6 repo documents an especially concrete migration issue: its ROS 2 environment updates the EtherCAT master in a way that breaks the older ROS 1 stack until the host is reverted. This is an excellent example of why middleware migration is also a fieldbus/dependency/OS integration problem, not just a source-code port.

---

# 10. 3500 deep-dive progression

## 3500-ROS1 — historical architecture and lessons

Study:

- `tomlarkworthy/linuxCNC_ROS`;
- historical Machinekit ROS HAL bridges;
- LinuxCNC forum ROS-link and HAL-ringbuffer discussions;
- ROS-Industrial historical driver model.

Outcome: understand why naive ROS-topic-to-HAL designs are insufficient and which problems drove later architectures.

## 3500-ROS2 — `ros2_control` architecture

Source-trace:

- Resource Manager;
- hardware interface lifecycle;
- System/Actuator/Sensor interfaces;
- controller manager loop;
- joint state broadcaster;
- JointTrajectoryController;
- action versus topic command paths;
- controller switching;
- realtime rules.

## 3500-MOVEIT2 — planning/execution boundary

Trace:

- URDF/SRDF;
- planning groups;
- IK plugins;
- planning scene/collision model;
- controller manager interface;
- FollowJointTrajectory execution;
- MoveIt Servo;
- TF/tool/work frames;
- external axes/multiple groups.

## 3500-ZA6 — real implementation source trace

Deep-read Tormach:

- `tormach_za_ros2_drivers`;
- `hal_ros_control`;
- `za6_hardware`;
- `za6_moveit_config`;
- EtherCAT/HAL configuration;
- drive enable/fault state;
- simulator path;
- machine tending config;
- Docker/RT_PREEMPT environment.

Freeze exact call flow from MoveIt trajectory to hardware command and from encoder/drive state back to ROS.

## 3500-LCNC-ROS2 — direct LinuxCNC feasibility

After understanding ZA6, answer explicitly:

- Can `hal_ros_control` be adapted cleanly from Machinekit HAL to current LinuxCNC HAL?
- Which RTAPI/HAL APIs differ?
- Can `controller_manager` safely run inside a LinuxCNC realtime component/thread?
- If not, what bounded shared-memory/ringbuffer interface is appropriate?
- Is it preferable to leave LinuxCNC motion active and hand it durable paths rather than bypassing motion?
- What functionality is gained/lost in each architecture?

Do not write a full bridge as a curriculum deliverable. A small simulated proof may be used if source evidence cannot resolve one narrow compatibility question.

---

# 11. Candidate bounded learning experiments

Allowed only where they answer a specific implementation uncertainty:

1. Run a stock `ros2_control` RRBot trajectory and inspect controller action/state transitions.
2. Run Tormach's HAL RRBot simulation and trace ROS 2 joint command -> HAL pin -> feedback.
3. Inject stale/missing command or trajectory cancellation and record actual controller behavior.
4. Switch forward-position and trajectory controllers and record ownership/state transition.
5. Compare MoveIt planned trajectory timestamps with `joint_trajectory_controller` execution.
6. Run MoveIt Servo in simulation and observe watchdog/stop/frame behavior.
7. Use a simple URDF tool-frame error and prove how TF/model error propagates to TCP motion.
8. Only if justified, compile a minimal current-LinuxCNC HAL component exposing command/state pins and compare its lifecycle/API surface with Tormach's Machinekit HAL assumptions.

Do not turn these experiments into a production ROS-LinuxCNC bridge inside the curriculum.

---

# 12. Safety and recovery boundary

ROS 2, MoveIt 2, `ros2_control`, LinuxCNC and HAL all provide ordinary control/diagnostic capabilities. None should be assumed to provide safety-rated protective functions merely because they can stop motion or detect a fault.

3500 must separately track:

- E-stop/STO/safety PLC chain;
- brake control;
- drive power authorization;
- safety-rated speed/position if required;
- ordinary trajectory cancellation;
- ordinary controller fault;
- collision planning versus safety-rated collision/protective-stop behavior;
- loss of ROS graph/network/process;
- loss of realtime controller thread;
- loss of fieldbus;
- stale encoder/joint state;
- recovery/re-reference requirements.

A robot that has stopped because a ROS node died is not thereby in a validated safe state.

---

# 13. Current recommendation

ROS 2 should be a **major 3500 competency**.

The strongest near-term study sequence is:

1. learn current `ros2_control` contracts;
2. learn MoveIt 2 planning/execution and TF model;
3. source-trace the Tormach ZA6 stack end-to-end;
4. compare it to native LinuxCNC `genserkins`/motion;
5. then investigate a direct modern LinuxCNC/ROS 2 bridge or durable path-handoff architecture.

Do not decide in advance that ROS 2 must replace LinuxCNC motion or that LinuxCNC must remain the robot planner. The curriculum should make the AI competent enough to choose based on the application: machining-style predetermined paths, sensor-reactive robotics, multi-arm cells, machine tending, external-axis coordination, or custom retrofit hardware.