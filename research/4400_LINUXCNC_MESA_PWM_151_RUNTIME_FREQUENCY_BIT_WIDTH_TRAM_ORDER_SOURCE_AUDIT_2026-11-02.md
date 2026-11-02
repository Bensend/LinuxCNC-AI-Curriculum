# MESA-PWM-151 — Runtime PWM frequency change crosses a HostMot2 TRAM/width boundary

**2026-11-02 06:36Z | 4000 LinuxCNC hardware implementation, 3100/3200/3400 transfer | NON-GRADUATED | SOURCE-CONFIRMED ordering, INFERENCE output consequence, TEST-CONFIRMED none.**

## Selection and predecessor distinction

Read `START_HERE.md`, the current governance/checkpoint, progress/lesson/lab/blind ledgers and the prior [MESA-66 Smithy PWM investigation](4400_LINUXCNC_MESA_66_SMITHY_5I20_PWM_ENABLE_STOP_AND_OFFSET_MODE_SOURCE_AUDIT_2026-10-31.md). **MESA-66 already established** the Smithy constant PWM enable, separate spindle contactor, value/scale clamp, offset-mode midpoint and stable/development sign-bit difference. Those are **not** new findings here. The incremental question is **what happens to the PWM width-dependent value register when the PWM frequency parameter is changed at runtime across a width-selection threshold**, given the actual HostMot2 write order. A full `PROGRESS.md` scan for `pwmgen` located MESA-66; no earlier frequency/bit-width/TRAM-order analysis was identified in that canonical record. Absence from that scan is not proof that no other historical document exists.

## Immutable primary sources

