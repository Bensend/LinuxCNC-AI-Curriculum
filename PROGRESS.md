# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed historical progress remains preserved in Git history and the referenced research/results/evaluation artifacts; this file is the current dependency/checkpoint view.

## Closed prerequisite levels

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The **2000 series — advanced control and diagnostics is GRADUATED / CLOSED as of 2026-09-14**.

Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` (finalized 2026-09-14).

F02 — compound-fault diagnosis/recovery integration is **GRADUATED at 2000 level**. Its valid information-separated evaluator result is `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — **PASS, no corrections required, no graduation blocker**.

The 2000-level advanced HMI / QtVismach/live-3D assessment is preserved at `evaluation/2000-hmi-qtvismach-assessment-2026-09-14.md` — **PASS, approximately 93/100**.

Do not reintroduce historical F02 or other 2000 fresh-AI blockers unless a new material defect is actually discovered in preserved evidence.

## Active curriculum level

The active level is **3000 — machine-specific specialization** under `LEVEL_ORDER.md` and `CURRICULUM.md`.

Parallel tracks:

- 3100 — Mills / VMCs
- 3200 — Lathes / Turning Centers
- 3300 — Plasma / Laser / Waterjet
- 3400 — Routers / Woodworking
- 3500 — Robots / Custom Kinematics
- 3600 — Press Brakes
- 3700 — Grinding / EDM
- 3800 — Saws / Feeders / Automation Cells
- 3900 — Emerging / Unusual Machines

Current active branch: **3300 — Plasma / Laser / Waterjet**.

Latest active checkpoint: `checkpoints/3300-next-2026-09-14b.md`.

The owner explicitly rotated to 3300 for a breadth-first pass. **Do not fall back to 3200 unless a later explicit rotation says to do so.**

---

## 3300 — Plasma / Laser / Waterjet

Pinned LinuxCNC revision for current source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

### Track asymmetry preserved

- **Plasma:** richest first-class LinuxCNC implementation through QtPlasmaC / `plasmac.comp`; current deep branch.
- **Laser:** native realtime `laserpower.comp`, `raster.comp` and laser simulation exist, but integrated production workflow is thinner; L1 follows plasma P1/P2/P3.
- **Waterjet:** real LinuxCNC retrofit evidence exists, but the bounded survey has not found an upstream dedicated process controller comparable to QtPlasmaC; W1 must begin from real implementations rather than copied plasma assumptions.

Breadth artifact:

- `research/3300-plasma-laser-waterjet-breadth-survey-2026-09-14.md`

### 3300-P1 — QtPlasmaC process / external-offset source trace

Artifact:

- `research/3300-qtplasmac-process-eoffset-source-trace-2026-09-14.md`

Current source-established contracts:

- `plasmac.comp` is a realtime state machine covering IHS/probe, pierce, Torch On, Arc OK, pierce delay, optional puddle jump, cut-height transition, THC, cut end/retract, pause, tests, consumable change and cut recovery.
- A pre-existing float/ohmic/breakaway input is not a valid fresh probe episode merely because it is high; sensor meaning is state-qualified.
- Ohmic probing can retry and fall back to the float switch according to configured attempt policy.
- Arc-start failure and later arc loss are separate failure classes. Start uses `arc_fail_delay`/retry count; established-arc loss uses Arc OK qualification plus `arc_lost_delay`.
- THC activation is qualified by process state, velocity/delay or stable-voltage sampling, configured enable/inhibit, Arc OK policy, corner lock/void lock and offset bounds.
- QtPlasmaC owns process decisions and requested X/Y/Z external-offset count evolution; LinuxCNC Motion owns the external-offset trajectory planner, acceleration/velocity allocation, insertion into Cartesian command and generic soft-limit clipping.
- Nominal axis position, requested external offset and applied external offset are distinct state surfaces. QtPlasmaC waits for applied offset convergence at important pierce/cut-height transitions.
- Removing eoffset enable while a nonzero offset exists does **not** clear the applied offset. Cleanup is a separate explicit action/trajectory.
- QtPlasmaC performs process-local Z offset bound checks before THC moves and separately reacts to Motion's `motion.eoffset-limited` feedback.
- MAX_HEIGHT, END_JOB and cut-recovery paths actively reconcile offsets; logical state completion is not treated as proof that physical/applied offsets are already zero.

