# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed historical progress remains preserved in Git history and in the referenced research/results/evaluation artifacts; this file is the current dependency/checkpoint view.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The **2000 series — advanced control and diagnostics is GRADUATED / CLOSED as of 2026-09-14**. Final closeout is preserved at `evaluation/2000-series-closeout-state-2026-09-11.md` (finalized 2026-09-14).

Prerequisite information-separated evaluation is preserved at `evaluation/fresh-ai-evaluation-2026-09-11-valid.md`:

- **S02 — PASS**
- **E20 — PASS**
- **X01 — PASS**
- **X02 — PASS**

No corrections were required.

### F02 — compound-fault diagnosis/recovery integration

F02 is **GRADUATED at 2000 level**.

Durable F02 evidence:

- source/documentation/community/function/call-flow pass: `research/F02-compound-fault-source-community-pass-2026-09-11.md`;
- frozen experiment: `experiments/F02-001-compound-fault-arbitration-plan.md`;
- implementation: `lab-jobs/082-f02-compound-fault-arbitration.sh`;
- authoritative workflow `34657204415`, source commit `4d3277d1d11b60cf68126c65190d7ee42886f8e8`;
- retained 19-row trace: `lab-results/f02-001/raw.csv`;
- frozen Gates A–J: **10/10 PASS**;
- independent audit: `results/F02-001-authoritative-audit.md`;
- separately frozen adversarial exam: **20/20 PASS**;
- authoritative transfer packet: `handoffs/F02-fresh-ai-compound-fault-transfer.md`;
- valid information-separated evaluator result: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — **PASS, no corrections required, no graduation blocker**.

The fresh evaluator explicitly confirmed repository identity, exact packet path, information separation, non-use of prohibited learner-side answer/grading files, and returned PASS after independently answering tasks A–G. The former F02 handoff blocker is satisfied and must not be reintroduced from historical `PREPARED / UNSCORED` snapshots.

### Advanced HMI / QtVismach roadmap topic

`evaluation/2000-hmi-qtvismach-assessment-2026-09-14.md` records **PASS at approximately 93/100** for the 2000-level advanced HMI / QtVismach/live-3D scope. Remaining exact API/lifecycle details are version-specific implementation work and do not block 2000 graduation.

## Active curriculum level

The active curriculum level is now **3000 — machine-specific specialization** under `LEVEL_ORDER.md` and `CURRICULUM.md`.

Tracks are parallel specialization branches:

- 3100 — Mills / VMCs
- 3200 — Lathes / Turning Centers
- 3300 — Plasma / Laser / Waterjet
- 3400 — Routers / Woodworking
- 3500 — Robots / Custom Kinematics
- 3600 — Press Brakes
- 3700 — Grinding / EDM
- 3800 — Saws / Feeders / Automation Cells
- 3900 — Emerging / Unusual Machines

The most recently active branch is **3200 — Lathes / Turning Centers**. Latest durable checkpoint: `checkpoints/3200-lathe-next-2026-09-14.md`.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10.
- BL-DEV-002 VALID 9/10.
- BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention remains separate; the immediate transfer success is not long-term retention evidence.
- Sealed benchmark answers remain information-separated. Do not reveal learner-side hidden answers to accelerate evaluation.

See `evaluation/BLIND_FEEDBACK_PROTOCOL.md` and `evaluation/FEEDBACK_SCORE_LOG.md`.

## Laboratory compute checkpoint

The authoritative ledger currently contains **338.56 minutes (5.64 h)** of exactly backfilled laboratory compute, including **0.87 minutes** exactly backfilled for 2026-09-12. Historical gaps still mean this is not a trustworthy full-project total.

`LAB_COMPUTE_LOG.md` is authoritative for individual job timestamps. PB-PREP-001 historical runs 073–077 are already integrated there; do not append them again. No laboratory compute was consumed in the 2026-09-12 bend-calculation/table source passes.

Latest lab result remains PB-BG-004 (`lab-jobs/089-pb-bg-004-targetset-runtime-episode.sh`), workflow `34670275431`, which passed frozen Gates A–J 10/10 under the narrow TargetSet-generation/runtime-episode boundary.

## 3600 press-brake specialization state

The 3600 specialization is **not graduated**. With the 2000 series now closed, its prior dependency-safe preparation becomes valid 3000-level prerequisite evidence and should be integrated rather than repeated blindly.

Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

