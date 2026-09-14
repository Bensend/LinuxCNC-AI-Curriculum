# 3500 Robots and Custom Kinematics — breadth survey

Date: 2026-09-14
Status: **BREADTH / TRACK-MAP PASS**

Pinned LinuxCNC source revision for source-level claims remains `f666f1a51ae7c4d991cc61233e785dcc53fbe98d` where applicable.

## Purpose

Map the 3500 specialization before deep-diving one robot family. The goal is to understand where LinuxCNC is already strong, what real robot/parallel-kinematic implementations exist, and which gaps are uniquely important for robots rather than ordinary CNC machines.

The curriculum scope includes SCARA, six-axis arms, delta/parallel mechanisms, non-Cartesian machines, custom kinematics, singularities, joint/Cartesian limits, homing/reference strategies, path-planning boundaries, visualization and diagnostics.

## High-level result

LinuxCNC already has a substantial native non-Cartesian foundation. Upstream kinematics include:

- `genserkins` for generalized serial manipulators with up to six angular joints using modified Denavit-Hartenberg parameters;
- `pumakins` for PUMA-style six-axis arms;
- `scarakins`;
- `lineardeltakins` and `rotarydeltakins`;
- `genhexkins` for six-DOF Stewart/hexapod mechanisms;
- `pentakins`, `tripodkins`, `corexykins`, `rosekins`, rotated and several 5-axis machine kinematics;
- `userkins` / custom kinematics provisions for out-of-tree mechanisms.

Several of the complex modules support `switchkins`, allowing the machine to switch between world/tool kinematics and identity joint control. LinuxCNC ships simulation configurations for SCARA, PUMA/genserkins, PUMA/pumakins, hexapod and multiple 5-axis mechanisms. This makes simulation-first commissioning a natural 3500 method rather than an optional visualization extra.

The breadth pass indicates that 3500 should be split conceptually into four machine/problem classes rather than taught as one generic 'robotics' topic:

1. **Serial industrial arms** — PUMA/Fanuc/KUKA/Denso-style 5/6-axis arms, usually with brakes, absolute encoders and multiple inverse-kinematic solutions.
2. **SCARA / palletizer / delta robots** — lower-DOF mechanisms with machine-specific kinematics, high-speed pick-and-place use and often EtherCAT servo drives.
3. **Parallel kinematics** — hexapods/Stewart platforms, tripods and pentapods with iterative forward kinematics, geometry calibration and convergence concerns.
4. **Custom/non-Cartesian mechanisms** — mechanisms not covered by stock kinematics, requiring `userkins`, custom forward/inverse transforms and explicit singularity handling.

## Real implementation evidence

### Fanuc R-2000iA / universal-IRC-1

`ExcessiveOverkill/universal-IRC-1` is a particularly valuable field case. It retrofits a Fanuc R-2000iA 200F using LinuxCNC, Mesa HostMot2 hardware and ODrive servo drives. LinuxCNC owns servo loops, path planning, kinematics and G-code interpretation. The project also had to solve proprietary Fanuc encoder interfacing, brake control and custom FPGA/HostMot2 support.

Important lessons:

- industrial robot retrofit difficulty often lies below the kinematics layer: encoder protocols, commutation, brakes, drive interfaces and reference retention;
- absolute multi-turn position matters because a gravity-loaded articulated arm cannot casually discard joint state at restart;
- ordinary software following-error/collision detection is not equivalent to modern robot safety functions;
- slow/low-voltage retrofit drives may preserve torque while badly degrading robot speed/dynamics;
- robot brake release is itself a hazardous machine state that needs explicit control and commissioning discipline.

### Current PUMA 200 field work

A July-August 2026 LinuxCNC forum build is operating all six PUMA 200 joints, brakes and encoders and then commissioning `genserkins`. The problems reported are not basic axis motion but tool-frame orientation, sign conventions, homing/reference frames and world-mode behavior. This is a strong example of the exact 3500 transition from 'six servos move' to 'the Cartesian robot model is trustworthy.'

### Delta / EtherCAT field work

