# R01 — uspace periodic task call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Scope

This trace separates four questions that must not be conflated: which implementation is selected, what scheduling policy/priority is requested, how periodic wakeups are generated, and whether the host actually delivers acceptable latency.

## Backend selection

`src/rtapi/uspace_rtapi_main.cc` selects the POSIX backend with `SCHED_OTHER` when `rtapi_get_realtime_type()` returns `REALTIME_TYPE_NONE`; otherwise the realtime POSIX path can use `SCHED_FIFO` (other compiled uspace backends such as Xenomai/RTAI remain distinct implementations). The capability probe attempts a real `sched_setscheduler(..., SCHED_FIFO, ...)` transition and restores the old policy. Failure is reported with capability diagnostics and produces POSIX non-realtime fallback. `LINUXCNC_FORCE_REALTIME` is explicitly a testing override, not qualification evidence.

Classification: `SOURCE-CONFIRMED` for the pinned revision.

Important correction to the initial R01 wording: PREEMPT_RT kernel-name detection is not itself the capability gate in this revision. The source first tests whether SCHED_FIFO can actually be acquired. Kernel-string detection then classifies the realtime type. Therefore neither a PREEMPT_RT label nor SCHED_FIFO availability alone is a measured-latency result.

## Task creation

Public `rtapi_task_new()` in `uspace_rtapi_main.cc` delegates to `App().task_new(...)`.

`RtapiApp::task_new()` in `uspace_rtapi_app.cc`:

1. validates the requested priority against the selected backend policy's `sched_get_priority_min/max` range;
2. allocates a task ID;
3. creates the backend task object;
4. clamps stack size upward to at least 1 MiB;
5. records owner, argument, task function, stack size and priority;
6. ignores the historical `uses_fp` choice and records FPU use enabled;
7. publishes the task in `task_array`.

It does **not** create the pthread yet. Invalid priority returns `-EINVAL`; task-slot exhaustion propagates `-ENOSPC`.

## POSIX task start

Public `rtapi_task_start()` delegates to `App().task_start(...)`.

For `PosixApp::task_start()` in `uspace_posix.cc`:

1. validate the task ID;
2. store the requested period;
3. construct a `sched_param` using the stored task priority;
4. set PLL correction limit to +/-1% of the period;
5. initialize pthread attributes;
6. set the configured stack size;
7. explicitly set the backend scheduling policy and priority;
8. require `PTHREAD_EXPLICIT_SCHED` so the new thread does not merely inherit the creator's policy;
9. on multicore systems, optionally pin to the selected realtime CPU (`RTAPI_CPU_NUMBER`, otherwise the highest isolated CPU found); and
10. create the pthread running `wrapper()`.

Attribute or pthread creation failures return the negative pthread error. Thus task creation and task start are separate failure boundaries.

### Non-realtime fallback detail

The same POSIX task-start code is used with `policy == SCHED_OTHER` in fallback mode. Under Linux/POSIX, the backend's priority helpers derive the valid range from that policy; for `SCHED_OTHER` this collapses to the policy's ordinary priority range rather than pretending FIFO priorities exist. The constructor sets `do_thread_lock = (policy != SCHED_FIFO)`, enabling a global mutex around periodic task execution/waits in this fallback path. This is simulation/execution behavior, not realtime scheduling.

## Periodic execution and wait

`wrapper()` records pthread-specific task identity, names the thread `rtapi_app:T#<id>`, reads `CLOCK_MONOTONIC`, computes the first `nextstart`, then invokes the task function. The task function is expected to remain alive and call `rtapi_wait()` periodically; returning from it is treated as an error.

The POSIX backend `wait()`:

- releases the fallback `thread_lock` when that serialization mode is active;
- provides a pthread cancellation point;
- advances the task's absolute `nextstart` by `period + pll_correction`;
- compares that deadline to current `CLOCK_MONOTONIC`;
- if late, reports `unexpected_realtime_delay()` only for `SCHED_FIFO`;
- otherwise sleeps with `clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, ...)` to the absolute deadline;
- reacquires the fallback lock when applicable.

Absolute deadlines avoid accumulating the execution-time drift that a naive relative sleep loop would introduce. They do not guarantee the scheduler wakes the task on time.

Classification: `SOURCE-CONFIRMED`.

## HAL thread priority/order connection

Pinned `hal_create_thread()` source rejects a newly requested period shorter than an existing previous thread period, enforcing creation from faster to slower periods. It assigns each new thread `rtapi_prio_next_lower(prev_priority)` before creating its RTAPI task. This source behavior reconciles the documentation's rate-monotonic creation rule: earlier/faster HAL threads receive higher scheduling priority; later/slower threads step downward through the backend's priority range.

Classification: `SOURCE-CONFIRMED` for ordering/priority assignment. Exact period rounding/base-clock behavior still requires the next source pass before it is promoted from documentation evidence.

## Evidence boundary

A runtime observation can separately establish:

- selected realtime type / fallback mode;
- actual pthread scheduler policy and priority;
- CPU affinity;
- wakeup lateness/jitter under a stated load.

Only the last category measures timing behavior, and even that is workload/hardware/configuration specific. A GitHub Actions host can usefully verify fallback selection and scheduler-policy observations, but it is not a realtime qualification platform.

## Next source checkpoint

Trace the remaining `hal_create_thread()` body and `rtapi_clock_set_period()` interaction to document exact first-thread base-period establishment and rounding. Then inspect `rtapi_app` startup memory-lock/capability handling (`mlockall`, allocation/page-fault preparation, capability retention/drop) and distinguish prerequisites for SCHED_FIFO from prerequisites for locked-memory realtime operation. After those traces, design one bounded R01 lab that records selected realtime type plus actual scheduler policy/priority without interpreting Actions latency as machine suitability.