### Y1/Y2 / hydraulic architecture

- `PB-PREP-001` remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** under its frozen contract. Do not strengthen its P6 discriminator or run architecture C merely to search for a preferred result.
- Public Ursviken/Pullmax evidence supports bounded real-machine feasibility of separate Y1/Y2 position loops plus a differential sync loop, but the final downloadable source remains unavailable; exact correction insertion, final saturation, ferror ownership and realtime order remain open.
- Public Accurpress chronology remains a useful architecture-evolution case study: hybrid ownership ambiguity -> standalone custom ownership -> improved read/compute/write order and pressure integration -> later regular-use report.
- Semantic press-cycle state, LinuxCNC motion ownership, differential synchronization, machine-specific hydraulic decoding, electrical/drive interface and functional-safety boundary remain separate layers.

### Backgauge and runtime command ownership

PB-BG-001 through PB-BG-004 are TEST-CONFIRMED bounded preparation artifacts. Current contract includes:

- manual jog and typed-position ownership;
- homing/reference authority;
- extra-joint `posthome-cmd` behavior;
- planner shaping distinct from authorization;
- application-owned command/target episode identity;
- atomic completion/`at-position` predicate;
- TargetSet generation -> fresh ExecutionEpisode transition;
- stale generations/episodes cannot silently regain authority after invalidation.

### CAD/DXF and bend-program data model

PB-DXF-001 through PB-DXF-004 are TEST-CONFIRMED bounded preparation artifacts. Current data chain is:

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet -> ExecutionEpisode`

with explicit revision/provenance boundaries. DXF bend lines are geometry, not guaranteed process semantics; UNKNOWN metadata must be preserved; automatic sequencing must not be inferred from geometry alone.

### Program execution/recovery

Pinned LinuxCNC Task source confirms ordinary Pause/Resume and abort-class behavior must not be conflated. `emcTaskAbort()` aborts motion, clears pending Task/interpreter state and closes/resets the task plan. A selected BendStep may remain operator context, but abort/restart/reference loss requires reconciliation and a fresh runtime episode rather than replay of stale motion authority.

### Calibration, correction, HMI and pressure/crowning

Current durable contracts separate:

- machine reference/calibration from product correction;
- nominal requested geometry from empirical first-piece correction;
- correction scope/revision from TargetSet generation;
- LinuxCNC controller state from BendStep/program state, runtime authorization and external safety-chain observation;
- pressure command/feedback, derived force/tonnage and crowning state.

Machine-specific numeric limits, acceptance tolerances, hydraulic truth tables, pressure/force models and safety requirements remain intentionally unclaimed.

### Tooling, material, bend technology and springback

Current source/documentation pass adds explicit provenance for:

- material identity/revision;
- punch/die/tool geometry revision;
- bend-technology revision;
- K-factor or other bend-calculation convention;
- nominal bend allowance/deduction and springback/overbend model;
- machine-specific TargetCalculation;
- empirical correction revision;
- generated TargetSet and runtime ExecutionEpisode.

Durable artifacts:

- `research/press-brake-tooling-material-springback-ownership-2026-09-12.md`;
- `research/press-brake-bend-technology-table-provenance-2026-09-12.md`;
- `research/press-brake-bend-allowance-public-source-audit-2026-09-12.md`;
- `research/press-brake-empirical-bend-table-semantics-2026-09-12.md`.

The public bend-calculation source audit adds two concrete failure classes. One calculator implements the conventional `BA = angle_rad*(R+K*T)` relation but permits a 180-degree endpoint where its tangent-based outside setback diverges. A second flat-pattern/DXF generator exposes K-factor and bend radius in its schema/UI while its actual geometry path ignores both and uses fixed `BD = 1.8*thickness`. Therefore calculation provenance must include the implementation/version and the **actual consumed-input set**, not merely values present in a UI or schema.

The empirical-table pass shows that a "bend table" is not one portable semantic object. Public CAD documentation includes full/half deduction, compensation and actual-radius table meanings, explicit angle/datum semantics, and tooling-indexed lookup axes. Pinned FreeCAD SheetMetal source further shows lookup-engine provenance matters: at the same repository revision, the legacy unfold path uses a non-interpolating range/step lookup while the newer unfold path uses endpoint clamping plus piecewise-linear interpolation. With the workbench's own test table `{1:0.38, 3:0.43, 99:0.50}`, `R/T=4` yields `K=0.50` in the legacy path versus approximately `0.430729` in the newer path.

A naked numeric K-factor, raw bend-table rows, or a project name without semantic/engine identity is therefore insufficient provenance. No universal K-factor, interpolation rule, springback or press-Y formula is claimed.

### Measured angle / sensor bending

Measured bend angle is modeled as a **process measurement channel**, not a fake commanded axis and not the same state as requested angle, nominal springback technology or accepted empirical correction.

Durable artifacts:

- `research/press-brake-measured-angle-sensor-boundary-2026-09-12.md`;
- `research/press-brake-sensor-bending-public-source-audit-2026-09-12.md`;
- `research/press-brake-measurement-only-qtvcp-display-2026-09-12.md`.

At pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`, HostMot2 encoder `position` is a measured HAL output; `position-interpolated` is separate and the documentation explicitly says not to use it for position control. QtVCP `HALLabel` can display a HAL float input directly, so measurement-only HMI data does not require inventing a commanded W joint.

