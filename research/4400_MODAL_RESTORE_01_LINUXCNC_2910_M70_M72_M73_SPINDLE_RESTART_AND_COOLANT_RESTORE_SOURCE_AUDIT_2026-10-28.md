# 4400-MODAL-RESTORE-01 — M72/M73 can reissue normal spindle/coolant commands
**2026-10-28 | pinned LinuxCNC v2.9.10 source inspection | NON-GRADUATED | no runtime test**

## Safety question
A normal subroutine saves modal state while spindle 0 is ON, then issues M5 for a temporary process step. Could returning from an M73-protected subroutine, or later issuing M72 after M70, **reissue M3/M4 and restore coolant**? The official LinuxCNC M-code manual explicitly includes spindle and coolant in saved modal state. More importantly, the inspected interpreter **constructs and executes M-code differences**, not merely changing internal labels. This is ordinary G-code state restoration, **not** independent personnel-safe rearming.

**Predecessor check:** full PROGRESS, safety index, research plan and cumulative design contain an existing [TSC/TAB M73 OEM portability collision](4400_TSC_TAB_01_LINUXCNC_HAAS_M73_M74_COLLISION_AND_COOLANT_SHUTDOWN_SOURCE_AUDIT_2026-10-27.md) (Haas TAB M73 versus LinuxCNC modal save), plus M0/M1/stop/restart lessons. They do **not** document this exact M70/M72/M73 saved-spindle re-command implementation. The increment is **restoration as an active command generator**, not a generic claim that a program can restart a spindle.

## Pinned original source, LinuxCNC/linuxcnc v2.9.10
- [interp_convert.cc L3534–3560](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3534-L3560), blob `f01a359652d588d59c9e210fa441a99d2ee19598`: M70/M73 call `save_settings` and mark the current frame valid; M73 in a subroutine sets `CONTEXT_RESTORE_ON_RETURN`; M71 invalidates the context; M72 calls `restore_settings` if valid. **SOURCE-CONFIRMED.**
- [interp_convert.cc L3076–3093](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3076-L3093): `save_settings` writes active G/M codes and saves them in the current call frame. **SOURCE-CONFIRMED.**
- [interp_write.cc L160–190](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_write.cc#L160-L190), blob `061891632d1dde3c4ec156fc223ee38daeb0621a`: `write_m_codes` encodes spindle 0 status as M5, M3 or M4, mist as M7/M9 and flood as M8/-1. It **only tracks spindle 0** for this saved M-code slot; do not claim equivalent multispindle restoration. **SOURCE-CONFIRMED.**
- [interp_convert.cc L2982–3019](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L2982-L3019): `gen_m_codes` compares current and saved M-code slots and appends actual M-code text for spindle, mist, flood, overrides, adaptive feed and feed hold when different. **SOURCE-CONFIRMED.**
- [interp_convert.cc L3105–3168](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3105-L3168): `restore_settings` calls `gen_settings` and `gen_m_codes`, then invokes `execute` for each generated line. **SOURCE-CONFIRMED.**
- The [official M-code manual §§M70–M73](https://linuxcnc.org/docs/stable/html/gcode/m-code.html) lists saved M3/M4/M5, M7/M8, feed/speed/hold and states that M73 restores on normal subroutine return, **not** program abort; M72 requires a valid save at that call level. **DOC-CONFIRMED.** It also says the G1/G0 motion mode is *not* restored.

## Source-based conditional failure path (not executed)
1. Normal process has spindle 0 commanded ON (M3 or M4) and coolant active. A valid M70/M73 saves that state.
2. A subroutine or maintenance-like macro issues M5 and M9 as **normal process commands**, without independent energy isolation.
3. An M72 restore (or M73 normal return/endsub) compares saved state with current state and can **emit a fresh M3/M4 and coolant command**. The source `execute` path demonstrates a command request, not just a UI status update.
4. The normal spindle/coolant control path may act on those commands if enabled and wired. Actual motor rotation, physical energy, guarding, speed and timing are **UNKNOWN**. A correctly designed independent safety chain must continue to block hazardous motion when access is unsafe.

**Do not generalize:** M73 auto-restore does not occur on abort; M71 invalidates the saved frame but is **not** a safety isolation method; M72 with no valid save errors; remaps and selected machine configurations may differ. The code encodes spindle **0** in its saved M-code state, not all spindles. A saved M3 command with speed zero is not necessarily rotating immediately; subsequent speed changes may cause rotation (official M3 docs). None of these nuances supplies personnel-safe restart authority.

## Practical design / human factors
- **Normal control:** use modal restore only for process-program continuity; review M70/M72/M73 and subroutine return as potential command-producing transitions. Label temporary M5/M9 as *process stop only*.
- **Monitoring:** observe actual spindle feedback, coolant valve state and program transitions as diagnostics, not independent protective permission.
- **Safety-related control:** guard/door/occupancy and protective stop must be enforced outside ordinary LinuxCNC/HAL/FPGA; restoration must not bypass independent rearm, safe-area confirmation and a separately deliberate cycle start.
- **Physical isolation:** maintenance requires actual energy isolation and stored-energy control. An M5 followed by M72 cannot be a service lockout. For press brakes, this lesson transfers only to the general **ordinary command restoration versus independent Y1/Y2 stopping/holding** boundary; it does **not** establish any OpenPressBrake spindle, coolant or modal-restore configuration.
- **Easier safe workflow:** make guarded setup and service steps obvious and accessible; keep guards quick to reinstall, do not incentivize reliance on temporary M5 or an operator remembering to avoid M72.

## Evidence and stop
**SOURCE-CONFIRMED** pinned code above; **DOC-CONFIRMED** official M70–M73 behavior; **INFERENCE** the conditional M70/M5/M72 or M73-return re-command sequence and any machine-level hazard; **UNKNOWN** installed mappings, physical rotation, protective devices, selected-machine stop/hold; **TEST-CONFIRMED none**, **COMMUNITY-REPORTED none used**. No lab: the exact interpreter question is adequately answered by source and docs; no safety-rated physical claim can be established by an ordinary simulation. GitHub-hosted compute **0 min**, self-hosted **0 min**. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Independent 2520–25F0 evaluator OPEN; no personnel-exposed hazardous operation.
