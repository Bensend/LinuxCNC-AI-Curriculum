# R01 — Adversarial exam answer key and grading record

Pinned primary revision: `8bf4605ae81042248add031e94c77300406e0413`.
Accepted laboratory run: `34011177375`, job `101427172728`, curriculum SHA `ac479678abec2e4933447b1d5d03eb51c7569fc6`.

Status: **PASS — source model reconciled with bounded runtime observation**.

This grading record answers the exam at the level required for a fresh-AI handoff. It deliberately does not turn the GitHub runner into latency-qualification evidence.

## 1. PREEMPT_RT misleading premise

**Answer:** Kernel naming/metadata is not the capability gate at the pinned revision. `rtapi_get_realtime_type()` attempts an actual `sched_setscheduler(..., SCHED_FIFO, ...)`; if that transition fails, the ordinary path becomes `REALTIME_TYPE_NONE`. `makeApp()` then selects the POSIX backend with `SCHED_OTHER`. Successful backend selection still would not establish acceptable latency: actual periodic pthread policy/priority and measured timing must be observed separately.

Evidence: `SOURCE-CONFIRMED`, then `TEST-CONFIRMED` for the accepted Actions fallback only. Run `34011177375` returned `realtime-verify-rc=1` and `No realtime`, and its periodic task rows were `TS`, not FIFO.

## 2. Scheduler capability versus memory locking

**Answer:** Successful FIFO acquisition followed by `mlockall()` failure does not itself select `SCHED_OTHER`. Scheduler privilege/resource-control and memory locking are separate boundaries. The realtime-capable branch invokes hardening; memory-lock failure is warning/degradation evidence, not the realtime-type selector. Conversely, when the initial FIFO capability test fails, `REALTIME_TYPE_NONE` selects POSIX `SCHED_OTHER` directly and the fallback does not traverse `harden_rt()`/`configure_memory()`.

Evidence: `SOURCE-CONFIRMED`. The accepted fallback run emitted no `mlockall` failure and the harness correctly records that absence as **not proof of lock success**.

## 3. HAL period quantization

With base period 1,000,000 ns, `hal_create_thread()` rounds using nearest-multiple integer arithmetic equivalent to `(requested + base/2) / base`, then multiplies by base. For 2,490,000 ns: `(2,490,000 + 500,000) / 1,000,000 = 2`, so the stored period is 2,000,000 ns. Creating it after an existing 2,000,000 ns thread is allowed because the rounded period is not shorter.

If the backend establishes a 999,000 ns base, the same HAL nearest-multiple rule applies around that base; the backend-specific fact is what period `rtapi_clock_set_period()` actually establishes. The pinned uspace POSIX backend stores the initial request exactly.

Evidence: `SOURCE-CONFIRMED`. Accepted run `34011177375` also `TEST-CONFIRMED` exact 1,000,000 and 2,000,000 ns reporting for the chosen requests/backend.

## 4. Creation-order failure

The rejection uses the rounded/stored candidate period, not merely the raw requested value. A later rounded period shorter than the previously created thread is rejected by `hal_create_thread()`; faster threads therefore must be created first for the rate-monotonic ordering expected by this layer.

Evidence: `SOURCE-CONFIRMED`.

## 5. Task allocation is not task start

`rtapi_task_new()` allocates/validates task state through `App().task_new(...)`; it does not prove a pthread exists. `rtapi_task_start()` is the later boundary. The POSIX implementation sets explicit scheduling attributes/policy/priority, optional affinity, and then creates the pthread. Attribute setup, affinity, scheduling permission, or pthread creation can still fail.

Evidence: `SOURCE-CONFIRMED`.

## 6. Absolute sleep is not a deadline guarantee

`clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, ...)` prevents simple accumulated drift from repeatedly sleeping relative to the previous wakeup. It cannot force the kernel to schedule the thread at the deadline and therefore does not establish determinism or acceptable jitter. Late-wakeup behavior and latency remain scheduler/load/platform dependent.

