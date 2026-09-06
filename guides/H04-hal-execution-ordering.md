# H04 — HAL Execution Ordering

- Course level: 1000
- Status: SOURCE / experiment design
- Primary LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`
- Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where explicitly noted
- Safety scope: software execution semantics only; this is not realtime qualification or functional-safety evidence.

## Learning objective

A fresh AI should be able to explain and inspect how an exported realtime HAL function becomes an ordered entry in one HAL thread, how that thread dispatches its function list, what `start`/`stop` actually change, why ordering within one thread is different from timing between different threads, and which mutation/failure boundaries must be treated cautiously.

## Official documentation pass

Current LinuxCNC HAL documentation says `addf` adds a realtime function to a realtime thread and that the optional position controls execution order. Positive positions count from the start (`+1` first); negative positions count from the end (`-1` last); zero is illegal. The HAL basics guide also warns that order is materially important for some I/O functions such as read/write paths.

References:

- https://linuxcnc.org/docs/html/man/man3/hal_add_funct_to_thread.3hal.html
- https://www.linuxcnc.org/docs/stable/html/hal/basic-hal.html
- pinned source-tree man page: `docs/src/man/man3/hal_add_funct_to_thread.3.adoc`

Documentation also defines `start` as beginning periodic invocation of functions added to each thread and `stop` as stopping those function calls. The source trace below sharpens that statement: the underlying RTAPI task is already created and continues its periodic wait loop; the global HAL run flag controls whether the function list is dispatched.

## Source inventory

| Path | Symbol / structure | Role |
|---|---|---|
| `src/hal/hal_lib.c` | `hal_create_thread()` | creates one RTAPI task per HAL thread and starts it at the thread period |
| `src/hal/hal_lib.c` | `hal_add_funct_to_thread()` | validates function/thread/position, inserts a function-entry into the thread list, increments users |
| `src/hal/hal_lib.c` | `hal_del_funct_from_thread()` | removes a matching function-entry from a thread |
| `src/hal/hal_lib.c` | `free_funct_entry_struct()` | decrements function `users` and recycles the list entry |
| `src/hal/hal_lib.c` | `hal_start_threads()` / `hal_stop_threads()` | set/clear the shared `threads_running` gate |
| `src/hal/hal_lib.c` | `thread_task()` | periodic dispatcher: traverses the thread's function list and calls each entry in list order |
| `src/hal/hal_priv.h` / related HAL private structures | `hal_thread_t`, `hal_funct_t`, `hal_funct_entry_t` | ordered list root, function metadata/users, scheduled entry |

## Function guide — `hal_add_funct_to_thread()`

**SOURCE-CONFIRMED at `8bf4605...`.**

The function first rejects uninitialized HAL, configuration locking, position `0`, missing names, unknown function/thread, and a non-reentrant function already having `users > 0`. It then calculates an insertion point on the target thread's circular `funct_list`.

Position semantics are implemented directly rather than inferred from command-file order:

- `position > 0`: walk forward from the list root until the requested one-based position.
- `position < 0`: walk backward from the tail; `-1` becomes the last position.
- an out-of-range positive or negative position fails rather than silently clamping.

After allocating `hal_funct_entry_t`, HAL snapshots the function pointer and argument into the entry, inserts it with `list_add_after()`, increments `funct->users`, releases the HAL mutex, and returns success.

This makes the configured list order an explicit shared-memory object, not a textual property of `.hal` files. Textual `addf` order matters only because repeated default `-1` additions append to that list.

## Function guide — delete and users accounting

`hal_del_funct_from_thread()` locates the target function and thread, walks the target thread's cyclic function list, removes the matching `hal_funct_entry_t`, and passes it to `free_funct_entry_struct()`.

`free_funct_entry_struct()` dereferences the entry's `funct_ptr` and decrements `funct->users` before clearing/recycling the entry. Therefore a successfully removed non-reentrant function is eligible to be added again after deletion; the `users` counter is not permanently latched by the first `addf`.

Failure cases include function not found, function not in use, thread not found, and function not actually present in that thread.

## Call flow — configured function to periodic invocation

1. A realtime component exports a function (`hal_export_funct*`), creating `hal_funct_t` metadata.
2. `hal_add_funct_to_thread(name, thread, position)` creates one ordered `hal_funct_entry_t` in `thread->funct_list`.
3. Separately, `hal_create_thread()` creates an RTAPI task whose entry point is `thread_task`, stores its task id, and starts that task at the computed thread period.
4. The task loops forever. Every loop ends in `rtapi_wait()`.
5. When `hal_data->threads_running > 0`, `thread_task()` begins at the first entry in `thread->funct_list`, calls `funct_entry->funct(funct_entry->arg, thread->period)`, advances via the list's next link, and repeats until it reaches the list root.
6. Function runtime and maximum runtime bookkeeping are updated after each call; thread runtime and `threadbeat` are updated after the full cyclic list completes.
7. `hal_stop_threads()` clears `threads_running`; the task remains alive and continues reaching `rtapi_wait()`, but cyclic functions are skipped. `hal_start_threads()` sets the gate again.

### Consequence: within-thread order

**SOURCE-CONFIRMED.** For one invocation of one HAL thread, functions are called sequentially in exactly the linked-list order established by `addf`/position. A later function can therefore consume values produced by an earlier function during the same thread cycle, assuming the component/signal topology permits it.

### Consequence: cross-thread timing

**SOURCE-CONFIRMED boundary + inference from R01 task model.** Each HAL thread has its own RTAPI task. There is no global per-cycle dispatcher in `thread_task()` that imposes a total order across different HAL threads. Thread period and scheduler priority govern when separate tasks can run. Therefore an `addf` list position provides a deterministic sequence only **inside its own thread**; it must not be described as a cross-thread execution barrier or as a proof of realtime deadline determinism.

## Start/stop semantics correction

A common shorthand is that `stop` "stops realtime threads." At this revision, `hal_stop_threads()` actually sets `hal_data->threads_running = 0`. It does not pause or delete each RTAPI task. The `thread_task()` loop continues and calls `rtapi_wait()` each period while dispatch is disabled. `start` sets the same shared flag to `1`.

This distinction matters for debugging: a stopped thread's `threadbeat` should stop advancing because it increments only after a cyclic dispatch pass, but the task itself still exists.

## Development-only init cycle note

The pinned development revision also contains `hal_init_funct_to_thread()` and `thread->init_funct_list`. On the first cycle after threads are enabled, `thread_task()` executes that init list once, calls `rtapi_task_self_resync()`, latches `init_done`, drains the init list, and intentionally does **not** execute the ordinary cyclic list in that same cycle. Cyclic execution begins on the following period.

The stable-reference tree does not contain the corresponding `docs/src/man/man3/hal_init_funct_to_thread.3.adoc` path. Do not silently project this development behavior onto LinuxCNC 2.9.x without a dedicated version trace.

## Configuration mutation boundary

**SOURCE-CONFIRMED observation; runtime safety conclusion remains UNKNOWN.**

`hal_add_funct_to_thread()` and `hal_del_funct_from_thread()` take the HAL configuration mutex, but `thread_task()` traverses `thread->funct_list` without taking that mutex. Neither add nor delete has an explicit `threads_running == 0` precondition in the traced code.

This means the source does not provide an obvious mutual-exclusion barrier between a running dispatcher and list mutation. The 1000-level laboratory will therefore perform `delf`/re-`addf` only while HAL dispatch is stopped. Exact behavior and supported guarantees for concurrent live list mutation are promoted to 2000-level study rather than guessed here.

## Failure modes relevant to H04

- `position == 0` -> rejected.
- position beyond current list bounds -> rejected.
- function/thread name missing or unknown -> rejected.
- non-reentrant function with existing `users > 0` -> rejected from a second thread/entry.
- deleting a function not actually in the stated thread -> rejected.
- `HAL_LOCK_CONFIG` blocks add/delete configuration changes.
- `HAL_LOCK_RUN` blocks start/stop.
- a slow function delays all functions that follow it in the same thread because dispatch is sequential; this statement does not itself establish whether a deadline is missed or what the scheduler does next.

## Claims ledger

| Claim | Class | Evidence | Verification |
|---|---|---|---|
| `addf` position determines one-thread execution sequence | DOC + SOURCE | man page; `hal_add_funct_to_thread()` | bounded H04 lab |
| default `-1` appends to tail | DOC + SOURCE | docs and negative-position insertion path | bounded H04 lab |
| dispatcher calls each function sequentially by next-link traversal | SOURCE | `thread_task()` | bounded data-flow lab |
| `stop` disables dispatch but does not delete/pause HAL RTAPI tasks | SOURCE | `hal_stop_threads()` + `thread_task()` | threadbeat stop/restart lab |
| non-reentrant function cannot have multiple active scheduled entries | SOURCE | `funct->users` / `reentrant` check | duplicate-add negative test |
| deletion decrements users and permits re-add | SOURCE | `free_funct_entry_struct()` | stop/delf/re-add test |
| add/delete while running has well-defined race-free semantics | UNKNOWN | dispatcher does not take config mutex; no running-state guard observed | promote 2000 |
| `addf` order defines ordering between different HAL threads | FALSE premise | separate RTAPI task per `hal_create_thread()` | adversarial exam; no lab needed for 1000 claim |

## Predeclared H04 experiment

Create one HAL thread and two stock `sum2` instances connected as a two-node feedback chain:

- `A = previous_B + 1`
- `B = current_or_previous_A + 1`, depending on execution order.

This gives a stable order discriminator after many cycles:

- A then B -> `B - A ~= 1`.
- B then A -> `A - B ~= 1`.

Experiment gates:

1. Add A then B using default tail insertion; `show thread` must list them in that order and runtime values must satisfy `B - A ~= 1`.
2. Duplicate `addf` of the same non-reentrant `sum2.0` must fail.
3. `stop` must cause `threadbeat` to stop advancing over an observation window.
4. While stopped, delete B and re-add it at position `+1`; this must succeed, proving user-count cleanup and configured reordering.
5. Restart; `show thread` must list B then A and runtime values must satisfy `A - B ~= 1`.
6. Completion marker required. No realtime-latency, physical-machine, or safety claim is permitted.

## Higher-level promotion / uncertainty queue

| Item | Evidence | Destination | Priority | Blocks H04? |
|---|---|---|---|---|
| Race/supported semantics of `addf`/`delf` while dispatcher is running | unlocked dispatcher traversal + config-side mutex only | 2000 | HIGH | No; lab/config guidance uses stop before mutation |
| Memory-ordering/atomicity of values passed between functions on different RTAPI tasks | not established here | 2000 | HIGH | No for within-thread ordering objective |
| Deadline/overrun behavior when one function consumes most/all thread period | R01/H04 source boundary only | R02/R04 / 2000 depth | HIGH | No; H04 does not claim deadline guarantees |
| Stable/development comparison of one-shot `initf` semantics | development source present; stable doc path absent | 2000/version comparison | MEDIUM | No |
| Cross-CPU scheduling and cache effects between HAL threads | not tested | 2000 | MEDIUM | No |

## Current sufficiency boundary

H04 is not ready to graduate yet. The source model is sufficient to justify a discriminating bounded experiment. Graduation still requires runtime reconciliation, adversarial exam/corrections, and a fresh-AI handoff.
