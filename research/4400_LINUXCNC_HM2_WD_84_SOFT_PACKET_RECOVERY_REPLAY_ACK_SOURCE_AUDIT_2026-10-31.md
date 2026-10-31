# 4000-LC-HM2-WD-84 — Soft packet error, watchdog recovery and unconfirmed replay (2026-10-31)

**Status:** NON-GRADUATED; SOURCE-CONFIRMED conditional paths, DOC-CONFIRMED public interface, TEST-CONFIRMED **none**. No physical Mesa, network, LinuxCNC runtime or FPGA image was accessed. This is **not** a personnel-safety analysis or a machine restart authorization.

## Question and predecessor
When a Mesa Ethernet read fails **below** the permanent packet-error threshold, does HostMot2 simply skip one feedback update, or does it also replay hardware configuration? Is a successful return from recovery evidence that the FPGA accepted it? The predecessor [ETH-82](4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md) investigated read-sequence freshness, not the recovery write path; [ETH-83](4400_LINUXCNC_HM2_ETH_83_DIRECT_READ_SHORT_REPLY_AND_DIAGNOSTIC_SOURCE_AUDIT_2026-10-31.md) investigated direct reads. This is a new causal **write/recovery/acknowledgment** boundary.

## Immutable sources inspected
- Stable v2.9.10 annotated tag peeled to commit `86cdca76fa2a36274c432caa21952b23c267989a`; development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Exact source:
  - [stable hm2_eth.c record_soft_error lines 871–885](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L871-L885), [queued receive lines 899–961](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L899-L961), [queued send lines 1021–1070](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L1021-L1070).
  - [stable hostmot2.c hm2_read/write lines 94–174](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L174), [hm2_force_write lines 1816–1840](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2.c#L1816-L1840).
  - [stable watchdog.c process/status lines 33–53](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/watchdog.c#L33-L53), [write/recovery lines 220–302](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/watchdog.c#L220-L302).
  - [stable tram.c hm2_finish_write lines 205–214](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/tram.c#L205-L214).
  - [development watchdog.c lines 253–304](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/watchdog.c#L253-L304), [development hm2_eth.c record_soft_error lines 984–998](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L984-L998), [development queued send lines 1147–1207](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L1147-L1207).
- [Official HostMot2 watchdog manual](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html) describes 5-ms default, watchdog `has_bit`, high-impedance board pins on a bite, and manual clearing of the latch.
- [Official hm2_eth packet-loss manual](https://linuxcnc.org/docs/html/man/man9/hm2_eth.9.html) describes soft-error-level accumulation and permanent `io-error` threshold. These are interface statements, not proof that a specific machine recovered.
- Real configuration: [MR-1 Mesa 7i96S mr1.hal](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal#L9-L38) sets watchdog to **5,000,000 ns**, schedules `hm2.read` before motion/PID and `hm2.write` after them; [mr1.ini](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.ini#L100-L114) specifies **1,000,000-ns servo period**. This is a public configuration, **not** an installed board observation.

## Exact source-level call path
1. A full queued read response fails its size/deadline check. `hm2_eth_receive_queued_reads` invokes `record_soft_error`, which sets `llio.needs_soft_reset=1`, raises `packet-error`, adds `packet-error-increment` (default 2) and returns `-EAGAIN` **if the limit is not reached**. At the default limit 10, one isolated failure from level zero is below the limit.
2. `hm2_read` sees `-EAGAIN` and returns **before** `hm2_watchdog_process_tram_read`, encoder, GPIO and other TRAM consumers. Last-published HAL feedback can remain stale. This is not a fresh sensor reading.
3. On the same servo-thread iteration in the inspected MR-1 ordering, `hm2_write` proceeds if `io_error` remains false. It prepares TRAM outputs and calls `hm2_watchdog_write` **after** `hm2_tram_write`.
4. If `watchdog.has_bit` is false, `hm2_watchdog_write` sees `needs_soft_reset` and calls `hm2_force_write`, which writes watchdog, GPIO, stepgen timing, PWM, serial and other **configuration registers**. The source does **not** show a blanket clearing of motion commands or machine authority. In particular `hm2_stepgen_force_write` replays timing/master DDS configuration, not a certified safe-output state.
5. `hm2_force_write` wraps the writes with `set_force_enqueue(1)` and `set_force_enqueue(0)`. The latter flushes the recovery packet. **Its return value is ignored**. In both inspected versions, the Ethernet send helper can return failure without setting `llio.io_error` at that point.
6. Back in `hm2_watchdog_write`, the code checks `io_error`, then clears `needs_reset` and `needs_soft_reset`. The clear can occur even if the recovery UDP send failed. The subsequent ordinary `hm2_finish_write` in `hm2_write` has its return value ignored; a later read's write counter may supply a *separate* delayed indication of write loss. This is **not** a same-cycle proof of FPGA register acceptance.

### Three distinct meanings of 'recovered'
- **SOURCE-CONFIRMED host bookkeeping:** `needs_soft_reset=0` after the code path, conditional on no `io_error` at its check.
- **UNKNOWN network delivery:** the queued send can fail or be lost; success of the send syscall is not a device acknowledgment.
- **UNKNOWN FPGA/axis state:** watchdog register and board output state, physical enable and motion authority require independent observation. A successful driver recovery message is not an installed-machine recovery certificate.

### Important alternative paths
- On `packet-error-level >= packet-error-limit`, `record_soft_error` sets `io_error`; `hm2_write` returns early. Operator/manual clearing of `io_error` is a separate prerequisite.
- If the firmware watchdog actually bit, `watchdog.has_bit` is latched on a successful read and blocks `hm2_watchdog_write` until it is cleared. Clearing `io_error` alone is not the same as clearing `has_bit`.
- When `needs_reset` is already set, the watchdog TRAM read path deliberately does not overwrite the latch, avoiding a race with the user clearing `has_bit`.
- If the firmware lacks a watchdog module, `hm2_watchdog_write` immediately returns; this recovery path does not execute. Do not generalize to every Mesa firmware.
- The prior [ETH-82](4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md) describes an additional *read-sequence validation* gap, so successful communication counters alone are not an independent physical oracle.

## Practical MR-1 timing calculation (INFERENCE)
With a nominal 1-ms servo period, a 5-ms watchdog setting spans five **nominal** servo intervals. It is not a guarantee of five tolerated missed Ethernet transactions: jitter, scheduling, packet latency, FPGA timer phase and prior elapsed time matter. The Ethernet default read deadline is 80% of servo period (nominal 0.8 ms here), not the 5-ms watchdog duration. A packet read timeout and a hardware watchdog bite are **different events**.

## Evidence ledger
| Statement | Class | Limit |
|---|---|---|
| Below-limit read failure sets soft-reset and skips TRAM consumers | SOURCE-CONFIRMED both revisions | only specified branch |
| Next write can force-replay hardware configuration | SOURCE-CONFIRMED both revisions | requires watchdog, no io-error, has-bit false |
| Recovery flags can clear without verified Ethernet replay acceptance | SOURCE-CONFIRMED both revisions | send/ack timing, not a physical result |
| Installed 7i96S will resume/stop motion in a particular way | UNKNOWN | firmware, drive, wiring, authority, runtime missing |
| Independent personnel safety is supplied by HostMot2 | NOT CLAIMED | requires separate qualified authority |

## Engineering use and next evidence
In a disconnected fixture, freeze before testing: one below-limit read timeout, send failure during forced replay, `io_error` and `has_bit` latch combinations, subsequent successful acknowledgment, and independent command/feedback witnesses. Capture `packet-error`, `packet-error-total` (where exported), `packet-error-level`, `packet-error-exceeded`, `io_error`, `watchdog.has_bit`, write-counter observations, servo iteration and output state. **Do not use a physical Mesa or any actuators.** See [verification guide](../guides/4000-linuxcnc-hm2-watchdog-soft-recovery-verification-2026-10-31.md).

**Uncertainty/promotion:** A source-only finding does not reopen graduated modules. Need compiled stubbed LLIO tests and independently isolated runtime for TEST-CONFIRMED status. Personnel safety authority and all existing evaluation gates remain unchanged.
