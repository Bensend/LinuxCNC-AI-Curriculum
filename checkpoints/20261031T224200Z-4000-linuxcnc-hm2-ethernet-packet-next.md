# 2026-10-31 22:42Z — HostMot2 Ethernet queued packet and direct-read handoff

**Active:** LinuxCNC-first 4000 implementation, NON-GRADUATED. **Start:** 2026-10-31T22:39:35Z. **Prior:** [2026-10-31 21:42Z CAM/plasma checkpoint](20261031T214200Z-4000-linuxcnc-nesting-cam-next.md). Governance START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, BLIND_FEEDBACK_PROTOCOL, FEEDBACK_SCORE_LOG and LAB_COMPUTE_LOG inspected. Graduated 1000/2000/F02/3000 CLOSED, evaluator separation and physical G0/G1 HOLD unchanged.

## New evidence, no tests

- [ETH-82 queued read] (../research/4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md): stable v2.9.10/development HostMot2 Ethernet receive copies data **before** read-sequence check; wrong sequence at/after deadline skips retry, final verdict checks write count only; a matching write count can return success and clear packet-error despite stale read sequence. Under-limit write mismatch also permits TRAM processing. SOURCE-CONFIRMED conditional, runtime UNKNOWN.
- [ETH-83 direct LLIO read](../research/4400_LINUXCNC_HM2_ETH_83_DIRECT_READ_SHORT_REPLY_AND_DIAGNOSTIC_SOURCE_AUDIT_2026-10-31.md): both versions accept `recv >= 0` rather than exact `recv == size`, copy requested length from partially initialized temporary buffer, and return success. POSIX transport preserves actual short-datagram length. SOURCE-CONFIRMED conditional; frequency/callers/runtime UNKNOWN.
- [14-case acceptance guide](../guides/4000-linuxcnc-hm2-ethernet-packet-freshness-disconnected-acceptance-2026-10-31.md): Q1–Q9, D1–D5, all NOT RUN.
- Real public [MR-1 7i96S HAL](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal) inspected; `hm2.read -> motion/PID -> hm2.write`, 10.10.10.10. Existing HAL-20 covers ordering; this session adds network **freshness**, not a new physical deployment claim.

## Next highest-value work

1. If **independently established physically isolated** `[self-hosted, openpressbrake]` runner is available, review exact allowed fixture and execute a bounded **software-only** receive-decision harness. Freeze expected Q2–Q6 and D2–D4 before results; capture full raw evidence. Do not use hosted Actions, dispatch unknown runner, connect to Mesa or actuators, or edit old workflow trigger paths.
2. If isolation remains unknown, investigate a **different** LinuxCNC internals question with new evidence (e.g. realtime latency/servo scheduling and Mesa watchdog reset recovery, real 7i96S machine diagnostics, or interpreter/Task state) rather than add more unrun Ethernet cases.
3. Upstream review-only fix ideas: validate read sequence before TRAM copy and unconditionally reject stale sequence even at deadline; require exact length for direct reads. Do not submit or claim a fix until compiled regressions and failure-policy review.
4. Preserve old CAM-77–81 QtPlasmaC/Deepnest acceptance debt; do not manufacture another postprocessor build.

**Evidence:** SOURCE-CONFIRMED selected branches and docs, conditional INFERENCE only; TEST-CONFIRMED none. No Actions, builds, simulations, packet injection, physical operations, evaluator or authoritative job runtime; hosted/self-hosted 0/0 min. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Hourly curriculum stays enabled.
