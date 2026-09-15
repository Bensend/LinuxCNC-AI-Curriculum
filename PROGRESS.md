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

Active checkpoint: `checkpoints/4000-next-2026-09-15c.md`.

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

Required hardening before final freeze:
1. failed-read VALID/FRESH handling;
2. command/feedback generation or equivalent freshness witness;
3. real transport latency/jitter/dropout/watchdog measurement on final hardware;
4. every custom actuator module consumes global FPGA watchdog/output authority.

### Core hardware working freeze

Primary copy/adapt reference remains Colorlight 5A-75B V8-class ECP5/Ethernet architecture.

Working decisions:
- one Gigabit Ethernet PHY;
- no SDRAM unless required;
- ECP5-25 BG256-class core with SPI NOR + JTAG/sysCONFIG;
- dedicated oscillator rather than PHY-owned FPGA clock;
- required 1.1-V and 3.3-V rails only;
- separate protected machine-power entry;
- USB-C service/program/debug only;
- no copied HUB75/74HC245 machine-I/O front end.

Frozen cross-firmware requirement: an FPGA-local command-freshness watchdog SHALL independently remove normal machine-facing output authority, expose diagnostic fault state, and require explicit recovery/rearm rather than automatically restoring stale outputs when communications return. This is fault containment, not safety-rated authority.

## 4300 reusable I/O block progress

### Encoder block — working schematic contract created

Artifacts:
- `research/4000-encoder-electrical-reference-and-receiver-selection-2026-09-15.md`
- `hardware/4300-encoder-input-block.md`

Working baseline:
- four differential A/B/Z channels;
- AM26LV32E-class 3.3-V RS-422 receivers;
- configurable 120-ohm termination;
- differential-only base connector;
- connector-edge low-capacitance protection + deliberate signal-common/shield/chassis strategy;
- 10-MHz transition-rate contract pending final PCB/FPGA integration proof;
- index, illegal-transition and transport generation/VALID/FRESH diagnostics kept separate.

Single-ended and galvanically isolated encoder support remain external variants/adapters unless real machine inventory justifies base-board complexity.

### Digital field I/O — working schematic contract created

Artifacts:
- `research/4000-digital-field-io-first-pass-2026-09-15.md`
- `research/4000-digital-input-receiver-selection-2026-09-15.md`
- `research/4000-digital-output-driver-selection-2026-09-15.md`
- `research/4000-digital-output-isolation-architecture-2026-09-15.md`
- `hardware/4300-digital-field-io-block.md`

Working baseline:
- 24 isolated 24-V inputs using ISO1212-class IEC 61131-2 digital-input receivers;
- source/sink configurable field wiring;
- 16 protected sourcing/high-side outputs using TPS4H160-Q1-class smart switches;
- default-LOW digital isolation between FPGA and output field domain;
- watchdog/output-authority gating occurs before the isolation barrier;
- electrical driver fault is distinct from physical actuator witness;
- ordinary robust I/O only, no safety-rated claim.

Open before schematic/PCB freeze: exact input resistor networks, output isolator/DC-DC, current-limit/thermal/clamp calculations, connectors/fusing and field-side supply-loss truth table.

## 4000 exact next work

1. **Step/dir output block** — inspect proven Mesa/Colorlight/open CNC differential driver circuits; freeze channel count, electrical standard, maximum rate, single-ended compatibility and watchdog behavior.
2. Then PWM/analog interfaces, explicitly separating raw PWM/PDM from filtered 0-10-V and +/-10-V interfaces.
3. Then the parameterized proportional-current/solenoid block.
4. In parallel, finish exact current-production PHY, oscillator and regulator selections for the core after datasheet/reference-design review.
5. Before freezing each block, inspect applicable open electronics/PCB/FPGA/KiCad skills as design-review aids subordinate to datasheets, schematics, calculations and measured evidence.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue 4000 from `checkpoints/4000-next-2026-09-15c.md`. Prefer proven topology and standard engineering over unnecessary simulation. Preserve the 3000 authority/recovery contract in every hardware block.
