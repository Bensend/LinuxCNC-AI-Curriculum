# 4400 FORM-HAZ-04 — Original NIOSH FACE fatal workpiece ejection: the sheet itself becomes the projectile
**2026-10-28 | Direct primary incident addendum to existing FORM-HAZ-04 | NON-GRADUATED**

## Predecessor and information gain

Existing [FORM-HAZ-04](4400_FORM_HAZ_04_TRUMPF_OSHA_TOOL_FRACTURE_WORKPIECE_SWEEP_AND_SPRING_ELEMENT_SOURCE_AUDIT_2026-10-26.md) already teaches **workpiece sweep, fracture and special-tool stored energy** from manufacturer/OSHA general material. [TOOL-LOAD-03](4400_TOOL_LOAD_03_WILA_LOCAL_TOOL_LOAD_DISTRIBUTION_AND_VERTICAL_HANDLING_SOURCE_AUDIT_2026-10-26.md) covers local tool load, and [STRUCT-01](4400_STRUCT_01_CINCINNATI_PRESS_BRAKE_ECCENTRIC_OFFCENTER_STRIPPING_LOAD_SOURCE_AUDIT_2026-10-28.md) separately covers machine structural moment/off-center/reverse-load limits. This **is not a new generic sheet-whip module**. It adds a **directly inspected fatality investigation** with a specific failure sequence: **heavy workpiece slips off the rear V-die edge under near-edge bending load and is ejected into the operator/forklift area**. It proves a real ejection exposure, **not** a bolt-fracture, eccentric-capacity violation or OpenPressBrake incident.

## Direct original official investigation

**Oklahoma Fatality Assessment and Control Evaluation (OKFACE) / NIOSH FACE, Report 05-OK-005-01, _A press brake operator died when he was struck by a steel lug_**, incident **2005-01-24**, published **2005-12-07**. [Original five-page report, CDC Stacks](https://stacks.cdc.gov/view/cdc/166325/cdc_166325_DS1.pdf), [official archive/metadata](https://stacks.cdc.gov/view/cdc/166325), DOI `10.26616/NIOSHSFACE05OK005`. **Original PDF directly inspected**, pp. 1–5; not merely a press excerpt.

**DOC-CONFIRMED original report (pp. 1–3):**
- A **920-pound** steel lug (reported dimensions 81 in × 28 in × 1¾ in) was being radius-bent using several short bends on a **1,250-ton, 22-ft** press brake. A forklift supported the heavy workpiece, with a second worker in its seat.
- The operator applied load approximately **2–3 inches from the lug edge**. The lug **slipped off the rear edge of the V-shaped lower die** and was **ejected**; it struck the operator, causing fatal head/chest injuries and pinning an arm between lug and forklift. The report does **not** attribute the event to a ram drive fault, broken die, missing E-stop or structural bolt failure.
- The machine had an emergency shutoff and warning signs but **no point-of-operation guards**. The facility had written general safety materials but lacked machine-specific procedures for the press brakes, and the report identified a task-training gap.
- The investigators recommended physical guarding or demonstrably effective separation, hazard recognition and task/machine-specific procedures. The report's historical references include OSHA CPL 02-01-025 (1997), whose current status must be assessed separately; **do not import a 1997 safe-distance shortcut as current press-brake compliance**.

## Exact hazard chain and witness

`heavy part + edge-near die engagement + external forklift support + applied bend force -> loss of lower V-die engagement -> workpiece ejection into operator/support zone -> fatal impact`.

| False assurance | Missing physical witness | Consequence |
|---|---|---|
| Y1/Y2 track and force are below machine nameplate | Actual **part-to-die contact and support geometry** through every bend increment, especially near edges | Workpiece can leave the die even with normal ram motion |
| Forklift supports the mass | Stability and controlled reaction of workpiece/support, independent operator/helper exclusion from possible ejection trajectory | Support can become an impact/pinch boundary |
| Emergency stop exists | Guarding/exclusion of **material trajectory**, not just hands in ram gap; stopping after release may be too late | E-stop alone cannot capture a projectile already moving |
| Written general safety policy and PPE exist | Task-specific setup, qualified tool/part suitability, personnel zones and practical support fixtures | Operators may face a non-obvious projectile hazard |
| OEM structure/tool load limits are satisfied | Distinct **retention of workpiece contact on V die**; load-center, die geometry and side support are not reducible to nominal tonnage | Correct capacity is not proof of safe part handling |

**Human-factors implication:** Provide practical purpose-built supports/fixtures and a clear way to keep people outside the potential ejection/sweep zone; do not make forklift positioning or hand-holding the only convenient way to run heavy parts. A guard that must be removed for every common part is a design defect to solve. Avoid a false numerical safe distance without the actual projectile/sweep analysis.

## Evidence status and restrictions

- **DOC-CONFIRMED:** original NIOSH/OKFACE report directly inspected; event mechanism, operator/support geometry and published recommendations are attributed to the investigators.
- **INFERENCE:** generalizable distinction between physical workpiece retention and normal CNC force/position; how to improve ergonomic support/guarding on a future machine.
- **UNKNOWN:** selected OpenPressBrake workpiece geometry, tool contact, guards, support, ram stop/hold and whether any similar operation occurs. No claim that a Cincinnati machine or an OpenPressBrake machine was involved in the FACE incident.
- **TEST-CONFIRMED:** none; no reenactment, simulation, force calculation, physical test, lab compute or blind score. Do not use the incident as a numeric ejecta-distance or stop-time rating.

Use **existing Stage A B/E/F/G** hazard/guard/proof logistics and FORM-HAZ-04's current unscored field module; do **not** create another owner packet or paper exam. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed hazardous operation.**
