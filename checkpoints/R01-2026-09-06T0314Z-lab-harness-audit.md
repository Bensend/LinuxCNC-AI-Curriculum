# R01 checkpoint — 005 harness audit

Session start UTC: `2026-09-06T03:14:38Z`.

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Durable work this session

- Source-traced first HAL-thread base-period establishment and nearest-multiple period rounding in `hal_create_thread()`.
- Confirmed the pinned uspace POSIX `RtapiApp::clock_set_period()` stores the first nonzero request exactly; backend-specific timer quantization remains a higher-level question.
- Separated actual SCHED_FIFO acquisition, realtime-type selection, runtime pthread policy, memory locking, and measured target latency as distinct evidence classes.
- Corrected an important source-model detail: `makeApp()` loads the SCHED_OTHER POSIX backend directly for `REALTIME_TYPE_NONE`; `harden_rt()` / `configure_memory()` run only on the realtime-capable branch. Therefore fallback selection is not caused by `mlockall()` failure, and the fallback path should not be expected to emit an `mlockall` warning.
- Preserved LinuxCNC issue #2821 as a `COMMUNITY-REPORTED` historical example where cgroup RT-runtime constraints caused `sched_setscheduler(SCHED_FIFO)` to fail with `EPERM`, illustrating why actual scheduler acquisition must be observed.
- Added `lab-jobs/005-r01-realtime-boundaries.sh`, triggering Actions run `34008620114` exactly once at curriculum SHA `118d9ceda4377e39b667921cd729268ffc3b3984`.

## Pre-result harness defect found

A source audit after launch found that pinned `scripts/realtime.in` accepts `verify`, not `check`. Its `Verify()` function calls `rtapi_app check_rt`; the public script dispatch is:

- `realtime verify` -> `Verify()` -> `rtapi_app check_rt`

The launched `005` script currently invokes `realtime check`. Therefore, if run `34008620114` fails at that point, classify it as **HARNESS INVALID / no realtime evidence**, not as a failed realtime-capability probe.

Do **not** edit `005` on `main` while run `34008620114` is still active because that would trigger a duplicate laboratory run. Wait for the existing run to complete. If it fails specifically on the invalid subcommand, make the one-line `check` -> `verify` correction plus any other defects revealed by the same log, then permit one materially corrected rerun.

If, unexpectedly, the wrapper accepts `check` through another path, still verify the exact executed command/output against pinned source before promotion.

## Exact resume point

1. Inspect run `34008620114` / job `101420312096` to completion.
2. Require artifact metadata to identify `lab-jobs/005-r01-realtime-boundaries.sh` and source SHA `118d9ceda4377e39b667921cd729268ffc3b3984`.
3. If it stops at `realtime check`, classify the attempt as harness-invalid and correct to `realtime verify`; do not promote scheduler/period claims from the run.
4. If it reaches the actual observations, reconcile `realtime verify` semantics, HAL thread periods, and periodic pthread scheduler class before promoting any `TEST-CONFIRMED` claims.
5. No latency/jitter observation from GitHub Actions qualifies physical-machine realtime suitability.
