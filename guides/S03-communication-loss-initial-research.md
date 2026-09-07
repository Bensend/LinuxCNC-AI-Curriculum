# S03 — Communication-Loss Behavior: Initial Research

Status: **RESEARCH**
Course level: 1000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Teach a fresh AI to distinguish **transport error detection**, **LLIO/HostMot2 host behavior**, **stale published HAL state**, **firmware watchdog behavior**, and **physical downstream response** after communication degrades or disappears.

The central debugging prohibition is:

> An unchanged HAL feedback value after communication loss is not automatically a fresh measurement of an unchanged machine state.

## Pinned HostMot2 host boundary

At the pinned revision, `src/hal/drivers/mesa-hostmot2/hostmot2.c` checks the low-level driver's `io_error` state repeatedly.

### Read request

`hm2_read_request()` returns immediately if `llio->io_error` is set. It also re-checks after TRAM/raw/TP-PWM queue setup. Only after successful queueing does it set `read_requested=true` and record `read_time`.

### Read completion/publication

`hm2_read()`:

1. requests a read if one is not already pending;
2. clears the host `read_requested` marker;
3. returns immediately if `io_error` is set;
4. returns on temporary `hm2_finish_read() == -EAGAIN`;
5. re-checks `io_error`;
6. only then calls the per-module TRAM processors that publish GPIO, encoder, resolver, stepgen, Smart Serial, etc. state into HAL.

Therefore, once communication is in an error state, previously published module HAL values can remain visible simply because fresh TRAM data is no longer being processed. They must not be relabeled as fresh feedback.

### Write path

`hm2_write()` likewise returns immediately when `io_error` is set, before preparing cyclic module writes, submitting TRAM, applying change-detected register writes, or calling `hm2_finish_write()`.

This establishes a source-level host boundary: a persistent LLIO communication error can stop both fresh feedback publication and fresh HostMot2 command delivery from the normal host paths.

It does **not** by itself establish what the FPGA outputs, drive enables, mechanics, or external safety hardware do after communication loss.

## Pinned hm2_eth error escalation

Pinned `src/hal/drivers/mesa-hostmot2/hm2_eth.c` maintains a communication-error counter and exports a packet/error level. When the accumulated error level reaches the configured packet-error limit, the driver sets the LLIO `io_error` true and marks the packet-error-exceeded state.

The receive path also contains explicit recovery bookkeeping: if the error counter was at the limit but the user has cleared `io_error`, the counter can be reset so communication can be attempted again. Exact read-timeout/error-increment/decrement behavior still needs a complete pinned call-flow trace before S03 advances to SOURCE.

## Current documentation reconciliation

Current `hm2_eth(9)` documentation exposes:

- `packet-error`, the most recent cycle's read/write error indication;
- `packet-error-level`, accumulated recent error level;
- `packet-error-exceeded`, limit reached;
- `packet-error-total`, cumulative packet errors;
- `packet-error-limit`, the level at which an error becomes permanent and `io-error` becomes TRUE;
- `packet-read-timeout`, which may be expressed as a percentage of the realtime thread period or an absolute time, with documentation warning that too-low values can create spurious errors while too-high values can create realtime delay errors.

This provides a useful teaching distinction between **a transient packet error** and **the persistent LLIO `io_error` boundary** that causes HostMot2 host functions to return early.

## Community evidence — field guidance, not authority

Historical LinuxCNC field reports provide useful failure-mode leads:

- poor Ethernet latency can produce read timeouts; community guidance describes consecutive errors escalating until communication is disabled and recommends observing `io_error` and read timing;
- earlier hm2_eth versions handled dropped packets differently, demonstrating why version-pinning is essential when reasoning from forum posts;
- users report real machines where pulling Ethernet causes board/output/watchdog effects, but those observations are board/configuration-specific and cannot substitute for source trace or physical validation of a different machine.

Community evidence is therefore retained as a debugging lead, not as proof of current pinned semantics or safe physical behavior.

## Failure-domain taxonomy

| Layer | Representative state/event | What it can establish | What it cannot establish alone |
|---|---|---|---|
| Ethernet transport | timeout, missing/wrong response, packet error | a communication transaction failed | machine stopped, FPGA safe state |
| `hm2_eth` policy | error level/limit, `io_error` set | driver has escalated transport failures to persistent LLIO error | downstream actuator state |
| HostMot2 host | read/write functions return early | no fresh normal TRAM publication/write processing through those paths | value shown in HAL is fresh; physical command is zero |
| HostMot2 firmware watchdog | bite after missed servicing | documented FPGA I/O ownership/high-Z behavior | universal drive/STO/zero-torque result |
| downstream I/O/drive | enable/STO/brake/contact state | machine-specific physical response if measured/validated | generic LinuxCNC behavior |
| machine mechanics | motion/stopping | actual physical consequence | software cause without correlated evidence |

## Adversarial debugging cases to preserve

1. **Frozen feedback trap:** encoder HAL value remains constant after `io_error`; do not infer the shaft is stationary.
2. **Command-state trap:** motion command pin changes in HAL after transport failure; do not infer the new value reached the board, because normal HostMot2 write can return before transmission.
3. **Watchdog conflation:** `io_error` and a firmware watchdog bite are related failure mechanisms but not identical state/events.
4. **Transient-versus-permanent error:** one packet error need not imply persistent `io_error`; trace the configured error policy.
5. **Recovery trap:** clearing `io_error` may permit host communication attempts again, but does not prove downstream state is synchronized or safe until fresh state is observed and recovery policy is verified.
6. **Version trap:** historical forum behavior must not be silently promoted to the pinned 2026 source revision.

## Experiment direction

A useful no-hardware S03 experiment must exercise production error-state boundaries rather than merely toggle an unrelated HAL pin. Candidate paths:

- a mutable/fault-injecting LLIO fixture that first supplies known fresh TRAM state, then sets `io_error`, proving module publication stops and previous HAL state remains visible;
- a write-capturing fixture that proves no new normal HostMot2 write reaches LLIO while `io_error` is asserted;
- if hm2_eth-specific packet policy can be exercised without a real Mesa Ethernet target, inject bounded transport-return conditions and verify packet-error escalation/recovery.

The first two may fit a HostMot2 fake-LLIO extension already promoted in earlier modules. The third may require a network-aware fixture and should not be faked if the stock test infrastructure cannot provide the relevant transport semantics.

## Exact next checkpoint

Advance S03 from RESEARCH toward SOURCE by tracing pinned `hm2_eth.c` from queued-read completion through timeout/response validation, packet-error increment/decrement, limit crossing, `llio.io_error`, and manual-clear recovery. Then join that transport trace to pinned `hostmot2.c` `hm2_read_request()` / `hm2_read()` / `hm2_write()` early-return paths and document exactly which HAL values can become stale. Only after the call flow is complete should a production-path fault-injection experiment be selected.
