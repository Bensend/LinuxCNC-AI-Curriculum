# 4400-G28-G30-01 — Predefined position is not a safe retreat
**One-pass technician card | 2026-10-28 | no machine test or safety approval.** Read [the pinned G28/G30 source audit](../research/4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md) after [G38 probe-status/offset audit](../research/4400_PROBE_EDGE_01_LINUXCNC_2910_G38_PRESTATE_EDGE_AND_FALSE_SUCCESS_SOURCE_AUDIT_2026-10-28.md) and the [2520 safety design entry](2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md).

**What actually happens:** G28/G30 are normal **rapid moves** to persistent machine-coordinate reference parameters. With axis words, LinuxCNC first rapids to an **intermediate waypoint in the active coordinate system**, then to the stored reference for the specified axes. With no axis words, it moves all axes toward the stored reference. G28.1/G30.1 save the current position; neither homes a joint against a physical switch nor validates a collision-free path. If a reference was never stored, official docs describe machine-origin fallback.

| Common mistaken assumption | Correct review |
|---|---|
| “G28 means safe home.” | Inspect stored `5161–5169`, active work/tool offsets, axis words and both rapid legs. |
| “G28 X0 Y0 retracts Z before moving XY.” | Not by that instruction on a trivial XYZ machine. Verify a separately ordered clearance/retract plan. |
| “G30 means the tool changer is safe.” | G30 reference is normal positioning; tool capture, spindle stop, guards and safe restart need separate proof. |
| “G28.1 confirms homing.” | It stores a position; it is not independent physical position trust. |
| “Machine soft limits make any G28 route safe.” | Limits constrain travel; they do not certify fixture clearance, person absence or gravity holding. |

**Human-factor fix:** make the approved tool-change/retreat route simpler than hand-editing G28/G30 parameters or bypassing a guard. Label the selected reference and fixture setup, show unexpected reference changes, provide a guarded service route and require intentional fresh start after a fault. Do not promote HMI “HOME” or “AT G30” to a green personnel-safety signal.

**Authority boundary:** normal LinuxCNC/HAL/FPGA controls positioning; independently qualified safety logic owns protective stop/guard/rearm; actual final elements must physically stop and hold hazards. Selected OpenPressBrake Pilz/AKAS, K1/K2/EDM, Y1/Y2 hydraulic stop/hold, guard, isolation and restart remain **UNKNOWN/NOT RUN**. **G0/G1 HOLD; G3/G4 NOT AUTHORIZED.** No numeric stop-time, PL/SIL, machine motion or physical test claimed.


**M6-specific correction:** in the tagged v2.9.10 interpreter, `TOOL_CHANGE_AT_G30=1` produces a **direct** traverse to the stored G30 reference, not the two-leg `G30 axes` command path. `TOOL_CHANGE_QUILL_UP=1` adds a **separate Z-first** traverse; `TOOL_CHANGE_WITH_SPINDLE_ON=1` can suppress the normal spindle-stop command. Even an emitted spindle-stop command is not measured standstill. Inspect all three INI options and independent physical guard/tool-retention evidence; do not conflate M6 with a G30 block.


**Homing gate is ordinary Task control:** v2.9.10 normally rejects MDI/Auto execution if a joint's normal HOMED flag is false; `[TRAJ] NO_FORCE_HOMING=1` bypasses that prerequisite. Neither a successful HOMED check nor a G28.1/G30.1 stored coordinate proves physical trust, collision-free route or independent safety. Do not assume an unhomed G28 always runs, or that Task's gate is a safety-rated permissive.


**More inspectable normal-control pattern:** official G53 is nonmodal and explicitly addresses machine coordinates; a qualified machine-specific program can use **separately ordered** G53 G0 clearance legs rather than depending on hidden G28/G30 reference parameters. But `G53 G0 X0 Y0 Z0` is still a combined rapid, **not** automatically Z-first, and G53 does not prove physical position trust or independent personnel safety. Never copy illustrative coordinates into a machine without validating its real clearance envelope.


**G28.1/G30.1 do not physically measure a safe point:** tagged `convert_savehome` computes persistent reference values from interpreter `current_*` and offsets. It does not independently sample a safety encoder, verify a mechanical stop, or prove that a tool/fixture clearance pose is safe. Do not use “saved current position” as a physical witness.
