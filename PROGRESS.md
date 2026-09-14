# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and the referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.

Do not reopen or repoll closed 2000 work unless a genuinely new material defect is discovered.

## Active curriculum level

**3000 — machine-specific specialization.** Current active work branch: **3400 — Routers / Woodworking**, reached by work-selection rotation after the current highest-value 3300 source paths hit branch-local information-gain stops.

Latest active checkpoint: `checkpoints/3400-next-2026-09-14b.md`.

3300 remains open, not graduated, with latest preserved checkpoint `checkpoints/3300-next-2026-09-14f.md`. 3200 remains intentionally paused. 3600 retains its branch-local information-gain stop.

## 3300 — Plasma / Laser / Waterjet

Pinned LinuxCNC revision for upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

### Plasma P1/P2/P3

Current breadth pass is mature enough for rotation. Authoritative artifacts include:

- `research/3300-qtplasmac-process-eoffset-source-trace-2026-09-14.md`
- `research/3300-plasma-build-diary-comparison-2026-09-14.md`
- `research/3300-plasma-production-workflow-foundation-2026-09-14.md`
- `research/3300-plasma-rfl-pmx-source-trace-2026-09-14.md`
- `research/3300-plasma-hole-filter-pmx-field-trace-2026-09-14.md`

Preserved contracts: QtPlasmaC realtime process state is distinct from Motion external-offset execution; requested/applied/nominal offsets are distinct; real THCAD/Arc OK commissioning failures are layer-specific; RFL reconstructs process/modal state; PMX485 is userspace communications rather than realtime Arc OK/safety authority; the filter can synthesize small-hole E3 velocity reduction and P3 overcut with explicit normal M5 cleanup.

Do not repeat generic plasma tracing. Reopen opportunistically for strong downloadable ohmic+float configs, current CAM-post provenance, later tandem production evidence or a specific unresolved recovery problem.

### Laser L1

Authoritative artifacts now include:

- `research/3300-laser-native-source-foundation-2026-09-14.md`
- `research/3300-laser-real-implementation-comparison-2026-09-14.md`
- `research/3300-laser-sector67-raycus-config-trace-2026-09-14.md`
- `research/3300-laser-laserpower-deployment-availability-audit-2026-09-14.md`
- `research/3300-laser-qtplasmac-laser-mode-source-history-2026-09-14.md`

Native source establishes `laserpower.comp`, `raster.comp`, and queued/immediate M62/M63/M67/M64/M65/M68 semantics. Real public machines currently show multiple materially different architectures rather than one canonical stack.

A bounded global search found `loadrt laserpower` / `laser.control.power` only in the shipped LinuxCNC laser simulator and source-tree forks/copies, not an independently evidenced physical machine. Treat `laserpower.comp` as native reusable realtime infrastructure, not as a proven dominant production architecture.

A new source-history trace established that the 2024 community fiber-height-control experiment became merged upstream QtPlasmaC `laser_mode` through PR #2973. At the pinned revision:

- `(torch_on || laser_mode)` admits the CUT_MODE_01 height-control path;
- `laser_mode` bypasses the initial near-requested-velocity target-acquisition gate;
- configured downstream corner-lock and void-lock logic still remain capable of suppressing correction.

Thus `laser_mode` is a real upstream **fiber-specific height-control adaptation**, not a complete fiber process controller and not unconditional THC at all velocities. Source READY/FAULT, optical emission proof, gas readiness, focus, pierce recipe, chiller/interlocks and abort/restart remain separate machine-specific evidence requirements.

Highest-value L1 work is now mature fiber field evidence with integrated READY/FAULT, gas type/pressure, focus/pierce and recovery. Do not repeat exact `laserpower.*` or `laser_mode` history searches without a new candidate or specific source question.

### Waterjet W1

