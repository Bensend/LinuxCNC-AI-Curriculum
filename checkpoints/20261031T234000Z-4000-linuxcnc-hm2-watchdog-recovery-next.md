# 2026-10-31 23:40Z — HostMot2 watchdog recovery/forced-write acknowledgment checkpoint

**Active:** LinuxCNC-first 4000 implementation, NON-GRADUATED. Previous: [22:42Z Ethernet receive checkpoint](20261031T224200Z-4000-linuxcnc-hm2-ethernet-packet-next.md). Governance entry, source policy, current progress/lesson/compute/evaluation read. 1000/2000/F02/3000 remain CLOSED, evaluator separation and physical OpenPressBrake G0/G1 HOLD unchanged.

## New source-grounded findings
- [WD-84 soft recovery and ack](../research/4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md): below-threshold Ethernet read loss sets `needs_soft_reset`; `hm2_read` skips TRAM consumers, next `hm2_write` can force-replay configuration. Both stable v2.9.10 and pinned development ignore forced-flush failure, so clearing recovery flags does **not** establish FPGA acceptance. SOURCE-CONFIRMED conditional; physical outcome UNKNOWN.
- [WD-85 capacity/version](../research/4400_LINUXCNC_HM2_WD_85_FORCE_ENQUEUE_1400_BYTE_CAPACITY_VERSION_AUDIT_2026-10-31.md): both use 1400-byte write buffer; stable enqueue lacks bounds, development checks per write and trailer but forced-replay caller ignores failure. No observed overflow or drop.
- [12-case disconnected guide](../guides/4000-linuxcnc-hm2-watchdog-soft-recovery-verification-2026-10-31.md): W1–W8/B1–B4 all NOT RUN. Real MR-1 7i96S public HAL/INI: 5-ms watchdog, 1-ms servo, `read -> motion/PID -> write`. Timing is illustrative, not a measured margin.

## Exact next work
1. If independent physical isolation and `[self-hosted, openpressbrake]` qualification are positively established, freeze W2–W4 and B2–B4 and run software-only LLIO stub tests. Retain source revisions, expected outputs, compiler logs, raw call traces, packet bytes and independent verdicts. Do **not** run any hosted Actions, attach to real Mesa, or modify safety hardware.
2. If qualified compute remains unknown, rotate to a **distinct** LinuxCNC implementation topic (e.g. interpreter/Task tool change, EtherCAT actual CiA402 PDO configuration, ROS 2 status-bridge source contracts, or real 3000-series machine configuration). Do not add more unexecuted HM2 Ethernet cases.
3. For potential upstream maintenance, distinguish memory bounds, transport send result, device acknowledgment, and recovery bookkeeping; propose no patch until source-specific test and maintainer discussion.
4. Preserve existing QtPlasmaC/CAM and HM2-ETH test debt, blind evaluator separation, and independent personnel safety authority.

**Evidence:** SOURCE/DOC-CONFIRMED conditional, no TEST-CONFIRMED. No build, simulation, network injection, hardware, evaluator or Actions. Hosted/self-hosted 0/0 min; LAB_COMPUTE_LOG/FEEDBACK_SCORE_LOG unchanged. Hourly task remains enabled.

## Same-session second distinct LinuxCNC topic: MTConnect / ROS 2 read-only telemetry
- [TELEM-86 pinned development source audit](../research/4400_LINUXCNC_TELEM_86_MTCONNECT_ACTUAL_SPINDLE_AND_POLL_FRESHNESS_SOURCE_AUDIT_2026-10-31.md): MTConnect `ROTARY_VELOCITY ACTUAL` derives from NML spindle speed × override, not a tachometer; Python G96 status speed can represent max RPM. `_live` checks poll success but not heartbeat progression; agent timestamps poll, not FPGA acquisition; only spindle 0 is sampled. Development-only inspected path, no stable v2.9.10 equivalent. SOURCE-CONFIRMED, no runtime.
- [Read-only bridge provenance walkthrough](../guides/4000-linuxcnc-ros2-mtconnect-status-provenance-review-2026-10-31.md): separate measured RPM (UNAVAILABLE absent sensor), status speed, heartbeat age and bridge timestamp; R1–R6 all NOT RUN. No ROS product build.
- **Next unblocked source task if no compute:** inspect actual upstream MTConnect model/agent consumers and test `ACTUAL` semantics with a fake stat in an isolated software fixture, or rotate to distinct LinuxCNC machine-specific work. Do not let unexecuted integration examples become claimed telemetry accuracy.

- [Unexecuted Python reference fixture](../examples/4000_linuxcnc_mtconnect_spindle_semantics_reference.py): five deterministic `unittest` cases, no LinuxCNC/ROS dependency, no execution or physical evidence. If isolated runner becomes available, compare its frozen expected results to actual pinned upstream source before claiming behavioral evidence.
