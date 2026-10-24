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
