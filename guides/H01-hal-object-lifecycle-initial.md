# H01 — HAL architecture/object lifecycle: initial evidence map

Primary pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.
Status: **RESEARCH / SOURCE STARTED**.

## Scope

H01 begins from R01's graduated realtime/thread model and asks what HAL objects exist, where their metadata/value storage lives, how components register those objects, how objects are connected, and what synchronization/process boundaries make the configuration visible across LinuxCNC processes.

This first pass intentionally stops before a full pin/signal/function registration call flow. It establishes the object/shared-memory model and the first component-lifecycle boundary that the next lesson must deepen.

## Documentation model

Current LinuxCNC documentation describes HAL by analogy to electronic circuits: components expose pins; pins are connected by signals; the signal owns the data value while a pin is effectively a pointer to the value. An unlinked pin points at dummy storage so realtime component code does not need a null-pointer special case.

Current documentation/query interfaces enumerate the principal inspectable HAL object classes as:

- components;
- pins;
- parameters;
- signals;
- functions;
- threads.

The current `hal_query_t(3)` documentation adds an important concurrency warning: the HAL mutex is held while query callbacks execute; blocking I/O, unsafe signal handling, or exiting from a callback can strand HAL access. This is consistent with the lock-failure lessons already discovered experimentally/source-wise in A01 and is a core H01 reliability boundary.

Documentation sources consulted 2026-09-06:

- `https://linuxcnc.org/docs/devel/html/en/hal/basic-hal.html`
- `https://www.linuxcnc.org/docs/master/html/nb/man/man3/hal.3.html`
- `https://linuxcnc.org/docs/master/html/en/man/man3/hal_query_t.3.html`
- `https://linuxcnc.org/docs/html/hal/comp.html`

Evidence class: `DOC-CONFIRMED` for intended/public behavior; implementation details below are independently pinned to source.

## Pinned source: shared-memory root

File: `src/hal/hal_lib.c` at `8bf4605ae81042248add031e94c77300406e0413`.

Global library state includes:

- `char *hal_shmem_base` — mapped HAL shared-memory base;
- `hal_data_t *hal_data` — root HAL shared-data structure at that base;
- RTAPI module/shared-memory IDs used by the library.

For ULAPI callers, `hal_lib_init()`:

1. initializes an RTAPI module identity for the process;
2. opens/creates RTAPI shared memory with `HAL_KEY` and `HAL_SIZE`;
3. maps that shared memory;
4. assigns `hal_shmem_base` and `hal_data`;
5. calls `init_hal_data()` if global initialization is needed.

Failure to initialize RTAPI, open shared memory, map it, or initialize HAL data unwinds the acquired RTAPI/shared-memory resources and returns an error.

Evidence: `SOURCE-CONFIRMED`.

## Shared-memory allocation policy

The same pinned source explicitly separates two shared-memory allocation directions:

- `shmalloc_up()` allocates upward from the base for data expected to be accessed by realtime code;
- `shmalloc_dn()` allocates downward from the top for larger structures accessed mainly during initialization/configuration.

The source comments state this arrangement is intended to cluster realtime-accessed data for cache behavior. Allocation helpers assume the caller already owns the HAL mutex.

This is an important architecture point: HAL is not merely a set of per-process C objects. Its core object metadata and runtime values are coordinated through RTAPI shared memory, with offset/reference helpers used because mappings can differ across processes.

Evidence: `SOURCE-CONFIRMED`.

## Component lifecycle: `hal_init()`

Pinned `hal_init(const char *name)` performs the first object-registration lifecycle:

1. validates the component name;
2. for ULAPI, ensures the HAL library/shared-memory mapping exists via `hal_lib_init()` when needed;
3. creates an RTAPI identity using a `HAL_<name>` RTAPI name;
4. acquires the recursive HAL shared-data mutex before modifying shared metadata;
5. rejects duplicate component names;
6. allocates a `hal_comp_t` structure;
7. records component ID, type, mapped shared-memory base, name, and initial `ready = 0` state;
8. for userspace/ULAPI components records `pid = getpid()`; realtime components store PID 0 at this layer;
9. links the component into the global component list in shared HAL data;
10. releases the mutex and returns the component ID.

This source trace explains why `halcmd show comp` can expose the owning PID of a userspace component, a fact already exploited in A01 to prove `iocontrol.0` ownership by `milltask`.

Evidence: `SOURCE-CONFIRMED`; the userspace PID visibility is also `TEST-CONFIRMED` by accepted A01 run `34000879408`.

## Removal/refcount boundary

Pinned `hal_exit(comp_id)` takes the same shared-data mutex, finds/unlinks the component structure, frees component-owned HAL structures through the component cleanup path, decrements the userspace library reference count, and eventually releases RTAPI/shared-memory resources when no userspace HAL component references remain.

`hal_lib_exit()` refuses to tear down the mapping while component references remain and can enumerate dangling components owned by the process. This gives H01 a useful failure/debugging invariant: a process/library mapping lifetime and a component object lifetime are related but not identical.

Evidence: `SOURCE-CONFIRMED`.

## Shared HAL mutex boundary

Pinned `halpr_mutex_acquire()`/`halpr_mutex_release()` implement recursive ownership around shared HAL metadata. The source tracks lock count, owning thread ID and recursion level in `hal_data`. The comments explicitly say code under this mutex is configuration/query work rather than realtime execution.

This is consistent with current `hal_query_t(3)` documentation warning that callbacks run while the HAL mutex is held. A blocking or abnormally terminated observer can therefore affect system-wide HAL configuration/query access. A01 already demonstrated why force-killing a HAL participant during such a wait/critical-section boundary invalidates subsequent shared-HAL observations.

Evidence: `SOURCE-CONFIRMED` + prior A01 experimental integrity evidence.

## Initial object-model distinction

A fresh AI should carry forward these distinctions:

- **component**: registered owner/lifecycle object;
- **pin**: component-facing endpoint whose effective data pointer can be redirected to signal storage;
- **signal**: named shared value/connectivity object between pins;
- **parameter**: HAL-configurable/inspectable value with access semantics, not a signal connection endpoint;
- **function**: callable realtime HAL work item that may later be scheduled into a HAL thread;
- **thread**: periodic execution container from R01's RTAPI/HAL scheduling model.

These definitions are only the public/architectural layer. H01 still must trace the exact structures, offset references, ownership fields, signal-linking rules and function/thread list mechanics before graduation.

## Community/developer research lead

The A01 lock investigations and current `hal_query_t(3)` warning converge on the same practical field risk: HAL query/configuration is globally coordinated and observer behavior matters. The next community pass should specifically search for developer discussions of stale/dangling components, signal-writer conflicts, component-ready semantics, and HAL shared-memory/mutex recovery rather than generic configuration tutorials.

## Exact next source-work checkpoint

1. Locate `hal_ready()` at the pinned revision and document how the `ready` transition constrains further component registration/mutation.
2. Inventory `hal_pin_t`, `hal_sig_t`, `hal_param_t`, `hal_funct_t`, `hal_thread_t`, and the corresponding list heads/free lists in `hal_data_t`/`hal_priv.h`.
3. Trace one pin creation API into shared allocation and owner linkage.
4. Trace `hal_signal_new()` plus pin link/unlink operations to prove the documented pointer-to-signal-value model from source.
5. Trace function export and `addf`/thread-list insertion separately from runtime `thread_task()` execution.
6. Build a bounded H01 experiment only after the registration/connectivity flow is source-complete.

No physical I/O, hardware control, or functional-safety claim belongs to this initial H01 work.
