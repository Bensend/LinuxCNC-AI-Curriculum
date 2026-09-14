# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed historical progress remains preserved in Git history and the referenced research/results/evaluation artifacts; this file is the current dependency/checkpoint view.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.

Do not reopen or repoll closed 2000 work unless a genuinely new material defect is discovered in preserved evidence.

## Active curriculum level

**3000 — machine-specific specialization.** Parallel branches remain:

- 3100 Mills / VMCs
- 3200 Lathes / Turning Centers
- 3300 Plasma / Laser / Waterjet
- 3400 Routers / Woodworking
- 3500 Robots / Custom Kinematics
- 3600 Press Brakes
- 3700 Grinding / EDM
- 3800 Saws / Feeders / Automation Cells
- 3900 Emerging / Unusual Machines

Current owner-selected branch: **3300 — Plasma / Laser / Waterjet**.

Latest active checkpoint: `checkpoints/3300-next-2026-09-14d.md`.

Do not fall back to 3200 without a later explicit owner rotation. 3200 is paused, not graduated. Preserve the 3600 information-gain stop.

---

## 3300 — Plasma / Laser / Waterjet

Pinned LinuxCNC revision for current upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

### Breadth asymmetry

- **Plasma:** richest first-class LinuxCNC process implementation through QtPlasmaC / `plasmac.comp`. P1 source ownership is established and P2/P3 have reached a breadth-first diminishing-return point.
- **Laser:** upstream realtime `laserpower.comp`, `raster.comp` and `configs/sim/axis/laser` are now source-traced. Real CO2, diode/Fusion and fiber-retrofit architectures differ materially; no universal integrated laser process controller has been established.
- **Waterjet:** real LinuxCNC retrofits exist, but bounded upstream source search still finds no dedicated waterjet process component comparable to QtPlasmaC. W1 has begun from real machine evidence and retains major process-sequencing unknowns.

### 3300-P1/P2/P3 — plasma state

Authoritative artifacts include:

- `research/3300-plasma-laser-waterjet-breadth-survey-2026-09-14.md`
- `research/3300-qtplasmac-process-eoffset-source-trace-2026-09-14.md`
- `research/3300-plasma-build-diary-comparison-2026-09-14.md`
- `research/3300-plasma-production-workflow-foundation-2026-09-14.md`
- `research/3300-plasma-rfl-pmx-source-trace-2026-09-14.md`
- `research/3300-plasma-hole-filter-pmx-field-trace-2026-09-14.md`

Preserved contracts:

- `plasmac.comp` owns plasma process decisions; Motion owns external-offset trajectory/application/limits.
- requested, applied and nominal eoffset state are distinct; disable does not itself clear nonzero applied offset.
- IHS/probe, pierce, Torch On, Arc OK, THC qualification, arc-start failure, arc loss, pause/recovery and offset cleanup are state-qualified rather than inferred from one signal.
- real commissioning histories preserve Arc OK mode mismatch, THCAD wiring polarity, THCAD divide/scaling provenance and tandem-axis/joint topology failures.
- material/CAM/filter/interpreter/realtime process authority are separate layers.
- Run From Line reconstructs modal/process state rather than merely seeking line N.
- `pmx485.py` is userspace/non-realtime communications/diagnostics, not Torch/Arc OK/safety authority.
- automatic small-hole filtering can insert `M67 E3` velocity reduction and computed overcut with `M62 P3`; normal M5 cleanup explicitly reconciles lingering E3/P3 filter state.
- a real PMX485 field history shows adapter replacement alone did not exhaust the fault tree; software-version/dependency provenance belongs in diagnostics.

Plasma remains open for strong new evidence such as downloadable ohmic+float configs, current CAM-post provenance, later tandem production evidence or a specific unresolved abort/recovery question, but do not repeat the generic source pass.

### 3300-L1 — laser state

Authoritative artifacts:

- `research/3300-laser-native-source-foundation-2026-09-14.md`
- `research/3300-laser-real-implementation-comparison-2026-09-14.md`

Source-established native contracts:

