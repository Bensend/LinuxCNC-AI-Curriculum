# 2026-10-31T00:36:29Z — LinuxCNC EtherCAT WKC and HostMot2 Ethernet timing continuation

**NON-GRADUATED | source/community only | UTC start witness:** [session start](2026-10-31T003629Z-session-start-linuxcnc.md).

## State and precedence
START_HERE and required mission, level order, LinuxCNC-first work selection, curriculum, source/template policy, PROGRESS, blind protocol/score, compute ledger, predecessor 2026-10-30T23:33:10Z checkpoint and relevant audits recovered. 1000/2000/F02/3000 CLOSED. Safety remains cross-cutting, OpenPressBrake G0/G1 HOLD, independent evaluator OPEN. No sealed answers accessed.

## New work
- [ECAT-13](../research/4400_LINUXCNC_ETHERCAT_13_WKC_FRESHNESS_CROSS_THREAD_SOURCE_AUDIT_2026-10-31.md): pinned EtherCAT bus publishes threaded image **before** sampling/updating WKC; `fresh` generation and WKC are not atomically paired. Master WKC includes prior state of unscheduled slow domains; `sync_units_started` latches after first OP and does not reset on OP loss in inspected code.
- [HM2-ETH-14](../research/4400_LINUXCNC_HM2_ETH_14_PPOLL_IRQ_TIMEOUT_COUNTER_SOURCE_AUDIT_2026-10-31.md): pinned v2.9.10 polling vs development POSIX `ppoll`, source-level 80%-of-period timeout, packet counter fields, conditional deadline read-count fall-through. Upstream issue #4525 adds real-machine **community-reported** timing/affinity evidence but does **not** validate the read-count corner case.
- [Diagnostic exercise](../guides/4000-linuxcnc-ethercat-hm2-stale-feedback-diagnostic-2026-10-31.md): separate input freshness, transaction integrity, realtime scheduling, physical state and independent safety.

## Next highest-value LinuxCNC work
1. Prefer an **inspectable** LinuxCNC HAL+INI EtherCAT or HostMot2 machine config showing actual feedback consumer and diagnostics; compare whether it records `fresh`/WKC and error/fault paths. Do not claim example XML is deployed.
2. If source evidence still leaves a material question, inspect upstream HostMot2 counter-protocol maintainer history; freeze a no-hardware replay only if it can discriminate an unresolved production-relevant condition and self-hosted runner dispatch + physical I/O isolation are confirmed.
3. Otherwise rotate to core LinuxCNC motion/trajectory, probing or interpreter source rather than repeat networking audits.

## Compute, evaluations, release
Zero GitHub-hosted/self-hosted Actions minutes; no workflow, build, simulation, test suite, physical operation or new authoritative runtime. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Local runner access/isolation UNKNOWN. No graduation/evaluator/release claims. Recurring curriculum remains enabled.
