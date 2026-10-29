# 4400-EOFFSET-01 — Feed hold is not a universal motion stop
**Technician/reviewer field card | 2026-10-29 | SOURCE/DOC study, NOT a machine authorization**

**Problem:** On LinuxCNC v2.9.10, an external-axis-offset generator has its own request, planner and applied position. G-code feed hold does not prove that all possible normal-control motion paths are quiet. Turning off the external-offset enable does not automatically erase the offset already applied.

| What the screen says | What it actually supports | What it does **not** prove |
|---|---|---|
| `motion.feed-hold=TRUE` (with appropriate M53 state) | Ordinary G-code feed scaling can be zero | No external-offset, jog or physical actuator movement; independent safe stop |
| `axis.L.eoffset-enable=FALSE` | New offset requests not accepted by that planner branch | Existing offset removed or no residual deceleration |
| `axis.L.eoffset-request=0` | Requested planner target zero | Applied position instantly zero; physical ram held |
| `axis.L.eoffset=0` | Software-reported applied offset near zero | Safe torque/energy isolation, correct homing, independent guard access |
| `motion.eoffset-limited=TRUE` | Software soft-limit interaction | Controlled protective stop; no following error or lost steps |
| No “disabled while NON-zero” warning | **Nothing reliable:** v2.9.10 source has an unreachable warning predicate | Zero offset, correct disable sequence, safe restart |

## Three easy-to-confuse operations
1. **Hold G-code:** normal feed control; offset motion uses another planner. Do not use feed hold as an E-stop or guard-access permit.
2. **Disable offset:** stops accepting new offset requests; an existing offset is retained, with possible deceleration. Do not label this “offset cleared.”
3. **Clear/reset offset:** changes internal request or resets on machine-on. It is still normal software behavior, not proof of the physical safe state.

## Safer, easier operating design
Give operators separate visible **REQUESTED**, **APPLIED**, **FEED HELD**, **INDEPENDENT SAFETY PERMITTED**, and **PHYSICAL STOP/HOLD VERIFIED** states. If an offset is unexpectedly nonzero or limit interaction occurs, keep hazardous operation unavailable and use the selected machine's qualified recovery/verification procedure. Make that procedure accessible and quick enough that nobody needs to bypass guards or hand-edit HAL signals. Never ask a maintainer to enter a danger zone because a display says “offset disabled.”

## Paper-only reviewer checks (not a lab)
Can the reviewer trace the normal G-code feed-scale path separately from the external-offset planner? Identify the exact assignment that makes the warning unreachable? Explain why a software limit and an internal offset reset cannot certify physical stop/hold? These checks require no motion or power.

**Sources:** [exact pinned v2.9.10 audit](../research/4400_EOFFSET_01_LINUXCNC_2910_INDEPENDENT_OFFSET_MOTION_DISABLE_LATCH_AND_SILENT_WARNING_SOURCE_AUDIT_2026-10-29.md), [official LinuxCNC 2.9 external offsets](https://linuxcnc.org/docs/2.9/html/motion/external-offsets.html), [safety course entry](SAFETY_COURSE_ENTRY_CARD_2026-10-28.md), [Stage A evidence request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md).

**OpenPressBrake actual configuration UNKNOWN.** No runtime test, physical stop, hydraulic load hold, guard, isolation or fresh restart proved. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.**


**Upstream counterexample to “paused means safe”:** the original v2.9.10 [`jwp_z_panel.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/external_offsets/jwp_z_panel.hal) deliberately connects `halui.program.is-paused` to `axis.z.eoffset-enable`; its `M0` demo asks the operator to change Z offset while paused. This is **SOURCE-CONFIRMED demo wiring, NOT RUN**. Therefore display **PROGRAM PAUSED** separately from **EXTERNAL OFFSET APPLIED** and from independent safety permission. Never grant access to dies, tools or moving axes solely because the program is paused.
