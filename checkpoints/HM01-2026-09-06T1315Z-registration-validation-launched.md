# HM01 checkpoint — registration validation lab launched

Session start UTC: `2026-09-06T13:11:59Z`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Durable work completed this lesson

- Added `call-flows/HM01-lowlevel-registration-lifecycle.md`.
- Inventoried the complete foundation-level `hm2_lowlevel_io_t` contract: required read/write callbacks, optional programming/reset, queued/split I/O hooks, connector/board metadata, runtime I/O error/reset state, `threadsafe`, and private ownership.
- Traced the pinned `hm2_eth` handoff far enough to establish low-level ownership: `hm2_eth` populates LLIO read/write/queued/reset callbacks and then calls `hm2_register(&board->llio, config[boards_count])`; Ethernet transaction details remain deferred to E01+.
- Traced `hm2_parse_module_descriptors()`: IOPort is parsed first; recognized GTAGs dispatch to module-specific parsers; negative parser return or LLIO `io_error` aborts registration; unknown GTAGs are warned/ignored rather than automatically fatal.
- Traced rollback: post-parser failures converge through `hm2_cleanup()` before tentative list removal/free; earlier failures can go directly to `fail0`.
- Identified the pinned upstream no-hardware `tests/hm2-idrom` + `hm2_test` fixture as the appropriate HM01 experiment. The upstream README explicitly says it tests `hm2_register()` with a fake AnyIO register file, and the userspace checker consumes `halrun-stderr` rather than kernel dmesg.
- Added bounded `lab-jobs/009-hm01-registration-validation.sh` with independent semantic gates around the upstream rejection matrix.

## Experiment state

Exactly one `009` run was triggered by the lab-job commit:

- Actions run: `34035539216`
- Job: `101492796989`
- Curriculum SHA: `84a65ff98d495001a487b8df33853791d1ee3387`
- Event: push
- State when checkpointed: `in_progress`

Do not launch another `009` merely because the next lesson begins. Inspect this exact run first.

## Acceptance gates for the next lesson

Require fresh metadata matching SHA `84a65ff98d495001a487b8df33853791d1ee3387` and job file `lab-jobs/009-hm01-registration-validation.sh`, then reconcile the readable artifact/logs. A valid pass requires:

1. pinned LinuxCNC checkout exactly `8bf4605ae81042248add031e94c77300406e0413`;
2. source sanity gates proving the upstream fixture explicitly tests `hm2_register()` and `hm2_test` is no-hardware;
3. upstream `tests/hm2-idrom/test.sh` exits successfully;
4. all 15 expected diagnostic lines are observed by the curriculum gate;
5. representative invalid-cookie/config/IDROM/clock/pin diagnostics are present;
6. the standalone pattern-0 adversarial check contains explicit `invalid cookie` and `hm2_test fails HM2 registration` diagnostics;
7. explicit completion marker is present;
8. no runtime claim is promoted from workflow green status alone.

If the run fails because a grep/source literal in the curriculum harness is stale while the upstream test itself is valid, classify that as HARNESS INVALID and make one materially corrected `009`; do not reinterpret it as HostMot2 behavior. If the upstream test itself fails, inspect the exact diagnostic and classify source/build/environment versus semantic failure before rerunning.

## Evidence boundary

A passing `009` can promote HostMot2 fake-LLIO registration validation/rejection behavior to `TEST-CONFIRMED` for the pinned userspace build. It cannot establish successful physical-board registration, Ethernet timing, realtime deadlines, TRAM cycle timing, watchdog safety, or functional safety.

## Exact resume point

Inspect run `34035539216` / job `101492796989`. If it passes all gates, record an accepted HM01 result, reconcile any discrepancy into the source/call-flow guide, then create the HM01 adversarial exam and answer/correction pass. If the fresh-AI handoff is sufficient, graduate HM01 and advance to E01. If the run is invalid, correct only log-proven harness defects and launch at most one materially corrected retry.
