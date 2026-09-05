# A01 — `halcmd` → HAL shared-memory lock call flow

Primary LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Purpose

Runtime experiment `004` reached a live LinuxCNC controller but an unbounded `halcmd list comp` probe prevented the intended topology assertions from completing. This guide narrows the source-level blocking boundary without claiming which location actually blocked in the failed run.

## End-to-end userspace path

For a one-shot `halcmd list comp` at the pinned revision:

1. `src/hal/utils/halcmd_main.c::main()` parses options and calls `halcmd_startup(0)` before command dispatch.
2. `src/hal/utils/halcmd.c::halcmd_startup()` installs signal handlers, creates a unique `halcmd<PID>` component name, sets `hal_flag = 1`, and calls `hal_init(comp_name)`.
3. `src/hal/hal_lib.c::hal_init()` initializes/maps the userspace HAL library on the first reference, calls `rtapi_init()`, and then calls `halpr_mutex_acquire()` before it inspects/modifies the shared component list.
4. `halpr_mutex_acquire()` increments shared `lockcnt`. On contention by another thread/process it calls `rtapi_mutex_get_rd(&hal_data->priv_rdmutex)`.
5. `src/rtapi/rtapi_mutex.h::rtapi_mutex_get_rd()` is explicitly blocking: it repeatedly tests the reverse-default mutex and calls `sched_yield()` in userspace until it acquires the bit. There is no timeout in this loop.
6. Once startup completes, command dispatch selects `do_list_cmd()`.
7. Component listing reaches `src/hal/hal_lib_query.c::hal_list_comp()`, which independently calls the same `halpr_mutex_acquire()`, walks `hal_data->comp_list_ptr` while holding the lock, invokes the callback for each component, and releases the lock afterward.

Evidence classification: **SOURCE-CONFIRMED**.

## Important correction to the hang hypothesis

There are at least two source-confirmed blocking opportunities in one `halcmd list comp` process:

- startup registration in `hal_init()` while acquiring the HAL shared-data lock; and
- the later `hal_list_comp()` query while acquiring that same shared-data lock.

Both converge on the unbounded userspace `rtapi_mutex_get_rd()` loop when the shared recursive lock is contended. Therefore the previous statement "`list comp` hung" is still too broad to localize the failure.

The correct current claim is:

> **INFERENCE:** the failed experiment was likely held inside an unbounded `halcmd` invocation. Source proves that both component registration and list traversal can wait indefinitely for the HAL shared-data mutex. The cancelled run did not preserve an internal marker that distinguishes those two waits, so the exact blocking site remains **UNKNOWN**.

## Signal/timeout adversarial detail

`halcmd_startup()` deliberately sets `hal_flag = 1` around `hal_init()`. Its `quit()` signal handler does not immediately exit while that flag is set; it sets `halcmd_done = 1` and returns because the process may hold or be acquiring the HAL mutex. If `hal_init()` is stuck in the blocking mutex acquisition, a normal `SIGTERM` therefore need not terminate it promptly.

This validates the prepared experiment's use of an external hard-kill fallback (`timeout -k ...`): the TERM phase alone is not a sufficient wall-clock bound for every startup failure path.

Evidence classification: **SOURCE-CONFIRMED** for handler behavior and blocking primitive; the behavior of the failed `004` invocation remains **UNKNOWN** until instrumented.

## HAL shared-memory architecture community cross-check

LinuxCNC issue #2716 (2023-10-30, rmu75, with discussion including andypugh) describes the practical difficulty of parallel LinuxCNC instances because HAL uses fixed shared-memory resources and discusses "one HAL instance" as the present architectural model. This is useful corroborating context for why independent tools such as `halcmd` attach to shared HAL state rather than opening a private per-tool database.

Classification: **COMMUNITY-REPORTED**, consistent with the pinned source but not used as implementation authority.

Reference: https://github.com/LinuxCNC/linuxcnc/issues/2716

## Function guide

### `halcmd_startup(int quiet)`
- Path: `src/hal/utils/halcmd.c`
- Context: userspace `halcmd` process.
- Purpose: attach one command invocation to HAL as a temporary userspace component.
- Calls: principally `hal_init(comp_name)`, then `hal_ready(comp_id)`.
- Failure: propagates a negative `hal_init()` result as `-EINVAL`; however a lock wait inside `hal_init()` has no internal timeout.
- Timing assumption: not realtime; may block.
- Evidence: **SOURCE-CONFIRMED**.

### `hal_init(const char *name)`
- Path: `src/hal/hal_lib.c`
- Context: userspace or initialization context; HAL header explicitly excludes realtime use.
- Purpose: initialize/register a HAL component.
- Important calls: first-reference `hal_lib_init()` in ULAPI, `rtapi_init()`, `halpr_mutex_acquire()`, duplicate-name lookup, component allocation/list insertion, `halpr_mutex_release()`.
- Shared state: `hal_data->comp_list_ptr`, HAL shared-memory allocation structures, recursive mutex metadata.
- Failure: invalid name, RTAPI failure, duplicate name, allocation failure; lock acquisition itself has no timeout.
- Evidence: **SOURCE-CONFIRMED**.

### `halpr_mutex_acquire()` / `rtapi_mutex_get_rd()`
- Paths: `src/hal/hal_lib.c`, `src/rtapi/rtapi_mutex.h`
- Context: non-realtime lock path.
- Purpose: serialize HAL shared metadata access with recursive ownership tracking.
- Blocking behavior: after shared `lockcnt` indicates contention by another thread, `rtapi_mutex_get_rd()` loops until the reverse-default mutex becomes available and yields the CPU between attempts.
- Timeout: none in the inspected implementation.
- Realtime boundary: `rtapi_mutex.h` explicitly says the blocking getter must not be used in realtime code.
- Evidence: **SOURCE-CONFIRMED**.

### `hal_list_comp()` / `hal_list_funct()`
- Path: `src/hal/hal_lib_query.c`
- Context: userspace query API.
- Purpose: iterate stable snapshots of shared HAL metadata by holding the HAL mutex through list traversal/callback execution.
- Blocking behavior: each acquires the same potentially unbounded HAL shared-data mutex before iteration.
- Evidence: **SOURCE-CONFIRMED**.

## Consequences for corrected experiment `004`

The prepared bounded-observation branch is now source-justified in four ways:

1. process readiness must be observed independently from HAL-query readiness;
2. every whole `halcmd` process needs an external elapsed-time bound;
3. the bound must include a hard-kill fallback, not only SIGTERM;
4. a timeout result must report only "HAL command process failed to return" unless finer instrumentation identifies whether startup registration or the query lock blocked.

The next run should preserve stderr and progress markers around each whole `halcmd`. If it times out, the next diagnostic experiment should distinguish startup from query execution—for example by instrumenting/stracing the bounded probe or adding an independently bounded minimal HAL attach operation—before changing LinuxCNC source or repeating a full build.

## Open question

Why was the HAL shared-data mutex unavailable for long enough to defeat the original experiment, if that is indeed the blocking mechanism? Source analysis proves that such an indefinite wait is possible but does not prove which process owned the lock or why it failed to release it. Resolving ownership requires fresh runtime evidence; it must not be reconstructed from process presence alone.
