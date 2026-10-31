# 4000-LC-HM2-FILTER-75 — HostMot2 encoder filter-rate arithmetic, HAL readback and FPGA register semantics

**2026-10-31 | 4000 HostMot2/Mesa integration | NON-GRADUATED | SOURCE/DOC-CONFIRMED static; NO RUNTIME TEST.**

## Decision / novelty
The prior [HM2-ENCODER-18](4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md) covered probe/index latch arming and firmware capability, **not** the global quadrature-filter sample-frequency conversion. A direct full-`PROGRESS.md` synonym scan found no `QFilterRate`, `sample-frequency`, `muxed-sample` or encoder-filter audit. This lesson addresses a different FPGA configuration arithmetic and observability boundary, not a new graduation.

## Pinned authority
- LinuxCNC **v2.9.10**: [`src/hal/drivers/mesa-hostmot2/encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c#L159-L184), blob `9719d41419da9220761637e002024cdc9d17a8ba`; write trigger [lines 199–276](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c#L199-L276); HAL export/defaults [lines 464–473, 696–706](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c#L464-L473).
- LinuxCNC **development pinned** `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`: [same source, lines 159–184](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/encoder.c#L159-L184), blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`. This path changes HAL accessors but **retains the same integer algorithm**.
- Firmware register description: [LinuxCNC/hostmot2-firmware `src/regmap`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/regmap#L495-L501) and [muxed filter notes](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/regmap#L568-L630), blob `b3a2a77c27de0c71278dc910992efeddd7deb577`. This historical firmware repository explicitly labels itself unmaintained; verify the **installed FPGA image** before extrapolating hardware behavior.
- Official [`hostmot2(9)` manpage](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html): `encoder.sample-frequency` and `muxed-sample-frequency` are global `u32` input pins controlling encoder filter sampling; `.filter` requires 15 or 3 sample clocks; muxed sample rate also affects multiplexing.

## Exact execution path
1. `hm2_encoder_parse_md` creates one **HAL_IN u32** global `sample-frequency` (or `muxed-sample-frequency`) at lines 464–473 and initializes it to 25,000,000 (ordinary) or 8,000,000 (muxed) at lines 702–706. It does not impose a runtime input range there.
2. `hm2_encoder_write` compares the HAL input against `written_sample_frequency`; on change it enters `hm2_encoder_force_write`. The force path calls `hm2_encoder_set_filter_rate_and_skew` after writing control/timestamp registers. The latter is reached during initialization as well as subsequent reconfiguration. **No validation of zero or range occurs before its first division.**
3. `hm2_encoder_set_filter_rate_and_skew` uses unsigned 32-bit `q = clock_frequency / requested_frequency` (integer truncation). If `q == 1`, it writes `filter_rate = 0xFFF`; otherwise `filter_rate = q - 2` (unsigned). It then **overwrites the HAL input pin** with `clock_frequency / (filter_rate + 2)`, merges optional muxed skew bits, writes the register, and stores this overwritten pin as its software `written_sample_frequency` shadow.
4. The firmware regmap specifies a **12-bit QFilterRate**, normally `ClockLow / (QFilterRate+2)`, but says **a divisor with its MSb set means divide-by-one**. Thus the special `0xFFF` request means *full clock* at the FPGA, while the driver computes its readback using the ordinary divisor formula `4097`.
5. The `llio->write` return value is not examined in `hm2_encoder_set_filter_rate_and_skew`; the shadow is updated regardless. A changed HAL readback is not an independent acknowledgment of FPGA register acceptance.

## Bounded arithmetic examples (illustrative ClockLow = 33,000,000 Hz)
These are **arithmetic predictions, not test observations**. Exact board clock and firmware must be read from the actual module descriptor.

| Requested HAL u32 (Hz) | q = floor(clock/request) | Driver register | Driver's HAL readback | Regmap-implied filter clock | Meaning |
|---:|---:|---:|---:|---:|---|
| 1,000,000 | 33 | 31 | 1,000,000 Hz | 1,000,000 Hz | ordinary valid example |
| 16,500,000 | 2 | 0 | 16,500,000 Hz | 16,500,000 Hz | ordinary valid example |
| 25,000,000 | 1 | 0xFFF | **8,054 Hz** (floor(33,000,000/4097)) | **33,000,000 Hz** (MSb override) | **readback not actual sample rate** |
| 8,054 | 4097 | 0xFFF | 8,054 Hz | **33,000,000 Hz** (MSb override) | **low-frequency request can select full clock** |
| 0 | — | — | — | — | **first integer division by zero** |
| 33,000,001 | 0 | 0xFFFFFFFE (unsigned wrap) | — | — | `filter_rate + 2` wraps to zero; **second integer division by zero before register write** |

The `q==1` readback mismatch is particularly misleading because `HAL_IN` is mutated by the driver itself: the visible pin can say ~8 kHz while the firmware register requests full clock. For `q` whose `q-2` sets the 12-bit register's MSb, the firmware's divide-by-one rule creates additional nonmonotonic regions; **do not assume an arbitrary small positive input is representable**. Avoid asserting exact installed-hardware frequency from a historical regmap alone.

## Consequence / failure boundaries
- **SOURCE-CONFIRMED:** zero input and greater-than-clock input reach C integer division by zero in both inspected revisions. The specific realtime exception, LinuxCNC fault propagation, kernel/user RT behavior and machine response are **UNKNOWN** without isolated execution; no claim of observed crash.
- **SOURCE + firmware-regmap CONFIRMED:** special `0xFFF` arithmetic readback disagrees with the regmap's divide-by-one behavior; the physical sampling frequency is **INFERENCE until firmware/image verified**.
- **SOURCE-CONFIRMED:** a register write result is ignored and software shadow updated; readback and `written_sample_frequency` are not hardware acknowledgments.
- **DOC-CONFIRMED:** reducing sample rate increases digital noise filtering but reduces permissible encoder transition rate, and muxed mode also changes multiplex timing. This can affect feedback integrity and following-error diagnostics, but no physical failure is established.
- Distinguish this global filter input from per-channel `.filter`, index/probe latch, timestamp divisor and DPLL sample timer. The latter are separate paths.

## Review-only hardening design (NOT a patch; not compiled)
Guard `requested == 0` **before division**; compute quotient in a type with explicit bounds; handle `q <= 1` by programming the documented divide-by-one code **and publishing the actual clock**, not `clock/4097`; constrain the ordinary `q-2` to values with the register's MSb clear; reject or explicitly clamp unrepresentable low frequencies rather than silently wrapping; keep the muxed skew field separate; check `llio->write` status before updating a confirmed/shadow value. Verify exact FPGA implementation/clock before choosing policy or submitting upstream.

## Practical diagnostic / acceptance
See [seven-case disconnected acceptance guide](../guides/4000-linuxcnc-hostmot2-encoder-filter-rate-disconnected-acceptance-2026-10-31.md). Inspect the real `halcmd show pin hm2_*.encoder.*sample-frequency`, exact firmware/module descriptor, `encoder.NN.filter`, thread ordering, `hm2.read`/`hm2.write` and hardware register telemetry if available. **Do not set zero or out-of-range values on a physical controller.** A standalone source-level arithmetic review does not establish a functioning, isolated Mesa FPGA simulation.

**Status:** 4000 SOURCE/DOC only; TEST-CONFIRMED none; no compilation, simulator, FPGA synthesis, workflow, physical operation or independent evaluation. Existing closed levels, blind-evaluator separation and OpenPressBrake physical G0/G1 HOLD unchanged. Hosted/self-hosted Actions compute 0/0 minutes.
