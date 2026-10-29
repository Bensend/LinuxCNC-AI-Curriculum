# 4400-REVERSE-DIO-01 — reversing a LinuxCNC trajectory does not automatically undo synchronized outputs

**2026-10-29 | pinned source composition | NON-GRADUATED / NOT RUN**

## Safety question and novelty check

A plasma/laser/wire-EDM machine uses ordinary LinuxCNC M62/M63 motion-synchronized output requests. Its process controller also enables M52 adaptive feed, which can request reverse trajectory. Does moving backward through a previously traversed segment automatically restore the earlier digital-output state in reverse order? **No such inverse-output contract is established by the inspected implementation.**

Closest predecessors: [LASER-02 M62–M65 scheduling/source audit](4400_LINUXCNC_PINNED_M62_M65_DIO_MOTION_QUEUE_VS_LASER_SAFETY_INHIBIT_SOURCE_TRACE_2026-10-25.md) already proves ordinary queued output scheduling, not safety isolation. [ADAPTIVE-REVERSE-01](4400_ADAPTIVE_REVERSE_01_LINUXCNC_2910_M52_NEGATIVE_FEED_DIRECTION_AND_HOLD_SCOPE_SOURCE_AUDIT_2026-10-29.md) proves negative M52 sign requests reverse trajectory and source gating. **New incremental mechanism:** the **one-shot consumption** of each trajectory segment's synchronized I/O does not encode an inverse action when the segment is traversed backward. This is cross-subsystem source composition, not another generic laser safety lesson or a new exam bank.

## Exact pinned LinuxCNC v2.9.10 source path

1. [`tpSetDout` lines 3620–3629](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3620-L3629) records a pending digital output as `+1` (ON) or `-1` (OFF), sets the output mask, and marks `tp->syncdio.anychanged=1`. This is a **commanded state**, not an independent optical/process-energy sensor.
2. [`tpSetupSyncedIO` lines 1547–1557](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L1547-L1557) copies the pending output command to a trajectory segment's `tc->syncdio` and clears the planner's pending copy.
3. [`tpToggleDIOs` lines 2491–2506](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2491-L2506) writes the stored ON/OFF values when `tc->syncdio.anychanged` is set and then **sets that segment's `anychanged=0`**. It does not test `tp->reverse_run` or synthesize the opposite value on reverse traversal. **SOURCE-CONFIRMED one-shot output behavior.**
4. [Split-cycle handling lines 3336–3345](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3336-L3345) and [3411–3420](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3411-L3420) use `queue_dir_step = reverse_run ? -1 : 1`; [`tp.c` lines 2746–2754](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2746-L2754) backs up the queue in reverse completion. [`tpHandleRegularCycle` lines 3382–3387](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3382-L3387) still calls the same `tpToggleDIOs` for a segment; no inverse-output function is visible in the inspected path.
5. [`control.c` lines 380–408](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L380-L408) can request reverse from negative M52, while [Task reverse/forward dispatch](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2333-L2343) is an **independent normal-control path** to the same planner direction. The conclusion is not restricted to an M52-origin reverse request.

All `tp.c` evidence is pinned to blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, LinuxCNC v2.9.10 commit `86cdca76fa2a36274c432caa21952b23c267989a`.

## Adversarial timeline — reasoning only

Assume a forward program segment has already executed an M62 output-ON event. Its `tc->syncdio.anychanged` is now zero. Later a separate forward segment executes an M63 output-OFF event; its flag is also consumed. If normal control reverses through these **already consumed** segments, the inspected toggle routine has no automatic action that replays ON or OFF in reverse order. The process output may remain at its last commanded state unless another explicit command/path changes it.

If a segment had **not** consumed its synchronized output yet, the routine writes its stored value when invoked, regardless of reverse direction; it does not invert ON to OFF. The exact segment queue, blending, early termination, Task timing, and physical process-output sequence are **UNKNOWN** without a bounded, isolated execution witness. Do not claim a universal laser-on-backtrack behavior or a measured incident.

## Practical safety architecture and human factors

A builder must not assume reversing an ordinary toolpath also reverses laser/torch/valve state changes, or that a G-code M63 is a personnel-safe beam-off. Explicitly design **normal process-output state management** for pause, reverse, abort, program end and restart, with a clear operator indication of output request and physical-process feedback where available. Avoid workflows that encourage users to bypass a guard to inspect a confusing reverse move. For exposed-person protection, allocate an **independent** safety-rated guard/interlock and physical hazardous-energy isolation/containment, with qualified validation. Neither M52, M62/M63, `motion.tp-reverse`, nor ordinary HAL output state is personnel-safety authority.

## Evidence, scope and lab decision

**SOURCE-CONFIRMED:** tagged one-shot synchronized I/O flag consumption, queue direction selection and ordinary reverse command paths. **DOC-CONFIRMED:** official M52 reverse semantics and M62/M63 scheduling from existing predecessor. **INFERENCE:** illustrative output state during reverse traversal and possible human error. **UNKNOWN:** selected machine program, queue history, process final element, actual optical/plasma energy, physical stop/guard, runtime execution. **TEST-CONFIRMED none; COMMUNITY-REPORTED none.** No live laser, plasma, machine or lab run. A future isolated test is justified only if a concrete remaining queue-order question matters to an actual design and verified disconnected `[self-hosted, openpressbrake]` compute access exists. **G0/G1 HOLD; independent 2520–25F0 evaluator OPEN.**

## Queue-history confirmation

The original [`tcqBackStep` implementation, `src/emc/tp/tcq.c` lines 237–255](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tcq.c#L237-L255), simply moves the queue start pointer backward and updates length counters; it does **not** reset a trajectory segment's `syncdio.anychanged` or construct inverse output events. Pinned queue source blob `ce2a711c9e393a4dd75de9992e313189f334f2d1`. Together with `tpToggleDIOs` consuming the segment flag, this strengthens the **SOURCE-CONFIRMED one-shot/no-automatic-inverse** conclusion. It still does not establish the physical output sequence for any unrun machine or every possible new segment insertion.
