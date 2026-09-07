# S03-013 harness attempts and materially redesigned cycle

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Module: S03 — communication-loss behavior  
Decision: **ESSENTIAL NOW; materially redesign harness before another attempt**

## Why this experiment remains current-level work

The predeclared S03 prediction is central: after a known fresh HostMot2 publication, persistent LLIO `io_error` should prevent new module publication and normal LLIO writes, leaving the previous HAL feedback visible until host processing resumes. The 1000-level graduation evidence floor requires independent verification beyond rereading the implementation. Promoting the entire experiment would leave that central claim source-only, so this experiment remains ESSENTIAL NOW.

## Repeated invalid attempt classification

The recent `013-s03-hostmot2-stale-state` runs are **HARNESS INVALID**, not counterevidence to S03. They failed before Gate A could establish a valid independent baseline.

1. Earlier instrumentation exposed test state as ordinary HAL parameters while also trying to alias the HostMot2-owned `io_error`; the run failed before the declared gates. This did not test stale publication or write suppression.
2. A correction moved the test hooks toward pins, but allocated the pin-pointer variables as C static storage. The pinned HAL API explicitly requires the `data_ptr_addr` passed to `hal_pin_*_new*()` to reside in memory returned by `hal_malloc()`. The resulting `HAL: ERROR: data_ptr_addr not in shared memory` prevented `hm2_test` from becoming ready.
3. Subsequent hosted-realtime/setup corrections did not change that invalid pointer-storage model, so repeating them did not create valid S03 evidence.

The three-attempt safeguard is therefore applied now: do not rerun the same pointer-storage design.

## Source-grounded redesign

Pinned `src/hal/hal.h` states that the address of the component's HAL-pin data pointer must point into `hal_malloc()` memory because HAL may later rewrite that pointer when the pin is linked to a signal.

The new harness therefore allocates one small `s03_hal_t` container with `hal_malloc(sizeof(*s03_hal))` immediately after successful `hal_init()`. The container holds the four pin pointers used only for test instrumentation:

- mutable fake IOPort input word;
- LLIO write count;
- most recent LLIO write address;
- most recent LLIO write word.

The pins are exported using addresses of pointer members inside that shared container. Production `hostmot2.c` remains untouched.

The harness no longer creates a duplicate test `io_error` object. `hm2_register()`/HostMot2 already owns and exports the LLIO `io_error` control as `<llio-name>.io_error`; the experiment uses that production-owned parameter.

## Validity gates remain unchanged

This redesign does **not** weaken the predeclared experiment:

- Gate A: successful HostMot2 registration, mutable input publication, and observable LLIO write baseline are mandatory.
- Gate B: backing input changes while `io_error` is asserted, but the previously published HAL value must remain visible.
- Gate C: an output command change during persistent `io_error` must not advance the LLIO write-callback count.
- Gate D: after clearing `io_error`, fresh input publication and LLIO write activity must resume.

Any failure before Gate A is still HARNESS INVALID. A Gate B/C/D mismatch after a valid Gate A is evidence requiring explanation before S03 can graduate.

## Evidence boundary

Even a pass demonstrates only the generic HostMot2 host path at the pinned revision with a test-only mutable LLIO. It does not prove UDP hardware behavior, Ethernet timing, FPGA watchdog behavior, board electrical state, drive response, safe resynchronization, or functional safety.
