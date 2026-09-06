# H01 Adversarial Answer Key

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

1. `hal_ready()` is component lifecycle state, not a global configuration freeze. It marks that component ready; component-owned registration APIs such as new pins/functions reject additions while ready. The studied source also has `hal_unready()`, so the state is reversible.
2. Before linking, the pin points at its component-owned dummy storage. Linking redirects the pin's data pointer to signal-owned shared value storage. For an unowned/new signal linked to this pin, the observed corrected `006` test preserved 1.25: `pre-link-pin=1.25`, `after-link-pin=1.25 signal=1.25`.
3. With the link active, setting the signal to 2.5 makes the pin read 2.5. `hal_unlink()` redirects the pin back to dummy storage and snapshots the signal's scalar value there. After changing the now-independent signal to 3.5, corrected `006` observed `unlink-snapshot=2.5 pin-after=2.5 signal-after=3.5`.
4. A signal is not merely a naming alias. It owns shared typed value storage; linked pins are redirected to that storage. Unlinked pins use their own dummy storage. This explains both propagation while linked and separation after unlink.
5. HAL tracks signal writer ownership. A signal cannot accept two output writers because simultaneous authoritative producers would make value ownership ambiguous and order-dependent. Corrected `006` attempted to attach `siggen.0.cosine` after `siggen.0.sine` already wrote `h01-writer`; `halcmd` returned 1 and reported that the signal already had an OUT pin.
6. Export only registers a callable HAL function. `hal_add_funct_to_thread()`/`addf` creates a scheduling entry in a HAL thread. The periodic thread dispatcher walks its function entries and invokes them. Corrected `006` showed `siggen.0.update` exported with zero users before scheduling, then listed it beneath `h01-thread` after `addf`.
7. Check: (a) function exists/exported; (b) it has actually been added to the intended thread and ordering is sensible; (c) HAL execution has been started; then inspect a bounded state/counter consequence. Also check thread existence/period and command errors before blaming component logic.
8. Conceptual interfaces may be useful hypotheses on another revision, but implementation claims about structure fields, pointer transitions, ready-state checks, writer accounting, and dispatch call flow remain pinned until source is rechecked. Runtime observations are additionally host/build specific.
9. Example: `loadrt threads name1=h01-thread period1=1000000`; `loadrt siggen`; `addf siggen.0.update h01-thread`; `show thread`; `start`. The corrected lab additionally required positive `h01-thread.threadbeat`. This proves scheduling/execution in that software environment, not deadline/jitter bounds or realtime qualification.
10. The cloud experiment has no representative machine I/O path or safety chain and ran under the already-established POSIX non-realtime fallback. Connectivity semantics and function execution therefore do not establish physical signal integrity, deterministic deadlines, hardware suitability, or functional safety.

## Verification result

PASS for the H01 1000-level objective. The corrected `006` artifact is fresh for curriculum SHA `43fae7ea1835058e9f6e85b9c5adcb7360f35195`, exit code 0, and contains all declared gates: 1.25 dummy→signal preservation, 2.5 unlink snapshot with subsequent 3.5 signal separation, second-writer rc=1 with explicit diagnostic, `siggen.0.update` scheduled under the 1,000,000 ns thread, positive threadbeat 254, and the completion marker.

No result is generalized to realtime determinism, physical hardware, or safety-rated behavior.
