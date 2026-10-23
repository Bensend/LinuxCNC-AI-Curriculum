# 4400 — Stopped-motion release: sensor coverage, fault diagnostics, and mechanical coupling

**2026-10-23 UTC | Original source investigation, not a historical archive release, machine acceptance, or test.** Courses 2570, 2590, 25E0 and 4400. Follows `4400_TRAPPED_KEY_TIMED_RELEASE_VS_SENSED_STOP_MOTION_2026-10-23.md`.

## Engineering question

A trapped key may be released after a monitor sees no pulses. What **specific** proposition is supported by that observation, which faults are actually detected, and which hazardous motions remain outside the observed mechanical path? Do not silently turn “no pulses” into “all loads safely stopped and restrained.”

## Manufacturer sources inspected and version scope

1. **DOC-CONFIRMED — Rockwell CU2-IN001, Part 70884, Change 13151 Issue 1, p. 1**, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/cu2-in001_-en-p.pdf . The CU2 uses **two sensors**, shown as NPN and PNP inductive devices, to detect movement at a flywheel, gear or shaft. After stopped motion is detected, its **integral timer** runs before the outputs close. The illustration calls for **separate sensor mounting brackets**. Y1/Y2 may monitor contactors at power-up; the text calls the output and timer circuits fail-safe/cross-monitored. This short historical sheet **does not document a comprehensive diagnostic truth table for a sensor frozen high/low, both sensors simultaneously disconnected, misaligned targets, shared mechanical drive, or a slipping coupling**. These behaviors are **UNKNOWN** for a selected unit; do not infer them from the phrase “cross monitored.”
2. **DOC-CONFIRMED — Rockwell 440T-IN035A-EN-P, April 2018, pp. 1–3**, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440t-in035_-en-p.pdf . Scope: 440T-MSMSEx/440T-MDMSEx stopped-motion key units, with separate contact arrangements and solenoid monitoring. The wiring illustration uses NPN and PNP proximity signals; the installation sheet gives adjustable timer ranges, requires an application risk assessment, weekly operation/alteration inspection, at-least-six-monthly wear checks, and replacement rather than repair after malfunction. It **does not** prove that a particular CU2 sensor-failure mode inhibits release or that the monitored shaft is mechanically coupled to every dangerous load.
3. **DOC-CONFIRMED — Pilz PNOZ s30 operating manual 1001715-EN-24, pp. 11–12, 16, 35–36, 73–74, 92–99 and 121–122**, https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf . This is a **different product architecture**, not a drop-in 440T/CU2 replacement. The manual expressly warns that encoder signals can cease being proportional to monitored speed due to **slippage or a broken shear pin**, and gives application measures including mechanical solutions and additional Z-frequency sensing on the same axis. It documents a configurable **validation cut-off frequency below which sensor plausibility checking is not performed** (p. 74). It documents encoder stuck-track errors and an fAB/fZ mismatch error with a broken-shear-pin/slippage diagnostic suggestion (pp. 92–99). Basic configurations have **different default standstill thresholds** (proximity versus encoder); no default is a press-brake acceptance setting. The manual explicitly requires analysis of **sensor-subsystem common-cause failures** (p. 122). Its examples and product-level safety characteristics do not prove whole-machine physical holding.
4. **DOC-CONFIRMED at catalog/diagnostic-document scope — Schmersal FWS 1206 A (archived product)**, https://products.schmersal.com/en_CH/fws-1206-a-101170057 and the manufacturer FWS integral-system-diagnostics sheet https://products.schmersal.com/upload/orig/10/00/40/99/DOC_APP_INF_i-fws_SEN_AIN_V2.pdf . Catalog states **one or two pulse sensors plus an additional standstill signal** (which may originate from a PLC), and lists wire-breakage and earth-fault detection; the retrieved manufacturer operating-manual search extract says **short-circuit recognition: no**. The ISD sheet distinguishes two-channel frequency disagreement, sensor-input faults, relay faults, and disagreement between the additional standstill signal and sensor frequencies. **Important scope limit:** the FWS 1206 is archived/not a current procurement recommendation; the PDF operating-manual URL redirected during direct inspection, so its full installation/diagnostic logic was **not** independently re-read. Do not generalize catalog checkboxes to every wiring topology or to CU2/Pilz.
5. **DOC-CONFIRMED — Rockwell 440T SMU current family page**, https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440t-stopped-motion-unit.html . It describes proximity sensors and CU2 monitoring. A family-level “up to Category 3/PL d” statement cannot be assigned to an unselected sensor mounting, safety function, or machine.

