# 4400 RIG-01 — machine transport, floor support and precommissioning safety

**Status:** NON-GRADUATED practical engineering module; **eight PUBLIC PAPER cases UNSCORED**, **eight documentary gates NOT RUN**. No physical rigging, lift calculation or foundation acceptance performed.

**Source prerequisite:** [original TRUMPF TruBend 2100 / scoped OSHA audit](../research/4400_RIG_01_TRUMPF_PRESS_BRAKE_DELIVERY_LIFT_FOUNDATION_OSHA_SCOPE_AUDIT_2026-10-26.md). Existing 4400 tooling retention and gravity-load holding lessons are related but do not authorize whole-machine lifting.

## Five machine lifecycle states with different safety authority

| State | Dominant hazard | Who/what must prove safe |
|---|---|---|
| Transport/delivery | suspended machine, off-center CG, trailer/unloading path | qualified riggers and exact OEM lift plan, exclusion zone, rated equipment |
| Temporary placement | roller/jack stability, floor slope/deflection, pinch/crush | qualified physical support plan, no personnel under unstable machine |
| Final support/utility connection | slab/foundation/anchors, uncontrolled electrical/hydraulic energy | selected OEM + site structural/electrical/hydraulic specialists, isolation |
| Precommissioning | gravity-held ram, guards missing, shipping locks being removed | independent mechanical restraint and safety-function/energy-isolation review |
| Operational handoff | emergency stop/guard/reset/physical Y1/Y2 stop not yet proven | qualified physical stop/hold and restart validation; **G0/G1 HOLD until evidence** |

**Rule:** a LinuxCNC E-stop bit, powered-off FPGA, or “normal controller is idle” does not secure a suspended machine or mechanically support a press ram.

## Product-specific trap

The original TRUMPF **TruBend 2100** quick-start guide warns of an unusual press-brake center of gravity and names **integrated top eyelets** and **armored rollers** for that model. Its **16,534-lb mass**, **8-in concrete** direct-install statement and alternative manufacturer floor-plate drawings belong to that product. **Do not copy them** to OpenPressBrake, a different TRUMPF model or a home-built frame. The quick-start explicitly says the **full Installation Manual** is required.

## Eight public PAPER scenarios — all UNSCORED

| ID | Scenario | Correct reasoning/evidence to request |
|---|---|---|
| RIG-P01 | Crew proposes lifting from a convenient top bolt hole because it looks symmetric. | Demand exact OEM approved lifting points, CG and rigging design; no guessed hole strength. |
| RIG-P02 | Forklift rated above the machine weight; crew hangs a chain directly on forks. | Load-center/capacity and manufacturer-approved attachment, qualified rigging; weight alone insufficient. |
| RIG-P03 | Someone copies 8-in concrete from TruBend 2100 guide for another press brake. | Reject transferred slab dimension; selected OEM foundation and site structural review. |
| RIG-P04 | Machine moved on rollers; crew wants to remove all restraints on sloped floor. | Stable temporary support/exclusion zone and qualified signoff first. |
| RIG-P05 | Ram looks stationary during unloading; shipping lock will be removed before hydraulics connected. | Mechanical gravity-hold and restraint/energy plan, not appearance. |
| RIG-P06 | Power is connected and HMI boots, so installers want a quick jog with side guards off. | No personnel-exposed hazardous motion; independent guards, stop/hold, commissioning plan. |
| RIG-P07 | Machine relocated with heavier tooling and auxiliary support arms. | Reassess CG, lift points, foundation, attachments, guards and safety proof; original certificate stale. |
| RIG-P08 | Contractor leaves lifting hardware unlabeled; later crew uses tooling clamp to move whole machine. | Differentiate tool vs machine lifting; permanently accessible OEM instruction/labels and proper storage. |

## Eight documentary gates — all NOT RUN

| Gate | Required evidence before progressing |
|---|---|
| RIG-G01 | Selected machine make/model/serial (private), exact full OEM installation/rigging manual and revision |
| RIG-G02 | Verified machine transport mass, CG and lifting/roller/jack contact points for actual configuration |
| RIG-G03 | Qualified rigging contractor/equipment/attachment/capacity and exclusion-zone plan |
| RIG-G04 | Site path, floor capacity/condition/slope/door clearance and temporary support plan |
| RIG-G05 | Exact selected-machine foundation/anchor/leveling design and qualified site review |
| RIG-G06 | Utility isolation and precommissioning gravity-load/shipping-restraint removal sequence |
| RIG-G07 | Independent physical Y1/Y2 stop/hold, hydraulic isolation, guards and deliberate restart commissioning plan |
| RIG-G08 | Qualified signoffs, change record, fresh safety validation and independent learner evaluation |

These are **paper gates**, not instructions to lift, anchor, jack or energize machinery. The real lift and structural checks require qualified professionals and actual selected-machine data.

## Practical human factors

Store the OEM full installation manual and lifting hardware location with the machine's maintenance documents; label **whole-machine** lifting points distinctly from tooling/guard mounting points; maintain a clear delivery route and staging area; require a simple visible hold tag until support/energy/guard checks are complete. Make correctly using restraints, supports, and guards easier than discarding them. Avoid pressure to power up an unguarded machine simply to satisfy a delivery milestone.

## Provenance and state

**DOC-CONFIRMED:** exact TRUMPF quick-start product-specific eyelets, rollers, unusual CG warning, foundation statement and requirement for full manual; OSHA 1910.178 manufacturer-approval and off-center-load principles in their applicable context. **INFERENCE:** lifecycle stage gates and anti-shortcut patterns. **UNKNOWN:** OpenPressBrake as-built machine mass/CG/floor/anchors, safety circuit, physical Y1/Y2 stop/hold, hydraulic truth and qualified rigging. **SOURCE-CONFIRMED new LinuxCNC none, TEST-CONFIRMED none, COMMUNITY-REPORTED none relied upon.** No lift, structural simulation, tests or compute.

**G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No personnel-exposed hazardous operation until qualified minimum safety is established; remote/isolated experiments require people outside danger zone and residual risk stated.
