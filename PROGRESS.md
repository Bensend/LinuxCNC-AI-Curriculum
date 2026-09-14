# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and the referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.

Do not reopen or repoll closed 2000 work unless a genuinely new material defect is discovered.

## Active curriculum level

**3000 — machine-specific specialization.** Current active work branch: **3500 — Robots / Custom Kinematics**, reached by work-selection rotation after the current 3400 router breadth/source pass closed its remaining generic Motion-DOUT question.

Latest active checkpoint: `checkpoints/3500-next-2026-09-14b.md`.

The earlier authoritative 3500 breadth/ROS checkpoint `checkpoints/3500-next-2026-09-14.md` remains valid; checkpoint B adds native kinematics failure propagation and a pinned Tormach HAL/ros2_control realtime-loop trace without displacing the ROS/ROS2 deep-dive priority.

3300 remains open, not graduated, with latest preserved checkpoint `checkpoints/3300-next-2026-09-14f.md`. 3200 remains intentionally paused. 3400 is paused after a clean breadth/source stop. 3600 retains its branch-local information-gain stop.

## 3300 — Plasma / Laser / Waterjet

Pinned LinuxCNC revision for upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

### Plasma P1/P2/P3

Current breadth pass is mature enough for rotation. Authoritative artifacts include:

- `research/3300-qtplasmac-process-eoffset-source-trace-2026-09-14.md`
- `research/3300-plasma-build-diary-comparison-2026-09-14.md`
- `research/3300-plasma-production-workflow-foundation-2026-09-14.md`
- `research/3300-plasma-rfl-pmx-source-trace-2026-09-14.md`
- `research/3300-plasma-hole-filter-pmx-field-trace-2026-09-14.md`

Preserved contracts: QtPlasmaC realtime process state is distinct from Motion external-offset execution; requested/applied/nominal offsets are distinct; real THCAD/Arc OK commissioning failures are layer-specific; RFL reconstructs process/modal state; PMX485 is userspace communications rather than realtime Arc OK/safety authority; the filter can synthesize small-hole E3 velocity reduction and P3 overcut with explicit normal M5 cleanup.

Do not repeat generic plasma tracing. Reopen opportunistically for strong downloadable ohmic+float configs, current CAM-post provenance, later tandem production evidence or a specific unresolved recovery problem.

### Laser L1

Authoritative artifacts now include:

- `research/3300-laser-native-source-foundation-2026-09-14.md`
- `research/3300-laser-real-implementation-comparison-2026-09-14.md`
- `research/3300-laser-sector67-raycus-config-trace-2026-09-14.md`
- `research/3300-laser-laserpower-deployment-availability-audit-2026-09-14.md`
- `research/3300-laser-qtplasmac-laser-mode-source-history-2026-09-14.md`

Native source establishes `laserpower.comp`, `raster.comp`, and queued/immediate M62/M63/M67/M64/M65/M68 semantics. Real public machines currently show multiple materially different architectures rather than one canonical stack.

A bounded global search found `loadrt laserpower` / `laser.control.power` only in the shipped LinuxCNC laser simulator and source-tree forks/copies, not an independently evidenced physical machine. Treat `laserpower.comp` as native reusable realtime infrastructure, not as a proven dominant production architecture.

A source-history trace established that the 2024 community fiber-height-control experiment became merged upstream QtPlasmaC `laser_mode` through PR #2973. At the pinned revision, `(torch_on || laser_mode)` admits the CUT_MODE_01 height-control path, `laser_mode` bypasses the initial near-requested-velocity target-acquisition gate, and configured downstream corner-lock and void-lock logic still remain capable of suppressing correction. Thus `laser_mode` is a real upstream fiber-specific height-control adaptation, not a complete fiber process controller.

### Waterjet W1