P1 bounded adversarial review: **8/8 passed**.

No P1 lab launched: pinned source and Motion documentation are stronger than a synthetic duplicate for the current ownership questions.

### 3300-P2 — real plasma implementations / commissioning

Artifact:

- `research/3300-plasma-build-diary-comparison-2026-09-14.md`

Current community/config evidence:

1. **Powermax 45XP + Mesa 7i96 + THCAD5 + external Arc OK** — Arc OK was visible in HAL yet the process failed because QtPlasmaC was configured for the wrong Arc OK mode; correcting Mode 1 fixed Arc OK, then Hypertherm->THCAD wiring polarity had to be corrected for arc voltage. CAM/post problems became the next failure layer.
2. **QtPlasmaC + Mesa 7i96 + tandem-Y gantry** — early configuration confused Cartesian axis count with tandem-joint topology; the machine remains XYZ while Y has two joints/step generators.
3. **Everlast 82i + Mesa 7i96 + THCAD-2** — credible voltage acquisition required correct THCAD frequency divide plus correct source-divider/scale/offset provenance; `/32` and corrected scaling resolved the reported voltage problem.

Cross-machine lesson: `physical source/sensor -> electrical interface -> Mesa/encoder/GPIO -> HAL signal -> QtPlasmaC mode/config interpretation -> plasmac process state -> Motion applied offset -> physical process` is a chain. A correct observation at one layer does not certify downstream interpretation.

P2 bounded adversarial review: **6/6 passed**.

P2 remains open for a downloadable ohmic+float config, Powermax RS485 implementation/failure history and later-stage tandem production evidence.

### 3300-P3 — production plasma workflow

Artifact:

- `research/3300-plasma-production-workflow-foundation-2026-09-14.md`

Current contracts:

- Authority is separated as `CAD -> CAM/process intent -> postprocessor G-code/material commands -> QtPlasmaC G-code filter -> LinuxCNC interpreter/trajectory -> plasmac realtime state -> synchronized outputs/eoffsets -> physical process feedback`.
- `M190 Pn` requests a material change; documented workflow uses `M66 P3 ...` to wait for confirmation before relying on the selected material's feed.
- Standard QtPlasmaC plasma programs do not own process Z; filtering normally removes cut-program Z while the realtime plasma controller owns IHS/pierce/cut/retract through external offsets.
- `M62/M63 P2` schedule synchronized THC inhibit/enable intent; actual THC activity still depends on realtime qualification.
- `M67 E3` schedules feed reduction/restoration for feature strategy; it is not itself a THC command.
- `M62/M63 P3` is the synchronized torch-disable/enable surface recognized by the QtPlasmaC filter/run-from-line workflow and supports overcut-style strategies.
- `qtplasmac_gcode.py` actively validates/transforms incoming plasma G-code; it is not transparent pass-through.
- Run From Line has dedicated reconstruction/recovery code and cannot safely be modeled as jumping the interpreter directly to a line with no process-state rebuilding.
- PowerMax RS485 settings/telemetry are a **non-realtime** communication path and must remain separate from realtime cut/Arc OK/THC authority.

P3 bounded adversarial review: **7/7 passed**.

### Exact next 3300 work

Continue from `checkpoints/3300-next-2026-09-14b.md`:

1. continue P2 with inspectable ohmic+float, Powermax RS485 and later tandem-gantry configuration/build evidence;
2. continue P3 by tracing `run_from_line.py`, exact hole/overcut transformations in `qtplasmac_gcode.py`, a current QtPlasmaC CAM post, and `pmx485` integration/failure diagnostics;
3. then 3300-L1: pinned `laserpower.comp`, `raster.comp`, laser sim and M62/M63/M67/M68 semantics followed by real laser implementations;
4. then 3300-W1: multiple real waterjet configs/build diaries before freezing any process state model;
5. later build the cross-process 3300 playbook while preserving plasma/laser/waterjet process differences.

