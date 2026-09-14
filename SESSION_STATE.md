# Active Curriculum Session State

Session start UTC: `2026-09-14T21:36:26Z`
Session end UTC: `2026-09-14T21:50:44Z`
Actual elapsed: **14.3 minutes**
Status: **CLOSED — 3500 bounded breadth stop preserved; active work rotated to 3700 and EDM adaptive/reverse-path authority advanced.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. No closed prerequisite work was reopened or rescored.

## Branch selection

Repository-authoritative state at session start was newer than the stale 3300 instruction embedded in the invocation: `PROGRESS.md` and `checkpoints/3500-next-2026-09-14b.md` made **3500 Robots / Custom Kinematics** active. That newer state was followed.

3500 then reached a clean breadth/source stop, so work rotated under `WORK_SELECTION_POLICY.md` to **3700 Grinding / EDM / Specialty Finishing** rather than ending the session.

Latest active checkpoint: `checkpoints/3700-next-2026-09-14.md`.

## Durable 3500 work completed

Created:

- `research/3500-za6-runtime-stale-command-fault-containment-source-trace-2026-09-14.md`
- `research/3500-za6-launch-supervision-controller-death-boundary-2026-09-14.md`
- `research/3500-puma200-genserkins-field-commissioning-chronology-2026-09-14.md`
- `research/3500-genserkins-inverse-failure-field-reconciliation-2026-09-14.md`
- `checkpoints/3500-next-2026-09-14c.md`

### ZA6 result

Pinned Tormach/HAL/device-manager source now separates high-level trajectory freshness, HAL command storage, EtherCAT online/oper state, CiA-402 drive state, software quick stop, and functional safety/STO.

EtherCAT/drive faults have real containment: lcec online/oper loss reaches device-manager fault and `drive_safety` can impose cross-drive quick-stop-compatible control-word masking. No downstream command-age/generation/heartbeat witness was found for `hal_hw_interface.*.position_cmd` itself.

`hal_control_node` can set `cm_ok=0` and stop ControllerManager read/update/write without resetting command pins, and no ZA6 use of `cm_ok` as a drive/quick-stop permissive was found. Launch supervision does globally shut down on HAL-manager exit/readiness failure, but that is not proof of timely STOP/quick-stop for every individual high-level controller failure.

Preserved rule: **fieldbus healthy != high-level command fresh**.

### PUMA/genserkins result

The real 2026 PUMA 200 commissioning chronology separates working joint motion from valid Cartesian kinematics. The actual repair path required correct physical zero/home geometry, modified-DH frames/signs, wrist transmission coupling, and physical gear-ratio verification; supplied family gearing was for another PUMA 2xx variant.

Pinned genserkins source confirms a seeded iterative Jacobian inverse. Jacobian build/inversion can fail before max-iteration exhaustion; nonconvergence, singularity, wrong mechanism/model calibration, joint soft limits and following error are distinct failure classes. Blindly raising `max-iterations` is not a repair for bad machine geometry.

3500 is open/paused, not graduated.

## Durable 3700 work completed

Created/advanced:

- `research/3700-grinding-edm-breadth-survey-2026-09-14.md`
- `research/3700-edm-adaptive-feed-source-trace-2026-09-14.md`
- `research/3700-edm-reverse-path-synced-io-source-trace-2026-09-14.md`
- updated `checkpoints/3700-next-2026-09-14.md`
- updated `PROGRESS.md` to make 3700 active.

### EDM adaptive-feed result

Pinned LinuxCNC source shows M52/adaptive-feed as a native EDM-relevant motion primitive. Realtime Motion samples `motion.adaptive-feed`, clips it to `+-MAX_FEED_OVERRIDE`, uses magnitude as feed scaling and sign as TP direction request. When sign changes while motion is active, the effective adaptive scale is forced to zero until TP can stop and change direction.

Thus negative adaptive feed is an explicit controlled path-direction transition, not a naive negative velocity multiplier.

### Reverse-path synchronized-output result

Reverse segment completion uses `tcqBackStep()` through retained trajectory segments. Synchronized M62/M63/M67 changes are stored on TC segments as commanded values. No reverse-specific output inversion/rollback path was found.

Therefore **reverse path != process-state rollback**. A wire/sinker EDM controller must explicitly own spark, wire and dielectric/flushing state instead of assuming path rewind reconstructs output chronology. Abort clears pending cached synchronized outputs and resets TP reverse/queue state after stopping, but it does not establish physical EDM process-state reconciliation.

The generic reverse/DIO lab was not run because source already resolves the architectural question.

## Next work

Continue 3700-E2 with real wire-EDM process authority: gap-voltage conditioning/freshness, forward/slow/hold/reverse law, spark generator state, wire run/tension/break, dielectric/flushing readiness, U/V taper authority, and pause/abort/restart recovery. Then inspect adjacent OpenEDM subsystem architecture and rotate within 3700 to materially different real grinder implementations when the EDM source path reaches a local stop.

## Laboratory state

No lab was run. `LAB_COMPUTE_LOG.md` remains unchanged at the preserved exactly recorded total of **338.56 minutes (5.64 h)**; historical gaps mean that is not a trustworthy full-project total.

## Overlap

**No overlap.** Previous canonical session ended `2026-09-14T20:50:54Z`; this session began `2026-09-14T21:36:26Z`, **45m32s later**.
