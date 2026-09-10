# Generic Y1/Y2 duplicated-joint source grounding — 2026-09-10

## Scope and dependency boundary

This is dependency-safe press-brake specialization preparation while F02 remains blocked on genuinely information-separated fresh-AI handoffs for S02, E20, X01, and X02. It does not self-certify those modules, activate F02, prescribe a machine-specific hydraulic circuit, or claim functional-safety adequacy.

Pinned LinuxCNC source revision used for source conclusions:

`8bf4605ae81042248add031e94c77300406e0413`

The concrete question is deliberately generic: if a machine has two independently actuated physical sides that conceptually share one Cartesian bend-depth coordinate, what does stock LinuxCNC duplicated-coordinate motion actually provide, and what synchronization behavior must be added explicitly?

## Predeclared prediction

Before inspecting the detailed identity-kinematics mapping implementation for this session:

1. `trivkins` with a duplicated coordinate such as `coordinates=YY`/`XYYZ` should fan one Cartesian Y request into two distinct joint command channels.
2. Each joint should retain its own motor-feedback input, following-error state, amplifier-enable output, and optional PID/control path.
3. Stock duplicate-coordinate kinematics should not itself calculate a continuous Y1-vs-Y2 differential correction.
4. Forward Cartesian Y should not be assumed to be an independent aggregate agreement witness for both duplicated joints.

Existing C01/C02/D01 laboratory evidence was not used as a substitute for source reading; it is used below as independent verification after the source trace.

## Official documentation pass

Current LinuxCNC kinematics documentation explicitly permits an axis letter to appear more than once and gives `coordinates=xyyz` as the example where two joints move one Cartesian Y coordinate. The `kins(9)` documentation recommends `KINEMATICS_BOTH` for duplicated-coordinate machines so individual joints can be handled unambiguously in joint mode, especially around homing and setup.

Current official docs also describe the old `gantry` component as superseded by general-purpose `trivkins` duplicated coordinates. This is significant: duplicated coordinates are a supported representation of one Cartesian coordinate backed by multiple joints, not a press-brake-specific cross-coupled controller.

Relevant current documentation:

- https://www.linuxcnc.org/docs/html/motion/kinematics.html
- https://www.linuxcnc.org/docs/html/man/man9/kins.9.html
- https://www.linuxcnc.org/docs/master/html/en/man/man9/gantry.9.html

Classification: DOC-CONFIRMED for duplicate-coordinate support and the joint/axis distinction. Documentation does not claim that duplicate mapping supplies continuous anti-racking/differential control.

## Source inventory

| Path | Symbol / structure | Role in this question | Evidence |
|---|---|---|---|
| `src/emc/kinematics/trivkins.c` | `rtapi_app_main`, `kinematicsInverse`, `kinematicsForward` | Enables duplicate coordinate mapping (`allow_duplicates = 1`) and delegates to identity helpers | SOURCE-CONFIRMED |
| `src/emc/kinematics/kins_util.c` | `map_coordinates_to_jnumbers` | Maps repeated coordinate letters to multiple joint numbers; retains one principal joint and a bitmap of all mapped joints | SOURCE-CONFIRMED |
| `src/emc/kinematics/kins_util.c` | `position_to_mapped_joints` | Inverse path copies one Cartesian coordinate value into every joint mapped to that coordinate | SOURCE-CONFIRMED |
| `src/emc/kinematics/kins_util.c` | `mapped_joints_to_position` | Forward path publishes the coordinate from the principal/first joint, not an average or disagreement calculation | SOURCE-CONFIRMED |
| `src/emc/motion/control.c` | `emcmotController`, `get_pos_cmds`, `process_inputs`, `output_to_hal` | Servo-cycle chain from kinematics-generated joint commands through feedback/following-error processing to HAL | SOURCE-CONFIRMED |
| `src/emc/motion/motion.c` | `export_joint` | Exports distinct `joint.N.motor-pos-cmd`, `joint.N.motor-pos-fb`, `joint.N.pos-cmd`, `joint.N.pos-fb`, `joint.N.amp-enable-out` interfaces for each joint | SOURCE-CONFIRMED |
| `src/hal/components/pid.c` | per-instance `hal_pid_t`, `calc_pid` | Each PID instance owns its own command, feedback, error, integrator/state and output; there is no implicit peer-joint comparison | SOURCE-CONFIRMED |

## Function / call-flow reconstruction

### 1. Cartesian request to duplicate joint commands

`emcmotController()` runs once per servo period. In its core sequence it calls `get_pos_cmds(period)`, then screw compensation, `output_to_hal()`, and finally status publication.

In coordinated/teleop paths, `get_pos_cmds()` calls `kinematicsInverse(&emcmotStatus->carte_pos_cmd, positions, ...)`. With `trivkins`, that delegates to `identityKinematicsInverse()`, which calls `position_to_mapped_joints()`.

