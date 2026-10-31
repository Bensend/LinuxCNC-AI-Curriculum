# 4000-LC-HM2-WD-85 — Forced Ethernet configuration replay, 1400-byte packet bounds and version delta (2026-10-31)

**Status:** SOURCE-CONFIRMED selected code, INFERENCE capacity consequence, TEST-CONFIRMED **none**. Complements [WD-84](4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md) and previous [ETH-82/83](4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md). No machine/board execution.

## New question
How does the **entire forced configuration replay** fit the Ethernet write packet, and what happens when enqueue or flush fails? This is different from the earlier stale-read and short-direct-read mechanisms.

## Pinned source inventory
- Stable LinuxCNC `86cdca76fa2a36274c432caa21952b23c267989a`: [hm2_eth.h 1400-byte write_packet](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.h#L45-L54); [hm2_eth.c enqueue, flush and set_force_enqueue](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L1021-L1070); [hostmot2.c hm2_force_write](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2.c#L1816-L1840); [watchdog.c recovery](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/watchdog.c#L252-L302).
- Development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`: [hm2_eth.h 1400-byte buffer](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.h#L56-L65); [hm2_eth.c bounds checks](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L1147-L1207); [hostmot2.c hm2_force_write](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hostmot2.c#L1820-L1847); [watchdog.c recovery](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/watchdog.c#L253-L304).
- [stable tram.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/tram.c#L188-L214) checks queued write return values **only if the caller propagates its own return**.

## Stable/development comparison
| Boundary | v2.9.10 | inspected development | Verified implication |
|---|---|---|---|
| Ethernet `write_packet` capacity | 1400 bytes | 1400 bytes | Fixed finite buffer, not an unlimited stream |
| `hm2_eth_enqueue_write` | Appends command and data with **no capacity test** | Tests `used + command + data > sizeof(write_packet)`, returns 0 without appending | Development prevents this individual enqueue overflow; stable can exceed the array **if** cumulative replay is too large |
| `hm2_eth_send_queued_writes` | Appends count command without capacity test | Tests room for count command and counter; if full, resets pointer and returns 0 | Development can drop entire accumulated packet rather than corrupting buffer |
| Send syscall failure | Returns 0, without resetting write pointer/size in that branch | Returns 0 and resets write pointer after attempted send | Stable may carry unsent queued bytes into a later write path; precise subsequent consequences depend on call sequence |
| `hm2_force_write` | Ignores `set_force_enqueue(0)` return | Still ignores `set_force_enqueue(0)` return | **Both** can report/clear recovery bookkeeping without confirmed replay |
| `hm2_write` | Calls `hm2_finish_write` without checking return | Same pattern | No same-cycle reliable application-level send-success witness |

**Source scope:** This is a **conditional capacity boundary**, not proof that any standard 7i96S configuration exceeds 1400 bytes. The total depends on loaded firmware modules, counts and their force-write register sizes. No buffer overflow, memory corruption or dropped packet was reproduced.

## Size-accounting walkthrough
In the inspected Ethernet write path, each queued register operation costs a command header plus its payload; the final write-count command consumes additional bytes. For a deterministic software-only fixture, enumerate every `llio.write(addr, data, size)` issued by `hm2_force_write`, sum `sizeof(command) + size` per operation, then add the count trailer. Do **not** estimate from the number of HAL pins; one write can contain many registers. Compare total with 1400 and run separate cases for 1399, 1400 and 1401 bytes including trailer, under the exact source's packet format.

### Important caveat
Development's bounds checks improve memory safety of individual enqueues, **but** their error return is not automatically promoted to `io_error` by the forced-replay caller. A safe memory bound is not the same as an end-to-end successful configuration restoration. This is a source-grounded separation of memory safety, transport success and application acknowledgment.

## Practical engineering review
For a machine configuration with many modules, capture the actual forced-write call list and aggregate size under a *software-only* mock LLIO. Freeze the expected register list, payload sizes, return codes, reset flags and buffer state before execution. If over-capacity, identify the specific write that crosses the boundary, rather than assuming a particular Mesa card fails. A candidate upstream change would propagate force-enqueue and flush failures to `io_error` or an explicit recovery-failed state, and ensure bounded packet framing/splitting. Do not submit or deploy before maintainer review and isolated regression tests.

## Evidence ledger / next step
- SOURCE-CONFIRMED: stable unchecked enqueue; development per-write and trailer bounds; both ignore forced-flush return; both 1400-byte arrays.
- INFERENCE: sufficiently large force-write sequence could exceed stable capacity or cause development drop; actual module counts/size not measured.
- UNKNOWN: concrete installed firmware, packet-size distribution, send failure frequency, FPGA acceptance, machine output state.
- TEST-CONFIRMED: none. [Verification guide](../guides/4000-linuxcnc-hm2-watchdog-soft-recovery-verification-2026-10-31.md). No new graduation, compute or physical authorization.
