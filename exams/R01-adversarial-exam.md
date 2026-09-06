# R01 — Adversarial exam: LinuxCNC realtime model

Pinned primary revision: `8bf4605ae81042248add031e94c77300406e0413`.

Status: **DRAFT / source-grounded, laboratory reconciliation pending**.

This exam tests whether a fresh AI can reason about the realtime model without collapsing kernel type, scheduler privilege, memory locking, HAL period setup, and measured latency into one concept.

## Rules

For each answer, identify the evidence class (`SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN`) and the relevant pinned source path/symbol. Do not claim target-machine suitability from the cloud laboratory.

## Questions

### 1. Misleading premise — PREEMPT_RT implies LinuxCNC realtime

An engineer says: “`uname` contains PREEMPT_RT, therefore LinuxCNC will create all HAL threads as `SCHED_FIFO` and the machine is realtime-qualified.”

Explain every logically separate step that is wrong or unsupported. Trace the pinned source from realtime-type detection into backend selection and state what additional evidence would be needed to make each stronger claim.

### 2. Scheduler capability versus memory locking

A machine can successfully acquire `SCHED_FIFO`, but `mlockall(MCL_CURRENT | MCL_FUTURE)` fails.

At the pinned revision:

- Does LinuxCNC necessarily fall back to `SCHED_OTHER`?
- Which source function selects the backend before/around this point?
- Which capability/rlimit families are relevant to FIFO acquisition versus memory locking?
- What can and cannot be inferred about latency?

Then reverse the scenario: actual `sched_setscheduler(SCHED_FIFO)` fails. Explain which fallback is selected and whether `configure_memory()` is expected to execute on that fallback path.

### 3. HAL period quantization

Assume the pinned uspace POSIX backend and no previously established RTAPI clock. The first requested HAL thread period is 1,000,000 ns.

A later thread is requested at 2,490,000 ns.

Without hand-waving, derive the `hal_create_thread()` stored period from the actual integer expression in source. Then explain whether that thread may be created after a previously created 2,000,000 ns thread.

Repeat conceptually for a backend where `rtapi_clock_set_period(1,000,000)` returns 999,000 ns. State which conclusions are backend-specific and which are generic HAL behavior.

### 4. Creation-order failure path

A component first creates a nominal 2 ms HAL thread and later tries to create a nominal 1 ms HAL thread.

Trace the source path to the rejection. Is the comparison made against the raw requested period or the quantized/stored period? What error is returned by `hal_create_thread()` to its caller at this layer?

### 5. Task allocation is not task start

Explain why a successful `rtapi_task_new()` does not prove that a periodic pthread exists or is running with the requested scheduling policy.

Name the later function boundary, the important pthread attribute operations, and at least two ways task start can still fail.

### 6. Absolute sleep is not a deadline guarantee

The POSIX backend uses `clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, ...)`.

An engineer concludes: “Absolute sleep makes the servo thread deterministic.” Explain what absolute deadlines solve, what they do not solve, and how LinuxCNC detects/reports a late wakeup in the SCHED_FIFO POSIX path at this revision.

### 7. Community failure — cgroups

A PREEMPT_RT host has the expected `rtapi_app` installation privileges, but `sched_setscheduler(..., SCHED_FIFO, ...)` returns `EPERM` for its periodic thread because of resource-control policy.

How should R01 classify this evidence if learned from issue #2821? What diagnostic conclusion is safe? What distro/kernel configuration recipe would be unsafe to universalize?

### 8. Debugging scenario — “latency test shows zeros”

A latency tool starts but reports zeros. Build a bounded diagnostic sequence that distinguishes:

1. backend/realtime-type selection;
2. actual periodic thread existence;
3. actual scheduler policy/priority;
4. capability/rlimit/cgroup denial;
5. measured timing quality.

Explain why the sequence must not begin by treating the zeros as good latency.

### 9. Version/backend-sensitive reasoning

The documentation says the RTAPI base clock period may differ from the requested period because of hardware/RTOS limitations. The pinned uspace POSIX implementation stores the requested period exactly.

Is that a documentation/source conflict? Give the correct version/backend-scoped interpretation and identify the experiment or source comparison needed before making an RTAI or Xenomai claim.

### 10. Bounded modification task

Modify the conceptual R01 observation harness so it can distinguish POSIX fallback from realtime-capable execution without accidentally qualifying the host.

Your design must record:

- pinned revision;
- realtime verification result;
- actual scheduler class/priority of periodic RTAPI pthreads;
- HAL thread periods;
- capability/rlimit context;
- a hard evidence boundary about latency.

It must fail closed when the host unexpectedly takes a different scheduler path from the predeclared prediction rather than silently relabeling the result.

### 11. Harness adversarial question

The public `scripts/realtime.in` wrapper is used to test whether realtime is available. A test harness calls `realtime check`.

At the pinned revision, verify whether that is a valid subcommand. Trace the correct wrapper subcommand to the underlying `rtapi_app` command. Explain why a failure at an invalid wrapper subcommand cannot be promoted as evidence that realtime capability is absent.

### 12. Safety boundary

List the minimum additional categories of evidence needed before using R01 knowledge to approve a physical machine for timing-sensitive control. Explicitly separate LinuxCNC functional behavior from functional-safety certification.

## Expected answer anchors / grading rubric

A passing fresh-AI response must establish all of the following without inventing behavior:

- `rtapi_get_realtime_type()` uses demonstrated SCHED_FIFO acquisition as a capability gate at this pinned revision; kernel metadata alone is insufficient.
- `makeApp()` chooses SCHED_OTHER directly on `REALTIME_TYPE_NONE`; `harden_rt()` executes only on the realtime-capable branch.
- `CAP_SYS_NICE`/RTPRIO/resource-control and `CAP_IPC_LOCK`/MEMLOCK are separate boundaries.
- `mlockall()` failure on a realtime-capable hardening path warns rather than itself selecting fallback.
- first-thread base-period setup and later nearest-multiple rounding are traced to `hal_create_thread()` and `RtapiApp::clock_set_period()`.
- later HAL threads must be nondecreasing in rounded period and receive lower RTAPI priority.
- `rtapi_task_new()` and `rtapi_task_start()` are separate failure boundaries.
- TIMER_ABSTIME avoids accumulated relative-sleep drift but cannot guarantee scheduler wakeup latency.
- issue #2821 remains community-reported historical evidence and motivates checking actual scheduler acquisition.
- `realtime verify`, not `realtime check`, is the pinned wrapper command; `Verify()` invokes `rtapi_app check_rt`.
- cloud scheduler observations are not physical-machine latency qualification and are not functional-safety evidence.

## Laboratory-dependent grading hold

Do not mark this exam fully passed until experiment `005` (or a materially corrected successor) has reconciled the predicted fallback/runtime scheduler observations. If the lab contradicts a source assumption, correct the guide and rubric first.
