# 4000-LC-HM2-ETH-11 — HostMot2 Ethernet split-read, stale HAL feedback and packet-count deadline

**2026-10-30 | LinuxCNC-first source continuation | NON-GRADUATED | no runtime/physical test.**

## Why this branch, not a duplicate watchdog lesson?

The [2026-09-15 HostMot2 watchdog first pass](4000-hostmot2-watchdog-recovery-first-pass-2026-09-15.md) studied FPGA watchdog bite, latching and recovery, but explicitly left Ethernet transaction model and servo latency for later. The [QtPlasmaC Mesa HAL-order audit](4400_LINUXCNC_QTPLASMAC_MESA_02_TORCH_OUTPUT_DB_ARCOK_HAL_ORDER_SOURCE_AUDIT_2026-10-30.md) established one particular process-feedback ordering. This new branch traces the **generic HostMot2 read request → Ethernet packet validation → HAL feedback update → write** boundary and an unresolved count-mismatch corner case. It is not a second watchdog or safety-course module.

## Pinned evidence

Development [LinuxCNC `24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886):

- [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `f83e48fad84639eb1c095335ce908b4d408a4d38`: `hm2_read_request` ~76–92, `hm2_read` ~94–123, `hm2_write` ~126–177, per-board HAL function exports ~1695–1715.
- [`tram.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/tram.c), blob `7e85334d3ae712b71d4a2bdcc4737b954f437943`: `hm2_tram_read` ~153–166, `hm2_queue_read` ~169–176, `hm2_finish_read` ~179–189, `hm2_finish_write` ~209–217.
- [`hm2_eth.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hm2_eth.c), blob `4c671e7609294430f85e6fde923e780be46dc81d`: `hm2_eth_send_queued_reads` ~930–979, `record_soft_error` ~981–1000, `hm2_eth_receive_queued_reads` ~1012–1078, `hm2_eth_send_queued_writes` ~1147–1178, `llio.split_read=true` ~1238, low-level callback registration ~1612–1618.
- [`hm2_eth(9)`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hm2_eth.9.adoc), blob `603da4e6812b2506e2a6403b4f0d85fb12f8783f`, PACKET LOSS ~94–117 and pins/parameters ~119–153.
- [`hostmot2(9)`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc), blob `da9f56a494f345fc1920878ace5729d80377e7dd`, functions ~1409–1435.
- Stable [v2.9.10 `hm2_eth.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, `hm2_eth_receive_queued_reads` ~899–962.

## End-to-end cycle and freshness

1. `hm2_eth` registers low-level `queue_read`, `send_queued_reads`, `receive_queued_reads`, `queue_write`, `send_queued_writes` and sets `llio.split_read=true`. Generic HostMot2 exports `<board>.read-request`, `<board>.read` and `<board>.write` as HAL thread functions. **SOURCE-CONFIRMED.**
2. `hm2_read_request` queues TRAM and auxiliary reads, calls `hm2_queue_read` to send, then sets `read_requested` and records request time. `hm2_read` issues the request itself when one is not already pending; otherwise it consumes the previously scheduled request. Official `hostmot2(9)` illustrates `read-request A; read-request B; read A; read B` to overlap Ethernet turnaround. **DOC/SOURCE-CONFIRMED:** HAL `addf` ordering affects where communication wait occurs; **not** an automatic one-servo-cycle delay. A correctly ordered split request and read can be in the same thread iteration.
3. `hm2_finish_read` invokes the low-level receive callback. If it returns `-EAGAIN` for a temporary timeout, generic `hm2_read` immediately returns **without** running the encoder/stepgen/GPIO/etc. TRAM-to-HAL processing functions. Previously published HAL feedback remains present until a later successful processing pass, unless another path changes it. **SOURCE-CONFIRMED conditional stale-feedback behavior**, not proof of a physical encoder freeze.
4. The Ethernet callback constructs a packet with read/write-count information and a scratch-register readback. A received datagram of the expected byte length is copied into queued TRAM buffers, including `confirm_rw_cnt`. If the **read counter differs** and the reception timestamp is **before** the deadline, the function loops for another packet. If a receive times out/has wrong length, `record_soft_error` increments a bounded error level; before the permanent threshold, the callback returns `-EAGAIN`, so the generic HAL feedback-processing step is skipped. At the configured limit, `llio.io_error` latches and generic read/write paths return until operator recovery. **SOURCE-CONFIRMED.**
5. The documentation explicitly warns that stale encoder feedback during packet loss can affect tuning and home-to-index. It describes an optional `mux2` substitution of commanded position during transient loss. That is a **DOC-CONFIRMED ordinary control/tuning technique, not genuine measured position**, and must never be presented as verified feedback, a safety function, or a substitute for machine-specific recovery checks.

## Narrow deadline/count corner case (investigation lead)

Both pinned development and stable v2.9.10 `hm2_eth_receive_queued_reads` implementations use the equivalent condition:

`if (received_read_count != requested_read_count && receive_timestamp < read_deadline) retry;`

After the deadline, a **full-length** datagram with a mismatched read count falls through that condition. The next error check tests **write-count** mismatch (with a startup guard in development), not read-count mismatch again. If write count happens to match, it calls `decrement_soft_error` and returns success. In development the queued buffers are copied *before* this conditional. **SOURCE-CONFIRMED control-flow possibility:** a late full-length response with a mismatched read count is not unconditionally rejected by the read-count check; it can reach the successful-return path if other conditions allow. This is **not TEST-CONFIRMED** reception of an old UDP packet, not proof that a particular board or machine actually uses wrong encoder data, and not proof that the write-count guard fails in ordinary traffic.

The exact frequency and physical effect require an isolated packet-injection/replay test with a frozen oracle and explicit write-count conditions. The current source evidence already establishes the branch predicate; there is no reason to spend compute simply to rediscover the predicate. Before proposing an upstream correction, verify intended protocol semantics and existing maintainer discussion. A bounded issue search for the exact stale-read-count/timeout terms returned no directly matching issue, **not** an exhaustive absence finding.

## Two failure paths to keep separate

| Event | Generic HostMot2 outcome | Ethernet error accounting | Interpretation |
| --- | --- | --- | --- |
| Read timeout/wrong-length packet while under error limit | `-EAGAIN` causes `hm2_read` to skip TRAM processing | `packet-error` and level increment | Last published HAL feedback may be stale; not a fresh position witness |
| Full-length packet with mismatched read count at/after deadline, matching write count | Callback source can return success; generic TRAM processing may proceed | Read mismatch alone is not rechecked after deadline | Conditional source-level protocol acceptance question; runtime and consequences UNKNOWN |
| Error level reaches limit | `io_error` set; normal read/write paths return | `packet-error-exceeded` asserted | Ordinary communication fault/rearm boundary, not independent safety |

## Practical configuration exercise (unscored)

Given two Mesa Ethernet boards in one servo thread, sketch and justify this **illustrative** order (replace names with actual board names):

```hal
addf hm2_boardA.read-request servo-thread
addf hm2_boardB.read-request servo-thread
addf hm2_boardA.read servo-thread
addf hm2_boardB.read servo-thread
# control/feedback consumers (machine-specific)
addf hm2_boardA.write servo-thread
addf hm2_boardB.write servo-thread
```

Explain why `read-request` is not the same as updated encoder feedback; why `read` may skip updating HAL on a soft packet error; why command-as-feedback substitution is not a physical measurement; and why `packet-error`, `packet-error-level`, `io-error` and watchdog bite are different signals. The placeholder `hm2_boardA` is **not a literal installable component name**. Validate actual `addf` order using `halreport` and machine-specific INI/HAL files before use.

## Evidence, boundaries, next question

**SOURCE-CONFIRMED:** split-read callback architecture; generic read/write TRAM ordering; `-EAGAIN` skips processing; bounded soft-error counter; conditional deadline/read-count fall-through in stable and development.

**DOC-CONFIRMED:** official split-read scheduling example and packet-loss/stale-feedback caveats.

**INFERENCE:** a real control loop can consume stale values across a transient packet-loss cycle; exact motion consequences depend on wiring, loop configuration, timing and the board.

**UNKNOWN:** actual UDP packet sequence/timing, packet-counter semantics under all hardware variants, whether the corner case is exploitable or occurs in practice, measured jitter, physical motion, and safety performance. **TEST-CONFIRMED: none.**

No workflow, simulator, hardware, benchmark, Actions minutes, physical operation or upstream submission. If a later packet-replay test is justified, use **only** a proven isolated `[self-hosted, openpressbrake]` environment; runner dispatch/physical I/O isolation are currently UNKNOWN. No hosted fallback. Personnel safety must be independent of ordinary LinuxCNC, HAL and FPGA control.

**Next source question:** trace the `hm2_eth` read-count and write-count protocol layout and compare exact retry/fall-through semantics with upstream maintainer history; only then decide whether a no-hardware deterministic packet-injection oracle is justified. Alternatively rotate to LinuxCNC EtherCAT HAL scheduling, if this branch reaches an information-gain stop.
