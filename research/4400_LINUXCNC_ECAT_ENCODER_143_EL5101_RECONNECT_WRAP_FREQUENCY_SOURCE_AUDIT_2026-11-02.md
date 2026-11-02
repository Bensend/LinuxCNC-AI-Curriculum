# ECAT-ENC-143 — EL5101 incremental encoder: reconnect discontinuity, modular count ambiguity and frequency scaling

**2026-11-02 ~02:36Z | 4000 LinuxCNC implementation / 3200 lathe + 3100 mill + 3400 router transfer | NON-GRADUATED | source-only.**

## Selection and non-duplication

START_HERE, standing mission, level/selection/source policy, current THREAD-142 checkpoint, blind-evaluation ledger, lab ledger and historical PROGRESS were checked. The last checkpoint's two-spindle G76 experiment requires positively qualified, physically disconnected `[self-hosted, openpressbrake]` compute, not established here. Rotate rather than accumulate override tests. Existing [ECAT-12](4400_LINUXCNC_ETHERCAT_12_SYNC_UNIT_FRESHNESS_LATE_OUTPUTS_SOURCE_AUDIT_2026-10-30.md) already covers generic Sync Unit generation/WKC/stale-image processing. This investigation is **device-specific**: Beckhoff EL5101's 16-bit encoder count, reconnect treatment, index latching and published frequency. The historical PROGRESS predecessor search found no EL5101/EL5151 investigation. Do not claim generic EtherCAT safety behavior or installed hardware.

## Pinned source provenance

Out-of-tree maintained [linuxcnc-ethercat/linuxcnc-ethercat](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat), **commit [56515f4aac313551346289d9c227193f50e9602a](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a)** (already used by ECAT-12, not a newly discovered release). Files and Git blob SHAs read directly through the GitHub connector:

- [`src/devices/lcec_el5101.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el5101.c), blob `5e4dc95697f7945273c644e0730fd18d471959ac`, lines 24, 37–77, 104–149, 174–197, **200–292**, 298–321.
- [`src/devices/lcec_el5151.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el5151.c), blob `dde87142b42f50ecbb4e67c29214abc1faac265f`, lines **233–316**: 32-bit comparison.
- [`src/lcec_main.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c), blob `85fc4a195c1e7c83d27835285e50a9c744e7eecf`, lines 102–109 (slave state HAL pins), 1640–1790 (master receive, WKC, periodic state and driver callback).
- [`src/lcec.h`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec.h), blob `019ef59fa2b3d8084523f61e392fea6cf6e9f815`, `LCEC_STATE_UPDATE_PERIOD=1000000000LL`.
- [`documentation/DEVICES.md`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/DEVICES.md), blob `6261b7f99fdf0298964cdcbe8bac864f38defe49`, identifies EL5101 vendor/product `0x2:0x13ed3052` and EL5151 `0x2:0x141f3052`. Testing-status field for EL5101 is blank: **no hardware-verification claim**.

## A. What the EL5101 HAL pins actually represent

`lcec_el5101_init` registers PDO `0x6000:01` status, `:02` signed **16-bit** counter, `:03` latch, `:04` 32-bit raw frequency, `:05` period, `:06` window; output `0x7000:01` control and `:02` counter-set value. `enc-raw-count` is the most recently published 16-bit sample in a signed-32 HAL pin; `enc-count` is a software-accumulated signed-32 total; `enc-pos = enc-count / enc-pos-scale`. `enc-raw-latch` is the captured hardware latch when validity bits are seen. The two `enc-index-*-enable` controls are HAL_IO; driver clears the relevant enable on a valid latch. None of these is a G38 probe result, a hardware timestamp, or a safety channel.

The driver sets `enc-frequency-scale=5e-2` and publishes `enc-frequency = enc-raw-freq * enc-frequency-scale`. An in-source comment says the default is historically wrong, and simultaneously writes **`1e-2 (0.001)`**, which is internally inconsistent (`1e-2=0.01`). With a hypothetical raw-frequency value of 1000, default output is 50; changing the scale to 0.01 would output 10, or 0.001 would output 1. **SOURCE-CONFIRMED default and comment conflict; actual physical frequency calibration UNKNOWN.** Do not silently 'fix' the scale based on the comment.

## B. Operational loss and position continuity

`lcec_el5101_read` lines 209–212 returns early when `slave->state.operational` is false, setting `last_operational=0`. It **does not clear** published `enc-pos`, `enc-count`, `enc-raw-count`, latch validity or frequency pins. On the first later operational read, lines 242–245 set `last_count = raw_count` before the delta calculation at line 284. Thus the first restored sample contributes **zero delta**, and any encoder motion while offline is not recovered from the new 16-bit sample.

Worked source-derived example (assuming no reset/latch/set-count request): prior `enc-count=1000`, `last_count=1000`; offline device advances 500 counts to raw 1500; first restored read sets `last_count=1500`, computes delta 0, leaves `enc-count=1000`. A later sample 1510 adds 10, producing 1010, **not** the physical-relative 1510. This is a continuity loss by design/implementation, not a measured machine result. The 32-bit EL5151 source has the same operational-rebaseline pattern (lines 240–243, 274 onward); width alone does not fix reconnect ambiguity.

The master exposes `lcec.<master>.<slave>.slave-oper`, but its `ecrt_slave_config_state` update is conditional on `check_states` in `lcec_main.c` lines 1775–1781. After startup, that state-check cadence is nominally **1 s**, not every 1-ms servo callback. Meanwhile the master updates domain WKC each bus cycle. **Consequently a still-TRUE `slave-oper` or unchanged `enc-pos` is not a same-cycle proof of valid new encoder data.** The precise time to detect a fault depends on the bus, Sync Unit schedule and IgH state behavior; this is not a fixed 1-s worst-case guarantee.

## C. Signed modular delta and ambiguity

The EL5101 code uses `int16_t raw_count, last_count, raw_delta` and assigns `raw_delta = raw_count - last_count`. The subtraction is performed after integer promotion; converting an out-of-range result to `int16_t` is implementation-defined by ISO C. On typical GCC two's-complement targets it behaves like modulo-65536 narrowing. Under that assumption:

| Previous raw | New raw | Narrowed delta | Interpretation |
| ---: | ---: | ---: | --- |
| 32760 | -32760 | +16 | valid forward wrap if true motion +16 |
| -32760 | 32760 | -16 | valid reverse wrap if true motion -16 |
| 0 | -32536 | -32536 | **also** compatible with true +33000, so sign can alias |
| 1000 | 1000 after offline motion | 0 on first recovered read | motion while non-operational lost by rebaseline |

A 16-bit modulo count cannot uniquely resolve a movement of >=32768 counts between accepted samples without additional direction/speed constraints. At a **hypothetical** 1-ms accepted sample interval, half-range is 32,768 counts/ms, not a validated encoder electrical limit; a longer dropout reduces the admissible counts/s bound proportionally. `enc-overflow` and `enc-underflow` are exported **status bits**; the driver does not use them to disambiguate `raw_delta`. These observations do not establish an actual missed pulse or physical encoder speed.

## D. Latch, reset and set-count are separate origin-changing operations

The read function first handles counter-set acknowledgment by resetting `last_count` and clearing `enc-set-raw-count`, then software `enc-reset` zeros accumulated count, then valid external/C index latches reset count and rebase `last_count` to `raw_latch`; finally it adds `raw_count - last_count`. Thus after an index latch the published count is the delta from the **latched position to the current sampled position**, not necessarily exactly zero. If both external and C validity bits are set, the later C branch takes precedence in the source. No independent verification of terminal firmware latch timing or repeated-valid-bit behavior was performed.

## E. Diagnostic interpretation and implementation consequence

For a spindle encoder, a mill/router axis, or a robot joint, `enc-pos` is a calculated value, not a freshness verdict. Commissioning must record `slave-oper`, per-unit/master WKC state, per-unit `fresh` when a threaded Sync Unit is used, and application-specific continuity/rehome status **separately**. The master can publish a new image generation without WKC complete (see ECAT-12); no single pin proves a physically trustworthy position. Do not silently resume position-dependent operations after communication loss without an independently justified reacquisition policy. This is a normal-control engineering requirement, not an assertion of functional-safety performance.

## Evidence, limitations, next

**SOURCE-CONFIRMED:** device PDO widths/pins, 16-bit modular delta, offline early return, first-recovered-sample rebaseline, unchanged published values on early return, status-check cadence, historically wrong 0.05 default and contradictory comment, index handling. **NUMERIC INFERENCE:** four worked examples and 5×/50× scale comparisons. **TEST-CONFIRMED:** none for this EL5101 study. **UNKNOWN:** actual installed hardware, exact Beckhoff revision/configuration, IgH error timing, encoder maximum count rate, physical shaft motion, WKC under fault, scale calibration, runtime compiler narrowing behavior and safe restart.

No build, simulation, HAL session, EtherCAT hardware, physical machine, evaluator or Actions job. Hosted/self-hosted compute **0/0 minutes**; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. 1000/2000/F02/3000 remain graduated/closed; independent personnel-safety authority and OpenPressBrake G0/G1 HOLD unchanged. The recurring curriculum remains enabled.

[Practical commissioning guide](../guides/3200-3400-4000-linuxcnc-ethercat-el5101-encoder-continuity-preflight-2026-11-02.md) and [precise continuation checkpoint](../checkpoints/20261102T0236Z-4000-linuxcnc-ethercat-encoder-next.md).
