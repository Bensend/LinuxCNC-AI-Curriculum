# 4400-AMR-TRANSFER-01 — Handshake is not safe transfer: four paper cases
**2026-10-30 | PUBLIC UNSCORED technician exercise | NOT RUN**

Source: [Omron I680 original conveyor/lift audit](../research/4400_AMR_TRANSFER_01_OMRON_I680_CONVEYOR_LIFT_HANDSHAKE_VS_INDEPENDENT_STOP_SOURCE_AUDIT_2026-10-30.md); prerequisites [AMR-FLEET-01](../research/4400_AMR_FLEET_01_OMRON_2019_2025_FLEET_WIFI_NOT_INTERLOCK_AND_EDGE_BARRIER_OEM_AUDIT_2026-10-30.md) and [AMR-MODE-01](../research/4400_AMR_MODE_01_OMRON_JOYSTICK_LIDAR_BYPASS_STOP_ENVELOPE_AND_REARM_OEM_AUDIT_2026-10-30.md).

For each case, identify HZ, physical PROP, normal-control signal, independently selected SF/SRS and final element, failed-feedback/energy/occupancy possibility, restart ownership, and the qualified physical witness. Do not invent selected machine data or self-score.

1. An AMR reports 'ready for conveying in'; a lift is still descending and the stationary CNC conveyor starts. Which ordinary I/O handshake is insufficient, and what must actually be held/stopped?
2. A drawing shows a safety relay and an optional safety PLC. The roller motor has a stuck-on drive command. What exact physical energy-removal path and feedback must be demonstrated rather than assumed from symbols?
3. A 'conveying complete' sensor is stuck high while a part bridges the gap. The AMR receives an ordinary depart command. What fault latch, material restraint, personnel exclusion and independent stop are needed?
4. After a jam, the operator presses error reset on both AMR and CNC. One system retains 'start' while the other resumes. How do you prevent automatic rearm, provide accessible recovery, and require a new deliberate cycle start?

**Not an operating procedure.** No physical run, no hidden answer, no external score, no new machine release. The example's 'same E-stop circuit' instruction is manufacturer/application specific; exact selected safety architecture must be independently validated. G0/G1 HOLD.
