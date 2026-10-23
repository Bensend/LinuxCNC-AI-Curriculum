# 4400 — Counterbalance pilot, thermal relief and motor-brake safety boundary
Date: 2026-10-23 UTC | Original 4400 safety source investigation | Status: DOC-CONFIRMED component mechanisms; INFERENCE failure paths; selected-machine PHY/VAL UNKNOWN; no bench/physical test.

## Question and falsifiable premise

Does a load-holding valve prove that an axis cannot move when electrical control power is removed? **No.** Its behavior depends on the selected valve family, pilot pressure, pressure at the load and downstream ports, thermal relief, manual override, internal leakage of the actuator, and the actual mechanical load path. This investigation deliberately tests the tempting shortcuts “pump OFF = pilot absent,” “pilot absent = every path blocked,” and “counterbalance valve = motor brake.” It extends, rather than replaces, [the Parker HAS manual-override/order-code audit](4400_PARKER_HAS_LOAD_HOLD_OVERRIDE_CODE_AND_MANIFOLD_ORIENTATION_2026-10-23.md) and [the brake-fault torque-retention investigation](4400_BRAKE_FAULT_TORQUE_RETENTION_AND_HYDRAULIC_LOAD_CONTROL_SCOPE_2026-10-23.md).

### Primary manufacturer evidence

