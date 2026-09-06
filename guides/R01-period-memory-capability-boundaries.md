# R01 — HAL period, scheduler capability, and memory-lock boundaries

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Course level: 1000-series foundation. This artifact deliberately separates scheduler selection, HAL period quantization, memory hardening, and measured latency. They are related but are not interchangeable evidence.

## 1. `hal_create_thread()` establishes the HAL base period once

Source: `src/hal/hal_lib.c::hal_create_thread()`.

For the **first** HAL thread, the function asks `rtapi_clock_set_period(0)` whether a clock period already exists. If it returns zero, HAL calls `rtapi_clock_set_period(period_nsec)` with the requested first-thread period. A negative return is rejected. HAL also rejects an existing/current clock period that is more than 1% longer than the requested period.

The value stored as `hal_data->base_period` then depends on `hal_data->exact_base_period`:

- when `exact_base_period` is true, HAL stores the original requested `period_nsec`;
- otherwise it stores the period returned by RTAPI.

At the pinned **uspace POSIX** backend, `src/rtapi/uspace_rtapi_app.cc::RtapiApp::clock_set_period()` does not perform hardware-timer quantization: first nonzero call stores `period = nsecs` exactly; a second nonzero set attempt returns `-EINVAL`; a zero call returns the existing period. Therefore, in this backend, the returned clock period equals the requested value. Other backends must not be assumed to behave identically.

Classification: **SOURCE-CONFIRMED** for the pinned uspace POSIX implementation.

## 2. Every HAL thread period is rounded to an integer multiple of the base period

After base-period establishment, `hal_create_thread()` rejects a requested period shorter than `hal_data->base_period`. It then computes:

`n = (period_nsec + base_period / 2) / base_period`

and stores:

`new->period = base_period * n`

This is integer nearest-multiple rounding (half a base period is added before integer division). The rounded period, not the original request, is passed to `rtapi_task_start()`.

The function then enforces creation ordering: the rounded new period may not be less than the previous/slowest existing thread's period. Priority is selected one step lower than the prior priority using `rtapi_prio_next_lower(prev_priority)`. The first HAL thread begins one step below `rtapi_prio_highest()` because the absolute highest priority is deliberately reserved in the HAL code.

This makes the source rule more precise than the shorthand “fastest thread first”: **creation order must be nondecreasing after HAL's base-period rounding**, and each later thread is assigned a lower RTAPI priority.

Classification: **SOURCE-CONFIRMED**.

### Failure boundaries worth teaching

`hal_create_thread()` can reject the operation before task creation for zero period, duplicate name, configuration lock, allocation failure, clock-set failure, clock period too long, period shorter than the base period, or a rounded period shorter than the previously created thread. `rtapi_task_new()` and `rtapi_task_start()` are separate later failure boundaries.

## 3. SCHED_FIFO capability and memory locking are independent gates

Source: `src/rtapi/uspace_rtapi_main.cc`.

### Scheduler capability probe and backend selection

`can_set_sched_fifo()` performs an actual `sched_setscheduler(..., SCHED_FIFO, ...)` transition on the calling process/thread and restores the old policy. `rtapi_get_realtime_type()` returns `REALTIME_TYPE_NONE` when that test fails (unless the explicit testing override is active), so POSIX non-realtime fallback selection is tied to demonstrated SCHED_FIFO acquisition, not merely to a kernel name.

The diagnostic path reports effective `CAP_SYS_NICE` and `CAP_IPC_LOCK`, but only the scheduler acquisition result is the gate used here for choosing `REALTIME_TYPE_NONE` versus a realtime type.

`makeApp()` makes the distinction operationally important: when the realtime type is `REALTIME_TYPE_NONE`, it directly loads `liblinuxcnc-uspace-posix.so.0` with `SCHED_OTHER`. It calls `harden_rt()` only on the realtime-capable branch. Therefore the ordinary POSIX non-realtime fallback **does not call `configure_memory()` at all** in this pinned revision.

This corrects an easy misreading: failure of memory locking is not what selects the non-realtime fallback, and an unprivileged fallback run should not be expected to emit an `mlockall()` warning because that hardening path is skipped.

### Memory hardening on a realtime-capable branch

When `makeApp()` has selected a realtime-capable path, `harden_rt()` calls `configure_memory()`. That function:

1. inspects effective `CAP_IPC_LOCK`;
2. attempts to raise the soft `RLIMIT_MEMLOCK` to its hard limit;
3. calls `mlockall(MCL_CURRENT | MCL_FUTURE)`;
4. warns, but does not abort, if `mlockall()` fails;
5. disables malloc trimming and mmap-backed allocation where supported; and
6. allocates 32 MiB, touches one byte per page, then frees it so pages are faulted/touched while memory locking is active and the heap space remains reusable.

`harden_rt()` also attempts `RLIMIT_RTPRIO`, `RLIMIT_CORE`, dumpability setup, I/O privilege where applicable, signal setup, and `/dev/cpu_dma_latency` handling. These hardening operations have distinct error handling; several are best-effort warnings rather than a single all-or-nothing “realtime enabled” flag.

Classification: **SOURCE-CONFIRMED**.

