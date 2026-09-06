# H01 community findings — connectivity, component readiness, and HAL object boundaries

Research date: 2026-09-06.
These are investigation/teaching leads, not implementation authority; source reconciliation is recorded below.

## Multiple-writer errors are a real HAL invariant

LinuxCNC forum thread: `NET: can not add OUT pin .. it already has out pin` (2017)

URL: https://www.forum.linuxcnc.org/49-basic-configuration/33684-net-can-not-add-out-pin-it-already-has-out-pin

Field report: a user encountered an `already has out pin` error and initially interpreted physical I/O direction as HAL signal-flow direction. Experienced responders emphasized that HAL pin direction is from the component's perspective and that a signal cannot be given multiple output/writer pins.

Classification: **COMMUNITY-REPORTED**, independently **SOURCE-CONFIRMED** at pinned revision `8bf4605...`: `hal_link()` rejects a `HAL_OUT` when `sig->writers > 0` or `sig->bidirs > 0`, and rejects `HAL_IO` when an output writer already exists.

Teaching consequence: do not explain this as a `net` parser limitation. It is the object-model ownership invariant enforced by `hal_link()`.

## One pin cannot belong to two signals

LinuxCNC forum thread: `Spindle MDI and Gcode Control problem` (2018)

URL: https://forum.linuxcnc.org/38-general-linuxcnc-questions/35396-spindle-mdi-and-gcode-control-problem

Experienced community explanation: a pin already linked to one signal cannot be linked to a second signal, while a signal can connect many compatible reader pins.

Classification: **COMMUNITY-REPORTED** and **SOURCE-CONFIRMED**: pinned `hal_link()` explicitly returns an error if `pin->signal` already refers to another signal. Fan-out to multiple `HAL_IN` pins is allowed because reader count is not limited for ordinary scalar signals.

## HAL pin storage must follow HAL shared-memory rules

LinuxCNC forum thread: `How to access rt pins in user space` (2025)

URL: https://forum.linuxcnc.org/38-general-linuxcnc-questions/55435-how-to-access-rt-pins-in-user-space

The reported userspace C example allocates a HAL value but passes a process-local pointer slot to `hal_pin_float_new()`, producing `data_ptr_addr not in shared memory`. The discussion redirects the user toward complementary HAL pins/shared-memory component patterns and existing sampler/streamer examples.

Classification: failure is **COMMUNITY-REPORTED** and independently **SOURCE-CONFIRMED**: pinned `hal_pin_new()` requires the supplied `data_ptr_addr` itself to satisfy `SHMCHK()`, because HAL later rewrites that shared pointer slot from dummy storage to signal storage.

Teaching consequence: the pin API is not merely registering an arbitrary userspace address; the pointer indirection is part of HAL's cross-context/shared-memory design.

## Component-ready usage pattern

Numerous current and historical examples call `ready()` only after creating all intended pins. Public API documentation says `hal_ready()` lets `loadusr -W` wait until a userspace component is available.

Classification: **DOC-CONFIRMED** usage pattern; pinned source adds the important nuance that the flag is reversible (`hal_unready()` / `hal_set_unready()`) and that specific component-owned registration APIs enforce the restriction by rejecting creation while `comp->ready` is set.

Teaching consequence: `ready` should be described as a component registration/synchronization state, not as a global HAL configuration freeze. Global signal creation/linking is controlled separately by HAL configuration locks.

## Open field-reliability lead

The current source and `hal_query_t(3)` documentation establish that HAL object/configuration operations share a global recursive HAL mutex. A01 already showed that killing a participant around this synchronization boundary can invalidate later observations. A focused community search did not produce a comparably strong modern developer post describing automatic robust-mutex recovery after owner death.

Classification: **UNKNOWN** for robust recovery semantics beyond the pinned implementation's force-release/internal accounting paths. Promote detailed owner-death recovery behavior to 2000-level HIGH unless a H01 experiment exposes it as necessary for basic object-model correctness.