Public LinuxCNC users report real delta robots on EtherCAT, including machines with absolute encoders and custom homing/reference behavior. A 2025 example showed that retaining drive encoder position across LinuxCNC restarts does not automatically mean the LinuxCNC Cartesian state/referencing model is reconciled correctly. This is a useful recovery/reference case for 3500.

### Hexapod field work

Multiple users have converted the shipped `genhexkins` simulation into real hardware. Their recurring difficulty is correctly describing base/platform geometry, actuator lengths, joint-axis unit vectors and sign/orientation conventions. `genhexkins` also exposes convergence/error/iteration state, making solver behavior itself part of diagnostics.

## Native LinuxCNC capabilities worth deep study

### Kinematics model

LinuxCNC explicitly separates joint space from Cartesian/world coordinates. Kinematics modules provide forward and inverse transforms between those spaces. For generalized serial robots, `genserkins` uses modified Denavit-Hartenberg parameters supplied through HAL.

### Switchable kinematics

`switchkins` is central to 3500. Complex mechanisms can switch to identity/joint control for setup, homing, recovery or singularity avoidance. The active kinematics type is visible through HAL, but switching requires synchronization between interpreter and motion state and creates substantial operator/UI obligations.

### Custom kinematics

LinuxCNC provides `userkins` and user-k-function templates so an unusual machine can implement its own forward/inverse kinematics outside the main tree. 3500 should teach the contract and test method, not merely provide formulas.

### Visualization

QtVismach can embed an animated 3D model in QtVCP and bind motion directly to HAL/joint feedback. Existing SCARA/PUMA/hexapod simulations mean the learner can test geometry, frame conventions and world/joint motion before energizing real hardware.

## Distinctive 3500 technical problems

### 1. Coordinate frames and DH conventions

A robot's correctness depends on base frame, link/joint definitions, flange frame, tool center point and work frame being consistent. A wrong sign or a different DH convention can produce plausible joint motion but an incorrect TCP.

### 2. Multiple inverse solutions

Serial robots may reach the same TCP pose with different shoulder/elbow/wrist configurations. 3500 must study solution continuity, branch selection and how LinuxCNC's kinematics implementation preserves or changes joint configuration across moves.

### 3. Singularities

Singularities are not just a mathematical curiosity. Near singularities, small Cartesian changes can require extreme joint velocity or cause an inverse solution to become invalid. `switchkins` explicitly exists in part to permit joint control when ordinary Cartesian motion becomes problematic.

### 4. Joint limits versus Cartesian reachability

A requested Cartesian pose can be mathematically reachable while violating a real joint limit, cable/hosing constraint or collision envelope. Conversely, safe joint positions do not guarantee the intended Cartesian/tool path is safe. These are separate validity layers.

### 5. Homing/reference and restart reconciliation

Robots may use absolute encoders, battery-backed multi-turn encoders, index marks or hard reference fixtures. LinuxCNC's world pose after startup must be reconciled with actual joint state. A drive remembering its encoder count is not sufficient evidence that the Cartesian model is valid.

### 6. Gravity, brakes and servo disable

Vertical/articulated joints can move violently when brakes release or servo torque disappears. Brake sequencing, drive-ready state, torque enable and reference validity must be studied as an integrated machine-state problem.

### 7. Tool-coordinate motion

Robot tasks often need jogging or programmed motion relative to the current hand/tool frame, not only the world frame. Historical LinuxCNC discussions show this as an important robot-control requirement for grippers, welding torches and spray tools and an area that deserves current source/implementation review.

### 8. CAM/postprocessing and path intent

For robot machining, welding, spraying, dispensing or trimming, the difficult handoff is frequently CAD/CAM/toolpath orientation rather than servo control. LinuxCNC can consume Cartesian XYZABC motion through its kinematics, but the CAM/post must emit poses that preserve TCP orientation, branch continuity and process needs.

### 9. External axes

Real industrial cells may add a linear track, rotary positioner or workpiece manipulator. 3500 should distinguish an external axis participating in the same coordinated path from an independent mechanism that needs its own motion program.

