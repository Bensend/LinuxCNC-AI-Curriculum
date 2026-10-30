# 2026-10-30T23:33:10Z — LinuxCNC-first KINS-10 and HM2-ETH-11 continuation

**NON-GRADUATED; static SOURCE-CONFIRMED/DOC-CONFIRMED; no runtime.** UTC start [witness](2026-10-30T233310Z-session-start-linuxcnc.md).

## Governance and state
START_HERE, mission, level/work-selection, curriculum, source/template policy, PROGRESS, blind protocol/score, compute ledger, and predecessor 22:35Z checkpoint read. 1000/2000/F02/3000 GRADUATED/CLOSED; 4000 LinuxCNC internals primary. Safety course preserved but not routine queue. G0/G1 HOLD, independent evaluator OPEN, no sealed answers accessed.

## This session's durable work
1. [KINS-10](../research/4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md): pinned development failed-forward kinematics switch follows sequence echo, actual-type rollback, error status, Task sequence-only DONE and outer-loop abort/resync; `#<_kins_type>` before/after sync distinguished. Stable v2.9.10 has HAL-only selection and unchecked forward return. [Diagnostic card](../guides/4000-linuxcnc-switchkins-status-vs-acknowledgement-2026-10-30.md).
2. [HM2-ETH-11](../research/4400_LINUXCNC_HM2_ETH_11_SPLIT_READ_PACKET_LOSS_STALE_FEEDBACK_SOURCE_AUDIT_2026-10-30.md): rotated to nonduplicate HostMot2 Ethernet read-request/read/write transport. Temporary `-EAGAIN` skips HAL feedback update; Ethernet packet error counter latches after threshold. A full-length mismatched-read-count packet arriving at/after deadline can pass the read-count retry check and, with matching write count, reach success in both pinned stable and development source. This is a **conditional code path, not runtime-proven stale data**. Official docs acknowledge packet-loss stale feedback and encoder-index caveats. No physical/safety inference.

## Next unblocked highest-value work
- **Preferred:** finish a source-only review of `hm2_eth` read/write-count layout, counter wrap and protocol acceptance (including maintainer history) before considering an upstream issue or a bounded no-hardware packet-injection oracle. The exact branch predicate is already known; do not run a lab merely to reproduce it.
- **Alternative:** trace LinuxCNC EtherCAT realtime/HAL cycle integration and compare its input/output freshness contract to HostMot2, using an inspectable real configuration; or resume TWP error behavior only if new source/test evidence appears.
- Preserve practical CAM/DXF integration, but do not manufacture more 3000 work. No new safety-course competency or release claim.

## Compute/verification
No Actions workflow, self-hosted/hosted compute, build, simulation, machine operation, evaluator or authoritative runtime. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged. Runner dispatch and physical isolation UNKNOWN; only `[self-hosted, openpressbrake]` permitted if a frozen justified experiment is eventually possible. Existing safety gates remain HOLD; recurring curriculum remains enabled.
