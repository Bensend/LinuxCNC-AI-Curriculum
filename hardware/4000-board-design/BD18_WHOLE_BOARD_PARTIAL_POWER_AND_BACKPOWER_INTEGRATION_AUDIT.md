# BD18 — Whole-Board Partial-Power and Back-Power Integration Audit

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BOARD INTEGRATION stress-testing BLOCK ENGINEERING contracts  
**Design-flow position:** reusable lifecycle contracts -> cross-domain board composition -> fault-created power states -> verification/commissioning gates

## Purpose

BD17 made startup, reset, brownout and partial-power behavior part of a reusable block contract. BD18 composes those contracts across a complete controller and asks a harder question:

**WHAT CAN POWER WHAT WHEN THE BOARD IS NOT IN ITS INTENDED STEADY STATE?**

Normal startup order is not sufficient evidence. Service cables, external machine devices, stored energy, branch faults, failed regulators, isolated field supplies and connector hot-plug can create combinations the normal sequence never requests.

Core rule:

**AN UNINTENDED POWER COMBINATION IS NOT IMPOSSIBLE MERELY BECAUSE FIRMWARE NEVER REQUESTS IT.**

## Learning outcomes

The student can:

1. enumerate board power domains without collapsing separately owned field and logic sources;
2. build a whole-board partial-power matrix;
3. trace every cross-domain signal as a possible phantom-power path;
4. distinguish galvanic isolation from back-power immunity elsewhere on the board;
5. distinguish signal survivability, signal validity and machine-output authority;
6. audit USB/service interfaces without assuming VBUS powers the board;
7. preserve source/return ownership while tracing clamp and fault currents;
8. identify which answers belong to reusable blocks and which belong to board integration;
9. turn missing lifecycle data into explicit catalog defects rather than assumptions;
10. define bench evidence needed before a physical partial-power claim can be released.

## Student-facing source audit

