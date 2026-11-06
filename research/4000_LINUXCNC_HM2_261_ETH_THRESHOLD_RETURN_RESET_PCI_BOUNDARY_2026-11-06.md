# HM2-261 — HostMot2 Ethernet threshold return, reset callback and PCI contrast (4000; 2026-11-06)

**Status:** SOURCE-CONFIRMED bounded for LinuxCNC v2.9.10, NON-GRADUATED. No execution, network injection, FPGA tests or physical-machine operation. Continues [HM2-260](4000_LINUXCNC_HM2_260_PACKET_ERROR_INTEGRATOR_RECOVERY_2026-11-06.md).

## Immutable source provenance
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), Git blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, especially lines 900–980 and 1495–1501.
- [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), Git blob `75619ae3f6925087a6693c5421bbf629f4459d94`, lines 90–122, 1437–1450 and registration reset call near 1411.
- [hm2_pci.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_pci.c), Git blob `a2082286e8cdd61b72da1e9fc41b11ba449e51da`, reset routines around lines 287 and 387. PCI-specific complete error handling remains open; do not assume Ethernet's packet counter applies to PCI.

## Trace: temporary miss versus threshold

In `hm2_eth_receive_queued_reads`, a receive whose byte count differs from `queue_buff_size` clears the queued read bookkeeping, calls `record_soft_error`, and returns **-EAGAIN** if that call reports the level still below the configured limit. At equality/exceedance, `record_soft_error` asserts `io_error`, and the receive routine instead returns **0**. A valid-size packet takes a different branch: it copies queued data, checks the acknowledged write count, then returns `1` on a confirmed cycle or the boolean result of `record_soft_error` on mismatch.

The common `hm2_read` invokes `hm2_finish_read`, returns early on `-EAGAIN`, and *then* checks `io_error` before calling any TRAM feedback processors. Thus at the threshold the common guard is explicitly designed to prevent publishing the failed cycle's encoder/GPIO/stepgen feedback even though the transport's return code is zero. **This is a two-part source trace, not an executed proof of `hm2_finish_read`'s exact return-value translation.** That intermediate function remains a targeted inspection gap.

A second nuance: the comment in `hm2_eth_receive_queued_reads` calls `io_error` a pin, but `hostmot2.c` exports it via `hal_param_bit_new(..., HAL_RW,...)`; the exported interface is a **HAL parameter**. The counter-reset condition requires `comm_error_counter == packet_error_limit` and `io_error == 0` when the next receive routine actually runs. Changing the limit while stopped can invalidate equality; do not promise that clearing the parameter always resets the counter.

## Reset is not a successful reconnection

The Ethernet transport's `hm2_eth_reset` constructs an LBP16 write to `HM2_ADDR_WATCHDOG` with data `0x0001` and sends it to the board. Its own source comment describes forcing a watchdog bite in 1 ns. The callback returns an error only if the socket send itself fails; a successful send is **not** a readback acknowledgment, proof of an FPGA watchdog bite, or proof of machine-state recovery. The common HostMot2 registration path can invoke `llio->reset` when present. Do not conflate this transport callback with the separate runtime `needs_soft_reset`/watchdog force-write sequence investigated in HM2-260.

**PCI comparison, bounded:** `hm2_pci.c` contains PLX9030 and PLX9054 reset routines operating on PCI controller registers; Ethernet instead emits a network LBP16 watchdog write. The examined PCI source does not establish that the Ethernet `packet-error-level` integrator exists on PCI. Full PCI read/write and fault reporting must be traced before drawing stronger transport-wide claims.

## Reproducible implementation exercise

On a clean checkout pinned to `v2.9.10`:
```sh
git rev-parse HEAD:src/hal/drivers/mesa-hostmot2/hm2_eth.c
git rev-parse HEAD:src/hal/drivers/mesa-hostmot2/hostmot2.c
git rev-parse HEAD:src/hal/drivers/mesa-hostmot2/hm2_pci.c
sed -n '900,980p' src/hal/drivers/mesa-hostmot2/hm2_eth.c
sed -n '90,122p' src/hal/drivers/mesa-hostmot2/hostmot2.c
grep -R -n 'hm2_finish_read' src/hal/drivers/mesa-hostmot2
```

Construct a four-row offline decision table: (1) short reply below threshold -> `-EAGAIN`; (2) short reply at threshold -> `io_error=1`, transport return 0; (3) full reply, write-confirm mismatch below threshold -> transport return 1 but soft error recorded; (4) full reply, mismatch at threshold -> `io_error=1`, return 0. In every case distinguish transport return from *published* HAL feedback. Verify `hm2_finish_read` and queue semantics before claiming an end-to-end tested outcome. Do not inject these faults on a machine.

## Open evidence / next checkpoint
1. Read `hm2_finish_read` implementation and confirm whether a zero receive return is forwarded, translated, or interpreted as a success. Inspect read buffer commit/rollback behavior before upgrading the feedback claim.
2. Compare `hm2_pci` actual `llio.read/write` callbacks and error indications with Ethernet, rather than inferring identical packet-loss behavior.
3. If source evidence plateaus, rotate to Mesa encoder index or stepgen integration with a pinned real HAL/INI config and independently checkable simulation fixture.
4. Search historical lab evidence before scheduling any new test. Only `[self-hosted, openpressbrake]` permitted for justified compute; no hosted fallback.

**Safety/evaluation:** No automated recovery or motion restart recommended. Independent personnel-safety authority, blind evaluation separation, graduated levels, and existing physical gates unchanged.
