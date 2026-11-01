# 4000-LC-TP-92 — Development S-curve Ruckig pool exhaustion can allocate in the servo cycle

**Date:** 2026-11-01. **NON-GRADUATED.** A distinct LinuxCNC trajectory-planner implementation investigation after HOMING-90/91. **SOURCE-CONFIRMED conditional**, no runtime, jitter or physical test. This finding is **specific to inspected development commit 537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**; do not project it onto stable v2.9.10, whose TP lacks the inspected Ruckig pool.

## Source provenance and exact execution boundary

- [`src/emc/tp/ruckig_wrapper.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/ruckig_wrapper.c#L119-L229): `RUCKIG_POOL_SIZE=16`, `ruckig_pool_init`, `ruckig_pool_acquire`, `ruckig_pool_release`. [`ruckig_create`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/ruckig_wrapper.c#L60-L111) uses `rtapi_kmalloc` for planner state; destruction uses `rtapi_kfree`.
- [`src/emc/tp/sp_scurve.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/sp_scurve.c#L142-L193): `sp_scurve_init` allocates a cached planner, eagerly calls `ruckig_pool_init`, logs partial-pool error, **but returns 0** after a successful cached planner even if the pool is incomplete. `tpSetCycleTime` invokes this at [tp.c ~534](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L520-L540).
- [`src/emc/tp/tp.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L2780-L3057): `tpCalculateSCurveAccel` acquires planner when absent, and on failed acquisition returns `TP_SCURVE_ACCEL_ERROR` (log once per segment).
- [`tpUpdateCycle`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L3851-L3937) calls Ruckig for `GET_TRAJ_PLANNER_TYPE()==1`; on `TP_SCURVE_ACCEL_ERROR`, it computes a ramp/trapezoidal update **for that cycle**, rather than halting or permanently disabling the S-curve mode.
- [`tpReleaseQueuedPlanners`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L416-L445) calls `tcCleanupRuckig` before `tcqInit`; [`tcCleanupRuckig`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tc.c#L1106-L1118) releases pooled or fallback planners. This is important to avoid mislabeling ordinary abort/queue reset as a permanent pool leak.

## Reconstructed call chain

Configuration/init: `tpSetCycleTime` → `sp_scurve_init` → `ruckig_pool_init` → 16 `ruckig_create` allocations. The intended invariant is that the servo loop only **borrows** already allocated planners.

Realtime trajectory cycle: `tpRunCycle` → regular/blended segment update → `tpUpdateCycle` → `tpCalculateSCurveAccel` → `ruckig_pool_acquire`. Under normal conditions `ruckig_pool_acquire` resets a free planner and returns it without allocation. **When no free slot exists**, the function logs once and calls **`ruckig_create(cycle_time)` directly from this acquisition path**. When the pool was never initialized, the lazy backstop calls `ruckig_pool_init(cycle_time)` on that same path. Both are conditional allocation in the servo execution path, contrary to an unconditional “no RT allocations” interpretation.

The code comment explicitly describes this as an availability fallback rather than a no-allocation guarantee. Its rationale assumes at most the active and next segment hold planners. That is an engineering assumption to verify, **not proof** that exhaustion can happen during normal machining.

## Error behavior and status trust

A partially allocated pool is marked initialized even if fewer than 16 planners were created; `sp_scurve_init` logs the incomplete pool but returns 0. If the fallback `ruckig_create` also fails, `tpCalculateSCurveAccel` logs at most once per segment and returns an error. `tpUpdateCycle` then calculates a ramp/trapezoidal update for that cycle and can retry Ruckig on later cycles. The source does **not** establish a hard realtime deadline, maximum latency, trajectory continuity under repeated fallbacks, or an installed-machine failure. A warning log is not a servo jitter measurement.

On abort and queue clear, development explicitly releases borrowed planners before queue reset. A genuine pool-leak claim would require a retained state trace demonstrating that some other queue-removal path fails to call `tcCleanupRuckig`.

## High-value disconnected verification matrix — all NOT RUN

| Case | Fixture and instrumentation | Discriminator |
|---|---|---|
| TP92-01 | Preinitialize 16-slot pool; acquire/release one segment repeatedly | No `ruckig_create` in instrumented servo cycle; slot returned. |
| TP92-02 | Artificially reserve all 16 slots before acquisition | `ruckig_pool_acquire` calls live `ruckig_create`; record allocator call site and timing. |
| TP92-03 | Simulate partial initialization (e.g. fail one allocation) | `ruckig_pool_init` returns -1, `sp_scurve_init` logs but returns 0 after cached planner succeeds. |
| TP92-04 | Simulate live fallback allocation failure | `TP_SCURVE_ACCEL_ERROR`, once-per-segment diagnostic, ramp/trapezoidal cycle fallback. |
| TP92-05 | Force repeated failure over successive cycles | Distinguish retry behavior, velocity/position continuity and log rate; no safety conclusion from a single successful fallback. |
| TP92-06 | Abort and queue-clear with active/next planners | `tcCleanupRuckig` releases all queue-held slots; inspect pool occupancy before/after. |
| TP92-07 | Exercise a parabolic blend and a regular cycle | Verify both `tpUpdateCycle` call sites and `mode` selection; don't assume the blend branch is unreachable. |

**Test harness requirements:** Only an independently qualified disconnected `[self-hosted, openpressbrake]` runner, no physical machine, no GitHub-hosted fallback. Use injected allocator failures or a software shim, pinned source SHA, and retained per-cycle logs, return codes, queue depth, allocator call counts, cycle duration/jitter distribution, commanded position and velocity. Never mark `TEST-CONFIRMED` without executing and inspecting outputs.

## Practical significance and uncertainty

The failure-mode distinction matters for high-speed routers, mills and robotic paths using development jerk-limited trajectory planning. The safe teaching is: **preallocation exists, but exhaustion and lazy initialization retain dynamic allocation paths in the servo-cycle call chain**. This does not demonstrate that 16 concurrent planners occur on a real configuration, nor that allocation is necessarily unbounded or unsafe on a particular RT kernel. Further upstream maintenance should be considered only after reproducing a reachable failure, or as a clearly labeled deterministic-RT hardening proposal.

**Novelty check:** full PROGRESS text contains no prior `ruckig_pool`, `ruckig_create` or S-curve pool audit. No code change, build, simulation, Python execution, evaluator, hardware or Actions compute this session.
