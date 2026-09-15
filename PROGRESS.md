# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15 after formal promotion/playbook-completeness review. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not reopen closed 1000/2000 work without a genuinely new material defect. Do not routinely mine 3000 branches after closeout; their checkpoints remain reopen maps for materially stronger machine-specific evidence.

## 3000 closeout summary

All nine machine-specialization tracks received substantive source/community/config/build-diary passes and durable architecture/failure/recovery coverage. The cross-track synthesis is `research/3000-cross-machine-authority-patterns-2026-09-15.md`; 3300 also has `research/3300-cross-process-gantry-cutting-playbook-2026-09-15.md`.

The reusable machine-control contract entering 4000 is:

`request -> actuation path -> physical witness -> qualified completion -> continuation acknowledgement`

Preserve value/validity/freshness separation, explicit ownership transfer, independent process cleanup/recovery, distinct commanded/electrical/physical/process-valid states, and the boundary between normal-control permissives, software fault containment and independent safety-rated authority.

### Preserved 3000 reopen maps

- 3100 Mills/VMCs — `checkpoints/3100-next-2026-09-15.md`
- 3200 Lathes/Turning — `checkpoints/3200-lathe-next-2026-09-15.md`
- 3300 Plasma/Laser/Waterjet — `checkpoints/3300-next-2026-09-15.md`
- 3400 Routers/Woodworking — `checkpoints/3400-next-2026-09-14d.md`
- 3500 Robots/Custom Kinematics — `checkpoints/3500-next-2026-09-14c.md`
- 3600 Press Brakes — documented information-gain stop; integration map `research/3600-press-brake-integration-playbook-outline-2026-09-12.md`
- 3700 Grinding/EDM — `checkpoints/3700-next-2026-09-14.md`
- 3800 Saws/Feeders/Cells — `checkpoints/3800-next-2026-09-14.md`
- 3900 Emerging/Unusual — `checkpoints/3900-next-2026-09-15c.md`

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

Active checkpoint: `checkpoints/4000-next-2026-09-15.md`.

### 4000 foundation completed this session

- Canonical hardware block contract: `hardware/BLOCK_SPEC_TEMPLATE.md`.
- First reusable block map: `hardware/4000-block-map.md`.
- First Colorlight core baseline: `research/4000-colorlight-core-baseline-first-pass-2026-09-15.md`.
- First Colorlight LinuxCNC watchdog/enable trace: `research/4000-colorlight-linuxcnc-firmware-watchdog-first-pass-2026-09-15.md`.

Current hardware direction is to use proven Colorlight 5A-75B/5A-75E ECP5/Ethernet architecture as a primary copy/adapt reference for applicable core circuitry while **not** blindly copying its HUB75 field-I/O front end. Press-brake-specific blocks without a true equivalent, especially proportional-solenoid/current drive, remain independently engineered from suitable reference designs and standard engineering principles.

The firmware/protocol decision is intentionally not frozen yet. Keep upstream HostMot2/`hm2_eth`, ColorCNC/Lcnc-style custom Etherbone firmware, and LiteX-CNC distinct until their watchdog, latency/freshness, integration, extensibility and maintainability tradeoffs are source-compared.

### 4000 exact next work

1. Source-compare HostMot2/`hm2_eth`, Lcnc/ColorCNC and LiteX-CNC for the core firmware/protocol decision.
2. Extract the Colorlight V8 FPGA/PHY/configuration/power circuit details needed for an explicit copy/adapt contract.
3. Freeze one-versus-two PHY, SDRAM necessity, USB-C role, power-entry domains and watchdog/output-gating architecture before schematic placement.
4. Then proceed through encoder, digital I/O, step/dir, PWM/analog and proportional-current blocks using the canonical block template.
5. Before freezing each block, inspect applicable open electronics/PCB/FPGA/KiCad skills and use them as design-review aids, subordinate to schematics/datasheets/source/engineering calculations.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue 4000 from `checkpoints/4000-next-2026-09-15.md`. Prefer proven topology and standard engineering over unnecessary simulation. Use simulation only for real nonduplicate uncertainty such as control-loop stability, switching/current-control behavior, transient margin, timing-sensitive interfaces or fault transitions. Preserve 3000 machine authority/recovery requirements in every hardware block rather than optimizing only for electrical connectivity.
