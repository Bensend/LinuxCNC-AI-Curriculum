# 3100 VMC ATC field chronology — first pass

Date: 2026-09-14
Status: **FIELD PASS ADVANCED — TWO DIFFERENT VMC TOOLCHANGE ARCHITECTURES PRESERVED**

## Purpose

Start the real-machine side of 3100 immediately after the source/documentation breadth foundation. Preserve design evolution and commissioning problems rather than treating a final ATC recipe as universal.

## Case A — EMCO VMC100, spindle-driven carousel

A 2025–2026 LinuxCNC build thread documents an unusual but highly instructive VMC100 ATC where the **main spindle mechanically drives the tool carousel**.

### Initial physical contract

The builder reports four proximity functions:

- tool-1/reference witness;
- gear/slot counting witness;
- tool engaged witness;
- tool disengaged / carousel-drive-coupled witness.

The carousel begins its exchange motion above the normal Z reference region. The spindle drive already had encoder feedback and was also expected to support synchronized tapping/orientation.

This architecture is important because one actuator — the main spindle drive — has two very different authorities:

1. normal machining spindle velocity/phase/orientation;
2. carousel motion during toolchange.

That makes **mode/authority transfer** a central design problem rather than a cosmetic HAL detail.

### Early failed direction

The builder initially tried to use repeated M19 orientation operations to obtain carousel motion and reported that this approach was poor for the mechanism. Community discussion suggested instead keeping the spindle in velocity mode and using `carousel.comp` to treat the spindle as the carousel motor while the toolchanger is mechanically coupled.

The builder also considered a hardware relay approach switching the Mesa step/dir source between spindle velocity and a separate position-mode step generator. This records a genuine architecture fork:

- physical signal-source switching;
- versus HAL/software authority switching around a common drive.

### Working intermediate architecture

By 28 Aug 2025 the builder reported:

- `carousel.comp` homing/counting correctly;
- M6 remap coordinating sensors through M64/M65/M66;
- spindle orientation before Z lifts into the carousel gear to avoid collision;
- an AND gate enabling carousel motion only when the hardware disengaged/coupled sensor is true;
- the same full-servo spindle remaining capable of synchronization/orientation.

Later the same day bidirectional carousel motion was working on a bench setup by selecting signed carousel velocity before switching it into the spindle-drive command path.

This is strong field evidence for the architecture:

`machining spindle authority`

`-> stop/orient`

`-> prove mechanical disengage/coupling state`

`-> transfer drive-command authority to carousel logic`

`-> index carousel using physical slot/reference witnesses`

`-> return drive-command authority to spindle machining logic`.

### Commissioning failures / corrections

The chronology preserves several useful failures:

- spindle HAL attempts were deleted by the builder as bad examples;
- bidirectional velocity sign handling initially required correction;
- proximity inputs showed noise/spikes;
- later M6/NGC attempts were also removed as bad files;
- community guidance clarified that carousel `strobe` is a **feedback-valid/alignment witness**, not merely another arbitrary position input.

The builder had already added debounce but was still debugging sequence logic. Therefore this case is valuable precisely because it is **not** a clean final canonical config.

### Durable lessons

- One physical drive can have multiple operational roles, but command authority must be mutually exclusive and explicitly transferred.
- Spindle orientation can be a prerequisite for mechanical coupling without being the carousel-position controller itself.
- `carousel.ready` or slot count cannot replace the physical engaged/disengaged/coupling sensor.
- Sensor debounce does not repair an incorrect state machine.
- A remapped M6 using M64/M65/M66 can coordinate the sequence, but each signal must retain its real physical meaning.

## Case B — OKADA VM500, conventional twenty-pocket carousel with Z motion

A 2018 field thread documents a large mid-1980s OKADA VM500 retrofit with a 20-position carousel ATC. The builder had all toolchanger I/O wired and could manually walk the physical sequence through Axis/Glade, but needed automatic M6 integration that moved Z during the exchange.

Community guidance drew an important responsibility boundary:

