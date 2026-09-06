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
| H01 HAL architecture | GRADUATED | H01 lifecycle/call-flow/community/handoff guides | corrected `006` run `34018699909` | passed | object/connectivity semantics TEST-CONFIRMED for pinned host |
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367` | passed | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | GRADUATED | M03 source/call-flow/accepted-result/handoff guides | `008` run `34029848545` | passed | canonical loopback phase relationship TEST-CONFIRMED; not universal latency |
| HM01 HostMot2 architecture | GRADUATED | `guides/HM01-graduation-handoff.md`; call flow + accepted result | corrected `009` run `34038328272` | passed | fake-LLIO malformed-registration rejection TEST-CONFIRMED; no physical transport/safety claim |
| E01 hm2_eth architecture | GRADUATED | `guides/E01-graduation-handoff.md`; `call-flows/E01-hm2-eth-transport.md` | production-path no-hardware transport experiment promoted | passed | architecture/discovery/LLIO ownership SOURCE-CONFIRMED; no physical network claim |
| HM08 HostMot2 watchdog | SOURCE | `guides/HM08-watchdog-initial.md`; `call-flows/HM08-watchdog-cycle-and-recovery.md` | fixture feasibility under review | — | active critical path; read/write/recovery ordering SOURCE-CONFIRMED |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

E01 is **GRADUATED** at its 1000-level architecture/discovery scope.

HM08 is active at **SOURCE**. Pinned source now establishes the complete generic HostMot2 watchdog cycle: successful `hm2_read()` completion precedes watchdog status interpretation; a bite sets HAL `has_bit` and internal `needs_reset`; ordinary `hm2_write()` prepares the `0x5a000000` watchdog reset/pet TRAM value before the combined TRAM write; `hm2_watchdog_write()` separately handles enable/timeout changes and recovery. Recovery is intentionally user-gated by clearing `has_bit`, then uses generic `hm2_force_write()` and clears `needs_reset`/`needs_soft_reset` only if `io_error` remains clear. Generic read/write/watchdog paths return early while `io_error` is asserted, so transport-specific communication recovery is outside HM08.

Official HostMot2 documentation agrees on the 5 ms default, write-function petting, `has_bit` user reset and described high-impedance I/O behavior after a bite. The latter remains DOC-CONFIRMED, not cloud-lab TEST-CONFIRMED. Historical docs used a separate `pet_watchdog()` interface and must not be projected onto the pinned revision.

Upstream `hm2_test` is a real no-hardware LLIO fixture, but its write callback is a success stub and the inspected fixture does not emulate watchdog timer progression/bites. A bounded production-function software-state experiment may be possible by minimally extending the fake register pattern; physical bite timing/electrical behavior must not be simulated and mislabeled as hardware evidence.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and unusual cross-process mappings: **2000 / MEDIUM**.
- Recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions: **2000 / HIGH**.
- Stable/development ready/unready and object-lifetime comparison: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal visibility/cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` versus stable: **2000 / MEDIUM**.
- M03 Task-side command-mutex hold duration and command-to-echo latency distribution: **2000 / HIGH**.
- M03 full planner/kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- HM01 successful fake-board registration fixture extension: **HM02 or 2000 / MEDIUM**.
- E01 production-path stale/duplicate/wrong-size/lost-packet fault injection: **E03/E06 or 2000 / HIGH**.
- E01 exact socket/interface/routing/firewall setup: **E02 / MEDIUM**.
- E01 servo-period Ethernet timing and recovery: **E05/E07 / HIGH**.
- HM08 physical watchdog reaction time, actual board pin electrical state, and output-module behavior after bite: **advanced hardware/commissioning / CRITICAL**; requires representative hardware/firmware and safety analysis.
- HM08 transport-specific path that clears/re-establishes communication after `io_error`: **E03/E06/E07 or 2000 / HIGH**.
- HM08 fake-LLIO production-function state-transition test if fixture extension becomes invasive: **2000 / MEDIUM**.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **HM08 — HostMot2 watchdog**. Inspect the remainder of pinned `hm2_test` patterns/descriptors and upstream HostMot2 tests to determine whether a valid watchdog descriptor already exists. If a minimal fixture extension can execute production `hm2_watchdog_process_tram_read()` and `hm2_watchdog_write()` without copying production logic, design one bounded no-hardware experiment with predeclared gates for exported 5 ms timeout, synthetic status-bit detection -> `has_bit`/`needs_reset`, user clear -> force-write recovery, and timeout programming. If the fixture extension would require building a fake watchdog timer/physical behavior model, PROMOTE that experiment rather than faking evidence. Then create HM08 adversarial exam/corrections and fresh-AI handoff if the 1000-level evidence is sufficient. Preserve the distinction between software/register recovery and physical/safety behavior.