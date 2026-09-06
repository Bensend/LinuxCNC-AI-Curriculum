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
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367`, job `101461896527`, SHA `f15451ee...` passed all gates | passed | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | GRADUATED | M03 source/call-flow/accepted-result/handoff guides | `008` run `34029848545`, job `101477262140`, SHA `10f187e8...` passed all gates | passed | canonical loopback phase relationship TEST-CONFIRMED; not universal latency |
| HM01 HostMot2 architecture | EXPERIMENT | `guides/HM01-hostmot2-registration-initial.md`; `call-flows/HM01-lowlevel-registration-lifecycle.md` | `009` run `34035539216`, job `101492796989`, SHA `84a65ff9...` in progress | pending | LLIO contract, concrete hm2_eth handoff, GTAG dispatch, rollback and upstream fake-LLIO test path source-traced |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path after HM01 |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Graduated evidence summary

A01 accepted run `34000879408` confirmed the required process/HAL topology for its pinned simulation. R01 corrected run `34011177375` confirmed explicit non-realtime fallback, expected HAL periods, and TS scheduling for periodic pthreads. H01 corrected run `34018699909` confirmed dummy/signal linkage semantics, second-writer rejection and cyclic function execution. H04 run `34024102367` confirmed same-thread configured function order drives same-cycle dataflow, while cross-thread ordering/live mutation remained outside the promoted claim. M03 run `34029848545` confirmed the canonical direct motor-command→feedback loopback phase relationship while explicitly rejecting a universal latency claim. None of these cloud results is physical-machine realtime or safety qualification.

## HM01 current result

HM01 is the active critical-path module and has advanced to `EXPERIMENT`.

Durable source artifacts:

- `guides/HM01-hostmot2-registration-initial.md`
- `call-flows/HM01-lowlevel-registration-lifecycle.md`
- `lab-jobs/009-hm01-registration-validation.sh`
- `checkpoints/HM01-2026-09-06T1315Z-registration-validation-launched.md`

Current source-grounded conclusions at `8bf4605...`:

- generic `hostmot2` and low-level board/transport drivers are distinct layers;
- `hm2_lowlevel_io_t` contains required `read`/`write` callbacks, optional firmware/reset hooks, optional queued/split-I/O hooks, connector/board metadata, capability flags, I/O-error/reset bookkeeping, and a private low-level-driver instance pointer;
- missing supported queued callbacks are replaced by synchronous wrappers around required read/write callbacks, preserving the generic orchestration path;
- pinned `hm2_eth` populates its LLIO read/write, queued-I/O and reset callbacks and then calls `hm2_register(&board->llio, config[boards_count])`; Ethernet packet mechanics remain E01+ scope;
- `hm2_register()` validates LLIO, allocates/tentatively lists a per-board `hostmot2_t`, parses configuration, optionally programs firmware, validates firmware identity/IDROM/descriptors, initializes module/TRAM/HAL state, synchronizes initial state, then exports board-cycle HAL functions;
- `hm2_parse_module_descriptors()` handles IOPort first, then dispatches recognized GTAGs to module parsers; negative parser return or LLIO `io_error` aborts registration; unknown GTAGs are warned/ignored rather than automatically fatal;
- failures after module initialization converge through `hm2_cleanup()` before list removal/free, while earlier failures may go directly to list removal/free;
- `hm2_unregister()` performs generic teardown and includes the already-noted watchdog action when a watchdog instance exists, but HM01 makes no safety-rated claim from it;
- pinned upstream `tests/hm2-idrom` explicitly tests `hm2_register()` using `hm2_test`, a fake no-hardware AnyIO register file, making it the preferred foundation experiment.

### HM01 experiment state

Exactly one `009` experiment was launched by commit `84a65ff98d495001a487b8df33853791d1ee3387`:

- run `34035539216`
- job `101492796989`
- state at latest inspection: `in_progress`, executing the bounded lab step.

Do not start a duplicate run merely because another lesson starts. The acceptance gates are preserved in `checkpoints/HM01-2026-09-06T1315Z-registration-validation-launched.md`.

A passing `009` can promote fake-LLIO registration validation/rejection behavior to `TEST-CONFIRMED`; it cannot establish successful physical-board registration, Ethernet timing, realtime deadlines, TRAM ordering, watchdog safety or functional safety.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and unusual cross-process mappings: **2000 / MEDIUM**.
- Recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions: **2000 / HIGH**.
- Stable/development ready/unready and object-lifetime comparison: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal visibility/cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` versus stable: **2000 / MEDIUM**.
- M03 Task-side command-mutex hold duration and command-to-echo latency distribution: **2000 / HIGH** unless needed earlier.
- M03 full planner/kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**.
- M03 cross-thread/base-thread exchange timing: **2000 / HIGH** unless required earlier.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- HM01 successful fake-board registration fixture extension: **HM02 or 2000 / MEDIUM**; not required because HM01 successful architecture is source-confirmed and the upstream fixture is rejection-oriented.
- HM01 hotplug/re-registration/partial-failure lifetime edges: **2000 / MEDIUM-HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **HM01 — HostMot2 architecture and registration lifecycle** by inspecting Actions run `34035539216`, job `101492796989`, before launching anything else.

If the run passes, require all gates in `checkpoints/HM01-2026-09-06T1315Z-registration-validation-launched.md`, write an accepted result, reconcile any discrepancy, create/grade the HM01 adversarial exam, and perform the fresh-AI handoff/graduation decision. If it is harness-invalid, correct only log-proven harness defects and launch at most one materially corrected retry. After HM01 graduation, advance to **E01 — hm2_eth architecture and board discovery/registration ownership**.
