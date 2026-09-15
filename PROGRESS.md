# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED; valid evaluator `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md`; closeout `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15 after formal promotion/playbook-completeness review. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

Active checkpoint: `checkpoints/4000-next-2026-09-15h.md`.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit.

Working firmware baseline: **LiteX-CNC**, with HostMot2/hm2_eth as maturity/fallback reference. Required hardening remains failed-read VALID/FRESH handling, command/feedback generation witness, final-hardware transport measurement and global FPGA watchdog consumption by every custom actuator module.

Core working freeze: Colorlight 5A-75B V8-class ECP5/Ethernet copy/adapt reference; one GbE PHY; no SDRAM unless justified; ECP5-25 BG256-class core; SPI NOR + JTAG/sysCONFIG; dedicated oscillator; 1.1/3.3-V FPGA rails; protected machine-power entry; USB-C service/debug only; no HUB75 field front end.

New BOM freeze: `research/4000-core-phy-clock-power-bom-2026-09-15.md`. Working PHY is RTL8211FI-CG-class industrial RGMII; dedicated 25.000-MHz 3.3-V reference clock; PHY reset must not own FPGA clock availability. Exact 1.1/3.3-V regulator MPNs wait for whole-board load calculation.

Frozen rule: FPGA-local command-freshness watchdog independently removes normal output authority and requires explicit recovery/rearm. This is fault containment, not safety-rated authority.

## 4300 reusable I/O blocks

### Encoder — working contract
`hardware/4300-encoder-input-block.md`: four differential A/B/Z channels; AM26LV32E-class receivers; configurable 120-ohm termination; differential-only base connector; connector-edge protection; 10-MHz working transition contract; index/illegal-transition/transport freshness diagnostics separated.

### Digital field I/O — working contract
`hardware/4300-digital-field-io-block.md`: 24 isolated 24-V inputs using ISO1212-class receivers; 16 protected sourcing outputs using TPS4H160-Q1-class smart switches; default-LOW isolation; watchdog gate before isolation barrier.

Power/protection freeze: `research/4000-dio-power-fusing-freeze-2026-09-15.md`. Default input personality is low-power IEC Type-3; general outputs use a 0.5-A/channel working limit; four 4-output field-power groups use a 2-A working group-protection target; output isolation power is split into two 8-output banks. Exact resistor, DC/DC and fuse MPN/curve values remain calculation/procurement-bound.

### STEP/DIR — working contract
`hardware/4300-stepdir-output-block.md`: six axes; 5-V differential STEP/DIR; 10-MHz working maximum; MAX3042B-class transmitters; single-ended compatibility where drive supports one polarity; watchdog forces STEP static inactive before line driver; explicit rearm; enable/fault/STO separate.

### PWM / analog — working contract
Artifacts: `research/4000-pwm-analog-interface-first-pass-2026-09-15.md`, `research/4000-analog-output-source-trace-2026-09-15.md`, `hardware/4300-pwm-analog-output-block.md`.

Freeze at interface level:
- >=4 watchdog-gated PWM/PDM resources;
- 1–2 isolated VFD potentiometer-replacement analog channels on base board, 10–20-kHz PWM working target and deterministic minimum-command startup/watchdog state;
- precision +/-10-V servo output stays daughterboard/variant using a dedicated precision conversion path and independent enable/zeroing contract.

Public evidence did not expose Mesa's internal board-level 7I96S/7I77 analog circuitry; do not manufacture an internal topology from the manuals.

### Proportional-current / solenoid — drawable working contract
Artifacts include `hardware/4300-proportional-current-driver-block.md`, `research/4000-proportional-driver-gate-fault-net-contract-2026-09-15.md`, and `hardware/4300-proportional-current-kicad-interface.md`.

Present measured 22–28-ohm / 24-V coils imply roughly 0.86–1.09 A DC. First light-duty variant uses a 1.5-A engineering ceiling pending hot-coil measurements. Working architecture: low-side 80-V-class N-MOSFET, engineered fast-decay clamp, 50-milliohm high-side Kelvin shunt + INA240A1-class PWM-rejecting current sense, ADS7953-class shared SAR ADC, FPGA-local fresh-sample current loop and independent hardware overcurrent gate inhibit.

Gate/fault freeze: UCC27511A-class driver with deterministic LOW on UVLO/floating inputs; independent fast comparator + SET-dominant OC latch directly inhibits gate drive. Hardware trip is not merely reported to FPGA. Explicit zero-command/healthy-feedback rearm is required.

Working base-board allocation is four proportional-current channels, implemented as a reusable hierarchical sheet so channel count remains parameterized. Exact clamp voltage/TVS, final MOSFET, PWM frequency and loop gains remain measurement-bound. The schematic-AI contract explicitly rejects inventing clamp values before coil L/current-decay and rail-envelope evidence.

Current request, PWM/gate state, measured current, electrical fault, spool/hydraulic response, ram motion and safety authority remain separate. Watchdog or stale current feedback removes gate authority and requires explicit rearm; stale loop integrator state must not survive rearm.

## Exact next work

1. Freeze exact VFD analog isolation/conversion circuit and parts with deterministic minimum/zero watchdog behavior.
2. Build whole-board 3.3-V/1.1-V/isolated-logic power budget; then select exact regulators/DC-DC parts.
3. Reconcile FPGA bank/pin budget across RGMII, encoder, STEP/DIR, DIO, PWM, proportional-current and service interfaces.
4. When physical coil data arrives, calculate clamp energy/decay/repetition/VDS margin before any simulation.
5. Assemble the first whole-board schematic-AI/KiCad package from the frozen block contracts.
6. Use labs only for nontrivial residual loop stability, clamp overshoot/energy, current-sense aperture or watchdog/rearm uncertainty.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue 4000 from `checkpoints/4000-next-2026-09-15h.md`. Prefer proven topology and standard engineering over unnecessary simulation. Preserve the 3000 authority/recovery contract in every hardware block.
