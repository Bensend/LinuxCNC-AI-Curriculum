# 4400-COORD-01 — After a short circuit, Type 2 does not mean reset-and-run
**Technician field card | 2026-10-28 | PAPER / UNSCORED / NO LIVE TEST**

Read the [original Schneider Type I/II coordination audit](../research/4400_COORD_01_TYPE1_TYPE2_SHORT_CIRCUIT_COORDINATION_CONTACT_WELD_POST_FAULT_REARM_SOURCE_AUDIT_2026-10-28.md), existing [PANEL-01 electrical safety module](4400_PANEL_01_MULTIFEED_SCCR_ARC_FLASH_ISOLATION_AND_RAM_HOLD_MODULE_2026-10-25.md) and [MIRROR-01 source-depth](../research/4400_MIRROR_01_ROCKWELL_SUVA_AND_SCHNEIDER_ACCESSORY_SOURCE_DEPTH_ADDENDUM_2026-10-28.md).

**Scenario:** The starter's breaker trips during a fault. The catalog claims Type 2 coordination. A technician has a replacement breaker with a higher standalone interrupt rating and wants to reset the machine immediately.

**Decision:** **HOLD**. Type 2 applies to a tested **combination**, not an arbitrary breaker. The original manufacturer permits **light contact welding** under defined conditions and requires maintenance guidance. A higher breaker kA number does not establish the same peak-current/I²t protection. Determine the fault cause, isolate all energy, inspect and follow exact manufacturer post-fault instructions, restore the correct approved combination, requalify affected EDM/final elements and separately verify machine safe state before a deliberate new start.

**Keep six witnesses separate:** (1) actual available fault current, (2) breaker/fuse interrupting capability, (3) panel SCCR, (4) exact Type I/II starter combination, (5) safety output/EDM/main-contact physical behavior, (6) hydraulic/mechanical stop, gravity hold and fresh restart. A 'green' PLC bit or a replaced fuse proves none of the others.

**Practical repair design:** store the approved protective-device and contactor/auxiliary part numbers together, make the protected maintenance/isolation map easy to find, display fault source instead of a generic reset prompt, and require qualified post-fault inspection rather than inviting a jumper or substitution. Use existing Stage A A–G, RST-03/04/07/11/12 and PANEL-01 witness; **do not create a new owner form**.

**OpenPressBrake installed protection and Pilz/AKAS/Y1/Y2 physical behavior are UNKNOWN. G0/G1 HOLD; no personnel-exposed hazardous operation authorized.**
