# 4000-LC-SSERIAL-54 — multi-remote fault reporting can stop at the first healthy remote

**Status:** SOURCE-CONFIRMED conditional implementation defect; NOT TEST-CONFIRMED; NON-GRADUATED. **Date first audited:** 2026-10-31. This is new LinuxCNC HostMot2/Mesa implementation work, not a personnel-safety qualification.

## Question and novelty
On a Smart Serial port with two or more remotes, can a fault on the later remote be silently skipped by the host's error-reporting loop? The previous curriculum covered hm2_eth packet loss and EtherCAT/CiA402 freshness, not HostMot2 Smart Serial multi-remote status scanning. Do not generalize EtherCAT WKC behavior to this separate protocol.

## Immutable source and intended contract
- LinuxCNC **v2.9.10**, `src/hal/drivers/mesa-hostmot2/sserial.c`, blob `2d23131f41f25e0836db53fe2e77d09975a8c744`, [lines 1707–1714, 2219–2241](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c#L2219-L2241).
- LinuxCNC development **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**, same file, blob `bf70a0cc307dfbae72de8b3fe8d790184923cf9c`, [lines 2155–2177](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/sserial.c#L2155-L2177).
- Official [LinuxCNC 2.9 Smart Serial manpage](https://linuxcnc.org/docs/2.9/html/man/man9/sserial.9.html) describes multi-channel remote detection, port run and fault counters, but does not promise that every remote fault is logged.

## Function-level trace (realtime servo path)
`hostmot2.c::hm2_read` completes TRAM and calls `hm2_sserial_process_tram_read`, which calls `hm2_sserial_read_pins` for each running remote. That reader sets `chan->status` from its CS register. Later `hostmot2.c::hm2_write` invokes `hm2_sserial_prepare_tram_write`; state 3 calls `hm2_sserial_write_pins`, which invokes `hm2_sserial_check_remote_errors` **for its logging side effect**, ignoring its return value.

In both inspected versions, `hm2_sserial_check_remote_errors` iterates remotes but executes:

```c
if ((chan->status & 0x100) == 0) return 0;
```

Bit 8 gates the remote-fault bits 24–31. **SOURCE-CONFIRMED:** a healthy remote encountered before a faulted remote exits the *entire* function, not just that iteration. The later remote's bits are not logged and its `seen_remote_errors` mask is not updated. A prior faulted remote can be logged, but a subsequent healthy remote also forces a zero return, discarding the prior error return (currently ignored by caller).

The port-level `fault-count` increment path is separately based on DoIt-busy and low-byte transfer-error flags, not solely on the remote's bit-8 status. Thus **no new error log and a low fault-count do not establish that every remote reports healthy**. Remote-specific HAL fault pins, where exported, and installed firmware/device diagnostics remain distinct.

## Frozen source-level discriminator (not executed)
Two discovered remotes, indexed 0 and 1. Feed the checker synthetic status `chan0=0x00000000`, `chan1=0x01000100` (remote fault bit 8 + watchdog-fault bit 24), with both seen masks initially zero. **Prediction before runtime:** current code returns zero on channel 0; no channel-1 watchdog message and no channel-1 seen-mask update. Change only `return 0` to `continue`; predicted result: one channel-1 watchdog message, `-EINVAL` return, and the seen mask latched. Repeating the call should not duplicate the message. A reversed case (fault first, healthy second) distinguishes return-code preservation. This is a test design, **not a test result**.

## Evidence ledger and limits
| Claim | Evidence | Classification |
|---|---|---|
| Early return bypasses later remotes | Both pinned source loops | SOURCE-CONFIRMED |
| Later remote fault may go unlogged | Conditional synthetic input trace | INFERENCE from source, not executed |
| Fault count is not a complete remote-health oracle | Separate write-pins counter path | SOURCE-CONFIRMED |
| Any particular 7I77/8I20 actually suffered this | No installed machine, no trace | UNKNOWN |
| Proposed one-line fix works in LinuxCNC realtime | No build or test | UNKNOWN |

A **review-only** one-line candidate patch is at [SSERIAL-54 patch](../patches/4000_LINUXCNC_SSERIAL_54_REMOTE_FAULT_SCAN_v2.9.10_REVIEW_ONLY.patch). It has not been applied upstream or run. Independent personnel safety and remote hardware watchdog behavior cannot be inferred from this logging fix.

## Next evidence
Use a disconnected hostmot2/sserial unit fixture or approved `[self-hosted, openpressbrake]` runner with two fake remotes and captured logs/return codes; verify the existing and patched loops separately. Avoid power, field wiring and real drives. No independent evaluation or graduation claim.
