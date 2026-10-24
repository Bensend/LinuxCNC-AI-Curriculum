# 4400 — Selected-machine physical witness intake and release gate
**Learner-facing commissioning/qualification field procedure, 2026-10-23.** Status: `INFERENCE` workflow grounded in OSHA and manufacturer evidence; not a completed installation inspection, executable test script, machine safety certification or hidden assessment key.

## Purpose: turn documentary confidence into falsifiable machine propositions
The existing [worked hydraulic traceability package](4400_HYDRAULIC_PHYSICAL_WITNESS_WORKED_PACKAGE_2026-10-22.md) illustrates the causal chain. This card is the **empty, real-machine evidence-intake gate** that must be completed *before* designing a safe physical validation. It is not a recipe for energizing an unqualified machine.

**Source boundaries:** OSHA 1910.212 machine guarding (https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212); OSHA 1910.147(d)(5) stored/reaccumulating energy and (d)(6) verification before maintenance (https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147); OSHA 2012-12-12 interpretation rejecting a mere LED disconnect indication as isolation verification (https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12); OSHA 2004-03-25 archived press-brake laser-guard interpretation stressing installed machine performance (https://www.osha.gov/laws-regs/standardinterpretations/2004-03-25-0). These establish regulatory/interpretive **scope**, not the design of a particular hydraulic circuit. See [historical interpretation reconciliation](../research/4400_OSHA_2003_2004_PRESS_BRAKE_LASER_GUARD_REVERSAL_AND_PHYSICAL_PROOF_2026-10-23.md).

## Intake packet: no physical testing before the prerequisites are known
| Intake ID | Required artifact and owner | What it must identify | State on this template |
|---|---|---|---|
| `IN-01` | As-built machine identity and modification history; owner/maintainer | Machine serial/revision, working modes, tooling, prior retrofits, safety function inventory | UNKNOWN |
| `IN-02` | Hazard and people/access map; machine designer + operator | Front/side/rear, sheet sweep, pinch/ejecta, ram, backgauge, maintenance and inside escape | UNKNOWN |
| `IN-03` | As-built electrical/safety I/O drawings; qualified controls engineer | Safety controller, firmware, inputs, outputs, E-stop/guard/foot control, final-element power and diagnostics; separate normal LinuxCNC/FPGA path | UNKNOWN |
| `IN-04` | As-built hydraulic/pneumatic circuit and parts; hydraulic designer | Each cylinder chamber, accumulator, pilot/check/bleed path, isolated volume, pressure tap, gravity load and load-restraint method | UNKNOWN |
| `IN-05` | Safeguard configuration record; qualified safety designer | Selected exact guard/laser variant, protective geometry, mode/blanking/muting, guard-lock and inside escape | UNKNOWN |
| `IN-06` | Functional requirement and acceptance basis; independent reviewer | `SF/SRS/PHY` for stop, hold, access, escape, maintenance and deliberate fresh restart; applicable edition and machine-specific numeric criteria, if needed | UNKNOWN |
| `IN-07` | Measurement plan; independent tester | Qualified sensors/instruments, mounting from outside danger zone, timestamps, calibration, coverage, uncertainties and safe test envelope | UNKNOWN |
| `IN-08` | Isolation/remote commissioning plan; owner + qualified tester | Physical exclusion, stored-energy controls, secondary restraints, abort/containment, personnel accountability and test permissions | UNKNOWN |
| `IN-09` | Human-factors review; operator + maintainer | Real loading, jam, setup and tool-change steps; guard usability, diagnostic clarity, practical reinstallation and foreseeable bypass | UNKNOWN |
| `IN-10` | Baseline revision package; document controller | Signed drawing revisions, safety software signature/CRC **plus** separate functional proof, firmware, parts and test witness links | UNKNOWN |

**Release gate 0 — documentary readiness:** all required intake artifacts identified, internally consistent and independently reviewed; contradictory drawings or unknown pressure zones are a **HOLD**, not a green default. Lack of evidence does not prove a fault, but it prevents claiming the protection has been established.

## Distinct physical propositions (do not collapse into one green bit)
| Proposed `PHY` | What a selected test must eventually establish | Independent witness needed | Wrong substitute |
|---|---|---|---|
| `PHY-STOP` | Hazardous motion ceases under defined demand/mode/exposure | Calibrated independent motion/stop measurement, time/position relative to qualified exposure boundary | HMI “Stopped”, guard trip, valve feedback |
| `PHY-HOLD` | Gravity/inertia/pressure cannot cause hazardous drift during relevant access interval | Independent load position/restraint/holding witness with defined duration and failure response | No current motion command |
| `PHY-ACCESS` | Guard retains or releases appropriately and the opening/approach is actually safe | Installed guard geometry, lock state, physical opening and reach/escape check without exposure | Solenoid command or single FO status |
| `PHY-ESCAPE` | Person can leave enclosed hazard area under foreseeable power/fault conditions | Installed mechanical release/egress verification using a safe unoccupied setup | Remote HMI unlock indicator |
| `PHY-ENERGY` | Each maintenance-exposed energy zone is isolated, residual energy rendered safe, reaccumulation controlled | Isolation point walkdown, zone-specific qualified verification and physical load restraint | One zero gauge, LED, valve “closed”, padlock without position |
| `PHY-RESTART` | Safety reset does not itself start motion; prior ordinary command cannot persist; new intentional action required | Independent safety reset and ordinary start retention observations with physical motion witness | Safety controller `Ready` bit |

The exact machine-specific tests, criteria, safe fixture and order remain **UNDEFINED** until `IN-01` through `IN-10` are resolved. A “test” must not require a person to enter the hazardous envelope to watch it. A qualified team must determine safe isolated/remote methods; no generic sequence here authorizes an energized experiment.

## Eight-field final-element evidence — complete once per element
For each selected valve, drive/STO, contactor, guard lock, isolator, accumulator block or mechanical restraint, use the canonical [final-element implementation specification](../hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md) and record separately:
1. Commanded safety action.
2. Physical final element and exact model/variant.
3. Feedback target actually observed.
4. Narrow legitimate proposition from that feedback.
5. Shared dependencies/common-cause paths.
6. Residual hazardous energy.
7. Machine-level independent physical witness.
8. Maintenance isolation/blocking.

A single feedback contact cannot be copied as evidence for multiple physical propositions. The design must identify which component *physically removes or contains* each hazardous energy source, rather than attributing that authority to LinuxCNC or the normal FPGA.

## Adversarial commissioning review — written outcomes before any live trial
| Contradiction or change | Required engineering disposition |
|---|---|
| Valve position feedback “safe” while independent ram displacement continues | `PHY-STOP/HOLD` FAIL or UNRESOLVED; hold release, investigate hydraulic/gravity path. Do not accept the feedback as a physical witness. |
| Zero gauge at manifold while an isolated cylinder chamber or gas accumulator exists | `PHY-ENERGY` UNKNOWN; obtain pressure-zone map and independent verification; no servicing exposure. |
| Guard unlock output changes but door binds or inside release is obstructed | `PHY-ACCESS/ESCAPE` NOT ESTABLISHED; fix mechanical/access issue, not merely logic. |
| Guard node replacement shows healthy ordinary network state | Mark affected `DEP/CHG/VAL/PT` STALE until selected safety function and physical response are revalidated. |
| Reset is accepted while a foot command remains pressed or LinuxCNC still requests motion | Require independent inhibit and fresh intentional start; a reset must not initiate hazardous movement. |
| Guard makes ordinary production awkward, operators routinely defeat it | `HF` design failure; improve fixture/hinge/visibility/reset/repair workflow without removing the required protective function. |
| Firmware/CRC matches, but as-built wiring differs | Configuration identity alone does not close physical validation; hold and reconcile wiring and functions. |
| Pressure appears to reaccumulate after isolation | `PHY-ENERGY` remains unresolved; identify energy source and continue qualified verification until controlled. |

## Acceptance disposition and traceability
Copy this table into the **actual** cumulative Safety Design Package with unique persistent IDs, machine-specific links and witness records; do not reuse the illustrative labels above as proof.

| Gate | Minimum release evidence | This template's status |
|---|---|---|
| `G0` documentary/design readiness | `IN-01..10`, applicable SRS, selected hardware and independent reviewer | HOLD — UNKNOWN |
| `G1` remote/isolated verification permission | Approved no-person-exposure method, energy controls, secondary restraints and residual-risk review | HOLD — NOT DESIGNED |
| `G2` physical `VAL/PT` evidence | Independent witness for each `PHY` plus negative/fault cases and signed results | HOLD — NOT RUN |
| `G3` personnel-exposed operating release | Minimum protective functions and usability established for selected tasks/modes, unresolved residual risks controlled | **NOT AUTHORIZED** |
| `G4` maintenance entry | Separate machine-specific LOTO, residual-energy and gravity restraint verification | **NOT AUTHORIZED** |
| `G5` change/restart | `CHG` impact review, stale evidence revalidated, deliberate reset + fresh ordinary start | HOLD |

**Evidence labels:** `DOC-CONFIRMED` for cited published OSHA material; `INFERENCE` for this generic intake/gating design; selected-machine details `UNKNOWN`; physical `TEST-CONFIRMED` **none**. Do not infer a PL/SIL, stopping time/distance, pressure threshold, DCavg or hydraulic truth table. No simulation is justified while selected-machine intake is missing. No personnel-exposed hazardous operation; if an experiment is necessary, use isolated/remote methods with people outside the danger zone and explicitly documented residual risk.


## 2026-10-24 exact hydraulic product-variant intake addendum (Bosch / HAWE)

The [Bosch IH04 versus IH04E audit](../research/4400_BOSCH_IH04_VALVE_FEEDBACK_LEAKAGE_REPLACEMENT_SCOPE_AUDIT_2026-10-24.md) and [HAWE ePRAX B 6340 / D 6340 audit](../research/4400_HAWE_EPRAX_2026_GRAVITY_VALVE_ACCUMULATOR_SAFETY_SOURCE_TRACE_2026-10-24.md) add **three required subfields** to `IN-03/IN-04/IN-10`, to be filled for **each actual Y1 and Y2 side**:

| Subfield | Required as-built evidence | Why absence blocks release |
|---|---|---|
| `IN-04a` hydraulic family / option identity | Complete manufacturer, product family, model, **every suffix/option**, serial and drawing/edition for each valve block, anti-cavitation device and optional accumulator; photo plus signed BOM/drawing reconciliation | Similar-looking modules and even the same manufacturer's `S` code can have different monitor coverage; ePRAX `X` vs `A/B` changes stored energy. |
| `IN-03a` safety feedback / final-element coverage | Actual physical target of **each** valve/linear-scale feedback, safety-related input, safety controller logic ownership and output to final element, with unmonitored paths explicitly identified | Normal analog valve telemetry and an expected switch state cannot prove absence of hydraulic leakage, actual beam holding or independent stop authority. |
| `IN-10a` revision/change invalidation | Manufacturer manual/datasheet editions and selected assembly drawing identity, last valve/orifice/gauge/drive/sensor replacement and affected reaction-time/stop/hold revalidation evidence | OEM B 6340 04-2026 and D 6340 07-2026 differ in edition; Bosch calls for reaction-time rechecks after safety-valve replacement. Same footprint/letter is not same physical safety proposition. |

This is a **documentation gate**, not a test recipe. `IN-04a/IN-03a/IN-10a UNKNOWN` until actual machine evidence is obtained. Do not perform valve-open, hose-disconnect, or unrestrained-ram experiments to fill the gaps.


## 2026-10-24 additional `IN-04b` — hydraulic hose injection / service-zone physical exposure

The [Parker/HSE original-source injection audit](../research/4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md) establishes a **hazard distinct from ram movement**. For every Y1/Y2 hose, coupler and test fitting, require: installed manufacturer/assembly identity, route/guard, possible high-pressure spray exposure, each check-isolated segment, trapped thermal/accumulator pressure, exact zone-specific isolation/bleed/test point, accessible safe service position, qualified instrument/procedure and compatible replacement history. `IN-04b UNKNOWN`. A pump-off state, one zero gauge, mechanical ram support, or a valve-position switch does **not** establish safe hose pressure. Do not search by touch, loosen a fitting to test, or energize an unqualified leak check. Mark affected `ENE/HAZ/HF/PHY/VAL/PT` unresolved until independent qualified evidence. HSE emergency guidance requires urgent medical assessment for suspected injection injury. This intake extension does not authorize physical operation.


## 2026-10-24 optional `IN-04c` — auxiliary pneumatic/vacuum zone and exhaust-scope intake

The [Festo/ROSS manufacturer source audit](../research/4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) identifies a distinct potential hazard for **machines with actual pneumatic or vacuum auxiliaries**. First record **whether such equipment exists** on the selected OpenPressBrake machine; current answer **UNKNOWN**. If present, for every air/vacuum zone require exact installed safety valve model and connector/reset suffix (Festo NECA MP1/MP3/MP5; ROSS DM1/DM2 if applicable), OEM edition and application approval, as-built supply/isolator/bleed/check/accumulator/vacuum/branch/exhaust/silencer routing, actuator chamber and gravity/spring/part-load response, independent safety control, physical pressure/holding witnesses and fresh local restart evidence. A valve READY/exhausted indication or a high component PL does **not** prove safe service entry. The Festo MS6-SV-E/D manufacturer's explicit press-safety-valve exclusion must not be ignored. `IN-04c UNKNOWN`; no evidence of any selected Festo/ROSS product; `PHY/VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED. No physical test, hose opening or pressure threshold is prescribed.


## 2026-10-24 optional `IN-04d` — hose-burst velocity fuse and low-flow fault coverage

The [HYDAC/HIDROS/Winner original manufacturer source audit](../research/4400_HOSE_BURST_VELOCITY_FUSE_FLOW_WINDOW_AND_UNSAFE_TEST_TRANSFER_AUDIT_2026-10-24.md) establishes an additional **conditional** question: is a flow-triggered hose-break fuse **actually installed** on either Y1/Y2 axis or auxiliary? Current state **UNKNOWN**. If present, require exact model/variant and OEM edition; port flow direction; physical cylinder-to-fuse protected/unprotected hose lengths; two-chamber/relief/check/accumulator topology; actual trip threshold and tolerance; credible maximum normal transient flow versus **minimum** rupture/partial-leak fault flow over load/viscosity/temperature; possible leakage after closure; and separate physical `PHY-STOP/HOLD/ENERGY/HOSE-INJECTION` witnesses. Manufacturer percentages are **not** machine acceptance values. Do not run the OEM-described open-line rupture demonstration without a separately qualified isolated/remote containment and personnel-exclusion plan; this course **does not authorize it**. `IN-04d UNKNOWN`, `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED.


### `IN-04d` blocking OEM contradiction: HYDAC part 710028 port direction

Two **original HYDAC sources for the same part 710028** disagree on excess-flow closure direction: [US official online product listing](https://catalog.hydac.com/item/cartridge-valves/valves--hose-break-check/710028) says **2→1**; [HYDAC International EN 5.174.14/10.21 original PDF](https://www.hydac.com.au/media/productattach/e/n/en5174_rbe_1.pdf?20250824=) pp. 1–2 says **1→2** and lists 710028. [Conflict audit](../research/4400_HYDAC_RBE_710028_OPPOSITE_PORT_DIRECTION_OEM_CONFLICT_2026-10-24.md). Do **not** freeze a protected-flow direction from either generic document alone. If that part is actually selected, require official manufacturer reconciliation tied to part/batch plus independent as-built port/consumer mapping before physical `VAL/PT` design. Actual OpenPressBrake fuse existence UNKNOWN. This is a documentary conflict, **not** a demonstrated installation defect.


## 2026-10-24 conditional `IN-04e` — workpiece whip-up, sheet follower and separate motion authority

The [Oregon OSHA/AMADA/Fab Supply/ENUTRON/SHENCHONG original-source audit](../research/4400_PRESS_BRAKE_SHEET_WHIP_UP_AND_INDEPENDENT_FOLLOWER_SAFETY_BOUNDARY_2026-10-24.md) identifies an additional **workpiece trajectory and auxiliary powered actuator** hazard. First establish whether the selected OpenPressBrake has any powered sheet follower/lifter; currently **UNKNOWN**. If absent, record `IN-04e N/A` but **still** evaluate sheet whip-up, part-to-slide pinch and face-strike exposure for actual bends. If present, require exact installed model/revision, support count, sheet geometry and center of gravity, powered axes, separate/press-coupled normal controls, encoder/magnetic scale and calibration, safety-input/output/physical final-element wiring for **both** press and follower, stop/hold under power loss, local/remote Start Follow, reconnection and fresh local restart, tool/part change invalidation and independent physical witnesses. The SHENCHONG 2022 vendor setup describes a separate follower scale/PLC/E-stop but **does not prove** reciprocal press/follower protective-stop integration. Do not perform its energized learning procedure as a curriculum test. `IN-04e UNKNOWN`, `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED; no machine-specific speeds, loads, distances or PL/SIL inferred.


## 2026-10-24 conditional `IN-04f` — upper punch retention, holder clamping and die fragment risk

The [WILA Safety-Click / Mate Maglock / AMADA die-fragment original-source audit](../research/4400_PRESS_BRAKE_TOOL_RETENTION_MAGLOCK_SAFETY_CLICK_AND_CLAMP_AUTHORITY_2026-10-24.md) requires exact selected **upper/lower tooling and holder** identification before safety claims. Record each tool segment mass and geometry, holder/adaptor/tang compatibility, anti-drop/magnetic temporary retention, separate bending-force clamp/actuation, actual physical clamping witness, condition/damage inspection, clamp power-loss behavior, fragment/ejection containment, guarded change access, independent ram support and maintenance isolation. The WILA **12.5 kg** Safety-Click suitability is only for that OEM product; Mate explicitly says Maglock is **not** a substitute for holder clamping. Do not treat these as generic safe-load or PL/SIL numbers. Actual selected OpenPressBrake tooling and compatibility **UNKNOWN**; `IN-04f UNKNOWN`, `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED. No live tool drop, unclamp or destructive die test prescribed.
