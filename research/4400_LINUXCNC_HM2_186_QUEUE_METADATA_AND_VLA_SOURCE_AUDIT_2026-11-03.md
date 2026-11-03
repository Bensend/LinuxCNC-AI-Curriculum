# HM2-186 — Ethernet queue metadata, counter structure, and receive-buffer preconditions (2026-11-03)

**4000 / SOURCE / NON-GRADUATED.** Continuation of HM2-185. No patch applied; no runtime or compiler verification.

## Immutable source provenance

LinuxCNC development commit `cdf957bd00bbcc4c569f01e7eed5b154422b816c`:
- [hm2_eth.h](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.h), `hm2_read_queue_entry_t`, `struct hm2_eth_t`.
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c), `hm2_eth_enqueue_read`, `hm2_eth_send_queued_reads`, `hm2_eth_receive_queued_reads`, `hm2_eth_reset_queued_reads`.

**SOURCE-CONFIRMED:** `hm2_read_queue_entry_t` stores `void *buffer; int size; int from;`; `queue_reads_count` and `queue_buff_size` are signed `int`. `MAX_ETH_READS=64`. `confirm_rw_cnt` is an *anonymous* structure containing consecutive `uint32_t read_cnt` and `uint32_t write_cnt`; a compile-time assertion in the send path requires its size to be eight bytes. There is no named typedef for that anonymous struct. The GNU `typeof(board->confirm_rw_cnt)` used in HM2-185 is therefore a review-only convenience; portable alternatives can decode the first 32-bit field via `memcpy` into a `uint32_t` after validating the eight-byte region, while preserving the existing destination for the post-acceptance write acknowledgment.

**SOURCE-CONFIRMED:** `hm2_eth_receive_queued_reads` declares `rtapi_u8 tmp_buffer[board->queue_buff_size]` *on entry*, before validating a packet or queue entry. Thus a candidate that checks metadata only after receiving cannot protect this variable-length array from zero, negative, or unreasonably large sizes. A robust fix must establish the queue-length and packet-size invariant **before entering this function or before allocating the receive buffer**. The existing 1400-byte `read_packet` is a separate transmit buffer, not proof that every queued receive length is bounded to 1400.

**SOURCE-CONFIRMED:** The enqueue path checks command-packet capacity and queue-entry count, then sets `from=queue_buff_size`, increments the count and adds `size`. The inspected enqueue excerpt does not itself prove that all callers constrain `size` to positive, aligned, and non-overflowing values. The send path checks space for two appended entries, and appends a 2-byte `rxudpcount` and 8-byte counter readback. The reset path sets `read_packet_ptr` to the start, `queue_reads_count=0`, `queue_buff_size=0`; it does **not** zero every queued destination or the previous `confirm_rw_cnt`. Do not treat reset as a feedback freshness marker.

## Corrected design constraints for a review patch

1. Before receive-buffer allocation, require `queue_reads_count` within `[1, MAX_ETH_READS]` and `queue_buff_size` positive and within a justified transport-specific receive maximum. Establish the maximum from actual transport code and protocol, **not** by assuming the transmit buffer size applies.
2. Validate every entry with **signed checks first**: `from >= 0`, `size > 0`, `from <= total`, `size <= total-from`, and `buffer != NULL`. Check the destination contract separately: the queue metadata alone does not prove the pointed-to destination has `size` writable bytes.
3. Require exactly one 8-byte entry targeting `&board->confirm_rw_cnt`; check that the eight-byte counter region is entirely inside the validated packet. Decode `read_cnt` via `memcpy` into `uint32_t` (native representation consistent with the current struct-copy semantics), not an unaligned pointer cast.
4. Check `packet_read_cnt == board->read_cnt` on **every** full-length response, regardless of deadline; if mismatched, retry only if deadline permits, otherwise fail without publishing any queued destinations.
5. Preserve the existing write-counter acknowledgment semantics and error accounting, but distinguish `packet accepted`, `destinations published`, `write ack valid`, and `downstream HM2 decoded` in diagnostics.
6. Avoid publishing any destinations before the counter passes. An invalid queue is a local invariant failure and should be diagnosed distinctly from ordinary network loss; precise error-state integration remains a patch-design question.
7. **Important limitation:** Bounds checking metadata does not prove caller-owned destination buffer capacity. Review all enqueue callers and the LLIO/TRAM contract before claiming memory safety.

## Disconnected verification matrix (DESIGNED, NOT EXECUTED)

| Case | Oracle |
|---|---|
| Zero/negative/oversized `queue_buff_size` | Reject before receive VLA allocation; no destination writes. |
| Negative `from` or `size`, `from>total`, `size>total-from` | Reject before memcpy; no destination writes. |
| `queue_reads_count<1` or `>64` | Reject before entry iteration. |
| Missing/duplicate/short counter entry | Reject; all sentinel destinations unchanged. |
| Correct read echo with counter entry at a nonfixed offset | Publish each entry once. |
| Wrong read echo before deadline, then correct echo | First packet publishes nothing; second publishes once. |
| Wrong read echo exactly at/after deadline | Reject, no publication; preserve packet-error reporting. |
| Counter wraps `UINT32_MAX -> 0` | Equality comparison only, no ordering assumption. |
| Valid read echo, wrong write echo | Preserve existing write-ack failure path; record publication separately. |
| Malformed enqueue caller destination capacity | Requires independent caller/contract inspection; queue bounds alone insufficient. |

**Verification ledger:** SOURCE-CONFIRMED header declarations, receive VLA placement, enqueue/reset logic. INFERENCE proposed correction and impact. UNKNOWN maximum receive size, all enqueue caller preconditions, compiler acceptability, and actual timing/hardware behavior. TEST-CONFIRMED none. No self-hosted or hosted jobs, no lab compute, no machine operations.

## Next decision

The source review has now identified the structure layout and an additional preallocation invariant. **Do not promote the HM2-185 candidate as compilable yet.** Next inspect transport receive size limits and all `hm2_eth_enqueue_read` callers, then draft a precise context patch if justified. To avoid a prolonged Ethernet-only research loop, rotate to LinuxCNC trajectory planning / real machine configurations if this does not produce a testable patch quickly. MOTION-144 remains blocked on independent isolation verification for `[self-hosted, openpressbrake]`. Preserve closed levels, blind evaluation, and independent personnel safety.
