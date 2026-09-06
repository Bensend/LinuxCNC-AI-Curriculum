# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; development `002` passed; stable `003` passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | development `8bf4605ae81042248add031e94c77300406e0413`; stable `86cdca76fa2a36274c432caa21952b23c267989a` | covered by Phase-0 exam/handoff | Stable `v2.9.10` experimentally confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | development `002` and stable `003` ran upstream `tests/realtime-math` | Phase-0 exam/corrections complete | Results are POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised on build failures, version comparison, and evidence boundaries | Phase-0 exam/handoff complete | Evidence/conflict workflow demonstrated |
| A01 Process/component architecture | GRADUATED | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-graduation-handoff.md` | corrected bounded `004` run `34000879408` passed topology/ownership gates | adversarial exam + corrections + fresh-AI handoff complete | Runtime topology TEST-CONFIRMED for pinned uspace simulation; no realtime-performance claim |
| R01 Realtime model | GRADUATED | `guides/R01-realtime-model.md`; `call-flows/R01-uspace-periodic-task.md`; `guides/R01-period-memory-capability-boundaries.md`; `guides/R01-graduation-handoff.md` | corrected bounded `005` run `34011177375` passed capability/scheduler/period gates | `exams/R01-adversarial-exam.md` + passing `exams/R01-adversarial-answer-key.md` | Fallback scheduler/period behavior TEST-CONFIRMED for pinned Actions host; physical latency/safety explicitly excluded |
| H01 HAL architecture | PLANNED | — | — | — | **highest-priority unblocked module**; critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | critical path; depends on HAL architecture/object model |
| M03 One servo-period trace | PLANNED | — | — | — | critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Phase 0 result

Phase 0 is graduated. Development experiment `002` and stable experiment `003` both built their pinned LinuxCNC revisions and ran the selected upstream representative test successfully. Stable `003`, Actions run `33952061943`, used exact LinuxCNC `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`. No result is generalized to realtime scheduling, hardware suitability, functional safety, or full-suite compatibility.

## A01 graduated result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

Corrected run `34000879408` / job `101399404407` supplied accepted runtime-topology evidence. It observed `linuxcncsvr`, `milltask`, and `linuxcncrsh` readiness; bounded HAL probes; `motmod`, `trivkins`, and `iocontrol.0`; exactly one live `milltask`; and `iocontrol.0`'s HAL userspace PID equal to that `milltask` PID. Those facts are `TEST-CONFIRMED` for the pinned uspace simulation only. Detailed failure/harness history and fresh-AI handoff remain in the A01 guides/checkpoints.

## R01 graduated result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable source artifacts:

- `guides/R01-realtime-model.md`
- `call-flows/R01-uspace-periodic-task.md`
- `guides/R01-period-memory-capability-boundaries.md`
- `call-flows/R01-realtime-verify.md`
- `exams/R01-adversarial-exam.md`
- `exams/R01-adversarial-answer-key.md`
- `guides/R01-graduation-handoff.md`

Core source conclusions:

- uspace is not synonymous with realtime-qualified execution;
- pinned `rtapi_get_realtime_type()` uses demonstrated `SCHED_FIFO` acquisition as the capability gate before selecting a realtime-capable path;
- `REALTIME_TYPE_NONE` maps through `makeApp()` to the POSIX backend with `SCHED_OTHER`;
- scheduler privilege/resource-control and realtime memory hardening are separate boundaries;
- `rtapi_task_new()` allocation/validation is separate from `rtapi_task_start()` pthread creation and actual scheduling;
- POSIX periodic waits use absolute `CLOCK_MONOTONIC` deadlines, which avoid simple relative-sleep drift but do not guarantee deadline wakeup;
- the pinned uspace POSIX backend stores the first requested base period exactly; HAL rounds later requested periods to nearest base-period multiples, requires nondecreasing rounded periods in creation order, and assigns later threads lower RTAPI priorities;
- runtime-reported realtime type, actual pthread policy/priority, memory-lock state, measured latency/jitter, hardware timing, and functional safety are separate evidence classes.

### Accepted R01 experiment `005`

The first attempt, run `34008620114`, is **HARNESS INVALID** because it invoked nonexistent public wrapper command `realtime check`. Pinned `scripts/realtime.in` uses `realtime verify`, whose `Verify()` invokes `rtapi_app check_rt`.

Corrected run `34011177375`, job `101427172728`, curriculum SHA `ac479678abec2e4933447b1d5d03eb51c7569fc6`, completed successfully with fresh metadata naming `lab-jobs/005-r01-realtime-boundaries.sh`.

Accepted runtime observations:

- `realtime-verify-rc=1` and explicit `No realtime`;
- HAL `r01fast` period `1000000` ns and `r01slow` period `2000000` ns;
- exactly one `rtapi_app` master;
- periodic pthreads `rtapi_app:T#0` and `rtapi_app:T#1` present;
- both periodic pthreads reported ordinary `TS` scheduling rather than FIFO/RR;
- no `mlockall` warning was emitted, explicitly treated as insufficient to infer lock success;
- explicit successful-completion marker reached.

Those observations are `TEST-CONFIRMED` only for this pinned build/Actions host. They do not qualify physical-machine latency, jitter, deterministic timing, hardware suitability, or functional safety.

### R01 adversarial/fresh-AI result

The adversarial exam is passed and reconciled with the accepted runtime result. `exams/R01-adversarial-answer-key.md` covers PREEMPT_RT inference, scheduler-vs-memory boundaries, HAL period quantization/order, task-new versus task-start, absolute deadlines versus determinism, cgroup/resource-control interpretation, invalid wrapper commands, and physical-machine/safety boundaries.

`guides/R01-graduation-handoff.md` passes the fresh-AI sufficiency check for the 1000-level objective and unblocks H01.

## R01 higher-level promotion / uncertainty queue

- Exact timer/base-period behavior across RTAI/Xenomai/uspace backends: **2000 / MEDIUM**; does not block R01 because backend scope is explicit.
- Modern cgroup/systemd RT-runtime interactions across supported distributions: **2000 / HIGH**; current R01 teaches observation of actual scheduler acquisition.
- Quantitative impact of failed memory locking on deadline misses: **2000 / HIGH**; requires controlled target experiments.
- Physical-machine latency/jitter qualification under representative worst-case load: **advanced commissioning / CRITICAL**; cloud results are explicitly non-qualifying.
- Functional-safety architecture and machine hazard analysis: **advanced safety / CRITICAL**; LinuxCNC functional behavior is not safety certification.

## Laboratory compute-budget checkpoint

September 6 laboratory use includes the short accepted A01 `004` run `34000879408`, invalid R01 attempt `34008620114`, and corrected accepted R01 `005` run `34011177375`. No further R01 run is justified; the accepted result resolved the 1000-level runtime question.

## Current checkpoint / exact resume point

R01 is **GRADUATED**. Continue **H01 — HAL architecture and object model**.

1. Establish intended HAL object/lifecycle behavior from current official documentation.
2. Search relevant LinuxCNC developer/community material for object/shared-memory/locking pitfalls and historical model changes.
3. At pinned development revision `8bf4605ae81042248add031e94c77300406e0413`, inventory the shared HAL structures and APIs for components, pins, signals, parameters, and functions.
4. Trace one complete lifecycle from `hal_init()` through object registration and `hal_ready()` into `halcmd` observation, identifying process, shared-memory and mutex boundaries.
5. Build the H01 function/symbol and call-flow guides before designing the next bounded experiment.