Authoritative artifacts:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`
- `research/3300-waterjet-w1-field-chronology-pressure-authority-2026-09-14.md`

Real LinuxCNC evidence supports distinct nozzle/water and abrasive commands, explicit program/manual authority arbitration, nominal Z versus cutting-time correction authority, and careful preservation of original servo/feedback topology. The targeted pump/readiness search reached a bounded source-availability stop: no downloadable LinuxCNC implementation was found exposing a complete `pump/intensifier command -> pressure transition -> READY/fault qualification -> cut authorization -> pause/abort recovery` chain.

W1 remains open and the 3-axis state machine is not frozen. Reopen only when stronger pressure/readiness/recovery evidence becomes inspectable.

## 3400 — Routers / Woodworking

Existing foundation and deep work include:

- `research/3400-router-woodworking-breadth-survey-2026-09-14.md`
- `research/3400-fenja-router-atc-source-audit-2026-09-14.md`
- `research/3400-fenja-atc-abort-recovery-audit-2026-09-14.md`
- `research/3400-linuxcnc-abort-motion-dout-source-trace-2026-09-14.md`
- `research/3400-funkenjaeger-dcnc-atc-dust-spindle-gantry-audit-2026-09-14.md`
- `research/3400-gantry-negative-home-sequence-source-trace-2026-09-14.md`
- `research/3400-router-spindle-vfd-readiness-fault-boundary-2026-09-14.md`
- `research/3400-router-vacuum-dust-authority-community-boundary-2026-09-14.md`
- `research/3400-motion-dout-transition-source-closeout-2026-09-14.md`

Latest preserved checkpoint: `checkpoints/3400-next-2026-09-14d.md`.

### ATC / pneumatic authority

Two materially different real router ATC configurations support the state separation:

`tool request -> pneumatic/source readiness -> physical transfer geometry -> actuator command -> clamp/pocket/tool witnesses -> logical tool identity -> measured/valid tool length`.

At `Funkenjaeger/fj-lcnc-cfg@f4877f862ab757bd396b02e54acb12e6835f8259`, a six-pocket rack ATC uses an air-pressure switch, six pocket sensors, drawbar/purge/rack outputs, machine-coordinate transfer moves, logical `M61` reconciliation and later fixed tool measurement. The inspected files do not expose direct drawbar-clamped/released feedback. Local failure paths clean some states, but no global custom-DOUT/tool-inventory reconciliation hook was found. Do not teach blind retry of an interrupted custom M6.

Repository chronology records a 2025 fix for an indefinite Auto-mode toolchange pause caused by spindle-at-speed interaction and a later fix for interference with an adjacent tool post. ATC commissioning must therefore include task/spindle-readiness interactions and real physical clearance, not only nominal geometry.

### Dust / workholding / spindle / gantry

The DCNC dust shoe is an explicit auxiliary state machine with clearance, pneumatic sequencing, feedback/timeout and conditional restoration. Community evidence preserves distinct collector, dust-foot, vacuum-command and vacuum-achieved authority. A production public vacuum pressure-ready/loss-recovery configuration remains source-poor.

The real WJ200 userspace driver exposes running, at-speed, ready, alarm, actual frequency and communications watchdog separately. The inspected machine uses at-speed and exposes alarms but does not establish READY/watchdog as a cut/ATC permissive. Status availability is not status authority.

Pinned LinuxCNC homing source closes the negative-HOME_SEQUENCE behavior used by the XYYZ router: reference acquisition remains per-joint; synchronized final HOME movement is grouped; a HOME_ABORT clears homing/homed state for the full synchronized group.

### Motion-DOUT closeout

Pinned Motion source now closes the remaining generic R5 question:

- immediate M64/M65-style DOUT writes set the Motion HAL output;
- an already-applied custom DOUT is not generically reset by `EMCMOT_ABORT`;
- Motion Disable / machine OFF does not generically reset it;
- the traced Task E-stop sequence contains Abort, spindle off, Disable and IO/amp actions but no custom-DOUT reset command;
- a queued future synchronized DOUT is a different state and can disappear when TP is aborted;
- exact physical terminal state on process shutdown/watchdog remains hardware/driver/external-circuit specific.

The narrow generic DOUT lab is therefore unnecessary. Reopen only for a named hardware terminal-state question, stronger vacuum authority evidence, or a real ATC with explicit interrupted-state reconciliation.

## 3500 — Robots / Custom Kinematics

Existing authoritative breadth/ROS artifacts include:

- `research/3500-robots-custom-kinematics-breadth-survey-2026-09-14.md`
- `research/3500-ros-ros2-implementation-deep-dive-2026-09-14.md`

New source-deepening artifacts:

- `research/3500-robots-custom-kinematics-foundation-2026-09-14.md`
- `research/3500-kinematics-failure-propagation-2026-09-14.md`
- `research/3500-tormach-hal-ros-control-realtime-loop-source-trace-2026-09-14.md`

### Native LinuxCNC kinematics

Pinned source establishes that synchronized `G12.1/G13.1` switching coordinates interpreter and Motion, while the raw HAL kinstype input is deprecated because lookahead can retain stale kinematics state. Kinstype persists across Abort/program end.

`genserkins` uses an iterative Jacobian inverse with current/supplied joint position as the seed. Matrix-inversion failure or iteration exhaustion returns failure. Realtime coordinated/teleop inverse failure or a non-finite joint result sets Motion error and requests disable; joint soft limits remain a separate downstream backstop. Thus `IK success != dynamic feasibility`, and Cartesian endpoint validity is not the same as safe/trackable robot motion.

Pinned `scarakins` carries elbow branch state through kinematics flags and clamps the `acos` input into `[-1,1]`; its near/outside-reach behavior remains a bounded validation target rather than something to infer.

### ROS2 / Tormach realtime bridge

At `tormach/hal_ros_control@506a3d109cb306e1d1cdb70f24440bde1159b256`, the exported HAL realtime function executes:

`controller_manager.read -> update -> write`.

The ROS executor is a separate userspace thread. `HalSystemInterface::read()` copies HAL feedback pins into ros2_control state storage and `write()` copies ros2_control command storage to HAL command pins.

The generic bridge's activate/deactivate callbacks do not explicitly reset command pins, and `CM_OK=0` returns from the realtime function without a source-visible command reset. Therefore the next high-value trace is downstream stale-command containment and actual drive/device-manager/EtherCAT authority, plus current JointTrajectoryController cancellation/tolerance/deactivation semantics. The bridge itself is not sufficient evidence of drive/brake/STO safety.

Latest checkpoint: `checkpoints/3500-next-2026-09-14b.md`.

## Other open 3000 branches

- **3200 Lathes / Turning Centers:** paused; latest preserved checkpoint `checkpoints/3200-lathe-next-2026-09-14b.md`.
- **3300 Plasma / Laser / Waterjet:** open with bounded current source stops; latest checkpoint `checkpoints/3300-next-2026-09-14f.md`.
- **3400 Routers / Woodworking:** paused after breadth/source closeout; latest checkpoint `checkpoints/3400-next-2026-09-14d.md`.
- **3500 Robots / Custom Kinematics:** ACTIVE; latest checkpoint `checkpoints/3500-next-2026-09-14b.md`.
- **3600 Press Brakes:** not graduated; documented branch-local information-gain stop. Integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.
- 3100/3700/3800/3900 remain parallel specialization branches for later rotation.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3500-next-2026-09-14b.md`: source-trace current ros2_control ControllerManager/ResourceManager and JointTrajectoryController lifecycle/cancel/tolerance behavior, then the Tormach ZA6 downstream drive/device-manager/EtherCAT enable/watchdog path. Freeze an RRBot cancel/reset/stale-command lab only if source leaves a real nonduplicate uncertainty. When the ROS2 path reaches a clean source boundary, continue real native robot commissioning evidence or rotate to another underdeveloped 3000 track according to `WORK_SELECTION_POLICY.md`; branch-local stops are not curriculum stops.
