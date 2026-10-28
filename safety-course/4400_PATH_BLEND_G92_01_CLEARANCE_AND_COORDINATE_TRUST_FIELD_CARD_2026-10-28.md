# 4400 field card — The commanded corner is not a protected clearance
**2026-10-28 | process-planning guidance, not safety validation.**

Read [G64/G0 planner source audit](../research/4400_PATH_BLEND_01_LINUXCNC_2910_G64_G0_CLEARANCE_AND_STOP_MODE_SOURCE_AUDIT_2026-10-28.md) and [G92 persistence/offset audit](../research/4400_G92_PERSIST_01_LINUXCNC_2910_UNSPECIFIED_AXIS_OFFSET_AND_RESTART_SOURCE_AUDIT_2026-10-28.md) after the [G28/G30 waypoint audit](../research/4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md).

### Two traps
**Corner trap:** default G64 allows corner blending, including rapid G0 moves. The tool may begin moving sideways before reaching the programmed retract point. G64 P0 is not a zero-error guarantee; it behaves like untoleranced G64. G61.1 plans a stop at every segment end, but is not a protective stop or physical clearance witness.

**Offset trap:** G52 and G92 share offset registers; G92 omitted-axis behavior in pinned v2.9.10 source preserves earlier offsets even though one G92 documentation paragraph says omitted offsets become zero. G92.2 disables offsets but retains saved values; G92.3 can restore them. Default M2/M30 persistence is not unconditional cleanup.

### Safer, easier normal-operation pattern
- **Before starting:** identify the active G5x, G52/G92, tool offset, homing trust, fixture/tool envelope and path mode. If the setup calls for zero G92 state, explicitly clear with G92.1 rather than hoping a restart or partial G92 command did so.
- **During clearance-sensitive process moves:** make the Z-retract and XY-travel stages explicit and review the planner mode. Use G61.1 when the process needs an exact stop at the corner; do not leave G64 untoleranced and assume orthogonal clearance. Consider G53 for deliberately selected machine-coordinate moves only after the physical reference is trusted.
- **For personnel protection:** independent guard/protective device, safety controller, energy-removal/holding elements, safe access and deliberate restart remain necessary. No G-code mode, HMI position, planner completion or servo following-error limit receives personnel-safety credit.
- **If a shortcut is observed or setup state is uncertain:** stop normal production, retain diagnostic and configuration evidence, establish a trustworthy machine reference and review the tool/fixture path before any authorized restart. Do not bypass guards to watch the motion.

**Human-factors test to conduct only in a qualified, nonhazardous review:** can a new operator see the active offsets and planner mode before pressing Cycle Start, and can they select a verified clearance procedure more easily than bypassing it? **INFERENCE / NOT TESTED.** No machine-specific clearance, stop distance or safe operating threshold is asserted.

**Status:** G0/G1 HOLD; physical validation NOT RUN; 2520–25F0 independent evaluation OPEN. No personnel-exposed hazardous operation.
