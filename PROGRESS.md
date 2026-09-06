# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | `guides/Phase0-graduation-handoff.md` | `000`, `001`, development `002`, stable `003` passed | Phase-0 exam complete | Actions is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | dev `8bf4605...`; stable `86cdca76...` | Phase-0 | stable v2.9.10 confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | representative upstream test passed | Phase-0 | POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised | Phase-0 | evidence/conflict workflow demonstrated |
| A01 Process/component architecture | GRADUATED | A01 architecture/call-flow/handoff guides | corrected `004` run `34000879408` | passed | topology/ownership TEST-CONFIRMED for pinned simulation |
| R01 Realtime model | GRADUATED | R01 model/call-flow/boundary/handoff guides | corrected `005` run `34011177375` | passed | fallback scheduler/period behavior confirmed; no physical latency claim |
| H01 HAL architecture | GRADUATED | H01 lifecycle/call-flow/community/handoff guides | corrected `006` run `34018699909`, job `101447160463`, SHA `43fae7ea...` passed all gates | passed | object/connectivity semantics TEST-CONFIRMED for pinned host |
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367`, job `101461896527`, SHA `f15451ee...` passed all gates | `exams/H04-adversarial-exam.md` + passing key | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | EXPERIMENT | `guides/M03-servo-period-trace-initial.md`; `call-flows/M03-one-servo-period.md` | `008` run `34029848545`, job `101477262140`, SHA `10f187e8...` in progress | pending | exact feedback sampling/output publication traced; one-cycle canonical loopback hypothesis under test |
| HM01 HostMot2 architecture | PLANNED | — | — | — | critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Graduated evidence summary

Primary development revision remains `8bf4605ae81042248add031e94c77300406e0413`; stable reference remains `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

A01 accepted run `34000879408` observed the required process readiness, bounded HAL topology, `motmod`, `trivkins`, `iocontrol.0`, exactly one live `milltask`, and `iocontrol.0` HAL PID equal to the `milltask` PID. R01 accepted corrected run `34011177375` observed explicit non-realtime fallback, expected HAL periods, and actual TS scheduling for periodic pthreads. Neither result is a physical-machine realtime or safety qualification.

H01 accepted corrected run `34018699909` confirmed dummy→signal value preservation, linked propagation, unlink snapshot/separation, second-writer rejection, cyclic function scheduling, and positive thread execution on the pinned host. H01 graduated with its adversarial exam and fresh-AI handoff.

## H04 graduated result

Durable artifacts:

- `guides/H04-hal-execution-ordering.md`
- `forum-findings/H04-execution-ordering-field-notes.md`
- `call-flows/H04-addf-to-thread-dispatch.md`
- `lab-jobs/007-h04-execution-ordering.sh`
- `lab-results/H04-007-execution-ordering-accepted.md`
- `exams/H04-adversarial-exam.md`
- `exams/H04-adversarial-answer-key.md`
- `guides/H04-graduation-handoff.md`

