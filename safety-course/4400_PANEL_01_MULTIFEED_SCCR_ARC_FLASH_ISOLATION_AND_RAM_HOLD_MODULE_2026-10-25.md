# 4400-PANEL-01 — Machine electrical cabinet: multi-feed SCCR, arc-flash, isolation and mechanical safe state
**Level 4000 safety implementation | 2026-10-25 | NON-GRADUATED | No physical test, no selected machine approval**

## Learning objective
A fresh engineer must be able to explain why (a) a panel's short-circuit current rating, (b) the installation's available fault current, (c) a protective device's interrupting rating, (d) an arc-flash task assessment, (e) an electrically isolated work zone, and (f) an independently held press-brake ram are **six distinct facts**. They must identify evidence needed to make each fact true, trace unsafe shortcuts and design an easier safe-maintenance workflow.

**Prerequisites:** 2520 hazard-to-SRS, 2530/2540 safety final elements, 2580 stored energy, 4400 selected-machine G0 intake. Read the [original UL/OSHA audit](../research/4400_UL_OSHA_MACHINE_PANEL_MULTIFEED_SCCR_ARC_FLASH_AND_LOTO_SOURCE_AUDIT_2026-10-25.md) before the exercises.

## Engineering hazard boundary
| Layer | Typical function | May legitimately establish | Cannot by itself establish |
|---|---|---|---|
| LinuxCNC/HAL/FPGA | Normal servo, pump, VFD, reset and HMI state | Ordinary commands/telemetry at recorded version | Shock protection, arc-flash control, electrical isolation or independent ram hold |
| Independent safety controller/final elements | Hazard-specific stop/guard/drive inhibit | Defined safety control response with qualified design/validation | All electrical feeds disconnected, no stored energy, or gravity load physically supported |
| Supply/overcurrent hardware | Disconnect, protective device, distribution, combination rating | Rated electrical protection *if* selected and installed correctly | Incident energy, task PPE, ram holding or verified absence of voltage |
| Qualified electrical safe-work procedure | Lock/isolate every applicable source; test exposure zone; restore deliberately | Evidence for a particular task and installation | Generic authorization for unrelated maintenance or future altered panel |
| Physical hydraulic/mechanical restraint | Prevents gravity/pressure motion while personnel may be exposed | Machine-specific verified load holding | Electrical absence of voltage or arc-flash exposure protection |

## Derive the SRS from actual tasks, not from a panel label
1. **HAZ-ELEC-01:** technician opens main cabinet to replace an I/O card; separate power/UPS and line-side exposure unknown. SRS: no exposed energized parts during ordinary service; all supplies identified; independent qualified isolation and absence-of-voltage evidence.
2. **HAZ-ELEC-02:** short-circuit in a new VFD or auxiliary power circuit. SRS: each machine supply/panel has documented adequate SCCR relative to available fault current; protective-device combinations verified at exact installed part/revision. Never substitute an assumed generic kA rating.
3. **HAZ-ELEC-03:** technician troubleshoots a fault with dead front removed. SRS: default to deenergized design/test points outside live compartments; energized work only if genuinely justified, separately qualified and protected.
4. **HAZ-MECH-01:** power removed while Y1/Y2 ram remains raised. SRS: independently verified physical stop/hold and safe maintenance restraint; do not rely on STO or a zero servo command.
5. **HAZ-START-01:** service ends, guards and power return. SRS: removal of jumpers/tools, people clear, independent safety rearm, then a **fresh** ordinary start. Restoring power/reset alone must not start hazardous movement.

## Low-friction design patterns (proposals, not installed facts)
- Separate an accessible **low-voltage service bay** from incoming power/VFD conductors with durable dead-front partitions; provide safe external diagnostic test points when technically feasible.
- Label every incoming supply and independent lockable isolator at the actual point of service; place an accurate *multi-source* supply map inside the controlled maintenance package.
- Use a door-mounted remote HMI or service diagnostics that do not require routinely opening the live power compartment.
- Prefer listed/recognized, documented power-protection combinations and an easily inspected panel nameplate rather than a field fuse improvisation.
- Make the guarded panel easy to close and reinstall: captive fasteners, unobstructed wiring, good light and readable diagnostics. A guard that technicians must defeat to perform routine work is a design defect.
- Design an independent ram-restraint/energy isolation workflow for mechanical access; an electrically safe cabinet does not make the dies safe.

## Discriminators to demand from a reviewer
- **SCCR vs available fault current:** site-supplied prospective fault-current evidence, selected power-circuit parts, approved combination/UL 508A method and correct enclosure marking.
- **SCCR vs arc-flash:** task, incident-energy/exposure and protective measures are separately evaluated; neither number substitutes for the other.
- **Isolation vs control stop:** disconnecting devices, all sources including backfeed, stored energy, qualified test at exposed points, controlled reenergization.
- **Safety stop vs gravity holding:** actual Y1/Y2 load path, hydraulic pressure zones, physical mechanical restraint and qualified independent stop/hold witness.
- **Revision control:** new PC supply, UPS, VFD, fuse, drive, branch circuit, machine location or upstream transformer triggers a change impact review, not an automatic pass.

## Technician assessment and verification
Complete [18 unscored PAPER scenarios and blank evidence card](4400_PANEL_01_TECHNICIAN_DECISIONS_AND_BLANK_WITNESS_2026-10-25.md) and [12-gate no-energy review](4400_PANEL_01_12_GATE_UNPOWERED_DESK_REVIEW_2026-10-25.md). A fresh independent evaluator must supply a *new* unseen case and withhold the answer; no self-scoring or claimed graduation. Do not perform live voltage probing or intentional faults as a curriculum exercise.

## Evidence/status
**DOC-CONFIRMED** exact UL/OSHA source statements in linked audit; **INFERENCE** design patterns and SRS decomposition; **SOURCE-CONFIRMED** none new; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none; **UNKNOWN** all actual OpenPressBrake electrical/hydraulic details. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. If basic safety cannot be established, no personnel-exposed hazardous operation. Isolated/remote experiments require a separately qualified plan and people outside the danger zone.

## 2026-10-28 COORD-01 source-depth — post-fault Type I/II is not panel SCCR
The [original Schneider Type I/II coordination audit](../research/4400_COORD_01_TYPE1_TYPE2_SHORT_CIRCUIT_COORDINATION_CONTACT_WELD_POST_FAULT_REARM_SOURCE_AUDIT_2026-10-28.md) adds a **post-short-circuit starter-combination witness** to existing panel SCCR/LOTO. Type II permits specified light contact welding and requires manufacturer maintenance measures; a standalone replacement breaker's kA rating does not inherit the original tested combination. Distinguish available fault current, breaker interrupt rating, panel SCCR, exact Type I/II combination, actual EDM/final-element state and physical gravity/pressure stop/hold. A cleared fault or new fuse does not authorize production. No installed-machine short-circuit test, new exam bank or physical validation; G0/G1 HOLD.
