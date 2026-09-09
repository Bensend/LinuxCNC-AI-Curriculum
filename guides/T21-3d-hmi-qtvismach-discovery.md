# T21 — 3D HMI, QtVismach and live machine visualization

Status: **PLANNED / 2000-level topic added 2026-09-09**

## Why this belongs in the 2000 series

The 1000-level T04/T05 work established the control-side HMI boundary: a GUI can remain responsive while controller state is stale, command acknowledgement is not machine-state truth, startup ordering matters, and UI behavior must not be treated as functional safety. The 2000-level follow-on should apply those rules to a richer operator interface that contains a moving 3D machine model.

The objective is not merely to render an attractive animation. The learner must be able to design a custom LinuxCNC HMI where a 3D model follows selected machine-state signals while retaining explicit provenance, freshness and authority boundaries.

## Existing LinuxCNC precedents discovered

### Official QtVismach support

LinuxCNC's current QtVismach documentation describes a Python/OpenGL machine-model library that can be embedded in QtVCP screens. Model parts can be created from primitives or imported from ASCII STL/OBJ geometry. `HalTranslate` and `HalRotate` can animate parts from HAL values, including existing system pins such as `joint.N.pos-fb` when the model reads system HAL directly.

Relevant documentation:

- https://www.linuxcnc.org/docs/stable/html/gui/qtvcp-vismach.html
- https://www.linuxcnc.org/docs/html/gui/qtvcp-libraries.html
- https://www.linuxcnc.org/docs/stable/html/gui/vismach.html

The QtVCP library documentation also lists supplied Vismach examples such as XYZ mill, SCARA, mill-turn and 5-axis gantry models. These establish that live multi-joint 3D visualization is an intended LinuxCNC use case rather than an external graphics hack.

### Press-brake-specific precedent

A LinuxCNC forum press-brake project developed a fairly complete simulated press-brake configuration. The discussion describes a bend-sequence table, a press state machine, ram motion through rapid/start/bend/finish phases, and a Vismach bender that follows the sequence. Later work discussed backstop motion and operator-sequence behavior.

Reference:

- https://forum.linuxcnc.org/30-cnc-machines/42100-pressbrake-cnc-control-setup-questions?start=10

This is especially useful as a case study because it demonstrates that LinuxCNC users have already coupled a press-specific HMI/state machine with a moving press-brake model rather than limiting Vismach to conventional mills.

### Embedding a press-brake model in QtDragon

A separate QtVCP/QtDragon discussion shows a user embedding a press-brake Vismach window into a custom QtDragon layout. The handler imports the press-brake model, constructs its window and adds it to a Qt layout. This demonstrates a practical path from a stock LinuxCNC screen to an integrated custom HMI rather than requiring a separate visualization process.

Reference:

- https://forum.linuxcnc.org/qtvcp/45274-qtdragon-simple-vismach-window

## T21 learning objectives

T21 should cover at least the following.

1. **QtVCP/QtVismach architecture** — locate the model/window/handler paths and document how an embedded 3D viewport is hosted inside a custom QtVCP screen.
2. **HAL-driven model motion** — trace how `HalTranslate`/`HalRotate` obtain values and how those values relate to `joint.*.pos-fb`, commanded position and other possible state sources.
3. **CAD-to-HMI workflow** — import STL/OBJ machine geometry, choose pivots/origins correctly and build a hierarchical moving assembly.
4. **Multi-joint visualization** — display independent actuators independently rather than hiding disagreement behind one Cartesian coordinate. A tandem/gantry example should expose each joint separately.
5. **Backgauge/tooling visualization** — represent rigid auxiliary axes, fingers, punch/die or tool state where useful without implying more authority than the source data supports.
6. **Freshness and provenance** — distinguish renderer frame rate, GUI polling rate, HAL observation freshness, controller state and physical truth. A smooth animation must never be accepted as evidence that feedback is current.
7. **Failure visualization** — define behavior for stale data, disconnected status, communication faults, homing loss and disagreeing redundant feedback. The display should visibly enter an unknown/stale state rather than silently freezing in a plausible pose.
8. **Diagnostic scaling/exaggeration** — investigate deliberately magnifying small tandem-joint disagreement for diagnostics, with an unmistakable indication that the geometry is exaggerated rather than literal.
9. **Performance/perturbation** — measure whether the visualization or its data-acquisition path perturbs UI responsiveness, Task/NML observation or recorder behavior. It must remain outside the realtime control loop.
10. **Authority boundary** — prove that the 3D model is an operator-information surface, not a safety channel, interlock, encoder substitute, collision guarantee or proof of physical actuator state.

## Rigid visualization versus workpiece deformation

QtVismach is well suited to rigid-body machine parts driven by transforms. A realistically bending sheet is a different problem.

T21 should therefore separate:

- rigid machine/tool/backgauge motion that can be represented directly with transforms;
- schematic workpiece-state visualization that changes geometry according to an explicit bend model;
- true deformation/collision/FEA-like simulation, which may require a different graphics/physics approach and should not be assumed to be supplied by QtVismach.

The module should investigate how the historical press-brake examples represented the workpiece and determine whether a lightweight bend-geometry generator is adequate for an operator HMI. High-fidelity material deformation or validated collision prediction may become a later specialized/3000-level candidate only if evidence shows it is actually needed.

## Proposed laboratory work

A useful frozen experiment should use a generic tandem-axis machine model rather than proprietary machine geometry.

- Embed a QtVismach viewport inside a minimal QtVCP screen.
- Animate two nominally coupled joints independently from HAL feedback.
- Animate at least one auxiliary rigid axis.
- Record model-input timestamps/state alongside the displayed state.
- Inject normal motion, controlled joint disagreement, a frozen/stale input, status loss and recovery.
- Verify that disagreement can be shown independently, stale/unknown state is not rendered as silently-valid truth, and GUI/3D update work does not become part of realtime control authority.
- If diagnostic exaggeration is implemented, prove that it is visually labelled and does not alter the numeric machine-state display.

## Graduation traps

T21 must reject at least these claims:

- "The model is moving, therefore feedback is fresh."
- "The two rendered sides line up, therefore physical geometry is synchronized."
- "QtVismach reads HAL, therefore it is realtime control logic."
- "A collision-free rendering proves the physical machine cannot collide."
- "A frozen but plausible 3D pose is acceptable during loss of state freshness."
- "A schematic sheet bend is equivalent to validated material-deformation simulation."

## Dependency intent

T21 should follow **T20 — UI/Task/NML freshness and ownership under stress**, and should consume **X02 synchronized multi-surface diagnostics** findings where useful. T21 is not a prerequisite for F02 compound-fault sequencing, but it is part of completing the advanced HMI branch of the 2000 series.
