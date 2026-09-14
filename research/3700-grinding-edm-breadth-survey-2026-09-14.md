# 3700 — Grinding / EDM breadth survey

Date: 2026-09-14
Status: RESEARCH / initial breadth rotation
Pinned LinuxCNC revision for source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Why 3700 was selected

3500 reached a clean breadth/source stop after the ZA6 ROS2/HAL authority trace, PUMA 200 field chronology, and genserkins failure reconciliation. Under the work-selection policy, 3700 is substantially less developed and has direct cross-machine value in adaptive motion, process feedback, legacy retrofits, synchronized motion and recovery.

The first survey shows that **Grinding and EDM must not be treated as one process family** merely because they share a curriculum number. Their LinuxCNC control problems differ materially.

## 3700-G — Grinding initial evidence

### Surface grinders

A Parker Majestic 6x18 CNC surface grinder retrofit thread exposes a conventional three-axis servo retrofit problem with a process-specific precision twist. The machine had X/Y ballscrews, a Z screw through worm reduction, and a linear encoder that the owner considered relocating to Z for LinuxCNC closed-loop feedback. Community discussion immediately raised feedback-topology questions because backlash/compliance in the worm train can interact with a linear-scale outer loop and following-error behavior.

This supports a grinding architecture split between:

- axis actuator/rotary feedback;
- direct linear position feedback where present;
- mechanical compliance/backlash between them;
- wheel spindle/process authority;
- grinding-specific cycle/recipe logic.

Do not assume that adding a linear scale to a mechanically compliant Z chain automatically improves control without an explicit loop/topology design.

### Hydraulic surface grinders

A separate community retrofit describes a legacy surface grinder with hydraulic X/Y/Z motion and linear scales, where directional hydraulic valves rather than normal servo drives are the actuator authority. This is a materially different implementation class from a ballscrew servo grinder and should be investigated separately rather than forced into a step/dir abstraction.

### Camshaft grinding

A 2025–2026 DIY LinuxCNC camshaft-grinder project uses a rotary A axis with encoder for the camshaft, a Y axis toward the grinding wheel, and X for axial cam selection/traverse. Community advice was to first validate ordinary XYZ/rotary behavior and simple cylindrical grinding before attempting cam profiles.

This creates a later 3700-G2 source target: determine whether real LinuxCNC cam grinding is implemented as coordinated XY/A path generation, electronic-cam style kinematics, precomputed profile motion, or another architecture. No implementation contract is frozen yet.

## 3700-E — EDM initial evidence

### LinuxCNC has an upstream adaptive-motion primitive explicitly relevant to EDM

Pinned LinuxCNC source/documentation exposes `motion.adaptive-feed`. With `M52 P1` active, this HAL input multiplicatively scales commanded feed. At LinuxCNC 2.9+, negative adaptive feed can run the G-code path in reverse.

Upstream canonical interface comments also explicitly describe adaptive feed as useful for EDM.

This is important but bounded:

> LinuxCNC provides a native adaptive path-speed/reverse primitive that can support EDM gap control; it does **not** by itself implement an EDM spark-gap controller, pulse generator, dielectric system, wire system, or process-safety state machine.

### Real Sodick wire-EDM retrofit chronology

A public LinuxCNC retrofit of a Sodick A320s gives strong field evidence.

By March 2020 the owner had:

- X/Y and U/V axes moving;
- wire run and tension working using original hardware;
- speed/tension adjustability;
- `motion.spindle-enable` repurposed to command wire run.

The hard problem was the spark source. The original generator's undocumented complexity led the owner to abandon it and build a replacement pulse generator. By July 2020 it had made test cuts in steel up to 30 mm, but remained slow and not production-ready.

The owner then began adaptive spark-gap work using gap voltage to modify feed. Community guidance specifically suggested LinuxCNC external offsets/reverse run/adaptive behavior and a THCAD-style voltage measurement path; another referenced retrofit reportedly used measured gap voltage simply to stop feed below a threshold rather than reverse run.

