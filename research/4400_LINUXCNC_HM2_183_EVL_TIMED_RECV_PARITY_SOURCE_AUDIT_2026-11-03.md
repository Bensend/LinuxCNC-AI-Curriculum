# HM2-183 — EVL timed receive versus POSIX and unconditional transaction validation (2026-11-03)

**4000 / NON-GRADUATED; source inspection only.** LinuxCNC development revision `cdf957bd00bbcc4c569f01e7eed5b154422b816c`. Follow-up to [HM2-182](4400_LINUXCNC_HM2_182_POSIX_TIMED_RECV_AND_DECODE_GATE_SOURCE_TRACE_2026-11-03.md). No LinuxCNC or machine execution.

## Question
Does the EVL network backend eliminate the HostMot2 wrong-counter-at-deadline acceptance path? **Prediction before inspection:** even if EVL enforces a receive timeout more tightly than POSIX, the shared caller's conditional counter comparison still admits a full-size wrong-counter datagram when its receive returns at or after the deadline.

## Primary source and call chain
- [EVL implementation at pinned revision](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth_net_evl.c), `hm2_evl_eth_socket_recv`: calls `evl_read_clock(EVL_CLOCK_MONOTONIC, &ts_timeout)`, adds `recv_timeout_ns` to an **absolute** `timespec` (normalizing nanoseconds), then invokes `oob_recvmsg(board->sockfd, &msghdr, &ts_timeout, 0)`. No explicit post-return timestamp validation in this wrapper. EVL API's exact boundary behavior and clock relationship to `rtapi_get_time` remain **UNKNOWN** without independent EVL documentation/experiment.
- [POSIX implementation](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth_net_posix.c), `hm2_posix_eth_socket_recv`: `ppoll` readiness wait with relative timeout then `recv`; no post-receive deadline validation.
- [Shared Ethernet driver](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c), `hm2_eth_receive_queued_reads`: after full-length packet, copies TRAM data, then retries wrong read counter only when `confirm_rw_cnt.read_cnt != read_cnt && t2 < read_deadline`. That condition does not depend on transport selection. A full-size wrong-counter packet at/after deadline can reach the normal path if later error checks allow it.
- [HostMot2 downstream](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hostmot2.c), `hm2_read`: module TRAM decoding has no additional counter comparison.

## Important distinction
**SOURCE-CONFIRMED:** EVL uses `oob_recvmsg` with a computed absolute timeout, unlike POSIX's `ppoll` then `recv`. Both wrappers lack an explicit post-receive deadline check; both feed the same conditional counter validation. **INFERENCE:** a datagram returned at the deadline can reach the wrong-counter acceptance branch on either backend. **UNKNOWN:** whether EVL actually permits a successful receive at/after the deadline in practice, exact clock-domain equivalence, physical consequence, and prevalence. Do not assert that EVL itself violates its timeout contract.

## Review-only correction design (not applied)
At the shared `hm2_eth_receive_queued_reads` acceptance point, validate **packet length and echoed read counter before copying untrusted response bytes into TRAM or declaring the transaction accepted**. On mismatch, retry only while the deadline remains; otherwise follow the existing soft-error path (preserving queue reset, error threshold, write-ack and `-EAGAIN`/IO-error semantics). Time alone must never convert a mismatched counter into a valid response. Review all read-buffer offsets and counter wraparound before constructing a compilable patch.

Suggested pseudocode (NOT a drop-in patch):

```c
if (received_len != expected_len) goto existing_receive_error;
if (echoed_read_counter != expected_read_counter) {
    if (now < deadline) goto retry_receive;
    goto existing_receive_error;
}
copy_verified_payload_to_tram();
```

This design intentionally does **not** reject an otherwise matching response solely because it arrives after the deadline; whether to impose a hard completion deadline is a separate policy question, requiring a defined timing oracle.

## Disconnected deterministic regression contract
Freeze inputs `transport={POSIX,EVL}`, receive-start, receive-complete, deadline, expected/echoed counters, packet length, write-ack, and io_error. A: matching before deadline => one decode. B: wrong counter before deadline followed by match => one decode of matching payload. C: wrong counter exactly at deadline => no decode. D: wrong counter after deadline => no decode. E: short packet => no decode. F: correct counter at deadline => explicitly decide policy, then assert consistently. G: wrong counter with correct write-ack => no decode. H: counter wraps at 32-bit boundary => equality semantics preserved. I: receive timeout/negative return => no decode. J: `io_error` asserted => no decode. For each record queue reset, TRAM writes, LLIO return, error counter and decoder calls. These are **proposed oracles**, not results.

## Transfer to real machines
A Mesa 7i96S step-generator feedback pin is not an independent mechanical encoder. Ethernet transaction freshness, independent feedback, hardware watchdog response, and independent personnel-safety authority are separate engineering questions. Do not inject communication faults into an energized machine. MOTION-144 is still first executable only after isolation of a permitted `[self-hosted, openpressbrake]` runner is independently verified. No hosted Actions.

## Next decision
Inspect exact `hm2_eth_receive_queued_reads` source context to produce a compilable **review-only** patch and a host-independent deterministic test that cannot accidentally write to hardware; alternatively rotate to a distinct motion/interpreter issue if evidence gain is low. Do not promote SOURCE to TEST without recorded execution.
