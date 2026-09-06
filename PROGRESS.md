# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; development `002` passed; stable `003` passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | development `8bf4605ae81042248add031e94c77300406e0413`; stable `86cdca76fa2a36274c432caa21952b23c267989a` | covered by Phase-0 exam/handoff | Stable `v2.9.10` experimentally confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | development `002` and stable `003` ran upstream `tests/realtime-math` | Phase-0 exam/corrections complete | Results are POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised on build failures, version comparison, and evidence boundaries | Phase-0 exam/handoff complete | Evidence/conflict workflow demonstrated |
| A01 Process/component architecture | GRADUATED | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-graduation-handoff.md` | corrected bounded `004` run `34000879408` passed all predeclared topology/ownership gates | adversarial exam + corrections + fresh-AI handoff audit complete | Runtime topology is TEST-CONFIRMED for pinned uspace simulation; no realtime-performance claim |
| R01 Realtime model | EXPERIMENT | `guides/R01-realtime-model.md`; `call-flows/R01-uspace-periodic-task.md`; `guides/R01-period-memory-capability-boundaries.md` | bounded `005` run `34008620114` launched once; result pending; harness audit found `realtime check` should be `realtime verify` | — | Source model now separates realtime-type selection, scheduler policy, memory hardening, HAL period quantization, and measured latency |
| H01 HAL architecture | PLANNED | — | — | — | blocked on R01 graduation; critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | critical path |
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

Source-confirmed findings include:

- `scripts/linuxcnc.in` starts `linuxcncsvr` first because it creates/owns NML buffers, starts RTAPI/HAL infrastructure, and later starts configured Task; normal HAL configuration loads kinematics/motmod.
- `src/emc/task/Submakefile` links `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc`, and related sources into `milltask`.
- UI/external control to Task uses NML channels (`emcCommand`, `emcStatus`, `emcError`).
- Task to realtime motion uses RTAPI shared `emcmot_struct_t`; `usrmotWriteEmcmotCommand()` copies under `command_mutex` and waits for matching `commandNumEcho`.
- `motion.c` exports `emcmotCommandHandler` as HAL function `motion-command-handler`; `command.c::emcmotCommandHandler()` try-locks the command mutex, observes new command numbers, echoes them, initializes `commandStatus`, and dispatches commands.
- Command-number echo is acknowledgement/observation, not proof of command success; userspace separately evaluates `commandStatus`.
- `Task::Task()` executes `hal_init("iocontrol.0")`; `Task::iocontrol_hal_init()` exports the `iocontrol.0.*` pins and calls `hal_ready()`.
- In the userspace/ULAPI `hal_init()` path, the HAL component record stores `comp->pid = getpid()`. `halcmd show comp` exposes that PID for userspace components.

Older community explanations that describe task/iocontrol as separate conceptual modules remain version/history leads and do not override pinned source.

### Accepted runtime observation

Corrected run `34000879408`, job `101399404407`, curriculum head `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`, produced artifact `linuxcnc-lab-004-a01-runtime-topology-34000879408-1` and exited `0`. Its fresh metadata identifies `lab-jobs/004-a01-runtime-topology.sh` and the pinned upstream commit.

Before cleanup, the run observed:

- `linuxcncsvr`, `milltask`, and `linuxcncrsh` readiness;
- bounded HAL readiness, `list comp`, and `list funct` probes all returning `rc=0` with no forced HAL-probe kill;
- HAL components including `motmod`, `trivkins`, and `iocontrol.0`;
- execution of `Key component assertions`;
- exactly one live `milltask` PID `17515`;
- `halcmd show comp iocontrol.0` reporting userspace PID `17515`, exactly matching the live `milltask` PID;
- no standalone `iocontrol` process;
- successful completion marker.

Those runtime-topology facts are promoted to `TEST-CONFIRMED` for this pinned uspace simulation. The GitHub runner remains explicitly non-qualifying evidence for realtime latency, deterministic scheduling, hardware timing, or functional safety.

After the accepted assertions, bounded cleanup observed that the top-level `linuxcnc` launcher did not exit within the TERM window and forced launcher exit after preserving a snapshot. This post-assertion shutdown observation does not invalidate the accepted topology evidence.

Full graduation evidence and fresh-AI audit: `guides/A01-graduation-handoff.md`.

## A01 experiment history / integrity corrections

- Run `33957356410` reached the former 60-minute workflow ceiling before valid topology assertions. It exposed a stale-artifact bug: inherited `LATEST.*` could be uploaded after cancellation. The runner was hardened to delete inherited `LATEST.*` before execution.
- Run `33960179986` also reached 60 minutes before valid assertions.
- Run `33965517203` (job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`) reached the 75-minute ceiling. Cleanup logs found live `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh`, proving the build had reached runtime. No fresh `004` assertions were produced, so it is not topology-confirming evidence.
- Pinned-source/adversarial work established that `halcmd_main.c::main()` calls `halcmd_startup(0)` before command dispatch; both registration and later list queries can encounter the shared HAL metadata mutex. Whole-command timeout alone therefore cannot localize a stall.
- The corrected harness bounded every HAL probe, preserved the original stalled PID for diagnostic capture, treated any force-killed HAL participant as terminal for later HAL evidence, bounded launcher teardown, fixed `set -e` status-capture hazards, used merge-safe push-range job selection, and required all three controller/display readiness markers.
- Direct `iocontrol.0` ownership verification was added because component presence plus absence of a standalone process was weaker than comparing HAL's recorded userspace PID to the live `milltask` PID.
- PR #1 merged only the audited workflow and `004` executable delta to `main` as `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`; the resulting run `34000879408` supplied the accepted evidence.

