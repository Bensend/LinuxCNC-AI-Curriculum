# 3700 Grinding, EDM and Specialty Process Machines — breadth audit

Date: 2026-09-14
Status: **BREADTH / TRACK-MAP PASS COMPLETE**

Pinned LinuxCNC source revision for source-level curriculum claims remains `f666f1a51ae7c4d991cc61233e785dcc53fbe98d` unless a claim is explicitly marked as current-web/community evidence.

## Purpose

Audit the 3700 specialization before deep work. The curriculum scope is process machines where the process loop matters as much as geometry: surface/cylindrical/profile grinding, wire/sinker/hole-drill EDM, honing and nearby specialty processes.

The key question is not merely whether LinuxCNC can move the axes. It is whether the machine can preserve process state, adapt motion from process feedback, manage consumables/tool state, and recover safely and repeatably from partial cycles.

## Breadth conclusion

3700 should not be taught as one generic machine family. It naturally divides into three different control classes:

1. **Grinding** — mostly deterministic motion plus wheel/workpiece/process compensation, dressing, oscillation, spindle/workhead coordination, in-process measurement and recipe/state management.
2. **EDM** — true process-feedback machining where spark-gap condition can modulate feed, hold motion, or run the programmed path in reverse. Power-generator behavior, flushing and wire/electrode state are first-class machine state.
3. **Honing / specialty finishing** — repetitive reciprocating or synchronized motion combined with force/expansion/feed control and part-quality process logic; useful as a bridge between conventional CNC and process-centric control.

The most uniquely 3700 branch is **EDM**. Grinding reuses much more of ordinary LinuxCNC motion and spindle infrastructure, while EDM directly exercises adaptive feed, reverse-path behavior, process sensing and feedback-driven recovery.

## Native LinuxCNC primitives that matter

### Adaptive feed / reverse path

LinuxCNC `M52` enables `motion.adaptive-feed`. At the pinned source revision, the adaptive-feed input may be negative; a negative value runs the G-code path in reverse. The upstream documentation explicitly names plasma cutters and wire spark eroders as intended applications, while also warning that reverse adaptive-feed is relatively new and not yet extensively tested.

This is a foundational 3700 primitive because it permits a spark-gap controller to map process state into:

- positive feed when the gap is healthy;
- reduced positive feed as the process degrades;
- zero for hold;
- negative feed for controlled retreat/backtracking.

Do not equate this with a complete EDM controller. The gap estimator, filtering, thresholds, hysteresis, power-generator state and restart policy still need machine/process logic.

### External axis offsets

LinuxCNC external offsets allow a realtime process loop to add a bounded axis correction while coordinated G-code continues. They preserve per-axis velocity/acceleration allocation and expose active/limited state.

This is relevant to:

- EDM gap correction where a small process offset is preferable to full path reversal;
- cam/profile grinding where wheel infeed is derived from rotary angle;
- compensation based on wheel wear, measured diameter or other process variables.

The official `eoffset_per_angle` component and shipped external-offset simulations are especially relevant to cam/profile grinding. They demonstrate computing an offset from a measured rotary/spindle angle and applying it to a linear axis.

External offsets have important recovery semantics: offsets reset to zero on machine-on, have independent planning limits, and can hit soft-limit behavior that needs explicit machine logic. 3700 must teach those state/recovery boundaries rather than treating eoffset as invisible compensation.

### Synchronized I/O and process state

M62/M63, M67/M68, M66, HAL and custom/remapped code can synchronize process outputs and wait on process inputs. These are sufficient primitives for many coolant, dresser, flush, wire, valve and recipe functions, but machine-specific process state must remain explicit.

## Grinding breadth

### G1 — surface grinding

Public LinuxCNC retrofit discussions show two recurring architectures:

- keep the high-speed table traverse hydraulic/mechanical and automate mainly cross-feed and down-feed;
- convert additional axes to servo/stepper motion when controlled positioning or programmable recipes justify it.

A 2023 hydraulic surface-grinder thread is especially useful because the owner planned linear-scale feedback with LinuxCNC while preserving hydraulic X/Y/Z actuation. Community feedback emphasized that the reciprocating table can remain a process mechanism rather than forcing every movement into a conventional CNC positioning axis.

