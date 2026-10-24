# 4400 — Rockwell GuardLogix FSBM: zero timers, override, validity, reset and restart
**Date:** 2026-10-24 | **Status:** official manufacturer online documentation, NOT controller source or runtime test.

## Frozen question
Can a safety muting function block be configured so that a nominally bounded mute or override never times out, and does a safety-instruction output prove downstream physical stop/hold or safe restart?

## Direct official source
**DOC-CONFIRMED from manufacturer-published online instruction reference:** Rockwell Automation, *Studio 5000 Logix Designer — Four Sensor Bi-Directional Muting (FSBM)*, version 38-03 online help, [official page](https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-03/contents-ditamap/instruction-set/safety-instructions/fsbm.html), inspected via manufacturer-indexed text. Some direct HTML opens time out; **do not represent the original 450L-UM001H 54 MB PDF as directly inspected**. This is a GuardLogix safety instruction, **not** the 450L light curtain's internal muting firmware and **not** a LinuxCNC HAL component.

## Exact documented discriminators
| ID | FSBM documentation finding | Design consequence |
|---|---|---|
| R-FSBM-01 | Four sensors must form a valid forward/reverse sequence around the light curtain; material shape, speed and geometry matter; a person must not reproduce a valid sequence. | Sensor count alone cannot qualify anti-tailgating. |
| R-FSBM-02 | S1-S2, S2-LC, LC-S3 and S3-S4 timing operands accept **0 to disable their respective timer** (otherwise documented 5–180,000 ms range). | Never treat a zero configuration value as zero allowed time. |
| R-FSBM-03 | Maximum Mute Time **0 disables its timer** (otherwise 0–3600 s), and Maximum Override Time **0 disables its timer** (otherwise 0–30 s). | A 'timeout = 0' parameter may mean unbounded duration, not fail-closed. Record actual setting and safety rationale. |
| R-FSBM-04 | Override rising edge can energize Output 1 **regardless of Input Status or existing faults**, subject to instruction's override rules; OEM requires hold-to-run at a location with visibility of sensing field. | O1=1 during override is not 'all sensors valid' or 'hazard clear'. A separate qualified recovery envelope is essential. |
| R-FSBM-05 | Restart Type distinguishes manual reset-edge from automatic restart when enabling conditions are met. Manufacturer restricts automatic restart to applications assessed safe for it. | Controller output readiness must not be mistaken for a fresh normal CNC cycle request. |
| R-FSBM-06 | Muting Lamp Status false inhibits normal muting; if no lamp required the manufacturer describes setting this input true. | A constant-true diagnostic input is not independent evidence that a lamp physically works. |
| R-FSBM-07 | Changing certain configuration operands online requires accepting edits and cycling controller Program -> Run to take effect. | An operator HMI may display an edited timer that is not the effective safety-controller runtime configuration. |
| R-FSBM-08 | Incorrect backing-tag sharing/writing and misuse of EnableIn can cause unexpected operation/controller faults. | Treat instruction instance state and project review as part of safety change control. |
| R-FSBM-09 | Invalid sequence de-energizes Output 1 and reports fault; input status loss is a documented fault. | Physical stopping/holding is still downstream; neither a function-block bit nor a fault code proves final-element behavior. |

## Cross-OEM comparison — deliberately no parameter transplant
SICK deTec4 HG SP2 documents 24-hour concurrence/total time and special belt-stop pausing; Rockwell FSBM documents zero as *disabled* for several timers. These are **different** device/controller architectures. Never import SICK's sensor-connection 50 ms rule, SP2 override counter, or belt-stop logic into FSBM; never assume FSBM's zero-time semantics apply to SICK.

## Adversarial commissioning thought experiments (PAPER ONLY)
A project shows Max Override=0: do not assert 'override immediately ends'; first verify documented disable semantics and physical controls. A PLC tag shows Input Status false while Override true and O1 true: do not assert impossible state. A parameter was changed online but controller mode never cycled: runtime effective value remains unverified. A fault resets and Output 1 becomes true: do not infer the conveyor can restart while someone is beyond the light curtain.

## Evidence ledger
**DOC-CONFIRMED:** R-FSBM-01..09 within cited manufacturer help. **SOURCE-CONFIRMED:** none (manufacturer online help is documentation, not source code). **TEST-CONFIRMED:** none. **INFERENCE:** independent safety relay/logic, monitored final elements, whole-body occupancy and deliberate restart are necessary integration questions. **UNKNOWN:** installed controller/version, whether FSBM is used, effective operands, actual safety performance and physical stop/hold. No selected OpenPressBrake installation claimed.

## Physical release
No person in hazardous area for testing. Before any attended use, independent competent review must confirm actual application, field geometry, safety controller logic, fault reactions, physical final elements and fresh start. Otherwise operate only isolated/remote with people outside danger and residual risk recorded.
