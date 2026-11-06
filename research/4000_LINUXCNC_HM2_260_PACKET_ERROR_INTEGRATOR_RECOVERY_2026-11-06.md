# HM2-260 — Ethernet packet error integrator and recovery gate (4000, 2026-11-06)

**Status:** LinuxCNC v2.9.10 SOURCE-CONFIRMED, NON-GRADUATED; no runtime, FPGA or physical-machine validation. Follows [HM2-259](4000_LINUXCNC_HM2_259_ETH_SERVO_WATCHDOG_RECOVERY_2026-11-06.md). This is a diagnostic model, not a certified safe-restart sequence.

## Pinned implementation and provenance
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), Git blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, lines 871–961, 1527–1578: `record_soft_error`, `decrement_soft_error`, `hm2_eth_receive_queued_reads`, HAL exports.
- [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `75619ae3f6925087a6693c5421bbf629f4459d94`, lines 82–105 and 1437–1447: read gates and **HAL RW parameter**, not pin, `<board>.io_error`.
- [watchdog.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/watchdog.c), blob `73b1a34d2410295f8903118bf0cfd9e00d7166e6`, lines 38–53 and 252–281: `needs_reset` watchdog latch, `needs_soft_reset` recovery and forced reconfiguration.

## Packet error state machine
`record_soft_error` sets `needs_soft_reset=1`, `packet-error=1`, increments `packet-error-total`, then increases the saturating `comm_error_counter` by at least one (default `packet-error-increment=2`). It publishes `packet-error-level`. Once `level >= packet-error-limit` (default 10), it asserts `io_error` and `packet-error-exceeded`. **Equality trips the threshold**. Below threshold it returns true; at threshold false.

`decrement_soft_error` reduces the counter by at least one (default `packet-error-decrement=1`, exported read-only), clamps at zero and clears the transient `packet-error` and `packet-error-exceeded` flags. A successful-sized read is not necessarily a success: after unpacking, the code compares `write_cnt` with `confirm_write_cnt`. A mismatch records another soft error; a match decrements. The receive timeout path returns `-EAGAIN` **only below the limit**; at/above limit it returns zero and leaves `io_error` set. Thus do not describe every missed reply as a recoverable `-EAGAIN`.

**Numerical fixture (source-derived, not executed):** Starting level zero with defaults, consecutive error events yield 2, 4, 6, 8, 10; the fifth trips `io_error`. Intervening confirmed successful cycles decrement by 1 each. Four errors, two successes, one error give 2→4→6→8→7→6→8, so no threshold trip. This is an **integrator**, not simply a consecutive-packet-loss counter. Errors can arise from read deadline or write-confirmation mismatch; the total count is not equivalent to number of missed Ethernet frames.

**Recovery nuance:** At entry to `hm2_eth_receive_queued_reads`, if the counter equals the current limit and `io_error` was externally cleared, the counter resets to zero. This check occurs on a subsequent receive invocation, not necessarily when the HAL parameter is written. The common HostMot2 read and write paths return early while `io_error` is asserted; therefore clearing the parameter is only a precondition for resuming processing, not proof of successful communication. The watchdog write path skips when `io_error` or `watchdog.has_bit` is asserted. When allowed and either `needs_reset` or `needs_soft_reset` is set, it zeroes watchdog status, force-writes FPGA settings, checks `io_error`, and only on successful check clears both reset flags. A soft error alone can therefore request reconfiguration without an observed FPGA watchdog bite. The source's recovery-success message is conditional on `needs_reset`, so **absence of that message does not disprove soft-reset processing**.

## Diagnostic interface: exact types
| Name suffix | HAL kind / access | Default | Meaning |
|---|---|---:|---|
| `io_error` | **parameter**, RW bit | 0 | common driver read/write guard |
| `packet-error-limit` | parameter RW s32 | 10 | saturated threshold |
| `packet-error-increment` | parameter RW s32 | 2 | event increment (minimum 1) |
| `packet-error-decrement` | parameter RO s32 | 1 | confirmed-cycle decrement |
| `packet-error` | pin OUT bit | 0 | last transient event indicator |
| `packet-error-total` | pin IO u32 | 0 | accumulated event count |
| `packet-error-level` | pin OUT s32 | 0 | current integrator |
| `packet-error-exceeded` | pin OUT bit | 0 | threshold indicator |

**Correction to HM2-259 exercise:** query `io_error` with `halcmd show param <board>.io_error`, **not** `show pin`. Verify actual board prefix with `halcmd show param` and `halcmd show pin` first. Avoid clearing the parameter or inducing faults on an operating machine.

## Minimal reproducible source exercise
```sh
git checkout v2.9.10
git rev-parse HEAD:src/hal/drivers/mesa-hostmot2/hm2_eth.c
grep -nE 'record_soft_error|decrement_soft_error|packet_error_limit|needs_soft_reset|confirm_write_cnt' src/hal/drivers/mesa-hostmot2/hm2_eth.c
grep -nE 'io_error|hm2_finish_read' src/hal/drivers/mesa-hostmot2/hostmot2.c
grep -nE 'needs_reset|needs_soft_reset|hm2_force_write' src/hal/drivers/mesa-hostmot2/watchdog.c
```
Reconstruct the 2/4/6/8/10 and 2/4/6/8/7/6/8 sequences independently. In a **separate offline simulator**, if a faithful mock is available, predeclare assertions for threshold equality, confirmed-write mismatch, soft reset and manual-clear counter reset. Do not claim these as executed tests.

## Falsifiable predictions / limitations
1. With defaults and no successful decrement between errors, the fifth event saturates at ten and asserts `io_error`. **Derived, not runtime-verified.**
2. A received correctly sized reply with mismatched write confirmation increases error level rather than decreasing it. **Source-confirmed branch; not packet-injected.**
3. Clearing `io_error` permits the next read path to reset a saturated counter; it does **not** guarantee watchdog status, physical position, or motion enable. **Source-confirmed gate, physical consequence unverified.**
4. After a subthreshold soft error, the next permitted watchdog write may force a configuration write because `needs_soft_reset` is set. **Source-confirmed branch; successful transport unverified.**

**Open:** How queued-read return zero propagates through `hm2_finish_read` at the exact threshold, whether the transport's reset callback changes observable outputs, PCI's distinct transport error semantics, bitstream-level watchdog output behavior, and runtime effects of recovery. Investigate these before making any automatic-restart claim. No new compute or Actions dispatched. Independent personnel-safety authority, existing blind gates, and graduated levels remain unchanged.
