# 3800 Saws, Feeders, Indexing and Automation Cells — breadth audit

Date: 2026-09-14
Status: **BREADTH / TRACK-MAP PASS COMPLETE**

Pinned LinuxCNC source revision for source-level curriculum claims remains `f666f1a51ae7c4d991cc61233e785dcc53fbe98d` unless explicitly marked as current community evidence.

## Purpose

Audit the 3800 specialization before deep work. This track covers machines and cells where the main engineering problem is not complex interpolation but **reliable sequencing of stock, clamps, stops, indexers, transfer mechanisms, sensors and repeated production cycles**.

The central question is not simply whether LinuxCNC can move a saw head or feeder. It is whether the control can preserve workpiece identity, mechanism state, product recipe, sensor evidence and recovery authority across many repetitive automatic cycles.

## Breadth conclusion

3800 naturally divides into five related control classes:

1. **Automatic saws / cut-to-length machines** — stock feed, clamp handoff, blade/process state, piece count, cut-list execution and remnant handling.
2. **Stock feeders / positioning stops / bar feeders** — push, shuttle, gripper or powered-roll mechanisms that advance material between machining or cutting operations.
3. **Indexing machines** — rotary tables, turrets, Geneva/index wheels, dial tables and discrete positioners that must unlock, move, prove position and relock before process motion resumes.
4. **Transfer mechanisms / multi-station machines** — linear or rotary station-to-station movement, with the important distinction between sequential station logic and true simultaneous multi-channel machining.
5. **Automation cells** — LinuxCNC as one machine-control node inside a broader PLC/Python/supervisory sequence including pallets, conveyors, presses, loaders, product selection and automatic G-code loading.

The uniquely valuable 3800 theme is **stateful sequencing and recovery**. Ordinary milling/turning teaches toolpath execution; 3800 must teach what happens when a clamp changes hands, stock slips, a pallet is missing, an indexer stops between stations, or a cycle is aborted after only part of the material flow has completed.

## Native LinuxCNC primitives that matter

### ClassicLadder / PLC logic

ClassicLadder is a realtime software PLC included with LinuxCNC. It provides ladder logic and Sequential Function Chart (Grafcet) support and executes with a minimum one-millisecond update period. This makes it a first-class study target for interlocks, timers, counters, sequence state and industrial-style mechanism logic.

Do not assume ladder is always the correct owner. 3800 should compare:

- realtime HAL components for small deterministic mechanisms;
- ClassicLadder for relay/PLC-style sequencing;
- remap / custom M-codes for machine-cycle integration;
- Python/LinuxCNC NML interfaces for supervisory orchestration and product/job management;
- external PLCs when the cell contains substantial non-CNC automation or existing plant control.

### Extra joints

LinuxCNC supports up to 16 joints total. `num_extrajoints` allows joints that participate in homing but are excluded from the machine kinematics. After homing, an extra joint is commanded through `joint.N.posthome-cmd` and is normally shaped by an independent planner such as `limit3`.

This is highly relevant to:

- bar feeders;
- stock pushers;
- movable stops;
- loader slides;
- simple pick/place auxiliary axes;
- independently positioned clamps or mechanisms that do not participate in the cutting toolpath.

Important boundary: extra joints are **independent single-joint motion**, not a second coordinated G-code channel.

### limit3

`limit3` follows a position request while enforcing position, velocity and acceleration constraints. It is the natural building block for many extra-joint mechanisms where the command is a target position rather than a G-code trajectory.

### Carousel / indexed-position logic

LinuxCNC's `carousel` component is intended for indexed mechanisms and can decode gray code, binary, individual position sensors or index-plus-pulse arrangements. Although designed for toolchangers, the underlying pattern is directly useful to understand discrete rotary indexers:

`desired position -> determine direction -> move -> observe code/index -> settle -> final position witness`

Do not automatically reuse `carousel` for every production indexer; study whether the mechanism also needs unlock/clamp pressure, dwell, exact-stop, fixture-state or workpiece-state logic that belongs outside the component.

### M-codes / I/O handshakes

M62/M63, M64/M65, M66, M67/M68, custom M100-M199 commands and remap provide useful program-to-sequence handoffs. In 3800 the curriculum should emphasize that a command is not the same as physical completion:

`request clamp != clamp solenoid energized != clamp closed switch != workpiece securely held`

Likewise:

`request index != motor running != station code reached != mechanical lock proven`.

### Python / NML supervisory control

A real LinuxCNC automation-cell build provides strong evidence for a split architecture where Python selects products and G-code, an external PLC handles broader machine/cell sequencing, and LinuxCNC executes the CNC section. This is an important 3800 pattern rather than an exception.

