# S03 — Communication-Loss Behavior: Source and Field Guide

Status: **SOURCE / EXPERIMENT**
Course level: 1000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Last research refresh: 2026-09-07

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

Pinned `src/hal/drivers/mesa-hostmot2/hm2_eth.c` maintains a communication-error counter. A representative failed queued-read receive path records a soft error; successful cycles reduce the soft-error level. When the configured error level reaches the packet-error limit, the low-level driver asserts persistent `llio.io_error`. Generic HostMot2 then observes that state and stops entering its normal LLIO read/write paths.

The receive path also contains explicit recovery bookkeeping: if the error counter was at its limit but the user has cleared `io_error`, the counter can be reset so communication can be attempted again. That means **manual clear is permission to retry, not proof of resynchronization**.

## Current official documentation reconciliation

Current English `hm2_eth(9)` documentation (checked 2026-09-07):

- describes packet-loss detection through expected packet-count checking;
- states that a detected loss asserts `packet-error` for that cycle and raises `packet-error-level`;
- states that reaching `packet-error-limit` produces a permanent low-level I/O error and sets the board `io-error` state until manually reset;
- explicitly discusses **stale position feedback** during transient packet loss;
- warns that some HostMot2 special functions do not recover perfectly from lost packets, naming encoder index handling as an example;
- documents `packet-read-timeout` and warns that too-low settings can produce spurious read errors while too-high settings can create realtime delay errors.

Official reference: https://www.linuxcnc.org/docs/html/man/man9/hm2_eth.9.html

This documentation independently supports the course's terminology and the stale-feedback hazard. It does not substitute for the pinned source trace because documentation may describe a different build/revision and does not prove the exact host execution path.

## Community evidence — field guidance, not current-version authority

Historical LinuxCNC forum thread "Random read errors on Mesa 7i92" (2016):

https://www.forum.linuxcnc.org/27-driver-boards/30750-random-read-errors-on-mesa-7i92

Developer Jeff Epler reported that the then-current 2.7/master hm2_eth code did not recover well from a missing read request/response and could wait long enough to miss realtime deadlines and possibly cause a 7i92 watchdog bite. Peter Wallace added that dropped packets were unusual on clean short links and emphasized graceful recovery as a design goal.

**Evidence classification:** `COMMUNITY-REPORTED`, historical/version-specific.

The report is valuable because it demonstrates two traps:

1. transport failure behavior has changed over LinuxCNC history, so a forum timing claim must not be projected onto the pinned 2026 source; and
2. a communication problem can interact with realtime deadline behavior and the firmware watchdog, but `io_error`, a missed deadline, and a watchdog bite are distinct states/events.

No precise 2016 timing behavior is taught as current pinned behavior.

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

## Independent-verification experiment

S03-013 uses a test-only mutable LLIO derivative while preserving production `hostmot2.c`. It must establish a valid baseline before fault injection, mutate a fake IOPort register, assert the production HostMot2-owned `io_error`, verify stale HAL publication plus LLIO write suppression, clear the error, and verify host publication/write activity resumes.

Earlier attempts that failed before baseline are classified HARNESS INVALID. `experiments/S03-013-harness-attempts-and-redesign.md` records the three-attempt safeguard and materially redesigned `hal_malloc()`-backed hook storage required by the pinned HAL API.

## Evidence boundaries

Even a passing S03-013 proves only generic HostMot2 **host-side** stale-publication/write-suppression behavior at the pinned revision. It cannot prove:

- physical Ethernet loss probability or exact packet timing;
- FPGA watchdog timing/state;
- connector voltage/current/high-impedance consequences;
- Smart Serial remote state;
- servo-drive enable/STO/torque/brake response;
- machine stopping time;
- safe synchronization/restart after real communication recovery;
- functional-safety performance.

## Exact current checkpoint

Inspect the materially redesigned S03-013 workflow launched from `baf93443d1e8793640c58f81050cdb9a53be0979`. Require Gate A registration/fresh input/write capture before interpreting Gates B-D. If it passes, preserve the accepted result and grade `exams/S03-communication-loss-adversarial.md`; if it fails before Gate A, diagnose it as a new-cycle harness attempt rather than evidence against S03.