## Source-to-proposition table

| Observation or claim | What source actually supports | What it cannot establish |
|---|---|---|
| CU2 timer elapsed after sensor-detected stop | A selected CU2 sequence can close its release outputs after its configured delay (historical manual) | Correct sensor target, downstream stopping, brake wear margin, gravity load restraint, exact fault response |
| Two proximity sensors wired to CU2 | A two-sensor wiring/installation arrangement is shown | Two independent mechanical witnesses if both observe the same disconnected shaft; immunity to common power/target failures |
| Pilz PNOZ s30 standstill output | Selected configured frequency is below a threshold (specific mode) | Zero mechanical speed, motion on an uncoupled axis, physical holding, safety under a mis-set validation cut-off |
| PNOZ s30 encoder diagnostics | Some track, ratio and signal faults are documented | Detection of every coupling/slip fault or all faults at arbitrarily low speed |
| FWS 1206 additional PLC standstill input | An additional standstill signal can be part of that product's monitored architecture | Independence if PLC derives the signal from the same sensor, or suitability as a safety-rated independent witness without full validation |
| Green LED, HMI key-free status or output closed | A particular controller/monitor state | All hazardous energy removed, guard safe to open, person absent, or maintenance isolation complete |

## Failure-path discrimination — no invented device truth table

| Challenge | Common tempting but invalid inference | Engineering evidence needed | Present verdict |
|---|---|---|---|
| Both sensors lose a common supply | “No pulses means stopped.” | Exact selected monitor fault response, wiring/power segregation and bounded fault verification | **UNKNOWN / HOLD** |
| Both sensors observe a motor shaft; downstream coupling shears | “Two sensors independently prove the load stopped.” | Mechanical sensor-to-hazard map, coupling-failure controls, downstream independent witness/holding | **NOT ESTABLISHED / HOLD** |
| One proximity sensor loses pulses; the other still sees motion | “Either low frequency permits access.” | Exact product logic and fault handling; note FWS ISD documents disagreement as enabling paths open at its product scope | **UNKNOWN for CU2; product-specific for FWS** |
| Very slow hazardous movement near monitor threshold | “Standstill output means physically stationary.” | Selected threshold, target geometry, response time, risk-based permissible motion and physical witness; PNOZ plausibility cut-off review | **UNKNOWN / HOLD** |
| Control PLC reports stopped, derived from same encoder as monitor | “Two different screens are two independent proofs.” | Dependency/CCF map; truly independent sensors/energy-path evidence if required | **NOT INDEPENDENT** |
| Power fails while a person is inside | “No voltage means locked or safely released.” | Exact lock polarity, mechanical inside escape, trapped-person rescue, safe power recovery and deliberate restart | **UNKNOWN / HOLD** |
| Shaft stopped but press-brake ram creeps due to hydraulic leakage/gravity | “Spindle monitor covers the ram.” | Independent ram holding and pressure-zone witnesses; hydraulic circuit as built | **NOT ESTABLISHED / HOLD** |

**INFERENCE:** Even a legitimately safety-rated standstill-monitoring subsystem can be blind to a dangerous mechanism that is not causally tied to its observed sensor target. More channels on the **same** failed mechanical member are not equivalent to independently observing the hazard.

## Practical architecture contract

Keep four authorities separate:

1. **Ordinary control:** LinuxCNC/FPGA requests controlled stop, reports speed, manages the production sequence. No personnel-safety release authority.
2. **Independent safety-related control:** selected monitor/safety controller validates the **defined sensor proposition**, selected fault behavior, protective stop and key-release interlocks. Fault, stale data, changed configuration, loss of required supply or unexplained disagreement should **block normal release pending qualification**; this is a proposed system requirement, not a claim about CU2 internals.
3. **Physical final elements and energy:** selected contactors/STO/brakes/valves/locks implement the actual stopping/holding/access function; maintenance isolation and stored-energy control remain separate.
4. **Independent physical witness:** validate actual hazard endpoints, not just relay LEDs or HMI status. For an elevated press-brake beam, include independently justified load restraint, pressure zones and maintenance isolation. For a lathe, distinguish spindle from chuck/workpiece, turret, tailstock and stored kinetic energy.

For `SRS-RELEASE`, record exact device/order/firmware/manual, sensor model and supply, each bracket/target/axis, drive-to-load mechanical dependency, pulse rate and low-speed limits, exact timer/threshold, sensor-fault response, lock power polarity, safe egress, final elements, reset and restart. Cross-link `DEP/CCF`, `HF`, `AUTH`, `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART`, `VAL` and `PT`. A change of coupling, sensor bracket, key-release device or control mode invalidates affected proof until reviewed.

## Evidence limits and next work

- **SOURCE-CONFIRMED:** none for internal CU2/Pilz firmware; official manufacturer documents are **DOC-CONFIRMED**, not source or test evidence.
- **TEST-CONFIRMED:** none. No lab or physical fault insertion was conducted; do not test a live guard release with a person exposed.
- **UNKNOWN:** exact selected CU2 fault table, selected device configuration and manual edition, sensor-to-hazard coupling, actual stop/hold response, mechanical escape, hydraulic energy, PL/SIL calculation and independent commissioning witnesses.
- **Information-gain stop:** documentary review can establish *which* faults must be qualified, but cannot prove a selected machine's physical safety. A future low-energy bounded bench test must answer one explicit selected-device fault question with an independently approved exclusion arrangement and, if computational work is justified, use only `[self-hosted, openpressbrake]`; no GitHub-hosted compute.
- **Release status unchanged:** `IN-01..10 UNKNOWN`, `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`. External 2520–25F0 evaluation remains OPEN.


## Adversarial evidence-quality review (same session)

Three plausible overclaims were challenged against the actual manufacturer text:

1. **“Below Pilz's plausibility cut-off, the safety output necessarily closes.” — REJECTED.** The manual says the **plausibility check is no longer performed** below the selected cut-off. That is a statement about one diagnostic function, not a complete truth table for output energization, other fault handling or restart. The correct `UNKNOWN` is whether a selected configuration's *overall* detection and final-element architecture is adequate at the hazardous machine's lowest relevant speed.
2. **“CU2's two sensors detect every missing-pulse or common-power failure.” — NOT ESTABLISHED.** CU2-IN001 describes a two-sensor installation and cross-monitored timer/output circuits; the reviewed single-page manual does not provide the asserted complete sensor-fault behavior. The appropriate proof is exact selected hardware documentation plus controlled, non-exposed fault qualification, not a fabricated fault result.
3. **“PNOZ's automatic start makes the machine start by itself.” — TOO BROAD.** The product can automatically **reenable its assigned output** under the documented conditions, and §7.7 warns that external measures must prevent unexpected restart. Whether actual hazardous motion occurs depends on the downstream safety final elements and ordinary controller's retained-demand behavior. [Separate exact start-mode source trace](4400_PNOZ_S30_AUTOMATIC_OUTPUT_REENABLE_VS_FRESH_MACHINE_RESTART_2026-10-23.md).

**Disposition:** the existing audit and field card are valid as *conditional engineering requirements*, not physical failure verdicts. These three negative conclusions must remain visible in later source transfer and external evaluation. No machine-level PL/SIL, stop distance, pressure, or acceptance criterion was created by the review.
