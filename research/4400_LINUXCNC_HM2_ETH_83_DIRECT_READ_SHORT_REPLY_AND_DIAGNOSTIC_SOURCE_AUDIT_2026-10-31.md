# 4000-LC-HM2-ETH-83 — Direct HostMot2 Ethernet read accepts short positive replies

**Session UTC:** 2026-10-31T22:39:35Z. **Source-only, NON-GRADUATED, NOT RUN.** Follow-on to [ETH-82](4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md), but distinct from the queued servo/TRAM path.

## Pinned evidence

- Stable LinuxCNC v2.9.10 [`hm2_eth_read`, lines 787–833](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L787-L833), blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`.
- Development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` [`hm2_eth_read`, lines 880–922](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L880-L922), blob `4c671e7609294430f85e6fde923e780be46dc81d`.
- Development POSIX transport [`hm2_posix_eth_socket_recv`, lines 150–176](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hm2_eth_net_posix.c#L150-L176), blob `4e8ddb48d688015b0b25b7a2fe4d95c87dbd43d1`. `ppoll` followed by `recv` returns the actual datagram byte count; a short nonnegative result is possible in the transport contract.
- Development [HostMot2 `hm2_read` queued read path](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L123) and [TRAM `hm2_finish_read`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/tram.c#L179-L189) distinguish this immediate LLIO read from the normal queued servo transfer.

## Conditional defect mechanism

The direct `hm2_eth_read` builds an LBP16 request for `size` bytes, receives into an uninitialized stack array `tmp_buffer[size + 4]`, then checks only `recv < 0`. For any `recv >= 0`, it performs `memcpy(buffer, tmp_buffer, size)` and returns success. A response of 2 bytes to a 4-byte request therefore copies two received bytes **plus two bytes not initialized by that receive**, while returning success. A zero-byte datagram is also a nonnegative result. This is not a claim that Mesa firmware normally emits short responses: it is an **input-validation boundary** in the host driver, relevant to startup/probe, diagnostic or other direct-read callers. The ordinary queued TRAM path **does** require an exact byte count and is analyzed separately in ETH-82.

Both revisions also log a direct read send error without immediately returning failure; the subsequent receive may succeed or fail independently. The stable direct-write path returns success after logging a failed send, while development's queued-write sender returns failure on a negative send. These are **different functions** and should not be generalized to all Ethernet writes.

### Independent acceptance oracle

For a controlled fake POSIX transport returning `recv=2` on a `size=4` direct read, the source predicts `hm2_eth_read` returns 1 and performs a four-byte copy. Avoid asserting exact values of the two uninitialized bytes; they are indeterminate. For `recv=-1`, the source predicts return 0 without the copy. For `recv=4`, it predicts return 1 and four copied bytes. A proposed fix must require `recv == size` before copying; evaluate logging, retry and error propagation separately.

The current development [hm2_eth(9) manual](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/man/man9/hm2_eth.9.adoc) describes transient loss handling and packet-error signals, but it does not make short direct reads valid. A separate small **DOC/SOURCE wording mismatch** is present: the manual's `packet-error-increment` paragraph says the increment is added in a cycle *without* detected errors; the inspected `record_soft_error` increments on an error, while `decrement_soft_error` subtracts on a successful cycle. This should be corrected as documentation, not confused with a new runtime defect.

## Real 7i96S integration question

The public [MR-1 7i96S HAL](https://github.com/LinuxCNC/linuxcnc/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal#L6-L38) loads `hm2_eth` and uses 1-ms nominal servo scheduling. Its `hm2.read`/write graph uses the **queued** path, so do **not** infer that this direct-read short-response defect manifests every servo cycle. The acceptance guide separates immediate and queued transfers. Verify exact installed LinuxCNC revision, transport backend, hardware/firmware and live `packet-error` pins before a machine-specific conclusion.

**Evidence:** SOURCE-CONFIRMED conditional C path, DOC/SOURCE wording mismatch; no network traffic or runtime reproduction. **Uncertainty:** how often a short datagram occurs on a deployed NIC/board, which direct callers exercise it, and whether any affected initialization continues are unknown. No builds, simulations, physical operations, evaluator or Actions compute. Personnel protection remains outside ordinary LinuxCNC/HAL.
