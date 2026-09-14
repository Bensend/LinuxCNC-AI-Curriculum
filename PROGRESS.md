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

Current active branch: **3200 — Lathes / Turning Centers**.

Latest active checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

## 3200 — Lathes / Turning Centers

Pinned LinuxCNC revision for current source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

### Durable artifacts

Foundation:

- `research/3200-lathe-spindle-sync-foundation-2026-09-14.md`
- `research/3200-g76-pass-generation-source-trace-2026-09-14.md`
- `research/3200-spindle-index-readiness-config-comparison-2026-09-14.md`
- `research/3200-lathe-turret-toolchange-boundary-2026-09-14.md`
- `research/3200-css-x-origin-control-boundary-2026-09-14.md`

Continuation:

- `research/3200-toolchange-abort-ack-ownership-2026-09-14.md`
- `research/3200-lathe-carousel-public-implementation-2026-09-14.md`
- `research/3200-spindle-sync-pause-index-failure-2026-09-14.md`
- `research/3200-lathe-tool-identity-offset-compensation-2026-09-14.md`
- `research/3200-spindle-orient-caxis-mode-ownership-2026-09-14.md`

### Current established contracts

#### Spindle synchronization / G33 / G76

- G76 pass geometry and sequencing are expanded by the interpreter; realtime TP/Motion owns synchronized segment execution.
- Spindle command, at-speed readiness, index/phase acquisition and ongoing feedback validity are distinct evidence surfaces.
- TP has separate waiting-for-index and waiting-for-at-speed states.
- Missing required index does not silently start position-synchronized motion.
- Ordinary pause does not feed-scale an active `TC_SYNC_POSITION` segment to zero mid-thread; LinuxCNC preserves synchronization through the active segment. Abort is a different ownership/recovery class.
- Upstream TP regression inputs include simple G33, multi-segment/blended G33, rigid tapping and at-speed programs, but the inspected harness is not a dedicated missing-index/pause-cycle fault injector.

#### Tool-change / turret ownership

- `iocontrol.0` prepare/change completion is a level handshake: request AND acknowledgement.
- `emcIoAbort()` drops tool-change/prep requests and explicitly returns IO status to DONE; the upstream abort-during-change regression independently confirms recovery and that an unfinished tool is not falsely installed.
- The basic handshake has no per-request generation ID, so external turret logic must make acknowledgements request-scoped. A stale held-high `tool-changed` / `tool-prepared` is an integration hazard.
- A real public five-position lathe ATT in LinuxCNC issue #2025 uses `tool-change -> carousel.enable`, physical index/pulse sensing, `carousel.motor-vel -> stepgen`, and `carousel.ready -> tool-changed`.
- The inspected carousel mechanism includes a reverse-latch phase and request-release state. Its `ready` is valid for that mechanism, but cannot be generalized as universal proof of hydraulic clamp/down/shot-pin state on heavier turrets.
- GUI/current-tool identity is not physical turret-position evidence.

#### Tool identity / offsets / compensation

- A fixed-station lathe turret is a LinuxCNC **nonrandom** changer even when physically circular.
- Preserve tool number, physical station/pocket, internal tooldata index, selected/prepared target, current tool, active G43 offset and cutter/nose compensation as distinct state.
- `Txxx` selection/preparation is not M6 physical completion.
- `G43` offset authority is separate from current-tool identity.
- Native D-word semantics belong to cutter/nose compensation lookup; do not assume a commercial-control-style `T0101 = station 1 + wear register 1` without an explicit remap/application contract.
- `M61` changes software current-tool identity without physical toolchanger motion and therefore cannot prove turret reconciliation.

#### Spindle orientation / C-axis / live tooling

- Native M19 is a discrete spindle-orientation transaction with target angle, direction/index mode, Q timeout, `orient`, `is-oriented`, `orient-fault` and `locked` surfaces. It is not a continuously coordinated C coordinate.
- Pinned `orient.comp` supplies orient position-command generation, optional index reacquisition and debounced in-position completion for an orient PID.
- Indexed live-tool operations may use M19 without a full C axis. Continuous coordinated milling requires actual C-axis trajectory ownership.
- A dual-role spindle/C-axis must arbitrate velocity command, C position command, encoder feedback, index-enable, PID/drive mode, homing/reference state, brake/inhibit and stale command ownership.
- LinuxCNC issue #3556 documented a real shared-`index-enable` ownership bug that could make G33 rapid instead of synchronize. Merged PR #4200 fixed the cause by preventing idle homing from clamping a shared `HAL_IO` signal.
- Same-hardware testing confirmed the fix. The pinned revision is 638 commits ahead of PR #4200's merge commit; the old disconnect-joint-index workaround is historical and must not be taught as current generic behavior.
- A current 2026 field C-axis implementation uses M19 to align the spindle before reconnecting C feedback/PID and explicitly neutralizes spindle command authority during ownership transfer. Its reported latent-M3 incident reinforces the stale-command hazard.
- Model the dual-role spindle as an ownership state machine (`SPINDLE_SPEED`, `ORIENT`, `C_AXIS`, plus machine-specific fault/reconcile/maintenance states), not merely as a command mux.

