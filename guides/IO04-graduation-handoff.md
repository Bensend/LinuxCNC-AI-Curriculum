# IO04 graduation handoff — HostMot2 PWM/PDM command path

Course level: 1000  
Status: GRADUATED  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## What a fresh AI must know

HostMot2 PWMGen has two host write paths that must not be collapsed:

1. **cyclic command path** — `hm2_write()` calls `hm2_pwmgen_prepare_tram_write()`, which reads HAL command/configuration state and writes each encoded PWM/PDM command into the PWM value TRAM image; `hm2_tram_write()` then publishes the combined HostMot2 cyclic write regions;
2. **configuration/enable path** — after the TRAM write, `hm2_pwmgen_write()` compares HAL state against `written_*` shadows and calls `hm2_pwmgen_force_write()` only when output type, offset mode, dither, frequency or enable changed. That force path directly writes PWM mode, enable mask and PWM/PDM master DDS registers through LLIO.

## Command semantics

- finite `value/scale` is clipped to `[-1,+1]`;
- normal PWM/PDM uses magnitude plus a sign/direction indication;
- PDM uses fixed 12-bit density magnitude, while PWM resolution varies 9–12 bits according to requested frequency and board clock;
- offset mode centers zero command at 50% duty;
- dither changes PWM encoding/resolution where firmware supports it;
- `enable=false` first forces the command to zero, but in offset mode that zero command still maps to centered 50% duty;
- the separate enable register is changed later on the slow path when the HAL enable state changes.

Therefore never use these phrases as synonyms: **HAL disabled**, **zero command**, **0% duty**, **zero analog volts**, **electrically safe output**.

## Failure/debug model

If the physical output is wrong:

1. inspect HostMot2 `io_error` / communication state;
2. verify HAL command, scale, enable, output type, offset mode and frequency;
3. verify the expected PWMGen instance and firmware pin assignment;
4. distinguish cyclic PWM value publication from slow mode/enable publication;
5. verify transport/register transfer;
6. verify FPGA behavior and the specific daughtercard/analog electronics separately.

A correct HAL `value` proves only the requested host command, not successful hardware output.

If `io_error` is already set when generic `hm2_write()` begins, the normal write cycle returns before PWM command preparation. Slow-path PWM configuration shadows are only refreshed after force writes when `io_error` remains clear.

## Adversarial boundaries

- `scale=0` is not assigned a safe made-up semantic. Pinned source has no explicit zero guard before floating arithmetic and later integer conversion; treat zero/non-finite scale as invalid configuration pending targeted advanced testing.
- invalid `output-type` is diagnosed and repaired to standard PWM+Direction by the pinned source.
- current docs and pinned source must not be projected silently onto historical revisions or different firmware versions.
- generic PWMGen `enable` is ordinary machine-control state, not a safety-rated channel.

## Experimental evidence boundary

The stock upstream `hm2_test` fake LLIO cannot currently provide a useful PWM write oracle: its write callback discards address/data and the stock register patterns are focused on registration/IDROM validation. A proper synthetic production-path test would require a valid fake PWM descriptor plus write capture. That experiment is promoted to 2000/HIGH.

Such a fixture could confirm host register encoding but still would not test FPGA waveform timing, physical analog transfer, Ethernet behavior, watchdog electrical state or machine safety.

## Community field lesson

Mesa developer PCW's 2023/2025 forum guidance for centered analog-output configurations agrees with the source model: relevant hardware requires `offset-mode=1`, and disabled offset mode can intentionally retain 50% centered PWM. Treat this as card-specific field evidence, not a universal physical guarantee.

## Durable artifacts

- `guides/IO04-pwm-pdm-initial-research.md`
- `guides/IO04-pwm-pdm-source-guide.md`
- `call-flows/IO04-pwm-command-to-register.md`
- `forum-findings/IO04-pwm-offset-enable-field-notes.md`
- `guides/IO04-experiment-sufficiency-and-promotion.md`
- `exams/IO04-adversarial-exam-and-corrections.md`
- this handoff

## Higher-level queue

1. **2000/HIGH** — mutable fake-board PWM descriptor + LLIO/TRAM write-capture production host-path experiment.
2. **2000/HIGH** — scale zero/NaN/Inf adversarial behavior.
3. **HM06/2000 HIGH** — FPGA PWMGen HDL/register interpretation and timing.
4. **IO05/commissioning CRITICAL** — daughtercard analog voltage/current transfer, polarity, limits, external enable/fault behavior.
5. **advanced hardware/safety CRITICAL** — watchdog bite and output electrical state/timing on representative hardware.

## Fresh-AI handoff result

PASS. Using only these artifacts plus the pinned LinuxCNC source, a fresh AI can locate the correct HostMot2 functions, trace HAL PWM commands to the register/LLIO boundary, explain offset/PDM/PWM behavior, diagnose host-side failure paths, and identify where physical/hardware evidence becomes necessary without inventing safety or analog-output guarantees.

## Graduation decision

IO04 is sufficient for the 1000-level command-path objective. The remaining uncertainties are advanced synthetic verification, firmware implementation, card-specific electronics and safety/commissioning questions; none invalidates the host architecture taught here because each boundary is explicit.