Accepted `007` artifact metadata: curriculum SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418`, Actions run `34024102367`, job `101461896527`, lab UTC `2026-09-06T09:14:59Z`–`09:19:17Z`, exit 0. Phase 1 displayed `sum2.0` before `sum2.1` and observed A=37, B=38, `B-A=1`. Duplicate non-reentrant add failed intentionally with rc=1 and the expected diagnostic. While stopped, threadbeat remained 19→19. After stopped delete/re-add at position +1, phase 2 displayed `sum2.1` before `sum2.0` and observed A=77, B=76, `A-B=1`, threadbeat=39. Completion marker was present.

The central H04 conclusion is therefore source-confirmed and test-confirmed at foundation depth: within one HAL thread pass, scheduled function entries execute sequentially in list order strongly enough for ordinary later-function dataflow to observe earlier-function updates. This does not create a total order across separate HAL threads and does not establish realtime deadlines, physical timing, safety, or safe live list mutation.

## M03 current result

M03 is now the active critical-path module. Initial documentation/community/source work is in `guides/M03-servo-period-trace-initial.md`; the first complete foundation call flow is in `call-flows/M03-one-servo-period.md`.

Current source-grounded conclusions at `8bf4605...`:

- `motmod` `init_threads()` creates the floating-point `servo-thread` and exports `motion-controller` / `motion-command-handler`; it does not itself schedule those functions with `addf`.
- `emcmotCommandHandler()` uses a nonblocking command-mutex attempt. If Task owns the command mutex, that servo invocation does not block waiting for Task; command processing is deferred. New commands are recognized by `emcmotCommand->commandNum != emcmotStatus->commandNumEcho`; accepted processing echoes command/code and command number into status.
- `emcmotController()` has an explicit top-level sequence: homing inputs -> kinematics-switch handling -> `process_inputs()` -> forward kinematics -> probe input -> fault/mode/jog/homing work -> planner/setpoint generation -> screw compensation/external offset -> `output_to_hal()` -> homing outputs -> status publication -> heartbeat/tail completion.
- `process_inputs()` samples `joint.N.motor-pos-fb` from HAL near the beginning of the controller invocation. In the ordinary non-index-search path, joint feedback is motor feedback minus backlash/motor offset; homing index search has a deliberate exception.
- `output_to_hal()` later forms normal `joint.N.motor_pos_cmd = pos_cmd + backlash_filt + motor_offset` and publishes `joint.N.motor-pos-cmd`, `joint.N.pos-cmd`, and `joint.N.pos-fb`.
- Therefore a feedback producer scheduled before `motion-controller` can affect that controller invocation, while a producer scheduled after motion cannot be observed by motion until a later invocation.
- The pinned `tests/linuxcncrsh/lcncrsh_sim.hal` loopback connects `joint.0.motor-pos-cmd` directly to `joint.0.motor-pos-fb`. Source ordering predicts that a sampler scheduled after motion will see `joint.0.pos-fb[n] ~= motor-pos-cmd[n-1]` during zero-compensation motion, while `joint.0.pos-cmd[n] ~= motor-pos-cmd[n]`.

Bounded experiment `lab-jobs/008-m03-servo-cycle-loopback.sh` was committed at SHA `10f187e8a33b741f9af5c12975150ddbb497af1a` and automatically launched as Actions run `34029848545`, job `101477262140`. It instruments the canonical linuxcncrsh simulation with `sampler`, schedules the sampler after `motion-controller`, commands a slow MDI X move, and compares lagged versus same-sample relationships. No TEST-CONFIRMED M03 runtime claim is promoted until that exact artifact is reconciled.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and cross-process unusual mapping behavior: **2000 / MEDIUM**.
- Robust recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions across supported architectures: **2000 / HIGH**.
- Stable-vs-development comparison of ready/unready and object lifetime semantics: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation race/support semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal memory visibility and cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` behavior versus stable 2.9.x: **2000 / MEDIUM**.
- M03 Task-side command mutex hold duration and command-to-echo latency distribution: **2000 / HIGH** unless needed by R05/T02 sooner.
- M03 full coordinated/free/teleop planner and kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**; not required for foundation phase ordering.
- M03 cross-thread/base-thread exchange timing: **2000 / HIGH** unless required to make the one-servo-thread trace correct.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL** and requires representative hardware/human involvement.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC functional behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **M03 — one servo-period source-level trace**.

1. Inspect exactly Actions run `34029848545`, job `101477262140`, source SHA `10f187e8a33b741f9af5c12975150ddbb497af1a`; do not launch a duplicate while it is active.
2. Require fresh metadata, configured `motion-command-handler < motion-controller < sampler.0` order, zero sampler overruns, at least 100 moving samples, lag error within the declared bound, materially worse same-sample feedback error, same-sample joint-command/motor-command agreement, and the completion marker.
3. If the harness fails before semantic observation, classify HARNESS INVALID and make only log-proven corrections before one materially corrected rerun. If the measured relationship contradicts the source prediction, preserve the artifact and investigate rather than weakening the assertion.
4. If valid, promote only the canonical-loopback phase relationship to TEST-CONFIRMED, write the M03 accepted result, then create/grade the M03 adversarial exam, corrections, fresh-AI handoff, and graduation sufficiency decision.
5. After M03 graduation, resume the critical path at **HM01 — HostMot2 architecture and registration lifecycle**.
