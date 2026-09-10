# X02 — `motion_type` cross-surface witness trace

Session source revision: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

## Purpose

X02 needs one software-only value that is observable both in the realtime/HAL surface and through Task/NML/Python, without pretending wall-clock proximity proves simultaneity. `motion_type` is suitable because the same motion-status field is deliberately copied to both surfaces.

## Source trace

1. **Realtime producer / trajectory state — SOURCE-CONFIRMED.** In `src/emc/motion/control.c`, motion status is refreshed from the trajectory planner with `emcmotStatus->motionType = tpGetMotionType(&emcmotInternal->coord_tp)`. The value therefore belongs to the realtime motion-status generation, not to Python or Task.
2. **HAL publication — SOURCE-CONFIRMED.** `src/emc/motion/motion.c` exports `motion.motion-type` as an `s32` HAL output backed by `emcmot_hal_data->motion_type`. In the realtime status-output path in `control.c`, LinuxCNC executes `hal_set_si32(emcmot_hal_data->motion_type, emcmotStatus->motionType)`. Thus HAL `motion.motion-type` and the shared motion-status field have a direct same-source relationship at this revision.
3. **Task-side motion status — SOURCE-CONFIRMED.** `src/emc/task/taskintf.cc::emcMotionUpdate()` copies `emcmotStatus.motionType` to the Task/NML trajectory status field as `stat->motion_type`. This occurs only after Task obtains a coherent motion shared-memory snapshot; it is not a direct realtime read by Python.
4. **Python exposure — SOURCE-CONFIRMED.** `src/emc/usr_intf/axis/extensions/emcmodule.cc` exposes Python `linuxcnc.stat().motion_type` from `status.motion.traj.motion_type`. The Python status object is updated by `stat.poll()` from the RCS/NML status channel as traced in `call-flows/X02-multi-surface-status-publication.md`.
5. **Independent Task generation witness — SOURCE/DOC-CONFIRMED.** `taskbeat` is copied from Task's own main-loop heartbeat into Task status and is exposed separately to Python. It is not the motion heartbeat and must not be used as if the two counters were one clock.

## Consequence for X02-001

A Python observation `(observer_monotonic_time, taskbeat, motion_heartbeat, motion_type)` can be compared to an X01-valid realtime recording containing deterministic recorder-cycle/health witnesses and HAL `motion.motion-type`. The comparison must be generation-based:

- equal `taskbeat` across repeated Python polls means no evidence of a newer Task generation merely because observer time advanced;
- a newer `taskbeat` may legitimately carry the same motion heartbeat and same `motion_type`;
- a slower Python observer may skip motion generations;
- HAL `motion.motion-type` is realtime publication of `emcmotStatus->motionType`, while Python `motion_type` is a later Task/NML publication of that state; nearest timestamps do not prove same-cycle identity;
- any realtime recorder overrun/payload discontinuity/truncation makes that interval unusable for exact correlation, per X01.

## Fixture suitability and limitation

`motion_type` is a good cross-surface state witness but not a unique generation identifier: it can remain unchanged for many motion cycles. X02-001 must therefore pair it with motion heartbeat/taskbeat and the deterministic realtime recorder witness. The experiment must never infer freshness from `motion_type` equality alone.

## Evidence classification

- Realtime trajectory planner -> `emcmotStatus->motionType`: **SOURCE-CONFIRMED**.
- `emcmotStatus->motionType` -> HAL `motion.motion-type`: **SOURCE-CONFIRMED**.
- `emcmotStatus.motionType` -> Task trajectory `motion_type`: **SOURCE-CONFIRMED**.
- Task/NML trajectory `motion_type` -> Python `stat.motion_type`: **SOURCE-CONFIRMED**.
- Cross-surface same-cycle correspondence based only on timestamp proximity: **REJECTED INFERENCE**.

## Next experiment design checkpoint

Freeze X02-001 around this witness. Use a deterministic software-only motion sequence that creates at least two known `motion_type` transitions, record HAL `motion.motion-type` with an X01-valid recorder, and poll Python at deliberately varied rates. Predeclare gates for repeated same-Task-generation polls, Task advance with unchanged motion generation/state, skipped motion generations under slow polling, transition ordering, and invalid recorder intervals. Do not score nearest-wall-clock matching as simultaneity evidence.