Teach surface grinding as a recipe/state problem:

- table traverse / reversal;
- cross-feed increment;
- down-feed or plunge increment;
- spark-out passes;
- wheel spindle ready/fault;
- coolant/filtration;
- magnetic chuck or workholding state;
- dresser approach, dress depth, number of passes and compensation;
- abort/restart while part or wheel is mid-cycle.

A final surface-grinding implementation should distinguish **positioning accuracy** from **traverse repeatability and process finish**. A hydraulic table may not need servo-style point positioning to be useful, but reversal timing, cross-feed and down-feed state still need deterministic authority.

### G2 — cylindrical grinding

Cylindrical grinding adds workhead synchronization, traverse/plunge modes, shoulders, taper/eccentric features and wheel-diameter compensation. Public LinuxCNC questions have specifically asked for an independently oscillating/traversing axis while the rest of the program continues, implying that cylindrical grinders often need a process oscillator/state machine rather than a simple sequence of ordinary G-code blocks.

Deep work should compare:

- explicit G-code traverse cycles;
- remapped/custom grinding cycles;
- realtime/HAL oscillators for repetitive stroke motion;
- workhead encoder synchronization when the feature depends on angular position.

### G3 — camshaft / crankshaft / non-round grinding

This is one of the most interesting grinding specializations. LinuxCNC community work has repeatedly discussed cam grinding using rotary-angle-driven external offsets.

Critical lesson: the commanded radius is not enough. The wheel/work contact point changes with tangent angle and **wheel diameter matters**. Wheel diameter changes as the wheel dresses/wears, so a cam grinder needs a defensible wheel-radius state and likely a method to measure or qualify it.

The native `eoffset_per_angle` mechanism makes a very useful learning foundation, but it is not itself a complete cam-grinding solver. 3700 should study:

- source cam/lobe geometry;
- contact geometry and tangent-point correction;
- wheel radius/diameter measurement and revision;
- phase relationship between workhead angle and infeed;
- profile interpolation rate and smoothness;
- traverse along the camshaft;
- dressing/wear compensation;
- surface-finish sensitivity to servo/trajectory behavior.

A current December 2025 LinuxCNC camshaft-grinder build is useful field evidence for the basic A-axis + linear-infeed architecture, but it is still early-stage and should not be treated as a complete canonical control.

### G4 — wheel dressing and wheel-state ownership

Dressing is not auxiliary housekeeping; it changes the effective cutting tool geometry.

The grinding branch should explicitly track:

`wheel identity -> nominal wheel geometry -> dressed geometry -> measured/estimated radius -> compensation generation -> active grinding program`

A dress cycle can invalidate previously calculated cam/profile compensation or dimensional offsets. Recovery after an interrupted dresser cycle must therefore reconcile wheel state rather than simply resume the next G-code line.

The breadth audit found good conceptual/forum evidence for dressing and wheel-diameter importance, but not yet a strong downloadable production LinuxCNC grinder configuration with complete dresser state and compensation provenance. This is a priority evidence gap.

## EDM breadth

### E1 — wire EDM motion architecture

Real LinuxCNC users have retrofitted or attempted Sodick and Charmilles/Robofil-class wire machines. The common mechanical/process architecture includes:

- X/Y principal path;
- U/V upper-guide offset for taper on 5-axis machines;
- optional Z guide-height axis;
- wire feed;
- wire tension;
- flushing/pumps/valves;
- wire-break detection;
- spark-generator command/feedback;
- gap/process feedback.

A current September 2026 Robofil 200 retrofit thread confirms this remains active community work. The builder identified X/U/Y/V/Z motion, analog linear scales, spark-generator control, wire spool/tension and pumps as the main retrofit surfaces.

Do not assume a five-axis wire machine is simply a foam cutter plus a power supply. Kinematics, guide geometry, taper, flushing and spark-gap authority interact with the cut.

### E2 — spark-gap feedback and motion authority

This is the defining 3700 control loop.

The public Sodick retrofit discussion and LinuxCNC documentation support the following generic model:

`gap/process sensor -> filter/classifier -> adaptive-feed / external-offset authority -> coordinated path`

