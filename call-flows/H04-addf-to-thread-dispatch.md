# H04 call flow — `addf` to periodic HAL function dispatch

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Configuration path

### `halcmd addf <funct> <thread> [position]`

`src/hal/utils/halcmd_commands.cc` parses the optional position and calls:

`hal_add_funct_to_thread(func, thread, position)`

The default position used by the command path is `-1`, meaning append at the end.

### `hal_add_funct_to_thread()`

File: `src/hal/hal_lib.c`

Important state:

- target `hal_thread_t`
- exported `hal_funct_t`
- one allocated `hal_funct_entry_t`
- `thread->funct_list`
- `funct->users`

Control flow:

1. Reject uninitialized HAL, HAL config lock, zero position, missing names.
2. Resolve exported function by name.
3. If `users > 0` and `reentrant == 0`, reject duplicate scheduling.
4. Resolve thread by name.
5. Walk the target circular function list forward for positive positions or backward for negative positions.
6. Reject an insertion point beyond the current list.
7. Allocate a function entry.
8. Copy function metadata needed for direct dispatch (`funct_ptr`, `arg`, callable `funct`).
9. Insert entry at the calculated position.
10. Increment `funct->users`.

The periodic dispatcher does not later resolve the function by name; it follows the already-created entry and calls the stored function pointer.

## Thread creation path

### `hal_create_thread()`

The function computes/rounds the period and priority, then creates an RTAPI task with:

`rtapi_task_new(thread_task, new, new->priority, lib_module_id, HAL_STACKSIZE, 1)`

and starts it with:

`rtapi_task_start(new->task_id, new->period)`

The created task exists independently of the later global HAL `start` command. Its loop is already executing and reaching `rtapi_wait()`.

## Run gate

### `hal_start_threads()`

Sets:

`hal_data->threads_running = 1`

### `hal_stop_threads()`

Sets:

`hal_data->threads_running = 0`

Neither routine walks individual thread tasks to create/delete them. `HAL_LOCK_RUN` can reject these state changes.

## Periodic dispatcher

### `thread_task(void *arg)`

Execution context: the RTAPI task created for one `hal_thread_t`.

Loop behavior:

1. If threads are enabled and the development-only init list has not yet run, execute the one-shot init list, resynchronize the task, mark `init_done`, drain the list, and skip the ordinary cyclic list for that cycle.
2. Else, if threads are enabled:
   - capture the first entry in `thread->funct_list`;
   - capture cycle start time;
   - while entry != list root:
     - call `funct_entry->funct(funct_entry->arg, thread->period)`;
     - capture end time;
     - update the corresponding function runtime / max-time values;
     - advance to the entry's next link;
   - update thread runtime / max-time;
   - increment `threadbeat`.
3. Call `rtapi_wait()` unconditionally at the bottom of the loop.

## One-thread ordering guarantee taught at H04

The cyclic call sequence is the list traversal sequence. Therefore, within one thread cycle:

`entry1 -> entry2 -> entry3 -> ...`

is a direct sequential call chain. If entry2 reads a HAL signal value written by entry1, entry2 can see the new value in that same cyclic pass.

This is the central H04 1000-level ordering property.

## What this does *not* guarantee

It does not create a total order across two different HAL threads. Each thread has a separate RTAPI task. A position in thread A has no list relationship with any position in thread B.

It also does not guarantee that all functions complete before the thread's nominal deadline. A long-running early function consumes time before every later function and the thread's final `rtapi_wait()`. Deadline/overrun behavior belongs to R02/R04 and higher-level timing work.

## Delete/re-add path

`hal_del_funct_from_thread()` finds the matching list entry, removes it, and calls `free_funct_entry_struct()`.

`free_funct_entry_struct()` decrements the owning function's `users` count before recycling the entry. This is why a non-reentrant function deleted from its thread can subsequently be added again.

The H04 experiment performs delete/re-add only after `halcmd stop`, because the running dispatcher itself does not take the configuration mutex while traversing the function list. Concurrent live mutation semantics are not assumed.

## Failure branches worth recognizing

- zero position -> `-EINVAL`
- requested insertion beyond list length -> `-EINVAL`
- function or thread absent -> error
- non-reentrant function already scheduled -> error
- configuration locked -> `-EPERM`
- run state locked -> start/stop `-EPERM`
- allocation failure -> `-ENOMEM`
- delete target not used by named thread -> error

## Debugging observation points

- `halcmd show funct` — exported functions and user counts
- `halcmd show thread` — thread period and ordered scheduled functions
- `<thread>.threadbeat` — increments after a completed cyclic dispatch pass
- `<function>.time`, `<function>.tmax`, `<function>.tmax-increased` — runtime instrumentation in the pinned development source
- `<thread>.time`, `<thread>.tmax` — aggregate thread execution timing

These are observation aids, not safety or deadline guarantees.
