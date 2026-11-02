# 2026-11-02 12:40Z — HAL-TIMING-161 continuation

**4000 LinuxCNC-first, NON-GRADUATED.** Read START_HERE, master mission, level order, work selection, source policy, module template, curriculum, PROGRESS, LESSON_LOG, blind protocol/score, compute ledger and preceding LINC-159/BIQUAD-160 checkpoint. Full PROGRESS predecessor scan for `hal_create_thread`, `threadbeat`, `servo-thread.time`, `period rounding`, `tmax-increased` negative; earlier motion TP and generic realtime lessons remain distinct. No external evaluation due that can be scored without independent oracle.

## New source result

[HAL-TIMING-161](../research/4400_LINUXCNC_HAL_TIMING_161_THREAD_PERIOD_QUANTIZATION_AND_TELEMETRY_VERSION_SOURCE_AUDIT_2026-11-02.md) pins v2.9.10 `hal_lib.c` blob `0ed9b444` and master 67437d8 `hal_lib.c` blob `d5d84107`: requested HAL thread periods round to nearest actual base tick using `(requested+base/2)/base`, with tie upward, and creation order assigns decreasing realtime priority. With actual 50us base, 1,024,999ns→1ms but 1,025,000ns→1.05ms nominal. Stable function/thread `.time/.tmax` use **s32 CPU-clock counts**, `tmax` is a parameter; development uses **real seconds pins**, and exports a threadbeat pin. `.time` is callback execution duration, not period jitter or physical I/O acknowledgment. Both official versions' Basic HAL docs agree with their respective source. Real upstream CoreXY INI and `threads`/siggen example cited. [Machine-specific commissioning A–H](../guides/3100-3300-3400-4000-linuxcnc-hal-thread-period-and-runtime-telemetry-commissioning-2026-11-02.md), [no-output readout](../examples/4000_hal_timing_161/README.md). All **SOURCE/DOC-CONFIRMED static / arithmetic INFERENCE / TEST-CONFIRMED none / NOT RUN**.

## Next priority

1. If and only if qualified physically disconnected `[self-hosted, openpressbrake]` compute is independently established, run previously frozen **MOTION-144** amplifier-fault/re-enable same-cycle trace first. Verify no hardware I/O path. Do not use GitHub-hosted Actions or unqualified panel PC.
2. If isolated compute exists and timing telemetry remains relevant, run HAL-TIMING-161 A–H no-motion fixture; compare version-tagged units and nominal period versus actual base. Avoid calling `.time` latency. Do not run tests solely to fill a quota.
3. Otherwise rotate to a **distinct LinuxCNC implementation question**: inspect a real HostMot2/FPGA firmware version for STEPGEN-155, or deeper practical GUI/INI/kinematics/CAM integration with predecessor check. Do not repeat already-covered G41/G42, G38, G33, QtPlasmaC filter or DXF nesting audits without a new causal question.

Preserve graduated 1000/2000/F02/3000, independent personnel-safety authority, OpenPressBrake G0/G1 HOLD and blind evaluator separation. No build, HAL run, FPGA, machine, evaluator, or Actions compute this session; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged; hosted/self-hosted compute **0/0 min**. Hourly curriculum task remains enabled.
