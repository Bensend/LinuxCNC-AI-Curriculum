# 4400-MON-01 timing and mechanical-coupling addendum — Pilz PNOZ s30
**2026-10-30 | exact OEM 1001715-EN-24 | NON-GRADUATED | PUBLIC DOCUMENTARY RESEARCH | G0/G1 HOLD**

## Why this is incremental rather than a new course
The existing [MON-01 integrated module](../safety-course/4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md), [Pilz selector/output audit](4400_PILZ_PNOZS30_PARAMETER_SET_SELECTION_DIAGNOSTIC_BYPASS_AND_OUTPUT_SCOPE_AUDIT_2026-10-25.md), [false-standstill source comparison](4400_STOP_MOTION_SENSOR_COVERAGE_FAULT_AND_COUPLING_SOURCE_AUDIT_2026-10-23.md) and [automatic reenable audit](4400_PNOZ_S30_AUTOMATIC_OUTPUT_REENABLE_VS_FRESH_MACHINE_RESTART_2026-10-23.md) already teach mode selection, sensor coupling, automatic restart and physical proof. This addendum resolves an *exact quantitative source gap* those artifacts did not spell out: the **activation preconditions and pulse-count plausibility delay** for two-encoder/shear-pin monitoring, plus filtering and invalid-level tolerance effects. It does not claim a new scored competency.

## Original source and edition
Pilz GmbH & Co. KG, *PNOZ s30 Operating Manual*, **1001715-EN-24**, manufacturer-hosted PDF: https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf . Manufacturer product record dates edition -24 to **29 April 2025**: https://www.pilz.com/en-INT/eshop/product/750330 . Direct PDF text examined **2026-10-30 UTC** (printed pp. 12–13, 21–26, 31–35, 38–39, 93, 120–122). A stable downloaded byte hash was not retained; exact edition was checked on inspected page headers, not claimed for a physical installed unit.

## Evidence ledger: what the monitor does, and does not, prove
| Claim | Class | Original manual location | Engineering consequence |
|---|---|---|---|
| Encoder slippage or a broken shear pin can make signal frequency cease to represent monitored speed; user must detect/exclude such faults | **DOC-CONFIRMED** | §3.1, printed p.12 | Healthy pulses are not physical shaft/load coupling proof. An encoder attached only upstream of a failed transmission can be misleading. |
| An additional proximity sensor or independent HTL encoder on track Z can support 2-encoder/broken-shear-pin monitoring; fAB/fZ discrepancy threshold is **10%** | **DOC-CONFIRMED** | §5.3.6, p.21 | Only valid when the selected configuration, gearing/ratio, sensing locations and sensor common-cause controls are justified. |
| This plausibility check does **not become active** until minimum speed exceeded, a pulse-count tolerance elapsed, and testing has not been disabled by parameter sets/wiring | **DOC-CONFIRMED** | §5.3.6, p.21 | At low speed/short motion, the diagnostic may not yet be active. It is not a universal instantaneous break detector. |
| When configured ratio fAB/fZ >= 1, tolerance is **7.5 Z pulses** or **7.5 × ratio AB pulses**; when ratio <1, **4.5 AB pulses** or **4.5/ratio Z pulses** | **DOC-CONFIRMED** | §5.3.6, p.21 | A configured *pulse count* cannot be converted into a universal milliseconds claim without actual frequency, ratio and activation setting. |
| A and B / Z signal-level tolerance may increase feasibility-check detection time to **up to 4× the configured tolerance** | **DOC-CONFIRMED** | §5.5.1–5.5.2, pp.38–39 | Fault-reaction timing must include configured invalid-signal tolerance; this is not automatically the complete protective stop time. |
| Speed filtering adds delay; example 99%-step responses: **slow ~420 ms, average ~47 ms, fast ~9 ms** | **DOC-CONFIRMED** | §5.3.8, pp.22–24 | These are example filter step-response times, **not** universal safety-output trip times or machine stop times. |
| Overspeed output switch-off delay further increases monitor reaction; optional automatic start can reenergize an output when condition becomes acceptable | **DOC-CONFIRMED** | §§5.3.9, 5.3.13, pp.24–26 | Distinguish monitoring, safe relay response, external final-element response and independent fresh machine start. |
| 'All 16' selector mode permits valid lower-number parameter selection on open input; 'No 2 encoder diagnostics' can suppress plausibility | **DOC-CONFIRMED, predecessor already covered** | §§5.4.1, 5.4.3, pp.31–35 | The source itself recommends ascending limit values and putting diagnostic-disable mode at higher-number set to avoid unintentional selection on open wire. Do not relabel this as a new discovery. |
| PNOZ s30 relay outputs 13–14 / 23–24 are safety outputs; Out 1–4 are ordinary semiconductor auxiliary outputs | **DOC-CONFIRMED, predecessor already covered** | §5.3.12, p.25 | An ordinary speed display or auxiliary bit cannot inherit safety-output authority. |
| Exact installed speed-monitor configuration, encoder mounting, ratio, response budget, safety target, physical stopping/holding and guard release | **UNKNOWN** | Requires restricted as-built and qualified witness | No selected OpenPressBrake or other machine release claim. |

