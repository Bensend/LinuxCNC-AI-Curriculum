# 4400-G96-CSS-01 — A G96 D cap is not independent safe-speed protection
**2026-10-29 | offline technician review | NON-GRADUATED / NOT TESTED**

Read [pinned LinuxCNC v2.9.10 G96 source audit](../research/4400_G96_CSS_01_LINUXCNC_2910_D_CAP_X0_OFFSET_AND_COMMAND_VS_PHYSICAL_OVERSPEED_SOURCE_AUDIT_2026-10-29.md) and [G95 spindle-feedback source audit](../research/4400_G95_SPEED_01_LINUXCNC_2910_SPINDLE_SELECTION_RPS_FEEDBACK_AND_FALSE_FEED_SOURCE_AUDIT_2026-10-29.md).

**What the source actually establishes:** `G96 S... D...` uses programmed surface speed, work/tool X datum and a commanded-speed cap. If D is omitted, the v2.9.10 interpreter substitutes `1e30` for its own D cap, **but** the ordinary motion layer still applies configured spindle speed limits. Do not claim an unbounded physical RPM, or that an ordinary configured cap is a certified independent overspeed function. The CSS formula uses commanded X and offsets; `spindle.N.speed-out` is a command, not actual measured RPM.

**Unscored desk checks:** A program omits D: identify both interpreter and motion caps before making any conclusion. A tool offset shifts X0: explain why CSS commanded RPM can change without a different S word. A green commanded-RPM display is shown while spindle feedback is stale: identify the missing physical evidence. A chuck rating is below the configured CNC max: identify the machine-specific workholding/guard/safety requirements rather than inventing an allowable RPM.

**Safer workflow:** distinguish actual RPM, commanded RPM, workpiece center, tool offset, programmed D, configured machine maximum and independently selected safety protection on the offline review sheet. Design guards and chip-clearance access so their legitimate use is easier than defeat. No live spindle, chuck, cabinet, guard or machine test is authorized by this card. No physical TEST-CONFIRMED evidence; **G0/G1 HOLD** and independent evaluator OPEN.
