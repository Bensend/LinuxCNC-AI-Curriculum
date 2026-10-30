# 2026-10-30T23:33:10Z — 4000 LinuxCNC kinematics-switch failure/status continuation

**NON-GRADUATED; source-only; UTC start witness:** [23:33:10.190Z](2026-10-30T233310Z-session-start-linuxcnc.md).

## Current-state and work selection
START_HERE first; mandatory mission, level/work-selection, curriculum, source/template policy, progress, blind protocol/score, lab compute ledger and latest 22:35Z checkpoint inspected. 1000/2000/F02/3000 remain GRADUATED/CLOSED; owner priority LinuxCNC internals, not safety-course expansion. No sealed answers accessed. No new external evaluator evidence; independent 2520–25F0 remains OPEN. OpenPressBrake G0/G1 remains HOLD.

## Durable result
- [KINS-10 pinned failure-path audit](../research/4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md) traces development `24e84c4506b41634240f7087f0295e361a954886` from G12.1 optimistic interpreter setting through realtime sequence echo **before** switch, rollback on failed forward, status's distinct sequence/type/error fields, Task's sequence-only `WAITING_FOR_KINS_SWITCH` DONE, and main-loop motion-error abort/resync. The Task executor runs before its motion-status refresh; exact race timing remains UNKNOWN. `#<_kins_type>` reads interpreter state until `interp.synch()` refreshes it from motion's actual type.
- [Version comparison](../research/4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md#stable-v2910-is-materially-different): v2.9.10 uses HAL pin, has no G12.1/Task wait, assigns global type before module switch, and ignores `kinematicsForward` return. No runtime or physical claims.
- [Practical source exercise/diagnostic card](../guides/4000-linuxcnc-switchkins-status-vs-acknowledgement-2026-10-30.md) distinguishes request, acknowledgement, active type, fault and physical validation.

## Next highest-value work
1. **Preferred new LinuxCNC branch:** inspect source-grounded HostMot2/Mesa servo-thread read/write and motion-command/feedback freshness across HAL ordering, or a real EtherCAT HAL cycle implementation. Check predecessors before creating another audit. Freeze a bounded local experiment only if source/docs cannot answer a consequential timing question.
2. **If KINS-10 remains consequential:** inspect `interp.synch()` error behavior and source tests; a controlled isolated failure harness would need explicit oracle and proof of no physical outputs. Avoid repeated source-only restatement.
3. Continue practical CAD/CAM and machine configurations only where new evidence is available. Do not reopen graduated levels.

## Evidence/compute
SOURCE-CONFIRMED/DOC-CONFIRMED, TEST-CONFIRMED none. No workflow, simulation, build, machine operation, upstream submission, evaluator or new authoritative compute runtime. Zero hosted/self-hosted Actions minutes; `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged. Self-hosted `[self-hosted, openpressbrake]` runner dispatch/physical isolation UNKNOWN; no hosted fallback. Safety release remains independent and HOLD. Keep hourly curriculum enabled.
