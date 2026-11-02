# 2026-11-02 ~00:42Z — LinuxCNC inhibit/override bitmask next checkpoint

> **SUPERSEDED 2026-11-02:** INHIBIT-141 duplicates earlier OVERRIDE-93/94/95. Continue from [THREAD-142 checkpoint](20261102T0137Z-4000-linuxcnc-thread-override-next.md); do not dispatch duplicate O93/O94/O95 tests.

**LINUXCNC FIRST | 4000-LC-INHIBIT-141 | 3100/3200/3400 transfer | NON-GRADUATED.** [Source audit](../research/4400_LINUXCNC_INHIBIT_141_FEED_SPINDLE_INHIBIT_SS_OVERRIDE_BITMASK_SOURCE_AUDIT_2026-11-02.md), [disconnected guide](../guides/3100-3200-3400-4000-linuxcnc-feed-spindle-inhibit-override-commissioning-2026-11-02.md), [A](../examples/4000_inhibit_141/inhibit_m51_enabled.ngc) and [B](../examples/4000_inhibit_141/inhibit_m51_disabled.ngc) fixtures.

## Established this session

- Stable v2.9.10 and development `06864e` use `enables & inhibit_bit` for **both** `motion.feed-inhibit` and `spindle.N.inhibit`; TRUE HAL bit is 1 and SS_ENABLED is 0x01. M51 P0 clears SS_ENABLED, so the inhibit condition becomes false on newly queued ordinary segments even when the pin is TRUE. This is **SOURCE-CONFIRMED bitwise semantics**, not a runtime demonstration or proof of physical motion.
- M49 similarly clears spindle override. Source-derived A/B truth table and published QtDragon simulated spindle-pause wiring are included; no claim of actual QtDragon machine failure.
- Predecessor check: earlier STEPGEN-97, HM2-GPIO-132, SPINDLE-100 and M66-140 are distinct; compute ledger contains no matching prior test. **No LinuxCNC build, HAL execution, simulation, physical machine, independent evaluator, or Actions compute this session.**

## Precise next checkpoint

1. First trace **G33/G33.1 and queued segment override-mask exception** plus multi-spindle `M51 $n` mapping before recommending a code change; do not replace mask test with unqualified `if (pin)`.
2. If positively qualified **physically disconnected** `[self-hosted, openpressbrake]` compute is available, freeze version/INI/HAL/fixtures/oracle and execute A–G. Capture source flags, pin values, commanded position, `net_feed_scale`, spindle requested speed, monotonic timestamps, actual job runtime, logs and exit codes. **Never dispatch GitHub-hosted Actions.** Distinguish source math from observed Task/motion execution.
3. If no qualified runner, rotate to a **distinct** LinuxCNC mechanism (e.g. EtherCAT distributed-clock PDO freshness or actual interpreter/toolchange path) rather than accumulating another unrun inhibit fixture.
4. Keep 1000/2000/F02/3000 GRADUATED/CLOSED, blind evaluator and personnel-safety authority separate, OpenPressBrake G0/G1 HOLD, hourly task enabled. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged unless new authoritative evidence arrives.