- LinuxCNC stable **v2.9.10**, [`src/hal/drivers/mesa-hostmot2/pwmgen.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/pwmgen.c), blob **`d7e77f524c16f28b5d4db3f022e13e239fd09953`**: `hm2_pwmgen_handle_pwm_frequency` lines 33–106; `hm2_pwmgen_force_write` 181–301; `hm2_pwmgen_write` 310–350; `hm2_pwmgen_prepare_tram_write` 606–674.
- Stable [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob **`75619ae3f6925087a6693c5421bbf629f4459d94`**, `hm2_write` lines 125–174.
- Development commit **`06864e23559e70463fc7112d5ce77138bcbc288c`**, [`pwmgen.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/pwmgen.c), blob **`1ea78d90bb66914ade4ec2b134bd85e8329953bf`**, and [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob **`f83e48fad84639eb1c095335ce908b4d408a4d38`**. Development uses HAL accessors but retains the frequency selection and **prepare → TRAM write → mode write** order.
- Official [HostMot2 manual, pwmgen section](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html): `pwm_frequency` is a shared runtime-writable parameter; `scale`, `output-type`, `offset-mode`, `dither` define command interpretation. The documentation says PWM frequency is clipped to a board-dependent maximum; it does not promise glitchless runtime transitions.
- Real upstream [Smithy 622 HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/622.hal), blob **`ffc5aae88817d488638198077d2e6cd273eeec5d`**: 5I20 with one PWM generator; `pwmgen.00.scale=5000`, `output-type=1`, `pwm_frequency=100`, `spindle.0.speed-out → pwmgen.00.value`; constant TRUE `Enable → pwmgen.00.enable`; `hm2.read → motion-command-handler → motion-controller → hm2.write`. **This real config sets a startup frequency, not an observed runtime frequency switch.** Clock below is a hypothetical calculation, not a verified Smithy board clock.

## Function and state ownership

| Symbol | Context | Reads / writes | Failure or uncertainty |
| --- | --- | --- | --- |
| `hm2_pwmgen_handle_pwm_frequency` | HostMot2 register update, normally called by `force_write` | Reads HAL `pwm_frequency` and `clock_frequency`; sets `pwm_bits` (12→9), 16-bit DDS register and, on overrange, writes clipped frequency back to HAL | Requested Hz need not equal actual DDS-derived Hz; no waveform observed |
| `hm2_pwmgen_prepare_tram_write` | realtime `hm2.write` | Reads HAL `value`, `scale`, `enable`, `offset_mode`, `dither`, **current `pwm_bits`**; prepares `pwm_value_reg[]` | Old bit width may still be in memory after HAL frequency changes |
| `hm2_tram_write` | realtime `hm2.write` | Sends prepared value-register region to low-level IO | Transport/FPGA application timing not established |
| `hm2_pwmgen_write` | realtime `hm2.write` | Detects frequency/mode/enable change; calls `force_write` | Detects changed frequency **after** current cycle's TRAM value preparation and transmission |
| `hm2_pwmgen_force_write` | realtime `hm2.write` | Recalculates bit width/DDS, updates mode and enable registers, caches written settings after successful IO | Does not re-prepare/re-transmit value register in same call |

The stable `hostmot2.c::hm2_write` executes:
```text
hm2_pwmgen_prepare_tram_write(hm2)  // uses OLD pwm_bits
...
hm2_tram_write(hm2)                 // writes OLD-width-encoded value
...
hm2_pwmgen_write(hm2)               // notices new pwm_frequency
  -> hm2_pwmgen_force_write(hm2)
     -> hm2_pwmgen_handle_pwm_frequency(hm2)  // changes pwm_bits
     -> write PWM mode/master-rate registers
// next servo callback:
hm2_pwmgen_prepare_tram_write(hm2)  // now uses NEW pwm_bits
```
**SOURCE-CONFIRMED:** At a parameter change that selects a different `pwm_bits`, one `hm2.write` invocation can submit a value encoded for the previous width, followed by mode/frequency registers encoded for the new width. This is a **cross-register temporal mismatch**; it is not proof of an external waveform glitch, because bus ordering, FPGA buffering, register interpretation and external hardware are unmeasured. At a same-width frequency change the width mismatch does not occur, although rate-register changes still have device-specific timing.

## Quantitative discriminator (hypothetical ClockHigh = 100 MHz)

The C code selects the **first** width `b ∈ [12,11,10,9]` for which the truncated integer `DDS = floor(requested_Hz × 65536 × 2^b / ClockHigh)` fits in 16 bits. Effective nominal frequency is `ClockHigh × DDS / (65536 × 2^b)`. Above the 9-bit maximum, DDS clamps to 65535 and the HAL frequency parameter is rewritten. These equations describe source arithmetic; hardware frequency has **not** been measured.

| Requested Hz | Selected bits | DDS integer | Nominal DDS-derived Hz | Normal-mode 50% command's value register, decimal |
| ---: | ---: | ---: | ---: | ---: |
| 100 | 12 | 268 | 99.837780 | 134184960 |
| 20,000 | 12 | 53687 | 19999.966025 | 134184960 |
| 24,414 | 12 | 65535 | 24413.689971 | 134184960 |
| 24,415 | 11 | 32769 | 24414.807558 | 67076096 |
| 60,000 | 10 | 40265 | 59999.525547 | 33521664 |
| 200,000 | 9 | 65535 (clamped) | 195309.519768 | 16744448 |

Value-register figures assume `scale=1`, `value=0.5`, `offset_mode=0`, `dither=0`, `enable=TRUE`, and the source's `register_value = 0.5 × (2^bits − 1)`, followed by multiplication by 65536 and integer conversion. **No assertion that an old 12-bit value will become a particular physical duty under a new 10-bit mode** is warranted without FPGA register semantics. This is especially relevant to runtime 20 kHz→60 kHz changes, where the old and new encoded values differ by roughly 4×.

The same code allows very low requested frequencies with coarse DDS resolution. At 100 MHz, requested 100 Hz computes 99.83778 Hz, so `pwm_frequency` is a **requested** parameter, not a measured frequency readback. This does not imply a meaningful spindle-speed error: PWM carrier frequency and spindle speed command are different quantities.

## Evidence ledger and bounded follow-up

- **SOURCE-CONFIRMED:** exact stable/development call order, frequency-to-bit-width selection, truncation, DDS clamp, width-dependent PWM value conversion, real Smithy HAL PWM startup topology.
- **DOC-CONFIRMED:** shared, runtime-writable PWM frequency and board-dependent limits.
- **INFERENCE:** a dynamic crossing of a width threshold can produce a transient externally visible PWM waveform/duty change; conditional on firmware and transport timing.
- **UNKNOWN:** whether real hardware buffers mode/value atomically, the resulting duty or pulse count, measured carrier, drive/VFD response, and whether any application changes this parameter while enabled.
- **TEST-CONFIRMED:** none. No LinuxCNC build, simulation, FPGA, machine, independent evaluation or Actions compute; hosted/self-hosted 0/0 min.

Do not change `pwm_frequency` on an energized machine to investigate this. The next evidence-bearing step is a qualified **disconnected** HostMot2 fake-LLIO or FPGA simulation with an instrumented register-write log, followed only later by separately authorized oscilloscope observation. No LinuxCNC software command is independent personnel-safety authority. See [implementation guide](../guides/4000-linuxcnc-hostmot2-pwm-frequency-transition-commissioning-2026-11-02.md) and [next checkpoint](../checkpoints/20261102T0640Z-4000-linuxcnc-pwm-transition-next.md).