## 4. Capability/lifecycle boundary visible in `rtapi_app`

The process startup path manipulates identities separately from backend selection. `main()` initializes `WithRoot` from real/effective UIDs and swaps UID state before opening its command socket. On Linux it also attempts to raise `CAP_NET_ADMIN` into the ambient set so child tools used by drivers such as `hm2_eth` can inherit it across `execve()` when that capability is present. This networking capability handling is separate from `CAP_SYS_NICE` (scheduler acquisition) and `CAP_IPC_LOCK` (memory locking).

The important R01 lesson is not to teach “rtapi_app needs root” as a monolithic rule. Different privileged operations have different capability/rlimit/resource-control requirements, and the source actively tests some of those capabilities rather than inferring them from UID alone.

Classification: **SOURCE-CONFIRMED** for the pinned revision.

## 5. Why the evidence classes must remain separate

A fresh engineer must not collapse the following into one boolean:

| Question | Example evidence | What it proves |
|---|---|---|
| Can this process acquire FIFO scheduling? | `sched_setscheduler` probe / actual thread policy | scheduler privilege/availability at that instant |
| What realtime type did LinuxCNC select? | `realtime check` / `rtapi_get_realtime_type()` | LinuxCNC backend classification |
| Was realtime hardening attempted? | source path + startup diagnostics | whether `harden_rt()`/`configure_memory()` executed |
| Is memory locked/pre-faulted? | `mlockall`, MEMLOCK/capability state, process diagnostics | resistance to paging/page-fault latency, not scheduler policy |
| What priority/policy does a HAL task actually have? | `/proc`, `ps`, scheduler introspection | runtime scheduling state for that thread |
| Does the machine meet its deadline under realistic load? | bounded latency/jitter measurement on the target machine | workload/hardware-specific timing behavior |

None of the first five, alone, is a machine realtime-qualification result.

## 6. Community failure case: cgroup RT throttling can invalidate naive assumptions

LinuxCNC issue #2821 (2024) reported a PREEMPT_RT system where realtime thread creation failed under `CONFIG_RT_GROUP_SCHED=y` because the process cgroup lacked RT runtime. The reporter's `strace` showed `sched_setscheduler(..., SCHED_FIFO, ...) = -1 EPERM` even after the historical setuid setup, and the symptom was a latency test returning zeros instead of useful measurements.

Classification: **COMMUNITY-REPORTED** for the historical configuration. The value for R01 is the failure model: kernel type plus installed privileges is not enough if an intervening resource-control layer denies actual FIFO scheduling. Current pinned source's active SCHED_FIFO probe is materially stronger than inferring capability from metadata.

Do not generalize the 2024 cgroup recipe to every current distro/kernel; treat it as a diagnostic lead when actual scheduler acquisition disagrees with expected privileges.

## 7. R01 laboratory implications

The first R01 lab is observational, bounded, and non-qualifying. It records, in one artifact:

- pinned LinuxCNC revision and curriculum SHA;
- `realtime check` / selected realtime type;
- kernel/version metadata;
- effective capabilities and MEMLOCK/RTPRIO limits;
- whether the run is on the hardening or fallback path;
- actual scheduler policy/priority and CPU affinity of HAL periodic pthreads; and
- HAL thread requested versus reported periods.

The lab must **not** label GitHub Actions latency as suitable or unsuitable for a physical machine. Its purpose is to verify the source-model distinctions and fallback behavior.

The predeclared Actions prediction is POSIX non-realtime/SCHED_OTHER with no expectation of an `mlockall()` diagnostic, because `makeApp()` skips realtime hardening on `REALTIME_TYPE_NONE`. A later target-machine qualification lesson can measure latency separately.

## Higher-level promotion / uncertainty queue

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks R01 graduation? |
|---|---|---|---|---|---|---|
| Compare exact timer/base-period behavior across RTAI/Xenomai/uspace backends | uspace POSIX source only | backend-specific internals exceed R01 foundation need | could affect backend-specific period-resolution claims | 2000 | MEDIUM | No, if R01 remains explicitly backend-scoped |
| Modern cgroup/systemd RT-runtime interactions across supported distros | historical issue + current scheduler probe | distro/kernel policy changes | can explain field SCHED_FIFO failures | 2000 | HIGH | No; current-level guidance says test actual acquisition |
| Quantify effect of failed memory locking on LinuxCNC deadline misses | source warns latency may suffer | requires controlled target experiments | reliability/performance consequence | 2000 | HIGH | No; R01 must avoid quantitative guarantee |
| Hardware-specific latency qualification limits | not suitable for cloud lab | requires target hardware and realistic load | machine suitability/safety | 2000/physical commissioning | CRITICAL | No, because R01 explicitly does not qualify hardware |

## Next checkpoint

Inspect bounded Actions run `34008620114` for `lab-jobs/005-r01-realtime-boundaries.sh`. Accept only observations that match its recorded source SHA/job metadata. Reconcile selected realtime type, HAL-reported periods, and actual pthread scheduler class. If the job fails because the prediction is wrong, treat the mismatch as research evidence and correct the model/harness before any rerun rather than weakening the assertion.