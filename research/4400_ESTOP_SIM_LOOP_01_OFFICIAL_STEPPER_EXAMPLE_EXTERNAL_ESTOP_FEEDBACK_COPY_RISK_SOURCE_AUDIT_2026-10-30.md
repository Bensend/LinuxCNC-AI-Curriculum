# 4400-ESTOP-SIM-LOOP-01 — LinuxCNC example E-stop loopback copied into a physical machine
**2026-10-30 | SOURCE-CONFIRMED upstream configuration and DOC-CONFIRMED pin contract | NO MACHINE RELEASE | NON-GRADUATED**

## Bounded question and novelty
Can a learner copy an official LinuxCNC HAL configuration that works in simulation into a physical machine and accidentally replace external E-stop *feedback to LinuxCNC* with a software loopback? What is proved, and what is **not** proved, about physical stopping?

Novelty check against the canonical safety index and 2530 route: earlier work already traced `halui.estop.reset` → Task → `user-enable-out`, the `estop_latch` first-scan behavior, and simulated tool-change acknowledgment. This audit adds a **distinct official-documentation-to-real-machine transfer hazard**: the stepper setup chapter's HAL example explicitly loops back E-stop and separately admits that it assumes no external E-stop button. This is **transfer/integration**, not a new scored competency or an allegation that upstream LinuxCNC is a safety-certified controller.