- ClassicLadder alone did not provide the convenient coordinated axis-motion ownership required for the Z moves;
- a remapped M6 / G-code subroutine is the natural place to sequence coordinated machine-axis moves;
- `carousel.comp` can own magazine indexing;
- the supplied `sim/axis/vismach/vmc_toolchange` example demonstrates this split.

This is materially different from the EMCO case:

- OKADA: carousel has its own mechanism and Z must join the toolchange trajectory;
- EMCO: spindle itself is temporarily repurposed as carousel drive.

The common reusable architecture is therefore not a fixed sequence but an **ownership split**:

`M6/remap = transaction/orchestration + coordinated axis moves`

`carousel/component or mechanism logic = magazine position`

`HAL/field I/O = physical witnesses and actuators`

`iocontrol/Task = logical toolchange request/ack boundary`.

## Case C — EMCO VMC300 corroborating topology

A 2023 VMC300 retrofit thread describes another spindle-driven carousel architecture:

1. spindle stops and orients to align drive dogs;
2. Z/head rises beyond the ordinary operating soft-limit region while mechanics grip/release the tool;
3. at the top, the spindle shaft engages gearing that drives the carousel;
4. proximity switches provide slow-down/final-position/reference information;
5. after positioning, Z/head lowers, mechanical coupling disengages and the spindle clamps the tool.

A later participant reported an existing LinuxCNC VMC200 conversion with working spindle orientation, synchronized tapping and toolchanger, supporting the feasibility of the overall architecture while not publishing enough source in the inspected page to make it canonical.

The thread also records a successful pattern for temporarily changing the effective Z soft limit through INI HAL pins during the toolchange subroutine, and notes that toolchange is a queue-buster, which matters when reasoning about interpreter look-ahead around the temporary state change.

## Cross-case authority map

### Spindle subsystem

Separate:

- speed command;
- speed-ready;
- encoder phase/index;
- M19 orient request/ack/fault/locked;
- temporary carousel-drive command authority where applicable.

### Magazine subsystem

Separate:

- requested pocket;
- homed/reference state;
- slot/position feedback;
- feedback-valid/strobe state;
- magazine motor command;
- physical coupling/clearance state.

### Tool-transfer subsystem

Separate:

- drawbar/clamp request;
- released/clamped physical proof where available;
- arm/pot/gripper position;
- Z/toolchange position;
- tool physically present;
- logical tool identity acknowledgement.

## First field adversarial review

1. **The spindle encoder identifies the carousel pocket on the EMCO.** Not by itself; slot/reference sensors remain authoritative for actual carousel position/alignment.
2. **M19 should be stretched into repeated multi-turn carousel positioning.** Field chronology shows this was an awkward/failed direction; separate carousel motion authority is cleaner.
3. **Once `carousel.comp` counts the desired slot, Z may always descend.** No; physical coupling/disengage/tool-transfer witnesses remain required.
4. **Debouncing the prox sensors guarantees a correct exchange.** No; it improves signal conditioning but not sequence correctness.
5. **ClassicLadder is the only correct owner for an ATC.** No; a real VM500 case specifically benefits from remapped G-code for coordinated Z motion plus carousel mechanism logic.
6. **Temporarily widening a soft limit means the physical toolchange zone is automatically safe.** No; that only changes software travel permission. Collision/mechanism witnesses remain machine-specific.
7. **A common VMC playbook should prescribe one exact ATC sequence.** No; the EMCO spindle-driven carousel and OKADA independent carousel have materially different actuator ownership.
8. **Toolchange success should be inferred from commanded motions.** No; physical mechanism witnesses and logical tool identity must be reconciled.

Result: **8/8 field-boundary review passed.**

## Next evidence target

Find/download at least one complete inspectable VMC ATC config with its remap/HAL/component files so the curriculum can trace exact logical-tool update timing, abort/restart behavior and physical acknowledgement. Prefer a configuration with drawbar/tool-present or arm/pot feedback rather than a timer-only transfer.

Then move into 3100 probing/tool-setting and spindle/lube/coolant readiness rather than over-focusing on ATCs.
