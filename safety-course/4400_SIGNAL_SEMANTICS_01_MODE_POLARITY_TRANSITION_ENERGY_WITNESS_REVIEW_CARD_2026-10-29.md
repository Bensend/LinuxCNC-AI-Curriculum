# 4400-SIGNAL-SEMANTICS-01 — Before trusting a named safety output
**2026-10-29 | reusable source-to-integration review card | documentary design method, not a test or certification**

## The practical mistake
A label such as `Moving`, `Not stopping`, `Enabled`, `Ready`, `Safe Home`, `Reduced` or `Guard Clear` sounds like a physical condition. The selected OEM may instead define a particular *polarity, transition, phase or operating-mode-dependent proposition*. A correctly functioning signal can be dangerously misinterpreted by an external controller.

The [UR SW10_15 ENABLE-02](../research/4400_ENABLE_02_UR_SW10_15_THREE_POSITION_MODE_FREEDRIVE_SF19_SF20_OUTPUT_CONTRACT_OEM_AUDIT_2026-10-29.md), [ROBOT-STATUS-01](../research/4400_ROBOT_STATUS_01_UR_SW10_15_MOVING_NOT_STOPPING_TOOL_IO_AND_SAFEGUARD_STOP_SEMANTICS_AUDIT_2026-10-29.md) and [ROBOT-PLANE-01](../research/4400_ROBOT_PLANE_01_UR_SW10_15_DYNAMIC_SAFETY_PLANE_LATE_TRIGGER_AND_UNMONITORED_GEOMETRY_OEM_AUDIT_2026-10-29.md) provide exact manufacturer counterexamples. This card **reuses** them; it does not claim a new machine-level competency.

## Eight-point point-of-use review (desk work before wiring, programming or machine operation)
| Gate | Question the integrator must answer | Example from inspected OEM | If unresolved |
|---|---|---|---|
| 1. Identity | Exact selected device, software, manual edition, terminal and output option? | UR g-Series PolyScope X SW10_15 table; not generic robot output | UNKNOWN; do not reuse another variant's truth table |
| 2. Polarity | Does HIGH mean positive condition, its complement or an inverted safety state? | SF11 `Moving` HIGH means no movement | Do not infer from label or LED |
| 3. Mode | Which operational modes and feature states change meaning? | SF19 HIGH in Automatic even with 3PE inactive; Freedrive reverses manual aggregation | Require selected mode/feature as explicit input to interpretation |
| 4. Transition | Is the output level a momentary event, a retained state, or an intermediate stopping phase? | SF12 HIGH includes stopping *and* standstill | Do not use as unqualified standstill/door unlock |
| 5. Energy | Which physical energy domain is actually affected? | SF2 Cat2 retains robot drive power and tool I/O | Separate end-effector/tool/pressure/load safety functions |
| 6. Geometry/time | What points, zones, latency and distance are within the claim? | SF23 late plane can be crossed; configured spheres do not cover entire arm | Do not assert full-body/whole-tool exclusion |
| 7. Integration | What external receiver, fault handling, PFH/dependencies, reset and final elements are qualified? | UR OEM explicitly requires integrated PFH and external-equipment validation | No generic PL/SIL transfer; selected SRS and validation required |
| 8. Human | Can an operator see the true mode, avoid inadvertent rearm and complete setup without defeating safeguards? | High-speed manual and guard suspension are separate selected states | Redesign workflow/guard/fixture before allowing shortcuts |

## Fillable **generic** proposition (not an OpenPressBrake owner questionnaire)
`Selected device/version | named output + electrical level | mode/feature | triggering event | validity/freshness | monitored physical quantity | NOT guaranteed | receiving safety logic | independent final element | physical witness | reset/restart rule | evidence ID | status`

For each output, write both **what is proved** and **what is not proved**. Treat UNKNOWN, contradictory, stale, and mode-mismatched conditions as HOLD for the affected safety function. This card is for an engineer's selected-machine private review; it does not request public drawings, terminal numbers or proprietary configurations.

## Boundary examples
- **Robot:** a stopped joint is not a supported suspended sheet, de-energized gripper or safe full-body access.
- **Press brake:** Y1/Y2 command disabled or a healthy EDM signal is not physical ram holding, pressure exhaustion or guarded access.
- **Plasma/laser:** process-output OFF is not a verified arc/beam extinguished and safely isolated.
- **Mill/lathe:** spindle-speed display zero is not torque-free, standstill, safe chuck/clamp release or maintenance isolation.
- **Automated cell:** a single robot's safe-state bit does not include other axes, fixtures, tooling, or people inside the cell.

These transfers are **INFERENCE**, not proof about any installed machine. Ordinary LinuxCNC/FPGA/HMI is normal control/diagnostics, not independent personnel-safety authority. Physical energy removal/holding and guarding remain separate. A machine that cannot establish minimum safe-to-operate protection must not operate with people exposed; isolated/remote experimental operation requires qualified authorization, people outside the danger zone and explicit residual risk.

## Evidence and no-compute decision
**DOC-CONFIRMED:** exact UR SW10_15 and IDEC OEM passages in linked audits. **SOURCE-CONFIRMED (repository):** existing 2520–25F0 and 4400 source/traceability methodology. **INFERENCE:** reusable review method and cross-machine examples. **UNKNOWN:** selected machine, adopted procedure, operator usability and actual safety outcome. **TEST-CONFIRMED:** none. No lab is justified to rediscover the OEM truth table; selected physical proof belongs to qualified validation after documentary G0/G1 gates. Independent evaluator remains OPEN; G0/G1 HOLD.


**Original-OEM interface-depth addendum (2026-10-29):** UR SW10_15 [Safety I/O](https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/H_g5_sections/SafetyIO_v2/psx_safetyIO_v2.htm) explicitly documents optional **1 ms LOW OSSD pulses / 32 ms interval** on otherwise HIGH outputs, all outputs LOW on safety faults, and external E-stop release returning a System Stop output HIGH while the receiving machine must require a **separate manual action to resume**. Add to Gates 2–4/7: `test-pulse configuration + receiver compatibility | fault LOW vs normal LOW | independent external restart interlock`. These are exact selected-product documentation claims, not universal OSSD timing or permission to filter safety signals in normal LinuxCNC software. [Source-depth audit](../research/4400_ROBOT_STATUS_01_UR_SW10_15_MOVING_NOT_STOPPING_TOOL_IO_AND_SAFEGUARD_STOP_SEMANTICS_AUDIT_2026-10-29.md).
