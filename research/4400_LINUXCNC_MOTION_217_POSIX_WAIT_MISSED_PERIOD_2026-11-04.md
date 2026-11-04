# MOTION-217 — POSIX realtime missed-period path (4000, non-graduated)
Date: 2026-11-04. LinuxCNC v2.9.10; source inspection only.

## Implementation question
What does the POSIX/PREEMPT_RT-style userspace backend do if a HAL servo thread finishes after its next scheduled release? Is the overrun a HAL pin, an exception, a skipped cycle, or a log message?

## Pinned implementation
Source: [LinuxCNC v2.9.10 src/rtapi/uspace_rtapi_app.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/rtapi/uspace_rtapi_app.cc), symbols `Posix::task_wrapper` (approximately 1100–1119), `Posix::wait` (1152–1172), `RtapiApp::unexpected_realtime_delay` (959–970), `rtapi_wait` (1274–1277), `RtapiApp::clock_set_period` (1205–1215); and [HAL thread_task](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c) (MOTION-216). Tag v2.9.10 is the version scope; the pinned commit identified by earlier course work is 86cdca76fa2a36274c432caa21952b23c267989a.

**SOURCE-CONFIRMED:** `rtapi_wait()` calls `App().wait()`. For `Posix`, each call advances `task->nextstart` by `task->period + task->pll_correction` from its *previous scheduled* value, not from current wall-clock time. It reads `CLOCK_MONOTONIC`; if the new deadline is strictly earlier than `now`, it does not sleep. For `SCHED_FIFO` it invokes `unexpected_realtime_delay(task)`; otherwise it sleeps until the absolute deadline using `rtapi_clock_nanosleep(..., TIMER_ABSTIME,...)`. The warning prints **only once per session** through a static `printed` flag. No per-overrun HAL counter, automatic shutdown, or motion abort is established by this path. The wrapper initially seeds the deadline from the current clock plus a period/correction; the PLL correction setter clamps correction to ±1% of requested period (see task start and PLL setter).

**SOURCE-CONFIRMED nuance:** The condition uses a strict less-than test; equality takes the sleep branch. The warning is conditional on `policy == SCHED_FIFO`. The function `unexpected_realtime_delay` accepts an unused `nperiod` argument, so do not interpret it as a counted number of missed periods. The wait code checks `res < 0` for `clock_nanosleep`; the exact diagnostic behavior of positive error-number returns is not resolved here. A scheduler wakeup after an absolute sleep target can be late without this branch noticing it until a subsequent wait. No claim is made about kernel-level latency instrumentation.

## Worked release timeline (analytical; no execution)
Assume period 1 ms, PLL correction zero and an established next deadline at t=10 ms. At a wait call, nextstart advances to t=11 ms. If current time is t=11.4 ms, the strict-past check fires, SCHED_FIFO emits the once-per-session warning (unless already printed), and the function returns without sleeping. On the next cycle, nextstart advances to t=12 ms; if work finishes at t=11.7 ms, the task sleeps until t=12 ms. **Inference:** The loop can catch up by doing successive work without sleeping, rather than automatically dropping a HAL function execution. Whether it catches up depends on subsequent work duration and scheduling; do not assert that it always does.

Contrast MOTION-216: HAL `.time/.tmax` measure execution duration, while the backend's past-deadline check compares scheduled release to wall-clock time. Neither alone establishes a timestamped per-cycle packet freshness record.

## Reproducible source-reading exercise
1. Fetch the two files at v2.9.10; find `thread_task`, `rtapi_wait`, `Posix::wait`, `unexpected_realtime_delay`, and `task_wrapper`.
2. Draw the path HAL functions → HAL timing update → `rtapi_wait` → deadline advance → past-deadline branch or absolute sleep.
3. Evaluate three cases with scheduled nextstart=10 ms, period=1 ms: now=10.8 (sleep to 11); now=11 (equality/sleep branch); now=11.4 (past deadline, no sleep and one-time SCHED_FIFO log). For a second overrun, predict no second warning in the same session.
4. Change only policy from SCHED_FIFO to a non-FIFO policy; explain why the past-deadline path still skips sleep but does not invoke the warning.
5. Design a non-machine simulator measurement using an independently timestamped loop release, not only `servo-thread.tmax`. Precommit thresholds before any execution; no test is claimed.

## Evidence and constraints
- SOURCE-CONFIRMED (v2.9.10): scheduled-deadline advancement, monotonic absolute wait, strict past-deadline branch, FIFO-only once-per-session warning, and void return path.
- INFERENCE: potential back-to-back execution when late; no automatic cycle drop is visible in the inspected branch.
- UNKNOWN: exact POSIX backend configuration on any particular machine, OS scheduling delay distribution, hardware communications effects, other realtime backends (RTAI/Xenomai), positive `clock_nanosleep` error reporting, and whether separate diagnostics expose missed periods.
- TEST-CONFIRMED: none. No LinuxCNC run, build, lab compute, GitHub Actions, or physical-machine operation.
- No graduation or safety gate changed; independent personnel safety is not delegated to this timing path.

## Next discriminating work
Inspect the v2.9.10 POSIX scheduling policy selection and clock-frequency/units path, then compare one actual documented latency diagnostic against the source. If diminishing returns, rotate to EtherCAT working-counter and PDO freshness propagation, preserving distinct bus-state and feedback-age concepts.
