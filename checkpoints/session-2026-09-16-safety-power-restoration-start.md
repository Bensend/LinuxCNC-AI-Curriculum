# Safety power-restoration session — 2026-09-16

- Session start UTC: `2026-09-16T22:35:00Z`
- Session end UTC: `2026-09-16T22:42:00Z`
- Actual elapsed: `7.0 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior durable safety checkpoint ended at 2026-09-16T21:36:30Z.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

- Added `safety-course/POWER_LOSS_RESTORATION_AND_UNEXPECTED_RESTART_2026-09-16.md`.
- Manufacturer evidence now explicitly separates cold-start behavior, restart behavior, safety reset, normal machine start and restored actuator authority.
- Rockwell GuardLogix DCST evidence exposes a dedicated Cold Start Type: manual cold start does not simply energize the safety output when controller power returns and inputs become valid; automatic cold start is a separate selectable behavior.
- Rockwell Guardmaster documentation constrains automatic reset to architectures where additional manual intervention is not required by the risk assessment or another start action exists downstream.
- Siemens STO evidence retained: STO prevents accidental torque production but does not electrically isolate the drive power unit/motor.

## Architecture freeze from this session

Do not collapse `mains available`, `safety supply healthy`, `safety initialized`, `protective devices valid`, `final elements proved`, `restart interlock reset`, `LinuxCNC/FPGA fresh`, `normal enable`, `operator start`, and `actuator authority` into one state. Restoration of an earlier state must not silently manufacture the later states.

OpenPressBrake normal-control recovery (LinuxCNC reboot, FPGA reboot, watchdog recovery, Ethernet reconnect, proportional-driver rearm) is not a personnel-safety reset and must not manufacture `safety_ready`.

## Exact next work

1. Apply the new four-case restoration trace (mains, safety 24 V, CNC power, communications) to a complete professional machine drawing.
2. Continue searching for a modern CNC press-brake electrical+hydraulic drawing pair that exposes pump contactor, safety controller and monitored hydraulic final elements together.
3. Study maintenance/bypass/keyed-mode architectures next: how professional machines permit setup/service without creating an easy permanent bypass path.
4. Preserve stored-energy analysis independently of electrical restart behavior.

## LESSON_LOG safe-append status

`LESSON_LOG.md` is known from the active safety checkpoint to exceed safe complete-fetch/write handling through the current connector. The available write is whole-file replacement, not atomic append, so it was not overwritten from incomplete content. Pending row:

`| 2026-09-16 | Safety course — power loss/restoration and unexpected restart | 2026-09-16T22:35:00Z | 2026-09-16T22:42:00Z | 7.0 | COLD-START/RESTART STATE MODEL INTEGRATED | Apply restoration trace to complete OEM machine + study service/bypass modes | No overlap; no compute. |`