## S1 — automatic saws / cut-to-length machines

A 2025 Marvel V10A automatic bandsaw retrofit thread is a strong current field case. The machine uses a shuttle/feed architecture with hydraulic clamps and a ball-screw-related length mechanism. The owner planned a Mesa 7i76EU, touchscreen, linear encoder and custom Python HMI, while considering cut-list import and automatic mitering.

A useful generic saw architecture is:

`job/cut list -> qualify stock -> clamp handoff -> feed to target -> prove length -> clamp cutting side -> blade ready -> descend/cut -> prove cut complete -> retract -> count part -> choose next feed/remnant action`.

### Saw-specific state to study

- stock/material identity;
- target cut length and tolerance;
- requested quantity / remaining quantity;
- kerf allowance and cumulative-length accounting;
- remnant length / end-of-stock state;
- feed clamp versus fixed clamp ownership;
- feed position and independent verification;
- saw-head up/down state;
- blade running / speed ready;
- blade tension/broken-blade state where available;
- coolant/chip handling;
- miter angle/index lock if automated;
- finished-part/outfeed clearance;
- operator/manual recovery state.

### Clamp handoff is the core saw problem

For a shuttle feeder, the curriculum should model the workpiece itself as stateful:

1. fixed clamp owns stock;
2. shuttle clamp closes and proves grip;
3. fixed clamp releases;
4. shuttle advances/retracts to transfer stock;
5. fixed clamp recloses and proves grip;
6. shuttle can release/reposition.

If both clamps release unintentionally, stock position may become UNKNOWN even if the feeder encoder still knows its own position. This is one of the strongest 3800 lessons:

`mechanism position != workpiece position`.

### Cut-list / production HMI

Unlike conventional G-code-centric machines, an automatic saw operator usually wants:

- material/profile selection;
- list of lengths and quantities;
- current piece and count;
- remaining stock/remnant;
- pause after current cut;
- manual trim/scrap cut;
- skip/retry item;
- fault explanation and guided recovery.

The curriculum should study how to map this operator workflow onto LinuxCNC/QtVCP/Python without forcing the operator to manage raw G-code.

## F1 — stock feeders, positioning stops and bar feeders

A documented LinuxCNC bar-feeder example uses an auxiliary U axis to move a long bar between machining operations:

`clamp -> machine -> unclamp -> feed -> clamp -> machine ...`

This is exactly the sort of mechanism now better represented by extra-joint architecture when no coordinated toolpath is required.

Another LinuxCNC lathe example demonstrates custom M-code / ClassicLadder coordination for bar-puller and chuck/clamp behavior.

### Feeder architectures to compare

- servo/stepper pusher;
- hydraulic/pneumatic shuttle with encoder/limit feedback;
- clamp-and-shuttle gripper;
- powered roller conveyor;
- servo stop where material is advanced by an external process;
- lathe bar puller using the cutting tool or dedicated puller;
- magazine loader feeding one full bar at a time.

### Required feeder contracts

Separate:

- feeder carriage position;
- actual stock position;
- clamp/grip state;
- stock-present state;
- stock identity/material/lot if relevant;
- end-of-bar / remnant state;
- machine-side ready-to-receive state.

A feeder can be perfectly positioned while the stock has slipped. Deep work should search for real designs using an independent encoder, measuring wheel, hard stop, sensor or post-feed verification to detect this.

### Multi-stroke feeds

If requested feed length exceeds shuttle travel, the control needs a repeatable multi-stroke transfer algorithm with explicit ownership at every clamp handoff. This should be a dedicated 3800 study case because cumulative error and ambiguous stock ownership can otherwise build silently.

## I1 — indexing machines / discrete positioners

3800 should study rotary tables and dial/index mechanisms that have a discrete mechanical lock or detent rather than treating every rotary system as a continuous C axis.

A reusable index cycle is:

`qualify safe-to-index -> unlock -> prove unlocked -> move toward requested station -> decelerate/pre-index -> reach station code/index -> stop -> clamp/lock -> prove locked -> authorize process`.

Important distinctions:

- encoder or code value says where the mechanism is;
- lock sensor says whether it is mechanically secured;
- fixture/workpiece sensors say whether the station is usable;
- machining authorization requires all required witnesses.

LinuxCNC community turret/indexer discussions provide multiple real mechanisms using coded sensors, index pulses, bidirectional motors, pneumatic unclamping and explicit clamp witnesses. Those are highly transferable to 3800 even when the original mechanism is a tool turret.

## T1 — transfer machines / multi-station systems

A 2024 LinuxCNC discussion on rotary transfer machines exposes the main architecture limit clearly.

