# 4400-TOOL-02 — Automatic tool-change compatibility and transfer authority
**2026-10-25 | 12 PAPER cases | NON-GRADUATED | NO TEST**

Read [manufacturer-source audit](../research/4400_WILA_NS_ATC_GSERIES_INCOMPATIBILITY_SAFETY_CLICK_SENSING_AUDIT_2026-10-25.md) and the [TOOL-01 manual-change foundation](4400_TOOL_01_PRESS_BRAKE_TOOLING_RETENTION_HANDLING_AND_RAM_HOLD_MODULE_2026-10-25.md).

**Key source correction:** WILA NS ATC tools are not compatible with its classic G-Series gripper. WILA's Safety-Click position detection is presented as **process control**, not a safety-function certificate. A dual ToolGripper's published 515 mm tool-length capability is not a load rating. The exact BIU-026 classic product says **<12.5 kg** for vertical Safety-Click change; generic WILA prose says up to and including 12.5 kg. Exact product instructions resolve the boundary, not a convenient rounding assumption.

For each paper case: name the hazardous physical proposition, manufacturer evidence needed, independent final element, safe decision, and stale-evidence trigger.

1. New NS ATC punch presented to an old G-Series gripper.
2. Gripper physically closes but pneumatic pressure is lost before transfer.
3. Safety-Click position detection reads true with an incompatible adapter.
4. Robot reaches holder target but holder capture is not physically witnessed.
5. BendSense identifies the correct tool while a foreign object blocks seating.
6. Dual gripper handles a long tool; someone treats 515 mm as a mass rating.
7. Classic BIU-026 exactly 12.5 kg is selected for vertical change based on generic inclusive wording.
8. Fixed-pin classic tool is scheduled for vertical removal.
9. Tool storage docking pins are removed during a changeover.
10. A person enters the cell after the robot stops but while the tool is suspended.
11. Controller reboots with an ATC resume command and an unknown tool-transfer state.
12. A replacement pneumatic valve and sensor preserve the same PLC tags but change fail-state timing.

## Blank physical witness / qualification (all NOT RUN)
| ID | Selected exact witness | State |
|---|---|---|
| ATC-ID | Gripper generation, tool adapter, orientation, compatibility, serial/revision | UNKNOWN |
| ATC-GRIP | Independent retention during pickup/transfer and power/air loss | NOT RUN |
| ATC-STORAGE | Physical storage release/return and support | NOT RUN |
| ATC-HOLDER | Actual capture and clamp before gripper release | NOT RUN |
| ATC-CELL | Guarding/people-clear and independent motion stop | NOT RUN |
| ATC-RESET | Fresh rearm without retained ATC/robot command | NOT RUN |

**Decision:** any incompatible/unknown mating generation, unsupported tool, unknown transfer support, missing cell exclusion or unproven fresh restart = HOLD. No personnel-exposed operation or test; selected safety controller and mechanical holding are separate from ordinary LinuxCNC/PLC/robot process control.