For a duplicated Y mapping, the Y bitmap contains both Y joints. `position_to_mapped_joints()` iterates joints and assigns `joints[jno] = pos->tran.y` for every bit set in that Y bitmap. Therefore one Cartesian Y request becomes the same pre-correction joint-position target on both mapped joints.

**SOURCE-CONFIRMED conclusion:** duplicate-coordinate inverse kinematics is command fanout. It is not a differential controller.

### 2. Distinct per-joint HAL authority remains after fanout

`motion.c::export_joint()` creates separate HAL interfaces per joint, including:

- `joint.N.motor-pos-cmd` — HAL OUT;
- `joint.N.motor-pos-fb` — HAL IN;
- `joint.N.pos-cmd` and `joint.N.pos-fb` — HAL OUT status/observation surfaces;
- `joint.N.amp-enable-out` — HAL OUT.

`control.c::output_to_hal()` computes each joint's `motor_pos_cmd` from that joint's `pos_cmd`, backlash compensation, and motor offset, then writes the corresponding joint HAL pins.

This leaves a clean architecture boundary where each duplicated joint can feed a separate actuator/controller chain even though the nominal Cartesian target is common.

### 3. Independent feedback and following-error path

During each servo cycle, `control.c::process_inputs()` reads each active joint's `joint.N.motor-pos-fb` independently. In the normal non-index special case it derives the joint feedback and then calculates:

`joint->ferror = joint->pos_cmd - joint->pos_fb`

It computes the velocity-scaled/floor following-error limit and sets that joint's following-error flag when absolute error exceeds the limit.

Therefore two duplicated Y joints can receive identical nominal commands but produce different feedback, different following error, and different joint-fault state.

**SOURCE-CONFIRMED conclusion:** command equality does not collapse the two joints into one feedback/control state.

### 4. Forward Cartesian feedback authority

`kins_util.c::map_coordinates_to_jnumbers()` records the first joint mapped to each coordinate as the principal joint (`JY` for Y) while also keeping a bitmap of all duplicate Y joints.

`mapped_joints_to_position()` uses the principal joint value when assigning Cartesian Y. The loop tests the Y bitmap, but the value assigned is always `joints[JY]`; it does not average all Y joints and it does not compute their difference.

**SOURCE-CONFIRMED conclusion:** for this pinned identity/trivkins implementation, Cartesian Y feedback is a principal-joint representation, not a tandem-agreement oracle.

### 5. Separate ordinary control loops

Pinned `pid.c` allocates one `hal_pid_t` per loop. Each instance has its own `command`, `feedback`, `error`, integrator/differentiator state, output limits, and output. The PID calculation is local to that instance: error is command minus that instance's feedback. No implicit peer PID/joint feedback is consumed.

**SOURCE-CONFIRMED conclusion:** two normal PID instances sharing one nominal command remain independent loops. Cross-coupling exists only if explicitly wired/implemented outside those independent loops.

## Independent laboratory verification already available

No new paid lab run was necessary for this source-grounding step because the repository already contains stronger retained experiments at the same pinned revision.

### C01-023 — duplicate command fanout

Accepted retained evidence observed a nontrivial 5-inch coordinated world-Y move with duplicated Y joints. In 5,798 same-servo-cycle samples, the two duplicate joint commands had exactly zero difference and the recorder had zero overruns.

Classification: TEST-CONFIRMED. This independently matches the inverse-kinematics fanout trace.

### C02-024 — independent loop state

Accepted retained evidence fed the shared Y command into separate PID/plant/feedback paths. A B-only plant disturbance caused sustained divergence in feedback, PID error, and PID output while the common command remained shared. No stock peer-comparison mechanism appeared.

Classification: TEST-CONFIRMED. This independently matches the per-instance PID/source ownership model.

### D01-006 — principal Cartesian authority and duplicate-side fault

The 2000-level authoritative experiment injected disagreement into the duplicate side. At low disagreement Cartesian Y stayed principal-looking; at high disagreement the duplicate joint asserted following error and global motion authorization was revoked while principal-joint/Cartesian Y remained visually clean. Frozen Gates A-J passed 10/10.

Classification: TEST-CONFIRMED. This independently matches the principal-joint forward-kinematics and independent joint-ferror source trace.

## Adversarial architecture checks

### Misleading premise: "If both joints are mapped to Y, LinuxCNC automatically keeps them synchronized."

Rejected. Source and experiment show equal nominal command fanout plus independent feedback/control state. Synchronization beyond both following their common target must be implemented explicitly.

### Misleading premise: "Cartesian Y tells us whether Y1 and Y2 agree."

Rejected at the pinned revision. `mapped_joints_to_position()` uses the principal joint for Cartesian Y; D01 independently demonstrated a duplicate-side disagreement while Cartesian Y remained principal-looking.

### Misleading premise: "Two separate PID loops are already a cross-coupled controller because they share a command."

Rejected. Each PID instance owns and calculates from its own state. C02 demonstrated large B-only divergence with the shared command unchanged.

### Safety trap: "Following-error shutdown is therefore an anti-racking safety function."

