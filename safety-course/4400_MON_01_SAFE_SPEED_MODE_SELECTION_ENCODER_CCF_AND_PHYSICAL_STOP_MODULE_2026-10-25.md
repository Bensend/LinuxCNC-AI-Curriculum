# 4400-MON-01 — Safe speed monitoring: parameter-set authority, encoder CCF, physical stop and restart
**4000 safety curriculum | 2026-10-25 | SOURCE READING / NOT GRADUATED | no physical or executable lab**

## Prerequisites and objective
Requires 2520 risk/SRS, 2540 safety outputs, 2570 drive stop, 2580 isolation, 2590 guarding, 4400-SET-01 guard-open setup/SLS, 4400-CFG-01 configuration identity, 4400-RST-01 reset/EDM and existing PNOZ s30 stopped-motion research. A fresh learner must distinguish **normal CNC speed command, safety-monitor configuration, independent sensor evidence, safety relay versus ordinary status, controlled deceleration, physical load holding, and deliberate fresh start**.

Read [Pilz parameter-selection/diagnostic/output original manual audit](../research/4400_PILZ_PNOZS30_PARAMETER_SET_SELECTION_DIAGNOSTIC_BYPASS_AND_OUTPUT_SCOPE_AUDIT_2026-10-25.md), [SICK dual-encoder/CCF/stop-ramp OEM example audit](../research/4400_SICK_STATIONARY_MACHINE_TWO_ENCODER_CCF_SPEED_RAMP_AND_RESTART_OEM_AUDIT_2026-10-25.md), and [technician cases/blank selected witness](4400_SAFE_SPEED_SELECTOR_SENSOR_INDEPENDENCE_TECHNICIAN_CARD_2026-10-25.md). Existing [SET-01](4400_SET_01_SETUP_MODE_ENABLING_SLS_AND_LOTO_BOUNDARY_MODULE_2026-10-24.md) remains the broad mode/LOTO prerequisite.

## The non-negotiable safety boundary
A configured safe-speed monitor can supervise a **specified motion variable** only through its validated sensors, configuration, reaction and final elements. Neither SLS nor a low shaft-frequency output proves a suspended ram is held, all Y1/Y2 hydraulic zones are isolated, a guard is clear of people, or ordinary LinuxCNC has canceled retained commands.

### Four independent propositions
| Proposition | Ordinary owner | Safety/physical owner | What remains UNKNOWN without selected evidence |
|---|---|---|---|
| Requested low speed | LinuxCNC/FPGA motion planner, drive command | None; normal control only | Actual measured speed and failure behavior |
| Monitored limited speed / direction | HMI may display state | Qualified safety monitor, correct parameter set, suitable encoder channels | Real selector wiring, sensor coupling, safety integrity |
| Actual stop / sustained hold | CNC may command ramp/disable | Independent final elements, suitable brakes/valves, load restraint | Hydraulic/gravity hold, stop time and distance |
| Deliberate restart | LinuxCNC start request | Independent safety reset/rearm plus **new** normal start | Stale queue, reset/occupancy, EDM and physical proof |

## Exact manufacturer lessons
**Pilz PNOZ s30 1001715-EN-24 (DOC-CONFIRMED, exact model):** 1-of-4 parameter selection and All 16 selection have **different manufacturer-rated maximum application integrity**; in All 16 a broken selection conductor may choose another valid lower-numbered set. Some parameter sets can disable two-encoder diagnostics, acknowledge recoverable faults or restart the monitor. The manufacturer distinguishes safe relay outputs from standard semiconductor outputs; overspeed switch-off delay adds reaction time. These are not universal SLS behaviors or an achieved OpenPressBrake PL/SIL.

**SICK Safe Stationary Machine 8020304/2017-07-26 (DOC-CONFIRMED, example):** two ordinary encoders need mechanically and electrically independent fault paths, while one safety encoder requires a **different** configured arrangement. Speed cross-check, actual ramp monitoring, configured response times and the final element are separate. The OEM conditions its example performance on correct components, fault analysis and integration. No generic speed limit, window or reaction value transfers to the selected machine.

