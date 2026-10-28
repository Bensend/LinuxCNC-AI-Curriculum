# 4400-MODAL-RESTORE-01 — A saved M3 can return after an M5
**Technician / programmer one-pass card | 2026-10-28 | no live test**

Read the [original pinned v2.9.10 interpreter source audit](../research/4400_MODAL_RESTORE_01_LINUXCNC_2910_M70_M72_M73_SPINDLE_RESTART_AND_COOLANT_RESTORE_SOURCE_AUDIT_2026-10-28.md) after the existing [M0/M1 pause versus safe access source audit](../research/4400_LINUXCNC_M0_M1_PAUSE_RESUME_VS_SAFE_ACCESS_SOURCE_AUDIT_2026-10-27.md).

**Misconception:** “M5 stopped the spindle, so a later M72 just restores harmless settings.” In the inspected LinuxCNC interpreter, M70/M73 save spindle-0 M3/M4/M5 and coolant state; M72 or normal M73 subroutine return can **generate and execute new M3/M4/M7/M8/M9 commands** when saved and current states differ. This is normal program behavior, not a personnel-safety reset.

| Question before access | Required distinction |
|---|---|
| Was M5/M9 a normal process step? | Yes. It is not verified zero energy, safe standstill or LOTO. |
| Is there an M70/M72 pair or M73 subroutine? | Inspect saved modes and later restore/return paths. M73 does **not** auto-restore on abort. |
| Does a status screen show spindle stopped? | A status bit is not an independent guard, spindle brake, physical lock or proof of energy isolation. |
| Can a restore command start a new cycle? | Ordinary program execution may reissue spindle/coolant commands; independent safety rearm and a separate deliberate start must remain authoritative. |
| Does this apply to OpenPressBrake? | Only the general control-authority lesson transfers. No actual OpenPressBrake spindle or M72 usage is asserted. |

**Make the safe action easiest:** put a clear protected setup/service workflow next to the machine, with accessible isolation and verified restraint; do not ask technicians to rely on an M5, M71, paused program or remembering which subroutine will return. Guards should be simple to close and reinstall. An M72 restore must never override independent safety-related stopping, gravity holding or fresh-start conditions.

**Desk-only check (UNSCORED):** saved spindle-0 mode is M3, then a normal subroutine issues M5. On M72, what does `gen_m_codes` append and what remains unknown physically? Answer from source, not a machine test. No additional examination bank or evaluator score.

**Release:** G0/G1 HOLD; actual selected OpenPressBrake safety program, Y1/Y2 stop/hold, guarding and independent evaluator UNKNOWN/OPEN. No hazardous operation with people exposed. GitHub-hosted/self-hosted compute 0 min.
