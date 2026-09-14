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

Latest active checkpoint: `checkpoints/3400-next-2026-09-14c.md`.

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

A source-history trace established that the 2024 community fiber-height-control experiment became merged upstream QtPlasmaC `laser_mode` through PR #2973. At the pinned revision, `(torch_on || laser_mode)` admits the CUT_MODE_01 height-control path, `laser_mode` bypasses the initial near-requested-velocity target-acquisition gate, and configured downstream corner-lock and void-lock logic still remain capable of suppressing correction. Thus `laser_mode` is a real upstream fiber-specific height-control adaptation, not a complete fiber process controller.

### Waterjet W1

Authoritative artifacts:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`
- `research/3300-waterjet-w1-field-chronology-pressure-authority-2026-09-14.md`

Real LinuxCNC evidence supports distinct nozzle/water and abrasive commands, explicit program/manual authority arbitration, nominal Z versus cutting-time correction authority, and careful preservation of original servo/feedback topology. The targeted pump/readiness search reached a bounded source-availability stop: no downloadable LinuxCNC implementation was found exposing a complete `pump/intensifier command -> pressure transition -> READY/fault qualification -> cut authorization -> pause/abort recovery` chain.

W1 remains open and the 3-axis state machine is not frozen. Reopen only when stronger pressure/readiness/recovery evidence becomes inspectable.

## 3400 — Routers / Woodworking

Existing foundation and earlier deep work:

- `research/3400-router-woodworking-breadth-survey-2026-09-14.md`
- `research/3400-fenja-router-atc-source-audit-2026-09-14.md`
- `research/3400-fenja-atc-abort-recovery-audit-2026-09-14.md`
- `research/3400-linuxcnc-abort-motion-dout-source-trace-2026-09-14.md`

New authoritative work:

- `research/3400-funkenjaeger-dcnc-atc-dust-spindle-gantry-audit-2026-09-14.md`
- `research/3400-gantry-negative-home-sequence-source-trace-2026-09-14.md`
- `research/3400-router-spindle-vfd-readiness-fault-boundary-2026-09-14.md`
- `research/3400-router-vacuum-dust-authority-community-boundary-2026-09-14.md`

### ATC / pneumatic authority

Two materially different real router ATC configurations now support the state separation:

`tool request -> pneumatic/source readiness -> physical transfer geometry -> actuator command -> clamp/pocket/tool witnesses -> logical tool identity -> measured/valid tool length`.

At `Funkenjaeger/fj-lcnc-cfg@f4877f862ab757bd396b02e54acb12e6835f8259`, a six-pocket rack ATC uses an air-pressure switch, six pocket sensors, drawbar/purge/rack outputs, machine-coordinate transfer moves, logical `M61` reconciliation and later fixed tool measurement. The inspected files do not expose direct drawbar-clamped/released feedback. Local failure paths clean some states, but no global custom-DOUT/tool-inventory reconciliation hook was found. Do not teach blind retry of an interrupted custom M6.

Repository chronology records a 2025 fix for an indefinite Auto-mode toolchange pause caused by spindle-at-speed interaction and a later fix for interference with an adjacent tool post. ATC commissioning must therefore include task/spindle-readiness interactions and real physical clearance, not only nominal geometry.

### Dust / workholding

The DCNC dust shoe is an explicit auxiliary state machine: it preserves prior state, obtains Z clearance, sequences pneumatic outputs, waits on its retract-position sensor, aborts on failed transition and conditionally restores after M6. Full down/swing-under completion remains partly dwell-based in the inspected source.

Community evidence shows dust collection may be machine-owned, spindle-timed or continuously shop-owned, while vacuum clamping commonly needs program/manual/HMI authority arbitration. Preserve distinct states for collector availability, dust-foot position, vacuum command and vacuum achieved. A production public vacuum-zone/pressure-ready/loss-recovery configuration remains source-poor; do not invent thresholds or recovery rules.

### Spindle / VFD

The real WJ200 userspace driver exposes running, at-speed, ready, alarm, actual frequency and a communication watchdog separately. The inspected machine HAL uses `is-at-speed` for `spindle.0.at-speed` and exposes alarm diagnostics, but no evidence was found that READY or watchdog freshness is a cut/ATC permissive. Status availability is not status authority.

Preserve command, running, at-speed, ready, alarm and communications freshness as distinct facts. Ordinary Modbus/VFD status is not safety-rated standstill.

### XYY gantry homing

Pinned LinuxCNC `homing.c` and homing documentation close the negative-HOME_SEQUENCE behavior for the real XYYZ DCNC configuration:

- joints sharing a negative absolute sequence value home as a group;
- switch/search/latch reference acquisition remains per joint;
- `sync_ready()` synchronizes the final move to `[JOINT_n]HOME`;
- a `HOME_ABORT` caused by a joint failure clears homing/homed state, stops free homing motion and clears sequence membership for all joints.

Thus one-side homing failure leaves the inspected software state globally unhomed. No synthetic lab is needed for this question. This does not guarantee mechanical anti-racking or replace correctly designed switches/overtravel protection.

### Remaining 3400 evidence

Continue from `checkpoints/3400-next-2026-09-14c.md`:

1. finish the custom Motion-DOUT transition boundary across program Abort, machine OFF / `EMCMOT_DISABLE`, E-stop/task state and shutdown/HostMot2 behavior;
2. if source cannot resolve the user-visible already-applied M64 state, run only the narrow DOUT transition lab while observing built-in iocontrol tool-change pins in parallel;
3. reopen vacuum workholding only for a real pressure/ready/loss/recovery implementation;
4. rotate to another underdeveloped 3000 track once the DOUT boundary is closed or checkpointed rather than over-mining 3400.

## Other open 3000 branches

- **3200 Lathes / Turning Centers:** paused; latest preserved checkpoint `checkpoints/3200-lathe-next-2026-09-14b.md`.
- **3300 Plasma / Laser / Waterjet:** open with bounded current source stops; latest checkpoint `checkpoints/3300-next-2026-09-14f.md`.
- **3600 Press Brakes:** not graduated; documented branch-local information-gain stop. Integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.
- 3100/3500/3700/3800/3900 remain parallel specialization branches for later rotation.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3400-next-2026-09-14c.md` while the custom-DOUT transition question has a concrete evidence-gain path. Reopen 3300 opportunistically only for genuinely new waterjet pressure/readiness or mature fiber process-recovery evidence. When 3400 reaches a bounded stop, rotate to an underdeveloped 3000 track according to `WORK_SELECTION_POLICY.md`; a branch-local source stop is not a curriculum stop.