- `laserpower.comp` supports vector/raster power modes, actual/requested velocity scaling, min/max normalization and vector interpolation by distance-to-go.
- `raster.comp` consumes preprogrammed raster lines from a HAL port, maps motion position to pixel position, supports bidirectional sweeps, interpolation, an all-ones OFF sentinel and explicit parse/runtime faults.
- the shipped laser simulator maps motion analog outputs to min/max/vector power and uses feed/arc motion type as its simulator enable; it does not define a universal physical source interface.
- raster M10-M13 remaps use `INTERP_EXECUTE_FINISH` around begin/start/stop so prior motion completes before raster state changes.
- M62/M63/M67 are queued and take effect at the beginning of the next motion; without later motion the queued change does not occur. M64/M65/M68 are immediate and break blending.

Real implementation comparison:

1. Buildlog CO2: M3/M5 master permission, analog power, custom PPI/raster streaming, chiller/assist sequencing and raster overscan.
2. JTrantow diode/Fusion at public head `687c83c5906b2483e4f4754ee26e894832a7c259`: Fusion emits M67 power by jet mode; `motion.analog-out-00` directly drives Mesa 20 kHz PWM; spindle-enable gates relay/PWM; air/crosshair use coolant outputs.
3. community 500 W Raycus fiber retrofit: adapted QtPlasmaC with capacitive BCL-AMP head sensing mapped into height-control surfaces plus fake Arc OK/ohmic compatibility signals and modified qualification behavior.

Key boundary: `laserpower.comp` is optional reusable infrastructure, not mandatory architecture. CO2, diode vector/raster and fiber metal cutting require separate process/readiness/height/focus evidence.

### 3300-W1 — waterjet state

Authoritative artifact:

- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`

Evidence-backed surfaces:

- water/nozzle and abrasive-sender commands can be distinct;
- multi-head implementations exist;
- program command and physical/manual override authority must be explicitly arbitrated rather than implemented as MDI injection during AUTO;
- nominal Z/retract and cutting-time Z correction authority can be separate;
- industrial servo/feedback topology must be verified before interface selection.

Public implementation evidence currently includes a two-nozzle/two-abrasive retrofit, a dual plasma/waterjet Mesa retrofit, a cutting-time manual-Z discussion, a CMS 5-axis retrofit investigation and an older converted FLOW machine reported to have run LinuxCNC reliably for roughly 8-9 years before a PC/input-device fault.

Still UNKNOWN and highest-value W1 targets:

- pump/intensifier start, READY and fault semantics;
- low/high-pressure water-valve ownership;
- pressure feedback/qualification;
- abrasive lead/lag and postflow;
- water-only/abrasive/low-pressure pierce strategy and dwell provenance;
- automatic standoff feedback/control;
- nozzle/abrasive-flow diagnostics;
- pause/feed-hold/abort/restart reconciliation;
- multi-head process arbitration;
- high-pressure safeguarding/interlocks.

Do not freeze a production waterjet state machine until those are backed by real public source/config/build-diary evidence. W2 dual-head/5-axis taper compensation remains deferred until the 3-axis process contract is evidence-backed.

### 3300 lab decision

No lab has been launched in the current 3300 source/config/build-diary passes. Continue source evidence while it has higher information gain.

Frozen nonduplicate candidates include:

- plasma abort with nonzero applied eoffset / stale process state if source leaves a real uncertainty;
- laser queued M67/M62 with no following motion;
- laser controlled deceleration/corner power scaling;
- raster pixel/position boundaries;
- water/abrasive lead-lag recovery only after a real public process contract exists.

---

## 3200 — Lathes / Turning Centers

Status: **PAUSED BY OWNER ROTATION — not graduated**.

Latest preserved checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

Preserve the established distinctions among spindle command, at-speed readiness, index/phase feedback, tool-change handshake, tool identity/offset authority and spindle/orient/C-axis ownership. Do not resume without later explicit rotation.

## 3600 — Press Brakes

Status: **not graduated; documented branch-local information-gain stop**.

Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

Preserve PB-BG/PB-DXF test-confirmed command/target/provenance contracts and existing bounded unknowns. Do not let the 3600 stop block other 3000 branches.

---

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled laboratory compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total.

Latest recorded lab remains PB-BG-004, workflow `34670275431`, Gates A-J 10/10. No new lab compute was consumed in the current 3300 plasma/laser/waterjet source pass.

## Global next-work rule

Continue from `checkpoints/3300-next-2026-09-14d.md`.

Prioritize W1 public evidence for pump/high-pressure readiness and water/abrasive timing, while opportunistically collecting strong L1 contemporary fiber source/config evidence. Use source/config/build-diary reasoning rather than manufacturing simulations. Build the final cross-process 3300 playbook only after W1 has a defensible 3-axis process contract.
