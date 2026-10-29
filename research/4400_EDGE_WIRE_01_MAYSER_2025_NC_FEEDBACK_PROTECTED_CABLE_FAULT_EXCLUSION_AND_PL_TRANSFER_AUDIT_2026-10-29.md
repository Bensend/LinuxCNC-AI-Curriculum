# 4400-EDGE-WIRE-01 — Mayser NC-chain feedback, protected-cable fault exclusion and false PL transfer

**2026-10-29 | Direct original OEM page-image source-depth | NON-GRADUATED | NO MACHINE TEST**

## Distinct unresolved safety question

Can a builder interpret the manufacturer statement “2-wire sensor and connection cables are constantly monitored” as proof that *any* field cable short, splice or retrofit cable routing preserves the published performance level? **No.** The exact original Mayser manual expressly conditions one short-circuit fault exclusion on **permanent, externally protected wiring**. The distinction is between **diagnostic function**, **fault exclusion justified by physical construction**, **whole-machine safety performance**, and **independent final-element stopping**.

This is an exact-original-source depth addition to [EDGE-CALC-02](4400_EDGE_CALC_02_MAYSER_2025_ORIGINAL_PAGE_ARITHMETIC_ACTIVE_LENGTH_INSTALLATION_LIMITS_AUDIT_2026-10-29.md) and the [general tactile-edge predecessor](4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md), not a new competency. A full safety-index/research synonym scan found tactile sensor principle, ASO resistor and Schmersal optical-evaluator distinctions, but no directly documented **Mayser v2.13 protected-wiring fault-exclusion chain**.

## Original manufacturer evidence

**Mayser GmbH & Co. KG**, *Normally closed safety edges SL NC II — Product information*, footer **080925 v2.13-RiA**, https://www.mayser.com/media/1769/download/PI-SL%20NC%20II_EN.pdf?v=3 , accessed 2026-10-29. The 28-page manufacturer PDF was opened; printed **p.4/28** and **p.7/28** visually inspected; printed **p.11/28** text directly read in the PDF viewer. Complete byte hash unavailable due container network download restriction.

- **Printed p.4/28 (DOC-CONFIRMED):** positive-break NC contact chain supplies an output to downstream control; Mayser says monitoring of sensor/cables relies on signal-transmission feedback, **without** a monitoring resistor. This is **not** evidence that a bare ordinary CNC input is safety-rated.
- **Printed p.7/28 (DOC-CONFIRMED):** PL calculation invokes ISO 13849-2 Table D.4 **fault exclusion for a short circuit between two conductors permanently installed and protected against external damage**. Under that exclusion, cable diagnostic coverage is **not** counted in determining PL. The manufacturer states a protective-device PL **up to d** under the relevant assumptions; the selected complete machine's PL is not given.
- **Printed p.11/28 (DOC-CONFIRMED):** wiring between sensor and downstream control must be **permanently installed and protected**, e.g. conduits/armoured conduits; where that is not possible, route each cable in a **separate sheath**. The manual explicitly warns that poor routing can cause line termination/loss of protection and downgrading of safety classification.
- **Printed p.10/28 (DOC-CONFIRMED PDF text):** for several sensors in sequence, Mayser recommends **S2/SR2/ST2** versions with an additional return line for feedback. **p.6** caps series connection at ten sensors.
- **Printed p.7/28 (DOC-CONFIRMED):** without a reset function (automatic reset), the reset function must be provided elsewhere. That does not prove safe restart or occupancy clearance.

The manual's two statements about monitoring and fault exclusion are **not necessarily contradictory**. Monitoring can address some fault classes while an architecture's calculated PL still relies on a justified physical exclusion for a different fault class. **UNKNOWN** exactly which shorts, bypasses and splices are diagnosed in a selected circuit without its complete wiring, controller/evaluator and OEM validation.

## Failure-path review — do not assume a wire break is the only failure

| Condition | Why it matters | Correct discriminator |
|---|---|---|
| Open-circuit cable or actuated NC chain | May interrupt protective channel | Exact monitored circuit, fault response, independent safety output and final element |
| Conductors bridged downstream of the NC chain | Could bypass sensor contact opening in a particular topology (**INFERENCE**, not an OEM-tested result) | Verify actual topology and fault-exclusion basis; do not assume every short is detected |
| Unprotected cable across sharp sheet-metal edge or movable hinge | Physical fault-exclusion premise may fail | Inspect as-built route, mechanical protection and maintenance wear evidence; mark PL assumptions **STALE** |
| Replacement S1 cable/sensor with different return topology | Feedback/diagnostic path may differ | Exact suffix, OEM wiring and validated controller; treat as `CHG` |
| Several sensors in series, one edge never reaches a corner | Series continuity does not establish geometric coverage | Separate active-length/angle and each hazard-zone witness |
| “Mayser says direct-to-control, so connect it to LinuxCNC GPIO” | Ordinary CNC input has no established personnel-safety authority | Independently selected/validated safety-related controller and physical stop/hold path |
| Edge clears and normal CNC retains start command | A closed NC chain can coincide with retained motion demand | Independent reset/restart inhibit, occupancy clearance and fresh start |

## Engineering handoff

Before accepting an edge circuit, retain **part/material/edition and S1/S2 return variant**, as-built protected cable route, splice/connector details, selected safety input diagnostics, explicit **fault exclusions and their physical evidence**, target PLr and achieved PL assessment, output/final-element chain, installed sensing coverage, physical stopping/force and reset/restart evidence. Route changes, a new splice, cable abrasion, panel relocation, or new controller input invalidate the relevant `DEP/SRS/ARC/VAL/PT` evidence and require `CHG` review. Make conduit, protected cable clamps and easily replaceable standard harnesses the default, not an awkward custom guard that encourages bypass.

**Evidence:** manufacturer **DOC-CONFIRMED** pp.4/7/10/11, page images p.4/7; hypothetical bypass scenarios **INFERENCE**; selected circuit fault coverage **UNKNOWN**; LinuxCNC ordinary input cannot be assigned independent personnel-safety authority. **TEST-CONFIRMED none.** No energized short, wire-break injection, machine actuation or human exposure authorized. GitHub-hosted/self-hosted compute **0/0 min**; independent 2520–25F0 evaluator OPEN; **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**.
