# 4000-LC-MESA-66 — Real Smithy 5I20 PWM command, enable and spindle contactor are separate

**2026-10-31 | SOURCE-CONFIRMED static, conditional integration INFERENCE, TEST-CONFIRMED none | NON-GRADUATED.** HostMot2 FPGA PWM + real machine HAL implementation. This is not an installed-machine fault finding.

## Selection and novelty

Earlier [SSERIAL-56](4400_LINUXCNC_SSERIAL_56_REAL_8I20_7I77_HAL_ORDER_FRESHNESS_SOURCE_AUDIT_2026-10-31.md) inspected a different Smithy 5I20/8I20 **Smart Serial** integration. No prior `pwmgen`, `sets Enable TRUE`, or HostMot2 PWM duty/offset-mode source trace appeared in the full PROGRESS novelty scan. This audit instead follows the **5I20 PWM output, global enable, contactor output and FPGA register conversion**. The independent personnel-safety chain remains outside LinuxCNC's ordinary control signals.

## Immutable primary sources

- LinuxCNC stable [v2.9.10 `configs/by_machine/smithy/622.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/622.hal), blob `ffc5aae88817d488638198077d2e6cd273eeec5d`: lines 10–11 load `hm2_pci` with 5I20 firmware and one PWM generator; 27–35 permanently assert `Enable`, connect `spindle.0.speed-out` to PWM value and configure scale 5000, output-type 1, frequency 100 Hz; 92–105 connect permanent Enable to PWM and charge pump; 154–158 connect `spindle.0.on` to separate GPIO.042 with output inversion; 170–178 schedule read, motion, write, then charge pump.
- Stable [v2.9.10 `configs/by_machine/smithy/924.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.hal), blob `c40c14e3f3cbad07b9aefd715cb57e4e442a950b`: comparable separate PWM/contactor topology, with lowpass before PWM and scale 3000. This confirms the exact settings are **machine-specific**, not universal.
- Stable [v2.9.10 `src/hal/drivers/mesa-hostmot2/pwmgen.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/pwmgen.c), blob `d7e77f524c16f28b5d4db3f022e13e239fd09953`: `hm2_pwmgen_prepare_tram_write` lines 606–673, `hm2_pwmgen_force_write` around 181–275, HAL param defaults 539–544.
- Stable [v2.9.10 `src/hal/drivers/mesa-hostmot2/hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `75619ae3f6925087a6693c5421bbf629f4459d94`: `hm2_write` calls PWM TRAM preparation and register update. This is the HostMot2 software→FPGA register boundary, not a measured external PWM waveform.

## Exact Smithy 622 signal authority

```text
HAL "Enable" signal:
  newsig Enable bit; sets Enable TRUE  [constant]
    -> hm2_5i20.0.pwmgen.00.enable
    -> charge-pump.enable
    -> joint jog-vel-mode pins

Spindle M3/M4/M5:
  spindle.0.speed-out -> hm2_5i20.0.pwmgen.00.value (scale=5000)
  spindle.0.on        -> hm2_5i20.0.gpio.042.out (inverted physical polarity)
  spindle.0.reverse   -> hm2_5i20.0.gpio.040.out (inverted physical polarity)

Other:
  hm2_5i20.0.gpio.037.in -> iocontrol.0.emc-enable-in [external estop-monitor input]
```

**SOURCE-CONFIRMED:** `pwmgen.00.enable` is **not** wired to `spindle.0.on` in this example; it is tied to a permanently TRUE HAL signal. M5's spindle-on output controls a **separate** GPIO contactor line. It would be incorrect to infer that M5 deasserts the PWM enable pin. Conversely, this does not establish that the spindle physically keeps running: PWM duty, contactor wiring, VFD configuration and external safety chain are independent and unmeasured.

## FPGA PWM arithmetic and important offset-mode caveat

`hm2_pwmgen_prepare_tram_write` first calculates `scaled_value = value / scale`, clamps it to [-1, 1], and forces it to zero when the PWM enable pin is FALSE. In normal mode (`offset_mode=0`), it converts `abs(scaled_value)` to PWM width; in offset mode (`offset_mode=1`) it maps zero to the **midpoint**, i.e. nominal 50% duty, while the enable output has its own hardware meaning. The source explicitly comments that PWM/Dir pins can continue toggling even when /Enable is inactive, and that offset mode can yield 50% at zero command.

At the inspected **normal-mode default** (`offset_mode=0`) and Smithy 622 `scale=5000`, source arithmetic gives nominal duty fractions 0% for S0, 20% for 1000 RPM and 100% for 5000 RPM (ignoring quantization/dither, external direction and any command override). The 924 example uses `scale=3000` and a lowpass, so do not transfer these fractions to it.

**Important limitation:** The zero-to-50% offset-mode behavior is a *general HostMot2 driver property*, not a claim that Smithy 622 sets offset mode TRUE. The driver initializes offset mode to zero and the inspected 622 HAL does not change it. A HAL parameter changed at runtime or a different firmware configuration must be checked separately. A 0% commanded duty or a disabled PWM channel is not an independently verified safe drive state.

## Servo phase

The 622 HAL schedules `hm2_5i20.0.read`, motion-command-handler, motion-controller, `hm2_5i20.0.write`, **then** `charge-pump` in the servo thread. A new motion speed-out value can reach PWM TRAM preparation in that iteration; a charge-pump output updated **after** the write can only reach that HostMot2 output in a later write. The exact FPGA output update time, watchdog and drive response are UNKNOWN. This is a source-derived publication-order observation, not a measured cycle count.

## Disconnected acceptance matrix (NOT RUN)

| ID | Scenario | Oracle |
|---|---|---|
| M66-1 | Freeze original 622 HAL, check whether it loads with its specified 5I20 firmware | HAL parse, module count and actual available FPGA descriptor; **NOT RUN** |
| M66-2 | M3 S1000 → M5 while machine remains enabled | `spindle.0.on`, PWM `value`, `pwmgen.00.enable`, contactor GPIO and physical output *separately*; **NOT RUN** |
| M66-3 | Compare S0/S1000/S5000 at scale 5000, normal offset mode | PWM value register and nominal duty; **NOT RUN** |
| M66-4 | Software-only toggle offset mode with value=0 | Normal zero duty vs offset midpoint; **NOT RUN** |
| M66-5 | Compare 622 vs 924 spindle speed command path | Direct PWM vs lowpass, 5000 vs 3000 scale; **SOURCE-CONFIRMED**, runtime **NOT RUN** |
| M66-6 | Capture servo function ordering | `hm2.write` before charge-pump; **SOURCE-CONFIRMED**, runtime **NOT RUN** |
| M66-7 | Change `pwmgen.00.enable` while value nonzero in a disconnected test | Distinguish PWM width, hardware enable output and actual physical voltage; **NOT RUN** |

Do not energize a physical spindle or manipulate an installed contactor to perform these checks. For a real design, document actual output polarity, charge-pump receiver, watchdog state, external contactor/drive stop and independent personnel-safety architecture. No software PWM command, HAL enable or G-code M5 is a qualified safe torque off, protective stop or physical zero-speed witness.

**Evidence:** Pinned source/config and arithmetic CONFIRMED; FPGA register effect INFERENCE from code; actual output voltage, field wiring, spindle stop, safety integrity and timing UNKNOWN. No build, runtime, simulation, hardware, evaluator or Actions compute. Preserve G0/G1 physical HOLD and graduated levels.
