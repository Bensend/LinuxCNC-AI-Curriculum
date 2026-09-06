# H01 — HAL registration, connectivity, and function scheduling call flows

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.
Evidence class in this document: **SOURCE-CONFIRMED** unless explicitly stated otherwise.

## Shared object graph

`src/hal/hal_priv.h` describes HAL as one shared-memory object graph rooted at `hal_data_t`. The root carries name-sorted lists for components, pins, signals, parameters, functions, and threads plus corresponding free lists. Shared-memory references are stored as offsets (`SHMFIELD` / `SHMOFF`) because each process may map the same RTAPI shared memory at a different virtual address.

Important structures:

- `hal_comp_t`: component ID/type, ready flag, userspace PID, component-local shared-memory base, name.
- `hal_pin_t`: owner, address of the component's pin-data pointer, dummy value, linked-signal offset, type/direction/name.
- `hal_sig_t`: signal-value offset, type, reader/writer/bidir counts, name.
- `hal_param_t`: owner, value offset/storage, access direction, type/name; not a signal endpoint.
- `hal_funct_t`: owner, executable function pointer and arg, reentrancy flag, user count, runtime/maxtime observability objects, name.
- `hal_funct_entry_t`: per-thread scheduling link containing function pointer/arg plus back-reference to `hal_funct_t`.
- `hal_thread_t`: RTAPI task ID, period, priority, cyclic and one-shot-init function lists, runtime/maxtime/threadbeat observability and pseudo-component ID.

## Ready-state transition

### `hal_init()` -> `hal_ready()`

`hal_init()` creates `hal_comp_t` with `ready = 0`. `hal_ready(comp_id)` takes the shared HAL mutex, finds the component, rejects a duplicate ready transition, sets `ready = 1`, and returns.

`hal_set_unready()` / `hal_unready()` can restore `ready = 0` (with slightly different lookup implementations in this pinned source). Therefore `ready` is a mutable lifecycle state, not an irreversible terminal state.

The important restriction is enforced by component-owned registration APIs, not by `hal_ready()` itself. For example:

- `hal_pin_new()` rejects `comp->ready != 0` with `pin_new called after hal_ready`.
- `hal_export_funct()` rejects `comp->ready != 0` with `export_funct called after hal_ready`.

Public documentation uses the transition as the synchronization point for `loadusr -W`: a userspace component calls `hal_ready()` after it has created the HAL objects required for use. Do not overstate this as a global freeze: signal/link configuration is separate and can occur after components are ready unless HAL locking policy forbids it.

## Pin creation: component pointer starts on dummy storage

Call flow for a legacy typed wrapper is representative:

`hal_pin_float_new()` -> `hal_pin_new(name, HAL_FLOAT, dir, data_ptr_addr, comp_id)`.

`hal_pin_new()`:

1. validates HAL initialization, type, direction, name and load-lock state;
2. takes the shared HAL mutex;
3. resolves `comp_id`, rejects duplicate pin/parameter-name collisions;
4. requires `data_ptr_addr` itself to reside in HAL shared memory;
5. rejects creation after the owner component is ready;
6. allocates/reuses `hal_pin_t`;
7. records `data_ptr_addr`, owner, type, direction and zero signal reference;
8. initializes `dummysig` to zero;
9. writes the component-visible `*data_ptr_addr` so it points at this pin's `dummysig` using the owning component's mapping base;
10. inserts the pin in the global name-sorted pin list.

This is the source-level reason an unlinked realtime pin can be dereferenced without a null check.

## Signal creation

`hal_signal_new(name, type)`:

1. validates HAL initialization/name/config-lock;
2. takes the shared HAL mutex and rejects duplicate signal names;
3. allocates signal value storage upward (`shmalloc_up(sizeof(halpr_data_u))`) and zeros it;
4. allocates/reuses `hal_sig_t` from the downward/configuration region;
5. stores the value offset, type, zero reader/writer/bidir counters, and name;
6. inserts the signal in the global name-sorted signal list.

The split between `hal_sig_t` metadata and separately allocated value storage is deliberate: runtime-accessed value data is clustered in the realtime-oriented upward allocation region while metadata lives in the configuration-oriented region.

## Linking: redirect the component's pin pointer to signal storage

`hal_link(pin_name, sig_name)` takes the HAL mutex, resolves both objects, and fails before mutation when:

- either object is missing;
- the pin is already linked to another signal;
- pin/signal types differ;
- a `HAL_OUT` would create multiple writers or conflict with bidirectional pins;
- a `HAL_IO` would conflict with an existing output writer;
- a `HAL_PORT` violates its stricter reader/I/O constraints.

On success, the essential pointer transition is:

1. resolve the pin owner component;
2. resolve `pin->data_ptr_addr` (the shared-memory address containing the component-visible pin pointer);
3. compute the signal value address in the owner's mapping;
4. write that signal address into the component's pin-data pointer;
5. on the first suitable non-port link, copy the pin's dummy/default value into the signal value;
6. increment signal reader/writer/bidir counts according to pin direction;
7. set `pin->signal` to the signal's shared-memory offset.

