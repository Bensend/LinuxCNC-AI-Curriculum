# A01 — Localizing a stalled `halcmd` observation

## Scope

Module: A01 process/component architecture  
LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`  
Curriculum lab branch: `a01-bounded-observation`  
Prepared lab commit: `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666`

This note refines experiment `004-a01-runtime-topology`. It does **not** claim a new runtime result. September 5 laboratory compute is already at the curriculum budget, so the corrected experiment is prepared without merging to `main` or launching another Actions run.

## Source-grounded ambiguity

`halcmd list comp` contains two independent places where the same HAL shared-data lock can be waited on indefinitely in userspace.

### Stage A — `halcmd` startup / component registration

Pinned source path:

1. `src/hal/utils/halcmd_main.c::main()` calls `halcmd_startup(0)` before parsing/dispatching the requested command.
2. `src/hal/utils/halcmd.c::halcmd_startup()` sets `hal_flag = 1`, calls `hal_init(comp_name)`, then clears `hal_flag` and calls `hal_ready(comp_id)` on success.
3. Prior A01 source tracing established that the ULAPI `hal_init()` path acquires the HAL shared-data mutex while registering the temporary `halcmd<PID>` component.

Therefore a process that never returns from `halcmd list comp` may still be blocked before the `list` command is dispatched.

### Stage B — component-list query

Pinned `src/hal/hal_lib_query.c::hal_list_comp()` first validates `hal_data` and the query/callback, then calls `halpr_mutex_acquire()` before walking `hal_data->comp_list_ptr`. The lock is held for the entire component-list callback iteration and released afterward.

The same pattern exists in `hal_list_funct()`. Thus a successful `hal_init()` does not imply a subsequent list query cannot block.

## Why the previous bounded probe was still insufficient

Wrapping the whole `halcmd list comp` process in GNU `timeout` proves only that the process failed to return before the deadline. It does not reveal whether it was blocked in startup registration or in `hal_list_comp()`.

It also destroys the most useful live evidence if the timed process is killed before a stack can be captured.

## Corrected diagnostic design

Branch `a01-bounded-observation` now runs each HAL observation as a monitored child process instead of relying only on `timeout`:

1. Start `halcmd ...` in the background and retain its PID.
2. Poll only for bounded wall-clock time (`HAL_TIMEOUT`, default 3 s).
3. If the process exits, collect the true exit code and preserve stdout/stderr.
4. If it remains alive, capture `ps`, `/proc/<pid>/status`, and a symbol-level GDB backtrace **before** terminating it.
5. Use `sudo gdb -p <pid>` because GitHub-hosted Ubuntu can enable Yama ptrace ancestry restrictions; the diagnostic must not silently fail merely because GDB is a sibling process.
6. Send SIGTERM, wait one bounded second, then SIGKILL if necessary. The hard-kill fallback remains justified because `halcmd` deliberately defers ordinary termination while `hal_flag` indicates it may hold/acquire the HAL mutex.
7. Return a synthetic timeout status `124`, while keeping the diagnostic stack in stderr/artifacts.

This design preserves the existing `set -e` correction: callers temporarily disable `errexit` when a nonzero result is expected and restore it before normal assertions continue.

## Interpretation rules for the next run

A captured backtrace may promote only the exact observed blocking site:

- stack in `hal_init()` / HAL registration path -> `TEST-CONFIRMED` startup/registration stall for that run;
- stack in `hal_list_comp()` or `hal_list_funct()` below their lock acquisition -> `TEST-CONFIRMED` query-stage stall for that run;
- stack only in generic mutex/yield code with insufficient caller frames -> blocking remains `UNKNOWN`; do not guess the higher-level stage;
- GDB attach failure -> retain the whole-command timeout only; do not infer a site;
- no timeout and assertions execute -> use the fresh process/HAL output to verify the intended A01 topology.

A timeout in one run does not establish an upstream LinuxCNC defect by itself. It may expose experiment sequencing, cleanup, stale shared state, or a genuine HAL-lock ownership problem. Root cause requires the owner/holder path or a reproducible minimal case.

## Community cross-check

LinuxCNC issue #2716 is useful corroboration that current HAL instances share fixed shared-memory resources and that parallel LinuxCNC sessions are constrained by those global resources. It remains `COMMUNITY-REPORTED`; it does not identify the lock owner in experiment `004` and must not be used to explain the timeout without runtime evidence.

## Adversarial checks applied to the instrumentation

- **False premise:** "A 3 s timeout means `hal_list_comp()` hung." Rejected; startup happens first.
- **Evidence destruction:** killing first and diagnosing second can miss a transient lock condition. Rejected; diagnose the original still-live PID.
- **Ptrace assumption:** a same-user sibling GDB process is always allowed to attach. Rejected; use privileged attach in the disposable GitHub runner and preserve attach failure output.
- **Signal assumption:** SIGTERM always ends `halcmd` promptly. Rejected; retain bounded SIGKILL fallback.
- **Shell assumption:** a failing diagnostic command will still reach its own logging code under global `set -e`. Rejected; neutralize `errexit` around expected failures.

## Exact next laboratory checkpoint

Do not launch another September 5 build. At the next calendar-day lab budget:

1. Reconcile branch `a01-bounded-observation` with current `main`, preserving commits `13063ce8...` and `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666` behavior.
2. Merge/apply the corrected `004` and runner changes once.
3. Allow exactly one auto-triggered run.
4. Require fresh `004` metadata and inspect the first stalled-probe backtrace before interpreting topology.
5. If the stack localizes the stall, document the exact call path and then decide whether a smaller follow-up experiment is justified. If the topology assertions pass, perform the A01 fresh-AI handoff and graduation review.
