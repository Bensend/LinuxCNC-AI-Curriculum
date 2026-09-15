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

**3000 — machine-specific specialization. Current active branch: 3900 — Emerging / Unusual Machines.**

Latest active checkpoint: `checkpoints/3900-next-2026-09-15b.md`.

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

Status: **ACTIVE / BREADTH + ADDITIVE AUTHORITY PASS**.

Authoritative artifacts:

- `research/3900-emerging-unusual-breadth-additive-first-pass-2026-09-15.md`
- `checkpoints/3900-next-2026-09-15b.md`

Preserved conclusions:

- Additive/extrusion is the first selected unusual class because it adds thermal/process authority rather than duplicating 3500 robot kinematics.
- Inspectable LinuxCNC-RepRap uses coordinated LinuxCNC motion plus a fourth stepgen for extrusion/feed and custom realtime thermistor acquisition.
- `ADC2Temp` updates its visible temperature only when `NewValue` toggles; no separate sample-age/freshness or thermistor-health witness was found in the inspected path.
- Heater authority in the inspected HAL is a hysteresis comparator driving a heater output; no production thermal-runaway/failure-to-heat/max-temperature/freshness contract was found.
- Durable rule: **temperature value != fresh/valid temperature != heater authority != extrusion-ready**.
- Native `genhexkins` remains a later unusual-machine target, but future work should focus on convergence/failure/switching authority rather than duplicate 3500 serial-robot IK work.

Next: find a stronger second real additive/hybrid implementation and compare readiness/fault/recovery authority. If source is exhausted, rotate within 3900 to winding/rotary synchronization or a bounded genhexkins convergence/failure trace.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3900-next-2026-09-15b.md`. Prefer real source/config evidence. Run a lab only for a concrete nonduplicate uncertainty exposed by a real implementation; rotate branches on information-gain stops rather than repeating searches.