## Design state contract (INFERENCE, not executable safety logic)
- **M0 UNKNOWN:** power return, lost sensor, uncertain mode, incomplete config identity, stale reset or incomplete final-element feedback => hazardous start inhibited independently.
- **M1 NORMAL:** ordinary controller requests production speed; safety monitor selects its validated corresponding limits. Selector state and selected mode are recorded and independently verified.
- **M2 SETUP REQUEST:** only validated mode selection and enabling/guard architecture permits reduced-speed operation; no normal-control override of safety authority.
- **M3 TRANSITION:** while reducing speed, a defined supervised transition and timeout apply; actual motion must be monitored, not assumed from commanded ramp.
- **M4 PROTECTIVE STOP:** safety output demands physical stopping/holding through selected final elements. Monitor low speed is not proof of Y1/Y2 gravity hold.
- **M5 ACCESS/MAINTENANCE:** guard-open or service access uses the independently validated access function; LOTO and stored-energy verification for tasks requiring isolation. E-stop/SLS/SOS do not replace isolation.
- **M6 REARM:** clear fault cause, verify physical safe state and people excluded, reset independent safety function, then require deliberate **new** ordinary machine start; reject retained queued motion.

## Fault and adversarial review
1. **Parameter integrity:** document model/firmware/manual, select mode, all parameter sets, special functions, output assignments, start/ack semantics and exact changed-settings audit. Test paper truth table for open/short/drift; do not infer behavior from a normal green status.
2. **Sensor independence:** draw both sensor-to-load physical paths; list common couplings, shafts, fasteners, power/0V, cable, connector, EMC, software scaling and speed comparison. Two readouts are not necessarily two independent measurements.
3. **Timing:** separately budget selector filter, speed monitoring, output delay, safety communications if present, final-element response and physical stop. No numeric acceptance before qualified selected measurement and risk assessment.
4. **Gravity:** require a distinct safe-state claim for the ram against gravity, residual pressure, stuck valves and hose failure, regardless of motor speed.
5. **Human factors:** prefer a keyed/clear physical mode selector, guarded wiring and accessible fault diagnostics, conspicuous maintenance status, easily restored guards and non-annoying safe recovery. Bypass frequency is a design defect to investigate, not a reason to weaken a monitor.

## Cross-machine application
Press brake: backgauge/drive SLS may be applicable, but Y1/Y2 hydraulic stop/hold is separately justified; no assumed shared encoder. Mill/lathe: spindle coast and tool/chuck containment matter after speed reaches a threshold. Robot: mode/occupancy and suspended payload remain independent. Conveyor/plasma: stopping axis does not isolate torch/process energy. No OEM sample configuration is a generic wiring diagram.

## Evaluation and release
Use [16 learner-visible PAPER cases](4400_SAFE_SPEED_SELECTOR_SENSOR_INDEPENDENCE_TECHNICIAN_CARD_2026-10-25.md) for practice only; [fresh evaluator assignment](../evaluation/4400_MON_01_FRESH_MODE_SENSOR_CCF_TRANSFER_HANDOFF_2026-10-25.md) is PREPARED/NOT RUN. **G0/G1 HOLD**, **G2 NOT RUN**, **G3/G4 NOT AUTHORIZED**, **G5 OPEN**. Actual selected machine components and stop/hold/restart UNKNOWN. No people-exposed hazardous operation; any experimental activity must be isolated/remote with personnel outside danger zone and independently reviewed.

## Claim ledger and promotion
SOURCE-CONFIRMED: no new LinuxCNC source trace. DOC-CONFIRMED: exact Pilz and SICK OEM manuals. TEST-CONFIRMED: none. COMMUNITY-REPORTED: none. INFERENCE: state contract/fault transfer. UNKNOWN: selected topology, physical stop/hold, PL/SIL, timing and independent evaluation. Different physical truth could overturn safety, so NOT GRADUATED. No promotion to routine controller-board design.

