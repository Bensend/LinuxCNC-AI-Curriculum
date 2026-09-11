# 3600 press-brake backgauge operator-mode contract — 2026-09-11

Status: RESEARCH / SOURCE ANALYSIS

## Scope

Bound the first-stage backgauge capability before DXF automation. Owner intent is deliberately simple first: operator may enter an absolute gauge distance or hold an arrow/jog control until the gauge is where desired. This note tests how that maps onto LinuxCNC semantics and two public press-brake implementations.

## LinuxCNC documentation findings

Current LinuxCNC documentation separates manual jogging, MDI/commanded motion, joint-vs-world/teleop mode, and homing rather than treating all operator movement as one command surface.

- AXIS documents continuous jog as motion while a button/key is held and incremental jog as a specified distance per activation.
- The Python command API exposes `JOG_STOP`, `JOG_CONTINUOUS`, and `JOG_INCREMENT`; `jjogmode=True` addresses a joint and requires teleop disabled, while Cartesian axis jog uses teleop enabled.
- `halui` exposes explicit MANUAL/MDI/AUTO and joint/teleop mode requests/status. MDI commands are separately configured actions.
- Default LinuxCNC behavior requires homing before MDI/program execution; normally jogging remains available before homing. `NO_FORCE_HOMING=1` bypasses that rule for identity kinematics but the documentation warns LinuxCNC then does not know joint travel limits.
- Homing establishes the G53 machine origin used by soft limits. `HOME_SEARCH_VEL`, `HOME_LATCH_VEL`, `HOME_OFFSET`, `HOME`, and `HOME_SEQUENCE` define search/latch/reference behavior. `motion.homing-inhibit` can block homing initiation.

Engineering consequence: a press-brake HMI should not implement typed-position and hold-to-jog as two front ends to an unqualified raw position command. They are distinct operator intents with different lifecycle and authorization requirements.

## Public press-brake evidence 1 — Ursviken Pullmax Optima

The public LinuxCNC build diary identifies X as backgauge forward/back, R as backgauge up/down, and Z1/Z2 as independent left/right finger motion. The builder reports a real failure mode while commissioning a backgauge-related joint: incorrect encoder reading drove joint 6 against a positive hard stop while the motor held stalled at maximum power. The proposed correction was to add a timeout based on meaningful amplifier power combined with insufficient joint velocity. The same post notes Z1/Z2 lacked home/limit switches and might require hard-stop homing.

This is strong field evidence that `command issued` and even `servo energized` cannot be treated as proof of backgauge progress. Motion supervision needs an independent progress witness and a bounded response when commanded effort does not produce motion.

## Public press-brake evidence 2 — standalone open-source backgauge controller

`aleadvea/press-brake-cnc-upgrade` is a dual-ESP32, production-tested backgauge project. Its motor node owns step/dir motion, homing, limits and alarms; the HMI node owns operator/program workflow.

Source inspection of `motor_brain/src/motor_ctrl.cpp` shows:

1. explicit `IDLE`, `HOMING`, and `ALARM` exclusions around absolute moves;
2. a two-pass home sequence: fast sensor search, backoff, slow sensor reacquisition, then logical position assignment;
3. home-search failure becomes `ALARM_HOME_FAIL` rather than silently accepting an endpoint;
4. normal absolute movement is constrained by post-home soft limits;
5. a normally-closed home switch interrupt and driver-alarm interrupt stop motion during normal operation;
6. absolute positioning uses a deliberate one-direction final approach/overshoot strategy to reduce backlash ambiguity.

This project is not LinuxCNC and its safety properties are not adopted wholesale. It is useful independent evidence that a practical backgauge benefits from explicit homing ownership, bounded search, alarm state, travel limits, and repeatable final approach.

## First-stage 3600 contract

### Typed position

Treat an entered value as a requested **absolute backgauge target**, not as proof of a physical gauge location.

Minimum authorization before accepting an automatic/typed move:

- machine/control authorization is present;
- the gauge has a valid reference (`homed` or a separately justified absolute-position scheme);
- requested target is inside configured travel/soft limits;
- no gauge drive/feedback fault is active;
- no conflicting jog/home/program owner is active.

