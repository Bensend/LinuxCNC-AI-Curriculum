# 3900 Emerging and Unusual Machines — breadth audit

Date: 2026-09-14
Status: **BREADTH / INCUBATOR TRACK MAP COMPLETE**

## Purpose

3900 is the curriculum's incubator for machine classes that are genuinely different from mills/lathes/routers/process cutters but do not yet justify a permanent numbered specialization. It should not become a miscellaneous dumping ground.

The job of 3900 is to identify recurring control patterns, gather enough real LinuxCNC evidence to understand them, and promote a machine family into its own track only when evidence shows sustained community use and a distinct body of engineering knowledge.

Current examples include gear hobbing, tube/pipe machinery, foam cutters, wire-forming/winding machines, additive/hybrid systems and other unusual industrial machines.

## Breadth conclusion

The survey found four strong recurring control patterns plus a smaller set of demonstration-only oddities:

1. **Electronic gearing / process synchronization** — gear hobbing, gear shaping, spring/wire winding and related processes where one rotational or linear quantity must maintain a precise ratio to another.
2. **Geometry split across multiple tool ends** — hot-wire foam cutters and similar machines where two independent XY/UV endpoints define one physical cutting element and ordinary cutter compensation assumptions do not fit cleanly.
3. **Deposition / additive process coordination** — FFF/FDM, paste deposition, SLS/other additive and hybrid machines where material flow, temperature and trajectory must remain synchronized.
4. **Recipe/table-driven forming machines** — tube/pipe benders and related machines where the operator thinks in feed length, rotation, bend angle, tooling and clamp/mandrel states rather than conventional XYZ toolpaths.
5. **Small unusual machine examples** — embroidery/sewing, scratchers, unusual multi-spindle carving machines and similar projects. These are useful to demonstrate LinuxCNC's flexibility and custom-HMI methods, but they should not receive a full branch unless repeated evidence shows a transferable machine class.

The strongest current candidates for eventual promotion beyond 3900 are **additive manufacturing** and, secondarily, **gear generation/electronic gearing**.

## 3900-G — gear generation and electronic gearing

Gear hobbing is a mature example of using LinuxCNC for a machine whose essential operation is not ordinary Cartesian interpolation. The hob spindle and gear blank must maintain a defined ratio; additional feed axes position the hob and can introduce helix lead, hob shift or worm/tangential effects.

Long-running LinuxCNC community implementations exist, including Andy Pugh's electronic hobbing work and multiple independent users adapting the pattern. A 2025 discussion confirms that electronic hobbing remains in active practical use and that modern Mesa-based systems commonly compute the relationship from already-decoded encoder position rather than relying on the older `encoder_ratio` component.

A December 2025 / January 2026 discussion of a standalone rotary table for hobbing reinforces the durable concept: an encoder on the machine spindle can electronically gear a driven dividing head/table to the hob spindle. Spur hobbing is the simple case; helical gears, hob shifting and tangential worm hobbing add feed-axis coupling to the synchronization problem.

Key topics:

- spindle/blank electronic gear ratio;
- encoder position versus raw quadrature counting;
- phase/reference relationship and restart behavior;
- tooth count, hob starts and direction;
- helical gear lead contribution from axial feed;
- hob angle and machine geometry;
- backlash/compliance in the blank drive;
- loss of spindle encoder or drive following state;
- whether the gear blank is exposed as a normal coordinate or remains a process-slave axis invisible to G-code;
- custom HAL component versus composed HAL math;
- machine-specific UI for entering gear parameters instead of forcing the operator to edit HAL.

Related machines include gear shaping, spline generation, spring winding, coil winding with traversing guide, electronic lead-screw functions and synchronized rotary engraving or indexing processes.

The useful control contract is:

`master measured phase/position -> ratio/phase transform -> slave command -> phase error supervision`

not merely `command two axes at once`.

Promotion status: strong 3900 subtrack. Do not create a permanent new 3000 number until a deep pass finds multiple complete modern configs covering hobbing plus at least one second gear-generation process or a clearly reusable electronic-gearing architecture.

## 3900-F — hot-wire foam cutters and dual-end geometry

A conventional 4-axis foam cutter often has two independently moving wire endpoints, commonly represented as X/Y and U/V. The physical tool is the hot wire segment between those endpoints. The geometry and process therefore cannot always be understood as a single TCP moving through space.

Real LinuxCNC users run XYUV foam machines, including current 2024-2026 configurations. One 2024 build published HAL/INI/PyVCP material and added controlled wire power. Another large 4-axis machine discussed in 2024-2026 raised a fifth-axis-like issue: wire length/tension changes as the endpoints move.

Key topics:

- XYUV endpoint representation;
- wire length and tension compensation;
- thermal wire power control;
- kerf/melt-zone compensation;
- constant cutting speed and its effect on kerf;
- tapered parts where left/right profiles differ;
- CAM responsibility for dual-profile geometry;
- why ordinary G41/G42 cutter compensation only applying to one plane is insufficient for many foam jobs;
- optional rotary/indexing additions for foam lathes or multi-sided work;
- wire-break and over-temperature state;
- keeping both wire endpoints within travel while preserving desired section geometry.