Healthy gap can allow forward motion. Shorting/poor-gap state can reduce feed, hold, or command reverse motion. Recovery then resumes along the existing path when the process returns to an acceptable state.

A Mesa THCAD-type analog front end is repeatedly suggested for isolated voltage measurement in community EDM discussions, but the curriculum must treat the exact sensing electronics and scaling as machine-specific.

Do not freeze one universal gap algorithm. Different EDM power supplies may expose average gap voltage, current, pulse-success statistics, digital status or proprietary servo signals. The controller architecture should separate:

- raw measured signal(s);
- conditioned gap metric;
- process state/classification;
- motion correction request;
- final feed/reverse authority.

### E3 — spark generator / pulse generator

Motion retrofit is often the easy half of wire EDM. Public builders repeatedly report that the difficult part is understanding or recreating the spark generator.

The LinuxCNC curriculum should not design a production high-voltage EDM generator as a graduation requirement. It should, however, learn the interface deeply enough to integrate one safely and correctly:

- enable/disable;
- pulse voltage/current/energy parameters;
- pulse on/off timing;
- polarity/AC considerations;
- ready/fault state;
- process feedback available to the motion loop;
- recipe ownership by material/wire/electrode/finish stage;
- startup/shutdown and discharge state.

Adjacent open-source project **OpenEDM** is now a high-value discovery source. As of September 2026 it has separate open repositories for a wire machine, arc generator and wire tensioner, with active development in 2026. Its arc-generator project documents multiple hardware topologies and warns explicitly about lethal voltage hazards. Use it to learn EDM process/electronics architecture, not as LinuxCNC-specific implementation evidence.

### E4 — wire feed and tension

Wire speed and wire tension are separate process variables.

OpenEDM's tensioner is a useful concrete open-source example: an output feeder pulls the wire while an input feeder/brake participates in tension control; a load cell provides tension feedback, and the firmware uses a PID loop plus a low-tension condition to stop the motors when the wire is likely broken.

This supports a durable 3700 contract:

`wire feed setpoint != wire tension setpoint != wire-present/broken state`

The LinuxCNC-facing implementation may leave the tension loop in a dedicated controller and exchange setpoints/status, or implement an equivalent realtime loop in HAL. 3700 should compare ownership rather than assuming one location is always best.

### E5 — flushing, dielectric and auxiliary process state

Wire and sinker EDM require fluid/process management that directly affects cut stability:

- flushing flow/pressure;
- fill/drain/tank state where applicable;
- conductivity/deionization state on water-based wire machines;
- filter condition;
- pump ready/fault;
- wire threading/break state;
- electrode/tool state.

These are not ordinary coolant toggles. Program continuation may be invalid if the required process condition is lost.

### E6 — sinker / hole-drill EDM

Sinker EDM can use a much simpler geometric path than wire EDM but has additional electrode-wear and gap-servo concerns. A LinuxCNC forum `sinker101` kit demonstrated a bounded sinker/EDG/hole-drill direction using external offsets and a simulated gap signal, while a 2023 homebrew sinker project emphasizes electrode wear and pulse-generator design.

Study:

- Z-only servo and orbital/3-axis sink strategies;
- electrode wear and multi-electrode workflows;
- gap feedback;
- flushing;
- power recipe stages from roughing to finishing;
- touch/reference without damaging electrode/workpiece;
- restart after a short, arc fault or interrupted burn.

## H1 — honing / specialty finishing

A Delapena E3500 honing retrofit discussion provides a strong third machine class. The machine has:

- reciprocating Z motion;
- a tool-expansion axis;
- servo spindle with encoder;
- controlled relationship between reciprocation, rotation and expansion;
- custom operator-cycle requirements.

The existing machine reportedly used sinusoidal stroke motion and could alter dwell/rotation behavior at the ends of the bore to correct taper or bell-mouth. This is exactly the kind of process machine that justifies 3700: geometry alone is insufficient; the finishing result depends on synchronized motion and process recipe.

Potential specialty extensions after core evidence is mature:

- lapping/polishing;
- superfinishing;
- abrasive belt finishing;
- specialty deburring/brush processes;
- EDG/electrical discharge grinding.

