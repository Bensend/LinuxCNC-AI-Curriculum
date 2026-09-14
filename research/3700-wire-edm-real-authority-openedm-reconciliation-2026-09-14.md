# 3700 Wire EDM — real-process authority and OpenEDM reconciliation

Date: 2026-09-14
Status: SOURCE / COMMUNITY EVIDENCE

## Scope

This pass follows `checkpoints/3700-next-2026-09-14.md` after the LinuxCNC adaptive-feed/reverse-path source question was closed. The objective is to ground the remaining wire-EDM process authority using real retrofit chronology plus adjacent open-source subsystem implementations, while keeping LinuxCNC field evidence separate from OpenEDM engineering evidence.

## 1. Sodick A320s LinuxCNC chronology

Primary community source:

- LinuxCNC forum, **Sodick wire EDM machine retrofit**, started 2020-01-05: https://www.forum.linuxcnc.org/30-cnc-machines/38133-sodick-wire-edm-machine-retrofit

Chronology preserved from the thread:

1. The project began with an intact Sodick A320s and incomplete/nearby wiring documentation. Early discussion already separated XYZ/UV geometric motion, wire tension, tank/process sensing, and material-specific process settings.
2. By 2020-03-17 the retrofit had XY and UV motion working, and wire run/tension still working through the original mechanism. The builder used `motion.spindle-enable` as the logical wire-run request. At that point the hard problem had become the spark source.
3. The builder intended to drive a custom MOSFET spark generator with PWM from LinuxCNC/Mesa, controlling pulse length/frequency independently from the axis loop.
4. By 2020-07-27 the original spark generator had been abandoned because its undocumented multilayer electronics could not be practically integrated. A custom high-side MOSFET generator produced real cuts in steel up to 30 mm, but cutting was too slow for useful production.
5. The custom generator had adjustable current-limiting resistance plus adjustable pulse on/off times. The builder explicitly stated there was no closed-loop feedback adjusting pulse current/voltage/timing; adaptive gap control was a separate experiment using gap voltage to alter feed.
6. Community suggestions proposed LinuxCNC adaptive/reverse motion and/or external offsets for gap control plus THCAD voltage measurement. These are candidate motion/feed mechanisms, not a complete spark-generator contract.
7. Later follow-up shows the machine did not mature into a publicly documented production-quality LinuxCNC wire-EDM controller. The spark generator and its control remained the central unsolved engineering burden.

### Durable interpretation

The strongest field-backed architecture is therefore not `one EDM controller`, but at least:

`program/path authority`
→ `LinuxCNC X/Y/U/V(/Z) motion`
→ `gap-voltage-derived feed/direction authority`

in parallel with:

`spark-generator enable + pulse/current recipe + generator fault`

and:

`wire run + tension + break authority`

and:

`dielectric/flushing/tank authority`.

A successful axis retrofit does not demonstrate a viable EDM process loop. The Sodick chronology is direct evidence of that separation.

## 2. Current Robofil 200 retrofit — evidence boundary

Primary source:

- LinuxCNC forum, **EDM retrofit**, started 2026-09-03: https://www.forum.linuxcnc.org/30-cnc-machines/59178-edm-retrofit

The current Robofil 200 project confirms continued community interest and the same architectural decomposition: X/U/Y/V/Z motion, analog Heidenhain scales, pulse-generator control, wire spool/tension, pumps and auxiliaries. As of the inspected 2026-09-06 reply, the public thread is still at architecture/hardware-selection stage. THCAD was suggested for process-voltage measurement and BAX EDM was suggested as a reference for the wire/pulse side.

**Do not promote this thread as a completed implementation.** It is useful current evidence of the problem decomposition, not evidence for exact gap law, pressure/flushing sequencing, wire-break recovery or spark-generator control.

## 3. OpenEDM arc generator — adjacent subsystem evidence

Repository:

- `OpenEDM/OpenEDM-arc-generator`
- inspected current main lineage through commit `f877a02d7413bad517c5a4f3360a5392b74bda45`
- project status and files: https://github.com/OpenEDM/OpenEDM-arc-generator

OpenEDM is **adjacent open-source engineering, not LinuxCNC field evidence**.

V1.1 demonstrates a useful spark-generator ownership split. Its power stage is described as an explicit state machine with INIT, inductor charging, pause, ignition and arc-energy states. In the documented iso-frequency control example:

- `t_on` owns ignition-delay + arc-duration timing;
- `t_off` owns inter-arc pause;
- Q1 regulates inductor current using cycle-by-cycle current limiting against a target;
- Q2 owns ignition/arc switching timing;
- generator state depends on whether gap conditions actually permit an arc.

This supports the curriculum model that **spark recipe/control state is its own realtime subsystem**. It should not be conflated with LinuxCNC trajectory adaptive feed.

The project also explicitly records hardware maturity limits. V1.1 was built/tested but retains serious thermal/layout issues; later V2.1 is on hold because simulation exposed issues. Therefore OpenEDM is valuable architecture evidence but not a turnkey production spark source.

## 4. OpenEDM wire tensioner — separate closed-loop authority

Repository:

- `OpenEDM/OpenEDM-wire-tensioner`
- inspected current main lineage through commit `2b020ae5ccab33575f19c8ae7b2895d862c7a57e`
- https://github.com/OpenEDM/OpenEDM-wire-tensioner