Execution must expose at least `requested_target`, `motion_active`, `position_feedback`, `at_target` with tolerance, and a fault/abort result. A completed command without a physical/position witness is not `at target`.

### Hold-to-jog

Treat arrow press/hold as **continuous manual intent**. Release, focus/control loss, mode change, authorization loss, limit/fault assertion, or explicit stop must revoke the jog request. Do not emulate hold-to-jog by repeatedly queueing absolute moves.

Incremental jog may be offered separately for fine positioning; it is not the same contract as continuous hold-to-jog.

Pre-home joint jogging can be useful for setup/recovery, but must be deliberately bounded because soft-limit authority is not yet established. For mechanically coupled/duplicated axes, individual joint jogging can create racking; LinuxCNC documentation explicitly warns about this case.

### Homing/reference

Reference acquisition owns motion while active. Typed positioning and ordinary jog must not race homing. Search must have a bounded travel/time/failure response; sensor detection should be followed by a repeatable latch/reference strategy appropriate to the hardware. The post-home reference establishes the coordinate frame used for subsequent travel limits.

Do not use `NO_FORCE_HOMING=1` merely to make the HMI convenient. It weakens the normal prerequisite and the LinuxCNC documentation explicitly notes the loss of known travel-limit authority.

### Interruption/recovery

On interruption, do not automatically resume a stale typed target merely because the fault or mode transition clears. Preserve the requested target for operator visibility if useful, but require explicit reauthorization after reference/feedback validity is reconciled.

A stalled/backstop condition needs a progress discriminator such as commanded motion/effort + insufficient position/velocity change for a bounded interval. Exact thresholds are machine commissioning values and are not inferred here.

## Minimal mode-ownership state model

`UNREFERENCED -> HOMING -> READY`

From `READY`, mutually exclusive ordinary motion owners are:

- `JOG_CONTINUOUS`
- `JOG_INCREMENT`
- `POSITIONING_TYPED`
- later `POSITIONING_PROGRAM`

Any owner may transition to `STOPPING/ABORTED` on authorization loss, limit, drive fault, stale/invalid feedback, progress timeout, or operator stop. Recovery returns through `READY` only if position/reference validity remains established; otherwise it returns to `UNREFERENCED` and requires reconciliation/homing.

This is ordinary machine-control architecture, not a functional-safety claim.

## Adversarial checks

1. **Arrow button gets stuck logically TRUE after GUI loses focus:** continuous jog must have a revocation/watchdog path outside the widget's visual state.
2. **Typed target entered before home:** reject automatic positioning; do not silently enable `NO_FORCE_HOMING`.
3. **Encoder freezes while drive is commanded:** target comparison alone can hang indefinitely; progress timeout/fault is required.
4. **Home sensor never arrives:** bounded home search must fault rather than consume unlimited travel.
5. **Home sensor already active at start:** homing strategy must explicitly back off/reacquire or otherwise define the hardware-specific valid sequence.
6. **Fault clears after interrupted typed move:** do not automatically continue toward the old target without explicit reauthorization and position/reference reconciliation.
7. **Operator jogs toward a limit before homing:** pre-home motion cannot rely on ordinary soft limits; physical limit/drive boundaries and conservative manual authorization remain necessary.
8. **Program and jog both request ownership:** arbitration must select one owner; commands must not sum or race.

## What this does not establish

- exact X/R/Z coordinate signs or travel for a particular machine;
- safe jog speed, acceleration, following-error, stall-power or stall-velocity thresholds;
- suitability of hard-stop homing for a particular mechanism;
- safety-rated stopping, guarding or protective-device behavior;
- automatic DXF bend sequencing or gauge-surface selection.

## Next verification checkpoint

Trace LinuxCNC's actual jog command path (`linuxcnc.command().jog` / Task command -> motion jog state) and homing inhibit/abort behavior at the pinned curriculum source revision. Then compare the public Ursviken implementation/config, if downloadable attachments expose X/R/Z ownership, against this contract. Only after that source trace should a small generic operator-mode experiment be frozen; it should test ownership/revocation/recovery rather than motor physics.