## Pinned LinuxCNC ordinary at-speed source extension (2026-10-25)
[Direct `062dc7c` source trace](../research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md) is **SOURCE-CONFIRMED**: `motion.c` initializes an unwired `spindle.N.at-speed` input **true**; `tp.c` uses that ordinary Boolean as a wait barrier; the shipped spindle soft-start HAL example derives readiness from **command versus ramped command**, not actual spindle feedback. A different `lathe.hal` example compares command with an encoder-derived speed estimate. `spindle_monitor.comp` latches its at-speed bit and can separately assert underspeed without clearing at-speed until its idle branch. **None of these is an independent personnel-safety speed/standstill/hold channel.** The source is pinned, not tested on a selected machine. Do not confuse a trajectory wait condition with a validated safe-speed monitor or actual Y1/Y2 gravity holding.

**Source-only adversarial correction:** The [pinned at-speed source audit](../research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md) now includes the exact `spindle_monitor` level-0/1/2 state table, strict comparison boundaries, sticky at-speed/underspeed bits, one-invocation clearing delay, `near` numerical OR semantics and `tp.c` configured-spindle wait. These are source-derived predictions, not TEST-CONFIRMED physical behavior. Four additional [paper scenarios](4400_SAFE_SPEED_SELECTOR_SENSOR_INDEPENDENCE_TECHNICIAN_CARD_2026-10-25.md) bring practice to **24**.

**Version-scoped source reinforcement:** [LinuxCNC 2.9 `a33293f` vs development `062dc7c` audit](../research/4400_LINUXCNC_2_9_VS_062DC7C_SPINDLE_AT_SPEED_VERSION_STABILITY_2026-10-25.md) verifies permissive unwired at-speed initialization and command-ramp proxy in both pinned snapshots. Source versions differ in HAL constructor syntax, not the observed readiness authority. No runtime/selected-machine claim.

## 2026-10-30 exact OEM timing/coupling supplement (non-graduated)

Read the [original Pilz 1001715-EN-24 pulse-count, 10% AB/Z plausibility and filter/tolerance addendum](../research/4400_MON_01_PILZ_2025_SHEARPIN_PULSE_COUNT_FILTER_AND_TOLERANCE_TIMING_ADDENDUM_2026-10-30.md) **after** the existing selector and sensor-CCF lessons. The 2-encoder/shear-pin check activates only after minimum speed and pulse-count plausibility tolerance and when not disabled; the OEM gives 7.5 Z-pulses for ratio >=1 or 4.5 AB-pulses for ratio <1 (with ratio-scaled alternatives). Invalid signal-level feasibility checks can take up to 4× the configured tolerance; speed-filter examples reach 99% after ~420/47/9 ms for slow/average/fast. These are *not* complete safety response or physical stopping times. The new exact timing depth is **DOC-CONFIRMED** at the manufacturer edition, not a new scored competency, measured stop distance, or permission to operate. Maintain independent protective final elements and physical load-holding validation; G0/G1 HOLD.

**Further OEM timing/diagnostics depth (same addendum):** Pilz EN-24 §13.3.1 requires square-wave TTL/HTL and safe sensor tracks to be exercised by movement within 8 h for stated PFH assumptions; longer intervals have manufacturer-specific PFH correction factors, **not** an instruction to move an exposed machine. §§13.3.9–10 distinguish normal versus reduced two-proximity diagnostics (conditional 90/99% versus 60% DC examples), and §13.3.4.1 prohibits common-processor-generated sin/cos tracks for a particular mechanically fault-excluded encoder architecture. §13.3.2 explicitly assigns drive stop/brake action to the machine designer, not the monitor. No achieved machine PL/PFH is inferred.
