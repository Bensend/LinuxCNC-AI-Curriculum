# 4400-ATC-01 — CNC spindle/toolchanger retention versus safety, energy and access
**4000 Safety | 2026-10-25 | SOURCE-READING / NOT GRADUATED | no lab or physical tests**

## Prerequisites and learning objective
Requires 2520 hazard/SRS, 2540 final elements, 2570 drive STO, 2580 isolation, 2590 guarding, 4400-BLK-01 mechanical restraint, 4400-PNEUMATIC exhaust/hold research and 4400-CELL-01 whole-body reset. Learner must distinguish **tool clamp position**, **physical retention force**, **pneumatic release**, **arm/pocket capture**, **Z/spindle drive stop**, **guarded access**, **service isolation**, and **deliberate restart**.

Also inspect the [pinned LinuxCNC M6/iocontrol ordinary acknowledgment source trace](../research/4400_LINUXCNC_PINNED_M6_IOCONTROL_TOOL_CHANGED_ACK_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-25.md): stock `tool-changed` Boolean acknowledgment drives Task completion, not a measured mechanical force or independent safety verdict.

Read [direct Haas original OEM source audit](../research/4400_HAAS_TOOL_RELEASE_DRAWBAR_PRECHARGE_SENSOR_AND_TOOL_DROP_OEM_AUDIT_2026-10-25.md) and [14 learner-visible paper scenarios / blank witness](4400_ATC_TOOL_RELEASE_AND_CAPTURE_TECHNICIAN_CARD_2026-10-25.md).

## Documented physical mechanisms
Haas 40T drawbar troubleshooting **TG0132 Rev A 12/2025** describes spring retention parts, insufficient drawbar clamp force, precharge effects, unexpected release associated with a solenoid-delay fault, and TRP sensor misalignment. Haas SMTC **TG0128 Rev B 08/2025** describes double-arm slide/retainer adjustment, pocket extractor wear, and a failed home sensor/cable leading to a hazardous Z-axis movement. **DOC-CONFIRMED for those OEM examples only**; no claim installed on OpenPressBrake or a LinuxCNC machine.

## Architecture and fault table
| Normal status or command | Separate physical safety proposition | Failure to analyze |
|---|---|---|
| `spindle.0.on=false` or STO | tool retained and no unintended drop | weak springs, bad pull stud, precharge |
| `tool-clamped=true` | sufficient clamp force and retention under load | position switch misadjusted, force low |
| `arm-home=true` | arm actually clear of Z travel and tool captured | failed proximity sensor/cable, bad alignment |
| `TRP-solenoid=false` | no pressure/trapped energy can actuate release | stuck valve, cross-feed, retained air |
| `guard-closed=true` | no person inside cell or tool-drop zone | walk-through, blind spot, defeat |
| `reset-accepted=true` | independent physical safe state and fresh new start | queued M6/Z motion, stale commands |

These are **INFERENCE design-review discriminators**, not tested safety logic or approved circuits.

## Design contract (not installed wiring)
**SF-ATC-RETAIN:** define and validate selected retention force and mechanical capture with OEM tooling and qualified measurements; do not borrow Haas numbers for another taper. **SF-ATC-TRANSFER:** prohibit hazardous release unless the receiving arm/pocket actually supports the tool and personnel are excluded by a validated independent protective function. **SF-ATC-ACCESS:** prevent unexpected Z, spindle, arm, pocket and pneumatic release motion during access. **SF-ATC-SERVICE:** isolate/verify electrical, pneumatic, spring and gravitational energy for the task; E-stop, MDI and software enable are not isolation. **SF-ATC-RESTART:** guard replacement/reset does not execute retained M6/Z movement; require deliberate new start and verified machine readiness.

## Human factors
Provide accessible inspection of wear and capture status without reaching below a suspended tool, labeled pressure/energy zones, simple reliable guard reinstallation, an unambiguous tool recovery mode with safe access and clear fault messages. Ask maintainers how often they defeat the enclosure to clear jams; treat friction as a design input. Prefer inexpensive proven mechanical containment and OEM-supported parts over complex FPGA inference.

## Cross-machine transfer
Mills/routers: spindle drawbar and changer arm; lathes: turret/toolholder retention and spindle coast; robot cells: end-effector drop and toolchanger locking; press brakes: die clamping and gravity ram hold (different mechanism); plasma: torch holder release and process energy. Do not transplant Haas toolholder-specific specs or claim equivalence.

