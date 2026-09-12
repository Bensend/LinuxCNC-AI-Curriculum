# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed historical progress remains preserved in Git history and in the referenced research/results/evaluation artifacts; this file is the current dependency/checkpoint view.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

The genuinely information-separated prerequisite evaluation is preserved at `evaluation/fresh-ai-evaluation-2026-09-11-valid.md`. It validly evaluated the exact authoritative packets from `evaluation/fresh-ai-packet-manifest.md` and returned:

- **S02 — PASS**
- **E20 — PASS**
- **X01 — PASS**
- **X02 — PASS**

No corrections were required. Their former fresh-AI-only blockers are satisfied. The previous PROGRESS snapshot that still described those four handoffs as pending is historical and must not be used to re-block F02.

### F02 — compound-fault diagnosis/recovery integration

F02 is **TECHNICALLY ACCEPTED / FRESH-AI HANDOFF PENDING**.

Durable F02 evidence:

- source/documentation/community/function/call-flow pass: `research/F02-compound-fault-source-community-pass-2026-09-11.md`;
- frozen experiment: `experiments/F02-001-compound-fault-arbitration-plan.md`;
- implementation: `lab-jobs/082-f02-compound-fault-arbitration.sh`;
- authoritative workflow `34657204415`, source commit `4d3277d1d11b60cf68126c65190d7ee42886f8e8`;
- retained 19-row trace: `lab-results/f02-001/raw.csv`;
- frozen Gates A–J: **10/10 PASS**;
- independent audit: `results/F02-001-authoritative-audit.md`;
- separately frozen adversarial exam: **20/20 PASS**;
- closeout state: `evaluation/2000-series-closeout-state-2026-09-11.md`;
- final transfer packet: `handoffs/F02-fresh-ai-compound-fault-transfer.md` — **PREPARED / UNSCORED**.

The **sole known 2000-series graduation gate** is a genuinely information-separated evaluation of exactly `handoffs/F02-fresh-ai-compound-fault-transfer.md`. The current learner must not self-score it or expose `exams/F02-adversarial-answers-and-score.md` / `results/F02-001-authoritative-audit.md` to that evaluator before it answers.

If the correctly routed F02 evaluator returns PASS with no required corrections, graduate F02 and close the 2000 series unless that evaluation discovers a new material defect. A valid FAIL/CONDITIONAL PASS triggers only the corrections identified by the evaluator.

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

## Dependency-safe 3600 press-brake preparation

The 3600 specialization is **not graduated**. Until F02 closes, this work remains dependency-safe preparation. Existing experiments and research should be integrated as prerequisites when 3600 formally activates rather than blindly repeated.

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

## Current information-gain stop

Generic 3600 preparation has reached a deliberate information-gain stop. Do not extend synthetic ownership fixtures, generic bend calculators, equivalent bend-table examples or toy interpolation fixtures merely to create activity. Resume a branch only when real source/documentation resolves a concrete remaining implementation question.

Highest-value evidence opportunities are:

1. a downloadable tandem Y1/Y2 implementation exposing scale producers, common commands, differential sign, exact correction insertion, downstream limits/saturation, addf order, per-side ferror and fault/disable behavior;
2. a real sensor-bending implementation exposing acquisition freshness/generation, phase, correction authority, saturation and recovery;
3. implementation-level process-calculation evidence such as measured-coupon fitting/table generation, a real flange/gauging-surface-to-backgauge target solver with explicit datums/tool geometry, or a production tooling/method calculator whose actual source consumes its declared tooling inputs.

## Exact next-work checkpoint

1. **Re-check F02 first every session.** If an information-separated result exists, preserve its full identity header and response before changing status.
2. Correctly routed F02 PASS/no corrections => mark F02 GRADUATED and close the 2000 series; do not self-certify the transfer.
3. If F02 is still externally blocked, keep 3600 at the current information-gain stop unless genuinely new public implementation/source becomes available.
4. Preserve PB-PREP-001 as INCONCLUSIVE / no architecture recommendation; do not retune its frozen discriminator.
5. Preserve the measured-angle closed-loop topology as SOURCE UNAVAILABLE until real evidence resolves it.
6. Preserve UNKNOWN for bend-table full/half semantics, angle convention, dimensional datum, calculation engine, interpolation/out-of-range policy or empirical origin whenever evidence does not establish them.
7. Do not invent target-machine hydraulic, tooling, material, pressure, springback, sensor-dynamics, stopping-performance, safety or acceptance-tolerance values.

Latest checkpoint artifact: `checkpoints/3600-tooling-angle-next-2026-09-12.md`.
