# G53-G91-01 — Machine-coordinate command is not a verified safe retreat
**2026-10-29 | LinuxCNC v2.9.10 source/technician card | no machine test**

**Source fact that the G53 reference's error list omits:** G53 is rejected if **G91 incremental distance mode is active**, even though G53's accepted coordinates are machine-absolute. The pinned interpreter checks both an explicit G91 on the block and a previously modal incremental state. G53 is also **nonmodal**: a following line without G53 returns to the active work-coordinate system.

A G53 G0 XYZ move is an **ordinary combined rapid**, not a guaranteed Z-first clearance, physical home verification or personnel-safety stop. A failed retract must never be counted as “ram/tool safely clear.”

**Review at the desk, not on a hazardous machine:** Inspect the macro's modal G90/G91, explicit G53 on each intended machine-coordinate leg, active G0/G1, cutter compensation, real tool/fixture clearance, trusted machine reference, and **what the operator sees after an interpreter error**. If error handling is unclear, leave recovery blocked and require a qualified process review. Avoid copying generic X0/Y0/Z0 examples.

**Source trace:** [pinned v2.9.10 check/coordinate/straight-motion audit](../research/4400_G53_G91_01_LINUXCNC_2910_MACHINE_COORDINATE_INCREMENTAL_REJECTION_DOC_OMISSION_SOURCE_DELTA_2026-10-29.md), extending the [existing G28/G30 source audit](../research/4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md). **SOURCE-CONFIRMED** interpreter check; **DOC-CONFIRMED** G53 error-list omission; downstream physical consequence **INFERENCE**, machine state **UNKNOWN**, runtime **NOT RUN**.

**Safety boundary:** LinuxCNC/FPGA motion, modal state and homing are normal control. Independent guard, safety controller, physical stop/hold, isolation and deliberate restart still require their own selected-machine proof. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
