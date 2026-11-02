# STEPGEN-153 — HostMot2 nanosecond timing quantization and persistent maxvel clipping
**2026-11-02 | 4000 LinuxCNC implementation | 3100/3300/3400/3600 machine transfer | NON-GRADUATED**

> **Same-session firmware correction (STEPGEN-154):** The [HostMot2 firmware regmap](https://github.com/LinuxCNC/hostmot2-firmware/blob/master/src/regmap) blob `b3a2a77c27de0c71278dc910992efeddd7deb577` explicitly specifies **N+1 clocks** for StepGen pulse active and idle registers. Therefore host register truncation does **not** imply an N-clock-short pulse for that firmware contract. At hypothetical 100 MHz, 15 ns → register 1 → **nominal 20 ns**, not 10 ns. See [STEPGEN-154 firmware reconciliation](4400_LINUXCNC_STEPGEN_154_FIRMWARE_NPLUS1_PULSE_AND_HOST_MAXRATE_RECONCILIATION_2026-11-02.md) for the cross-layer max-rate mismatch. Selected bitfile/waveform still NOT VERIFIED.

## Question and predecessor check
How does a HostMot2 step generator convert HAL nanosecond minimum pulse/setup/hold requests to FPGA clock registers, and does changing the timing restore a previously clipped `maxvel`? This is **not** STEPGEN-97/98 (feedback provenance/scale/accumulator), STEPGEN-99 (watchdog forced replay), MESA-PWM-151 (PWM resolution change), or PLASMA-33 (Mesa 7i96S scheduling). Inspected canonical `PROGRESS.md`/lesson history by `stepgen`, `steplen`, `stepspace`, `dirsetup`, `dirhold`, `maxvel`, `maxaccel`, `watchdog`; the four timing words and their quantization were not already an identified mechanism. GitHub code search is not proof of absence.

## Pinned sources
- LinuxCNC **v2.9.10**, commit `86cdca76fa2a36274c432caa21952b23c267989a`, `src/hal/drivers/mesa-hostmot2/stepgen.c`, blob **`8eb43d9a7d8e42573ef653cb82460609d2864ae4`**: `hm2_stepgen_instance_prepare_tram_write` lines 249–326, `hm2_stepgen_update_{dir_setup_time,dir_hold_time,pulse_idle_width,pulse_width}` lines 347–388, `hm2_stepgen_write` lines 485–549, `hm2_stepgen_parse_md` around 773, HAL parameter creation 1050–1091.
- Development snapshot **`67437d8865e431a9a33f74cee912dbf891d3b4c5`**, same path, blob **`4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`**, corresponding `hal_get_ui32`/`hal_set_real` conversions near lines 270–296 and 356–408. The relevant integer-register conversion and clipping pattern remain.
- Official [HostMot2 manual](https://linuxcnc.org/docs/master/html/en/man/man9/hostmot2.9.html), `stepgen` section: `steplen`, `stepspace`, `dirsetup`, `dirhold` are unsigned HAL nanoseconds; `maxvel=0` selects the current timing-derived physical maximum. Distinguish this hardware step generator from the unrelated **software** `stepgen(9)` component.

## Call and ownership trace (SOURCE-CONFIRMED)
1. HAL RW parameters are published for each FPGA stepgen: `steplen`, `stepspace`, `dirsetup`, `dirhold`, `maxvel`, `maxaccel`, `position-scale`. The module descriptor supplies `hm2->stepgen.clock_frequency`.
2. Each HostMot2 write cycle prepares the step-rate TRAM via `hm2_stepgen_instance_prepare_tram_write`. The velocity limit is calculated from **HAL-requested** `steplen+stepspace` in nanoseconds and `fabs(position_scale)`: `physical_maxvel = (1e9 / (steplen + stepspace)) / abs(position_scale)`. If a positive `maxvel` exceeds that value, the driver **writes the clipped value back to the HAL RW parameter**. A zero `maxvel` instead selects the calculated physical limit without changing the zero parameter.
3. `hm2_stepgen_write` compares current timing HAL parameters to `written_*` caches, converts each changed unsigned nanosecond parameter with `(double)requested_ns * clock_frequency / 1e9`, and assigns it to an integer register (`rtapi_u32`). The assignment **truncates fractional clock ticks toward zero**, rather than rounding upward. Values greater than `0x3FFF` are clipped, and the corresponding HAL parameter is rewritten to a derived value.
4. `hm2_stepgen_write` forwards the changed register words through the selected `llio->write` backend. The **FPGA's interpretation of a stored count**, exact pulse edges, Ethernet batching and physical drive input behavior are not established by this C-only audit. HAL requested ns is not a scope measurement.
5. The step-rate DDS register and `velocity-fb` are software/FPGA-command representations, **not independent motor position or drive compliance witnesses** (see STEPGEN-97).

## Discriminating numerical oracles (source arithmetic, NOT RUN)
For a **hypothetical** 100 MHz stepgen module clock (10 ns per tick), the C register conversion yields:

| Requested ns | Real-valued ticks | Stored integer register | Requested minus register×10 ns |
|---:|---:|---:|---:|
| 9 | 0.9 | 0 | 9 ns |
| 10 | 1.0 | 1 | 0 ns |
| 15 | 1.5 | 1 | 5 ns |
| 25 | 2.5 | 2 | 5 ns |
| 100 | 10.0 | 10 | 0 ns |
| 500 | 50.0 | 50 | 0 ns |

The fourth column is only **host count×tick arithmetic**, not a measured pulse deficit. **Superseded firmware interpretation:** the pinned HostMot2 `src/regmap` specifies **N+1 clocks** for pulse active and idle. For this regmap, 15 ns → N=1 → nominal **20 ns**, and 100 ns → N=10 → nominal **110 ns**. See STEPGEN-154 for the full corrected table and host max-rate mismatch. The actual selected bitfile and waveform remain unverified.

**Persistent clamp example:** at 1000 steps/mm and requested `steplen=1000 ns`, `stepspace=1000 ns`, `physical_maxvel=500 mm/s`. Writing `maxvel=600` is clamped **in place** to 500. If the timing is later relaxed to 500 ns + 500 ns, the new calculated maximum becomes 1000 mm/s, but the HAL `maxvel` stays 500 and still limits commanded speed until explicitly changed. By contrast `maxvel=0` tracks the new calculated maximum. No motor performance or machine feasibility is inferred from these illustrative numbers.

## Consequence and interpretation
- **SOURCE-CONFIRMED:** integer truncation can encode fewer whole clock periods than the fractional ns request, without an upward-rounding check; and an oversized explicit `maxvel` is permanently rewritten, so later timing relaxation does not restore the old request.
- **DOC-CONFIRMED:** parameters are in ns and `maxvel=0` means the timing-derived maximum; documentation does not itself prove waveform-level minimum timing.
- **SOURCE-CONFIRMED regmap continuation:** the firmware register map specifies **N+1 clocks** for STEP active/idle, so the earlier N-clock-short-pulse hypothesis is **superseded**. The host timing-derived max-rate formula does not include these extra clocks (STEPGEN-154). DIR setup/hold counter semantics beyond the regmap's stated prohibition on zero remain to be checked.
- **UNKNOWN:** installed bitfile/HDL versus regmap compatibility, DIR counter semantics, board-specific clock, physical pulse-edge measurements, effect of write batching at runtime, and drive response.
- **TEST-CONFIRMED:** none; no LinuxCNC, HAL, FPGA, compiler, runner or machine executed.

## Implementation decision
For a real Mesa configuration, obtain the actual stepgen clock and drive datasheet, choose conservative **whole-tick** values with margin, and verify the resulting register and pulse waveform before acceptance. The regmap's N+1 count is crucial: do not silently patch conversion to `ceil` or claim under-width without confirming the selected bitfile; reconcile maximum-step-rate calculation, 14-bit saturation and zero-time semantics first. Prefer `maxvel=0` when an intentional automatic timing-derived cap is desired; otherwise explicitly reapply a chosen cap after timing edits and keep trajectory/joint limits independently configured.

## Next verification and falsifiers
1. With a qualified, physically disconnected `[self-hosted, openpressbrake]` simulation/fake-LLIO, capture actual register writes for 9/10/15/25/100 ns at the selected module clock. Distinguish C calculation from backend and FPGA behavior.
2. Compare `maxvel` readback before clamp, after clamp, after timing relaxation, and after explicit reset to 0. Retain exact source SHA, HAL values, integer register words and timing.
3. If the FPGA firmware source is available for the selected board/bitfile, inspect the pulse-counter load and decrement semantics; only then decide whether an upward-rounding fix is correct.
4. **Falsifiers:** different integer conversion in another revision, firmware N+1 cycle semantics, a board-specific minimum-count coercion, or driver code restoring the original requested cap.

## Independent safety / scope
This is machine-control commissioning, not personnel-safety authorization. Independent safety functions and existing OpenPressBrake G0/G1 restrictions remain unchanged. Graduated levels stay closed. No hosted Actions permitted. The previously prioritized MOTION-144 qualified disconnected runtime experiment remains first in the execution queue.