Evidence: `SOURCE-CONFIRMED` for the wait mechanism; physical timing quality remains `UNKNOWN` until measured on the target.

## 7. Community cgroup failure

LinuxCNC issue #2821 is `COMMUNITY-REPORTED`. The safe lesson is that actual `sched_setscheduler(SCHED_FIFO)` acquisition can be denied by resource-control policy even when the host otherwise appears realtime-capable. It is unsafe to universalize one historical cgroup/systemd recipe across current supported distributions without version-specific verification.

## 8. “Latency test shows zeros” diagnostic sequence

Fail closed and separate these questions:

1. Record pinned source/build and `realtime verify` result.
2. Confirm the expected periodic RTAPI task threads actually exist.
3. Inspect their real OS scheduler class and realtime priority.
4. Inspect capabilities, RTPRIO/MEMLOCK limits and applicable cgroup/resource-control denial evidence.
5. Only then interpret measured latency/jitter output under a controlled workload.

Zeros are not proof of good latency because they can arise before a valid periodic measurement path is established.

## 9. Documentation versus pinned POSIX period behavior

There is no contradiction. Documentation describes a cross-backend contract in which hardware/RTOS limitations may change the base period. The pinned uspace POSIX implementation stores the first requested period exactly. Claims about RTAI/Xenomai require their own pinned source comparison or experiments.

Evidence: `DOC-CONFIRMED` + `SOURCE-CONFIRMED`, scoped by backend.

## 10. Bounded modification task

The accepted `005` harness satisfies the required design:

- pins upstream SHA;
- records host limits/capability context;
- calls the valid public `realtime verify` wrapper and requires explicit classification;
- fails closed if the host unexpectedly reports realtime capability;
- starts RTAPI, creates known 1 ms and 2 ms HAL threads, and verifies their reported periods;
- locates exactly one `rtapi_app` master and inspects its periodic `T#` pthread scheduler rows;
- rejects FIFO/RR rows on the predeclared fallback path;
- explicitly states that no latency or physical-machine qualification follows.

Run `34011177375` passed all of those gates.

## 11. Wrapper adversarial question

`realtime check` is invalid at the pinned revision. The correct public command is `realtime verify`; its `Verify()` path invokes `rtapi_app check_rt`. Therefore the earlier run `34008620114`, which stopped at the invalid wrapper verb, is **HARNESS INVALID** and contributes no capability evidence. The corrected run is the accepted evidence.

Evidence: `SOURCE-CONFIRMED` + `TEST-CONFIRMED` for corrected wrapper behavior.

## 12. Safety boundary

Before approving timing-sensitive physical control, additional evidence must include the actual target kernel/realtime environment, installed privilege/capability/resource-control state, observed scheduler policy/priority of LinuxCNC periodic threads, target-machine latency/jitter under representative worst-case load, hardware/driver timing behavior, fault/recovery testing, and commissioning evidence appropriate to the machine hazard analysis.

LinuxCNC functional behavior, PC realtime behavior, and functional-safety certification are separate questions. R01 does not claim LinuxCNC, HAL logic, the PC, or the cloud experiment is safety-rated.

## Adversarial grading result

The source model and accepted runtime result agree on all core R01 claims required for 1000-level graduation:

- realtime capability is demonstrated, not inferred from kernel naming;
- fallback backend/policy selection is separate from memory hardening;
- task allocation/start and actual scheduler state are separate boundaries;
- HAL period establishment/rounding and creation ordering are understood;
- absolute periodic deadlines do not guarantee latency;
- wrapper failures are not capability evidence;
- cloud observations are explicitly non-qualifying for physical-machine timing or functional safety.

No exam weakness remains that blocks R01 graduation. Cross-backend timer behavior, modern resource-control interactions, memory-lock timing consequences, and physical target qualification remain promoted advanced work.