## Qualification
G0/G1 HOLD: selected inventory, as-built mechanism, safety architecture, actual tool mass/retention OEM criteria, zones and independent final elements. G2 paper review only, NOT RUN. G3/G4 protected physical tests NOT AUTHORIZED without qualified plan and people excluded. G5 fresh independent evaluation OPEN. All PAPER cases not blind scores.

**Promotion:** selected spindle variant/force test (UNKNOWN/HIGH, blocks selected-machine graduation); actual safety-rated interlocks and mechanical capture (UNKNOWN/CRITICAL, blocks); air-release and trapped pressure state (UNKNOWN/HIGH, blocks); physical stop/hold/drop/zone witnesses (UNKNOWN/CRITICAL, blocks); novel fresh-AI handoff (UNKNOWN/HIGH, blocks). Counterfactual different physical truth could invalidate safety, so NOT GRADUATED. No LinuxCNC or FPGA personnel-safety authority.


## 2026-10-28 source-depth addendum — M61 tool identity is not a tool-retention witness (NON-GRADUATED)
**New exact source mechanism beyond the original M6 `tool-changed` acknowledgment:** [LinuxCNC v2.9.10 `interp_convert.cc` L3417–3435](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3417-L3435), blob `f01a359652d588d59c9e210fa441a99d2ee19598`, handles M61 Q as a **tool-number assignment**, checks nonnegative Q and a known tool index, sets `current_pocket`, flags synchronization and calls `CHANGE_TOOL_NUMBER`. [`emccanon.cc` L2149–2156](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L2149-L2156), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, appends `EMC_TOOL_SET_NUMBER` rather than `EMC_TOOL_LOAD`; [`emctaskmain.cc` L2097–2100](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2097-L2100) dispatches to `emcToolSetNumber` and [`taskclass.cc` L748–756](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskclass.cc#L748-L756), blob `31043d7e2aad68f2ffabc02408e7b13085d126bc`, forwards a set-number message. **SOURCE-CONFIRMED** status/identity update path; not a physical tool exchange, clamping or retention-force measurement. The [official M61 documentation](https://linuxcnc.org/docs/stable/html/gcode/m-code.html) explicitly says M61 changes current tool number **without a tool change** and does **not** update tool-length offset (G43 is separate). **DOC-CONFIRMED**.

**Practical failure discriminator:** after M61, the displayed tool number may agree with the operator's entered identity even if the actual tool, drawbar retention, pocket/arm clearance or tool-length offset differs. The selected machine's actual mismatch is **UNKNOWN**, not observed. A qualified tool-ID verification, mechanical capture/retention and guarding workflow is separate from the ordinary M61 status; avoid a convenience button that silently turns an unverified tool into “verified installed.” The safe service path should make physical confirmation easy and guard bypass unnecessary. No personnel-safety authority in LinuxCNC/HAL/FPGA, no tool-drop test or new paper exam. G0/G1 HOLD, external evaluator OPEN; hosted/local compute 0 min.


**Pinned development comparison (2026-10-28 audit):** At upstream commit [536d1baec1f2e5daf60cc856fda95a24160f6e89](https://github.com/LinuxCNC/linuxcnc/commit/536d1baec1f2e5daf60cc856fda95a24160f6e89), [`interp_convert.cc` L4203–4208](https://github.com/LinuxCNC/linuxcnc/blob/536d1baec1f2e5daf60cc856fda95a24160f6e89/src/emc/rs274ngc/interp_convert.cc#L4203-L4208) still calls `CHANGE_TOOL_NUMBER`; [`emccanon.cc` L3125–3133](https://github.com/LinuxCNC/linuxcnc/blob/536d1baec1f2e5daf60cc856fda95a24160f6e89/src/emc/task/emccanon.cc#L3125-L3133) explicitly comments that this is from M61 and appends `EMC_TOOL_SET_NUMBER`; [`emctaskmain.cc` L919–926](https://github.com/LinuxCNC/linuxcnc/blob/536d1baec1f2e5daf60cc856fda95a24160f6e89/src/emc/task/emctaskmain.cc#L919-L926) queues the status command and interpreter resynchronization. **SOURCE-CONFIRMED** normal identity path at pinned development; the newer Task scheduling details differ from v2.9.10 but neither source establishes actual tool retention. No test, selected machine or independent evaluator.
