# 4000 — Disconnected LinuxCNC EtherCAT/CiA402 machine-configuration acceptance

**2026-10-31 | NON-GRADUATED, NOT RUN.** Sources: [ETHERCAT-51 public machine/config comparison](../research/4400_LINUXCNC_ETHERCAT_51_CNC3_VS_2026_CSP_CONFIG_HOMING_DC_SOURCE_AUDIT_2026-10-31.md), [ETHERCAT-52 CiA402 internals](../research/4400_LINUXCNC_ETHERCAT_52_CIA402_FAULT_HOMED_FEEDBACK_SOURCE_AUDIT_2026-10-31.md), [ETHERCAT-50 Sync Unit timing](../research/4400_LINUXCNC_ETHERCAT_50_SYNCUNIT_FRESHNESS_LATE_TX_DC_PHASE_SOURCE_AUDIT_2026-10-31.md), [HOMING-27](../research/4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md). No live drives or physical motion. If compute is justified, use only verified disconnected `[self-hosted, openpressbrake]`; never GitHub-hosted Actions.

## Static acceptance before attempting LinuxCNC startup

1. Freeze the 2026 XYZ CSP template at `szolkaa/Automatic-linuxcnc-config-generators-for-ethercat@50b25a8fb263a234801e40b43abc89c558c82840`, the public CNC3 at `rabin-HE/OPENCNC-J@4f565be44497988774f28614ee7281938ffcdf87`, and maintained driver at `linuxcnc-ethercat@56515f4aac313551346289d9c227193f50e9602a`. Record exact installed LinuxCNC, `lcec`, `cia402` and custom homemod binary versions separately; source URLs are not installation evidence.
2. For each XML slave, inventory index, VID/PID, Sync Managers, PDO index, entry index/subindex, width, direction, HAL pin, `dcConf` and watchdog. Verify against *actual* ESI/drive firmware. Template matching alone is insufficient. The 2026 sample uses EK1100 index 0 and generic drives 1–3.
3. Follow HAL function order: `lcec.read-all` → `cia402.read-all` → motion → `cia402.write-all` → `lcec.write-all`. Check every `lcec.0.N.*` pin and each `joint.N.motor-pos-cmd`, `motor-pos-fb`, enable and fault connection. Spindle CSV needs 0x60FF target velocity and a velocity-command connection; 0x607A alone is CSP.
4. Compare `[EMCMOT]SERVO_PERIOD` with `appTimePeriod`. Classify positive `refClockSyncCycles` as R2M and `-1` as M2R for the pinned driver; record SYNC0 cycle/shift, `pll-err`, `dc-sync-converged` and WKC separately. On LinuxCNC 2.10+, verify `initf lcec.activate` availability and use; do not insert unsupported `initf` into 2.9.
5. Inspect `HOME_ABSOLUTE_ENCODER`, `HOME_SEQUENCE`, `HOMEMOD` and actual custom homemod pins. The generated 2026 INI has three absolute-encoder joints and **no HOME_SEQUENCE**. Under stock Home All semantics, they are excluded; verify the installed custom module rather than assuming Home All works. Its `FERROR=MIN_FERROR=1000` is a template, not a justified error budget.
6. Record raw `cia402.N.stat-fault` separately from `drv-fault`, `stat-homed` from `joint.N.homed`, and bus `lcec.0.wkc-state`, `all-op`, `slave-oper`, `dc-sync-converged` from app freshness. A low `amp-fault-in` alone cannot prove a fault-free drive. Independent STO/stop/safety systems are outside HAL.

## Frozen discriminating tests (all proposed; no observed PASS)

| ID | Disconnected stimulus | Required observation |
|---|---|---|
| EC51-1 | Static XML/HAL/INI mapping comparison | Exact PDO→HAL→joint graph and correct function order, not merely successful XML parse |
| EC51-2 | Compare 2024 and 2026 clock fields | R2M `5` vs `1`, shifts −250000 ns vs 0; do not infer actual synchronization |
| EC51-3 | Two isolated Home All INI variants: omitted sequence vs explicit `HOME_SEQUENCE=0` | Record accepted command, joint0 `homed`, Task mode, actual custom homemod path; no source-only PASS |
| EC51-4 | Disconnected HAL load of *installed* homemod and CiA402 | Exact pin existence, types, direction and ownership; no reliance on README alone |
| EC52-1 | Raw statusword fault with enable off, then on and fault reset | `stat-fault`, `drv-fault`, controlword 0x80, nominal 100 ms mask and eventual fault |
| EC52-2 | Homing mode bit10+12 high then CSP mode with bits low | Retained `stat-homed` versus fresh status; verify completion edge |
| EC52-3 | Synthetic 0x6064 values crossing signed rollover | 2021 direct conversion vs 2026 modular unwrapping |
| EC52-4 | Drive feedback changes while joint command fixed | Actual joint `f-error`, home state, custom homemod treatment; reject `FERROR=1000` as proof |
| EC52-5 | WKC incomplete with unchanged CiA402 status | Separate bus health from cached drive pins and input freshness |

**Trace schema:** `time_ns, linuxcnc_sha, lcec_sha, cia402_sha, homemod_sha, joint, home_request, home_state, joint_homed, motor_pos_cmd, motor_pos_fb, f_error, opmode_display, statusword, stat_fault, drv_fault, stat_homed, stat_homing, lcec_wkc_state, lcec_all_op, slave_oper, dc_sync_converged, result`. A real PASS requires retained raw trace, version hashes, accepted Task command and checked postcondition. A motion-logger acknowledgment is not a realtime oracle ([TP-48](../research/4400_LINUXCNC_TP_48_COMMAND_ACK_EFFECTIVE_STATUS_ORACLE_SOURCE_AUDIT_2026-10-31.md)).

**Review-only changes:** explicitly choose Home All sequencing, independently establish homemod feedback/origin behavior, select justified following-error limits, monitor raw fault and bus diagnostics, and measure DC phase before changing clock authority. None of these is a ready-to-deploy machine patch. Keep OpenPressBrake G0/G1 HOLD and independent personnel-safety authority. [Next checkpoint](../checkpoints/20261031T144601Z-4000-linuxcnc-ethercat-cia402-next.md).