**Interpretation guard:** The 10% comparison applies to the documented fAB-versus-fZ plausibility monitor, not a universal permissible speed error. The 4× tolerance applies to signal-level feasibility checking, not automatically to every fault class. The filter 99% figures are examples of filter response, not a physical stopping-distance calculation. **INFERENCE:** multiple timing stages can contribute to delayed protection, but simply adding every quoted figure would be an invalid worst-case proof without the exact configuration and timing definitions.

## Fault-path and authority matrix (paper analysis; not a tested truth table)
| Initiating fault/shortcut | Potential misleading observation | Required independent evidence |
|---|---|---|
| Broken shear pin between encoder and hazardous load | Encoder frequency looks valid for motor, not for load | Sensing location and mechanical transmission fault analysis; independent downstream motion/hold proposition as required. |
| Very slow movement or motion too short to meet activation/tolerance | No broken-shear-pin diagnostic trip yet | Actual minimum-speed, ratio, pulse counts, hazard approach and permissible response; no generic low-speed exemption. |
| Selector wire opens in 16-set mode | Different *valid* parameter set may be selected | Wiring/parameter table, monotonic safety thresholds, diagnostic-disable location, controlled change records. |
| Installer chooses slower filter or longer invalid-level tolerance to reduce nuisance trips | Cleaner status display but later reaction | Exact setting, monitor response and measured machine stopping envelope; correct EMC/installation instead of defeating protective function. |
| Drive reports stopped; guard unlock requested | Motor/encoder is stopped but a vertical ram or saw blade remains hazardous | Independent load restraint, coasting/stopping and guard-release validation; machine-specific physical witness. |
| Safety relay output returns automatically after fault clears | Operator assumes this authorizes a new cycle | Independent deliberate start/rearm and occupancy/guard verification; ordinary LinuxCNC/HAL must not own personnel safety. |

## Human-factors design: make correct setup easier than defeat
Use a short, versioned configuration sheet next to the qualified safety controller: exact selected sensor locations, ratio and speed units, enabled plausibility diagnostics, parameter-set truth table, filter/tolerance/delay values, safe output wiring and who approves changes. Keep a practical method for legitimate slow setup without turning off independent guards. If nuisance trips lead users to increase delay or disable checks, treat this as an engineering defect in wiring/EMC, sensor placement or usability—not an instruction to accept an unverified bypass. Maintenance after sensor replacement, gearbox service, belt work or coupling change reopens the mechanical-proposition review.

## Public unscored transfer prompts (do not add to blind bank)
1. The Z sensor is mounted on the motor side of a coupling that can slip. Is a valid 10% AB/Z agreement evidence that the dangerous load stopped? Explain the shared mechanical fault.
2. A spindle only turns for a fraction of the configured pulse-count plausibility interval. Can absence of a shear-pin diagnostic fault certify coupling integrity?
3. A technician increases the slow filter and invalid-level tolerance to eliminate intermittent trips. Which exact reaction-time terms must the reviewer revisit, and which figures cannot be treated as physical stop times?
4. An All-16 selector input breaks and selects a lower parameter set. Explain why a valid parameter set can still be an unsafe selection and why the diagnostic-disable option needs special placement.
5. A safety monitor's relay permits a guard unlock while a gravity-loaded press ram has no proven mechanical/hydraulic restraint. What physical evidence is missing?

**Assessment:** These are open-book, **UNSCORED** review cases. No independent 2520–25F0 evaluation was performed; do not contaminate sealed evaluation materials.

## Verification decision and next evidence
No simulation is justified: the above questions are answered directly by original manufacturer documentation. A *selected-machine* fault-injection or timing lab would only be justified after a qualified owner identifies the actual device/revision, selected encoder topology, configured settings, independent final elements, a concrete unanswered timing/fault question, and an isolated/remote safe test method. It must not use GitHub-hosted compute. If local runner [self-hosted, openpressbrake] cannot dispatch, source/documentary work continues and access remains UNKNOWN. No bench experiment can prove gravity-load holding or guard safe distance without a physical, qualified machine-specific validation.

**Gate disposition:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation. **TEST-CONFIRMED none; no selected machine; no PL/SIL, stop distance, or safety timing inferred.**
