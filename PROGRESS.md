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

Active checkpoint: `checkpoints/4000-next-2026-09-15e.md`.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit.

Working firmware baseline: **LiteX-CNC**, with HostMot2/hm2_eth as maturity/fallback reference. Required hardening remains failed-read VALID/FRESH handling, command/feedback generation witness, final-hardware transport measurement and global FPGA watchdog consumption by every custom actuator module.

Core working freeze: Colorlight 5A-75B V8-class ECP5/Ethernet copy/adapt reference; one GbE PHY; no SDRAM unless justified; ECP5-25 BG256-class core; SPI NOR + JTAG/sysCONFIG; dedicated oscillator; 1.1/3.3-V FPGA rails; protected machine-power entry; USB-C service/debug only; no HUB75 field front end.

Frozen rule: FPGA-local command-freshness watchdog independently removes normal output authority and requires explicit recovery/rearm. This is fault containment, not safety-rated authority.

## 4300 reusable I/O blocks

### Encoder — working contract
`hardware/4300-encoder-input-block.md`: four differential A/B/Z channels; AM26LV32E-class receivers; configurable 120-ohm termination; differential-only base connector; connector-edge protection; 10-MHz working transition contract; index/illegal-transition/transport freshness diagnostics separated.

### Digital field I/O — working contract
`hardware/4300-digital-field-io-block.md`: 24 isolated 24-V inputs using ISO1212-class receivers; 16 protected sourcing outputs using TPS4H160-Q1-class smart switches; default-LOW isolation; watchdog gate before isolation barrier. Exact resistor/isolation/DC-DC/thermal/fusing work remains.

### STEP/DIR — working contract
`hardware/4300-stepdir-output-block.md`: six axes; 5-V differential STEP/DIR; 10-MHz working maximum; MAX3042B-class transmitters; single-ended compatibility where drive supports one polarity; watchdog forces STEP static inactive before line driver; explicit rearm; enable/fault/STO separate.

### PWM / analog — working contract
Artifacts: `research/4000-pwm-analog-interface-first-pass-2026-09-15.md`, `research/4000-analog-output-source-trace-2026-09-15.md`, `hardware/4300-pwm-analog-output-block.md`.

Freeze at interface level:
- >=4 watchdog-gated PWM/PDM resources;
- 1–2 isolated VFD potentiometer-replacement analog channels on base board, 10–20-kHz PWM working target and deterministic minimum-command startup/watchdog state;
- precision +/-10-V servo output stays daughterboard/variant using a dedicated precision conversion path and independent enable/zeroing contract.

Public evidence did not expose Mesa's internal board-level 7I96S/7I77 analog circuitry; do not manufacture an internal topology from the manuals.

### Proportional-current / solenoid — RESEARCH started
Artifact: `research/4000-proportional-solenoid-driver-reference-pass-2026-09-15.md`.

Primary proportional reference is TI TIDA-020023: PWM proportional-solenoid drive plus accurate high-side current measurement. DRV110/TIDA-00289 are adjacent peak/hold and fault-detection references, not the continuously variable baseline.

Working architecture: 24-V-class coil, low-side N-MOSFET switching, engineered recirculation/clamp, measured current feedback, current setpoint as the command variable. Current request, gate/PWM, measured current, electrical fault, spool/hydraulic response and safety authority remain distinct. Present measured 22–28-ohm coils imply roughly 0.86–1.09 A at 24 V before control/thermal effects; design the light-duty baseline first and parameterize upward rather than defaulting to the previous 250-V MOSFET.

## Exact next work

1. Calculate current, switching/clamp energy and dissipation bounds for the 24-V / 22–28-ohm present coil class.
2. Select a modern MOSFET from SOA/avalanche/transient evidence, likely 40–60-V class unless clamp strategy justifies more margin.
3. Select shunt/current-sense architecture and compare high-side PWM-rejecting sensing with low-side simplicity.
4. Freeze freewheel/TVS/active-clamp decay behavior from valve response and device-stress requirements.
5. Decide FPGA+ADC versus local analog/current-controller loop partition and write the first schematic-level proportional-current block.
6. Only then simulate/bench a remaining nontrivial loop/stress uncertainty.
7. Parallel BOM work remains for exact VFD analog isolation parts, precision +/-10-V daughterboard DAC/op-amp, core PHY/oscillator/regulators and DIO thermal/fusing.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue 4000 from `checkpoints/4000-next-2026-09-15e.md`. Prefer proven topology and standard engineering over unnecessary simulation. Preserve the 3000 authority/recovery contract in every hardware block.
