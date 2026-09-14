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

Latest active checkpoint: `checkpoints/3300-next-2026-09-14e.md`.

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

Key L1 boundary: `laserpower.comp` is optional reusable infrastructure, not mandatory architecture. CO2, diode/vector-raster and fiber metal cutting require separate source-readiness, gas, height/focus, recipe and recovery evidence.

### Waterjet W1

Authoritative artifacts:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`

Real LinuxCNC evidence supports distinct nozzle/water and abrasive commands, explicit program/manual authority arbitration, nominal Z versus cutting-time correction authority, and careful preservation of original servo/feedback topology.

Primary vendor documentation sharpens but does not fill the missing LinuxCNC contract: low/high pressure modes and low-pressure pierce exist; vacuum-assist can establish abrasive before water; abrasive availability/transfer/metering are distinct layers; clog recovery may require purge/diverter state; intensifier and direct-drive pump idle behavior differ. Therefore **do not freeze a universal water-before-abrasive rule**.

Highest-value W1 unknowns remain:

- pump/intensifier start, READY and fault semantics;
- high-pressure valve/pressure qualification;
- recipe-specific water/abrasive lead-lag and pierce timing;
- automatic standoff feedback/control;
- nozzle/abrasive flow faults and purge recovery;
- pause/feed-hold/abort/restart reconciliation;
- high-pressure safeguarding/interlocks.

W2 dual-head/5-axis taper compensation remains deferred until the 3-axis process contract is evidence-backed.

### Lab decision

No new lab in this 3300 pass. Source/config/build-diary work is still higher information gain. Frozen candidates remain queued M67/M62 with no following motion, vector deceleration/corner power scaling, raster pixel boundaries, and water/abrasive recovery only after a real waterjet sequencing contract is found.

## Other open 3000 branches

- **3200 Lathes / Turning Centers:** paused by owner rotation; latest preserved checkpoint `checkpoints/3200-lathe-next-2026-09-14b.md`.
- **3600 Press Brakes:** not graduated; documented branch-local information-gain stop. Integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.
- 3100/3400/3500/3700/3800/3900 remain parallel specialization branches for later rotation.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3300-next-2026-09-14e.md`.

Prioritize W1 retrieval of a real pump/pressure-ready implementation and a real water/abrasive sequencing implementation. In parallel, collect mature fiber configs with integrated source READY/FAULT, gas pressure/selection, focus/pierce and abort/recovery, and search for a real deployment using upstream `laserpower.power`. Build the cross-process 3300 playbook only after W1 has a defensible 3-axis contract.
