# D01 — Servo-cycle feedback, following-error, kinematics, and fault order

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413` (`v2.9.4-743-g8bf4605ae8`).

## Purpose

This trace establishes the causal order needed for the D01 runtime experiment. It is deliberately narrower than a full motion-controller walkthrough: the question is when joint feedback becomes following error, when Cartesian feedback is published, and when a joint fault can revoke motion enable.

## Pinned call/order trace

Within the servo controller cycle in `src/emc/motion/control.c`, the relevant order is:

1. `process_inputs()`
2. `do_forward_kins()`
3. `process_probe_inputs()`
4. `check_for_faults()`
5. `set_operating_mode()`
6. later command/planner/output work

### 1. `process_inputs()` — joint feedback and following error

For each active joint, motion reads the HAL motor feedback and forms joint position feedback:

`joint.pos_fb = joint.motor-pos-fb - motor_offset`

It then forms following error from the joint command and joint feedback:

`ferror = pos_cmd - pos_fb`

The allowed following-error limit is velocity dependent, bounded by `MIN_FERROR` and `FERROR`. The fault comparison is strict: the joint following-error flag is asserted when `abs(ferror) > ferror_limit`.

Consequence for D01: duplicated-coordinate joints still have independent joint feedback and independent following-error evaluation. Sharing a world-axis command does not merge their joint-level fault accounting.

### 2. `do_forward_kins()` — Cartesian feedback publication

After joint input processing, motion passes the current per-joint feedback positions into forward kinematics and publishes Cartesian feedback (`carte_pos_fb`).

For pinned `trivkins` with a duplicated coordinate such as `XYY`, earlier source analysis and D01-001 establish an asymmetric authority rule: inverse kinematics sends the Y command to both Y-mapped joints, while forward kinematics selects one mapped joint as the Cartesian Y source rather than checking agreement between the duplicates.

Consequence for D01: in the same servo cycle, a duplicate joint can already have nonzero following error while Cartesian Y remains numerically consistent with the selected principal Y joint.

### 3. `check_for_faults()` — fault consequence

Only after forward-kinematics publication does `check_for_faults()` evaluate joint fault flags such as following error, amplifier fault, and limits for the machine-wide enable path. When a qualifying joint fault is found while enabled, the controller clears its internal enabling request/state, leading to motion-disable behavior.

Consequence for D01: a correctly ordered atomic trace may legitimately contain a sample where:

- duplicate-joint feedback has diverged,
- duplicate-joint following-error/fault state is asserted or becoming decisive,
- Cartesian Y still reports the selected principal-joint feedback,
- global motion enable is revoked in that cycle or the immediately subsequent observable state depending on HAL publication timing.

The experiment therefore must score bounded ordering rather than pretending sequential userspace reads are simultaneous.

## Authority boundary

This trace proves LinuxCNC software update order at the pinned revision. It does **not** prove physical gantry squareness, structural stiffness, independent encoder integrity, drive torque removal, STO behavior, or a functional-safety category. A runtime Cartesian coordinate is a software kinematics result, not an independent geometry measurement.

## D01 experiment implication

The decisive runtime evidence must be one realtime atomic recorder stream containing at minimum:

- phase marker,
- principal and duplicate joint commands,
- principal and duplicate joint feedback,
- principal and duplicate following-error/fault state,
- Cartesian Y feedback,
- global motion-enabled state,
- and recorder health/overrun evidence.

Sequential `halcmd getp` observations may be retained only as diagnostics; they are not the causal oracle.