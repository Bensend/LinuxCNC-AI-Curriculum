# MOTION-218 — POSIX scheduling selection and clock-domain boundaries (4000, NON-GRADUATED)
Date: 2026-11-04. Scope: LinuxCNC v2.9.10; source inspection, no execution.

## Question
When does LinuxCNC use FIFO rather than ordinary POSIX scheduling, and can HAL execution-time clock ticks be equated to the monotonic nanoseconds used by the realtime wait path?

## Source provenance
- [LinuxCNC v2.9.10 uspace_rtapi_app.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/rtapi/uspace_rtapi_app.cc), tag v2.9.10 (previous curriculum records identify commit `86cdca76fa2a36274c432caa21952b23c267989a`), symbols `makeApp` (~811–838), `Posix::task_start` (~1033–1080), `Posix::do_get_time` (~662–666), `Posix::wait` (~1152–1172).
- [LinuxCNC v2.9.10 rtapi.h](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/rtapi/rtapi.h), `rtapi_get_time` and `rtapi_get_clocks` declarations/comments (~242–293).
- Prior [MOTION-216](4400_LINUXCNC_MOTION_216_HAL_RUNTIME_VS_DEADLINE_2026-11-04.md) and [MOTION-217](4400_LINUXCNC_MOTION_217_POSIX_WAIT_MISSED_PERIOD_2026-11-04.md).

## Source-confirmed behavior
1. `makeApp()` selects `new Posix(SCHED_OTHER)` when effective UID is nonzero **or** `harden_rt()` fails. If those checks pass, it attempts a Xenomai or RTAI dynamic backend when detected and successfully constructed; otherwise it selects `new Posix(SCHED_FIFO)`. Therefore LinuxCNC userspace does **not** always imply FIFO, and successful root/effective-privilege handling alone does not establish which backend actually ran.
2. `Posix::task_start` sets the pthread scheduling policy from the selected `policy`, uses `task->prio` as `sched_priority`, and explicitly requests `PTHREAD_EXPLICIT_SCHED`. It may set CPU affinity if `find_rt_cpu_number()` returns a CPU. Errors in attribute setup or `pthread_create` are returned as negative error numbers. This is requested configuration, not proof of the kernel's achieved timing.
3. `Posix::do_get_time()` returns `CLOCK_MONOTONIC` seconds times 1e9 plus nanoseconds. The POSIX deadline path also uses a monotonic clock, with absolute sleeps. These values have nanosecond units; they are not automatically equivalent to `rtapi_get_clocks()`.
4. `rtapi.h` describes `rtapi_get_clocks()` as CPU-clock/TSC-style fast ticks and warns that their duration depends on clock frequency. **The exact implementation, units, frequency calibration and portability of `rtapi_get_clocks()` for the selected userspace backend were NOT resolved by this inspection.** Do not convert HAL `.time/.tmax` ticks to microseconds without a verified clock source and conversion factor.

## Consequences and reproducible review
- Scenario A: effective UID nonzero → POSIX SCHED_OTHER; the MOTION-217 past-deadline branch still avoids sleeping, but the FIFO-only unexpected-delay warning is not emitted.
- Scenario B: effective UID zero, hardening fails → same SCHED_OTHER selection. Do not infer that root means FIFO.
- Scenario C: effective UID zero, hardening succeeds, no successfully loaded alternate backend → POSIX SCHED_FIFO. The warning is possible, but once per session, not an overrun count.
- Scenario D: hardening succeeds and alternate backend is successfully loaded → this POSIX wait trace is **not** sufficient to describe that backend.
- Scenario E: two samples of `rtapi_get_time()` differ by 200000 ns. This is 0.2 ms; the same numeric difference in `rtapi_get_clocks()` is **not** 0.2 ms without tick calibration.
- Scenario F: `pthread_create` returns nonzero → `task_start` returns an error; it is incorrect to assume a functioning servo thread or silently treat its intended policy as achieved.

## Disconnected implementation exercise
At a pinned checkout, inspect `makeApp`, `harden_rt`, `task_start`, `Posix::wait`, `rtapi_get_time`, and search all definitions of `rtapi_get_clocks`. Construct a matrix of selected backend, scheduling policy, clock used for release timing, clock used for HAL timing, and available overrun evidence. Record compiler/backend configuration and observed return values before drawing runtime conclusions. If running a test, use a non-machine simulation only and an authorized `[self-hosted, openpressbrake]` runner; none was run in this lesson.

## Evidence ledger and stop rule
**SOURCE-CONFIRMED:** selection branches, explicit pthread scheduling setup, POSIX monotonic time in nanoseconds, and declaration-level distinction between time and clocks. **INFERENCE:** the same source tree can exhibit different latency diagnostics depending on privilege/hardening/backend. **UNKNOWN:** actual deployed backend, clock-tick conversion for HAL runtime, Linux kernel jitter, affinity effectiveness, and EtherCAT PDO freshness. **TEST-CONFIRMED:** none.

This closes the highest-value policy-selection question without manufacturing repeated realtime notes. **Next priority:** EtherCAT working-counter / slave operational-state / PDO read-freshness propagation in a pinned LinuxCNC EtherCAT driver, including a concrete HAL ordering example; distinguish upstream LinuxCNC core from third-party lcec. No graduation, blind-score, safety, or machine-operation change.
