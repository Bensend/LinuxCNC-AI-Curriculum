# 4400-ANALOG-SAFE-01 — Two channels are not automatically two sensors
**Field review card | PUBLIC / UNSCORED | 2026-10-30 | NO PHYSICAL RELEASE**

Read the [original SICK FX3-ANA0 OEM investigation](../research/4400_ANALOG_SAFE_01_SICK_FX3_ANA0_2026_DUAL_CURRENT_INPUT_SHARED_SENSOR_DISCREPANCY_AND_SECOND_RECEIVER_AUDIT_2026-10-30.md) first. This card applies the **existing 2520→2550→2580 safety-function method** to a new analog input/pressure-monitoring mechanism. It is **not** a new independently scored course and is not a claim that OpenPressBrake uses SICK hardware.

## Technician's five-minute review
**Question:** When two 4–20 mA values agree, which independent physical facts are actually established?

1. Draw **sensor element → pressure tap/process → transmitter electronics → supply/cable → safety input → logic → final element** for each channel. Count **independent sensing chains**, not input terminals. A single safe transmitter wired through both FX3-ANA0 inputs is expressly supported by the SICK manual; it is **one sensing source**, not automatically two.
2. Identify the actual process variable and hazard. A pressure reading is not automatically a position, standstill, load-support, valve-state or maintenance-isolation witness.
3. Verify the selected controller/sensor manuals, configuration revision, scaling, discrepancy limits, AI1 delay, averaging, fault behavior and deliberate reset. The original SICK hardware Table 105 identifies an analog-input processing/measurement path; it is **not** a machine stopping-time measurement.
4. Check shared power, taps, fittings, cable routes and any **second receiver in series**. SICK expressly warns that the second control's memorized fault current can influence the analog safety module.
5. Confirm that the **independent safety function** acts on invalid data, that final elements physically stop/hold/isolate, and that HMI/LinuxCNC/FPGA gateway telemetry is **non-safety diagnostics only**.

## Eight adversarial desk cases (PUBLIC, UNSCORED, NOT EXECUTED)
| Case | Proposed “green” shortcut | What must be established before any credit |
|---|---|---|
| A | One transmitter feeds AI1 and AI2; both agree. | Sensor's own safety claims, shared-source failure coverage and approved single-sensor wiring; **not** two independent sensors. |
| B | Two transmitters connect to the same isolated pressure stub. | Whether stub pressure reflects the actual hazard under blocked/faulted hydraulic states; no invented truth table. |
| C | Two channels share 24-V supply and one conduit. | Common-cause assessment and selected sensor fault signaling; separate readings alone are insufficient. |
| D | Widen discrepancy tolerance after nuisance stops. | Correct root cause and safety response-time/diagnostic impact; bypass incentives addressed by a better installation. |
| E | AI1 delay configured to compensate sensor lag. | Actual selected configuration, full path response calculation, independent stop and physical validation. |
| F | A second controller is added in series to reuse the signal. | Both OEM input/fault-current behaviors, electrical compatibility and independent safety validation. |
| G | Pressure HMI reads normal after safety-module fault. | Whether gateway data are non-safe and stale; fault logic and physical final elements must be checked independently. |
| H | Fault clears and both channels agree; operator hits START. | Explicit fault acknowledgement, guard-clear/hold-state check, deliberate restart authorization; no automatic rearm. |

## Low-friction field qualification worksheet — BLANK / NOT RUN
| Field | Evidence required | State |
|---|---|---|
| Machine/revision/mode and hazard | As-built SRS and qualified owner | UNKNOWN |
| Exact sensor elements and taps | Dated sensor/port diagram | UNKNOWN |
| Controller and transmitter OEM safety manuals | Model, firmware, edition and revision | UNKNOWN |
| Input wiring and second receivers | Approved schematic; shared supply and CCF review | UNKNOWN |
| AI1 delay / averaging / discrepancy | Safety project report and acceptance criteria | UNKNOWN |
| Invalid-signal behavior and reset | Qualified functional specification | UNKNOWN |
| Response-time budget | Selected sensor + input + logic + output + final-element path | UNKNOWN |
| Physical stop / gravity load hold / stored-energy isolation | Qualified independent witness, no personnel exposure | NOT RUN |
| Change and bypass management | Labeled replaceable parts, accessible unpowered diagnostics, revalidation | UNKNOWN |

**STOP/HOLD decision:** If the machine lacks a defensible independent safety architecture and verified physical safe state, **do not operate with people exposed to the hazard**. A later experimental run requires separate qualified authorization, isolation/remote execution with people outside the danger zone, and stated residual risk. Do not induce hydraulic motion, remove guards, bridge sensors or use a LinuxCNC test to claim personnel safety.

**Provenance:** original SICK 8012478/1WLY/2026-05-05 directly inspected; SICK 8012480/T157/2025-07-30 configuration detail available as manufacturer-hosted indexed excerpt but entire PDF not opened. No selected-machine evidence, no external blind score, no lab compute.
