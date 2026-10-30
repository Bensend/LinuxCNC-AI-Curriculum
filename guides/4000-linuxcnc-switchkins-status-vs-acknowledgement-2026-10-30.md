# 4000 — LinuxCNC kinematics-switch status and failure review card

**Scope:** development `24e84c4506b41634240f7087f0295e361a954886`, ordinary CNC control only; **not** a personnel-safety function. Source-grounded; not machine-tested.

## A five-signal distinction

| Observation | What it establishes | What it does **not** establish |
| --- | --- | --- |
| G12.1 Pn parsed | Interpreter accepted requested type (when supported) | Motion has activated type n |
| `traj.switchkins_seq` advanced | Realtime acknowledged handling a request | Forward kinematics succeeded |
| `traj.switchkins_changed` true | Task interface detected new sequence | No error or successful switch |
| `traj.switchkins_type == n` | Realtime reports active type n | Safe pose or collision clearance |
| `motion.status`, `task.status`, operator errors | Fault/abort visibility in normal control | Certified safety function or physical stop |

**Diagnostic ordering:** record exact version → requested type → sequence → active type → error status → Task abort/resync → actual motion/limits (only in an appropriately isolated, authorized commissioning environment). Do not stop at a changed sequence counter.

## Source exercise: expected failure pair

Assume a supported type n is requested, but `kinematicsForward` returns nonzero at the current joint positions. Before any test, predict:

1. Does the sequence advance? **Yes**, copied before the forward call.
2. Is the requested type retained? **No**, development attempts `kinematicsSwitch(old)` and retains the prior `switchkins_type`.
3. Can `switchkins_changed` coexist with `motion.status=ERROR`? **Yes**, source supports both in the same refreshed status.
4. Does `WAITING_FOR_KINS_SWITCH` inspect `motion.status`? **No**; it consumes the sequence and invokes interpreter sync.
5. Does Task's outer loop ignore the fault? **No**; its subsequent subordinate-error check aborts the program and queues a sync in the ordinary non-soft-limit case.
6. Can you state the exact microseconds from error to GUI update? **No**; no runtime evidence or fixed scheduling measurement was collected.

## Version trap

Stable v2.9.10 switches from the HAL pin, lacks the G12.1/Task wait, sets global type before calling the module, and does not check the forward return. **Do not generalize development's rollback semantics backward.**

## Follow-up if a real bug is reported

Capture source revision, INI/kinematics module identity, G-code and HAL request path, motion status fields, error text, and an isolated reproduction. Separate source-confirmed code paths from actual measured behavior. Never make ordinary LinuxCNC, HAL, Mesa or an FPGA the sole personnel-protection authority.

See [full KINS-10 audit](../research/4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md) and [KINS-09 predecessor](../research/4400_LINUXCNC_KINS_09_G121_G131_INTERP_TASK_MOTION_SYNCHRONIZATION_SOURCE_AUDIT_2026-10-30.md).
