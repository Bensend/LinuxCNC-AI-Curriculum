# HM2-185 — Bounds-checked queued reply counter decoder and stable/development layout (2026-11-03)

**4000 / SOURCE / NON-GRADUATED.** This follows HM2-184. No build, injection, machine test, or workflow was run.

## Pinned evidence

* LinuxCNC development `cdf957bd00bbcc4c569f01e7eed5b154422b816c`, [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c), symbols `hm2_eth_send_queued_reads`, `hm2_eth_receive_queued_reads`, `hm2_eth_reset_queued_reads`. Inspected blob SHA `4c671e7609294430f85e6fde923e780be46dc81d`.
* LinuxCNC stable 2.9.10 commit `86cdca76`, [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/hal/drivers/mesa-hostmot2/hm2_eth.c), same symbols. Inspected blob SHA `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`.

**SOURCE-CONFIRMED:** Both revisions queue a timer-space 8-byte readback after writing the current 32-bit read count to scratch address 0x10. In development, that queue entry's destination is `&board->confirm_rw_cnt`, size `sizeof(board->confirm_rw_cnt)` (asserted 8), and `from` is the accumulated response length. Stable uses `&board->confirm_read_cnt`, size 8, and accesses `confirm_write_cnt` separately. **Important version distinction:** the development structure-based decoder below must **not** be pasted into stable 2.9.10 unchanged. Both revisions currently copy every queued segment into its destination before comparing the read counter, and only retry mismatches while `t2 < read_deadline`.

## Development-only review candidate (not applied; compile status UNKNOWN)

Insert this *after the full-size receive check and before the existing queue-copy loop*. It resolves HM2-184's nonexistent `packet_read_cnt` placeholder without assuming a fixed response offset. The size checks use subtraction to avoid addition overflow.

```c
/* Review candidate for development cdf957bd only. */
int confirm_index = -1;
for (int j = 0; j < board->queue_reads_count; ++j) {
    if (board->queue_reads[j].buffer == &board->confirm_rw_cnt) {
        if (confirm_index != -1) {
            /* invalid queue: duplicate counter destination */
            hm2_eth_reset_queued_reads(board);
            if (!record_soft_error(board)) return 0;
            return -EAGAIN;
        }
        confirm_index = j;
    }
}
if (confirm_index < 0) {
    hm2_eth_reset_queued_reads(board);
    if (!record_soft_error(board)) return 0;
    return -EAGAIN;
}
size_t off = board->queue_reads[confirm_index].from;
size_t n = board->queue_reads[confirm_index].size;
size_t total = board->queue_buff_size;
if (n != sizeof(board->confirm_rw_cnt) || off > total ||
    n > total - off) {
    hm2_eth_reset_queued_reads(board);
    if (!record_soft_error(board)) return 0;
    return -EAGAIN;
}
typeof(board->confirm_rw_cnt) packet_confirm;
memcpy(&packet_confirm, &tmp_buffer[off], sizeof(packet_confirm));
if (packet_confirm.read_cnt != board->read_cnt) {
    if (t2 < read_deadline) goto do_recv_packet;
    hm2_eth_reset_queued_reads(board);
    if (!record_soft_error(board)) return 0;
    return -EAGAIN;
}
/* Existing queued memcpy loop follows only on matching read count. */
```

This is a **source-context review candidate**, not a verified compilable patch: `typeof` is a GNU C extension; the actual translation-unit language/compiler settings, type declaration, queue invariants, realtime stack and warning policy require compile validation. Avoid a blind global replacement of the stable implementation. The candidate deliberately preserves the original post-copy write-ack branch and allows a matching full-length reply after the deadline (existing policy, separately debatable).

**Important additional caveat:** `board->queue_buff_size` is the expected packet length; the preceding `recv == board->queue_buff_size` check establishes actual received length only for that call. The queue's other entries also need their own bounds checks before publishing, or the invariant must be proven at enqueue time. A malformed queue must not cause out-of-bounds reads even when the counter entry is valid.

## Deterministic disconnected verification contract (not executed)

1. Two ordinary response entries plus dynamically positioned counter: correct echo publishes exactly once.
2. Wrong echo before deadline followed by correct echo: first packet does not mutate any destination, second publishes.
3. Wrong echo at deadline or later: no publication; reset and soft error even with matching write acknowledgment.
4. Wrong echo with no prior write: still error, not success.
5. Counter offset exactly `total-8` accepted; offset `total-7` rejected; offset greater than `total` rejected.
6. Counter entry absent, duplicated, or wrong-sized: reject without touching destinations.
7. Counter wraps from 0xffffffff to 0: compare raw 32-bit values, no monotonic comparison.
8. Matching read echo but wrong write acknowledgment: preserve existing write-error path; distinguish successful payload publication from overall return status.
9. Verify stable's `confirm_read_cnt` / `confirm_write_cnt` layout separately; development `confirm_rw_cnt` must not be assumed equivalent without inspecting types.
10. Confirm packet-retry timeout path does not decode stale TRAM in `hostmot2.c`; verify POSIX and EVL separately.

For each case record received length, response deadline relation, read/write counters, destination sentinels before/after, return code, packet-error counters and whether module decode ran. A source-only model is not TEST-CONFIRMED LinuxCNC behavior.

## Decision and next checkpoint

The placeholder has a concrete development-only resolution, but claiming a ready upstream patch would be premature without inspecting the structure declaration, verifying all queued entry bounds, and compiling the actual source. **Next:** trace the `confirm_rw_cnt` declaration and the queue's allocation/reset invariants; prepare a minimal exact-context patch and disconnected harness only when the independent self-hosted isolation gate is met. If no new evidence emerges, rotate to motion/trajectory or real machine configs rather than endlessly re-auditing Ethernet.

MOTION-144 remains the first executable priority after independent qualification of `[self-hosted, openpressbrake]`. No GitHub-hosted runners. Preserve independent safety authority, closed graduations and blind-evaluation separation.
