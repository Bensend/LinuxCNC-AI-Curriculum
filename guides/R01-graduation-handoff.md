# R01 — Graduation handoff: LinuxCNC realtime model

Primary pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.
Accepted bounded runtime experiment: Actions run `34011177375`, job `101427172728`, curriculum SHA `ac479678abec2e4933447b1d5d03eb51c7569fc6`.

Status: **GRADUATED (1000-level)**.

## What a fresh AI must know

LinuxCNC's `uspace` build/runtime model must not be equated with realtime qualification. At this pinned revision, realtime capability selection begins with an actual `SCHED_FIFO` acquisition attempt. If that capability test fails, `REALTIME_TYPE_NONE` selects the POSIX backend with ordinary `SCHED_OTHER` scheduling. Kernel labels, PREEMPT_RT metadata, package presence, or a successful build are not substitutes for observing the runtime path.

`rtapi_task_new()` and `rtapi_task_start()` are different boundaries. Allocation/validation can succeed before any pthread exists. The later start path configures explicit scheduling attributes/policy/priority and optional affinity and only then creates the pthread. Actual OS scheduler state is therefore a separate evidence point from requested RTAPI priority.

The pinned POSIX periodic path uses absolute `CLOCK_MONOTONIC` deadlines. Absolute deadlines avoid simple relative-sleep drift but do not guarantee timely wakeup, bounded jitter, or machine suitability.

HAL thread-period behavior also has two layers. The backend establishes the base period; the pinned uspace POSIX backend stores the first requested nonzero base period exactly. HAL then rounds later requested periods to the nearest integer multiple of that base and rejects creation order that would place a faster rounded thread after a slower existing one. Later threads receive lower RTAPI priority.

Scheduler privilege/resource-control and memory hardening are separate. Failure to acquire FIFO leads to the ordinary fallback path. On the realtime-capable hardening path, memory locking and associated capability/rlimit work are separate operations; an `mlockall()` failure does not itself select `SCHED_OTHER`. Conversely, the `REALTIME_TYPE_NONE` path does not call the realtime hardening path.

## Accepted laboratory evidence

Run `34011177375` is accepted because its metadata is fresh and names the intended `005` job and corrected curriculum SHA. The workflow completed successfully.

The observed runtime facts were:

- `realtime verify` returned `1` with explicit `No realtime`;
- the harness therefore stayed on its predeclared non-realtime fallback interpretation rather than silently relabeling the host;
- HAL reported `r01fast` at 1,000,000 ns and `r01slow` at 2,000,000 ns;
- exactly one `rtapi_app` master was found;
- periodic task pthreads `rtapi_app:T#0` and `rtapi_app:T#1` were present;
- both periodic task rows showed ordinary `TS` scheduling rather than FIFO/RR;
- no `mlockall` failure message was observed, and the harness correctly refused to infer lock success from that absence;
- the experiment ended with its explicit successful-completion marker.

These facts are `TEST-CONFIRMED` only for the pinned build and GitHub Actions host. They do **not** qualify latency, jitter, physical hardware timing, deterministic machine behavior, or functional safety.

## Harness correction history

The first `005` attempt, run `34008620114`, used invalid public wrapper command `realtime check`. Pinned `scripts/realtime.in` accepts `verify`, and `Verify()` invokes `rtapi_app check_rt`. The first run is therefore **HARNESS INVALID** and supplies no realtime-capability evidence. The corrected harness also fails closed if a future host unexpectedly takes a realtime-capable scheduler path.

## Adversarial exam result

`exams/R01-adversarial-answer-key.md` records the passing grading result. The exam specifically attacks:

- PREEMPT_RT/kernel-label inference;
- scheduler capability versus memory locking;
- HAL period quantization and creation order;
- task allocation versus pthread start;
- absolute deadline versus determinism claims;
- cgroup/resource-control failure interpretation;
- invalid wrapper-command evidence;
- cloud versus physical-machine/safety boundaries.

No discovered weakness invalidates the 1000-level realtime model.

## Promotion / uncertainty queue

The following are intentionally deferred rather than papered over:

- **2000 / MEDIUM:** exact base-period/timer behavior across RTAI, Xenomai and other backend/version combinations;
- **2000 / HIGH:** modern systemd/cgroup realtime-runtime interactions across supported distributions;
- **2000 / HIGH:** quantitative timing consequences of memory-lock failure under controlled workloads;
- **advanced commissioning / CRITICAL:** physical target-machine latency/jitter qualification under representative worst-case load;
- **advanced safety / CRITICAL:** machine hazard analysis and functional-safety architecture. R01 provides no safety certification.

These do not block R01 because its 1000-level objective is to understand the LinuxCNC realtime model, scheduler/backend boundaries, HAL period model, and evidence needed to distinguish capability from qualification.

## Fresh-AI handoff test

A fresh AI using only the R01 guides/call flows, accepted lab record, exam/answer key, and pinned source should be able to:

1. explain why a uspace build can run non-realtime;
2. trace capability selection into backend scheduler policy;
3. separate scheduler privilege from memory locking;
4. explain task-new versus task-start and inspect actual pthread policy;
5. calculate HAL nearest-multiple period rounding and creation-order constraints;
6. explain why absolute sleeps do not prove deterministic timing;
7. design a bounded observation that fails closed on an unexpected scheduler path;
8. refuse to use cloud observations as physical-machine qualification or functional-safety evidence.

That handoff is sufficient for downstream **H01 — HAL architecture** and later **H04 — HAL execution ordering**, which can rely on R01's thread/backend/evidence boundaries without reopening the realtime model.

## Next dependency checkpoint

R01 is graduated. The highest-priority newly unblocked module is **H01 — HAL architecture and object model**. Begin with official HAL documentation and current community/developer material, then pin the object/shared-memory implementation and trace component/pin/signal/parameter/function registration through `hal_init()`/`hal_ready()` and shared HAL data structures before designing H01 experiments.
