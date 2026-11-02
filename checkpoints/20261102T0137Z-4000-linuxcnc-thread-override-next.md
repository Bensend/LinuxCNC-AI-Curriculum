# 2026-11-02 ~01:37Z — LinuxCNC THREAD-142 and predecessor correction checkpoint

**LINUXCNC FIRST | 4000 implementation / 3200 lathe transfer | NON-GRADUATED.** [THREAD-142 pinned audit](../research/4400_LINUXCNC_THREAD_OVERRIDE_142_G33_G331_G76_GLOBAL_LOCK_VERSION_SOURCE_AUDIT_2026-11-02.md) and [practical commissioning map](../guides/3200-4000-linuxcnc-threading-spindle-override-version-and-global-scope-2026-11-02.md).

## Evidence correction

The immediately preceding INHIBIT-141 lesson inadvertently repeated already-published **OVERRIDE-93, OVERRIDE-94 and OVERRIDE-95**. Full historical `PROGRESS.md` and original audits confirm the same v2.9.10 inhibit bitmask and dropped M51 spindle selector. INHIBIT-141 and its guide are now marked **DUPLICATE / SOURCE REINSPECTION**, not a new discovery or independent test. Preserve the files for provenance, do not repeat O93–O95 acceptance cases or count duplicate competency. This is a failure to follow the existing source-symbol predecessor check, not a reason to add new governance paperwork.

## Incremental work

Stable G33/G76 lack development's override suspend/lock, while development G33 suspends, G33.1 retains and G76 locks the override. The intended version-specific policy is already **DOC-CONFIRMED** in development. Newly traced consequence: G33's selected-spindle suspend crosses a Task boundary that discards spindle identity, and G76's SS_LOCKED latch snapshots **all configured spindle scales** capped at 1.0; SS_LOCKED without SS_ENABLED does not apply the multiplier. Source and existing expected canonical logs inspected; **no new LinuxCNC execution**.

## Precise next checkpoint

1. First check whether a positively qualified, physically disconnected runner labeled **both** `[self-hosted, openpressbrake]` is available. If so, execute the **existing** upstream stable/development `tests/interp/g76` comparison, then only the discriminating two-spindle G33/G76 lock-scope cases in the guide. Capture canonical logs, Task mode/spindle, motion `enables_new/enables_queued`, internal locked scales, HAL speed outputs, actual job timestamps/runtime, stdout/stderr and exit codes. Never GitHub-hosted runners.
2. Before proposing any code fix, separate two problems: the already-known **global selector loss** (OVERRIDE-95) and the development **global lock snapshot**. Evaluate a per-spindle override representation plus queued-segment semantics, not a one-line Task forwarding change that motion cannot honor.
3. If compute remains unqualified/unavailable, rotate to a **distinct** LinuxCNC mechanism (e.g. actual toolchange NML/GUI handshake, EtherCAT PDO freshness, DXF plasma CAM output validation), checking full historical PROGRESS and source-path predecessors **before** assigning a new ID. Avoid another unexecuted override fixture.
4. Keep 1000/2000/F02/3000 graduated/closed, independent blind evaluator and personnel-safety authority intact, OpenPressBrake G0/G1 HOLD, hourly curriculum enabled. No new authoritative compute or evaluator score; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.
