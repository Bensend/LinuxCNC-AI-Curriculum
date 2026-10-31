# 4000 — HostMot2 Ethernet packet-freshness and direct-read acceptance

**NON-GRADUATED practical review, 2026-10-31T22:39:35Z; all cases NOT RUN.** Companion [ETH-82](../research/4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md) and [ETH-83](../research/4400_LINUXCNC_HM2_ETH_83_DIRECT_READ_SHORT_REPLY_AND_DIAGNOSTIC_SOURCE_AUDIT_2026-10-31.md). Target stable v2.9.10 and pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. A real machine or a network-attached Mesa card is **not** a permitted test environment.

## Minimal isolated test architecture

Use a **fake LLIO socket/receive adapter** with an in-memory packet queue and controlled monotonic timestamps. It must never create a HAL connection to a physical board, drive a NIC, run a live `hm2_eth` against a machine, or connect to motion outputs. A reviewed standalone harness may call the extracted receive decision logic with an injectable clock; distinguish a logic-model result from a compiled upstream-driver result. Freeze source blobs, fixture inputs, expected return value, destination buffer bytes, read/write counters, `packet-error`, `packet-error-level`, `io-error` and whether `hm2_read` processed TRAM **before** executing. The only acceptable compute is a positively qualified, physically disconnected `[self-hosted, openpressbrake]` runner; if that cannot be established, leave all cases NOT RUN. No GitHub-hosted Actions fallback.

## Queued UDP cases

| ID | Injected event | Source-predicted observation | What falsifies it |
|---|---|---|---|
| Q1 | Correct length, matching read/write counts before deadline | Copied input, return success, error level decremented | Rejects correct packet |
| Q2 | Wrong read count before deadline, then correct packet before deadline | Retries; final correct data replaces earlier copy | Returns without retry |
| Q3 | Wrong read count before deadline, no further packet until deadline | `-EAGAIN`, no normal TRAM process this cycle; temporary error set | Processes TRAM as successful |
| Q4 | **Wrong read count** at deadline+1ns, **matching write count**, correct byte length | Stale payload copied, return success, no packet-error (source defect hypothesis) | Rejects stale read count |
| Q5 | Same as Q4 but write acknowledgment one behind, default level 0/limit 10/increment 2 | Stale payload copied, error level 2 and packet-error true, **still** returns success | Returns `-EAGAIN` / rejects payload |
| Q6 | Repeated write mismatches until level reaches 10 | `io-error` asserted, `hm2_read` skips TRAM publication at threshold | No threshold or unexpected publication |
| Q7 | Full-length correct read count but write acknowledgment mismatch | Soft error counted; below threshold current read data may still publish | Read-counter mismatch reported despite equality |
| Q8 | Read counter rollover `0xFFFFFFFF -> 0`, correct echo | Equality comparison still works | Spurious read mismatch solely due wrap |
| Q9 | Wrong-length packet, regardless of sequence | No valid read publication; `-EAGAIN` below threshold | Accepts wrong-length queued reply |

## Direct LLIO read cases

| ID | Fake direct response | Source-predicted observation | Verification |
|---|---|---|---|
| D1 | 4 bytes returned for 4 requested | Copies exactly four bytes, success | Check result/destination |
| D2 | 2 bytes returned for 4 requested | **Current source:** copies four bytes and reports success; last two are indeterminate | Instrument memory validity, never compare indeterminate byte values |
| D3 | 0 bytes returned for 4 requested | **Current source:** success and copy from uninitialized buffer | Check return and instrumentation |
| D4 | Negative receive result | Returns failure without copy | Check return and unchanged destination |
| D5 | Send returns negative, receive later returns 4 | Send error logged but read path continues to receive; conditional success | Separate send and receive witnesses |

## Real-configuration transfer, NOT a machine test

In [public MR-1 `mr1.hal`](https://github.com/LinuxCNC/linuxcnc/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal#L6-L38), identify the Ethernet board address, nominal servo period, `hm2.read` and `hm2.write` ordering, and which packet path the servo cycle uses. Explain why an ordinary `packet-error=0` reading does not prove every published sample was current under Q4. Review independent following-error and watchdog behavior without treating them as personnel-safety devices. Do not change the real configuration.

## Evidence gate and proposed fix acceptance

A candidate fix should first reject wrong read sequences **before any TRAM copy**, even at the deadline; direct LLIO reads should require exact `recv == size`. Preserve good packets, normal temporary-loss semantics, error counters, 32-bit wrap, watchdog and performance. Only a compiled upstream-version test can promote the source prediction to TEST-CONFIRMED. Retain raw fixture inputs, exact source SHA, stdout/stderr, exit code, elapsed job timestamps and review disposition. Do not self-grade blind challenges or modify existing graduation gates.

**Current status:** Q1–Q9 and D1–D5 all **NOT RUN**. No workflow, simulator, build, physical machine, network or evaluation performed.