A bounded public search found commercial sensor-bending feature documentation and LinuxCNC community use cases but **no inspectable public LinuxCNC press-brake sensor-bending implementation** exposing acquisition timing, phase qualification, correction insertion, Y1/Y2 interaction, saturation, stale/fault handling and recovery. Generic realtime sensor-bending topology is therefore **SOURCE UNAVAILABLE / UNKNOWN**; do not invent an `angle PID` merely because a toy loop can converge.

The frozen tooling/angle adversarial review `exams/PB-DOMAIN-tooling-angle-adversarial-2026-09-12.md` scored **16/16 PASS** in `exams/PB-DOMAIN-tooling-angle-adversarial-answers-2026-09-12.md`; no correction to the current ownership/provenance teaching was required.

## Current 3600 information-gain stop

Generic 3600 preparation has reached a deliberate information-gain stop. Do not extend synthetic ownership fixtures, generic bend calculators, equivalent bend-table examples or toy interpolation fixtures merely to create activity. Resume a branch only when real source/documentation resolves a concrete remaining implementation question.

Highest-value 3600 evidence opportunities are:

1. a downloadable tandem Y1/Y2 implementation exposing scale producers, common commands, differential sign, exact correction insertion, downstream limits/saturation, addf order, per-side ferror and fault/disable behavior;
2. a real sensor-bending implementation exposing acquisition freshness/generation, phase, correction authority, saturation and recovery;
3. implementation-level process-calculation evidence such as measured-coupon fitting/table generation, a real flange/gauging-surface-to-backgauge target solver with explicit datums/tool geometry, or a production tooling/method calculator whose actual source consumes its declared tooling inputs.

## Exact next-work checkpoint

The 2000 series is closed; **do not re-check F02 as a recurring gate** unless a material defect in the preserved evaluation is later discovered.

Current priority is substantive 3000-series specialization work. The latest active branch is 3200 Lathes / Turning Centers:

1. Continue from `checkpoints/3200-lathe-next-2026-09-14.md`.
2. Finish the iocontrol/tool-change source trace, especially abort/restart and stale acknowledgement semantics.
3. Inspect one complete public lathe turret implementation and map physical clamp/lift/lock witnesses to `tool-changed`.
4. Inspect TP spindle-sync pause/resume/index-failure behavior and upstream synchronized-motion/threading tests.
5. Only freeze a fault lab if that inspection leaves a real non-duplicate evidence gap.
6. Continue 3200 breadth afterward: tool-table/turret conventions, spindle orient/C-axis/live tooling, chuck/tailstock, probing and HMI.
7. If 3200 hits an information-gain stop, rotate to another underdeveloped 3000 track rather than returning to already-closed 2000 material.
8. Preserve 3600's current bounded unknowns: PB-PREP-001 remains INCONCLUSIVE/no architecture recommendation; measured-angle closed-loop topology remains SOURCE UNAVAILABLE until real evidence resolves it; unknown bend-table semantics and machine-specific hydraulic/tooling/material/pressure/safety values must not be invented.

Latest active checkpoint artifact: `checkpoints/3200-lathe-next-2026-09-14.md`.
