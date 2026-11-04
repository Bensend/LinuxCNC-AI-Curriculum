# MOTION-222 — EtherCAT WC classification and generic PDO publication (4000, NON-GRADUATED)

2026-11-04 UTC. Follows MOTION-221. **Source-only investigation; not an executed machine or network test.**

## Provenance
- Maintained LinuxCNC-EtherCAT [src/lcec_main.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/master/src/lcec_main.c), blob `85fc4a195c1e7c83d27835285e50a9c744e7eecf` (same as MOTION-221).
- Maintained [src/devices/lcec_generic.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/master/src/devices/lcec_generic.c), blob `04d07ea9a00fc8d0d673cc23c1779a5732e29c39`.
- Independently inspectable **historical IgH-derived mirror**, [ribalda/ethercat include/ecrt.h](https://github.com/ribalda/ethercat/blob/master/include/ecrt.h), blob `a0b48ae4f69e826d5a7feadd1097f55dfdaf35bb`; [master/domain.c](https://github.com/ribalda/ethercat/blob/master/master/domain.c), blob `35c9c6e739e4665cf86e2c912c288cfd98b163c3`; [master/datagram_pair.c](https://github.com/ribalda/ethercat/blob/master/master/datagram_pair.c), blob `656c9e9ebdf40c0d9b3dc63bb3ded29c67f0ff79`. **NOT** established to be the maintained/deployed IgH master. IgH 1.6/1.7 API documentation exists at [official EtherLab documentation](https://docs.etherlab.org/ethercat/1.7/doxygen/index.html), but implementation parity remains a dependency.

## Concrete implementation trace
1. IgH mirror `ecrt.h` lines 409–430 defines `EC_WC_ZERO=0`, `EC_WC_INCOMPLETE=1`, `EC_WC_COMPLETE=2`, and domain state containing last working counter plus interpretation. These are *enum values*, not packet timestamps.
2. `master/datagram_pair.c` `ec_datagram_pair_process` adds to WC only when `datagram->state == EC_DATAGRAM_RECEIVED`. Its pair setup computes expected WC based on input/output FMMUs, not simply a count of slaves.
3. `master/domain.c` `ecrt_domain_process` processes datagram pairs and totals counters; `ecrt_domain_state` lines 752–775 classifies zero as ZERO, exact expected as COMPLETE, and any other nonzero as INCOMPLETE. Thus a received but partially acknowledged exchange can be INCOMPLETE; missing datagrams contribute no WC.
4. Maintained lcec `lcec_read_master` processes queued domains, retrieves domain state, and invokes slave `proc_read` when that unit was processed, without a WC COMPLETE condition (MOTION-221).
5. Maintained `lcec_generic_read` lines 121–171 obtains `pd=lcec_slave_pd(slave)` and copies bit/s32/u32/float values from the PDO image into HAL output pins, gated on pin direction/initialization, **not on WC state**. This establishes a direct conditional publication path for whatever bytes are present in the PDO image after domain processing, including when WC is INCOMPLETE. It does **not** prove that the bytes are stale or corrupted.

## Critical boundary: buffer lifetime still unresolved
A domain's WC reports exchange participation, not a per-byte age. The generic callback has no independent validity or sequence check. Whether an absent response leaves a previous input value, a zero, or a mixture depends on IgH datagram/domain buffer ownership, receive-copy behavior, redundancy, and the specific exchange. **Do not assert that an incomplete WC necessarily preserves last-cycle encoder feedback.** A valid diagnostic trace should record both WC and application PDO values at the same servo-cycle index.

## Disconnected review fixtures (not executed)
| Expected WC | Actual WC | IgH mirror classification | Generic callback if lcec unit processed | Interpretation |
|---:|---:|---|---|---|
| 3 | 3 | COMPLETE (2) | invoked | domain exchange acknowledged, no independent position truth |
| 3 | 2 | INCOMPLETE (1) | invoked | input values cannot be assumed valid from WC alone |
| 3 | 0 | ZERO (0) | invoked | do not infer PDO bytes are zero |
| 3 | previous 3 | prior COMPLETE when unit not queued | not invoked for that unit | state retained, no new exchange |
| 0 | 0 | ZERO in inspected comparison | conditional | check empty-domain semantics before relying on diagnostic |

Minimal source exercise: inspect the three IgH mirror functions, compute WC classifications for 0/2/3 against expected 3, then follow maintained lcec `process` to `proc_read` to `LCEC_PIN_*_SET`. Contrast a processed incomplete cycle with an unscheduled slow Sync Unit. Verify in a version-matched isolated lab before assigning real-machine behavior.

## Evidence ledger / dependencies
**SOURCE-CONFIRMED (specified blobs):** IgH mirror enum/classification, datagram RECEIVED WC accounting; maintained generic callback publishes PDO image without WC gate; maintained lcec calls callback for processed unit. **ANALYTICAL:** five fixtures. **UNKNOWN:** deployed IgH revision parity, receive-to-domain byte copying and retention under timeout, servo-device-specific callbacks, realtime observation. **TEST-CONFIRMED:** none. No build, runner, physical machine or GitHub Actions used.

Next: inspect version-matched IgH datagram receive/copy and domain buffer ownership (including redundancy); if source inaccessible, rotate to trajectory-planner source rather than asserting stale-byte outcomes. Preserve independent personnel-safety authority, blind gates and existing graduations.
