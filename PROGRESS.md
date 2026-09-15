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

**3000 — machine-specific specialization.** Current active branch: **3100 — Mills / VMCs**.

Latest active checkpoint: `checkpoints/3100-next-2026-09-15.md`.

3100 remains active after 3800 reached bounded breadth-level stops. Branch-local stops do not imply graduation. 3200, 3300, 3400, 3500, 3700 and 3800 remain open/paused; 3600 retains its documented information-gain stop.

## 3100 — Mills / VMCs

Status: **ACTIVE / BREADTH + FIELD PASS**.

Authoritative artifacts include:

- `research/3100-mills-vmcs-breadth-foundation-2026-09-14.md`
- `research/3100-vmc-atc-field-chronology-first-pass-2026-09-14.md`
- `research/3100-atcduino-inspectable-config-abort-boundary-2026-09-14.md`
- `research/3100-probing-tool-setting-authority-foundation-2026-09-14.md`
- `research/3100-real-toolsetter-probe-readiness-audit-2026-09-15.md`
- `research/3100-upstream-persistent-tool-calibration-trace-2026-09-15.md`
- `checkpoints/3100-next-2026-09-15.md`

Preserved conclusions:

- M6 physical transfer, logical tool identity and G43 tool-length-offset activation are separate states.
- M19 has explicit request/ack/fault/timeout semantics; spindle at-speed, phase/index synchronization and orient/locked are separate witnesses.
- Rigid tapping is spindle-synchronized motion, not spindle orientation.
- Real VMC ATCs differ materially and commissioning chronology matters.
- Probe coordinates require validity qualification; #5070 is the probe-success discriminator.
- A real machine combines probe + TLS through OR + debounce; debounce addresses transition quality but does not establish which sensor fired or whether the measurement path is semantically healthy.
- Double-touch does not imply persistent tool calibration: the real machine macro writes G10 L2 WCO, while upstream `qt_auto_probe_tool.ngc` performs dual #5070 checks, writes G10 L1 persistent tool-table Z and then applies G43.
- WCO touch-off, persistent tool-length calibration and measurement-path validity are separate authorities/products.
- The inspected real machine exposes independent tool-clamped/tool-released inputs and VFD-derived spindle-at-speed feedback.

Next: production-readiness auxiliaries—lube, coolant/chiller, chip handling, fixture/pallet and spindle/VFD ready/fault—with explicit `status available != status used as authority` analysis. Bounded stronger ATC search only if a named source appears. Rotate to 3900 when 3100 reaches a clean breadth stop.

## 3200 — Lathes / Turning Centers

Paused after a substantial source pass. Latest preserved checkpoint: `checkpoints/3200-lathe-next-2026-09-14b.md`.

Preserved work includes spindle synchronization/G76, real spindle readiness/index configurations, turret/carousel semantics and CSS/X-origin behavior. Do not restart generic 3200 searches without a later explicit rotation or materially new evidence.

## 3300 — Plasma / Laser / Waterjet

Latest preserved checkpoint: `checkpoints/3300-next-2026-09-14f.md`.

Plasma QtPlasmaC P1/P2/P3 are mature enough for breadth rotation. Laser work covers native `laserpower.comp`, `raster.comp`, Sector67 Raycus integration and QtPlasmaC `laser_mode`. Waterjet preserves separate water/abrasive/height authority while the complete public pump-pressure-ready/recovery contract remains a source gap.

## 3400 — Routers / Woodworking

Latest preserved checkpoint: `checkpoints/3400-next-2026-09-14d.md`.

The breadth/source pass preserves two materially different ATC implementations, pneumatic/tool-identity authority, dust-shoe state, spindle/VFD readiness/fault witnesses, synchronized gantry homing and the custom Motion-DOUT abort boundary. An already-applied custom `motion.digital-out-NN` is not generically cleared by Motion Abort/Disable; interrupted custom M6 recovery therefore requires explicit physical/logical reconciliation.

## 3500 — Robots / Custom Kinematics

Status: **OPEN / PAUSED at bounded breadth stop**.

Latest preserved checkpoint: `checkpoints/3500-next-2026-09-14c.md`.

Pinned Tormach/ZA6 work separates high-level trajectory command freshness, HAL command storage/shaping, EtherCAT slave health, CiA-402 drive state, software quick stop and independent STO/safety authority. The PUMA/genserkins pass preserves the separation between joint-mode success, physical home geometry, DH/frame correctness, mechanical coupling and inverse-solver/joint-limit failures.

## 3600 — Press Brakes

Not graduated. Preserve the documented branch-local information-gain stop and bounded unknowns. Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

## 3700 — Grinding / EDM / Specialty Finishing

Status: **OPEN / PAUSED at bounded breadth/source stop**.

Latest preserved checkpoint: `checkpoints/3700-next-2026-09-14.md`.

Wire-EDM work preserves distinct LinuxCNC geometry/adaptive motion, gap-feed, spark-generator, wire/tension/break and dielectric/flushing authorities. Grinding work separates servo/direct-scale grinders from binary hydraulic directional-table architectures. Reopen for materially stronger implementation evidence rather than generic searches.

## 3800 — Saws / Feeders / Indexing / Automation Cells

Status: **OPEN / PAUSED at bounded breadth stop**.

Preserved checkpoint: `checkpoints/3800-next-2026-09-14.md` plus `research/3800-supervisory-freshness-and-locking-indexer-reconciliation-2026-09-14.md`.

Preserved conclusions include encoder-position versus material stability, command versus physical completion, ClassicLadder STOP semantics, extra-joint posthome command planning, carousel in-position versus lock proof, supervisory command/heartbeat distinctions, and native locking-indexer transaction behavior. Reopen only for a named stronger implementation or concrete machine-specific question.

## 3900 — Emerging / Unusual Machines

Still underdeveloped and available for the next breadth rotation after 3100 reaches a bounded stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3100-next-2026-09-15.md`. Inspect real production-readiness auxiliaries and how their status is used as authority. Run a lab only for a concrete nonduplicate uncertainty exposed by a real configuration. Rotate to 3900 when 3100 reaches a clean breadth stop.
