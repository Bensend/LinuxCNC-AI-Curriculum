# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; development `002` passed; stable `003` passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | development `8bf4605ae81042248add031e94c77300406e0413`; stable `86cdca76fa2a36274c432caa21952b23c267989a` | covered by Phase-0 exam/handoff | Stable `v2.9.10` experimentally confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | development `002` and stable `003` ran upstream `tests/realtime-math` | Phase-0 exam/corrections complete | Results are POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised on build failures, version comparison, and evidence boundaries | Phase-0 exam/handoff complete | Evidence/conflict workflow demonstrated |
| A01 Process/component architecture | GRADUATED | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-graduation-handoff.md` | corrected bounded `004` run `34000879408` passed all predeclared topology/ownership gates | adversarial exam + corrections + fresh-AI handoff audit complete | Runtime topology is TEST-CONFIRMED for pinned uspace simulation; no realtime-performance claim |
| R01 Realtime model | RESEARCH | `guides/R01-realtime-model.md` | not yet designed | — | A01 graduated; initial docs/community/source inventory begun |
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

## R01 initial result

R01 became the highest-priority unblocked module after A01 graduation. Initial research is committed in `guides/R01-realtime-model.md`.

Current documentation/source findings:

- `hal_create_thread()` creates periodic HAL realtime threads; documented period rounding and creation-order priority behavior must be verified against pinned source.
- uspace is not synonymous with realtime-qualified execution. Current LinuxCNC documentation distinguishes realtime-capable uspace from simulated/non-realtime uspace behavior and states that `rtapi_app` privileges/capabilities and the running kernel affect realtime capability reporting.
- Current `halcmd` documentation explicitly allows `rtapi_app` to create a simulated realtime environment on systems without userspace realtime support.
- Pinned `src/rtapi/rtapi.h` declares the backend-independent task API; pinned `src/rtapi/uspace_rtapi_main.cc` implements `rtapi_task_new()` as a wrapper into `App().task_new(...)`, while `src/rtapi/rtai_rtapi.c` has a separate backend implementation.
- Community latency reports are preserved only as investigation leads; PREEMPT_RT naming or successful LinuxCNC startup is not accepted as a universal latency guarantee.

## Laboratory compute-budget checkpoint

Target laboratory compute is at most approximately four GitHub Actions hours per calendar day. September 6 has consumed one short accepted A01 run (`34000879408`, roughly 3.6 minutes of experiment wall time). No additional lab is currently justified until R01 source analysis identifies a bounded discriminating observation.

## Current checkpoint / exact resume point

Continue **R01 — Realtime model**; A01 is graduated.

1. At pinned commit `8bf4605ae81042248add031e94c77300406e0413`, trace `rtapi_task_new()` and `rtapi_task_start()` through the uspace backend (`App().task_new` and related task/start/wait implementation).
2. Record the exact scheduling-policy and priority setup, periodic wait mechanism, privilege/capability and memory-locking requirements, failure behavior, and representation of non-realtime fallback.
3. Trace `hal_create_thread()` into RTAPI task creation far enough to reconcile the documented period rounding and fastest-to-slowest/rate-monotonic priority rule with pinned source.
4. Maintain separate evidence classes for: source path; runtime-reported realtime type/capability; observed scheduler policy/priority; and measured latency/jitter under load.
5. Only after the source trace, design a small bounded R01 experiment that distinguishes simulated uspace from realtime-capable uspace without treating the GitHub host as realtime-qualified.
6. Preserve any version-sensitive RTAI/uspace differences rather than forcing one backend's implementation model onto the other.
