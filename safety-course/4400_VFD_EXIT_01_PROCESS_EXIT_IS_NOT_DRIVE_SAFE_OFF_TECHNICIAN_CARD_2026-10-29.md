# 4400-VFD-EXIT-01 — Closing LinuxCNC is not a VFD safe-off function
**2026-10-29 | open-book technician safety card | NON-GRADUATED | no live VFD/machine tests**

Read the [exact source/docs and dated field-report audit](../research/4400_VFD_EXIT_01_LINUXCNC_2910_SHUTDOWN_HAL_MODBUS_LAST_COMMAND_VS_INDEPENDENT_STOP_SOURCE_AUDIT_2026-10-29.md). The pinned LinuxCNC INI manual explicitly says `[HAL]SHUTDOWN` **may** set outputs on normal exit but **cannot** be relied on during a computer crash and is **not** a physical E-stop replacement.

## The critical distinction
A user closes LinuxCNC while a Modbus-controlled spindle has been commanded RUN. The GUI disappears. Is the drive guaranteed OFF? **No.** A September 2026 LinuxCNC issue reports a VFD continuing to run after exit in one installation. That is **COMMUNITY-REPORTED**, not proof for every VFD. The original LinuxCNC source confirms a conditional cleanup script, and the manual warns it may not run. A **client** Modbus response timeout is not the **drive's** autonomous communication-loss stop function.

## Four desk reviews (no energized tests)
1. Identify whether the selected VFD receives RUN through fieldbus, ordinary terminals or another controller. Locate the exact drive manual's **communication-loss reaction** and **independent safety inputs**. If unavailable, mark UNKNOWN; do not assume an automatic stop or invent a timeout.
2. Trace the difference between **normal LinuxCNC exit**, **crash/PC power loss**, **USB/RS485 disconnect**, and **drive still powered**. Which failures prevent the shutdown script from transmitting any command?
3. Explain why `MB_RESPONSE_TIMEOUT_MS` and `MB_BYTE_TIMEOUT_MS` in mb2hal control client-side waiting, **not** drive-side stored RUN. A successful software error message does not remove hazardous energy.
4. Separate ordinary `spindle.on`/`machine-is-on`, selected drive watchdog behavior, independent protective stop/guard logic, physical final element, and qualified energy isolation. Do not call an ordinary HAL pin a safety-rated E-stop.

## Safer machine/operator contract
| Display | Required evidence | Unsafe shortcut |
|---|---|---|
| LinuxCNC disconnected | PC/process state | "drive is stopped" |
| Modbus timeout | exact source, age, communication health | "VFD dropped RUN" |
| VFD stopped | fresh selected drive/shaft feedback, valid provenance | stale RPM=0 |
| Protective stop | independent selected safety function and final element | `shutdown.hal` or ordinary HAL enable |
| Maintenance safe | qualified isolation, stored-energy release/restraint, verification | power down PC only |
| Restart ready | independent reset plus deliberate fresh start | reconnect fieldbus and auto-resume |

**Design for imperfect operators:** make a one-action ordinary STOP available, but require an independently verified safe-access/isolation procedure for human exposure. If a drive remains powered after PC shutdown, the operator should see **DRIVE STATE UNKNOWN / DO NOT ENTER**, not a green "machine off" badge.

**Evidence status:** SOURCE-CONFIRMED cleanup code; DOC-CONFIRMED explicit INI warning and client timeout scope; COMMUNITY-REPORTED issue #4529; TEST-CONFIRMED none; physical selected machine UNKNOWN. No new competency score, workflow, or safety release. OpenPressBrake G0/G1 HOLD.
