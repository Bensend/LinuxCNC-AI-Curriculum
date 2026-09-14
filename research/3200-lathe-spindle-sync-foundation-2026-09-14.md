# 3200 — Lathe spindle synchronization foundation pass

Date: 2026-09-14
LinuxCNC source revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: dependency-safe 3000-series preparation while F02 external handoff remains pending

## Why this branch

The 3600 press-brake branch is at a documented information-gain stop. Under `WORK_SELECTION_POLICY.md`, work rotated to 3200 because lathes are a broad LinuxCNC machine class and expose reusable spindle-feedback, synchronization, realtime trajectory, encoder/index, auxiliary-control and operator-state patterns.

This first pass deliberately focuses on the spindle-synchronized-motion foundation rather than attempting the whole lathe track at once.

## Documentation baseline

Official LinuxCNC lathe documentation establishes several lathe-specific contracts:

- spindle-synchronized motion requires spindle feedback; the lathe user guide describes a quadrature encoder with one index pulse/revolution for synchronized motion;
- G76 is the dedicated threading cycle; feed-per-revolution (G95) is not a substitute for threading;
- CSS (G96) computes spindle speed from X radius/diameter geometry relative to machine X origin and tool X offset; the machine X origin therefore has semantic importance at the spindle centerline;
- motion exposes `spindle.N.at-speed`; Motion may wait on it before the first feed after spindle start/speed change, before a chain of spindle-synchronized moves, and at CSS rapid-to-feed transitions;
- LinuxCNC supports multiple spindles and lets G-code choose the spindle used for synchronized motion.

Primary docs:

- https://linuxcnc.org/docs/stable/html/en/lathe/lathe-user.html
- https://linuxcnc.org/docs/master/html/en/examples/spindle.html
- https://linuxcnc.org/docs/stable/html/en/config/core-components.html
- https://linuxcnc.org/docs/stable/html/en/gcode/g-code.html

Evidence classification: `DOC-CONFIRMED`.

## Pinned source path: G33/G33.1/G76 into Motion

At source revision `f666f1a51...`, `src/emc/rs274ngc/interp_convert.cc` provides a source-visible command path.

### Interpreter boundary

`Interp::convert_straight()` handles G33 and G33.1 directly and dispatches G76 to `Interp::convert_threading_cycle()`.

For G33 the interpreter:

1. resolves the selected spindle (`$` where supplied);
2. rejects a spindle that is not marked clockwise/counterclockwise;
3. calculates the requested synchronized move delta;
4. calls `check_spindle_sync_feed(...)` before issuing the move;
5. suspends spindle-speed override;
6. calls `START_SPEED_FEED_SYNCH(active_spindle, K, 0)`;
7. emits the coordinated `STRAIGHT_FEED(...)`;
8. calls `STOP_SPEED_FEED_SYNCH()` and restores the override.

G33.1 follows the same synchronization boundary but emits `RIGID_TAP(...)` and can apply its I-word retract multiplier.

G76 likewise requires a selected spindle to be turning and then enters `convert_threading_cycle()`.

Evidence classification: `SOURCE-CONFIRMED`.

### Canonical/task boundary

`START_SPEED_FEED_SYNCH()` is declared in `src/emc/nml_intf/canon.hh` as a threading synchronization primitive.

`src/emc/task/emccanon.cc` implements it by flushing pending segments and creating an `EMC_TRAJ_SET_SPINDLESYNC` message carrying:

- spindle number;
- feed-per-revolution synchronization value;
- synchronization mode flag.

`src/emc/task/emctaskmain.cc` receives `EMC_TRAJ_SET_SPINDLESYNC_TYPE` and calls `emcTrajSetSpindleSync(...)`.

`src/emc/task/taskintf.cc` converts that to an `EMCMOT_SET_SPINDLESYNC` command with spindle, `spindlesync`, and flags fields, then writes it into the Motion command interface.

Evidence classification: `SOURCE-CONFIRMED`.

### Realtime Motion / trajectory-planner boundary

`src/emc/motion/command.c` handles `EMCMOT_SET_SPINDLESYNC` by calling:

`tpSetSpindleSync(&emcmotInternal->coord_tp, spindle, spindlesync, flags)`

`src/emc/tp/tp.c` implements `tpSetSpindleSync(...)` and selects the trajectory planner's synchronized mode when the synchronization value is nonzero. Separate synchronization modes exist for velocity-style versus position-style synchronization.

`src/emc/motion/control.c` reads the HAL spindle feedback into Motion status each realtime cycle, including:

- `spindle.N.revs` -> `spindleRevs`;
- `spindle.N.speed-in` -> `spindleSpeedIn`;
- spindle at-speed state.

`src/emc/tp/tp.c` consumes signed spindle position from Motion spindle status while executing synchronized trajectories.

Bounded source call flow:

`G33/G76 interpreter -> START_SPEED_FEED_SYNCH -> EMC_TRAJ_SET_SPINDLESYNC -> emcTrajSetSpindleSync -> EMCMOT_SET_SPINDLESYNC -> tpSetSpindleSync -> TP synchronized trajectory`

with spindle position/speed entering Motion from HAL in the realtime control cycle.

Evidence classification: `SOURCE-CONFIRMED`.

## Important architecture boundary: command, synchronization feedback and readiness are distinct

A lathe spindle has at least three logically separate surfaces:

1. **command/intent** — requested speed and M3/M4 direction;
2. **synchronization feedback** — spindle revolutions/phase/index used by synchronized motion;
3. **readiness** — `spindle.N.at-speed`, which is a separate input used to gate cutting transitions.

None should be inferred from another. A VFD accepting a speed command does not prove phase feedback is valid; a valid encoder count does not prove the spindle is at commanded speed; an at-speed predicate does not prove index/phase semantics are wired correctly.

This separation is directly reusable for other machine classes that have command, feedback and authorization/readiness layers.

## Community failure case: signed spindle readiness

A January 2025 LinuxCNC forum case reported CSS working clockwise but failing for an upside-down parting tool under M4/CCW. The eventual resolution was not a Motion/G96 defect: the user's spindle-at-speed detection used an absolute-value command signal. Changing the predicate from `spindle.0.speed-out-abs` to signed `spindle.0.speed-out` restored operation.

Source: https://forum.linuxcnc.org/20-g-code/54997-solved-css-g96-with-ccw-spindle-m4-on-lathe

Classification: `COMMUNITY-REPORTED`, reconciled with the documented fact that `spindle.N.at-speed` is an external Motion input and can gate CSS feed transitions.

General lesson: a readiness predicate must preserve every semantic dimension needed by the controller. Collapsing direction with `abs()` can make the predicate numerically plausible while semantically wrong.

## Existing LinuxCNC fixtures

Pinned source contains a `configs/sim/axis/lathe.ini` sample and `tests/lathe/` regression fixture. The sample establishes a normal X/Z trivkins lathe machine surface and the test directory demonstrates that lathe-specific behavior has upstream executable coverage.

This session did not claim that `tests/lathe/` specifically validates the full G76 realtime synchronization chain; that would require inspecting the exact test assertions and/or running a targeted fixture.

## Failure and safety boundaries

### Failure classes already supported by evidence

- spindle not marked turning before G33/G33.1/G76 -> interpreter rejection;
- requested synchronized feed beyond machine capability -> `check_spindle_sync_feed()` is part of interpreter-side validation, but comments in source warn that downstream motion limits can still produce an incorrect physical thread if the machine cannot deliver the demanded motion;
- incorrect `at-speed` construction -> cutting transition can remain blocked or be authorized incorrectly;
- bad/missing phase/index feedback -> synchronized motion semantics cannot be assumed merely because spindle command works.

### Safety boundary

Spindle synchronization and `at-speed` are ordinary LinuxCNC machine-control mechanisms, not evidence of safety-rated spindle stopping, chuck guarding, door interlocking, safe torque off, or safe speed monitoring.

## Adversarial boundary review

1. Does M3/M4 command prove synchronized feedback? **No.**
2. Does encoder motion prove `at-speed`? **No.**
3. Does `at-speed` prove index/phase integrity? **No.**
4. Is G95 equivalent to G76 threading? **No.**
5. Is CSS purely a spindle subsystem? **No; it depends on X geometry/origin and tool offset.**
6. Can a numerically plausible absolute-value readiness predicate destroy direction semantics? **Yes; community field case demonstrates this failure class.**
7. Does this pass prove turret, C-axis/live tooling, chuck/tailstock, probing or spindle-orient behavior? **No.**

Result: **7/7 PASS** for the bounded foundation claims.

## Laboratory decision

No new laboratory job was launched. The purpose of this pass was to establish the source/documentation execution graph and identify the next highest-value evidence gap. A synthetic spindle fixture at this stage would duplicate already source-visible behavior without yet testing a frozen novel claim.

A later targeted experiment is justified after the exact upstream synchronization test surfaces are inspected. Candidate experiment: deliberately corrupt spindle phase/index/readiness independently and verify which layers reject, wait or continue.

## Open questions / next source targets

Highest-value 3200 continuation work:

1. inspect `convert_threading_cycle()` deeply enough to document the G76 pass-generation algorithm, taper/entry/exit behavior and synchronization boundaries;
2. inspect TP spindle-sync state transitions, especially index waiting and pause/resume behavior;
3. inspect upstream synchronized-motion/threading tests and freeze a non-duplicate fault experiment only if they leave an important behavior unverified;
4. mine at least two real lathe retrofit/build configs for encoder/index, CSS, spindle-at-speed and threading wiring;
5. then move to turret/tool-table/toolchange architecture, which is both lathe-specific and rich in custom state-machine failure/recovery behavior.

Do not generalize from the simulator or one community configuration into a canonical lathe architecture.
