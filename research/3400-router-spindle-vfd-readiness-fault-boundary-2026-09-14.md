# 3400 Router / Woodworking — spindle VFD readiness and fault boundary

Date: 2026-09-14
Real implementation: `Funkenjaeger/fj-lcnc-cfg`
Pinned inspected revision: `f4877f862ab757bd396b02e54acb12e6835f8259`

## Source path

The DCNC router uses a userspace Hitachi WJ200 Modbus component, `wj200_vfd_emd.comp`, rather than treating spindle run command as proof of spindle state.

The component exposes separate pins for:

- commanded frequency;
- run request;
- reverse request;
- enable;
- `is_running`;
- `is_at_speed`;
- `is_ready`;
- `is_alarm`;
- actual frequency;
- motor current;
- heatsink temperature;
- a toggling `watchdog_out` that advances only after a complete successful update cycle.

The component reads VFD status first and only then writes requested operating state. Communication failures cause that loop iteration to be abandoned before the watchdog toggles.

## Machine wiring actually used

`custom.hal` connects:

- `wj200-vfd-emd.0.is-at-speed -> spindle-at-speed -> spindle.0.at-speed`;
- LinuxCNC spindle run/reverse requests to the VFD component;
- machine enable to the VFD component enable;
- motor current to a diagnostic signal;
- `is-alarm` to a `spindle-fault` signal.

The inspected machine config does **not** wire the component's `is_ready` or `watchdog_out` into a visible cut/ATC permissive in the files inspected. `spindle-fault` is surfaced to the QtDragon handler for display, but the inspected path does not establish it as a machine-enable or motion-inhibit interlock.

Therefore the public configuration demonstrates that **status availability is not the same as status authority**.

## Internal VFD recovery behavior

The userspace component itself contains active recovery logic:

- if the VFD is not alarmed and component `enable` is false, it commands a remote trip;
- if the VFD is alarmed and component `enable` is true, it attempts a VFD reset and then sleeps one second before further communication;
- communication failures print an error and retry on later iterations;
- status/commands are userspace Modbus, not servo-thread realtime logic.

This means the machine has several distinct layers:

`LinuxCNC run/speed request -> userspace Modbus transport -> VFD command/state -> is-at-speed/alarm/ready/watchdog observations -> selected HAL/HMI consumers`

Only the observations actually wired into control logic gain authority.

## ATC interaction

The DCNC M6 remap starts with `M5`, yet repository history records a later fix for an indefinite Auto-mode pause during tool change. The fix inserted a zero-distance `G1 X0 F1` before the first real feed move, with a comment saying it mitigates waiting on spindle-at-speed on that first real G1.

Independent LinuxCNC community evidence also documents that ordinary feed moves wait when `spindle.0.at-speed` is false. Thus spindle readiness must be commissioned not only during cutting but also across stop/toolchange/probing transitions.

## Failure boundary

Do not conflate:

- commanded spindle stop;
- VFD `is_running` false;
- `is_at_speed` state;
- VFD READY;
- VFD alarm/fault;
- Modbus communication freshness;
- safety-rated spindle standstill.

They are different facts.

The public DCNC configuration has richer raw observability than its final control interlocks consume. In particular, the presence of a watchdog and READY output in the component does not prove that stale Modbus or VFD-not-ready blocks machine motion.

## Adversarial review

1. Does M5 prove spindle standstill? **No.** It is a command.
2. Does `is_at_speed` prove VFD communications are fresh? **Not by itself.** The separate watchdog exists for communication freshness.
3. Does `is_ready` exist? **Yes.** Is it used as a visible machine permissive in the inspected config? **No evidence found.**
4. Does `is_alarm` automatically stop all machine motion? **No evidence in the inspected HAL.** It is exposed as `spindle-fault`, including to HMI diagnostics.
5. Is automatic VFD alarm reset equivalent to safe automatic recovery? **No.** The component attempts protocol-level reset; machine/process restart authority remains a separate concern.
6. Is Modbus userspace feedback safety-rated standstill? **No.**
7. Can spindle-at-speed semantics interfere with ATC moves even after M5? **Yes, field history in this repo records exactly such a commissioning problem.**

Result: **7/7 boundary checks passed.**

## Promotion decision

Promote to the 3400 playbook:

- model spindle command, running, at-speed, ready, alarm and communication freshness separately;
- audit which available VFD observations are merely displayed versus actually used as motion/ATC permissives;
- test spindle readiness semantics across cutting, stopping, probing and ATC transitions;
- userspace VFD recovery logic should not silently become machine-cycle restart authority;
- ordinary-control feedback is not a substitute for safety-rated standstill when the machine hazard analysis requires it.
