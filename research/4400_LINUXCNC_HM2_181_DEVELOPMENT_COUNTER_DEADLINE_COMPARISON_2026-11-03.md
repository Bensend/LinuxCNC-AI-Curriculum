# HM2-181 — Development-versus-stable Ethernet reply validation and counter provenance (2026-11-03)

**Status:** 4000 NON-GRADUATED. SOURCE-CONFIRMED conditional source path in two immutable revisions; NOT TESTED, no physical-machine claim.

## Immutable source scope
* Stable v2.9.10 annotated tag `4e7abeab3e764a42ef9def932333a1d4004e547b` dereferences to commit `86cdca76fa2a36274c432caa21952b23c267989a`. [Stable hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c), previously recorded file blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`.
* Development snapshot commit `cdf957bd00bbcc4c569f01e7eed5b154422b816c` (upstream master at inspection, 2026-11-03 02:22:10 UTC). [Development hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c). **Do not call moving master an immutable revision.**

## Counter producer/consumer trace
Stable `hm2_eth_send_queued_reads` around lines 848–860 increments `board->read_cnt`, writes the 32-bit value to FPGA timer/scratch space 4 address 0x10, and queues an 8-byte readback from the same space into `board->confirm_read_cnt` (plus adjacent write confirmation). The counter is not a UDP header sequence number. It is a read-after-write FPGA scratch-register echo included in the same queued transaction. Its provenance establishes which *transaction's* echoed value was returned, **not** independent freshness of every hardware register in that packet.

Development around lines 959–974 retains the write/readback design but changes scalar confirmation to `board->confirm_rw_cnt`, including `read_cnt` and `write_cnt`. The read-counter write now uses `memcpy` with an explicit 4-byte static assertion; queued confirmation uses `memcpy` and an explicit 8-byte assertion. This is a representation/packing improvement, not a proof of corrected stale-packet rejection.

## Comparison: same deadline-edge acceptance predicate
Stable `hm2_eth_receive_queued_reads` lines 927–961 requires a full-length response, copies queued payloads, then retries only if `confirm_read_cnt != read_cnt && t2 < read_deadline`. At/after deadline, a full-length mismatched response can bypass the retry check.

Development lines 1039–1075 first computes remaining deadline and calls a timed `eth_socket_recv` only when time remains; otherwise it sets `recv=0`. But after a timed receive returns a full-length packet, the code copies queued data **before** testing `board->confirm_rw_cnt.read_cnt != board->read_cnt && t2 < read_deadline`. If the timed receive completes at/after deadline, the predicate again fails to reject the mismatched counter. The change in receive-timeout handling does **not** eliminate HM2-180's conditional edge.

**Important temporal distinction:** a receive call *starting* after deadline is suppressed in development; a call started *before* deadline that completes at/after deadline with a full-length mismatched packet is the relevant case. Whether the timed socket call can return such a packet, and whether the source's write-ack and IO-error conditions allow normal decode, require a controlled test. Neither branch alone proves a stale physical position reaches HAL.

## Source-grounded review-only correction
An explicit mismatch rejection must occur regardless of deadline. A minimal design is: after copying (preferably before copying) verify the echoed read counter; on mismatch, retry only if time remains; otherwise reset queued reads and take the established soft-error / `-EAGAIN` path. A production patch must account for both revisions' distinct confirmation structures and preserve existing write-ack, early probe, error-counter and packet-size semantics. **No patch applied.**

## Frozen disconnected regression matrix (NOT RUN)
1. Matching full-size reply before deadline: normal decode permitted.
2. Mismatched full-size reply before deadline followed by matching reply: retry then decode matching payload only.
3. Mismatched full-size reply before deadline, no second packet: timeout/error; no normal decode.
4. Mismatched full-size reply received exactly at deadline: reject; no decode (expected fixed behavior, current source permits acceptance).
5. Mismatched full-size reply received after deadline from a call begun before deadline: reject; no decode (same distinction).
6. Receive attempted only after deadline: development skips socket call and follows error path.
7. Matching read counter but mismatched write acknowledgment: preserve existing separate write-error accounting; not equivalent to case 1.
8. Counter wraparound: ensure equality comparison is modulo native 32-bit representation; do not infer packet ordering from greater-than.
9. Queue buffer boundary and short datagram: reject before parsing confirmation fields.
10. Early initialization (`!board->hal`) and reset paths: verify no accidental change to initial read timing or soft-error bookkeeping.

**Test oracle:** record `read_cnt`, echoed read/write counters, monotonic `t2` and deadline, bytes returned, queue reset, soft-error level, LLIO result, `hm2_finish_read` return, and decoder-call count. Use a fake LLIO/socket and clock with no attached drives; runtime is blocked until independently qualified isolated `[self-hosted, openpressbrake]` compute. MOTION-144 retains first executable priority.

## Practical transfer
For 3100 mills, 3200 lathes, 3300 plasma, 3400 routers and 3600 press brakes, a successful `hm2.read` return is not proof of independently measured motion or fresh hardware feedback. Distinguish FPGA stepgen-derived commanded-position feedback, independent encoder feedback, communication error state, and separate personnel-safety authority.

## Next checkpoint
Inspect the timed `eth_socket_recv` implementation and the LLIO-to-HAL read-result chain in this pinned development commit; determine whether any extra response validation exists after the counter predicate. Then construct a review-only deterministic test harness or rotate to a distinct LinuxCNC subsystem if source information gain is exhausted. No lab compute or blind evaluation performed; prior graduated levels and independent safety gates remain unchanged.
