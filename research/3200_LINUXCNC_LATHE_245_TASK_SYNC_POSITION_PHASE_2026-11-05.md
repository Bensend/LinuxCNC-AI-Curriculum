# LATHE-245 — Task forwarding and position/velocity spindle-sync math (LinuxCNC v2.9.10)
**Scope:** 3200 lathes; non-graduated; 2026-11-05. Follow-up to LATHE-244. No machine operation, simulation, build or compute.

## Question and result
Does the G33/G76 canonical synchronization request actually reach motion, and how does the trajectory planner turn encoder revolutions into requested tool velocity? **SOURCE-CONFIRMED**: the previously open Task forwarding link is closed. Task dispatches the queued synchronization message into the userspace motion interface, which emits the realtime command. The motion handler calls the TP configuration function. Position synchronization is not a simple RPM-to-feed multiplier: after index acquisition it accelerates into phase, establishes an offset and continuously corrects spindle-relative position error.

## Immutable source ledger (LinuxCNC/linuxcnc tag v2.9.10)
| File and blob SHA | Lines / symbols | Finding |
|---|---|---|
| `src/emc/task/emctaskmain.cc` `7292a172023a5b42b023447c2458cb766c93fc9b` | 1882–1885, `EMC_TRAJ_SET_SPINDLESYNC_TYPE` | Passes spindle, feed_per_revolution, velocity_mode to `emcTrajSetSpindleSync`. |
| `src/emc/task/taskintf.cc` `96a041d1feef8560f37159a2f18b109171f084c3` | 1398–1405 | Writes `EMCMOT_SET_SPINDLESYNC`; `spindlesync=fpr`, `flags=wait_for_index` (parameter name is misleading in this call chain: Task supplies velocity_mode). |
| `src/emc/motion/command.c` `0b79061d39be915bbea548b2c33bb794d31ab302` | 989–991 | Forwards spindle, pitch, flags into `tpSetSpindleSync`. |
| `src/emc/tp/tp.c` `5768d6e6880569f72156ed9a761b5eee531c9fcf` | 3516–3529, 2971–3035, 2950–2964, 3459–3476, 2928–2940, 2825–2842 | Sync mode selection, spindle phase tracking and index gate. |
| `src/emc/motion/control.c` `b6e45d590c7d11030654d8f7d13d118f581b6439` | 1979–1995 | Internal index request becomes HAL_IO index-enable; falling HAL acknowledgement clears internal request. |
| LATHE-244 pinned `src/emc/task/emccanon.cc` blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11` | 1247–1266 | Canonical queues `EMC_TRAJ_SET_SPINDLESYNC` with velocity_mode=false for G33/G76. |

## End-to-end control path
G33/G76 interpreter -> canonical START_SPEED_FEED_SYNCH -> EMC_TRAJ_SET_SPINDLESYNC -> Task `emctaskmain.cc` case -> `emcTrajSetSpindleSync` in `taskintf.cc` -> EMCMOT_SET_SPINDLESYNC -> motion `command.c` -> `tpSetSpindleSync` -> queued synchronized trajectory segment -> index handshake -> `tpSyncPositionMode` each TP cycle. STOP_SPEED_FEED_SYNCH queues zero pitch; `tpSetSpindleSync` sets `tp->synchronized=0` when sync=0. **Important naming trap:** `taskintf.cc` names its third argument `wait_for_index`, but the same bit is passed from Task as `velocity_mode` and TP interprets nonzero as TC_SYNC_VELOCITY, zero as TC_SYNC_POSITION. Do not interpret this argument as a direct instruction to bypass/require the physical index independently of sync mode.

## Position synchronization: exact equations and timing
`tpSetSpindleSync(tp, spindle, sync, mode)` stores `uu_per_rev=sync`, selects spindle and mode. For `mode=0` it selects `TC_SYNC_POSITION`. The selected spindle's `spindleRevs` is signed according to `direction` by `tpGetSignedSpindlePosition` (tp.c 340–349). The position-mode controller computes:

`pos_desired = (spindle_revs - spindle_offset) * uu_per_rev`
`pos_error = pos_desired - tc.progress - (nexttc ? nexttc.progress : 0)`

Immediately after the index gate releases, `sync_accel` is set. While the segment has not caught up with the target spindle-derived speed, it requests `tc.maxvel`; when `tc.currentvel >= target_vel`, it recalibrates `spindle_offset = spindle_revs - tc.progress / uu_per_rev`, clears `sync_accel` and switches to tracking. In tracking:

`spindle_vel = (spindle_revs - old_revs) / cycleTime`
`target_vel = spindle_vel * uu_per_rev + sign(pos_error) * sqrt(abs(pos_error) * tangential_max_accel)`

Negative requested velocities are clipped to zero; a synchronized next segment may inherit the target velocity. This is a source formula, **not** a claim of guaranteed phase accuracy under arbitrary acceleration, encoder noise or timing delays. The `sync_accel` branch uses a different velocity estimate, `spindle.revs/(max(cycleTime,epsilon)*sync_accel++)`; avoid treating this as a steady-state derivative.

For `TC_SYNC_VELOCITY`, the planner instead uses `abs(spindleSpeedIn)*uu_per_rev` with a next-segment progress correction; it does not use the above position-error feedback. Thus a G33/G76 position-sync setup is fundamentally different from feed-per-revolution velocity sync.

## Worked inspection exercise (analytical, not executed)
Assume position-sync tracking already established, `uu_per_rev=1.5 mm/rev`, signed spindle advances 0.010 rev in a 1 ms TP cycle, `pos_error=+0.04 mm`, `tangential_max_accel=100 mm/s²`, no next segment. Feed-forward velocity = (0.010 / 0.001)*1.5 = **15 mm/s**. Error correction = sqrt(0.04*100) = **2 mm/s**. Requested target = **17 mm/s** before downstream constraints. If error is -0.04 mm, target becomes 13 mm/s. The numbers illustrate source math only; no spindle or axis dynamics were simulated.

## Diagnostics and falsifiable predictions (NOT TESTED)
1. Wrong spindle direction sign produces signed-revolution tracking errors even if RPM magnitude looks right. Inspect `spindle.N.revs`, direction and the selected spindle before tuning.
2. With at-speed true but index-enable never acknowledged, position-synchronized segment cannot enter its normal tracking phase. Distinguish at-speed gate from index gate.
3. After index acknowledgement, a transient acceleration-to-phase state precedes steady tracking; observing a short transient does not alone prove missed index.
4. Misconfigured revolution scale multiplies the commanded tool motion per actual revolution. Verify real encoder count-to-rev conversion against physical index.
5. `velocity_mode=1` changes the TP algorithm, not merely an index-wait toggle.

## Reproduce source audit
```sh
git clone --filter=blob:none https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc && git checkout v2.9.10
git grep -n 'EMC_TRAJ_SET_SPINDLESYNC_TYPE\|emcTrajSetSpindleSync' -- src/emc/task
git grep -n 'EMCMOT_SET_SPINDLESYNC\|tpSetSpindleSync' -- src/emc/motion src/emc/tp
git grep -n 'tpSyncPositionMode\|tpSyncVelocityMode\|waiting_for_index' -- src/emc/tp
git ls-tree v2.9.10 src/emc/task/emctaskmain.cc src/emc/task/taskintf.cc src/emc/tp/tp.c
```

## Evidence boundary and next dependency
**SOURCE-CONFIRMED:** Task bridge, mode-bit semantics, position tracking equations, phase-offset capture and separate velocity mode. **INFERENCE:** how real encoder quantization, servo ordering and network delay affect thread pitch error. **UNKNOWN:** complete real Mesa lathe INI/HAL inclusion chain; per-pass G76 index reacquisition in executable tests; observed performance. **TEST-CONFIRMED:** none newly obtained. Before any new test, inspect historical LAB_COMPUTE_LOG and lab-jobs/results by G33/G76, spindle index, Mesa and threading synonyms. Any justified execution is isolated self-hosted [self-hosted, openpressbrake] only, with no machine outputs. Independent personnel safety, blind evaluator separation and graduated levels unchanged.

**Next:** locate a publicly inspectable Mesa lathe configuration, enumerate all INI HAL files and servo-thread order, verify encoder counts/scale/index-enable wiring; if unavailable rotate to 3300 plasma torch-height control or 4000 HostMot2 firmware/driver boundary.