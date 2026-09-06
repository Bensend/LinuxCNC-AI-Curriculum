# H04 checkpoint — source trace complete, ordering lab launched

Session start: `2026-09-06T09:10:03Z`

## Durable work completed

- Official documentation pass for `addf` position/order and start/stop semantics.
- Community findings covering execution-order misconceptions, data-age failures, configuration auditability, and duplicate non-reentrant scheduling diagnostics.
- Pinned source trace at LinuxCNC `8bf4605ae81042248add031e94c77300406e0413` for:
  - `hal_create_thread()` -> one RTAPI task per HAL thread;
  - `hal_add_funct_to_thread()` validation/insertion/user accounting;
  - `hal_del_funct_from_thread()` removal;
  - `free_funct_entry_struct()` users decrement;
  - `hal_start_threads()` / `hal_stop_threads()` global dispatch gate;
  - `thread_task()` sequential list traversal, runtime accounting, threadbeat, and unconditional `rtapi_wait()`.
- Durable guides:
  - `guides/H04-hal-execution-ordering.md`
  - `forum-findings/H04-execution-ordering-field-notes.md`
  - `call-flows/H04-addf-to-thread-dispatch.md`
- Bounded experiment: `lab-jobs/007-h04-execution-ordering.sh`

## Important correction/boundary

At the pinned revision, `stop` clears the HAL dispatch gate; it does not delete or pause each RTAPI task. Each task remains in `thread_task()` and continues to `rtapi_wait()`.

`addf`/`delf` configuration mutations take the HAL mutex, but the realtime dispatcher traverses `thread->funct_list` without that mutex, and add/delete do not show an explicit running-state precondition. The 1000-level lab therefore reorders only while dispatch is stopped. Exact live-mutation race/support semantics are promoted to 2000/HIGH.

## Active experiment

- Curriculum commit that introduced the lab: `f15451ee92f7f5d82310f6f182b20cdf10b51418`
- Workflow run: `34024102367`
- Job: `101461896527`
- Job file: `lab-jobs/007-h04-execution-ordering.sh`
- Initial state when checkpointed: launched/in progress; no runtime semantics promoted yet.

## Predeclared acceptance gates

Require all of the following before any H04 TEST-CONFIRMED promotion:

1. fresh metadata for SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418` and `007-h04-execution-ordering.sh`;
2. phase 1 `show thread` lists `sum2.0` before `sum2.1`;
3. duplicate scheduling of non-reentrant `sum2.0` fails with the expected class of diagnostic;
4. phase 1 order-sensitive feedback gives `B-A ~= +1`;
5. after stop and settling, two threadbeat observations are equal;
6. while stopped, `delf sum2.1` followed by `addf sum2.1 h04-thread 1` succeeds;
7. phase 2 `show thread` lists `sum2.1` before `sum2.0`;
8. phase 2 order-sensitive feedback gives `A-B ~= +1`;
9. threadbeat increases after restart;
10. explicit H04 completion marker is present and exit code is zero.

A green workflow alone is insufficient.

## Exact next work

Inspect run `34024102367` / job `101461896527`; do not launch a duplicate while active. If harness-invalid, patch only the demonstrated harness problem before one materially corrected rerun. If valid, reconcile each gate, promote only observed facts, then create/grade the H04 adversarial exam, corrections, fresh-AI handoff, and graduation decision.