### 3200 lab decision

No new lab was launched for the latest passes because source/upstream regression/real-machine evidence already resolves the current questions more strongly than a synthetic duplicate.

Future labs are justified only for a real remaining evidence gap, for example:

- stale tool acknowledgement across a new request;
- post-index spindle feedback freeze/jump;
- pause/feed-inhibit/abort comparison in one synchronized-motion trace;
- bumpless spindle-to-C transfer;
- stale M3/S reactivation during ownership transfer;
- drive-mode acknowledgement failure or abort mid-transfer.

### Exact next 3200 work

1. **Chuck / collet / tailstock / steady-rest integration** — inspect real configs/components; separate command, physical open/closed/clamped witnesses, permissives, continuation acknowledgement, partial-cycle abort and recovery.
2. **Lathe probing / tool setter** — inspect tool-touch/probe workflows; separate measurement event, validity, calculated geometry update, persistence and active-offset refresh; cover already-tripped/no-trip/wrong-tool/stale-offset failures.
3. **Lathe HMI/operator workflow** — compare AXIS/Gmoccapy/QtVCP and inspect at least one community/production HMI; define minimum diagnostic surfaces for spindle sync, turret, current/active tool offsets, C-axis ownership, workholding and recovery state.
4. **Spindle/live-tool follow-up only if new implementation evidence appears** — inspect complete downloadable dual-role configs, drive-mode acknowledgement, brake/lock and coordinated live-tool programming rather than inventing generic behavior.
5. **Tool-table follow-up only where it adds evidence** — cutter-comp orientation/nose-radius implementation or explicit commercial-style wear remaps.
6. If 3200 reaches a real information-gain stop, rotate to another underdeveloped 3000 track rather than manufacturing more lathe simulation.

## 3600 — Press Brake specialization state

The 3600 specialization is **not graduated**. With the 2000 series closed, its prior preparation is valid 3000-level prerequisite evidence and should be integrated rather than repeated.

Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

Current preserved contracts include:

- PB-BG-001 through PB-BG-004: TEST-CONFIRMED backgauge command/target episode ownership and stale-generation protection;
- PB-DXF-001 through PB-DXF-004: TEST-CONFIRMED `ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet -> ExecutionEpisode` provenance chain;
- program abort/restart requires reconciliation and a fresh runtime episode rather than stale motion replay;
- machine reference/calibration, nominal process calculation, empirical first-piece correction, pressure command/feedback/derived force and external safety observation remain distinct;
- tooling/material/bend-technology/table semantics require explicit provenance;
- measured bend angle is a process measurement channel, not a fake commanded axis.

Preserved 3600 unknowns:

- `PB-PREP-001` remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**. Do not retune its frozen discriminator.
- A downloadable tandem Y1/Y2 implementation exposing exact correction insertion/saturation/addf/ferror/fault behavior remains unavailable.
- A real inspectable sensor-bending closed-loop implementation remains unavailable; do not invent an angle PID topology.
- Unknown bend-table semantics, interpolation policy, empirical origin and target-machine hydraulic/tooling/material/pressure/safety values must remain UNKNOWN when not evidenced.

Generic 3600 preparation is at an information-gain stop until new inspectable implementation/source appears; this stop is branch-local and must not block other 3000 tracks.

## Laboratory compute checkpoint

The authoritative ledger contains **338.56 minutes (5.64 h)** of exactly backfilled laboratory compute through the last recorded checkpoint. Historical gaps mean this is not a trustworthy full-project total.

`LAB_COMPUTE_LOG.md` remains authoritative for individual job timestamps. Latest recorded lab result remains PB-BG-004 (`lab-jobs/089-pb-bg-004-targetset-runtime-episode.sh`), workflow `34670275431`, frozen Gates A–J 10/10.

## Global next-work rule

Continue from `checkpoints/3200-lathe-next-2026-09-14b.md`.

Do substantive source/config/build-diary work, not repeated status checks or synthetic activity. When the active branch reaches a real information-gain stop, rotate to another open 3000 branch using expected information gain, community use, cross-machine value, coverage gap and availability of inspectable implementations.
