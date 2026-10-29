# 4400-ROBOT-STATUS-01 — Safety output labels are not physical stop/standstill or tool-energy proofs
**2026-10-29 | original UR g-Series PolyScope X SW10_15 safety-functions table | NON-GRADUATED / no lab**

## Question and predecessor
The [ENABLE-02 audit](4400_ENABLE_02_UR_SW10_15_THREE_POSITION_MODE_FREEDRIVE_SF19_SF20_OUTPUT_CONTRACT_OEM_AUDIT_2026-10-29.md) identifies mode-dependent 3PE output polarity. A second, distinct integration question arises in the *same original OEM safety-function table*: what exactly do signals named **Robot Moving**, **Not stopping**, and **Safeguard Stop** mean? Can an integrator wire a robot-status output directly as "tool safe / guard unlock / pressure safe"?

## Direct source
Universal Robots, *g-Series User Manual, PolyScope X SW10_15, Safety Functions Table*, original online OEM:
https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/safetyFunctionsAndinterfaces/safety_functions_table1.htm

Directly inspected 2026-10-29, table lines 76–88, 109–119 and footnotes 171–180. This is **DOC-CONFIRMED** for the documented version and product family only. No original PDF bytes/hash, selected installed firmware, physical output trace or other robot version was verified.

## Exact documented semantics
1. **SF11 "Moving" output:** dual outputs are **LOW whenever the robot is moving** and **HIGH when no movement** (table rows 112–113). The label is *not* a statement that HIGH means "moving." Even a documented nonmoving status does not independently establish a payload landed, hydraulic pressure exhausted, tool de-energized, or personnel-clear zone.
2. **SF12 "Not stopping" output:** the table states dual outputs are **HIGH while the robot is STOPPING or at standstill**, and **LOW when neither stopping nor stopped** (rows 114–115). This is not a proof that the robot has already reached standstill; **HIGH explicitly includes the deceleration interval**. Preserve the manufacturer's exact truth description rather than reverse-engineering semantics from the signal name.
3. **SF2 Safeguard Stop:** the manufacturer specifies **Stop Category 2 / SS2**; the robot retains drive power after stopping, and **tool I/O are unaffected by this safeguard stop** (rows 82–85, footnote 4). A stopped arm can therefore still have a powered tool or externally energized end effector. Tool-specific safety needs its own selected protective path.
4. **SF1 Emergency Stop:** the manufacturer describes **Stop Category 1**, with removal of actuator/tool I/O power after monitored standstill, and explicitly says not to use the manually actuated E-stop as a substitute for guarding (rows 79–81). This is a different OEM stop path from SF2.
5. **Integrated output PFH is a system question:** the table explicitly requires external-device/logic PFH and architecture to be considered for an integrated function (intro and footnotes 3, 6, 8). A robot's component-level PLd Category 3 statement cannot be copied onto an unvalidated external valve, gripper or guard.

## Adversarial integration paths (INFERENCE, no physical fault claimed)
| Misread signal | Consequence to investigate | Countermeasure / qualified proof |
|---|---|---|
| SF12 HIGH treated as "already stopped, unlock door" | HIGH can occur while still decelerating | Guard unlock requires validated actual standstill/stop-time/distance and separate hazard assessment. |
| SF11 HIGH treated as "safe to release workpiece" | Arm motion status does not show payload support | Positive workpiece support and independently justified release path. |
| SF2 stop wired as sole tool-energy inhibit | Manufacturer says tool I/O unaffected | Selected safety-rated tool isolation or load-retention architecture; physical witness. |
| E-stop chosen as routine protective guard | Manual actuation cannot replace automatic guard | Independently validated protective device and deliberate restart. |
| Green HMI mirrors one safety output | Stale/wrong-context status may conceal other hazards | Clear mode/status diagnostics without granting safety authority to HMI/LinuxCNC/FPGA. |

## Cross-machine lesson
A safety-related output is a **documented proposition with exact polarity, time/transition scope, mode and application**, not a universally safe word. For a robot with a vacuum gripper, a stopped arm does not prove vacuum retained; for a magnet, a stopped arm does not prove the load can be demagnetized; for a press brake, a stopped control command does not prove gravity-loaded ram restraint. These are **INFERENCE transfers**, not claims about installed equipment.