### 3300 lab decision

No lab launched in the current plasma passes. Source/config/build-diary evidence is still adding more information.

Candidate lab only if a real source/config gap remains:

- plasma external-offset cleanup on abort;
- stale/high Arc OK or probe state across a fresh pierce request;
- requested-vs-applied eoffset behavior during induced limit interruption;
- later laser synchronized-output/raster boundary experiments only after L1 source work.

---

## 3200 — Lathes / Turning Centers

Status: **PAUSED BY OWNER ROTATION — not graduated**.

Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

Latest preserved checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

Durable source/config artifacts:

- `research/3200-lathe-spindle-sync-foundation-2026-09-14.md`
- `research/3200-g76-pass-generation-source-trace-2026-09-14.md`
- `research/3200-spindle-index-readiness-config-comparison-2026-09-14.md`
- `research/3200-lathe-turret-toolchange-boundary-2026-09-14.md`
- `research/3200-css-x-origin-control-boundary-2026-09-14.md`
- `research/3200-toolchange-abort-ack-ownership-2026-09-14.md`
- `research/3200-lathe-carousel-public-implementation-2026-09-14.md`
- `research/3200-spindle-sync-pause-index-failure-2026-09-14.md`
- `research/3200-lathe-tool-identity-offset-compensation-2026-09-14.md`
- `research/3200-spindle-orient-caxis-mode-ownership-2026-09-14.md`

Preserve the established distinctions among spindle command, at-speed readiness, index/phase feedback, tool-change handshake, tool identity/offset authority and spindle/orient/C-axis ownership. Do not resume until a later explicit rotation chooses 3200.

---

## 3600 — Press Brake specialization state

The 3600 specialization is **not graduated**. Its generic preparation remains at a documented information-gain stop until new inspectable implementation/source appears.

Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

Preserved contracts include:

- PB-BG-001 through PB-BG-004: TEST-CONFIRMED backgauge command/target episode ownership and stale-generation protection;
- PB-DXF-001 through PB-DXF-004: TEST-CONFIRMED `ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet -> ExecutionEpisode` provenance chain;
- abort/restart requires reconciliation and a fresh runtime episode;
- reference/calibration, nominal process calculation, empirical correction, pressure command/feedback/derived force and external safety observation remain separate;
- measured bend angle is a process measurement channel, not a fake commanded axis.

Preserved unknowns:

- `PB-PREP-001` remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**;
- exact downloadable tandem Y1/Y2 correction insertion/saturation/addf/ferror/fault implementation remains unavailable;
- a real inspectable sensor-bending closed-loop implementation remains unavailable;
- unsupported bend-table/hydraulic/tooling/material/safety semantics remain UNKNOWN.

The 3600 stop is branch-local and must not block 3300 or another open specialization.

---

## Laboratory compute checkpoint

The authoritative ledger contains **338.56 minutes (5.64 h)** of exactly backfilled laboratory compute through the last recorded checkpoint. Historical gaps mean this is not a trustworthy full-project total.

`LAB_COMPUTE_LOG.md` remains authoritative for individual job timestamps. Latest recorded lab result remains PB-BG-004 (`lab-jobs/089-pb-bg-004-targetset-runtime-episode.sh`), workflow `34670275431`, frozen Gates A–J 10/10.

No lab compute was consumed in the current 3300 plasma source/community/workflow pass.

## Global next-work rule

Continue from `checkpoints/3300-next-2026-09-14b.md`.

Do substantive source/config/build-diary work, not repeated status checks or synthetic activity. When a 3300 branch reaches a real information-gain stop, rotate according to the explicit 3300 order or select another open 3000 branch by expected information gain, community use, cross-machine value, coverage gap and inspectable evidence.
