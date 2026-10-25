# 4400-CELL-01 — Whole-body access, mode-dependent safeguards, reset and fresh-start authority
**4000 Safety Course | 2026-10-25 | SOURCE-READING / NOT GRADUATED | no physical or lab test**

## Prerequisites and objective
Requires 2520 hazard/SRS, 2530 E-stop, 2540 final elements, 2580 isolation, 2590 guarding, 4400-SET-01 setup mode, 4400-RST-01 reset/EDM, 4400-GUARD-01 access and 4400-BG-01 rear access. A fresh learner should explain why **perimeter clear**, **guard closed**, **robot safeguard reset**, **safety-output high**, **actuator physically stopped**, **person absent**, and **deliberate restart** are separate claims.

This module extends the existing [trapped-person/restart-prevention design card](TRAPPED_PERSON_RESTART_PREVENTION_DESIGN_CARD_2026-09-17.md) with exact UR I/O and mode evidence, rather than replacing its general occupancy framework.

Read [UR SW10_15 OEM source audit](../research/4400_UR_SW10_15_SAFEGUARD_AUTO_RESET_MODE_AND_SYSTEM_STOP_HANDOFF_OEM_AUDIT_2026-10-25.md), [ABB/ISO source scope](../research/4400_ABB_RESET_VISIBILITY_ISO10218_2025_CELL_INTEGRATION_SCOPE_AUDIT_2026-10-25.md), and [learner cases / blank witness](4400_CELL_WALKTHROUGH_RESET_MODE_AND_RESTART_TECHNICIAN_CARD_2026-10-25.md).

## Hazard boundary
A person may **walk through** a light curtain or guard opening and stand in an undetected region. Restoring the optical field or closing the gate proves neither vacancy nor permission to move. A protective input configured for **Automatic Mode Safeguard Stop** may have a different manual-mode effect than a general safeguard input. A safety output restored by an upstream E-stop release may rearm a connected machine even without a new human start.

## OEM-grounded mechanism (not universal robot behavior)
- UR10e PolyScope X **SW10_15**: ordinary Safeguard Stop is category 2 **all modes**; Automatic Mode Safeguard Stop is category 2 **Automatic only**, with three-position enabling requirements. **DOC-CONFIRMED, exact software family**.
- Disabling configured Safeguard Reset permits automatic reset on safeguard-clear, which the OEM warns against for undetected whole-body entry. **DOC-CONFIRMED**.
- I/O/fieldbus start may move robot from current position; System Stop can rise on external E-stop release and must not be interpreted as a new start for downstream machinery. **DOC-CONFIRMED**.
- ABB recommends separate outside-zone manual reset with good view and separate deliberate start; ISO 10218-2:2025 publisher confirms robot-cell integration scope but not specific unseen clauses. **DOC-CONFIRMED with source limits**.

## Safety architecture layers
| Layer | Owner / example | May establish | Must not be mistaken for |
|---|---|---|---|
| Normal control | LinuxCNC, robot program, HMI, ordinary PLC/FPGA | queued step, displayed mode, program pause | personnel safety, safe load holding |
| Diagnostics | drive-ready, standard network status, status HMI | clues to faults and sequence | verified final element or occupancy |
| Independent safety | validated guard/interlock, safety controller, appropriate reset/EDM | authorized protective stop/rearm according to actual SRS | physical safe state without final-element proof |
| Physical energy/holding | drive STO where appropriate, brake, independent valve, ram support, isolation | selected actuator stopped/held/isolated if validated | complete cell clearance, another axis safe |

## Design-state contract (INFERENCE; not selected wiring)
**C0 unknown/unsafe:** power return, reset fault, ambiguous occupancy or mode -> inhibit hazardous start; do not rely on ordinary controller bit.
**C1 protective demand:** entry/guard opening causes independent protective response for *all relevant cell hazards*; determine actual category, final elements and hold.
**C2 access present:** protective field may be clear but person still inside; no automatic rearm if undetected occupancy possible.
**C3 reset eligibility:** safeguarded zone cleared by validated method, external reset within appropriate view, no stuck reset, feedback/guard operative.
**C4 reset accepted:** safety permission may return, but no queued/held ordinary motion is allowed to start without **new deliberate start**.
**C5 operation:** only after separately verified authority; if mode changes, re-evaluate which protective function remains active.
**C6 service:** lockout/tagout and stored-energy control where applicable; neither E-stop nor category 2 standstill is isolation.

## Cross-machine adversarial review
- Robot with a suspended gripper load: category 2 monitored standstill is not load-drop protection.
- Press brake with rear helper: rear gate closed is not Y1/Y2 gravity hold or personnel clearance.
- Mill with automatic toolchanger: a stationary spindle does not establish drawbar retention or pneumatic isolation.
- Lathe with enclosure: door closed does not establish spindle run-down/zero energy.
- Plasma/laser cell: robot stop does not extinguish separate process energy or eliminate fumes.
- Conveyor/feeder: downstream machine may rearm on shared stop output; must independently require new start.

## Practical anti-bypass design
Make a correctly aligned guard and clear outside-cell reset easy to use; provide an unambiguous safe access path, local mode indication, reachable escape/emergency means and a jam-clear process that does not demand routine defeat of safeguards. Survey actual operators for nuisance stops, hard-to-see zones and unreachable reset; treat recurring defeat as a design defect. **Do not** authorize personnel-exposed operation if basic independent stop/hold/occupancy/restart protection cannot be demonstrated.

## Evidence / graduation
G0/G1 **HOLD** pending selected-machine as-built SRS, installed function, mode map, zone coverage and physical stop/hold. G2 documentary worksheet only, **NOT RUN**. G3/G4 protected physical verification **NOT AUTHORIZED** until qualified machine-specific plan. G5 fresh information-separated competency **OPEN**. Learner paper cases are not blind evaluation.

**Promotion/uncertainty:** exact installed robot/PLC/firmware and safety output topology (UNKNOWN, HIGH, blocks selected graduation); actual occupancy blind spots and emergency escape (UNKNOWN, CRITICAL, blocks); independent Y1/Y2 stop/hold and any gauge/robot axes (UNKNOWN, CRITICAL, blocks); full 2025 ISO normative clauses (UNKNOWN, MEDIUM, no unverified normative assertion); physical reaction/holding measurements (UNKNOWN, CRITICAL, blocks). Counterfactual: alternate physical truth could overturn machine safety, so **NOT GRADUATED**. No LinuxCNC/FPGA safety authority assigned.
