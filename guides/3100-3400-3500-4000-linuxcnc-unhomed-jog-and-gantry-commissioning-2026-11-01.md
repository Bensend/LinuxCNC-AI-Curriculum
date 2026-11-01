# Practical LinuxCNC implementation — unhomed jogging, gantry joint/world modes, and dynamic HOME_SEQUENCE
**3100 mills / 3400 routers / 3500 gantries & robots / 4000 controller implementation | Source-derived walkthrough | NOT RUN**

Use this guide to avoid two common control-integration mistakes: treating unhomed jog limits as trusted physical travel limits, and treating duplicated-axis gantry joints as independent G-code axes. Read [JOG-135 source audit](../research/4400_LINUXCNC_JOG_135_UNHOMED_AXIS_JOG_LIMIT_VERSION_AND_RECENTER_SOURCE_AUDIT_2026-11-01.md) and [JOG-136 source/real-config audit](../research/4400_LINUXCNC_JOG_136_GANTRY_MIXED_HOME_SEQUENCE_JOG_GATE_REAL_CONFIG_SOURCE_AUDIT_2026-11-01.md) before implementation.

## Two different controllers inside one motion subsystem
- **FREE/joint mode**: `command.c` drives each joint's `free_tp`; unhomed jog limits are recomputed from **joint feedback** plus/minus the configured total range. The joint number, not the displayed axis letter, identifies the motor.
- **TELEOP/world mode**: `command.c` delegates to `axis_jog_cont/incr/abs`; `axis.c` drives `teleop_tp`, then kinematics maps axis coordinates to joints. For non-identity kinematics LinuxCNC requires all joints homed before entering TELEOP.
- **COORD/program mode**: trajectory planner executes programmed G-code. Do not confuse any of these with an independent physical stop.

## Exercise A — identity mill/router, versioned unhomed limits
**Disconnected-only source-derived oracle**, not a tested simulation. Freeze INI axis limits to -100 and +100 mm, unhomed position +10 mm, and choose a positive continuous jog while recording the actual mode:
 
| Case | Jog command target derived from source | Explanation |
|---|---:|---|
| v2.9.10, FREE joint | +210 mm | joint feedback + 200 mm span |
| development, FREE joint | +210 mm | same joint logic |
| v2.9.10, TELEOP axis | +100 mm | fixed INI axis maximum |
| development, TELEOP axis | +210 mm | unhomed current axis + 200 mm span |
| either, homed TELEOP axis | +100 mm | trusted absolute axis maximum |

At feedback/current position +60 mm, a *new* unhomed FREE jog command recomputes a +260 mm target; development unhomed TELEOP does the same. Do not interpret this as a physical movement prediction or a maximum safe excursion. An independent position datum is missing until homing.

**What to instrument:** `motion.teleop-mode`, joint homed state, joint/axis jog selector, joint `pos-fb`, joint `free_tp.pos_cmd` (instrument internally if necessary), axis `teleop_tp.curr_pos/pos_cmd`, `motion.jog-is-active`, error channel and actual joint output. Compare target to achieved position separately.

## Exercise B — actual upstream four-joint gantry
Use [LinuxCNC stable gantry_jjog.ini](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/gantry/gantry_jjog.ini) with its referenced [post-GUI HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/gantry/gantry_panel.hal), not an invented motor map. The INI specifies `KINEMATICS = trivkins coordinates=XYZY kinstype=BOTH`, joints 1 and 3 as duplicated Y, and negative sequence -1 for both.

The real HAL's `pyvcp.jj_enable` switch simultaneously:
- selects `ini.1/3.home_sequence` from -1 to +1;
- asserts `motion.homing-inhibit`;
- enables the joint1/3 MPG inputs; and
- supplies identical counts/scale to both joints.

The official configuration intentionally permits joint jogging for commissioning and prevents normal synchronized homing while the override is selected. It does not ensure the two axes remain square. The development HAL uses `conv_real_sint` where the stable HAL uses `conv_float_s32`; use the matching file for the selected binary.

**Predeclared observation matrix (all NOT RUN):**

| Phase | Joint1 seq | Joint3 seq | Mode | Expected command-layer result |
|---|---:|---:|---|---|
| A, default | -1 | -1 | FREE | individual joint1/3 keyboard jog refused |
| B, mixed-sign injected in disconnected copy | -1 | +1 | FREE | **both** refused by `home_is_synchronized` |
| C, commission override | +1 | +1 | FREE | synchronized-home jog gate clears; other jog conditions remain |
| D, after successful Home All and restored -1/-1 | -1 | -1 | TELEOP | world-coordinate Y jog maps to both Y joints |

Do not run phase B on a physical gantry. It is a software-only flag discriminator; the upstream panel itself selects -1/-1 or +1/+1.

## Implementation preflight and evidence capture
1. Confirm source SHA, LinuxCNC binary version, `KINEMATICS`, `JOINTS`, `[TRAJ]COORDINATES`, every relevant `HOME_SEQUENCE`, axis/joint limits and HAL file order.
2. Confirm whether a GUI is commanding a joint number or an axis letter. Do not assume an Axis GUI hotkey maps identically to another GUI, pendant or custom HAL interface.
3. Freeze predicted **target** positions and gate results before executing. Record status and error messages as well as target/feedback; a lack of physical motion is not necessarily an accepted jog command.
4. Only run on positively qualified, physically disconnected `[self-hosted, openpressbrake]` compute. Capture runner isolation evidence, exact job timestamps, exit code and raw logs; never use hosted Actions.
5. After any simulation, restore the original gantry `HOME_SEQUENCE` and homing-inhibit wiring. Preserve independently verified personnel safety and machine release gates. Do not transfer the test to hardware without a separate engineering review.

## Diagnostic decision points
A jog refused with `HOME_SEQUENCE=-1` may be correct even after homing if the operator selected FREE mode. A TELEOP request refused before homing on `kinstype=BOTH` is a different, earlier gate. A jog accepted but not achieving its target requires motion enable, limit, fault, feedback, kinematics and hardware-output investigation; it is not evidence that the source target formula was wrong. An unhomed target outside the literal INI soft-limit coordinates is not proof of an interpreter bug: those coordinates have no trusted G53 origin yet.

**Evidence status:** official documentation and pinned source/config inspected; no runtime test, HAL execution, GUI observation, motor operation, independent evaluator or lab compute in this lesson. The next checkpoint is [here](../checkpoints/20261101T2140Z-4000-linuxcnc-jog-limit-gantry-next.md).