Authoritative artifacts:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`
- `research/3300-waterjet-w1-field-chronology-pressure-authority-2026-09-14.md`

Real LinuxCNC evidence supports distinct nozzle/water and abrasive commands, explicit program/manual authority arbitration, nominal Z versus cutting-time correction authority, and careful preservation of original servo/feedback topology.

A 2022 retrofit chronology now adds commissioning evidence from original process-I/O identification through working LinuxCNC/Mesa control. Its waterjet command was intentionally active-low so controller shutdown would leave the machine depressurized; this is machine-specific field behavior, not a universal or safety-rated LinuxCNC contract. The same chronology separates successful CNC control from later independent hydraulic leaks. A converted FLOW machine provides long-lived LinuxCNC deployment evidence but exposes no process sequence.

Industrial process evidence sharpens the authority model without inventing LinuxCNC semantics: CNC low-pressure-pierce requests can be handed to a separate pump PLC/controller that owns the pressure transition; vacuum-assisted piercing can intentionally establish abrasive before water; abrasive availability/transfer/metering are distinct; clog recovery may require purge/diverter behavior. Therefore do not freeze a universal water-before-abrasive rule and do not treat a pressure command as proof that pressure is achieved.

The targeted pump/readiness search reached a bounded source-availability stop: no downloadable LinuxCNC HAL/remap/custom component was found that exposes a complete `pump/intensifier command -> pressure transition -> READY/fault qualification -> cut authorization -> pause/abort recovery` chain.

W1 remains open and the 3-axis state machine is not frozen. Reopen the pressure-readiness sub-branch only when a pump PLC mapping, pressure/ready/fault witness, high-pressure-valve ownership path, real sequencing component/remap, or recovery implementation becomes inspectable.

## 3400 — Routers / Woodworking

Existing breadth foundation:

- `research/3400-router-woodworking-breadth-survey-2026-09-14.md`

New deep source work:

- `research/3400-fenja-router-atc-source-audit-2026-09-14.md`
- `research/3400-fenja-atc-abort-recovery-audit-2026-09-14.md`
- `research/3400-linuxcnc-abort-motion-dout-source-trace-2026-09-14.md`

### FENJA/Groot real ATC source contract

At `GuiHue/myfenjalinuxcnc@16af9ade9484e9f6897b19bd6453ab4bbe79c0ac`:

- manual and automatic drawbar requests converge through HAL arbitration;
- WJ200 VFD `is-running` is used as an ordinary-control spindle-stop witness;
- rack M6 separates pocket provenance, safe machine-coordinate transfer geometry, drawbar command, drawbar-state feedback, tool-present feedback, logical `M61` tool update and later fixed-setter measurement;
- a separate 6-bar air-pressure signal exists;
- several `M66 ... L0` checks described in timeout-style comments are actually immediate input snapshots after fixed dwell, not transition waits with timeout.

Preserve the state chain:

`tool requested -> physical transfer -> clamp/tool witnesses -> logical tool identity -> measured/valid tool length`.

### Interrupted M6 / abort boundary

The inspected `groot.ini` has its `ON_ABORT_COMMAND=O <on_abort> call` line commented out. The preserved `on_abort.ngc` only restores G90/G40/G49 and does not reconcile drawbar output, physical tool state, rack/pocket inventory, air pressure or tool length.

Pinned LinuxCNC source further establishes:

- `emcTaskAbort()` clears task/interpreter execution state and invokes Motion abort;
- realtime `EMCMOT_ABORT` stops active motion paths and clears execution/error state but its inspected case does not explicitly reset arbitrary current `motion.digital-out-NN` values;
- `Task::emcIoAbort()` separately and explicitly clears the built-in `iocontrol.0.tool-change` and `iocontrol.0.tool-prepare` handshake outputs;
- LinuxCNC has an upstream regression test for abort-during-built-in-toolchange cleanup.

Therefore built-in iocontrol toolchanger cleanup must not be silently generalized to an M64/M65-driven custom drawbar output. A custom router ATC needs an explicit physical/logical recovery contract. Do not teach blind `retry M6` as idempotent.

The source result is deliberately bounded: it does not claim every E-stop, machine-OFF, module unload or startup transition preserves a DOUT. Those are separate transitions.

### Next 3400 evidence

Continue from `checkpoints/3400-next-2026-09-14b.md`:

1. compare a second materially different production router ATC with explicit failure/recovery behavior;
2. find real vacuum-table zone/pressure-proof and dust collector/dust-foot authority paths;
3. trace real spindle/VFD ready/fault around cutting and ATC;
4. compare XYYZ gantry squaring/home fault behavior;
5. only then decide whether a bounded M64-abort/machine-OFF/E-stop DOUT lab adds independent evidence.

## Other open 3000 branches

- **3200 Lathes / Turning Centers:** paused; latest preserved checkpoint `checkpoints/3200-lathe-next-2026-09-14b.md`.
- **3300 Plasma / Laser / Waterjet:** open with bounded current source stops; latest checkpoint `checkpoints/3300-next-2026-09-14f.md`.
- **3600 Press Brakes:** not graduated; documented branch-local information-gain stop. Integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.
- 3100/3500/3700/3800/3900 remain parallel specialization branches for later rotation.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3400-next-2026-09-14b.md` while 3400 has concrete evidence-gain paths. Reopen 3300 opportunistically only when genuinely new waterjet pressure/readiness or mature fiber process-recovery evidence becomes inspectable. Continue rotating among open 3000 tracks according to `WORK_SELECTION_POLICY.md`; a branch-local source stop is not a curriculum stop.
