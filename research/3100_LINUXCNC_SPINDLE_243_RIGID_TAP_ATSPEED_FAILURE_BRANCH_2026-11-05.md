# SPINDLE-243 — Rigid-tap insertion failure changes pending at-speed state (2026-11-05)

**Scope:** 3100 mills / 3200 lathe transfer, NON-GRADUATED. LinuxCNC v2.9.10 source inspection, no execution. This is a correction to the completeness language in SPINDLE-241: its field-reference enumeration did not emphasize the rigid-tapping failure branch. Do not extrapolate this branch to successful G33/G76 threading.

## Pinned primary source

LinuxCNC/linuxcnc `v2.9.10`, `src/emc/motion/command.c`, Git blob **`0b79061d39be915bbea548b2c33bb794d31ab302`** ([tagged file](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c)). Inspected the complete `EMCMOT_SPINDLE_ON`, `EMCMOT_SPINDLE_OFF` and `EMCMOT_RIGID_TAP` switch arms through the GitHub source connector. This is source evidence, not runtime evidence.

## New verified branch

1. `EMCMOT_SPINDLE_ON` writes `emcmotStatus->atspeed_next_feed = emcmotCommand->wait_for_spindle_at_speed` after updating spindle state. This is global pending-next-feed state, not proof that the spindle has reached speed.
2. `EMCMOT_SPINDLE_OFF` zeros selected spindle state/speed/direction, engages brake, cancels orientation, and does **not** directly assign `atspeed_next_feed` in this switch arm.
3. `EMCMOT_RIGID_TAP` first checks coordinated/enabled mode, position range and limits. It then calls `tpAddRigidTap(...)`. **If and only if that call returns a negative result**, the inspected branch assigns `atspeed_next_feed = 0`, reports an insertion error, aborts the coordinated TP, and sets the motion error flag. On successful insertion this arm clears the motion error flag but does not assign the pending field.
4. Therefore, a blanket statement that the pending flag is changed *only* by spindle start, line/circle insertion and CSS is incomplete. The error path of rigid tapping is another writer. The comment `rigid tap always waits for spindle to be at-speed` accompanies this **failure** branch; it does not by itself prove the TP's runtime synchronization algorithm.

## Important discriminators

| Command sequence / condition | Source-level expectation | Unknown / required oracle |
|---|---|---|
| M3 then M5 then first G1 | M5 arm does not directly clear pending flag | Whether the program actually waits/stalls depends on Task/TP and HAL; unexecuted |
| M3 then failed `tpAddRigidTap` | Negative-return arm clears pending flag | Whether interpreter can subsequently resume without abort/reset; unexecuted |
| M3 then successful `tpAddRigidTap` | No pending-field assignment in successful rigid-tap arm | Actual rigid-tap at-speed and index synchronization needs `tpAddRigidTap`/TP trace |
| Rigid-tap precondition failure before insertion | No explicit pending-field reset in the inspected precondition branches | Other error/abort paths and command sequencing unverified |

## Reproducible inspection

```bash
git clone --filter=blob:none https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc
git checkout v2.9.10
git rev-parse v2.9.10:src/emc/motion/command.c
rg -n 'atspeed_next_feed|EMCMOT_RIGID_TAP|tpAddRigidTap|EMCMOT_SPINDLE_OFF' src/emc/motion
```

For a bounded isolated simulation, first check historical `LAB_COMPUTE_LOG.md`, `lab-jobs/`, `lab-results/`, and upstream tests for rigid-tap failure/at-speed evidence. If no equivalent oracle exists, use only an authorized self-hosted `[self-hosted, openpressbrake]` runner and a simulator with controlled spindle feedback. Record queued command order, `motion.spindle-at-speed`, TP state, error output, and exact exit/timeout; a generic workflow PASS is insufficient. Do not send motion to physical hardware.

## Evidence and learning boundary

**SOURCE-CONFIRMED:** negative `tpAddRigidTap` return clears the pending flag; successful arm does not; M5 arm lacks direct reset. **INFERENCE:** whether these branches change externally observable waits after a particular G-code sequence. **NOT TESTED:** G33/G76 spindle index phase, successful G84/rigid-tap synchronization, physical encoder/index capture, machine behavior. No graduation or independent safety-gate changes.

## Next checkpoint

Rotate to the higher-information-gain **3200 lathe spindle-synchronized feed**: pin v2.9.10 interpreter G33/G76 canonical call path, motion `EMCMOT_SET_SPINDLESYNC`, TP index-enable and phase/position logic; contrast G33 and rigid tapping. Inspect a real Mesa lathe encoder HAL/INI before claiming any physical wiring. Do not continue speculative M3→M5 stall narratives without an executable oracle. Also keep the real Mesa ATC configuration search open as a separate branch, not a prerequisite to lathe research.