## Immutable source witnesses
1. LinuxCNC **v2.9.10** official `docs/src/config/stepper.adoc`, Git blob `588cca46281e8ad8da5aa2e6c3786214755ee112`: [example around L91–94](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/stepper.adoc#L91-L94); [external E-stop caveat around L235–237](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/stepper.adoc#L235-L237). The physical parallel-port example includes `net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in`; the chapter says `standard_pinout.hal` assumes **no external ESTOP button** and points to `estop_latch` for an external one.
2. LinuxCNC **v2.9.10** `lib/hallib/core_sim.hal`, Git blob `4bdf936603917f7bb1bc36f38dc2a0d8e8124014`: [header L1](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/core_sim.hal#L1) calls this a simulation config; [L46–51](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/core_sim.hal#L46-L51) loops E-stop and tool acknowledgments. Its context is simulation, not a qualified real-machine safety wiring plan.
3. LinuxCNC development commit `24e84c4506b41634240f7087f0295e361a954886`, `docs/src/man/man1/io.1.adoc`, Git blob `fc279016f968299514fc4bf8bc63c138d16be569`: [pin descriptions](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man1/io.1.adoc#L30-L58). `emc-enable-in` is an input to be FALSE on **external** E-stop; `user-enable-out` is an output FALSE on **internal** E-stop; `user-request-enable` reports a user request to clear E-stop. The same manual says the I/O controller is **non-realtime**. This is a different pinned revision from the v2.9.10 example; do not imply identical file editions.
4. Prior [internal-reset source trace](4400_LINUXCNC_INTERNAL_ESTOP_RESET_HALUI_NML_IOCONTROL_SOURCE_TRACE_2026-10-24.md) establishes normal NML/Task state semantics; prior [first-scan latch audit](4400_LINUXCNC_2_9_10_ESTOP_LATCH_FIRST_SCAN_SOURCE_AUDIT_2026-10-23.md) establishes that the HAL software latch is not independent safety logic.

## Mechanism — three different propositions
```text
Example HAL: internal user-enable-out ────────┐
                                             ├── emc-enable-in (ordinary LinuxCNC external-estop feedback input)
NO physical contact / safety PLC feedback ───┘

Real machine must independently establish:
  physical E-stop/protective input → qualified safety logic → selected physical final elements
                                              ↓
                                    independently evidenced stop/hold
  optional appropriately isolated/conditioned status → LinuxCNC normal-control feedback
```

**SOURCE-CONFIRMED:** in the sample, `emc-enable-in` is driven by LinuxCNC's own `user-enable-out`; there is no external E-stop contact, safety-controller state or physical final-element witness in that particular net. The net can therefore report an internally self-consistent state without observing an independent external E-stop fault. It does **not** establish that an actual machine's independent E-stop contacts or safety outputs are defeated: an independent physical safety chain may still remove hazardous energy while LinuxCNC's software feedback remains stale or misleading.

**DOC-CONFIRMED:** the official stepper chapter warns its sample assumes no external E-stop button. It is legitimate as a simulation/learning placeholder, but must not be treated as a complete physical safety design.

**INFERENCE:** copying the line unchanged into a retrofit may hide external-trip status from LinuxCNC and create false confidence during reset, fault recovery, or commissioning. Actual behavior depends on every as-built external circuit and configuration.

## Fault-path and reviewer matrix
| Situation | What the sample HAL can indicate | What the independent machine must prove | Disposition |
|---|---|---|---|
| Simulation with no hazardous actuator | Internal software E-stop request echoed back | No personnel-exposed hazard is represented | Legitimate teaching fixture only |
| Real machine, independent safety relay trips on guard opening | LinuxCNC `emc-enable-in` may still follow `user-enable-out`, not the relay | Final elements withdraw hazard and actual stop/hold; diagnostics accurately disclose trip | **Do not credit HAL status as relay witness** |
| Real machine with only a software loopback and no independent safety function | Software state can be internally consistent | Missing protective stop/hold authority and physical validation | **Do not operate with people exposed** |
| Operator resets LinuxCNC after external fault | Software reset request may restore `user-enable-out` | Independent fault clear, manual reset/rearm and **separate deliberate fresh start**; no retained demand restart | G0/G1 HOLD without proof |
| Loss of cable, feedback, power or configuration mismatch | Sample does not detect a fault not wired into its input | Fault behavior, final-element de-energization and witness appropriate to selected design | UNKNOWN until selected evidence |
| Tool-change loopback copied alongside E-stop line | Tool completion may also be self-acknowledged | Tool capture/retention requires separate real witness | Previously covered; do not count as new finding |

## Practical no-exposure migration review
1. Inventory **all loaded** HAL/INI files and generated configurations, not just the visible GUI. Search for `estop-loop`, `user-enable-out`, `emc-enable-in`, `estop_latch`, `user-request-enable` and implicit `setp` defaults. Do not infer a particular machine uses the sample.
2. Draw four independent boxes: ordinary LinuxCNC command/status, selected independent safety logic, physical final elements, and measured/observed physical stop/hold. Name the source of every arrow.
3. Identify the actual external E-stop/guard/drive/hydraulic feedback that is **appropriately available** to ordinary LinuxCNC; prove it is not merely a software echo. Such feedback is for diagnostics and normal-cycle inhibition, **not** the sole personnel-protection path.
4. Review loss of feedback, stuck-on, held reset, power return, stale status, and retained Cycle Start. Qualified reviewers own acceptance and validation; no energized or hazardous test is requested by this paper review.
5. For a press brake, explicitly keep gravity-loaded Y1/Y2 stopping, independent load holding, hydraulic trapped energy and reset/guard access **UNKNOWN** until selected machine evidence is accepted. For a mill/lathe, account separately for spindle inertia and stored drive energy; for a robot/cell, access/escape and multi-machine span differ.

## Human-factors and low-cost improvement
Ship **separate, conspicuously named** simulation and physical-machine configuration templates. Label any loopback `SIMULATION ONLY — NOT EXTERNAL E-STOP FEEDBACK`; put the external-input mapping and a review checklist adjacent to the machine configuration, not buried in a large manual. Keep status LEDs and fault explanations meaningful so users are not incentivized to bridge inputs to silence nuisance faults. The correct inexpensive first step is an as-built wiring/status review, not a self-invented safety rating or an unsafe powered experiment.

## Claims ledger and lab decision
| Claim | Classification | Evidence / limitation |
|---|---|---|
| Official stable stepper example loops internal enable output into external E-stop input | **SOURCE-CONFIRMED** | Pinned v2.9.10 documentation source |
| Official example expressly assumes no external E-stop button | **DOC-CONFIRMED** | Same pinned chapter |
| `emc-enable-in` is external-status input; `user-enable-out` is internal-status output | **DOC-CONFIRMED** | Pinned development `io(1)` source |
| Physical E-stop chain is disabled on any installed machine | **UNKNOWN / NOT ESTABLISHED** | No selected circuit or machine witness |
| Real-machine software/HMI status could misrepresent a separate physical trip | **INFERENCE** | Conditional on as-built loopback and safety chain |
| Machine stops/holds safely, achieved PL/SIL, stop distance, reset behavior | **UNKNOWN / NOT TEST-CONFIRMED** | Requires selected engineering/physical evidence |

Source/doc reasoning answers the present question; no lab, runner, workflow, or physical machine operation is justified. No new authoritative runtime; leave `LAB_COMPUTE_LOG.md` unchanged. Independent 2520–25F0 competency evaluation remains OPEN and information-separated. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**

## Next evidence
A qualified reviewer may map the **existing** Stage A C/F packets (safety logic/final elements and stop/rearm requirements) to the actual loaded HAL and as-built independent E-stop feedback, privately. Do not broaden the owner-facing A–G request. If selected evidence is unavailable, rotate to a distinct safety mechanism; do not make a new simulation merely to demonstrate a self-loop.

## Direct implementation trace — ordinary E-stop feedback actually consumed (same-session source deepening)
The pin contract is not merely documentation. In pinned LinuxCNC development commit `24e84c4506b41634240f7087f0295e361a954886`:

- `src/emc/task/taskclass.cc`, Git blob `2de1c714641330d77fa5eea4dcfcdd1c82e7c2f7`, [L48–54](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskclass.cc#L48-L54) declares `user_enable_out` **HAL_OUT** and `emc_enable_in` **HAL_IN**. `hal_init_pins()` initializes the internal output false at [L83–86](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskclass.cc#L83-L86).
- `Task::run()` at [L673–683](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskclass.cc#L673-L683) reads `emc_enable_in`; if false it sets `emcioStatus.aux.estop=1`, otherwise clears that ordinary I/O status and can clear `user_request_enable` after a request. This directly establishes that **only the HAL value presented at that pin is read**; no independent physical contact or actuator feedback is implied by the function.
- `src/emc/task/emctaskmain.cc`, Git blob `049c640f1af1b21c18161d6c065ff6f3e35fd83b`, [L3599–3614](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emctaskmain.cc#L3599-L3614) checks `emcStatus->io.aux.estop` and, if trajectory is enabled, requests ordinary trajectory disable and Task/IO/spindle abort/cleanup. The main loop invokes `task_methods->run()` at [L3780](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emctaskmain.cc#L3780). This is **SOURCE-CONFIRMED software propagation**, not an independent safety-rated stopping path or measured reaction time.

**Adversarial correction:** The statement “the loopback defeats the E-stop” is overbroad. The precise source-backed statement is: *the loopback prevents this LinuxCNC HAL input from independently representing an external E-stop state*. A separate hardwired safety circuit could still trip the physical final elements; conversely, absent such a circuit, normal Task abort is not personnel-safety authority. No machine-specific result, scan-time bound, physical stop time or certified safety performance follows.

## Inspectable shipped counterexample — external safety-relay **monitoring** fed into LinuxCNC
The repository also ships [`configs/by_machine/smithy/924.hal` L99–101](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.hal#L99-L101), stable v2.9.10 Git blob `c40c14e3f3cbad07b9aefd715cb57e4e442a950b`, with the comment **“Safety Relay Monitoring Contacts”** and `net estop-enable hm2_5i20.0.gpio.037.in => iocontrol.0.emc-enable-in`. The inspected development file, blob `4fc5bab2148c28f598c4858e8d5cc6e1a3f10ead`, retains that mapping. **SOURCE-CONFIRMED:** this shipped configuration routes an external digital input to LinuxCNC's E-stop feedback pin rather than self-looping `user-enable-out`. This is a concrete **normal-control diagnostic integration pattern**, not proof that the referenced relay, wiring, machine, final elements, physical stop, or monitoring-contact semantics are independently safety-qualified. It does **not** establish the installed OpenPressBrake topology. The safe review question becomes: *does the selected independent safety circuit protect the machine physically, and is its appropriate state separately reported to ordinary LinuxCNC without substituting for that circuit?*

## Stable v2.9.10 implementation source — version-aware correction to the development trace
The stable v2.9.10 sample must not be presented as though it runs through the **newer** development `Task::run()` implementation. Stable v2.9.10 has a separate I/O controller: [`src/emc/iotask/ioControl.cc` L8–42](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl.cc#L8-L42), Git blob `09cbd6ff4e5e119df04e61ffb8916b283a2f2014`, explicitly documents the three enable pins, recommends `user-enable-out → emc-enable-in` for the **simplest** system, and sketches a ClassicLadder external-E-stop/reset-feedback arrangement. [`read_hal_inputs()` L515–530](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl.cc#L515-L530) reads `emc_enable_in` and sets ordinary `emcioStatus.aux.estop` based on its Boolean value. The stable `ioControl_v2.cc` variant (blob `9f09844a7b1af4c5e0674470037e75910820e4a0`) retains the same described pin roles and `read_inputs()` Boolean test at [L602–615](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl_v2.cc#L602-L615). In the **development** snapshot, this role is integrated into `Task::run()` as traced above.

**Safety caveat:** the historical ClassicLadder example is a **normal-control integration explanation**, not a claim that ClassicLadder, an ordinary HAL input or a user reset button is an independently certified safety controller. A physically separate qualified E-stop/protective-device chain must own personnel protection, and an appropriate isolated/conditioned status may feed LinuxCNC for diagnostics. The official sample's loopback is intentional for the stated simple/no-external-input context; the hazard is **unreviewed reuse outside that context**, not proof of an upstream implementation defect.