LinuxCNC has one coordinated trajectory planner per process. A single instance cannot independently execute two unrelated multi-axis contour programs at the same time. Therefore distinguish:

### Sequential / simple station motion

LinuxCNC can plausibly control many station mechanisms when they are:

- discrete or point-to-point;
- one axis each;
- extra-joint / HAL-planned motion;
- synchronized by state logic;
- not simultaneously following independent multi-axis toolpaths.

### True simultaneous multi-channel machining

If two or more stations must simultaneously run independent coordinated paths, a single LinuxCNC process is not the natural architecture.

Candidate architectures:

- one LinuxCNC controller per independent machining station plus hardwired/fieldbus handshakes;
- an external PLC/supervisor coordinating multiple LinuxCNC nodes;
- another controller designed for true multi-channel NC.

3800 should teach this decision boundary rather than trying to force every automation cell into one LinuxCNC motion instance.

## A1 — automation cells

A particularly strong field case is a production automation system built with:

- an external PLC;
- LinuxCNC with Mesa 7i76E;
- Python supervisory software;
- circulating pallets;
- a heat-press process;
- a CNC cutting station;
- fully automatic infeed/outfeed;
- automatic homing/re-homing;
- operator product-code selection rather than direct CNC operation.

The Python layer communicated with LinuxCNC via NML to load the correct G-code, while the PLC and supervisory layer managed the broader production sequence.

This is one of the best 3800 architecture examples because it separates responsibilities cleanly:

**PLC / cell layer**
- pallet routing;
- conveyors / presses / process equipment;
- cell interlocks;
- product flow;
- high-level ready/busy/done/fault handshakes.

**LinuxCNC machine layer**
- homing/reference;
- coordinated CNC motion;
- local process I/O;
- execution and completion of the selected machining program.

**supervisory/HMI layer**
- product selection;
- job/recipe mapping;
- automatic program selection;
- operator presentation;
- possibly traceability and production counts.

### Cell handshake model

Deep work should freeze a generic handshake vocabulary from real implementations rather than inventing one casually. Candidate concepts include:

- cell_ready;
- machine_ready;
- part_present;
- part_clamped;
- cycle_request;
- cycle_active;
- cycle_complete;
- unload_authorized;
- fault;
- recovery_required.

The important lesson is that `program finished` is not automatically equivalent to `part safe to transfer`.

## P1 — pick-and-place / feeder-rich machines as adjacent evidence

LinuxCNC has an active pick-and-place community, and OpenPnP can use LinuxCNC through an external command bridge. This is useful 3800 evidence for:

- large numbers of feeder positions;
- feeder-advance commands;
- vacuum pick state;
- external supervisory software controlling LinuxCNC motion;
- synchronization between two software systems;
- position-state drift if one system moves the machine without the other knowing.

Do not let 3800 become an electronics-assembly curriculum. Use OpenPnP/LinuxCNC primarily as an architectural case for feeder-rich automation and external supervisory control.

## Cross-cutting 3800 state model

All 3800 machines should separate at least:

1. **Job/recipe state** — lengths, quantities, product code, material, station plan.
2. **Workpiece state** — which physical stock/part/pallet is where and who currently owns/clamps it.
3. **Mechanism state** — feeder, saw head, clamp, stop, indexer, conveyor, loader positions.
4. **Sensor evidence** — limit/prox/encoder/pressure/vacuum/part-present confirmations.
5. **Execution state** — requested cycle, active step, completed step, repetition count.
6. **Authority state** — which subsystem is permitted to move or transfer the part now.
7. **Recovery state** — what is still trustworthy after abort, E-stop, power loss or sensor disagreement.

A core 3800 rule should be:

**Never reconstruct workpiece state from commanded mechanism state alone after an interruption.**

## Recovery cases 3800 must teach

- abort during stock transfer;
- one clamp failed to close;
- stock slip / encoder disagrees with cut result;
- end-of-bar discovered earlier than expected;
- saw stopped in material;
- blade break / process-ready lost;
- indexer stopped between stations;
- index position reached but lock not proved;
- part-present sensor contradictory with expected pallet state;
- pallet/fixture identity lost after restart;
- PLC and LinuxCNC disagree on cycle state;
- supervisory software restarts while LinuxCNC remains running;
- LinuxCNC restarts while physical cell remains loaded.

For each case, deep work should document detection, ordinary-control response, what state becomes UNKNOWN, what can be retained, and what physical/operator reconciliation is required.

## Highest-value deep-work sequence

### 3800-S1 — automatic saw deep trace

Use the Marvel V10A retrofit and at least one second automatic saw/feed implementation.

Trace:

