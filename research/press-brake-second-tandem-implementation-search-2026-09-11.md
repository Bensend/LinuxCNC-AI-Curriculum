# Second independent tandem press-brake implementation — bounded search

Date: 2026-09-11
Status: **BOUNDED SEARCH / NO SECOND MATURE SOURCE LOCATED YET**

## Purpose

After closing the Ursviken final-config search as source-unavailable, search for a second independent LinuxCNC press-brake implementation with two physical ram feedback channels. This is intentionally separate from generic dual-motor gantry examples because the hydraulic press-brake ownership/fault problem is different.

## Search surfaces

Searched LinuxCNC forum material for combinations of:

- press brake + Y1/Y2;
- press brake + dual / left-right PID;
- press brake + glass scales;
- hydraulic press brake + two linear feedback channels;
- press brake + dual servo valve.

## Candidate 1 — 2018 `Hydraulic press brake control`

Thread:
https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control

The machine owner describes two hydraulic cylinders, a linear glass scale on each side, and two stepper-driven spool valves intended to raise/lower and synchronize the cylinders. The proposed control concept adjusts each valve based on left/right glass-scale position.

A community contributor posted an inline `pressbrake` component skeleton exposing:

- `Left_glas_encoder_pos_fb`;
- `Right_glas_encoder_pos_fb`;
- left/right stepper feedback;
- left/right stepper command outputs;
- oil-pressure input;
- E-stop/light-curtain/safety-door named inputs.

However, as already audited in the curriculum, the shown component's executable state machine is only an `INIT/SELECT` skeleton. It does **not** implement the claimed left/right synchronization, sequencing or safety behavior.

The thread later discusses how one lagging cylinder's stepper valve could be adjusted to compensate, but that is a design proposal rather than retained executable evidence.

**Classification:** COMMUNITY DESIGN INTENT + SOURCE SKELETON. Not a second mature tandem implementation.

## Candidate 2 — 2022 Accurpress field project

Thread:
https://forum.linuxcnc.org/show-your-stuff/45716-vertical-press-brake-interface-and-comp

This is a valuable real field implementation and its author reports that an early monolithic ram state-machine design was jerky, leading to a later design that used LinuxCNC MOTION for the ram and backgauge axes. The project is already useful to the 4600 architecture-evolution study.

But the described ram is a single servo axis with one Vickers proportional valve and glass-scale feedback. It is not a tandem Y1/Y2 system with two independently controlled ram sides.

**Classification:** FIELD IMPLEMENTATION, but **not tandem evidence**.

## Excluded search hits

Generic dual-drive gantry/router/plasma threads with Y1/Y2 or tandem Z were not promoted into press-brake evidence. They can teach LinuxCNC duplicated-joint/homing mechanics, but they do not establish hydraulic side synchronization, differential authority, pressure sequencing or press-specific failure behavior.

## Result

The bounded search did **not** locate a second mature public tandem press-brake configuration with inspectable final HAL/COMP/source.

Current tandem evidence hierarchy is therefore:

1. **Ursviken Pullmax Optima 2026:** strongest physical tandem field report; builder reports two side position PIDs plus Y1−Y2 sync PID and a successful steel bend, but final config not public in the current thread.
2. **2018 hydraulic press-brake thread:** genuine two-scale/two-valve concept plus an inline source skeleton, but no retained mature synchronization implementation in the inspected material.
3. **Accurpress:** mature public field/config evolution, valuable for press-cycle/motion/timing/pressure lessons, but single-ram and therefore not evidence for differential Y1/Y2 authority.

## Curriculum decision

Do not spend repeated hourly lessons re-running equivalent keyword searches. The second-source requirement remains open, but it is no longer the only useful 4600 task.

Until another tandem implementation appears, advance the track using evidence that is actually available:

- formalize the ownership/failure requirements learned from the Ursviken field report without inventing its hidden HAL;
- compare the Accurpress architecture evolution against LinuxCNC source semantics;
- study press-cycle, backgauge, bend-program, DXF and HMI workflows from multiple independent projects;
- retain tandem correction insertion/final-authority topology as an explicit source-availability uncertainty.

## Exact next checkpoint

Move to the next unblocked 4600 topic with high information gain rather than another identical source search. Recommended next topic: **press-cycle state sequencing and failure/timeout behavior** across the Accurpress, Ursviken and 2018 designs, with a source-grounded distinction between semantic cycle state, realtime motion ownership and hydraulic decoding. Revisit tandem-source discovery only when new links, attachments or repositories surface.
