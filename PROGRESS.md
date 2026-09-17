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

### Primary active priority — safety course / professional machine implementation

The owner has promoted the LinuxCNC/OpenPressBrake safety course to the primary active 4000 priority. Routine controller-board development remains a separate automation concern and must not displace safety work here.

Current safety emphasis: commissioning/validation includes common-cause and latent-failure analysis, a qualitative minimum-safe-to-operate gate, mode/feedback integrity, physical final-element proof, and personnel-retention/restart-prevention for bodily-entry hazards. Continue applying these methods to real professional implementations without inventing PL/SIL/DC, stopping, pressure or timing values.

Durable reference studies include `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md`, the complete-machine trace worksheet, reset/restart/EDM work, power-restoration work, service/setup-mode work, return-to-service work, `safety-course/COMMISSIONING_VALIDATION_FAULT_INJECTION_PACKAGE_2026-09-17.md`, `safety-course/COMMON_CAUSE_LATENT_FAILURE_AND_MINIMUM_OPERATE_GATE_2026-09-17.md`, `safety-course/MODE_SELECTION_EDM_COMMON_CAUSE_APPLICATION_2026-09-17.md`, and `safety-course/PERSONNEL_RETENTION_RESTART_AUTHORITY_TRACE_2026-09-17.md`.

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.** For hazards where a person can bodily enter and disappear behind a perimeter safeguard, restart-prevention authority belongs to the independent safety system; LinuxCNC/HAL/ordinary FPGA may consume diagnostics/permissives but must not be the sole memory that a person remains inside.

Home-shop maintenance rule: before work, remove/isolate/discharge/block/restrain or otherwise control the hazards relevant to the task. Never leave an unsafe/incomplete/bypassed machine unattended without unmistakable OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent status. Tag-out communicates/preserves the state; it is not a substitute for physical hazard control.

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

### STEP/DIR — working contract
`hardware/4300-stepdir-output-block.md`: six axes; 5-V differential STEP/DIR; 10-MHz working maximum; MAX3042B-class transmitters; single-ended compatibility where drive supports one polarity; watchdog forces STEP static inactive before line driver; explicit rearm; enable/fault/STO separate.

### PWM / analog — working contract
Artifacts: `research/4000-pwm-analog-interface-first-pass-2026-09-15.md`, `research/4000-analog-output-source-trace-2026-09-15.md`, `hardware/4300-pwm-analog-output-block.md`.

Freeze at interface level: >=4 watchdog-gated PWM/PDM resources; 1–2 isolated VFD potentiometer-replacement analog channels; precision +/-10-V servo output remains a daughterboard/variant using a dedicated precision conversion path and independent enable/zeroing contract.

### Proportional-current / solenoid — drawable working contract
Artifacts include `hardware/4300-proportional-current-driver-block.md`, `research/4000-proportional-driver-gate-fault-net-contract-2026-09-15.md`, and `hardware/4300-proportional-current-kicad-interface.md`.

Current request, PWM/gate state, measured current, electrical fault, spool/hydraulic response, ram motion and safety authority remain separate. Watchdog or stale current feedback removes gate authority and requires explicit rearm; stale loop integrator state must not survive rearm.

## Exact next work

1. Trace a complete professional implementation exposing personnel entry/presence or retained-person logic through the independent safety controller to physical final-element re-enable and separate ordinary START. Preserve UNKNOWN if public evidence stops before the final elements.
2. Continue complete-machine hydraulic/fall-protection evidence when it exposes actual cylinder volumes, blocking/load-holding/dump elements, feedback and gravity-load path together; do not infer an OpenPressBrake hydraulic truth table from generic practice.
3. Preserve mode-integrity and feedback-integrity rules: invalid selector combinations fail safe where relied upon; selecting mode does not start hazardous motion; EDM does not prove all hazardous energy absent.
4. Apply the commissioning + CCF + minimum-operate package to complete professional implementations as evidence becomes available.
5. Resume routine 4000 controller-board exact-BOM/power/pin work only when it directly supports the safety checkpoint or after the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.