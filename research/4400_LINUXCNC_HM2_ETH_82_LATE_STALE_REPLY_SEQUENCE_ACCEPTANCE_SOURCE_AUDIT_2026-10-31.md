# 4000-LC-HM2-ETH-82 — Late stale UDP read response can pass the queued-read path

**Session UTC:** 2026-10-31T22:39:35Z. **Scope:** LinuxCNC HostMot2/Mesa Ethernet, source inspection only; NON-GRADUATED. **All proposed tests NOT RUN.** This is a distinct packet freshness/validation question, not a repeat of HAL-19/20 scheduling, HM2-FILTER-75, or the QtPlasmaC CAM work.

## Reproducible source pins

- LinuxCNC **stable v2.9.10**, `hm2_eth.c` blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`: [queued read send, error accounting, receive, lines 835–961](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L835-L961).
- LinuxCNC **development pinned** `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`, `hm2_eth.c` blob `4c671e7609294430f85e6fde923e780be46dc81d`: [receive lines 1012–1077](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L1012-L1077).
- Development `tram.c` blob `7e85334d3ae712b71d4a2bdcc4737b954f437943`: [`hm2_finish_read`, lines 179–189](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/tram.c#L179-L189); `hostmot2.c` blob `f83e48fad84639eb1c095335ce908b4d408a4d38`: [`hm2_read`, lines 94–123](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L123).
- [Development hm2_eth(9) packet-loss documentation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/man/man9/hm2_eth.9.adoc), blob `603da4e6812b2506e2a6403b4f0d85fb12f8783f`, states that read/write counters detect packet loss and describes transient packet-error and stale feedback.
- Real config cross-check: [alexphredorg/mr1 `mr1.hal`](https://github.com/LinuxCNC/linuxcnc/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal#L6-L38), blob `f94bd8f15c4ef40ef0192be5b476b3290bc491cb`, published 2023-10-26, uses Mesa 7i96S at 10.10.10.10 with `hm2.read` before motion/PID and `hm2.write` afterward. It is a publicly shared configuration, **not** an installed-machine witness. Prior scheduling audit [HAL-20](4400_LINUXCNC_HAL_20_MR1_7I96S_PID_PROBE_SSR_POSTGUI_ORDER_SOURCE_AUDIT_2026-10-31.md) remains authoritative for that separate question.

## Exact mechanism

Both revisions append a monotonically incremented read counter to the queued UDP read and expect the returned counter to match. The receive path first checks **response byte count** and copies every queued data slice from the received datagram to its destination, including the TRAM input buffer. Only **after that copy** does it test the returned read sequence:

```c
if (confirm_read_cnt != read_cnt && t2 < read_deadline)
    goto do_recv_packet;
```

(The development struct names are `confirm_rw_cnt.read_cnt` and `confirm_rw_cnt.write_cnt`.) Thus a full-length reply with a **wrong read sequence arriving at or after the deadline** does **not** take the retry branch. The code resets the queue, then tests the *write* acknowledgment, not the read counter again. A matching write acknowledgment causes `decrement_soft_error()` and returns success. A mismatched write acknowledgment increments the soft-error counter but also returns success **until the configured error threshold is reached**. Both variants then allow `hm2_finish_read` to report success and `hm2_read` to publish/process the TRAM data.

### Explicit discriminating trace (logical fixture, not observed network traffic)

Assume queued read #12 expects 8 payload bytes and write count #8. Receive a full-length datagram at `read_deadline + 1 ns` carrying **read count #11**, **write count #8**, and stale data. The condition `wrong-read && t2 < deadline` is FALSE, so stale data has already been copied and `decrement_soft_error` reports success. The ordinary `packet-error` indicator can be FALSE. If the reply instead confirms write #7, the driver increments `packet-error-level`; with default increment 2, limit 10 and starting level 0, it still returns success and processes the stale input. The latter numerical example assumes the default settings and no other errors.

If a wrong-sequence packet arrives **before** the deadline, the code retries. If that retry times out, `-EAGAIN` suppresses normal TRAM processing for the cycle; the earlier copy occurred, but it must not be confused with newly published HAL feedback. The late-deadline branch is different. Correct-length/sequence delivery and physical UDP timing have not been demonstrated.

## Diagnostic significance and boundaries

The driver's `packet-error` and `io-error` are **not a complete per-sample freshness proof**. Even when packet-error is true, the current soft-error return value may allow processing. A timestamp, counter and output/error trace must be captured separately before attributing a following-error, index-homing problem, or probing result to Ethernet. The documented transient-packet-loss tolerance is intentional; this analysis does not imply that every lost packet becomes an accepted stale sample. A real Ethernet switch, Mesa firmware behavior, kernel scheduling and physical actuator response are **UNKNOWN**.

**Source-confirmed conditional:** copy-before-read-sequence-verdict, deadline-gated retry, write-only final verdict, success below soft-error threshold, TRAM publication path. **Inference:** possibility of an accepted stale input under the exact stated datagram/timing conditions. **TEST-CONFIRMED:** none. **Physical machine consequence:** unknown. Ordinary HostMot2 watchdog and LinuxCNC following-error checks are not independent personnel-safety authority.

## Review-only corrective direction (NOT a tested patch)

A candidate change should validate **both packet length and read sequence before copying any queued data**. Reject or retry a wrong-sequence datagram regardless of whether its arrival time is at/after the deadline; when the deadline expires, return `-EAGAIN` or escalate consistently with the existing soft-error policy. Preserve valid write-acknowledgment error accounting and avoid changing hard-fault behavior without regression tests. Test stale, duplicate, late, missing and wrong-length packets, including 32-bit wraparound, before considering an upstream submission. See [bounded acceptance guide](../guides/4000-linuxcnc-hm2-ethernet-packet-freshness-disconnected-acceptance-2026-10-31.md).

**No build, simulation, network injection, workflow, physical motion, or independent evaluation.** No new lab-runtime evidence. The closed 1000/2000/F02/3000 levels and independent OpenPressBrake G0/G1 gates are unchanged.