A useful architecture rule is:

`left endpoint path + right endpoint path + thermal process state -> physical wire cut`

The curriculum should not pretend there is always one meaningful Cartesian tool center point.

Promotion status: remain in 3900. The community evidence is real and durable, but the control problem is bounded and currently does not justify a full independent top-level specialization.

## 3900-A — additive manufacturing and hybrid machines

This is the strongest promotion candidate. LinuxCNC has a dedicated Additive Manufacturing forum category with dozens of topics covering FFF/FDM, SLA/SLS concepts, large/delta printers, multiple extruders, heater control, galvo interfaces and 5-axis printing. Activity continued into 2026, including a large EtherCAT delta printer project and an open-source SLS discussion.

LinuxCNC has been used successfully for 3D printing, but the community repeatedly identifies an architectural issue: representing the extruder as an additional coordinated axis can degrade trajectory lookahead. Community advice has sometimes mapped the extruder to Z and physical height to another coordinate because XYZ receives the full trajectory-planner treatment while moves involving extra rotary/UVW coordinates may fall back to more limited lookahead behavior. This must be verified against the current pinned LinuxCNC revision before teaching a final architecture.

Separate these layers:

1. **geometric motion** — Cartesian, delta or custom kinematics;
2. **material-flow command** — filament/paste/pellet/other extrusion rate;
3. **thermal state** — hotend, bed, chamber, material temperature;
4. **process auxiliaries** — fans, purge/wipe, tool/extruder change, chamber controls;
5. **slicer/post boundary** — how conventional printer G-code concepts map into LinuxCNC;
6. **fault/recovery** — thermal fault, material runout, extrusion fault, paused layer, power recovery.

LinuxCNC primitives worth studying include PWM + PID for heater control, analog/ADC temperature acquisition, custom M-codes/remap for printer-style commands, spindle/analog-output alternatives for material flow, trajectory-planner behavior with an extrusion coordinate, delta/custom kinematics from 3500 and QtVCP/custom UI for temperatures/material/print state.

Non-planar / multi-axis additive should be a specific research branch because it stresses nozzle orientation, collision, extrusion synchronized to path length, surface-following layers, tool-frame planning and CAM/slicer capability. Hybrid additive/subtractive should remain a study topic rather than a build requirement, with attention to mode ownership, coordinate-frame consistency, tool/extruder identity and recovery between process phases.

Promotion recommendation: additive manufacturing is already large enough to be a serious candidate for a permanent numbered 3000 track during the next curriculum restructure. Before promotion, require at least one complete real LinuxCNC FFF/FDM implementation, current-source verification of trajectory/extruder behavior, heater/temperature fault ownership, one delta or non-Cartesian printer, one multi-axis/non-planar or hybrid reference and slicer/postprocessing comparison.

## 3900-T — tube / pipe bending and forming machines

LinuxCNC has multiple tube-bender discussions and at least one strong field retrofit: a large BLM C88 hydraulic pipe bender. That machine combined two servo axes with a massive hydraulic proportional bender axis and many hydraulic actuators/sensors. The implementation used G-code/O-code routines plus custom HAL components, with sequencing critical because incorrect actuator order could physically damage the machine.

Earlier community work also produced a tube-bender simulator and table-oriented GUI concept. The proposed operator model was not conventional CAM G-code entry; it was rows of manufacturing values that the UI translated into motion/MDI or generated G-code.

A rotary-draw/3D tube bender is naturally described with values such as:

- feed/advance length;
- tube rotation/plane angle;
- bend angle;
- bend radius/tooling selection;
- left/right bend mode where supported;
- mandrel state;
- clamp die state;
- pressure die state;
- collet/chuck state;
- proportional hydraulic bend command/feedback;
- springback compensation.

This is a useful example of an important 3900 principle: **the best operator program does not have to look like XYZ G-code.** LinuxCNC can remain the deterministic machine-control engine while a purpose-built GUI/table/filter converts process intent into motion and machine-state commands.

Key deep topics:

- sequence/interlocks among powerful hydraulic actuators;
- servo feed + tube rotation + bend-axis coordination;
- proportional valve closed-loop control;
- springback compensation;
- tooling/setup data;
- part program represented as a bend table;
- teach/manual entry versus generated program;
- collision/feasibility checks;
- recovery from abort with clamps/mandrel/bend arm in partial state.

Tube bending deliberately reuses 3600 proportional hydraulics/forming knowledge, 3800 material-flow/sequencing/recovery and 3500 custom geometry where unusual bender mechanisms demand it.

## 3900-W — wire/spring winding and forming

This branch currently has less LinuxCNC-specific evidence than hobbing or additive, so it should remain exploratory.

Potential machine classes include spring winders, transformer/coil winders, cable winding/laying and simple 2D/3D wire-forming machines.

Recurring concepts likely include master spindle angle/revolution count, synchronized traverse pitch, wire feed/tension, programmable pitch changes, cut/end operations, material length and part count, and process-specific tooling state.

