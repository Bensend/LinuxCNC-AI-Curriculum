# C06 — HostMot2 Communication / Watchdog Function and Symbol Guide

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## `hostmot2.c:hm2_read_request(void *, long)`
Purpose: initiate a servo-cycle bulk read. Stores `llio->period`, refuses work while `io_error` is true, queues TRAM/raw/special reads, sends queued reads, then records `read_requested` and `read_time`.

Important state: `llio->io_error`, `llio->read_requested`, `llio->read_time`, `llio->period`.

Failure behavior: returns before/among queue stages if the low-level driver asserts `io_error`.

## `tram.c:hm2_tram_read(hostmot2_t *)`
Purpose: walk registered TRAM read regions and invoke `llio->queue_read()` for each stable destination buffer.

Failure behavior: returns `-EIO` when a queue operation reports failure.

## `tram.c:hm2_queue_read(hostmot2_t *)`
Purpose: call optional `llio->send_queued_reads()`. For high-latency transports this separates request transmission from response receipt.

## `hostmot2.c:hm2_read(void *, long)`
Purpose: complete the queued read and publish received register data through module-specific TRAM processors.

Behaviorally significant order:
1. ensure read was requested;
2. clear `read_requested`;
3. stop on `io_error`;
4. call `hm2_finish_read()`;
5. on `-EAGAIN`, return for this cycle;
6. stop if `io_error` became true;
7. process watchdog TRAM first, then GPIO/encoder/inmux/resolver/stepgen/etc.

## `tram.c:hm2_finish_read(hostmot2_t *)`
Purpose: call optional `llio->receive_queued_reads()`.

Return contract: negative errors propagate; false/zero becomes `-EIO`; positive success becomes 0. This is the boundary where an Ethernet llio's receive result gates generic HostMot2 module processing.

## `hostmot2.c:hm2_write(void *, long)`
Purpose: assemble and transmit the servo-cycle output register image.

Behaviorally significant order:
1. stop immediately on `io_error`;
2. initialize DDR once;
3. `hm2_watchdog_prepare_tram_write()` first among module prepare functions;
4. `hm2_tram_write()` queues all write regions;
5. module-specific direct writes, including `hm2_watchdog_write()`;
6. raw write;
7. `hm2_finish_write()` sends queued writes.

## `watchdog.c:hm2_watchdog_prepare_tram_write()`
Purpose: put `0x5a000000` in the watchdog reset/pet TRAM register. This occurs before each successful generic write TRAM assembly.

## `watchdog.c:hm2_watchdog_process_tram_read()`
Purpose: interpret received FPGA watchdog status.

Guards: returns if no watchdog, if `io_error` is true, or if `needs_reset` is already nonzero.

Bite path: if status bit 0 is set, logs the bite, sets HAL `watchdog.has_bit=true`, and sets `llio->needs_reset=1`.

Important consequence: watchdog bite detection requires a valid received status image and is therefore observably distinct from a host receive failure.

## `watchdog.c:hm2_watchdog_write()`
Purpose: maintain watchdog enable/timeout and orchestrate post-fault force-write recovery.

Guards: returns on `io_error` and returns while HAL `watchdog.has_bit` remains true.

Recovery: after the user clears the blocking visible condition, `needs_reset` or `needs_soft_reset` causes local status clear plus `hm2_force_write()`. If `io_error` appears during force-write, recovery aborts; otherwise pending reset flags clear.

## `hostmot2-lowlevel.h:hm2_lowlevel_io_t`
Purpose: abstraction between generic HostMot2 and hardware/transport-specific llio drivers.

Relevant callbacks: `read`, `write`, optional `queue_read`, `send_queued_reads`, `receive_queued_reads`, `queue_write`, `send_queued_writes`.

Relevant state: HAL `io_error`; `read_requested`; `period`; `read_time`; `split_read`; `needs_reset`; `needs_soft_reset`.

Contract: llio sets `io_error` on detected I/O error; generic HostMot2 stops calling llio while it is true; the user can clear the HAL parameter to permit reset/re-drive behavior.

## `hm2_test.c:hm2_test_read()` / `hm2_test_write()`
Purpose: hardware-free pretend llio. The pinned source explicitly states that `hm2_test` supplies compiled-in data without special hardware to verify HostMot2 behavior.

C06 use: laboratory seam only. An experiment may instrument this fixture to inject deterministic failures or emulated register status while preserving production generic HostMot2 source unchanged.

## Evidence / diagnostic boundary

`io_error` establishes low-level communication/I/O failure state from the driver contract. `watchdog.has_bit` establishes that generic HostMot2 successfully received and processed a watchdog status image showing a bite. Neither one by itself establishes physical machine safety, actuator state, energy removal, or restart readiness.
