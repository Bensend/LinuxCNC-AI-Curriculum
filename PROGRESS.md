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

**3000 — machine-specific specialization.** Current owner-selected branch: **3300 — Plasma / Laser / Waterjet**.

Latest active checkpoint: `checkpoints/3300-next-2026-09-14f.md`.

3200 remains paused by explicit owner rotation, not graduated. 3600 retains its branch-local information-gain stop. Do not fall back to either without evidence/rotation authority.

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

Authoritative artifacts:

- `research/3300-laser-native-source-foundation-2026-09-14.md`
- `research/3300-laser-real-implementation-comparison-2026-09-14.md`
- `research/3300-laser-sector67-raycus-config-trace-2026-09-14.md`
- `research/3300-laser-laserpower-deployment-availability-audit-2026-09-14.md`

Native source establishes:

- `laserpower.comp`: vector/raster modes, actual/requested velocity scaling, min/max normalization and vector interpolation by distance-to-go;
- `raster.comp`: position-driven pixel stream, bidirectional sweep, interpolation, OFF sentinel and explicit faults/reset;
- M62/M63/M67 are queued to the next motion; with no following motion the queued change does not occur; M64/M65/M68 are immediate.

Real implementations now include:

1. historical Buildlog CO2: M3/M5 master permission, analog power, custom PPI/raster streaming, chiller/assist and overscan;
2. JTrantow diode/Fusion at `687c83c5906b2483e4f4754ee26e894832a7c259`: Fusion emits M67 power by jet mode and `motion.analog-out-00` directly drives Mesa 20 kHz PWM;
3. **Sector67 Raycus C500 fiber at pinned revision `938b501bfd092505170af8146c1b77a8564754d1` with a downloadable full config.**

Sector67 source/config confirms:

- power path: `QtPlasmaC material cut_amps -> custom_filter M03 spindle speed -> spindle.0.speed-out-abs -> Mesa PWM -> PWM-to-0-10 V converter -> Raycus analog power`;
- capacitive height path: `BCL-AMP frequency -> Schmitt trigger -> HostMot2 encoder counter mode -> encoder velocity -> scaling/limit -> QtPlasmaC arc-voltage surface`;
- synthetic ohmic probe from capacitive threshold and an always-true fake Arc OK are compatibility glue, not physical plasma semantics;
- Raycus analog power, modulation, enable and READY are separate surfaces; READY is not integrated into machine-on qualification in the preserved config, and source enable during source power-up can fault the source, so startup correctness is currently procedural;
- gas control is a simple program-running timed solenoid and is explicitly described by the project as naive.

A fresh global code audit found `loadrt laserpower` / `laser.control.power` only in the shipped LinuxCNC laser simulator and source-tree forks/copies, not an independently evidenced physical machine. This is a bounded **public deployment gap**, not evidence that no field machine uses the component. Treat `laserpower.comp` as native reusable realtime infrastructure, not a canonical production laser architecture.

Key L1 boundary: CO2, diode/vector-raster and fiber metal cutting require separate source-readiness, gas, height/focus, recipe and recovery evidence. The highest-value remaining L1 evidence is a mature fiber implementation with integrated READY/FAULT, gas pressure/type, focus/pierce and abort/restart behavior. Do not repeat exact `laserpower.*` deployment searches without a new candidate.

### Waterjet W1

Authoritative artifacts:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`
- `research/3300-waterjet-w1-field-chronology-pressure-authority-2026-09-14.md`

Real LinuxCNC evidence supports distinct nozzle/water and abrasive commands, explicit program/manual authority arbitration, nominal Z versus cutting-time correction authority, and careful preservation of original servo/feedback topology.

A 2022 retrofit chronology now adds commissioning evidence from original process-I/O identification through working LinuxCNC/Mesa control. Its waterjet command was intentionally active-low so controller shutdown would leave the machine depressurized; this is machine-specific field behavior, not a universal or safety-rated LinuxCNC contract. The same chronology separates successful CNC control from later independent hydraulic leaks. A converted FLOW machine provides long-lived LinuxCNC deployment evidence but exposes no process sequence.

Industrial process evidence sharpens the authority model without inventing LinuxCNC semantics: CNC low-pressure-pierce requests can be handed to a separate pump PLC/controller that owns the pressure transition; vacuum-assisted piercing can intentionally establish abrasive before water; abrasive availability/transfer/metering are distinct; clog recovery may require purge/diverter behavior; intensifier and direct-drive pump idle behavior differ. Therefore **do not freeze a universal water-before-abrasive rule** and do not treat a pressure command as proof that pressure is achieved.

The targeted pump/readiness search has reached a bounded source-availability stop: no downloadable LinuxCNC HAL/remap/custom component was found that exposes a complete `pump/intensifier command -> pressure transition -> READY/fault qualification -> cut authorization -> pause/abort recovery` chain.

W1 remains open and the 3-axis state machine is not frozen. Reopen the pressure-readiness sub-branch only when a pump PLC mapping, pressure/ready/fault witness, high-pressure-valve ownership path, real sequencing component/remap, or recovery implementation becomes inspectable.

W2 dual-head/5-axis taper compensation remains deferred until the 3-axis process contract is evidence-backed.

### Lab decision

No new lab in this 3300 pass. Source/config/build-diary work remains higher information gain for the open questions. Frozen candidates remain queued M67/M62 with no following motion, vector deceleration/corner power scaling, raster pixel boundaries, and water/abrasive recovery only after a real waterjet sequencing contract is found.

## Other open 3000 branches

- **3200 Lathes / Turning Centers:** paused by owner rotation; latest preserved checkpoint `checkpoints/3200-lathe-next-2026-09-14b.md`.
- **3600 Press Brakes:** not graduated; documented branch-local information-gain stop. Integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.
- 3100/3400/3500/3700/3800/3900 remain parallel specialization branches for later rotation.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3300-next-2026-09-14f.md`.

Prioritize mature fiber implementations with integrated source READY/FAULT, gas type/pressure, focus/pierce and pause/abort/restart behavior. Reopen W1 pump/pressure-ready work only on genuinely new inspectable implementation evidence rather than repeating generic searches. If those 3300 paths both remain source-limited, checkpoint 3300 and rotate to another underdeveloped open 3000 branch according to `WORK_SELECTION_POLICY.md` rather than returning by default to paused 3200 or source-limited 3600.
