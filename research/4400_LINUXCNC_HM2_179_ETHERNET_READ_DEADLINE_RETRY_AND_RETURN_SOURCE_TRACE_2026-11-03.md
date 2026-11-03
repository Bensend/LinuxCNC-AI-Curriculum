# HM2-179 — Ethernet queued-read deadline, error return and feedback freshness

Status: **4000 NON-GRADUATED; SOURCE-CONFIRMED for LinuxCNC v2.9.10 and master file snapshots; TEST-CONFIRMED none.** Continuation of [HM2-178](4400_LINUXCNC_HM2_178_WATCHDOG_ETHERNET_ERROR_RECOVERY_SOURCE_TRACE_2026-11-03.md). Inspected 2026-11-03 UTC using upstream GitHub raw source. Master is a moving ref: **its exact commit SHA was not obtained, so treat the development comparison as provisional, not immutable provenance.** Stable v2.9.10 is a tag; exact commit SHA should be resolved before any promotion.

## Source inventory and concrete call chain

* [stable hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), `hm2_eth_receive_queued_reads` lines 899–962; [master hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/master/src/hal/drivers/mesa-hostmot2/hm2_eth.c), same function lines 1012–1078.
* [stable tram.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/tram.c), `hm2_finish_read` lines 175–185.
* [stable hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), `hm2_read` lines 94–122.
* Read chain: HAL hm2.read → hm2_finish_read → LLIO receive_queued_reads → Ethernet receive/deadline/error accounting → tram return translation → early-return or decoding in hm2_read.

## New findings (distinct from HM2-178)

**A. Timeout is a deadline budget, not a guaranteed 1.6 ms blocking receive. SOURCE-CONFIRMED.** Stable lines 914–923 choose read_timeout from HAL or 1,600,000 ns fallback, interpret <=0 as 80% of LLIO thread period, interpret values below 100 as percentages, and clamp below 100,000 ns to 100,000 ns. Deadline is `this->read_time + read_timeout`, not unconditionally `now + read_timeout`. Stable polls `MSG_DONTWAIT`, delaying after negative recv, until expected byte count or deadline. Master computes remaining time and passes it to a different `eth_socket_recv` wrapper. The actual socket timeout semantics, scheduling jitter and packet arrival order remain UNKNOWN.

**B. Wrong-size/missing UDP reply invalidates this cycle's read. SOURCE-CONFIRMED.** Stable 932–937 clears queued-read bookkeeping and calls `record_soft_error`; if it returns true, receive returns `-EAGAIN`. Master 1050–1054 uses `hm2_eth_reset_queued_reads` and same error accounting/return split. Stable `hm2_read` line 103 explicitly returns on `-EAGAIN` before watchdog/encoder/stepgen decode, leaving last published HAL feedback in place. This does not prove that mechanical position is stationary.

**C. Distinguish two error-return branches. SOURCE-CONFIRMED.** Both versions return **0** from LLIO receive when `record_soft_error` returns false (error limit reached), rather than `-EAGAIN`. Stable `tram.c::hm2_finish_read` translates LLIO zero into `-EIO` (and logs), but `hm2_read` checks only `-EAGAIN` explicitly before checking `io_error`. On the normal limit-exceeded path the latched IO error should cause the second guard to return; the exact effects of other possible `-EIO` paths and the master implementation require a separate trace. Do not collapse all failed reads into one return code.

**D. Reply-count validation and copy ordering. SOURCE-CONFIRMED.** Stable lines 942–947 copy queued response fields into TRAM destinations *before* comparing the returned read counter with the current read counter. If the counter does not match and deadline remains, it loops to receive again. Master 1059–1064 retains the same copy-before-counter-check ordering. Therefore **a stale but correctly sized reply can temporarily overwrite the TRAM buffer** before a matching reply arrives. If no matching reply arrives by the deadline, hm2.read exits without invoking module decoders; whether another consumer can observe the intermediate TRAM bytes is UNKNOWN and must not be inferred from this source trace. A matching reply overwrites fields again before normal decode.

**E. Write acknowledgment is separate from read freshness. SOURCE-CONFIRMED.** Stable 953–961 compares `write_cnt` with `confirm_write_cnt`; master 1068–1077 compares `write_cnt` with `confirm_rw_cnt.write_cnt` gated by `has_written_cnt`. The counters diagnose transport acknowledgment, not independent mechanical feedback. This is not a physical-output acceptance oracle.

## Practical diagnostic contract

For a 7i96S commissioning display, distinguish (1) last decoded feedback value, (2) successful decode-cycle count / age derived from a verified acquisition witness, (3) packet-error/IO-error/watchdog state, (4) stepgen-command-derived position versus independent encoder position, and (5) external drive-ready/enable confirmation. **Do not synthesize a “fresh” timestamp simply because the HAL servo thread ran.** If using a userspace monitor, sample rates and race behavior must be characterized before asserting a one-cycle bound.

## Disconnected regression matrix — frozen predictions, NOT RUN

| Case | Receive input | Expected source path / observation |
|---|---|---|
| A | Correct-sized packet, matching read count, acknowledged write | TRAM copy, error-level decrement, decoders may execute |
| B | No reply until deadline, below error limit | Queue reset, `-EAGAIN`, decoders skipped, previous HAL value retained |
| C | Short UDP reply until deadline | Same timeout/error branch as B |
| D | Correct size but wrong read count, then matching reply before deadline | First TRAM copy followed by second; normal decode only after completion |
| E | Correct size but wrong count until deadline | Intermediate TRAM writes possible; no normal decoder update on `-EAGAIN` |
| F | Timeout at error threshold | LLIO 0 → TRAM `-EIO`; check IO-error guard and diagnostic latch |
| G | Correct read count but unacknowledged write | Soft-error accounting despite valid read; do not infer drive actuation |
| H | Master-specific recv wrapper with expired deadline | No positive-time receive call; returns failure/reset path |

Instrumentation: record monotonic send/read-start, each received packet length and counters, read deadline, LLIO return, TRAM return, io_error, decoder-call count and output values. Fake LLIO only, no physical I/O. Pin exact stable and development commit IDs before running; preserve stdout, build command and revision. Only dispatch to independently qualified isolated `[self-hosted, openpressbrake]`; MOTION-144 remains ahead in executable queue.

## Adversarial transfer checks

1. Does `-EAGAIN` mean the FPGA watchdog bit was read? **No; decoding is skipped.**
2. Can a valid-length packet still be rejected? **Yes; read-count mismatch.**
3. Does an acknowledged write prove the stepper moved? **No.**
4. Is a 1 ms servo thread necessarily a 1 ms network read timeout? **No; deadline and settings are distinct.**
5. Does a stale intermediate TRAM copy prove HAL encoder output was corrupted? **No; decoder may not run.**

Evidence limitations: no LinuxCNC execution, hardware, PNCconf-generated configuration, master commit pin, socket-wrapper trace or independent evaluator. Preserve closed levels and independent safety authority.