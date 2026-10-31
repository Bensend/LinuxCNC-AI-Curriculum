# 4000-LC-HM2-TIMESTAMP-76 — HostMot2 16-bit encoder timestamp ambiguity after delayed reads

**2026-10-31 | LinuxCNC-first HostMot2 realtime/encoder implementation | NON-GRADUATED | SOURCE/DOC only.**

## Why this is distinct
[HM2-FILTER-75](4400_LINUXCNC_HM2_FILTER_75_ENCODER_SAMPLE_FREQUENCY_DIVIDER_READBACK_SOURCE_AUDIT_2026-10-31.md) covers **quadrature input filter-rate configuration**; [HM2-ENCODER-18](4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md) covers **index/probe latch arming**. This investigation addresses the independent **16-bit timestamp clock used to estimate low-speed encoder velocity**, its rollover inference, and the effect of a delayed HostMot2 read. Full `PROGRESS.md` scan before publication found no `hires-timestamp`, `tsc_num_rollovers` or `timestamp rollover` predecessor.

## Pinned source
- LinuxCNC stable [v2.9.10 `encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c#L199-L266) (blob `9719d41419da9220761637e002024cdc9d17a8ba`), `hm2_encoder_write` timestamp divisor selection; [`hm2_encoder_instance_process_tram_read` lines 919–1080](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c#L919-L1080), `tsc_num_rollovers` and `prev_time_of_interest`.
- Stable [`hostmot2.h` lines 267–269](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.h#L267-L269), blob `004bf458efcc2d18dbacde09e0b90ba2119252e7`: both event timestamp and free-running timestamp are masked to **16 bits**.
- Pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` [`encoder.c` lines 936–1101](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/encoder.c#L936-L1101), blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`: rollover comparison still increments by at most one on each processed read; development also publishes `position-interpolated` using computed elapsed time in its no-new-count path.
- Official [`hostmot2(9)` manpage](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html) says `hires-timestamp` selects approximately **10 MHz** instead of **2 MHz**, and advises leaving it FALSE when servo periods exceed **1 ms**. The driver comment warns its 16-bit overflow inference needs fewer than 32,767 timestamp counts per servo period (a conservative bound).

## Execution and state
1. `hm2_encoder_write` sets the timestamp divisor for nominal 2 MHz (`hires-timestamp=0`) or 10 MHz (`=1`) and computes `seconds_per_tsdiv_clock`. It does not derive the timestamp rate from the observed servo period or reject an incompatible period.
2. `hm2_encoder_parse_md` registers TRAM read of the timestamp counter **before** the encoder counter/timestamp registers (lines 429–445), preserving their intended read order. A read does not contain an independent 32/64-bit rollover count.
3. In `HM2_ENCODER_MOVING`, when no count changes, `hm2_encoder_instance_process_tram_read` obtains a 16-bit free-running timestamp and increments `tsc_num_rollovers` **once only if** the new timestamp is numerically smaller than `prev_time_of_interest` (stable lines 987–993; development 1004–1010). When a count changes, it applies the same single-wrap comparison to the latched event timestamp (stable lines 1039–1042; development 1059–1062), then consumes/reset rollovers after the velocity update.
4. Because both timestamps are modulo 65,536, a delay containing a complete wrap **plus** a positive residual can appear to have **no rollover**. The resulting elapsed time is too small. No separate skipped-cycle counter or rollover-validity flag is exported by this calculation.
5. Development uses this `dT_s` for `position-interpolated` in the no-count path (development lines 1026–1027), so a missed wrap can also affect that estimate; it does **not** prove a corresponding change in ordinary encoder `position`, which is derived from counts.

## Exact bounded predictions — no tests performed
These cases assume the free-running timestamp begins at 0 and the next observed timestamp is sampled after the stated interval, with no intervening reads. They are **illustrative arithmetic**, not observed scheduler behavior.

| Case | Timestamp rate | Gap between relevant observations | True ticks | Observed 16-bit value | Source inferred rollover | Consequence |
|---|---:|---:|---:|---:|---|---|
| T1 | 10 MHz | 1 ms | 10,000 | 10,000 | 0 | Correct interval |
| T2 | 10 MHz | 10 ms | 100,000 | 34,464 | **0** | Reports 3.4464 ms instead of 10 ms; a velocity based on this delta can be ~2.90× too high |
| T3 | 2 MHz | 40 ms | 80,000 | 14,464 | **0** | Reports 7.232 ms instead of 40 ms; a velocity based on this delta can be ~5.53× too high |

These examples deliberately isolate a **single observed 16-bit counter delta**. Actual event timestamps, prior event state, low-speed timeout, encoder pulses and missed read pattern affect whether a given machine enters the affected branch. Do not claim every delayed read produces the listed velocity error. The driver comment's stricter **32,767-count** bound is useful to avoid ambiguous wrap interpretation, not merely the theoretical 65,536-count period.

## Practical disconnected verification (T1–T3 all NOT RUN)
Freeze exact source/clock/servo timing and implement a tiny **pure-software 16-bit counter + previous-time state** mock on a positively isolated `[self-hosted, openpressbrake]` runner. Feed 10,000, 100,000 and 80,000 tick advances with no intermediate samples, record modulo counter, comparison result, rollover count, `dT_clocks` and `dT_s`. Then add a variant with periodic reads to show why timely sampling avoids missed wraps. A full LinuxCNC/FPGA run requires a separately reviewed harness and independent machine isolation; no live Mesa driver/physical fault injection. A source-level arithmetic prediction is **not** a TEST-CONFIRMED scheduler or motor outcome.

## Implementation / diagnostic implications
Monitor actual HostMot2 read cadence, jitter and worst-case gaps, not just nominal servo-thread period; choose `hires-timestamp` consistent with the worst-case interval and official guidance. Record `encoder.NN.velocity` separately from `rawcounts`, `position`, `position-interpolated` (development) and following error. A velocity spike without count anomaly is not automatically an encoder electrical fault. For future FPGA-compatible designs, expose a wider timestamp/rollover witness or a freshness/age indicator if the interface permits; any redesign requires compatibility review and independent tests.

**Evidence:** SOURCE-CONFIRMED modulo-16-bit timestamp, one-wrap-per-comparison inference, development interpolation dependency; DOC-CONFIRMED frequency guidance; INFERENCE conditional velocity consequence; TEST-CONFIRMED none. No builds, simulation, physical operations, workflow or evaluator. Hosted/self-hosted Actions 0/0 minutes; independent personnel safety, physical G0/G1 HOLD and closed levels unchanged.