| ID | Classification | Exact source and observation | Non-transferable boundary |
|---|---|---|---|
| CP-01 | **DOC-CONFIRMED** | Sun Hydraulics, *Counterbalance & Pilot-to-Open Check Cartridges*, Technical Tip Pub. 999-901-287, June 2023, p. 2: three-port PO checks are non-modulating on/off load-holding devices; three-port counterbalance cartridges modulate overrunning load, with opening dependent on load and pilot pressure. [Sun original PDF](https://www.sunhydraulics.com/sites/default/files/media_library/tech_resources/TT_US_Ctrbal_POCk_Jun2023_Final_0.pdf). | General Sun cartridge-family description; not an installed circuit or proof of selected safety function. |
| CP-02 | **DOC-CONFIRMED** | Same Sun technical tip: three-port counterbalance cartridges incorporate relief from load port 1 to inlet port 2 against load/thermal overpressure; standard PO-check variants can intentionally leak from port 2 to pilot port 3 to purge air; sealed-pilot variants exist. | Leakage statement concerns described **PO-check** variants, not a universal counterbalance leakage path. A product-specific cavity/order code is required. |
| CP-03 | **DOC-CONFIRMED** | Parker Hannifin, *Load and Motor Control Valves*, Catalog HY15-3502/US, Technical Tips printed LM2–LM4: a counterbalance's external pilot assists opening, its thermal relief may vent trapped oil when heated, and the illustrative pilot threshold is load-dependent. [Parker official catalog](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Cartridge-Systems-Division---Europe/HCSE-Websphere-literature/HCSE_LoadControlValves/Parker_HCSE_LoadControlValve_datasheets_HY15-3502-US-EU_English.pdf). | Catalog **illustrative** pressures and pilot ratios are not press-brake acceptance values; selected product and circuit may differ. |
| CP-04 | **DOC-CONFIRMED** | Same Parker catalog, printed LM5: for hydraulic **motor** applications, internal motor leakage means the counterbalance alone cannot hold the load; a mechanical brake is used. The catalog also discusses brake release sequencing and special equal-area valves. | Do not transfer this motor conclusion mechanically to every cylinder, or presume a generic brake is safety-rated. |
| CP-05 | **DOC-CONFIRMED** | Parker HAS Installation Manual HY08-4005-M11, printed pp. 32, 35–37: selected counterbalance valve traps pressure in the cylinder, uses pilot-assisted load control, and must not be removed before all internal pressure is relieved; PO-check code N can be supplied overridden, and push/pull port mapping depends on manifold orientation. [Parker official HAS manual](https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf). | HAS-specific, not a hydraulic truth table for OpenPressBrake. |
| CP-06 | **DOC-CONFIRMED** | Sun, *Three-Port Counterbalance Valves* technical catalog, states pilot or load pressure exceeding relief setting can open the selected family, and port-2 backpressure affects non-vented variants. [Sun technical sheet](https://www.sunhydraulics.com/sites/default/files/media_library/tech_resources/uk_3pcbstcart_4m5m.pdf). | Exact cartridge/vent configuration required; “pump off” alone is not a pilot-pressure measurement. |

**Source retrieval note:** Sun June 2023 PDF was indexed in the research search results but direct PDF retrieval returned HTTP 403 in this session. Treat CP-01/02 as **DOC-CONFIRMED via indexed manufacturer text**, with page-level independent reread pending if exact quotations are needed. Parker PDF was opened and relevant text inspected directly. No TEST-CONFIRMED statements.

## Failure-path graph: power loss does not collapse hydraulic energy

Illustrative nodes only, **not** an as-built hydraulic schematic:

- `CMD`: LinuxCNC/FPGA commanded zero motion; `PUMP`: pump electrically off.
- `P3`: actual pressure at valve pilot port; `P1`: load-side pressure; `P2`: downstream pressure; `T`: trapped-fluid temperature.
- `V`: selected valve's internal state and relief/override configuration; `H`: load position/physical holding; `Z`: every volume exposed by the planned service task.
- `MECH`: qualified independent restraint or brake, if selected and demonstrated.

Invalid implication **`CMD=0 && PUMP=off => P3=0`**: a trapped or cross-connected pilot volume could remain energized; the selected diagram and measurements must decide. This is a **candidate failure mechanism**, not a claim about any particular machine.

Invalid implication **`P3=0 => P1 isolated indefinitely`**: load-induced pressure may reach the selected valve's relief setting, temperature can drive thermal relief, or an override/contamination/other route may defeat holding. Conversely, normal designed thermal relief does **not** by itself prove dangerous drift; the actual load, circuit and allowed displacement matter.

Invalid implication **`counterbalance present => hydraulic motor load stationary`**: Parker explicitly identifies motor internal leakage and the need for a separate mechanical brake in the illustrated motor applications. A motor/gearbox/shaft coupling or brake-feedback sensor is not by itself a direct load witness. The selected mechanical transmission and brake engagement must be verified.

Invalid implication **`upstream gauge zero => Z safe`**: the load-side cylinder volume can remain pressurized behind a correctly closed valve. An accurate upstream gauge can be unrelated to the volume opened during maintenance.

## Qualitative adversarial cases and disposition

| Scenario | Safety question | Potential contradictory evidence | Disposition |
|---|---|---|---|
| A. Power off, pilot trapped | Which path exhausts/islands P3 and is it independent of normal control? | HMI says “hydraulics off” while mapped pilot port still has pressure | **HOLD** until as-built topology and independent pressure-zone witness. |
| B. Counterbalance holds a warm cylinder | What relief route is present and where does displaced fluid go? | Temperature/pressure increases despite no motion command | **HOLD** for service access; do not blindly defeat relief or increase setting. |
| C. Downstream hose rupture | Is the selected valve between the cylinder and rupture, and is that the hazard-controlling load direction? | Valve fitted remotely, with unprotected hose between cylinder and valve | **HOLD**; do not claim hose-burst protection without mounting/path evidence. |
| D. Hydraulic motor hoist | Does mechanical brake physically engage and hold independent of motor leakage? | Counterbalance state healthy but load drifts | **HOLD**; direct load witness prevails. |
| E. Service pressure release | Are P1, P2, P3 and other connected volumes independently mapped and verified? | Pump-side gauge zero but cylinder chamber pressurized | **HOLD** and perform authorized isolation design review; no live loosening. |
| F. Restored power | Are pilot, valve, brake and restart states fresh after power recovery? | Normal controller retained a start bit or diagnostic became stale | **HOLD** until independent rearm and deliberate fresh start. |

These are **paper counterexamples**; no pressure, stopping distance, drift rate, leakage allowance, integrity target or safe pilot threshold is invented. Do not deliberately rupture a hose or inject hazardous faults on an accessible machine.

## Selected-machine proof contract and ownership

1. **IN-04 / ENE / DEP:** collect exact cylinder/motor/brake model, load direction, manifold code, valve order code, pilot ratio/setting, orientation, all P1/P2/P3 routes, bypass/override state, accumulator, drain/thermal relief and pressure tap locations. Owner: hydraulic designer; independently review as-built versus drawings.
2. **SRS / ARC:** separately allocate production stop, gravity holding, protection against unexpected descent, maintenance isolation and safe recovery. Select appropriate independently qualified safety control/final elements; no authority transfer to LinuxCNC or normal FPGA.
3. **PHY-HOLD / PHY-ENERGY:** define independent load-position/restraint evidence and task-specific pressure-zone verification, including instrument calibration, sensor location, reaccumulation and loss-of-signal behavior. Do not treat valve feedback as the load witness.
4. **VAL / PT:** write bounded, approved physical acceptance procedures only **after** design/measurement evidence and personnel exclusion are established; do not infer a universal proof test from this document.
5. **CHG / human factors:** mark service overrides conspicuously, make return to normal guarded configuration simple and auditable, and require requalification after a valve/brake/port/orientation/pilot change. A guard or override that routinely obstructs service is a redesign target, not a justification for permanent bypass.

### Machine transfer

- **Press brake:** ram gravity, cylinder chamber isolation, redundant hydraulic safe state and front/side/rear exposure remain machine-specific UNKNOWN. The counterbalance mechanism is background knowledge only.
- **Mill/lathe:** spindle coasting after STO and vertically loaded axes require different stopping/holding witnesses; do not call a motor-brake architecture equivalent to a hydraulic cylinder circuit.
- **Robot/hoist/cell:** motor leakage, load holding and access/escape can be coupled; external safety controller and physical restraint must be justified together.

## Explicit outcome

**Documentary mechanism resolved; selected-machine release remains blocked.** `IN-01..10` are not filled by this paper; `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` remain UNKNOWN; `VAL/PT` NOT RUN. The minimum safe-to-operate threshold is not demonstrated. No operation with people exposed to the danger zone is authorized; any future experiment must be isolated/remote under a qualified exclusion and residual-risk plan. **No lab justified:** source documents resolve the mechanism distinction; physical testing without an as-built machine and safety plan would not answer a well-posed question.

## Next source/qualification questions

- Recover the exact selected valve datasheet and as-built pilot/drain topology; inspect whether thermal relief, sealed pilot, vented backpressure and manual override apply to **that** order code.
- Identify whether the hazardous load is carried by a hydraulic cylinder or motor and where independent mechanical holding acts.
- Reconcile hose and valve mounting relative to the actual cylinder chamber; establish maintenance pressure zones and the correct test ports.
- Preserve a technician field exercise without hidden answers and submit external competency evidence to the independent evaluator when available.

## Follow-on adversarial source correction — motor brake-release ordering and equal-area exception

The directly inspected Parker HY15-3502/US **printed LM5** motor-brake example adds a safety-relevant sequencing counterexample that is not captured by the generic phrase “counterbalance valve has thermal relief”:

- **DOC-CONFIRMED, example only:** With the catalog's illustrative 10:1 pilot-ratio valve and 3,000 psi thermal setting, the formula `Ppilot=(Pthermal-Pload)/pilot_ratio` gives 300 psi pilot with no load and 100 psi with a 2,000 psi load. The example mechanical brake releases at 300 psi. The counterbalance can therefore begin to open **before** the mechanical brake releases when the load is present, causing motor motion against an applied brake and wear. **These are Parker's teaching example numbers, not selected-machine pressure settings or safety acceptance criteria.**
- **DOC-CONFIRMED, variant exception:** Parker describes a **1:1 equal-area** motor-brake application that is selected to delay counterbalance opening until the mechanical brake is released. Crucially, Parker states that its illustrated equal-area valve **has no built-in thermal relief**, and cautions about heavy-load stopping pressure spikes. Therefore `all counterbalance valves have thermal relief` is **REJECTED**; the exact valve architecture must be identified.
- **INFERENCE:** A brake-release pressure switch alone cannot prove that the brake physically released, or that the motor/shaft/load remained stationary during the transition. A physically valid safety claim needs selected brake feedback coverage, actual load-path witness and a documented failure response; normal pressure sequencing may help control but does not replace the independent safety function.
- **UNKNOWN:** Whether any OpenPressBrake axis, lathe, robot or hoist uses this valve/brake arrangement, whether pilot/holding pressure can remain trapped, and whether its brake-release order is safe. No hydraulic truth table, valve adjustment or commissioning setting is authorized.

**Source:** [Parker official HY15-3502/US, Technical Tips LM5](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Cartridge-Systems-Division---Europe/HCSE-Websphere-literature/HCSE_LoadControlValves/Parker_HCSE_LoadControlValve_datasheets_HY15-3502-US-EU_English.pdf). The larger current catalog HY15-3503R1/US (indexed 2026) appears to retain this teaching example, but the PDF exceeded the reader's size limit; do not classify that later edition as directly inspected. **No test or lab run justified**: the manufacturer text already resolves the existence and mechanism of this sequencing hazard.
