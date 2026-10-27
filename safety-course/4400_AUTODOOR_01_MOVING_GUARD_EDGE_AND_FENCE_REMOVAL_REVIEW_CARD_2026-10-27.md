# 4400-AUTODOOR-01 — A moving guard can be the hazard
**Technician/reviewer card · 2026-10-27 · DOCUMENTARY / NOT SCORED / NOT RUN**

Use with [original OEM and regulatory source audit](../research/4400_AUTODOOR_01_HAAS_CNC_POWERED_DOOR_EDGE_CURRENT_FENCE_REMOVAL_SOURCE_AUDIT_2026-10-27.md). Do not apply Haas-specific M80/M81 or INPUT 128 numbering to LinuxCNC.

## One-pass field decision
**Question:** A fenced robot was removed from a CNC machine. The powered door still opens and closes and its controller reports no alarm. Can the machine be returned to standalone use?

**Answer:** **Not on that evidence.** Haas explicitly documents an HE Autodoor/robot-or-APL variant supplied *without an edge sensor* because it has a fence, and requires installing an edge sensor if the machine will run without that fenced automation. Confirm the exact model/serial/variant and changed safeguard dependency. A normal “no alarm” is not proof of an intact closing-edge safeguard. Do not allow people exposed to an unqualified door closing/crush hazard.

## Separate four propositions
| Observable | What it can support | What it cannot support |
|---|---|---|
| Controller door-close request / Cycle Start | Ordinary motion command | Closing edge free of people; certified protective function |
| Motor-current reversal or CAN protection | OEM-described process response to excess motor load | Qualified obstruction-force limit, full sensor fault detection or safety-rated stop |
| Edge sensor INPUT 128 changes | An installed/connected OEM input responds in that check | Safe stop/reversal on real door, cable open/short coverage, safety integrity |
| Door closed/locked feedback | State of selected interlock *if correctly wired/qualified* | Robot cell empty, pinch prevention during closure, all hazardous motion stopped |

## Safe review order (do not deliberately obstruct a live door)
1. **BND/CHG:** Establish installed machine, door type, firmware/options, robot/APL and fence history. Document which protective device was removed or replaced. No generic “fence not needed now” assumption.
2. **HAZ/ENE:** Map closing nip/shear/entrapment, door fall/track service, spindle/robot hazards, and any pneumatic/electrical stored energy separately.
3. **SF/AUTH:** Identify a qualified closing-edge/obstruction function and an independent enclosure/guard interlock. Keep ordinary LinuxCNC/FPGA/M-code door requests outside personnel-safety authority.
4. **DEP:** Check sensor kit, option patch, wiring, cable carrier, door height/shims, lock alignment, power-loss response, controller fault behavior, and any retained cell-safe input. A stuck HIGH cell-safe input is not proof of a cleared cell.
5. **PHY/VAL:** Qualified personnel design a safe validation procedure for the selected hardware: edge actuation, sensor faults, closing stop/reversal, guard-lock and hazardous-machine stop, unexpected restart, and door support during service. **None performed here.** Do not insert fingers, hands, tools, or persons into a moving door to “prove” it works.
6. **HF:** Make the protective edge and guard alignment easy to inspect and repair. A persistent nuisance trip calls for maintenance and redesign, not bypassing the edge or door lock.
7. **RELEASE:** Retain HOLD until all selected-machine evidence, independent physical witnesses, and any applicable safety-performance requirements are qualified.

**Source-specific trap:** Haas TG0044 Rev E describes a 250-ms CAN firmware overcurrent-protection condition and software reversal; that is **not a machine-safe stopping-time specification**. Haas AD0583 Rev C documents INPUT 128 verification, but does not establish a certified edge channel. OEM HRP-3 installation explicitly describes fence/edge substitution. These are **DOC-CONFIRMED product statements**; extrapolated fault chains are **INFERENCE**; selected-machine facts and physical results are **UNKNOWN**.

**Change-control trigger:** Removing robot/APL/fence, replacing door motor, moving the lock/rail, changing edge wiring/patch or changing automatic-door cycle behavior makes prior protective-function validation potentially STALE. The safest inexpensive pattern is to preserve the proper edge hardware and inspection instructions with the machine and make the guard easier to keep than to defeat.

**OpenPressBrake:** no automatic door is asserted installed. This cross-machine 4400 lesson does not change G0/G1 HOLD, 2520–25F0 external-evaluator NOT RUN or any machine-specific safety ratings. No physical testing or compute.