The following CURRENT artifacts were opened directly during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml` — current CORE_24V/5V_MAIN architecture, separately assigned sensor/proportional field domains, explicit backfeed-prevention requirement and open board-wide brownout/fault-isolation work.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — core rails, hardware output authorization, FT2232H service interface and explicit USB-VBUS detect-only/no-board-power/no-backfeed contract.
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml` — isolated field/logic boundary and its still-incomplete lifecycle semantics.
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml` — current ownership rule that reusable blocks publish their supply demand and board integration aggregates it once without reconstructing block internals.
- Curriculum `hardware/4000-board-design/BD17_STARTUP_RESET_PARTIAL_POWER_AND_DEENERGIZED_STATE_CONTRACTS.md` — reopened to ensure BD18 composes rather than duplicates block-local lifecycle analysis.

These artifacts are not evidence that the complete OpenPressBrake controller is production qualified.

## 1. Build the domain inventory before drawing arrows

For the current OpenPressBrake example, keep at least these concepts distinct:

| Domain/source | Current authority | Integration meaning |
|---|---|---|
| machine regulated 24 V | cabinet/source contract | upstream energy source; not a generic claim that every 24-V board net is common |
| CORE_24V / 24V_LOGIC_PROTECTED | machine_power | protected ordinary-control branch |
| 5V_MAIN / 5V_CORE_IN | machine_power -> core | low-voltage source feeding core and other explicitly assigned consumers |
| 3V3_CORE / FPGA_2V5 / FPGA_1V1 | fpga_core | locally converted core rails |
| PVR_SENSOR_24V | board integration | separately sourced sensor-field domain; excluded from CORE load accounting |
| PROP_FIELD_24V | board integration | proportional-load source domain; excluded from CORE logic branch |
| switched output field domains | output integration | load-side energy must not be confused with logic-side command power |
| USB VBUS | external service host | detection/reference only in the current core contract; not board power |
| externally powered machine signals | machine/harness | may remain energized while controller logic is absent |

A board audit must preserve electrical source identity and current-return ownership. Similar nominal voltages do not authorize a bridge.

## 2. The whole-board matrix

Create rows for domain combinations, not merely startup timestamps. At minimum challenge:

| Case | CORE | core rails | field domains | USB/service | Required question |
|---|---|---|---|---|---|
| A | off | off | off | off | true de-energized state |
| B | off | off | on | off | can field signals/loads phantom-power logic? |
| C | on | valid | off | off | are external pins benign into unpowered devices? |
| D | off | off | off | connected | can service VBUS lift any board rail? |
| E | off | off | on | connected | are there two independent injection sources? |
| F | on | one rail failed | on | any | does output authority fail low? |
| G | brownout | collapsing | on | any | clamp/reset/watchdog ordering and chatter risk |
| H | recovering | ramping | on | any | can prior commands reassert before current authority? |
| I | on | valid | one field branch failed | any | can diagnostics/status backfeed failed branch? |
| J | off | stored energy | external devices on | any | capacitor/inductor/external-device discharge paths |

Do not mark a cell `safe`. Record three independent results: **survives? valid? authorized?**

## 3. Trace every cross-domain signal as a power path

For every signal crossing two domains record:

`source -> series impedance -> protection/clamp/input structure -> sink rail/return`

Then evaluate both directions with either side unpowered. Include:

- FPGA GPIO and bank clamps;
- transceiver pins;
- isolator logic and field pins;
- ADC/DAC/analog clamps;
- pull-ups to rails that can disappear independently;
- status/fault outputs;
- SPI/I2C/MDIO/UART/RS-485 interfaces;
- output-driver command/diagnostic pins;
- encoder/sensor supplies and signal returns;
- USB VBUS detect and data protection;
- connector shields/chassis coupling;
- external machine devices that source a signal while board power is absent.

If the unpowered-input specification, clamp topology or limiting impedance is unknown, the answer is `ENGINEERING_REVIEW_NEEDED`.

## 4. OpenPressBrake USB example: a good explicit boundary

The current FPGA-core manifest says the FT2232H service interface is **self-powered from `3V3_CORE`** and describes USB VBUS as `protected_detection_reference_only_no_board_power_no_backfeed`.

That is exactly the kind of reusable contract an integrator needs. It allows the board matrix to state the intended topology: plugging in USB must not become an alternate board-power source.

But topology intent and component naming do not by themselves constitute assembled-board hot-plug qualification. Final evidence still requires exact rendered connectivity, protection orientation, PCB implementation and physical test where needed.

Freeze:

**USB CONNECTED != BOARD POWERED.**  
**DETECT-ONLY CONTRACT != ASSEMBLED-BOARD BACKFEED QUALIFICATION.**

## 5. OpenPressBrake field-source example: separate means separate

The current machine-power contract explicitly keeps Rev1 sensor and proportional field sources outside the protected CORE logic branch. It also requires prevention of field-domain backfeed into logic through diagnostics, current-sense, driver or protection structures.

This creates two obligations:

1. power accounting must not silently add field loads to the CORE branch; and
2. signal/protection paths must not silently reconnect those sources during partial power.

A diagram that shows separate supplies but ignores a diagnostic IC's input clamp is incomplete.

Freeze:

**SEPARATE POWER BUDGETS != PROVED ELECTRICAL ISOLATION.**

## 6. Isolation must be scoped to the actual path

The current digital-input block uses an ISO1212 field-to-logic boundary and independent field-return islands with controlled EMC coupling to chassis. That is strong normal electrical architecture.

However, as BD17 found, the current manifest does not yet publish a complete field-only/logic-only/ramp-down/signal-valid/back-power lifecycle matrix. Therefore BD18 may rely on the documented isolation topology and transient envelope, but it may not invent exact logic-output behavior during every rail transition.

This is `ENGINEERING_REVIEW_NEEDED` and a catalog defect.

**ISOLATED SIGNAL PATH != COMPLETE BOARD HAS NO PHANTOM-POWER PATH.**

## 7. Output authority under partial power

The core's ordinary-control `GLOBAL_OUTPUT_ENABLE` requires all three core power-good signals, reset released, watchdog valid and FPGA DONE. It has a physical pull-down and no FPGA/software bypass.

For board integration, trace that authority to every energy-capable driver. Ask:

- does the downstream block itself have a deterministic inactive state if its logic command disappears?
- can a field-powered driver assert while its logic side is unpowered?
- can a command clamp or isolator output be lifted by field power?
- does loss/recovery of one domain require fresh current command authority?
- can diagnostics bypass the main enable?

A strong core enable equation is necessary evidence, not proof of every downstream physical state.

## 8. Power-load ownership and partial-power ownership are related but different

The current `REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml` freezes a useful reusable-block rule: blocks publish their own steady/startup supply demand; integration aggregates each once; field current cannot be used as a proxy for logic demand; converter capacity is not operating load.

BD18 adds the analogous lifecycle rule:

**A BLOCK THAT CROSSES POWER DOMAINS MUST PUBLISH THE CROSS-DOMAIN PARTIAL-POWER BEHAVIOR IT INTRINSICALLY OWNS. BOARD INTEGRATION OWNS COMPOSITION OF THOSE CONTRACTS.**

The board integrator must not reverse-engineer undocumented internal clamps merely to complete the matrix. Missing intrinsic data goes back to the block owner.

## 9. Fault-created states

Do not limit the audit to commanded sequences. Challenge:

- eFuse open while field supplies remain present;
- 5V converter absent while external inputs remain driven;
- one FPGA rail failed while other rails remain up;
- output field supply present with command-side logic absent;
- sensor supply present with analog/ADC supply absent;
- proportional supply present with SPI/control logic absent;
- USB host connected to an otherwise unpowered controller;
- cable connected between two independently powered cabinets;
- connector insertion with signal before return;
- power-down while bulk capacitors retain unequal charge;
- fault/status line pulled up by the opposite domain.

If a combination is claimed impossible, identify the physical topology that makes it impossible.

## 10. Required audit record

For each boundary use a record with at least:

| Field | Required content |
|---|---|
| boundary ID | stable semantic name |
| source domain | actual possible energy source |
| sink domain | domain that may be absent |
| crossing signal/component | exact path |
| powered/unpowered case | explicit combination |
| limiting path | resistor, switch, isolator, diode, clamp, etc. |
| return path | where current actually returns |
| survivability | proved / open |
| signal validity | criterion / open |
| output-authority effect | none / inhibit / possible actuation / open |
| evidence class | datasheet / calculation / structural / simulation / bench / machine |
| readiness | VERIFIED_FOR_LESSON / ENGINEERING_REVIEW_NEEDED / INCOMPLETE_NOT_STUDENT_MATERIAL |
| regression trigger | component, rail, connector, topology or firmware/gateware change that reopens it |

## 11. Bench qualification strategy

Physical partial-power testing is question-driven. Do not randomly cycle supplies and call survival proof.

For a bounded test:

1. identify the exact powered/unpowered combination and expected current path;
2. current-limit sources appropriately from engineering evidence;
3. instrument both source and supposedly unpowered rails;
4. observe phantom voltage/current, reset, enables and physical outputs;
5. challenge power application/removal order deliberately;
6. repeat brownout near relevant thresholds when justified;
7. record board revision, population, firmware/gateware identity, instruments and acceptance criteria;
8. do not promote a bench pass beyond the tested voltage, timing, temperature and topology envelope.

Machine verification remains necessary where cable, external-device or cabinet behavior is part of the claim.

## 12. Catalog stress-test result

The current catalog contains good fragments but not yet a uniform whole-board lifecycle interface.

Positive examples:

- FPGA core explicitly declares USB VBUS detect-only/no-backfeed intent.
- FPGA core exposes fail-low output authorization based on rails/reset/watchdog/configuration.
- machine_power keeps sensor/proportional field sources distinct from CORE and explicitly calls for field-to-logic backfeed prevention.
- current integration authority assigns reusable supply-demand ownership instead of making board integration reconstruct block internals.

Defects exposed:

1. lifecycle/partial-power fields are not yet uniform across block manifests;
2. cross-domain unpowered-input limits and clamp paths are often prose or absent;
3. signal-valid criteria during recovery are not consistently machine-readable;
4. whole-board back-power dependencies are not yet generated from block contracts;
5. some answers require physical PCB/bench evidence that no schematic-only artifact can supply.

The correction is not to meld blocks into a board-specific mega-circuit. The correction is to strengthen each reusable block's intrinsic lifecycle contract, then compose those contracts at board level.

## 13. Adversarial lab

Starting from a controller architecture of your choice (mill, lathe, plasma table, router, robot, press brake or custom automation):

1. inventory every independently powered domain and external source;
2. build the matrix in Section 2;
3. choose at least eight cross-domain paths and trace them electrically in both directions;
4. include one service/programming path and one externally powered machine input;
5. include one failed-rail case and one brownout/recovery case;
6. state survivability, validity and authority separately;
7. reject any answer that depends only on intended startup order;
8. return undocumented intrinsic behavior to the reusable-block defect list;
9. define the minimum bench evidence needed for every remaining physical claim;
10. state explicitly which ordinary-control behaviors receive no personnel-safety credit.

A passing result may contain open cells. It may not fill them with intuition.

## 14. Safety boundary

This audit improves deterministic ordinary-control behavior and fault containment. It does not turn LinuxCNC, the FPGA, watchdog, output enable, ordinary I/O or power sequencing into the independent personnel-safety authority. The OpenPressBrake example retains the independent Pilz/AKAS/SICK safety chain as that authority.

## 15. Compute policy

No simulation, synthesis or other executable compute is justified for this lesson. The useful result is an authority/contract audit, and the unresolved cases are primarily missing lifecycle data or physical qualification questions. An unchanged simulation cannot prove PCB parasitics, connector mating order, external-device backfeed or brownout behavior not represented by the model.

If a future bounded executable question is justified, it must run only on `[self-hosted, openpressbrake]`; hosted Actions minutes are forbidden.

## Durable freezes

- `INTENDED STARTUP ORDER != PROOF OTHER POWER COMBINATIONS CANNOT OCCUR`.
- `SEPARATE POWER BUDGETS != PROVED ELECTRICAL ISOLATION`.
- `GALVANIC ISOLATION ON ONE PATH != COMPLETE-BOARD BACKPOWER IMMUNITY`.
- `USB CONNECTED != BOARD POWERED` for a detect-only self-powered service contract.
- `DETECT-ONLY TOPOLOGY != PHYSICAL HOT-PLUG QUALIFICATION`.
- `SURVIVABILITY != SIGNAL VALIDITY != OUTPUT AUTHORITY`.
- `CORE FAIL-LOW ENABLE != PROOF EVERY DOWNSTREAM DRIVER IS FAIL-LOW IN EVERY PARTIAL-POWER STATE`.
- `REUSABLE BLOCK OWNS INTRINSIC PARTIAL-POWER BEHAVIOR; BOARD INTEGRATION OWNS COMPOSITION`.
- `UNKNOWN UNPOWERED-INPUT/CLAMP BEHAVIOR IS A CATALOG DEFECT, NOT AN INTEGRATOR ASSUMPTION`.
- `ORDINARY-CONTROL FAULT CONTAINMENT != PERSONNEL-SAFETY AUTHORITY`.

## Next lesson

BD19 should teach **power-contract closure and upstream protection sizing without double counting**: reusable load contracts -> steady/startup envelopes -> board operating modes/simultaneity -> derived-rail referral -> source capacity -> eFuse current limit/dVdT -> conductor/connector/copper/thermal checks -> fault coordination -> evidence/regression triggers. It should use current OpenPressBrake CORE-load ownership work only where the owning blocks have actually published defensible numerical contracts; unresolved values must remain open rather than being replaced with converter ratings or component maxima.