Rejected. It is an ordinary LinuxCNC machine-control fault mechanism. It does not authenticate physical geometry under common-cause sensing, prove stopping performance, or establish functional-safety integrity.

### Design trap: "Put arbitrary differential correction after `joint.N.motor-pos-cmd`; LinuxCNC will take care of the rest."

Not established. Because motion calculates joint following error against its own joint `pos_cmd`/feedback model, downstream command modification can change the relationship between LinuxCNC's expected joint trajectory and the physical actuator trajectory. Any explicit differential correction layer must be analyzed together with per-joint feedback, actuator saturation, following-error thresholds, loop ordering, and authority limits. Treat downstream summing as a candidate architecture, not a free insertion point.

## Architecture conclusions for a generic hydraulic/tandem Y1/Y2 study

The strongest source-grounded decomposition is:

1. **Common coordinate/request layer** — one Cartesian bend-depth/request surface can legitimately map to two Y joints.
2. **Per-side joint state** — preserve independent Y1 and Y2 command/feedback/following-error/enable observability.
3. **Per-side actuator loop** — each side can have an independent ordinary servo loop driven by the shared nominal request.
4. **Explicit differential synchronization layer** — any term based on Y1-Y2 disagreement must be explicit; stock duplicated-coordinate mapping does not create it.
5. **Explicit authority/saturation contract** — the synchronization term must have bounded authority and defined interaction with per-side loop saturation and LinuxCNC following-error behavior.
6. **Independent disagreement/validity monitor** — do not use Cartesian Y as the tandem-agreement source. Consume the per-side feedback/validity channels directly.
7. **Separate safety layer** — do not equate HAL/PID/following-error/watchdog logic with safety-rated stopping or hydraulic energy isolation.

## Candidate control formulations to test later — not yet endorsed

Two generic software architectures are worth discriminating experimentally after the dependency gate is open:

### A. Common target + symmetric differential bias

Let `Yc` be the common nominal request and `eΔ = Y1_fb - Y2_fb`. Construct bounded side references such as:

- `Y1_ref = Yc - KΔ * eΔ`
- `Y2_ref = Yc + KΔ * eΔ`

This preserves a common-mode request while adding equal/opposite correction. Questions: where exactly should this correction enter, how should it be rate/position limited, and how does it interact with each side's PID/following-error state?

### B. Independent common-target loops + supervisory disagreement authority

Keep both actuator loops referenced to the same Y target and use a separate realtime disagreement monitor only to reduce/withdraw ordinary motion authority when bounded position/velocity disagreement criteria are violated.

This is simpler but may not actively correct load/plant asymmetry before the disagreement threshold is reached.

These are control-study hypotheses only. Hydraulic dynamics, valve architecture, load transfer, frame compliance, sensor placement, and required stopping behavior can materially change the correct machine-specific design.

## Proposed next software-only experiment

When the dependency graph permits activation, freeze a two-side synthetic plant experiment that compares the two candidate architectures under the same disturbances:

- identical common Y command;
- controlled B-side gain reduction and lag increase;
- correction authority limits;
- per-side output saturation;
- independent encoder bias/freeze cases;
- per-side following-error state;
- explicit differential position/velocity witnesses;
- atomic realtime sampling with X01 recorder-health proof;
- observer-generation witnesses where userspace diagnostics are compared, per X02.

Predeclare discriminators before execution: peak and steady-state differential error, common-mode tracking error, saturation duration, recovery behavior, fault timing, and whether correction hides or aggravates individual following error.

A result must not be promoted to a physical press-brake prescription without a hydraulic/plant model justified by public component data or controlled machine measurements.

## Open questions / specialization queue

1. Where should explicit differential correction live relative to LinuxCNC `joint.N.motor-pos-cmd`, ordinary PID position loops, and hardware/FPGA valve-command generation?
2. Should the synchronization loop operate primarily on position difference, velocity difference, or a cascaded/observer state for hydraulic systems?
3. What anti-windup and common/differential saturation strategy prevents one side's limit from commanding the other side into a worse condition?
4. How should disagreement thresholds distinguish transient elastic/pressure effects from loss of synchronization?
5. What feedback-validity/common-cause checks must be satisfied before differential correction is allowed to continue?
6. How should homing/squaring establish the initial Y1/Y2 geometric relationship without implying continuous geometric validity afterward?
7. Which of these questions belong in F02 integration versus a justified later specialized press-brake/control module?

## Precise checkpoint

F02 remains blocked on external fresh-AI handoffs. The next useful unblocked specialization task is to source-ground the **insertion-point and saturation question**: trace a normal Mesa/HostMot2 or generic velocity-command servo HAL chain from `joint.N.motor-pos-cmd` through PID output to hardware-facing command and back through `motor-pos-fb`, then identify exactly which signals/state would be bypassed or distorted by inserting a differential correction before PID command, after PID output, or in a custom two-axis controller. Do not launch a physical-machine experiment and do not treat any candidate insertion point as approved until that trace is complete.
