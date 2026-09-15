# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.

Do not reopen or repoll closed 2000 work unless a genuinely new material defect is discovered.

## Active curriculum level

**3000 — machine-specific specialization. 3900 has reached a bounded breadth stop and is ready for branch rotation.**

Latest 3900 checkpoint: `checkpoints/3900-next-2026-09-15c.md`.

3100 reached a clean breadth stop after real ATC, probing/tool-setting, VFD/readiness and auxiliary-authority work. 3200, 3300, 3400, 3500, 3700 and 3800 remain open/paused; 3600 retains its documented information-gain stop. Branch-local stops do not imply graduation.

## 3100 — Mills / VMCs

Status: **OPEN / PAUSED at bounded breadth stop**. Latest checkpoint: `checkpoints/3100-next-2026-09-15.md`.

Preserved conclusions include separate M6 physical transfer/logical tool/G43 state; M19 request/ack/fault/timeout; probe `#5070` validity; WCO versus persistent G10 L1 tool calibration; measurement-path validity; spindle/VFD and gravity-axis readiness; and the rule `status available != status trustworthy != status used as authority`.

## 3200 — Lathes / Turning Centers

Paused after substantial spindle synchronization/G76, index/at-speed, turret/carousel and CSS/X-origin source work. Latest checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

## 3300 — Plasma / Laser / Waterjet

Latest checkpoint: `checkpoints/3300-next-2026-09-14f.md`. Plasma QtPlasmaC P1/P2/P3 are mature enough for breadth rotation. Laser covers native laserpower/raster, Sector67 Raycus integration and QtPlasmaC laser mode. Waterjet preserves separate water/abrasive/height authority while complete public pump-pressure-ready/recovery source remains a gap.

## 3400 — Routers / Woodworking

Latest checkpoint: `checkpoints/3400-next-2026-09-14d.md`. Preserves two ATCs, pneumatic/tool identity, dust-shoe state, spindle/VFD readiness, synchronized gantry homing and custom Motion-DOUT abort boundaries.

## 3500 — Robots / Custom Kinematics

Status: **OPEN / PAUSED at bounded breadth stop**. Latest checkpoint: `checkpoints/3500-next-2026-09-14c.md`. Preserves separation of trajectory-command freshness, HAL command storage/shaping, EtherCAT health, CiA-402 state, software quick stop and independent STO/safety authority, plus genserkins physical-home/DH/coupling/solver distinctions.

## 3600 — Press Brakes

Not graduated. Preserve documented branch-local information-gain stop and bounded unknowns. Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

## 3700 — Grinding / EDM / Specialty Finishing

Status: **OPEN / PAUSED at bounded breadth/source stop**. Latest checkpoint: `checkpoints/3700-next-2026-09-14.md`. Preserves separate EDM geometry/adaptive motion, gap-feed, spark, wire/tension/break and dielectric/flushing authorities, plus servo/direct-scale versus binary hydraulic grinder architectures.

## 3800 — Saws / Feeders / Indexing / Automation Cells

Status: **OPEN / PAUSED at bounded breadth stop**. Checkpoint: `checkpoints/3800-next-2026-09-14.md`. Preserves encoder-position versus material stability, command versus physical completion, ClassicLadder STOP semantics, extra-joint planning, carousel in-position versus lock proof, supervisory freshness and locking-indexer transaction behavior.

## 3900 — Emerging / Unusual Machines

Status: **OPEN / PAUSED at bounded breadth stop**.

Authoritative artifacts now include:

- `research/3900-emerging-unusual-breadth-additive-first-pass-2026-09-15.md`
- `research/3900-remora-additive-second-implementation-authority-audit-2026-09-15.md`
- `research/3900-winding-rotary-synchronization-bounded-survey-2026-09-15.md`
- `research/3900-genhexkins-convergence-failure-authority-trace-2026-09-15.md`
- `checkpoints/3900-next-2026-09-15c.md`

Preserved conclusions:

- LinuxCNC-RepRap and Remora provide two materially different inspectable additive architectures.
- Remora uses coordinated A/joint-4 extrusion, remote-MCU thermistor/PWM endpoints, LinuxCNC PID, and communication status tied into machine enable.
- Remora's temperature path updates at 1 Hz and provides a limited PV=999 sensor-error sentinel, but no complete freshness/runaway/failure-to-heat/thermal-readiness contract was found.
- Durable additive rule: **temperature scalar != fresh/valid temperature != heater authority != thermal readiness != extrusion/material-flow correctness**.
- Coordinated extrusion proves geometric coupling, not deposited-material correctness.
- Public LinuxCNC winding evidence supports coordinated rotary/traverse geometry, but production tension/material-break/restart authority remains source-thin. Preserve **rotary/traverse coordination != winding-process correctness**.
- Native `genhexkins` forward kinematics is iterative and seed/nearby-solution dependent; convergence/failure is observable, but numerical convergence does not prove intended physical assembly branch or safe mechanical workspace.
- On a hexapod, ordinary-looking tool-offset changes can create physical joint transitions; source warns against G43/G49 changes while tilted.

3900 should not be over-mined. Reopen only when stronger production additive/winding/parallel-kinematics evidence appears or another unusual class offers clearly higher transfer value.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Rotate from `checkpoints/3900-next-2026-09-15c.md` to the highest-information open 3000 branch. Prefer real source/config evidence. Run a lab only for a concrete nonduplicate uncertainty exposed by a real implementation; rotate branches on information-gain stops rather than repeating searches.