Do not expand 3700 into every unusual machine. Promote a specialty process only when there is enough community/source evidence to teach a distinct control pattern.

## Cross-cutting 3700 state model

All 3700 branches should separate at least these layers:

1. **Geometric program state** — commanded path/position/profile.
2. **Process recipe state** — wheel/burn/hone parameters, feeds, power, coolant/flushing, material/finish stage.
3. **Consumable/tool state** — wheel diameter/dress generation, wire/electrode state, honing stone expansion/wear.
4. **Process feedback state** — gap voltage/current, tension, force, in-process gauge, vibration or other sensor evidence.
5. **Execution authority** — forward feed, hold, reverse, offset correction, retract, cycle abort.
6. **Recovery/reconciliation state** — what remains valid after process fault, power interruption, wire break, dresser interruption or partial cycle.

## Highest-value deep work sequence

### 3700-E1 — EDM feedback/control deep trace

Start with upstream `motion.adaptive-feed`, M52 reverse semantics, external offsets and the exact current motion-source behavior. Then trace one real wire-EDM implementation/build deeply enough to preserve gap-feedback, wire, flushing and recovery behavior.

Preferred field sources:

- Sodick A320 LinuxCNC retrofit chronology;
- current September 2026 Robofil 200 retrofit as an active follow-up;
- BAXEDM field material if a durable inspectable source/config can be found.

### 3700-E2 — adjacent open-source EDM subsystem study

Source-trace OpenEDM arc generator and wire tensioner to understand:

- generator command/feedback surfaces;
- pulse/energy parameterization;
- tension/feed ownership;
- wire-break detection;
- EMI/noise mitigation;
- modular controller boundaries.

Do not treat OpenEDM as proof of LinuxCNC integration.

### 3700-G1 — surface/cylindrical grinder implementation comparison

Find at least one reasonably complete LinuxCNC grinder retrofit with downloadable HAL/INI/remap/HMI files. Compare against the hydraulic surface-grinder architecture and the Jones & Shipley/camshaft work.

Focus on oscillation/traverse ownership, dresser state, wheel compensation, spark-out, workholding/coolant and recovery.

### 3700-G2 — cam/profile grinding

Source-trace `eoffset_per_angle`, external-offset simulation and any available cam-grinding code. Establish wheel-radius ownership and tangent/contact compensation before considering a lab.

### 3700-H1 — honing process architecture

Deep-read the Delapena hone discussion and seek a real completed config. Model reciprocation, spindle phase/relationship, expansion, reversal shaping and end-of-bore correction.

## Candidate bounded experiments — only if evidence leaves a question

- adaptive-feed positive -> zero -> negative path continuity/recovery test;
- EDM gap classifier driving adaptive feed with hysteresis and intentionally noisy sensor input;
- external-offset soft-limit behavior under an EDM correction request;
- cam/profile `eoffset_per_angle` simulation with changing wheel-radius parameter;
- interrupted dress-cycle state reconciliation model;
- honing reciprocation profile comparison: trapezoidal versus sinusoidal stroke;
- wire-tension loss/broken-wire state transition in a simplified simulated loop.

Do not run these merely because 3700 exists. Prefer real source/config evidence first.

## Promotion boundary

Do not call 3700 mature until the curriculum has at least:

1. one source/config-traced grinder implementation with dresser or wheel-compensation state;
2. one source/config-traced wire or sinker EDM implementation with actual process feedback affecting motion;
3. a defensible spark-generator interface model that separates generator physics from LinuxCNC motion authority;
4. wire/electrode/consumable state and recovery behavior;
5. one specialty finishing implementation (honing is the current best candidate) demonstrating a process loop not reducible to ordinary milling/turning;
6. a recovery playbook covering wire break/short, lost process feedback, dresser interruption, wheel-state uncertainty and partial-cycle restart.

## Breadth verdict

3700 has enough depth to justify a full specialization. The branch with the highest unique information gain is **EDM feedback and recovery**. Grinding should follow with emphasis on dressing/wheel-state ownership rather than generic axis motion. Honing is the strongest current specialty-process candidate because it introduces synchronized reciprocation, expansion and quality-shaping behavior without duplicating another 3000 track.
