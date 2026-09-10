# Generic Y1/Y2 duplicated-joint source grounding — 2026-09-10

## Scope and dependency boundary

Dependency-safe press-brake specialization preparation while F02 remains blocked on genuinely information-separated fresh-AI handoffs for S02, E20, X01, and X02. This does not self-certify those modules, activate F02, prescribe machine-specific hydraulics, or claim functional-safety adequacy.

Current source trace is pinned to LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

## Predeclared prediction

Before detailed identity-kinematics inspection, the prediction was:

1. duplicated `trivkins` coordinates fan one Cartesian Y request into distinct joint command channels;
2. each joint retains independent feedback/following-error/enable/control state;
3. duplicate-coordinate kinematics does not itself implement continuous Y1-vs-Y2 correction; and
4. Cartesian Y must not be assumed to be an aggregate tandem-agreement witness.

The source trace supports all four predictions.

## Documentation pass

Official LinuxCNC kinematics material permits duplicate axis letters (for example `coordinates=xyyz`) so multiple joints can represent one Cartesian coordinate, and the `kins(9)` material recommends `KINEMATICS_BOTH` for duplicate-coordinate machines where individual joint handling is needed. The old `gantry` component is documented as superseded by general-purpose duplicated coordinates in `trivkins`.

Relevant documentation:

- https://www.linuxcnc.org/docs/html/motion/kinematics.html
- https://www.linuxcnc.org/docs/html/man/man9/kins.9.html
- https://www.linuxcnc.org/docs/master/html/en/man/man9/gantry.9.html

Classification: DOC-CONFIRMED for duplicate-coordinate support and joint/axis distinction. The documentation does not claim duplicated mapping supplies continuous differential synchronization.

## Source trace at `8bf4605...`

### `src/emc/kinematics/trivkins.c`

`trivkins` delegates forward/inverse operations to identity helpers and sets `allow_duplicates = 1` during setup.

### `src/emc/kinematics/kins_util.c`

`map_coordinates_to_jnumbers()` maps repeated coordinate letters to multiple joint numbers, stores the first mapped joint as the principal joint (`JY` for Y), and stores a bitmap containing every mapped joint.

`position_to_mapped_joints()` is the inverse-kinematics fanout: for every joint in the Y bitmap it assigns the same `pos->tran.y`. Therefore one Cartesian Y request becomes the same nominal target for all duplicate Y joints.

`mapped_joints_to_position()` performs the opposite representation using `joints[JY]` for Cartesian Y. It does not average duplicate joints and does not compute their disagreement.

**SOURCE-CONFIRMED:** duplicated identity kinematics is command mapping/fanout, not a differential controller; Cartesian Y is principal-joint representation at this revision, not an agreement oracle.

### `src/emc/motion/control.c`

`emcmotController()` executes once per servo cycle and includes `process_inputs()`, forward kinematics, fault checks, `get_pos_cmds()`, `output_to_hal()`, and status update.

The coordinated command path calls `kinematicsInverse()` to generate joint positions. For each active joint, `process_inputs()` independently reads `joint.N.motor-pos-fb` and computes normal joint feedback. Motion's own following error is:

`joint->ferror = joint->pos_cmd - joint->pos_fb`

The limit is velocity-scaled from `max_ferror`, floored by `min_ferror`, and the joint ferror flag asserts when absolute error is strictly greater than that limit.

`output_to_hal()` separately generates each joint's `motor_pos_cmd` from its `pos_cmd` plus motion-owned compensation/offset terms.

**SOURCE-CONFIRMED:** equal nominal duplicate commands do not collapse feedback, tracking error, or joint fault state into one state.

### `src/emc/motion/motion.c`

`export_joint()` creates distinct per-joint HAL pins including `joint.N.motor-pos-cmd` (OUT), `joint.N.motor-pos-fb` (IN), `joint.N.pos-cmd`, `joint.N.pos-fb`, and `joint.N.amp-enable-out`.

### `src/hal/components/pid.c`

