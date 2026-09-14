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

**3000 — machine-specific specialization.** Current active branch: **3800 — Saws / Feeders / Indexing / Automation Cells**.

Latest active checkpoint: `checkpoints/3800-next-2026-09-14.md`.

3800 was selected after 3700 reached bounded local stops for the wire-EDM public process contract and the first servo-versus-hydraulic grinder comparison. Branch-local stops do not imply graduation. 3200, 3300, 3400, 3500 and 3700 remain open/paused; 3600 retains its documented information-gain stop.

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

The breadth/source pass preserves two materially different ATC implementations, pneumatic/tool-identity authority, dust-shoe state, spindle/VFD readiness/fault witnesses, synchronized gantry homing and the custom Motion-DOUT abort boundary.

Key rule: an already-applied custom `motion.digital-out-NN` is not generically cleared by Motion Abort/Disable; interrupted custom M6 recovery therefore requires explicit physical/logical reconciliation. The generic DOUT lab was dropped as duplicate evidence.

## 3500 — Robots / Custom Kinematics

Status: **OPEN / PAUSED at bounded breadth stop**.

Latest preserved checkpoint: `checkpoints/3500-next-2026-09-14c.md`.

Pinned Tormach/ZA6 work separates high-level trajectory command freshness, HAL command storage/shaping, EtherCAT slave health, CiA-402 drive state, software quick stop and independent STO/safety authority. Preserve: **fieldbus healthy != command fresh** and **software quick stop != STO**.

The PUMA 200/genserkins field/source pass also proved that working joint mode does not validate Cartesian kinematics. Exact home geometry, modified-DH frames/signs, mechanical wrist coupling and actual gear ratios must be reconciled separately from inverse-solver, joint-limit and following-error failures.

## 3600 — Press Brakes

Not graduated. Preserve the documented branch-local information-gain stop and bounded unknowns. Integration map: `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`.

## 3700 — Grinding / EDM / Specialty Finishing

Status: **OPEN / PAUSED at bounded breadth/source stop**.

Latest preserved checkpoint: `checkpoints/3700-next-2026-09-14.md`.

Authoritative deep artifacts now additionally include:

- `research/3700-wire-edm-real-authority-openedm-reconciliation-2026-09-14.md`
- `research/3700-grinder-servo-vs-hydraulic-authority-comparison-2026-09-14.md`

### EDM

Pinned LinuxCNC source already established negative adaptive feed as a controlled trajectory-direction transition, not a naive negative velocity multiplier, and separately established that reverse trajectory traversal does **not** reconstruct synchronized process-output chronology.

The new real-process reconciliation preserves distinct authorities for:

- LinuxCNC X/Y/U/V(/Z) geometry and adaptive motion;
- gap-voltage acquisition/validation and feed-direction request;
- spark-generator enable/recipe/fault;
- wire feed/tension/break state;
- dielectric/flushing readiness;
- interrupted-cycle recovery.

The real Sodick A320s chronology demonstrates that successful XY/UV motion plus working wire transport still did not produce a useful production EDM without a capable spark generator. Adjacent OpenEDM source further demonstrates spark generation as an explicit realtime state machine and wire tension as a separate load-cell/PID loop with a low-tension stop threshold. These are architecture evidence, not a LinuxCNC production controller.

Exact public gap-law scaling/filtering/hysteresis, mature spark-generator handshake/fault behavior, wire-break restart/rethread and complete dielectric recovery remain unavailable in the bounded pass. Reopen 3700-E2 for materially stronger implementation evidence rather than generic searches.

### Grinding

The first deep comparison now separates:

- servo/ballscrew/direct-scale architectures, where direct scale closes around drivetrain error but does not remove backlash/compliance/stiction;
- hydraulic directional-table architectures, where binary LEFT/RIGHT reciprocation may be the correct machine abstraction rather than pretending a non-proportional valve is a servo axis.

Grinding process state—wheel readiness, dressing, workholding, coolant, infeed, spark-out and interrupted-cycle recovery—remains separate from axis position and needs a stronger mature field implementation before a full playbook is frozen.

## 3800 — Saws / Feeders / Indexing / Automation Cells

Status: **ACTIVE / SOURCE + FIELD DEEP PASS**.

Latest checkpoint: `checkpoints/3800-next-2026-09-14.md`.

Authoritative artifacts include:

- `research/3800-saws-feeders-indexing-automation-cells-breadth-audit-2026-09-14.md`
- `research/3800-saws-feeders-automation-breadth-survey-2026-09-14.md`
- `research/3800-classicladder-realtime-sequence-recovery-source-trace-2026-09-14.md`
- `research/3800-pick-place-feeder-supervisory-vs-realtime-authority-2026-09-14.md`

### Automatic saw / feeder field result

The Marvel V10A chronology supplies a concrete failure mode: an encoder-controlled hydraulic shuttle oscillated around target and then continued creeping from hydraulic leakage. Preserve:

**position in window != feeder/material stable**.

A defensible cutting transaction needs explicit treatment of feed target, physical stability, clamp ownership/proof, saw readiness and cut authorization.

### ClassicLadder source result

At pinned LinuxCNC revision `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`:

- `classicladder.0.refresh` is a realtime HAL function, but ladder scans are capped at no faster than 1 ms;
- the scan path is input copy -> ordered ladder/sequential evaluation -> output copy;
- Sequential/Grafcet transitions can cascade more than one step in the same scan while conditions remain true;
- the normal STOP/RUN toggle does not reset the SFC to initial steps;
- when STOPPED, ClassicLadder skips logic and output-copy rather than generically forcing HAL outputs false.

Preserve: **ClassicLadder STOP != safe output state != cycle reset**.

### Feeder supervisory/realtime result

A real LinuxCNC pick-and-place feeder implementation uses:

`M201 supervisory pickup -> M161 userspace feeder request -> ClassicLadder feeder logic`.

The uploaded M161 shell script pulses ClassicLadder inputs and exits without a physical completion acknowledgement. Preserve:

**command returned != actuator completed** and **request pulse issued != proven realtime consumption**.

First reusable 3800 transaction model:

`fresh request -> deterministic actuator sequence -> physical completion/stability -> fresh acknowledgement -> next cycle`.

Exact next work is a real public implementation with explicit completion feedback, stale-ack prevention and partial-cycle recovery. After that, source-trace extra-joint feeder authority and then position+lock indexer semantics per the active checkpoint.

## 3900 and 3100

These remain parallel specialization branches for later work-selection rotation. Prefer genuinely underdeveloped tracks when 3800 reaches a bounded local stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. The ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue from `checkpoints/3800-next-2026-09-14.md`. First seek a completion-feedback saw/feeder/transfer implementation with real request/ack/fault/recovery behavior. If that public source path reaches a bounded stop, proceed to the pinned LinuxCNC extra-joint/`posthome-cmd`/`limit3` feeder authority trace rather than repeating generic saw searches. Run a lab only for a concrete nonduplicate uncertainty exposed by a real implementation.