The implementation makes wire transport/tension a distinct closed loop:

- user/upper-layer feed-speed setpoint;
- tension setpoint;
- load-cell measurement via HX711;
- output feeder speed corrected with PID from tension error;
- input feeder follows nominal feed speed;
- motors are inhibited when measured tension is below a minimum threshold (500 g in the inspected firmware), treating low tension as probable broken wire;
- startup deliberately unloads/tare-calibrates the tension measurement and then retensions above the minimum threshold before normal running.

The README also documents deliberate noise hardening of the load-cell path: 80 SPS HX711 operation, a changed analog low-pass network and shield bonding because EDM electromagnetic noise can corrupt tension measurement.

### Durable interpretation

`wire run commanded` is not equivalent to `wire healthy`.

A defensible wire-EDM authority model needs separate witnesses for at least:

- requested wire speed;
- requested tension;
- measured tension;
- sensor freshness/validity;
- broken-wire/low-tension state;
- feeder/controller fault;
- actual wire-motion proof if required by the implementation.

OpenEDM currently demonstrates a local tension loop and a low-tension stop rule, not a complete LinuxCNC restart/rethread/recovery sequence.

## 5. Gap-voltage path — what is and is not established

The Sodick chronology establishes that gap voltage was intended to drive adaptive feed and that practical cutting performance depends heavily on generator/process quality. The current Robofil thread independently points to THCAD as a possible voltage acquisition path.

What is **not** yet publicly frozen from a mature implementation:

- exact voltage divider/isolation/scaling on a production LinuxCNC wire EDM;
- freshness/timeout semantics for the sampled gap signal;
- validated forward/slow/hold/reverse thresholds/hysteresis;
- anti-chatter filtering and minimum dwell rules;
- interaction between motion reversal and spark enable;
- restart policy after sustained short/open circuit;
- cut-quality/servo tuning across material/thickness recipes.

Accordingly, do **not** invent a universal gap-control transfer function. Preserve only the architecture:

`gap voltage acquisition -> filtered/validated process observable -> bounded feed/direction request -> LinuxCNC adaptive motion`

with spark/wire/flushing authorities remaining separate.

## 6. U/V taper and geometric authority

Real community evidence consistently treats X/Y and U/V as independent geometric axes for wire position/taper, with Z present on some machines. This supports a separate **geometry/kinematics** layer from process-gap regulation.

A future playbook must therefore avoid allowing the gap controller to silently rewrite U/V geometry. Adaptive feed/reverse should advance or retreat along the commanded multidimensional path; taper geometry remains program/kinematics authority unless a separately justified compensation layer exists.

## 7. Pause / abort / recovery contract — evidence-backed minimum

Combining LinuxCNC source work from the prior artifact with the real/adjacent evidence above yields this minimum recovery contract:

1. **Motion state** — know whether the path is advancing, held, decelerating for reversal, reversing, or aborted.
2. **Spark state** — explicit generator enable/off plus recipe state; do not infer it from path direction.
3. **Wire state** — explicit run command and tension/break witness; low tension must block continued cutting.
4. **Dielectric/flushing state** — explicit readiness/command state; not established by motion state.
5. **Geometry state** — preserve X/Y/U/V(/Z) commanded path/taper state independently from process feedback.
6. **Restart eligibility** — require process witnesses to be valid again before re-enabling erosion; do not assume reversing the toolpath reconstructs prior process outputs.

This is intentionally a contract boundary, not a claim that any inspected public LinuxCNC config implements all six items.

## 8. Adversarial review

Questions applied to the merged evidence:

1. Does working XYUV motion prove EDM process viability? **No.** Sodick chronology disproves that shortcut.
2. Does negative adaptive feed undo synchronized spark/wire outputs? **No.** Prior LinuxCNC TP source trace already closed that question.
3. Does `motion.spindle-enable` prove actual wire motion/tension? **No.** It was used as a logical request in the Sodick build.
4. Is low tension alone a universal broken-wire detector? **No.** It is an OpenEDM implementation rule, not a universal standard.
5. Can OpenEDM arc-generator timing be copied as LinuxCNC's universal EDM recipe? **No.** It is one adjacent topology/control mode.
6. Is THCAD itself a complete gap-control loop? **No.** It is only a possible acquisition interface.
7. Does current Robofil 200 discussion prove a working five-axis EDM retrofit? **No.** The thread is still at architecture selection.

Result: **7/7 boundaries preserved.**

## 9. Information-gain decision

The public LinuxCNC wire-EDM branch now has a useful breadth-level authority model, but still lacks an inspectable mature end-to-end process controller with exact gap law, spark-generator handshake/faults, wire-break recovery and dielectric readiness.

Reopen 3700-E2 immediately if any of these appear:

- downloadable mature LinuxCNC wire-EDM HAL/config/custom component;
- BAXEDM or another production controller exposes a public machine-interface/process contract;
- Robofil 200 thread gains implementation files or commissioning results;
- a public retrofit exposes exact gap-voltage scaling/filtering and recovery logic.

Absent that, the next highest-information work is 3700-G1: compare real servo/direct-scale and hydraulic/directional-valve grinder implementations.
