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

**3000 — machine-specific specialization.** Current active branch: **3700 — Grinding / EDM / Specialty Finishing**.

Latest active checkpoint: `checkpoints/3700-next-2026-09-14.md`.

3700 was activated after 3500 reached a bounded breadth/source stop. Branch-local stops do not imply graduation. 3200, 3300, 3400 and 3500 remain open/paused; 3600 retains its documented information-gain stop.

## 3200 — Lathes / Turning Centers

Paused after a substantial source pass. Latest preserved checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

Preserved work includes spindle synchronization/G76, real spindle readiness/index configurations, turret/carousel semantics and CSS/X-origin behavior. Do not restart generic 3200 searches without a later explicit rotation or materially new evidence.

## 3300 — Plasma / Laser / Waterjet

Latest preserved checkpoint: `checkpoints/3300-next-2026-09-14f.md`.

### Plasma

QtPlasmaC P1/P2/P3 are mature enough for breadth rotation. Preserved evidence covers process state and external-offset ownership, THCAD/Arc OK commissioning failures, material/process state reconstruction, PMX485 communications boundaries, small-hole velocity/overcut transformation and field integration. Reopen for stronger downloadable field configs, current CAM-post provenance, tandem production evidence or a named recovery problem.

### Laser

Preserved work covers native `laserpower.comp`, `raster.comp`, M62/M63/M67/M68 semantics, real public implementations, the Sector67 Raycus config, and the upstream QtPlasmaC `laser_mode` history. `laser_mode` is a real fiber-height-control adaptation, not a complete fiber process controller. Native `laserpower.comp` is reusable infrastructure, not proven dominant production architecture.

### Waterjet

Real evidence supports separate water/nozzle and abrasive authority plus nominal-Z versus cutting-height correction. No inspectable complete `pump/intensifier -> pressure READY/fault -> cut authorization -> recovery` LinuxCNC contract was found in the bounded pass. Keep that absence as a source gap, not proof of nonexistence.

## 3400 — Routers / Woodworking

Latest preserved checkpoint: `checkpoints/3400-next-2026-09-14d.md`.

The breadth/source pass now preserves two materially different ATC implementations, pneumatic/tool-identity authority, dust-shoe state, spindle/VFD readiness/fault witnesses, synchronized gantry homing and the custom Motion-DOUT abort boundary.

Key rule: an already-applied custom `motion.digital-out-NN` is not generically cleared by Motion Abort/Disable; interrupted custom M6 recovery therefore requires explicit physical/logical reconciliation. The generic DOUT lab was dropped as duplicate evidence.

## 3500 — Robots / Custom Kinematics

Status: **OPEN / PAUSED at bounded breadth stop**.

Latest preserved checkpoint: `checkpoints/3500-next-2026-09-14c.md`.

Authoritative new artifacts include:

- `research/3500-za6-runtime-stale-command-fault-containment-source-trace-2026-09-14.md`
- `research/3500-za6-launch-supervision-controller-death-boundary-2026-09-14.md`
- `research/3500-puma200-genserkins-field-commissioning-chronology-2026-09-14.md`
- `research/3500-genserkins-inverse-failure-field-reconciliation-2026-09-14.md`

### ZA6 / ROS2 authority result

Pinned Tormach source separates high-level trajectory command, HAL command storage/shaping, EtherCAT slave health, CiA-402 drive state, software quick stop and independent STO/safety authority.

`hw_device_mgr` detects lcec online/oper loss and drive faults; `drive_safety` provides cross-drive quick-stop-compatible containment for explicit triggers. No high-level command age/generation/heartbeat witness was found downstream of `hal_hw_interface.*.position_cmd`. `hal_control_node` can set `cm_ok=0` and stop ControllerManager read/update/write without a source-visible command reset, and no use of that `cm_ok` pin was found in the pinned ZA6 config as a drive/quick-stop permissive.

Preserve: **fieldbus healthy != command fresh** and **software quick stop != STO**.

### Native robot field/source result

The PUMA 200 field chronology proves that working joint mode does not validate Cartesian kinematics. The repair path separated singularity, exact physical home pose, modified-DH geometry/signs, coupled wrist transmission and actual machine gear ratios. Family documentation contained gearing for another PUMA 2xx variant, forcing physical verification.

Pinned genserkins source confirms iterative Jacobian inverse behavior: Jacobian construction/inversion can fail before iteration exhaustion, convergence is seed-dependent, and downstream limits/following errors remain separate from inverse-solver failure.

3500 should reopen for a materially different inspectable real robot implementation, exact ZA6 controller/heartbeat provenance, or a named runtime timing question—not another generic stale-command or genserkins search.

## 3600 — Press Brakes

Not graduated. Preserve the documented branch-local information-gain stop and bounded unknowns. Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

## 3700 — Grinding / EDM / Specialty Finishing

Status: **ACTIVE / SOURCE**.

Latest checkpoint: `checkpoints/3700-next-2026-09-14.md`.

Authoritative breadth/deep artifacts include:

- `research/3700-grinding-edm-specialty-breadth-audit-2026-09-14.md`
- `research/3700-grinding-edm-breadth-survey-2026-09-14.md`
- `research/3700-edm-adaptive-feed-source-trace-2026-09-14.md`

### EDM

LinuxCNC has a native adaptive-motion primitive explicitly relevant to EDM. With M52/adaptive feed enabled, realtime Motion samples `motion.adaptive-feed`, clips it to `+-MAX_FEED_OVERRIDE`, uses magnitude for feed scaling and sign for trajectory-planner direction. A requested sign reversal calls `tpSetRunDir()`; if direction cannot change immediately, Motion forces adaptive scale to zero so the path stops/decelerates before reversing. Feed hold/inhibit remain separate authorities.

Thus negative adaptive feed is an explicit path-direction state transition, not a naive negative velocity multiplier. It still does not implement spark-gap logic, spark power, wire, dielectric/flushing or recovery.

A real Sodick A320s retrofit provides field evidence for separate X/Y/U/V, wire run/tension, spark-source replacement, material/process recipes and gap-voltage adaptive control. Wire EDM and sinker EDM remain distinct branches.

Exact next source question: trace trajectory reverse behavior through segment boundaries and synchronized M62/M63/M67 process outputs. Do not assume reverse path reconstructs output chronology.

### Grinding

Breadth evidence already separates servo/ballscrew grinders, hydraulic directional-valve grinders and later nonround/cam grinding. Direct linear feedback changes loop topology and does not erase mechanical compliance/backlash. High-value next comparison is wheel/dresser/infeed/spark-out authority across real servo and hydraulic grinder implementations.

### Specialty finishing

Honing remains prepared as a later subbranch. Do not let it displace the current EDM reverse-path source question.

## 3800 / 3900 and 3100

These remain parallel specialization branches for later work-selection rotation. Prefer genuinely underdeveloped tracks when the current 3700 evidence path reaches diminishing returns.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3700-next-2026-09-14.md`. First source-trace EDM trajectory reversal across segment boundaries and queued synchronized process outputs; then deepen one real wire-EDM process contract. Run a lab only if source leaves a real nonduplicate queued-I/O/reverse ambiguity. When EDM reaches a clean local stop, compare real servo and hydraulic grinder implementations before rotating to another underdeveloped 3000 branch.