Each PID channel owns a separate `hal_pid_t`: command, feedback, error, integral/differential state, output, limits, and saturation state. Its calculation consumes that instance's command/feedback; there is no implicit peer-joint comparison.

**SOURCE-CONFIRMED:** two normal PIDs sharing one nominal command remain independent loops unless an explicit cross-coupling mechanism is added.

## Independent verification with version discipline

No new paid lab was necessary for the source claims already covered by retained experiments. Version scopes are kept separate rather than silently merged.

### C01-023 — pinned `8bf4605...`

A nontrivial 5-inch coordinated Y move with `trivkins coordinates=XYZY kinstype=BOTH` produced 5,798 same-servo-cycle samples with zero recorder overruns and exactly zero difference between the duplicate joint command signals.

Classification: TEST-CONFIRMED at `8bf4605...`; independently verifies duplicate command fanout.

### C02-024 — pinned `8bf4605...`

Separate PID/plant/feedback paths received the common Y command. A B-side-only plant gain disturbance produced sustained divergence in feedback, PID error, and control output while the nominal command remained shared.

Classification: TEST-CONFIRMED at `8bf4605...`; independently verifies that shared command is not shared controller/plant state and is not cross-coupling.

### D01-006 — pinned `6e20ea4c50208ae7b04d1aefaecc8f00a576e394`

D01 is deliberately **not** described as the same source revision. Its authoritative 2000-level run independently exercised the same architectural boundary at a different pinned revision: low duplicate-side disagreement could coexist with principal-looking Cartesian Y, while high duplicate-side disagreement asserted that joint's following error and revoked global motion authority with the principal side still visually clean.

Classification: TEST-CONFIRMED at `6e20ea4...`; useful corroborating evidence, but not silently generalized back to or forward from `8bf4605...`.

## Adversarial checks

- **"Both joints are Y, so LinuxCNC automatically synchronizes them."** Rejected. Source gives equal nominal fanout plus independent per-joint state; continuous differential correction must be explicit.
- **"Cartesian Y proves Y1 and Y2 agree."** Rejected for pinned identity/trivkins behavior; it is principal-joint representation.
- **"Two PIDs sharing a command are cross-coupled."** Rejected; each PID owns independent feedback/error/output state.
- **"Following-error shutdown is therefore an anti-racking safety function."** Rejected. It is ordinary machine-control fault behavior and does not authenticate physical geometry, common-cause sensor correctness, stopping performance, or functional-safety integrity.
- **"A differential term can be inserted anywhere downstream and LinuxCNC will take care of it."** Rejected. Motion ferror remains referenced to motion's own joint target, and downstream changes can alter controller/saturation semantics.

## Generic architecture decomposition

A defensible generic study model now has seven distinct layers:

1. one common Cartesian/request surface;
2. duplicate per-side joint targets;
3. independent Y1/Y2 feedback and motion following-error state;
4. independent side actuator loops;
5. an explicit differential synchronization layer if active correction is needed;
6. explicit correction/saturation/validity authority and independent disagreement monitoring; and
7. a separate safety layer that must not be inferred from LinuxCNC/HAL/PID behavior alone.

## Open specialization questions

- Where should differential correction enter relative to `joint.N.motor-pos-cmd`, stock PID, and hardware-facing command generation?
- How should common and differential authority share limited actuator range when one side saturates?
- Should hydraulic synchronization primarily use position difference, velocity difference, or a cascaded/observer state?
- What validity/common-cause conditions must be met before correction remains authorized?
- How should homing/squaring establish the initial geometric relation without implying continuous geometric validity?
- Which questions belong in F02 integration versus a later justified specialized control module?

## Precise checkpoint

The immediate next task is the insertion-point/saturation trace: follow a normal Mesa/HostMot2 servo HAL chain from `joint.N.motor-pos-cmd` through PID to the hardware-facing command and back through `motor-pos-fb`, then compare pre-PID reference correction, post-PID effort correction, and an explicit two-channel controller. Preserve motion following-error and final actuator saturation as separate authority witnesses. Do not treat any insertion point as approved before that trace and a bounded software experiment are complete.
