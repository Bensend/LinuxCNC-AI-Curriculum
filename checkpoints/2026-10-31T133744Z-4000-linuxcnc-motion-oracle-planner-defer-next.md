# 2026-10-31T133744Z — LinuxCNC motion command/status oracle and deferred jerk/planner checkpoint

**Active:** 4000 LinuxCNC-first implementation, NON-GRADUATED. 1000/2000/F02/3000 remain CLOSED; safety-course and independent evaluator unchanged; OpenPressBrake G0/G1 HOLD. No qualified isolated runner or hardware-independent runtime evidence established.

## New source-grounded results

1. [TP-48](../research/4400_LINUXCNC_TP_48_COMMAND_ACK_EFFECTIVE_STATUS_ORACLE_SOURCE_AUDIT_2026-10-31.md) proves the realtime planner handler can report an operator error for type1/jerk<1 or defer a busy-queue request **while leaving commandStatus OK**; Task `usrmotWriteEmcmotCommand` checks echoed status, not effective activation. Ordinary NML `EMC_TRAJ_STAT` omits active planner and pending state; axis NML omits private normal/external velocity ceilings. The upstream motion-logger always acknowledges OK, logs requested type only, and omits external-offset velocity in its axis-limit line.
2. [TP-49](../research/4400_LINUXCNC_TP_49_DEFERRED_JERK_FALLBACK_QUEUED_SEGMENT_SOURCE_AUDIT_2026-10-31.md) traces a new queue-busy case: active type1, jerk2; jerk falls to .5 while busy and queues type0; jerk recovers to2 **before idle** without a type1 reissue; type0 applies at idle after recovery. Selector type1 during the busy interval does not guarantee per-segment S-curve: TP has a jerk<1 fallback. Other planner requests can cancel pending switches.
3. [Practical acceptance guide](../guides/4000-linuxcnc-motion-status-oracle-and-planner-queue-acceptance-2026-10-31.md) freezes O1–O4/Q1–Q5 and proposes a **test-only** realtime oracle contract. NOT RUN.

## Next highest-value unblocked work

1. **Only if physically isolated `[self-hosted, openpressbrake]` compute is independently qualified:** run bounded O1/O2/Q1/Q3 and axis split O3 in a disposable LinuxCNC simulation, with test-only realtime status/pending/limit instrumentation. No hosted fallback, no live hardware, record actual job runtime and retain full raw evidence.
2. **If source-only:** investigate another *distinct* LinuxCNC implementation gap rather than endlessly re-documenting the planner: EtherCAT distributed-clock/servo feedback timing, router spindle/tool-change, or Mesa HostMot2 FPGA register/firmware interface with pinned real configuration. Prioritize whichever has a reproducible source/config and an independently checkable diagnostic.
3. Verify any newly found result against earlier 3000/4000 progress and guides, read back committed files, check links, and append the actual lesson duration to `LESSON_LOG.md`. Do not touch safety-course evidence, evaluator seals, or G0/G1 release holds.

## Evidence / compute

Pinned LinuxCNC development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`; stable v2.9.10 contrast for axis-limit handler. SOURCE-CONFIRMED static, conditional runtime INFERENCE, TEST-CONFIRMED none. No builds, simulation, Actions dispatch, physical operation or independent evaluation; GitHub-hosted/self-hosted Actions **0/0 minutes**. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged. Existing hourly task stays enabled.
