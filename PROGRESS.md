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

Current safety emphasis: commissioning/validation includes common-cause and latent-failure analysis, a qualitative minimum-safe-to-operate gate, mode/feedback integrity, physical final-element proof, personnel-retention/restart-prevention for bodily-entry hazards, gravity-axis retaining-function proof/recovery, guard-locking/escape-release authority, safety-network identity/recommissioning authority, physical stop-performance validation, and individual hydraulic final-element disagreement/inhibit behavior. Continue applying these methods to real professional implementations without inventing PL/SIL/DC, stopping, pressure or timing values.

Durable reference studies include `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md`, the complete-machine trace worksheet, reset/restart/EDM work, power-restoration work, service/setup-mode work, return-to-service work, `safety-course/COMMISSIONING_VALIDATION_FAULT_INJECTION_PACKAGE_2026-09-17.md`, `safety-course/COMMON_CAUSE_LATENT_FAILURE_AND_MINIMUM_OPERATE_GATE_2026-09-17.md`, `safety-course/MODE_SELECTION_EDM_COMMON_CAUSE_APPLICATION_2026-09-17.md`, `safety-course/PERSONNEL_RETENTION_RESTART_AUTHORITY_TRACE_2026-09-17.md`, `safety-course/GRAVITY_AXIS_BRAKE_PROOF_FAILURE_DISPOSITION_TRACE_2026-09-18.md`, `safety-course/DUAL_BRAKE_SEQUENTIAL_PROOF_AND_MASKING_TRACE_2026-09-18.md`, Lane B `safety-course/GUARD_LOCKING_ESCAPE_RELEASE_RESTART_AUTHORITY_STUDY_2026-09-18.md`, `safety-course/SAFETY_FIELDBUS_BLACK_CHANNEL_IDENTITY_FRESHNESS_AUTHORITY_STUDY_2026-09-18.md`, `safety-course/CIP_SAFETY_REPLACEMENT_IDENTITY_RECOMMISSIONING_AUTHORITY_TRACE_2026-09-18.md`, `safety-course/HYDRAULIC_PRESS_BRAKE_STOP_PROOF_PERIODIC_VALIDATION_RESCUE_BOUNDARY_TRACE_2026-09-18.md`, `safety-course/PRESS_BRAKE_VALVE_DISAGREEMENT_NEXT_CYCLE_INHIBIT_TRACE_2026-09-19.md`, and `safety-course/PRESS_BRAKE_VALVE_FAULT_TO_STOPPING_REPROOF_AUTHORITY_TRACE_2026-09-19.md`.

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.** For hazards where a person can bodily enter and disappear behind a perimeter safeguard, restart-prevention authority belongs to the independent safety system; LinuxCNC/HAL/ordinary FPGA may consume diagnostics/permissives but must not be the sole memory that a person remains inside.

Gravity-axis proof freeze: **BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.** A failed required brake proof removes further-operation authority; STO alone is not load retention for a gravity axis. Fault acknowledgement is not repair or re-proof, and stale ordinary START/JOG/ENABLE must not become fresh intent when safety authority returns.

Dual-brake proof freeze: **BRAKE A PASS + BRAKE B UNTESTED/FAIL/UNKNOWN != DUAL-BRAKE PROOF COMPLETE.** Professional SEW and Kollmorgen implementations test mechanically coupled brakes independently so a companion retaining element cannot mask the brake under test. Two brakes also do not establish two independent proofs when they share a motion witness or other common dependency.

Guard-locking Lane-B freeze: **GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.** Manufacturer evidence distinguishes guard position, personnel-protection locking, escape release, device reset and machine restart. Escape release changes the safety state; restoring the release and closing the guard does not by itself establish personnel-clear or fresh ordinary START authority.

Safety-network replacement freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.** Rockwell CIP Safety replacement evidence requires explicit safety identity/ownership handling and functional testing; ordinary network reachability or automatic configuration is not production authorization.

Hydraulic stop-proof freeze: **PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE.** A real BAYKAL hydraulic press-brake manual exposes a laser-guard stop/retract reaction, hydraulic safety/directional final elements, periodic stop-time measurement, and a separate rescue-motion function. Initial stop-time acceptance is not lifetime proof, and rescue motion is not production-cycle authority. HAWE current press-brake documentation independently keeps beam holding, switching time/overtravel, function monitoring and stored hydraulic energy as physical hydraulic concerns.

