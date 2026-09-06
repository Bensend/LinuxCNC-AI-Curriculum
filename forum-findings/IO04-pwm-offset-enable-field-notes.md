# IO04 community findings — PWM offset/enable configuration

Module: IO04 — PWM/PDM command path  
Evidence class: COMMUNITY-REPORTED investigation leads, reconciled where source agrees.

## Centered analog output requires offset mode on relevant Mesa hardware

A February 2025 LinuxCNC forum thread for 7I97T analog outputs includes a correction from Mesa developer PCW: `offset-mode` must be true for that board's centered analog output path so 50% PWM represents zero analog output, and standard PWM+Direction output type should be selected. This is useful because it shows how a superficially plausible HAL configuration can produce full-scale negative analog output.

Source: LinuxCNC Forum, "Mesa 7i97T + 7i84 + 7i78 configuration", PCW reply 2025-02-21.

## Disabled offset mode may intentionally remain at 50% duty

A 2023 forum question asked why `pwmgen.enable=false` did not produce 0% duty with offset mode enabled. PCW explained that offset mode assumes zero analog output corresponds to 50% duty, including when disabled, and suggested explicit command selection if a particular system needs 0% PWM under that condition.

Source: LinuxCNC Forum, "pwmgen enable mode-offset", PCW reply 2023-04-29.

This field behavior is independently consistent with pinned host source: `hm2_pwmgen_prepare_tram_write()` first forces `scaled_value=0` when disabled, then offset-mode encoding maps zero to the midpoint.

## Debugging lesson

Do not use the words "disabled", "zero command", "zero duty" and "zero analog volts" interchangeably.

For a centered PWM-to-analog interface:

- HAL command zero can legitimately encode 50% PWM duty;
- `enable=false` can still leave a centered PWM command image while the separate hardware enable line is deasserted;
- the downstream analog stage determines whether that corresponds to zero volts, high impedance, or another physical condition;
- the exact safe-state behavior is board/interface/hardware-specific and must not be inferred from generic HostMot2 HAL semantics.

## What is not promoted from community evidence

These forum reports do not establish generic behavior for every Mesa card, FPGA firmware revision, daughtercard, amplifier, or watchdog state. Hardware-specific transfer behavior belongs in IO05/commissioning and must be verified from the relevant board manual or hardware test.