The gear-hobbing/electronic-gearing work may supply the core synchronization model, while 3800 supplies material-flow ownership. Do not invent a final architecture until a real inspectable LinuxCNC implementation is found.

## 3900-O — useful oddities, not yet branches

### Embroidery / sewing

A LinuxCNC-converted sewing machine used XY motion plus a needle-up digital signal and a custom G-code generation workflow. It demonstrates that LinuxCNC can coordinate a nontraditional cyclic process and that the UI/program can be shaped around stitch data rather than machining vocabulary.

### Multi-spindle carving / specialty routing

Users have deployed LinuxCNC on machines with many independent step generators/spindles. These examples are useful for hardware scale and UI lessons but should normally remain under 3400/3800 unless the process itself is distinct.

### Laboratory and one-off research machines

Keep as evidence of extensibility, not curriculum scope by default.

## Cross-cutting abstraction-selection skill

3900 should explicitly teach how to decide which LinuxCNC abstraction fits an unusual mechanism.

### Ordinary coordinated coordinate

Use when the mechanism participates directly in the geometric path and should be commanded by the trajectory planner.

### Process-slave / electronic gearing

Use when motion is determined primarily by measured phase/ratio to another mechanism rather than independent path geometry.

### Extra joint / independent bounded motion

Use for auxiliary positioning not part of kinematics, subject to the single-planner and independent-motion limitations studied in 3800.

### HAL realtime process loop

Use for tight feedback, synchronization, phase correction or simple process mechanisms that should not be expressed as G-code path geometry.

### State machine / ClassicLadder / custom component

Use where sequence, interlocks and partial-cycle recovery dominate.

### Purpose-built UI / input filter / external application

Use when the operator's natural program is a gear recipe, bend table, stitch file, slicer output or other domain representation rather than handwritten G-code.

This abstraction-selection skill is the main transferable value of 3900.

## Promotion rule for a new numbered machine track

A 3900 topic should be promoted only when all of these are true:

1. there are multiple real LinuxCNC implementations or sustained community activity;
2. the machine class has control problems not already adequately taught elsewhere;
3. enough source/config/build evidence exists to teach implementation rather than speculation;
4. there is a meaningful operator/CAM/process workflow distinct from ordinary CNC;
5. the branch contains enough depth for multiple lessons without padding or duplicate material.

Current ranking:

- **Additive manufacturing:** strongest promotion candidate.
- **Gear generation/electronic gearing:** strong 3900 subtrack; possible future promotion.
- **Tube/pipe forming:** strong applied subtrack, especially because of real hydraulic field evidence.
- **Foam cutting:** mature bounded subtrack, likely stays in 3900.
- **Wire/spring winding:** discovery phase; needs better real implementation evidence.
- **Embroidery and other oddities:** case studies only for now.

## Recommended deep-work sequence

### 3900-G1 — electronic gearing / hobbing

Trace the current-source-compatible version of the established LinuxCNC hobbing architecture, including spindle encoder -> ratio/phase transform -> blank command. Compare with at least one independent hobber. Resolve helical/hob-shift feed coupling and restart/phase-reference behavior.

### 3900-A1 — additive architecture

Deep-read one complete real LinuxCNC printer config and current motion source. Resolve extrusion-coordinate planning, temperature control, pause/recovery and slicer/post mapping. Include the current 2026 delta project as contemporary evidence but do not treat an unfinished machine as canonical.

### 3900-T1 — BLM C88 tube bender

Trace the real field retrofit deeply: axes, proportional hydraulic bend loop, custom HAL, O-code, clamp/mandrel sequence and recovery. Compare against the earlier table-driven simulator/UI concept.

### 3900-F1 — foam cutter

Trace a real XYUV LinuxCNC configuration with wire power plus the recent large-machine wire-tension/length issue. Establish CAM-versus-controller ownership for kerf and dual-profile geometry.

### 3900-W1 — winding discovery

Search targeted real LinuxCNC spring/coil/wire winding implementations. If evidence remains thin, checkpoint an information-gain stop instead of fabricating a synthetic course.

## Candidate bounded experiments

Run only when source/field evidence leaves a real uncertainty:

- hobbing electronic-ratio phase-loss/restart simulation;
- helical hobbing ratio plus axial-feed coupling check;
- XYUV foam geometry with changing wire length/tension;
- current LinuxCNC planner comparison for XYZ-only versus XYZ+extrusion-coordinate additive motion;
- heater PID/process-fault simulation;
- tube-bender abort/recovery state model with clamp/mandrel/bend axis;
- table-driven bend program -> generated G-code proof;
- simple synchronized winding/traverse model if a real reference implementation first establishes the architecture.

Do not build production machines as curriculum requirements.

## Breadth verdict

3900 is valuable precisely because it is not a single machine family. Its enduring subject is **how to map unusual physical processes onto LinuxCNC's motion, HAL, sequence and UI abstractions without forcing every machine to pretend it is a mill**.

The branch with the highest immediate unique information gain is **electronic gearing/gear hobbing**, while **additive manufacturing is the strongest candidate for eventual promotion into its own permanent 3000-level specialization**.