## Verification and disposition
- **DOC-CONFIRMED:** exact UR SW10_15 table/footnotes as described.
- **SOURCE-CONFIRMED:** repository predecessors [VAC-LIFT-01](4400_VAC_LIFT_01_SCHMALZ_PIAB_POWER_LOSS_DROP_VS_SEALED_VACUUM_RETENTION_OEM_AUDIT_2026-10-29.md), [MAG-LIFT-01](4400_MAG_LIFT_01_ECLIPSE_2026_POWER_LOSS_HOLD_WLL_CONFLICT_AND_RELEASE_INTERLOCK_OEM_AUDIT_2026-10-29.md), ENABLE-02.
- **INFERENCE:** safety architecture and cross-machine transfer.
- **UNKNOWN:** selected UR robot/configuration, physical I/O and final elements, real stopping/hold/guard performance, integrated PFH, evaluator score.
- **TEST-CONFIRMED:** none. No simulation, workflow, physical machine operation or lab; original OEM table resolves the logical question without compute.

**Minimum operation boundary:** do not allow personnel exposure where selected stopping, tool-energy and guard functions are not independently validated. OpenPressBrake Stage A A–G qualified public status not established (restricted receipt UNKNOWN), G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.

## Same-session independent OEM cross-check — fault lows, OSSD pulses, and external E-stop reset
Directly inspected **Universal Robots g-Series PolyScope X SW10_15, Safety I/O**:
https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/H_g5_sections/SafetyIO_v2/psx_safetyIO_v2.htm (web lines 92–99, 131–149). This independent OEM page corroborates **Robot Moving LOW when moving** and **Robot Not Stopping HIGH while stopping or stopped**. It adds three consequential, source-specific integration requirements:

1. **DOC-CONFIRMED fault behavior:** the manufacturer says **all safety outputs go LOW on a safety-system violation/fault**. Therefore a LOW value must be interpreted in the context of the selected function and faults, not naively as one physical event.
2. **DOC-CONFIRMED optional OSSD test pulses:** with the selected safety output's OSSD option enabled, the OEM specifies **1 ms LOW pulses once every 32 ms while the output is otherwise inactive/HIGH**, with 18 ms channel offset. Its safety input filtering samples every 1 ms and determines state over the last 7 ms. These are **UR SW10_15 configuration-specific interface facts**, not universal OSSD pulse timing or a reason to insert arbitrary debounce in a safety chain. An external receiver must be qualified for the selected pulse/fault behavior. Ordinary LinuxCNC GPIO or HMI sampling is not safety-rated OSSD evaluation.
3. **DOC-CONFIRMED external E-stop reset propagation:** the OEM warns that when the robot's external E-stop is released, its System Stop output can return HIGH and the *external machinery's E-stop state may reset without manual action at the robot*. The external machinery **must require a separate manual action to resume**. The manufacturer also describes an exceptional System Stop deadlock-avoidance case when the stop originates from the System Stop input; preserve the exact selected topology rather than assuming every low/high maps to the same stop.

A second manufacturer version, **UR SW5_25 UR8 Long Configurable Safety Functions**, independently describes `Robot Moving` HIGH when no joint exceeds its stated motion criterion and `Robot Not Stopping` HIGH when stopped or stopping: https://www.universal-robots.com/manuals/EN/HTML/SW5_25/Content/prod-usr-man/complianceUR8Long/H_g5_sections/safetyFunctionsAndinterfaces/configurable_functions.htm . This is **cross-version DOC corroboration of the broad output polarity**, not evidence that every version's thresholds, OSSD settings, SF19/20 behavior or hardware is identical.

**Adversarial correction:** a receiver that assumes a continuous, pulse-free HIGH will see periodic LOW test pulses in an OSSD-configured output; a receiver that treats E-stop-release HIGH as a new run command can restart another machine without a deliberate new start. Both are **INFERENCE failure paths**, not observed installations. Qualify the exact selected safety controller and receiver, ensure fresh restart, and independently verify the physical safe state. No lab, test, selected machine, or score.
