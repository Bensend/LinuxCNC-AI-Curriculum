# 2026-10-31T134130Z — LinuxCNC-first EtherCAT Sync Unit source continuation checkpoint

**Active 4000, NON-GRADUATED.** 1000/2000/F02/3000 CLOSED. Independent personnel-safety and evaluator gates unchanged; OpenPressBrake G0/G1 HOLD. Hourly curriculum enabled.

## New source work

1. [TP-48/49 checkpoint](2026-10-31T133744Z-4000-linuxcnc-motion-oracle-planner-defer-next.md) preserves development motion command acknowledgment and deferred jerk/planner queue results.
2. [ETHERCAT-50](../research/4400_LINUXCNC_ETHERCAT_50_SYNCUNIT_FRESHNESS_LATE_TX_DC_PHASE_SOURCE_AUDIT_2026-10-31.md) inspects maintained out-of-tree `linuxcnc-ethercat/linuxcnc-ethercat` commit `56515f4aac313551346289d9c227193f50e9602a` (2026-10-29): bus vs unit-thread vs DC scheduling, bounded RX seqlock/TX double buffer, `fresh` generation without WKC validation, callbacks on reused non-torn image, ten tolerated missed due sends and suppression on the eleventh, and `dc-phased`/slave DC monitor distinction. Example 8 kHz bus/2 kHz drive unit yields nominal 343.75 µs post-receive output-publication window with default offset. Source-only, no installed bus evidence.
3. [Practical acceptance guide](../guides/4000-linuxcnc-ethercat-syncunit-fresh-late-phase-review-2026-10-31.md) freezes EC1–EC7; upstream multirate generic PDO example is **not machine-ready**.

## Highest-value next

- With independently verified disconnected `[self-hosted, openpressbrake]` compute: run a bounded pure-software EC1–EC4 test for `lcec_syncunit.h` and optionally the earlier TP-48/49 realtime oracle only in a qualified LinuxCNC simulation; retain actual job timestamps. No hosted Actions fallback.
- Otherwise inspect a **real, pinned EtherCAT LinuxCNC HAL/INI/XML drive configuration** and compare its read/write order, SYNC0/phase, PDO mapping, CiA402 enable/fault handling and diagnostics to this source; or rotate to a distinct router/spindle implementation if evidence is sparse.
- Do not claim independent personnel safety from WKC, DC phase, stale/late counts, slave watchdog or HAL logic. No new graduation/evaluator action. Check current repository and any new evidence before next commit.

## Evidence / compute

Pinned out-of-tree EtherCAT commit `56515f4aac313551346289d9c227193f50e9602a`, LinuxCNC development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` for TP-48/49. SOURCE/DOC-CONFIRMED static, conditional inference, TEST-CONFIRMED none. No builds, simulations, physical operations, workflows or independent evaluation. Hosted/self-hosted Actions **0/0 minutes**; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.
