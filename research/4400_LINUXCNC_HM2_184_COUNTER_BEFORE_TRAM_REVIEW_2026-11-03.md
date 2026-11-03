# HM2-184 — Transaction-counter validation before TRAM publication (2026-11-03)

**4000 / SOURCE / NON-GRADUATED.** Revision: LinuxCNC development `cdf957bd00bbcc4c569f01e7eed5b154422b816c`. Follow-up to HM2-183. No build, runtime, hardware or Actions execution.

## Precise question and pre-inspection prediction

Can the receive path be corrected without changing the existing write-ack policy or the queue-reset contract? **Prediction:** moving the counter comparison before the queued-buffer `memcpy`, and routing a mismatched counter at deadline to the existing short-read soft-error branch, prevents stale payload publication without changing the success path for matching replies. The current implementation has a subtle exception: it can accept a mismatched counter after deadline and still report success if the write counter matches.

## Inspected implementation

[Source at pinned revision](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c), `hm2_eth_receive_queued_reads`:

1. The deadline is `this->read_time + read_timeout`, where `read_timeout` may be a percentage of `llio.period`, and the minimum is 100000 ns.
2. `eth_socket_recv` receives into a temporary stack buffer only when positive time remains. A short/missing packet resets the read queue, invokes `record_soft_error`, and returns `-EAGAIN` or zero at error limit.
3. On **full-length** reception, the loop copies each queued segment from `tmp_buffer` into the destination TRAM buffers **before** checking `board->confirm_rw_cnt.read_cnt != board->read_cnt && t2 < read_deadline`.
4. If the counter mismatches and the deadline has expired, the condition is false; the queue is reset and the routine tests the **write** acknowledgment. If that acknowledgment matches (or no prior write exists), `decrement_soft_error` is invoked and `result=1` returned.
5. Therefore a stale full-length packet with mismatched read counter and matching write counter can be accepted and can decrement accumulated soft errors. This is **SOURCE-CONFIRMED conditional behavior**, not an observed physical machine fault. The counter is an FPGA transaction scratch-register echo, not an independent encoder sample timestamp.

## Review-only correction (not applied upstream)

Replace the current **full-length receive success block**, preserving its surrounding timeout setup and normal write-ack branch, with the following source-context pseudodiff. This is deliberately a review candidate, not a compile-verified patch.

```diff
     if(recv != board->queue_buff_size) {
         LL_PRINT("receive_queued_reads: warning (%m) after %llins timeout=%llins\n", t2 - t1, read_timeout_recv);
         hm2_eth_reset_queued_reads(board);
         if(!record_soft_error(board)) return 0;
         return -EAGAIN;
     }
 
     LL_PRINT_IF(debug, "receive_queued_reads(%d) : PACKET RECV [SIZE: %d | TIME: %lld]\n", board->read_cnt, recv, t2 - t1);
 
+    // The counter must be decoded from the current temporary packet
+    // before publishing any queued read buffers. Resolve the actual
+    // confirm_rw_cnt offset and endian representation before compiling.
+    if (packet_read_cnt(tmp_buffer) != board->read_cnt) {
+        if (t2 < read_deadline) goto do_recv_packet;
+        hm2_eth_reset_queued_reads(board);
+        if (!record_soft_error(board)) return 0;
+        return -EAGAIN;
+    }
+
     for (i = 0; i < board->queue_reads_count; i++) {
         memcpy(board->queue_reads[i].buffer, &tmp_buffer[board->queue_reads[i].from], board->queue_reads[i].size);
     }
-
-    if(board->confirm_rw_cnt.read_cnt != board->read_cnt && t2 < read_deadline)
-        goto do_recv_packet;
```

**Additional source finding:** In `hm2_eth_send_queued_reads`, the driver appends `CMD_READ_TIMER_ADDR16_INCR(4)` at address `0x10` and then appends a queued destination `&board->confirm_rw_cnt`, size 8, with `from = board->queue_buff_size`. This identifies the offset dynamically in the queue; the packet is not required to place the counter at a universal fixed offset. **Critical implementation detail:** `packet_read_cnt` above is a placeholder, **not an existing upstream symbol**. A compilable patch should locate the queue entry whose destination is `&board->confirm_rw_cnt`, bounds-check its `from` and 8-byte size, copy those 8 bytes into a local object of the same type (or equivalent representation) using `memcpy` for alignment, then compare its `read_cnt`. Preserve write-ack checking and read-counter wraparound. The old copy-first comparison worked by mutating the struct as a side effect; merely moving the comparison before the copy would break valid replies. The previous copy-first code makes the comparison work by populating the struct as a side effect; moving comparison earlier without decoding the temporary packet correctly would silently break valid replies.

## Frozen disconnected regression matrix (NOT EXECUTED)

| Case | Received bytes | Echo read count | Completion | Write ack | Expected |
|---|---|---|---|---|---|
| A | short | any | before deadline | any | reset queue; soft error; -EAGAIN or zero at limit |
| B | full | matches | before deadline | matches | publish TRAM, reset queue, success |
| C | full | wrong | before deadline, then valid full | matches | discard first, publish second, success |
| D | full | wrong | at deadline | matches | no TRAM publish; reset; soft error |
| E | full | wrong | after deadline | matches | no TRAM publish; reset; soft error |
| F | full | matches | after deadline | matches | preserve existing acceptance policy (deadline policy separate) |
| G | full | matches | before deadline | wrong | preserve write-ack soft-error behavior |
| H | full | wrong | before deadline, then timeout | any | no TRAM publish; soft error |
| I | full | wrong | at deadline | no prior write | no TRAM publish; soft error (must not be treated as success) |
| J | full | matches | before deadline | matches, counter wraps | accepted using correct uint32 equality |

Test invariant: destination TRAM bytes remain sentinel-filled for A/D/E/H/I; the mismatched temporary buffer never modifies externally consumed queued buffers. Record exact return code, error-counter transition, queue reset, and decoded module invocation. Repeat on stable v2.9.10 and pinned development revision; POSIX and EVL receive backends require independent runtime validation. No tests were run in this session.

## Next engineering decision

Use the confirmed `confirm_rw_cnt` queue entry in `hm2_eth_send_queued_reads`; check its offset, size, alignment and endian representation against both pinned revisions, then produce a **compilable** correction and a deterministic injected-reply harness. Do not dispatch until the independently qualified isolated `[self-hosted, openpressbrake]` gate permits MOTION-144. No GitHub-hosted runners. Keep independent personnel safety and blind evaluation gates unchanged.