This proves the documentation's circuit analogy precisely: the signal owns the shared value; linking redirects each component pin pointer to that one value.

### Writer invariant

For ordinary non-port values, one signal may fan out to many `HAL_IN` readers, but the source rejects a second `HAL_OUT` writer and rejects `HAL_IO`/writer combinations that would create ambiguous ownership. Community reports of `signal already has output pin` are therefore direct manifestations of this source invariant, not merely halcmd syntax quirks.

## Unlinking: snapshot signal value back into the pin dummy

`hal_unlink(pin_name)` -> internal `unlink_pin(pin)`.

`unlink_pin()`:

1. returns immediately if the pin is already unlinked;
2. resolves the current signal;
3. redirects the component-visible pin pointer back to `pin->dummysig`;
4. copies the signal's current value into that dummy for ordinary scalar types (ports are reset to empty storage);
5. decrements the signal reader/writer/bidir counters;
6. clears `pin->signal`.

Deleting a signal calls `free_sig_struct()`, which finds every linked pin and invokes the same unlink path before recycling the signal metadata. Deleting a component similarly removes its owned functions, pins and parameters; freeing an owned pin first unlinks it from any signal.

The resulting invariant is important for debugging: after unlink, a component pin stops observing the shared signal but retains the signal's last scalar value at the instant of unlink as its independent dummy value.

## Function export is registration, not scheduling

`hal_export_funct(name, funct, arg, uses_fp, reentrant, comp_id)` is restricted to realtime components and rejects calls after the component is ready. It allocates `hal_funct_t`, stores owner/reentrancy/function-pointer/argument state, sets `users = 0`, and inserts the function in the global function list.

Export alone does **not** execute the function. The public API/documentation explicitly separates making a function available from adding it to a thread.

This pinned source also exposes function runtime/maxtime observability as HAL objects; those registrations occur while the component is still unready.

## `addf`: scheduling link creation

`hal_add_funct_to_thread(funct_name, thread_name, position)`:

1. validates HAL/config-lock state and takes the HAL mutex;
2. rejects position `0`;
3. resolves function and thread by name;
4. rejects adding a non-reentrant function when `funct->users > 0`;
5. computes insertion position in `thread->funct_list` (`+N` from head, negative positions from tail);
6. allocates `hal_funct_entry_t`;
7. copies the executable function pointer and arg into the entry and stores a shared reference back to `hal_funct_t`;
8. inserts the entry in the thread's doubly-linked circular function list;
9. increments `funct->users`.

This is a configuration-time list mutation. It is distinct from periodic execution.

## Runtime execution boundary

`hal_create_thread()` creates an RTAPI task whose entry point is `thread_task(new_thread)`. The thread structure owns `funct_list`. During cyclic execution, `thread_task()` walks the list and invokes each entry's saved `funct(arg, thread->period)` in list order when HAL threads are running.

Therefore the end-to-end execution relationship is:

`component rtapi_app_main/init -> hal_export_funct()`

`HAL configuration -> hal_add_funct_to_thread()`

`hal_create_thread() -> rtapi_task_new(thread_task, hal_thread_t*) -> rtapi_task_start()`

`periodic RTAPI wakeup -> thread_task() -> thread->funct_list -> exported function(arg, period)`.

H04 will deepen ordering/runtime semantics; H01 only needs the object-model boundary that exported functions become executable members of a thread through `hal_funct_entry_t` links.

## Failure/reliability boundaries

- All name-list/object-graph mutations above are serialized by the shared HAL mutex; abnormal death while corrupting or stranding that synchronization state can impair system-wide query/configuration access.
- `hal_pin_new()` requires the caller-supplied pointer slot itself to be HAL shared-memory resident; allocating only the pointee and passing a normal process-local pointer variable is invalid.
- Ready-state mistakes fail registration rather than silently appending new pins/functions.
- Signal writer conflicts are rejected before pointer redirection/counter mutation.
- Signal deletion and component deletion intentionally unwind links, preventing surviving pins from retaining a pointer into recycled signal metadata/value ownership.

## Evidence/promotions

The object graph, ready-state registration checks, pin dummy/signal pointer transition, writer-count rules, unlink snapshot behavior, function-entry scheduling relation and cleanup flows are sufficient 1000-level source foundations for a bounded H01 experiment.

Promote deeper questions rather than block H01 unless experiments expose a core contradiction:

- allocator fragmentation/reuse behavior under long-lived dynamic HAL reconfiguration -> 2000 / MEDIUM;
- cross-process mapping/address correctness under unusual userspace component layouts -> 2000 / MEDIUM;
- robust recovery after owner death while the shared recursive HAL mutex is inconsistent -> 2000 / HIGH;
- detailed `thread_task()` timing/order semantics -> H04 now, deeper jitter/fault treatment later.
