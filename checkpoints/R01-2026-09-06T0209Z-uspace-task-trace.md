# R01 checkpoint — 2026-09-06T02:09Z

R01 remains the highest-priority unblocked module.

Completed this session: source-traced the pinned uspace POSIX task path and committed `call-flows/R01-uspace-periodic-task.md`. The trace now distinguishes backend selection, task allocation, explicit pthread scheduling setup, CPU-affinity selection, absolute CLOCK_MONOTONIC periodic waits, and POSIX non-realtime fallback. It also source-confirms the HAL fastest-to-slowest creation constraint and descending-priority assignment.

Important correction: at pinned `8bf4605...`, PREEMPT_RT name detection is not itself the capability gate. `rtapi_get_realtime_type()` first probes whether SCHED_FIFO can actually be obtained; kernel metadata is used later for type classification. This still does not establish latency suitability.

Exact next checkpoint: finish the `hal_create_thread()` body trace for first-thread base-period establishment/rounding and `rtapi_clock_set_period()` interaction. Then trace `rtapi_app` memory locking and privilege/capability lifecycle (`mlockall`, page-fault/allocation preparation, capability retention/drop). Preserve SCHED_FIFO privilege and locked-memory requirements as separate failure boundaries. Only then design a bounded R01 lab that observes selected realtime type plus actual pthread scheduler policy/priority; do not use Actions jitter as qualification evidence.

No R01 laboratory run was launched this session.