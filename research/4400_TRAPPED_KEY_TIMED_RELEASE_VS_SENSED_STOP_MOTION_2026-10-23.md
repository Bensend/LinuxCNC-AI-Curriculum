# 4400 — Trapped-key release: elapsed-time gate versus sensed stopped-motion gate

**2026-10-23 UTC | Original manufacturer source comparison, not a selected-machine stopping-time determination or bench test.** Courses 2570, 2590, 25E0, 4400. The central question is: **what evidence permits a guard key to be released while a hazardous mechanism may still be moving?**

## Official source trail and exact limits

1. **DOC-CONFIRMED — Rockwell 440T Electronic Timed-delay Unit (ETU)**, manufacturer family page https://www.rockwellautomation.com/en-pr/products/hardware/safety-products/440t-timed-delay-unit.html and exact `440T-MSTUE22AA` cut sheet https://configurator.rockwellautomation.com/api/Product/440T-MSTUE22AA/cutsheet . Turning the nonremovable key initiates a **timer**; when the configured duration expires, the device permits removal of the access key through its solenoid. This is an elapsed-time proposition, **not a direct motion measurement**. The family page describes a maximum up to 40 minutes, while the exact cut sheet says up to 30 minutes; do not transfer either limit or a stop-time value to an unselected installation.
2. **DOC-CONFIRMED — Rockwell 440T Stopped Motion Unit (SMU)**, manufacturer page https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440t-stopped-motion-unit.html and installation instructions `440T-IN035A-EN-P`, April 2018, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440t-in035_-en-p.pdf . The SMU family uses inductive proximity sensors and a CU2 detector for sensed motion. The installation sheet shows NPN/PNP sensor channels, solenoid monitoring, catalog-specific safety contacts and configurable time ranges. This is **not** a blanket assertion that any one shaft sensor proves all hazardous axes are stopped.
3. **DOC-CONFIRMED, historical CU2 manual** — `CU2-IN001`, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/cu2-in001_-en-p.pdf , describes detection of stopped movement at a flywheel/gear/shaft, **then** an integral configured time delay before safety outputs allow access. It shows two separately mounted proximity sensors and a monitoring path. The manual is old; its details are historical product-specific evidence and must be reconciled against the exact selected CU2 hardware/manual.
4. **DOC-CONFIRMED public scope** — ISO 14118:2017 https://www.iso.org/standard/66460.html includes unexpected startup from electrical/fluid power, stored gravity and external influences. It does not prescribe a universal stopping time or selected device.

## Three different release propositions

| Proposed release rule | Narrow claim | Critical failure path / missing evidence |
|---|---|---|
| Timer has elapsed after stop request | Configured duration has elapsed after the initiating event | Stop command might not have removed torque, machine might coast longer due to changed load/brake, supply or drive fault; timer alone does not observe motion |
| Sensor reports stopped motion (plus any configured delay) | Selected sensor/monitor sees the expected stopped condition at its observed target | Coupling/gear may slip; sensor may observe wrong shaft, stalled pulse train, misalignment or a different axis; gravity load may move without observed rotation |
| Independent machine safe-state release | All hazardous movement/holding/access propositions for **the selected task** are established | Requires risk assessment, actual final elements, relevant independent witnesses and qualified stopping/holding/access criteria |

**INFERENCE:** A selected timer-based release can be a legitimate engineered solution only when the machine-specific worst-case stopping behavior, faults, drift and applicable standards justify the configured delay. A sensor-based release can improve observability but must be tied to the actual hazardous motion and validated sensor fault paths. Neither device's “key free” LED is physical proof that a press-brake ram is restrained, a lathe spindle is stopped, a robot has no stored energy, or maintenance isolation is complete.

## Adversarial source-grounded cases

- **Brake wear:** stopping duration grows beyond the ETU setting; the key releases on schedule. `PHY-STOP/ACCESS` remains **NOT ESTABLISHED** unless the design detects or otherwise bounds this case with qualified evidence.
- **Broken coupling:** a monitored motor shaft stops while a downstream load continues under gravity or inertia. The SMU/CU2 sees only its instrumented target; `PHY-HOLD` and downstream `PHY-STOP` need separate witnesses.
- **Sensor power loss or disconnected target:** a missing pulse stream must not silently be interpreted as a proven stopped machine. Exact CU2 fault behavior, sensor wiring, self-monitoring and selected configuration must be reviewed before assigning a verdict.
- **Access under power failure:** guard-lock polarity and emergency inside escape remain independent of timer/stop detection. Never use a live trapped-person test.
- **Mode changes:** setup, muted laser, manual jog, auto-cycle and maintenance may have different hazard exposure and permitted key-release logic; no LinuxCNC speed command substitutes for independent measured safe motion.
- **Maintenance:** a valid stop-release key is not by itself a lockable energy isolator, residual-energy discharge, or per-worker OSHA LOTO.

## Architecture / physical-witness gate

For every guard release demand, record `SRS-RELEASE` with the *initiating event*, exact selected timer or stop detector, observed shaft/axis, sensor/clock supply, coupling and load path, time/fault response, release actuator, `AUTH` owner, `DEP` common-cause paths, and `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` witnesses. If the relevant hazard has no verified stop/hold criterion, the key release remains **HOLD** regardless of product label. The ordinary LinuxCNC/FPGA may request and display state but must not unilaterally override independent key-release authority.

**No selected-machine facts are available:** no sensor mounting/shaft map, actual stop distribution, brake wear envelope, hydraulic truth table, speed threshold, time setting or PL/SIL. `IN-01..10 UNKNOWN`, `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`. Do not perform personnel-exposed hazardous operation. No lab frozen: source comparison answers the conceptual distinction; a selected configuration may later justify a bounded low-energy bench experiment only on `[self-hosted, openpressbrake]` and with people outside danger zones.
