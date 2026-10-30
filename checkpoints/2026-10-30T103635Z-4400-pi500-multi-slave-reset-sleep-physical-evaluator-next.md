# 2026-10-30T10:36:35.671Z — 4400 PI500-MULTI-03 shared Modbus process cross-slave reset sleep
**NON-GRADUATED | SOURCE-ONLY | NO MACHINE RELEASE**

## Recovery
UTC start captured at 2026-10-30T10:36:35.671Z before substantive work, immediately after reading START_HERE. Required governance, blind-feedback score/protocol, lab-compute ledger, 09:39Z thermal-relief checkpoint, safety course entry/index/research, selected Stage A A–G board, PI500-VFD-01, PI500-OEM-COMM-02, VFD-EXIT and RST-01 predecessors inspected. 1000/2000/F02/completed 3000 CLOSED; 4400 safety active. Qualified public Stage A A–G status unestablished, restricted evidence receipt UNKNOWN, independent 2520–25F0 evaluator OPEN/NOT RUN.

## New evidence and novelty
[PI500-MULTI-03 pinned-source/generator audit](../research/4400_PI500_MULTI_03_HALCOMPILE_SINGLE_THREAD_RESET_SLEEP_PEER_STARVATION_SOURCE_AUDIT_2026-10-30.md) traces LinuxCNC `pi500_vfd.comp` blob `92cc57bdf5214bbb3fb92103837539e42a76d452` and `halcompile.g` blob `a610bba80794cc33b5fc524fb80e094fa2900a76` at commit `e1c6a557c0e1c61961f17ee35a1ba188e7db275f`. One generated userspace `user_mainloop` sequentially traverses all instances. A zero slave address or automatic fault reset causes `sleep(1)` within the shared loop, delaying peers; reset sleep occurs even on write failure and may repeat while an alarm remains. Stable v2.9.10 PI500 blob `b77f6e0241d3bf9db44edd97ddbb229af184dd18` corroborates. This **cross-instance fault propagation** is distinct from prior PI500 missing trip/heartbeat findings. Source control flow confirmed; actual multi-drive installation, timing, VFD behavior and physical safety UNKNOWN. No new scored competency or fabricated latency.

## Durable integration
New research plus existing [upstream maintainer packet](../safety-course/4400_PI500_UPSTREAM_MAINTAINER_REVIEW_PACKET_2026-10-30.md), [index](../safety-course/SAFETY_COURSE_INDEX.md), [research plan](../SAFETY_COURSE_RESEARCH.md), [curriculum](../CURRICULUM.md), [progress](../PROGRESS.md). Existing original source conclusions preserved. No upstream issue or patch submitted.

## Compute, authority, and hold
Zero GitHub-hosted and zero self-hosted compute; no workflow dispatch, simulation, build, synthesis, benchmark, test, machine operation, or independent evaluation. No new authoritative runtime: LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Local runner dispatch and panel-PC physical isolation unverified. Ordinary LinuxCNC/FPGA/Modbus remains normal control and diagnostics; independent safety controller and physical final elements must own protective stop/hold/isolation. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.**

## Precise next work
1. Check for qualified **redacted** Stage A A–G machine evidence and information-separated independent 2520–25F0 evaluator result first. Never infer private receipt or self-score public scenarios.
2. Upstream PI500 maintainer review remains OPEN: decide exact supported OEM/firmware, `enable` and reset semantics, shared-bus quiet requirement after reset, peer scheduling/freshness, no-RUN-when-disabled and deliberate fresh normal start. A source-only patch proposal is not a safety rating. Do not assume per-slave cooldown is safe until OEM bus requirements are known.
3. If source-review information gain stops, rotate to another genuinely novel 4400 safety question after full index/research/progress/predecessor synonym audit; do not manufacture 3000 work or duplicate scored paper cases.
4. For any justified frozen compute question, only use [self-hosted, openpressbrake] after independently proving physical isolation; no hosted fallback. Append full LESSON_LOG with actual UTC end and overlap using current blob SHA immediately before end.