### Wire EDM exposes multiple process authorities beyond XY motion

The same thread identified:

- XYZ plus U/V for taper/head-angle control;
- wire tension sensor;
- wire-spool/tension motor;
- voltage/current and tank ionization/conductivity-related sensing;
- material-specific machining-condition tables;
- spark voltage selection;
- pulse frequency/on-time/off-time/current parameters;
- gap-voltage adaptive feed;
- OEM ballscrew compensation provenance.

This is fundamentally richer than modeling EDM as "a mill with a different spindle."

## Cross-process asymmetry

### Grinding

Current public evidence suggests LinuxCNC often supplies general motion/servo/feedback infrastructure while grinding cycle/process logic remains machine-specific. High-value gaps include:

- wheel spindle ready/fault and dressing authority;
- wheel wear/radius compensation and dress accounting;
- infeed/spark-out cycles;
- hydraulic versus servo reciprocation;
- direct-scale feedback topology;
- cam/nonround grinding synchronization.

### EDM

LinuxCNC has a particularly relevant generic primitive—adaptive feed including reverse path—but no dedicated upstream wire/sinker EDM process controller was found in this bounded pass. Real retrofits assemble custom process logic around motion, voltage sensing, wire/pump/tank hardware and spark-generation authority.

Wire EDM and sinker EDM must remain separate subbranches. A sinker may have fundamentally different axis/orbit and flushing/electrode logic from a wire machine with U/V taper, tension, threading and break detection.

## Initial playbook boundaries

Preserve these independent witnesses/authorities for EDM:

`path command -> gap/process feedback -> adaptive-feed/retract authority -> spark generator command/state -> dielectric/flushing readiness -> wire/electrode state -> axis motion -> fault/recovery`

For grinding, preserve at least:

`cycle/profile command -> wheel/process readiness -> axis/feedback topology -> infeed/reciprocation -> dressing/wear authority -> spark-out/completion -> fault/recovery`

Neither chain is yet a frozen production state machine.

## Adversarial review

1. Does `motion.adaptive-feed` make LinuxCNC a complete EDM controller? **No.**
2. Does negative adaptive feed prove every EDM retrofit should reverse along the path? **No; one referenced field implementation instead stopped below a voltage threshold.**
3. Is wire run equivalent to spark enable? **No; the Sodick retrofit treated wire motion and spark generator as separate systems.**
4. Can OEM machining tables be treated as generic recipes? **No; they are machine/generator/material-specific provenance.**
5. Is a surface grinder necessarily a normal XYZ servo machine? **No; public examples include both ballscrew servo and hydraulic directional-valve architectures.**
6. Does a direct linear scale remove backlash/compliance concerns? **No; it changes the feedback topology and can expose mechanical dynamics.**
7. Does cam grinding already have an evidence-backed LinuxCNC architecture from this pass? **No; only a real project direction is established so far.**
8. Can wire and sinker EDM be collapsed into one process state machine? **No.**

Adversarial result: **8/8 bounded claims survive.**

## Next work

1. **3700-E1 — EDM adaptive-motion source trace:** trace exact M52/adaptive-feed behavior through interpreter/canonical/task/motion, including negative feed, zero crossing, feed hold/inhibit interaction, path reversal limits and behavior around queued I/O. Then inspect the later pages of the Sodick retrofit and any downloadable HAL/config it references.
2. **3700-E2 — process authority:** hunt inspectable wire-EDM configs for gap voltage conditioning, feed/retract law, wire tension/break, dielectric readiness, spark enable, pause/abort/recovery and U/V taper.
3. **3700-G1 — surface grinding:** find at least two real LinuxCNC grinder implementations with configs/build chronology, preferably one servo/linear-scale and one hydraulic, then map wheel/dress/infeed/spark-out authority.
4. **3700-G2 — nonround/cam:** only after basic grinding control is grounded, trace actual synchronized/profile generation.
5. No lab yet. Source/build-diary evidence has much higher information gain.