## R01 current result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

R01 became the highest-priority unblocked module after A01 graduation. The current durable source artifacts are `guides/R01-realtime-model.md`, `call-flows/R01-uspace-periodic-task.md`, and `guides/R01-period-memory-capability-boundaries.md`.

Current documentation/source findings:

- uspace is not synonymous with realtime-qualified execution. Current LinuxCNC documentation distinguishes realtime-capable uspace from simulated/non-realtime uspace behavior.
- Pinned `rtapi_get_realtime_type()` attempts an actual `sched_setscheduler(..., SCHED_FIFO, ...)` transition before selecting a realtime-capable path; failure selects `REALTIME_TYPE_NONE` unless the explicit testing override is used.
- `makeApp()` maps `REALTIME_TYPE_NONE` directly to the POSIX backend with `SCHED_OTHER`. Realtime-capable paths invoke `harden_rt()` first and use an appropriate SCHED_FIFO/backend implementation.
- `rtapi_task_new()` delegates to `App().task_new(...)`; task allocation/validation is separate from pthread creation. `rtapi_task_start()` delegates to backend start logic that explicitly sets pthread scheduling policy/priority and optional CPU affinity.
- The POSIX periodic wait uses absolute `CLOCK_MONOTONIC` deadlines with `TIMER_ABSTIME`; absolute scheduling avoids simple relative-sleep drift but does not guarantee timely wakeup.
- In POSIX non-realtime fallback, the backend runs under `SCHED_OTHER` and additionally uses its thread-lock serialization path rather than pretending FIFO scheduling exists.
- For the first HAL thread, `hal_create_thread()` establishes/queries the RTAPI base period. In the pinned uspace POSIX backend, first nonzero `RtapiApp::clock_set_period()` stores the requested nanoseconds exactly; other RTOS backends may quantize and remain version/backend-specific.
- HAL rounds each requested thread period to the nearest integer multiple of `hal_data->base_period` with `(requested + base/2) / base`, rejects a rounded period shorter than the previously created thread, and assigns each later thread `rtapi_prio_next_lower()`.
- Scheduler privilege and memory hardening are separate. `CAP_SYS_NICE`/scheduler policy controls FIFO acquisition; the realtime-capable hardening path separately attempts MEMLOCK/`CAP_IPC_LOCK`, `mlockall`, page pre-touch, RTPRIO/CORE adjustments, I/O privilege, and CPU DMA latency controls. Failure of `mlockall()` warns but is not the fallback selector; moreover the `REALTIME_TYPE_NONE` branch skips `harden_rt()` entirely.
- LinuxCNC issue #2821 is retained as `COMMUNITY-REPORTED` evidence that cgroup RT-runtime policy can cause actual `sched_setscheduler(SCHED_FIFO)` to fail with `EPERM` despite an expected realtime setup. It is a diagnostic lead, not a universal current-distro recipe.
- Runtime-reported realtime type, actual pthread policy/priority, memory-lock state, and measured latency/jitter remain separate evidence classes. GitHub Actions cannot qualify a physical machine for realtime performance.

