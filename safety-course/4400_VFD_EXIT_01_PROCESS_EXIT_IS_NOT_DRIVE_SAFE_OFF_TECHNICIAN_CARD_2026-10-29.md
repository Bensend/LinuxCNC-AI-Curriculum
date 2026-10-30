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


## 2026-10-30 exact-OEM addendum — auto-retry can mask the ordinary fault relay (not a new scored competency)
Read the [Schneider ATV12 07/2018 original-manual audit](../research/4400_VFD_RESTART_01_SCHNEIDER_ATV12_2018_RETRY_MASKED_R1_HELD_RUN_FLYING_RESTART_OEM_AUDIT_2026-10-30.md) **after** this card. Its printed p.91 warns that with `Atr=YES` R1 may not indicate a fault until the automatic-restart time-out, while `tCC=2C,tCt=LEL` permits a held run level to restart on eligible recovery; optional `FLr=YES` can catch a coasting motor. Printed p.51 says `tCt=trn` needs a new transition after power interruption, but that is **ordinary drive logic, not independent safety**.

**Incremental technician decision (PUBLIC / UNSCORED):** If a selected drive's R1 "no error" contact remains energized during retries, a controller displays green and the operator opens a spindle enclosure, identify the missing physical witnesses: independent protective stop/guard function, selected final element, standstill/kinetic-energy state, and fresh-start authorization. Record exact model, firmware, `Atr,tAr,tCC,tCt,FLr,r1`, terminal/control source and fault eligibility. **Do not infer these ATV12 parameters exist on another VFD or that any OpenPressBrake hardware is so configured.** No energized test, machine release or evaluator score.


## 2026-10-30 source-level counterexample — `pi500_vfd.enable=0` does not transmit the advertised trip in the inspected code
[Read the pinned LinuxCNC PI500 original-source audit](../research/4400_PI500_VFD_01_LINUXCNC_PIN_REMOTE_TRIP_CLAIM_VS_COMMENTED_OUT_SOURCE_PATH_AUDIT_2026-10-30.md). The published pin says `enable=0` will remote-trip, but `pi500_trip()` is commented out and the `!status.alarm && !enable` branch logs `failed to trip` then continues without a Modbus trip/STOP command. **PUBLIC UNSCORED review:** distinguish the declared pin contract, actual code path, error log, ordinary heartbeat, drive-side behavior and independently proven physical stop. No actual VFD response or machine exposure was tested; do not generalize the bug to other drivers or make the corrected software a safety-rated stop. Existing VFD-EXIT competency and independent safety boundary remain unchanged.


## 2026-10-30 PI500 cross-layer watchdog source-depth (PUBLIC / UNSCORED; no new competency)
[PI500-OEM-COMM-02](../research/4400_PI500_OEM_COMM_TIMEOUT_02_SOURCE_OEM_CROSS_LAYER_WATCHDOG_AUDIT_2026-10-30.md) establishes a second discriminator: with `enable=0` and successful status reads, the LinuxCNC **HAL** heartbeat stops toggling while Modbus polling continues. The manufacturer-authored 2018 PI500 manual (mirrored) documents **F9.04=0.0s** communication timeout disabled by default and an **F8.18 Err.16** response that may be configured to continue running. Neither a HAL heartbeat nor a drive-side communications fault is a personnel-safe stop. The [upstream review packet](4400_PI500_UPSTREAM_MAINTAINER_REVIEW_PACKET_2026-10-30.md) supplies a non-executed acceptance matrix; a one-line uncomment of the unknown `0x0002` coil is not an established repair. Exact drive and physical stop remain UNKNOWN; G0/G1 HOLD.