### 10. Single-planner boundary

LinuxCNC has one coordinated realtime motion/planner instance per process. A second robot that must move independently while the primary machine continues cutting is therefore not simply 'more axes.' Recent 2026 forum discussion recommends a second LinuxCNC/controller, an external sequencer, or deliberately limited independent extra-joint planning for simple point-to-point mechanisms. This is a major architecture boundary for robotic cells.

## Adjacent open-source robotics ecosystem

3500 should inspect, but not become, a ROS curriculum. ROS/MoveIt and other robotics libraries may contribute:

- robot description and frame conventions;
- collision models;
- offline path planning;
- teaching/visualization concepts;
- industrial robot postprocessing and cell planning.

The key research question is where such planning belongs relative to LinuxCNC's deterministic trajectory/servo execution. Historical LinuxCNC-to-ROS bridge projects exist, so integration is possible, but they should be treated as architectural references rather than mandatory dependencies.

## Proposed breadth progression

### 3500-S1 — serial-arm foundation

Deep-read `genserkins`, DH setup documentation and shipped PUMA simulation. Validate frames, TCP, world/joint modes and basic singularity behavior in simulation.

### 3500-S2 — real industrial-arm retrofit comparison

Source-trace universal-IRC-1 plus at least one second field robot (current PUMA 200 and/or Denso/Fanuc community build). Separate kinematics problems from drives, encoders, brakes and safety boundaries.

### 3500-D1 — SCARA/delta/palletizer

Compare stock SCARA/delta kinematics against a real EtherCAT or equivalent build. Focus on reference state, high-speed path behavior and machine-specific kinematic adaptation.

### 3500-P1 — parallel mechanisms

Trace `genhexkins` and at least one real hexapod. Study geometry parameters, solver convergence, calibration, limits and failure diagnostics.

### 3500-K1 — custom kinematics

Build or adapt only a small simulated custom mechanism if necessary to learn the `userkins` contract, forward/inverse verification, singularity reporting and switchkins integration. Do not turn the curriculum into a full robot-product implementation.

### 3500-R1 — robot path/programming boundary

Study TCP/work frames, tool-coordinate jogging, CAM/post output, orientation interpolation, branch continuity, external axes and how robot process I/O is synchronized with motion.

### 3500-V1 — visualization and diagnostics

Use QtVismach/QtVCP to present joint feedback, Cartesian pose, frame/tool state, active kinematics type, branch/configuration, limit margin and solver/singularity diagnostics.

## Candidate learning experiments

Only run experiments that resolve an uncertainty. Good candidates include:

- perturb one DH parameter and compare joint/world error;
- cross or approach a known serial-arm singularity in simulation;
- switch world ↔ identity kinematics and verify interpreter/motion synchronization;
- restart a simulated absolute-encoder robot with stale/invalid world reference;
- intentionally request an unreachable Cartesian pose and inspect failure propagation;
- alter hexapod geometry and observe convergence/iteration diagnostics;
- verify TCP/tool offset changes do not silently produce a joint jump;
- test a simple external-axis path versus an actually independent second-motion requirement.

## Safety boundary

LinuxCNC can provide ordinary servo control, limits, diagnostics, communication watchdogs and machine logic, but those are not automatically safety-rated robot functions. Industrial robots can move quickly, silently and with large stored/gravity energy. Safe-speed monitoring, safe limited position, collision detection, protective stops, guarding, enabling devices and required PL/SIL remain machine- and risk-assessment-specific.

## Breadth conclusion

3500 is a worthwhile deep specialization. LinuxCNC already has enough native kinematics and simulation infrastructure that the course can focus on the difficult engineering questions instead of deriving every robot transform from scratch. The highest-value next deep pass is a **serial industrial-arm comparison**: shipped `genserkins`/PUMA simulation + universal-IRC-1 Fanuc field retrofit + the current 2026 PUMA 200 commissioning thread. That combination exposes kinematics, frames, references, encoders, brakes, servo hardware and recovery in one coherent track.