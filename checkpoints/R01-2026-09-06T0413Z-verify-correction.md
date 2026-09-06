# R01 checkpoint — corrected realtime verifier experiment

Session start UTC: `2026-09-06T04:13:55Z`

## What was resolved

Actions run `34008620114` / job `101420312096` is conclusively **HARNESS INVALID** for realtime-behavior evidence.

Fresh metadata proves it executed `lab-jobs/005-r01-realtime-boundaries.sh` at curriculum SHA `118d9ceda4377e39b667921cd729268ffc3b3984` against pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. The run completed with workflow failure. Its stderr reaches the public wrapper usage line:

`realtime {start|load|stop|unload|restart|force-reload|status|verify}`

and then the lab's own fail-closed message `Expected an explicit non-realtime classification message.`

Therefore the run never supplied the planned scheduler/HAL-period evidence and no R01 runtime claim is promoted from it.

## Source correction

Pinned `scripts/realtime.in` dispatches public `realtime verify` to `Verify()`. On uspace, `Verify()` runs `rtapi_app check_rt` and returns zero only for a realtime-capable classification.

Pinned `src/rtapi/uspace_rtapi_main.cc` dispatches `check_rt` to `do_check_rt_cmd()`, which prints `realtime_type_name(rtapi_get_realtime_type())`. `REALTIME_TYPE_NONE` is named exactly `No realtime`, and the command returns nonzero when `rtapi_is_realtime() == 0`.

This makes the intended observation contract precise:

- nonzero + recognized `No realtime`/source-grounded non-realtime diagnostic => predicted fallback classification;
- zero => unexpected realtime-capable environment; stop and reinterpret;
- nonzero + no recognized classification => harness/environment error; fail closed.

The public LinuxCNC latency documentation agrees with this boundary: its realtime status is reported by `realtime verify`; `No realtime` means measurements are running with ordinary non-realtime scheduling and are not representative of a properly configured realtime system.

Durable call-flow: `call-flows/R01-realtime-verify.md`.

## Corrected experiment

Commit `ac479678abec2e4933447b1d5d03eb51c7569fc6` changes the lab from invalid `realtime check` to `realtime verify`, renames the emitted status label accordingly, and preserves the predeclared/fail-closed interpretation.

Exactly one push-triggered corrected workflow was observed for that SHA:

- run: `34011177375`
- job: `101427172728`
- lab: `005-r01-realtime-boundaries.sh`

At checkpoint creation, checkout and lab-job selection have succeeded and the bounded lab execution step is in progress. Do not launch another `005` while this run is active.

## Adversarial acceptance test

The classifier was independently exercised with synthetic status/text pairs:

- `rc=1`, `No realtime` => accepted fallback classification;
- `rc=0`, `Preempt RT` => rejected as unexpected realtime-capable environment;
- `rc=1`, unrelated `permission denied` => rejected as invalid/unclassified failure.

This specifically prevents the invalid inference that every nonzero `verify` status proves `REALTIME_TYPE_NONE`.

## Exact next-work checkpoint

1. Inspect run `34011177375` by exact run ID, job `101427172728`, head SHA `ac479678abec2e4933447b1d5d03eb51c7569fc6`, and fresh committed `LATEST.metadata.txt`/logs.
2. Require the corrected `realtime-verify-rc` marker and an explicit `No realtime` (or source-equivalent non-realtime diagnostic) before accepting the classification.
3. Separately require successful HAL thread creation/reporting and inspect actual `rtapi_app:T#...` scheduler rows. Do not infer scheduler class solely from classification.
4. Separately verify HAL-reported periods for `r01fast` and `r01slow`; do not infer actual periods merely from request arguments.
5. If the run fails, classify the failure by its last durable marker and correct only a log-proven defect. Do not weaken the experiment prediction to manufacture a pass.
6. Once a valid runtime observation exists, reconcile it with source and official documentation, grade/apply the R01 adversarial exam, perform the fresh-AI handoff audit, and graduate R01 only if core conceptual and safety evidence is complete.