Hydraulic valve-disagreement freeze: **VALVE COMMAND EXPECTED STATE != VALVE MONITOR EXPECTED STATE -> SAFETY FAULT / EMERGENCY-STOP REACTION -> FURTHER PRESS OPERATION INHIBITED.** Lazer Safe PCSS evidence monitors individual press-brake safety/prefill/proportional/holding valve states and treats turn-on/turn-off disagreement as a valve fault. The same PCSS manual states that a prolonged mismatch causes an emergency-stop condition and switches off the auxiliary-axis or emergency-stop output, preventing further press operation until the problem is resolved. A healthy companion valve does not erase an explicitly monitored failed element. Valve-monitor agreement remains switching-state evidence, not proof of ram stop, load retention, safe pressure, exhausted stored energy, valid stop performance or safe access.

Hydraulic re-proof freeze: **FAULT MESSAGE CLEARED != VALVE REPAIRED != VALVE SWITCHING STATE RE-PROVED != RAM/LOAD PHYSICALLY SAFE != STOPPING PERFORMANCE RE-PROVED != PRODUCTION AUTHORITY.** Lazer Safe PCSS start-up tests deliberately induce two stops, measure actual beam stopping distance/time, trigger emergency-stop action on failure, block normal operation, and repeat until successful; normal operation may begin only after required tests pass. `Valve Zero` is therefore not a substitute for physical stopping-performance proof. The public PCSS evidence does not yet prove that replacement of every monitored valve automatically forces this test sequence, nor does it expose a separate static retaining/load proof for a serviced holding valve; those remain UNKNOWN.

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

1. Primary lane: continue from `PRESS_BRAKE_VALVE_FAULT_TO_STOPPING_REPROOF_AUTHORITY_TRACE_2026-09-19.md`. Find press-brake OEM/service evidence explicitly exposing `individual monitored holding/safety valve disagreement -> ram/load physical safe disposition -> isolate/support/depressurize -> repair/replacement -> individual retaining-function proof that cannot be masked by companion element -> dynamic stop-performance re-proof -> safety reset/rearm -> press-brake-specific fresh production initiation`.
2. Primary lane: determine from authoritative service/OEM evidence whether replacement of a monitored hydraulic safety/holding valve forces or requires the stopping/start-up test sequence, and whether a separate static load-retention proof is required. Keep this UNKNOWN until directly supported.
3. Primary lane: trace a two-retaining-element failure beyond the test itself: after A PASS / B FAIL, identify the documented physical load-safe disposition and whether/when A must be re-proved after B service. Do not invent a degraded-production mode.
4. Safety-network lane: continue the Rockwell replacement trace into an implementation exposing `communication/replacement fault -> safety output safe reaction -> physical final-element witness -> identity/configuration recommission -> functional test -> safety rearm -> separate ordinary START`; prefer drive/STO, safety contactor or guard-locking evidence.
5. Accessible-cell lane: continue `hazardous motion -> safety-side safe-state/standstill proof -> guard unlock -> bodily entry -> escape/restart-prevention -> guard close/lock -> personnel-clear proof -> safety reset/rearm -> separate fresh ordinary START`, preferably with failed lock/escape-release diagnostics or power-cycle recovery.
6. Preserve stop-time/stopping-performance validation as a physical maintained property. Do not transfer Lazer Safe/BAYKAL numerical thresholds or configuration values to another machine. After relevant hydraulic/safeguarding service, seek authoritative evidence for what revalidation is required before personnel exposure.
7. Preserve mode-integrity and feedback-integrity rules: invalid selector combinations fail safe where relied upon; selecting mode does not start hazardous motion; EDM, `Valve Zero`, or valve-position monitoring does not prove all hazardous energy absent.
8. Apply the commissioning + CCF + minimum-operate package to complete professional implementations as evidence becomes available.
9. Resume routine 4000 controller-board exact-BOM/power/pin work only when it directly supports the safety checkpoint or after the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. Ledger contains **338.56 minutes (5.64 h)** of exactly backfilled compute through the last recorded checkpoint; historical gaps mean it is not a trustworthy full-project total. No new lab compute was consumed in this session.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