- feed mechanism;
- clamp handoff;
- length measurement;
- saw-head sequence;
- blade/process ready;
- miter/index state if present;
- cut count/cut list;
- remnant handling;
- manual/recovery modes.

### 3800-F1 — feeder / extra-joint architecture

Source-trace LinuxCNC extra joints, `limit3`, the shipped extra-joint simulations and at least one real bar-feeder/stock-feeder config.

Freeze when an extra joint is sufficient versus when a coordinate axis or separate controller is necessary.

### 3800-I1 — discrete indexer

Deep-read `carousel` and compare it with one production index mechanism having:

- unlock/clamp witnesses;
- encoded position;
- fast/slow or bidirectional approach;
- timeout/fault behavior.

Teach the transferable mechanism pattern without pretending a toolchanger is identical to a rotary production table.

### 3800-A1 — PLC + LinuxCNC automation cell

Deep-trace the documented industrial automation project and seek at least one second cell architecture.

Focus on:

- NML/Python or equivalent program-loading/control path;
- PLC/LinusCNC responsibility split;
- ready/busy/done/fault handshake;
- product/pallet identity;
- startup/re-homing;
- E-stop/recovery;
- unattended-repeat behavior.

### 3800-T1 — transfer-machine boundary

Study simple sequential station control versus true simultaneous multi-channel machining. Preserve the single-planner limitation and compare multi-controller architectures.

### 3800-P1 — external supervisor / OpenPnP case

Bounded study of OpenPnP-to-LinuxCNC synchronization, feeder commands and position ownership as an adjacent automation pattern.

## Candidate bounded experiments — only if evidence leaves a real question

- simulated shuttle feeder with two clamp witnesses and intentional clamp failure;
- multi-stroke feed with accumulated stock-slip error versus independent stock encoder;
- extra-joint stop/pusher commanded through `limit3` and interrupted mid-move;
- indexer state machine with position code reached but lock sensor missing;
- ClassicLadder/SFC automatic saw sequence with abort at each step;
- PLC/LinuxCNC handshake simulator with duplicate/stale cycle requests;
- supervisor restart while LinuxCNC retains program/machine state;
- cut-list executor recovering from an uncertain partially completed item.

Do not run prototypes just because the track exists. Prefer real configs, field sequences and source-level behavior first.

## Safety boundary

Saws, automatic clamps, feeders, conveyors and transfer mechanisms introduce severe cut, crush, shear and entanglement hazards. LinuxCNC/ClassicLadder ordinary logic, diagnostics and software interlocks are not automatically safety-rated functions.

Required guarding, monitored doors, safe stopping, blade/saw safety, clamp safety, enabling devices, safe speeds and required PL/SIL remain machine- and risk-assessment-specific. LinuxCNC may observe and react to safety-chain state without being assumed to implement the certified safety function.

## Promotion boundary

Do not call 3800 mature until the curriculum has at least:

1. one automatic saw/cut-to-length implementation with stock feed, clamp handoff and cut-list/count behavior;
2. one source/config-traced feeder or stop using a defensible position/workpiece-state model;
3. one discrete indexer with position and mechanical-lock proof;
4. one production automation-cell architecture showing PLC/supervisor/LinuxCNC ownership boundaries;
5. a clear single-controller versus multi-controller decision model for transfer machines;
6. a recovery playbook covering interrupted transfer, stock uncertainty, index uncertainty, cell-state disagreement and partial-cycle restart.

## Breadth verdict

3800 has strong practical value and significant transfer to real factory automation. The highest unique information gain is **workpiece/state ownership across sequential mechanisms** rather than motion mathematics. The strongest first deep pass should be automatic saw + feeder/clamp handoff, followed by the real PLC/Python/LinuxCNC automation-cell architecture and then discrete indexers / transfer-machine boundaries.

## Primary sources discovered in this breadth pass

- LinuxCNC `motion` / extra-joints documentation and shipped extra-joint simulations.
- LinuxCNC `limit3` component.
- LinuxCNC `carousel` component and toolchanger simulations.
- LinuxCNC ClassicLadder documentation.
- LinuxCNC M-code I/O and synchronization documentation.
- LinuxCNC forum: `Automatic band saw marvel v10a` (2025).
- LinuxCNC forum: auxiliary-axis/bar-feeder discussion.
- LinuxCNC forum: custom M-code/bar-puller setup.
- LinuxCNC forum: `Industrial Automation Project` describing a long-running PLC + Python + LinuxCNC production cell.
- LinuxCNC forum: rotary transfer-machine architecture discussion (2024).
- LinuxCNC pick-and-place/OpenPnP discussions and `linuxcnc-gcode-server` project as adjacent supervisory-control evidence.
