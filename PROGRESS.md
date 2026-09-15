# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14.
- F02 is GRADUATED. Valid information-separated evaluation: `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md` — PASS, no corrections required.
- Final 2000 closeout: `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15 after formal promotion/playbook-completeness review. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not routinely reopen closed levels without a genuinely new material defect. 3000 checkpoints remain reopen maps for materially stronger machine-specific evidence.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

Active checkpoint: `checkpoints/4000-next-2026-09-15b.md`.

## 4000 foundation and core state

Completed durable foundation:

- `hardware/BLOCK_SPEC_TEMPLATE.md` — canonical block authority/electrical/failure/recovery/verification contract.
- `hardware/4000-block-map.md` — reusable controller block map.
- `research/4000-colorlight-core-baseline-first-pass-2026-09-15.md` — Colorlight core baseline.
- `research/4000-colorlight-linuxcnc-firmware-watchdog-first-pass-2026-09-15.md` — Lcnc/ColorCNC watchdog/enable trace.
- `research/4000-litexcnc-watchdog-output-gating-trace-2026-09-15.md` — initial LiteX-CNC watchdog/PWM trace.
- `research/4000-hostmot2-watchdog-recovery-first-pass-2026-09-15.md` — HostMot2 bite/rearm/reconstruction trace.
- `research/4000-firmware-protocol-comparison-2026-09-15.md` — HostMot2 vs Lcnc/ColorCNC vs LiteX-CNC architecture comparison.
- `research/4000-litexcnc-output-watchdog-audit-2026-09-15.md` — GPIO/PWM/stepgen watchdog/reset audit.
- `hardware/4000-colorlight-core-copy-adapt-contract.md` — explicit Colorlight V8 core copy/adapt/omit contract.

### Working firmware selection

**LiteX-CNC is the preferred working baseline**, not yet an irreversible freeze. HostMot2/`hm2_eth` remains the maturity/reference standard and fallback; Lcnc/ColorCNC remains the minimal known-working Colorlight reference.

Reasons: native open-toolchain Colorlight/ECP5 support, modular custom-function architecture suitable for a proportional-current block, LinuxCNC realtime integration and FPGA-local watchdog behavior with lower project-owned protocol burden than Lcnc.

Required hardening before final freeze:

1. explicit failed-read VALID/FRESH handling — the inspected LiteX-CNC generic read loop currently processes its read buffer after the board read call and contains a TODO to stop processing failed reads;
2. explicit command/feedback generation or equivalent freshness witness;
3. authoritative transport latency/jitter/dropout/watchdog measurement on final hardware;
4. every custom output module must consume the global FPGA watchdog/output-authority state.

The standard LiteX-CNC GPIO, PWM and stepgen modules have now been source-checked: GPIO returns to configured safe states on reset/watchdog, PWM enable is cleared, and stepgen enable is gated by inverse watchdog-bite state.

### Core hardware working freeze

Primary copy/adapt reference remains Colorlight 5A-75B V8-class ECP5/Ethernet architecture.

Working decisions:

- one Gigabit Ethernet PHY, not two;
- no SDRAM unless a concrete memory-requiring feature appears;
- ECP5-25 BG256-class core with SPI NOR + accessible sysCONFIG/JTAG;
- dedicated oscillator/clock architecture rather than copying V8.0's dependency on a PHY-generated 25 MHz FPGA clock;
- 1.1 V core and 3.3 V I/O/logic rails retained as required; do not copy unused SDRAM-related rails;
- machine/24 V power entry is a separate protected industrial power block, not a copy of Colorlight's ~5 V input;
- USB-C is service/program/debug only for now, not realtime machine-control transport;
- HUB75/5 V 74HC245 field I/O is explicitly not copied as industrial CNC I/O.

Frozen cross-firmware requirement remains: an FPGA-local command-freshness watchdog SHALL independently remove normal machine-facing output authority, expose diagnostic fault state, and require explicit recovery/rearm rather than automatically restoring stale outputs when communications return. This is fault containment, not a claim of safety-rated authority.

## 4000 exact next work

1. Begin the **encoder input block** using `hardware/BLOCK_SPEC_TEMPLATE.md`: inspect proven LinuxCNC/Colorlight/community differential encoder front ends, receiver/protection/index topology and failure/freshness semantics.
2. Then digital inputs/outputs, step/dir and PWM/analog blocks, preserving proven topology first.
3. In parallel, select exact current-production PHY, oscillator and regulators for the core after datasheet/BOM review; do not pick parts solely by copied footprint.
4. Design the proportional-current/valve block after the generic I/O foundation, using suitable proven current-driver references and standard engineering; keep it parameterized for coil classes.
5. Before freezing each block, inspect applicable open electronics/PCB/FPGA/KiCad skills as design-review aids subordinate to datasheets, schematics, calculations and measured evidence.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue 4000 from `checkpoints/4000-next-2026-09-15b.md`. Prefer proven topology and standard engineering over unnecessary simulation. The next justified core experiment is eventual real transport measurement on concrete hardware, not a toy simulation. Preserve the 3000 authority/recovery contract in every hardware block.