### R01 experiment 005

`lab-jobs/005-r01-realtime-boundaries.sh` was committed at curriculum SHA `118d9ceda4377e39b667921cd729268ffc3b3984`, triggering exactly one Actions run `34008620114` / job `101420312096`. The experiment predeclares POSIX non-realtime/SCHED_OTHER behavior on the ordinary Actions host and records HAL thread periods plus scheduler state without making a latency qualification claim.

A post-launch source audit found a harness defect before the result was interpreted: pinned `scripts/realtime.in` accepts the subcommand `verify`, whose `Verify()` calls `rtapi_app check_rt`; the launched script currently invokes invalid `realtime check`. While run `34008620114` remains active, no second run will be triggered. If it fails at that command, the attempt is classified **HARNESS INVALID** and supplies no realtime-behavior evidence. The exact correction/resume rule is preserved in `checkpoints/R01-2026-09-06T0314Z-lab-harness-audit.md`.

## R01 higher-level promotion / uncertainty queue

- Exact timer/base-period behavior across RTAI/Xenomai/uspace backends: promote to 2000, MEDIUM; does not block 1000-level R01 if backend scope stays explicit.
- Modern cgroup/systemd RT-runtime interactions across supported distributions: promote to 2000, HIGH; current R01 teaches actual scheduler acquisition rather than metadata inference.
- Quantitative impact of failed memory locking on deadline misses: promote to 2000, HIGH; requires controlled target experiments.
- Physical-machine latency qualification under realistic load: promote to advanced/commissioning work, CRITICAL safety/reliability consequence; cloud results are explicitly non-qualifying and therefore do not block the conceptual 1000-level model.

## Laboratory compute-budget checkpoint

`CURRICULUM.md` now permits up to approximately eight GitHub Actions laboratory hours per calendar day during the first-draft sprint, within the overall project budget. September 6 has consumed one short accepted A01 run (`34000879408`, roughly 3.6 minutes of experiment wall time) plus the single currently active R01 `005` run `34008620114`. Do not launch a duplicate while it is running.

## Current checkpoint / exact resume point

Continue **R01 — Realtime model**; A01 is graduated.

1. Inspect Actions run `34008620114` / job `101420312096` to completion and require fresh `005` metadata/source SHA before using any observation.
2. If the run fails at `realtime check`, classify it HARNESS INVALID, correct only to the pinned public command `realtime verify` plus any other log-proven harness defects, and permit one materially corrected rerun rather than weakening the prediction.
3. If it reaches runtime observations, reconcile selected realtime type, HAL-reported thread periods, and actual periodic pthread scheduler class separately before promoting `TEST-CONFIRMED` claims.
4. Then write the R01 adversarial exam around misleading “PREEMPT_RT means deterministic”, scheduler-vs-memory-lock failure boundaries, period rounding/order, and a configuration/debugging scenario.
5. Apply exam/experiment corrections, perform fresh-AI handoff, and graduate R01 when remaining advanced uncertainties are explicitly promoted and no core conceptual/safety conclusion remains unsupported.
