# HM2-180 — Deadline-edge read-counter acceptance in stable HostMot2 Ethernet

Status: **4000 NON-GRADUATED; SOURCE-CONFIRMED conditional branch in LinuxCNC v2.9.10; runtime UNKNOWN; NOT RUN.** This corrects the overbroad HM2-179 assumption that an unmatched read counter necessarily prevents normal decode.

## Immutable source and call path

Upstream LinuxCNC **v2.9.10** `src/hal/drivers/mesa-hostmot2/hm2_eth.c`, contents blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, `hm2_eth_receive_queued_reads` lines 899–961; `hostmot2.c` blob `75619ae3f6925087a6693c5421bbf629f4459d94`, `hm2_read_request` lines 77–92 and `hm2_read` lines 94–122; `tram.c` blob `d060f6cbb448b98f8d42bb54ccb76037e07f765e`, `hm2_finish_read` lines 175 onward. [Stable Ethernet source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), [HostMot2 source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c).

**Source-confirmed:** `hm2_read_request` sets `read_time = rtapi_get_time()` after queueing the read. `hm2_read` calls the request itself only if none is outstanding. Hence the receive deadline is anchored to **request time**, not the start of receive. A separately scheduled read-request function may consume part of the budget before the receiving function runs; precise delay depends on HAL schedule.

**New deadline-edge branch:** In `hm2_eth_receive_queued_reads`, the loop first requires a full-length UDP response (lines 927–937), then copies its fields into queued TRAM destinations (942–944). It retries a mismatched read counter only under the conjunction `confirm_read_cnt != read_cnt && t2 < read_deadline` (946–947). If a **full-length stale reply arrives at or after the deadline**, the retry condition is false even though the read counter is mismatched. The function clears the queue and reaches its success/error-accounting return (949–961), with **no unconditional read-counter rejection**. With acknowledged write and no unrelated error, `result=1` is possible, so `hm2_finish_read` can succeed and `hm2_read` can decode the copied TRAM data. This is a **source-derived conditional possibility**, not a measured occurrence. The prior HM2-179 case E expected no normal decoder update for all unmatched replies; that prediction is too broad and must be split by receive time.

**Important distinction:** A *short* or missing response fails the length test and does not reach this path. A matching full-length reply is accepted normally. A mismatched full-length reply **before** deadline retries. The vulnerable condition requires a full-length mismatched reply with `t2 >= read_deadline`, plus the normal read path and no overriding IO-error state. A mismatched write acknowledgment may change error accounting, so freeze the acknowledged-write control.

**Socket semantics:** The stable `eth_socket_recv` wrapper (same blob lines 772–774) calls `recv` directly; the queued-read caller uses `MSG_DONTWAIT`. No additional read-counter validation occurs in this wrapper. The deadline is checked after the receive call; it is not a hard filter on packet age. `rtapi_delay` on negative recv (928) may affect arrival/timing; no realtime bound is claimed.

## Disconnected falsification matrix (NOT RUN)

A: full-length matching reply before deadline → decode permitted. B: short reply after deadline → `-EAGAIN` under error limit, no decode. C: full-length mismatched reply at `deadline-1ns`, followed by matching reply → second copy and decode. D: full-length mismatched reply at `deadline-1ns`, then no reply → `-EAGAIN`, no decode. **E: full-length mismatched reply at `deadline` or later, write acknowledged → function may return success and decoders may run on stale TRAM.** F: same E with write unacknowledged → record-soft-error branch, not automatically equivalent to E. G: separate `hm2.read-request` and `hm2.read` scheduling → deadline starts at request, not receive. H: no separate request → read invokes request and sets deadline immediately before receiving.

Test design: fake LLIO/socket receive with deterministic monotonic clock and packet bytes, assert decoder-call count, captured TRAM payload, `read_cnt`/`confirm_read_cnt`, LLIO/TRAM returns, `io_error`, and write acknowledgment. Pin full upstream commit and compile exact source before any TEST-CONFIRMED claim. **Do not test on connected drives.** No Actions dispatched: only isolated, independently qualified `[self-hosted, openpressbrake]` may be considered; MOTION-144 remains first executable priority.

## Commissioning/transfer

For Mesa 7i96S and other hm2_eth configurations, a successful HAL read invocation is not an independent freshness witness. Separate packet transport validation, hardware encoder evidence, stepgen-derived position and physical drive-ready feedback. For machine-specific 3100/3200/3300/3400/3600 implementations, treat an unchanged displayed position after communication disturbance as ambiguous. Independent personnel safety remains external to these software diagnostics.

## Next question

Pin stable tag commit and a specific development commit; compare the development receive function's counter/deadline predicate, then inspect how `confirm_read_cnt` is populated and whether the counter field itself can be torn or overwritten. Build a deterministic disconnected regression only when qualified compute is available. This investigation does not establish a physical machine fault or a universal LinuxCNC version defect.
