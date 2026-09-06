# IO04 — HostMot2 PWM/PDM initial research notes

Course level: 1000
Status: RESEARCH
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Intended/public behavior

Current `hostmot2(9)` documents per-instance `enable` and `value`, with `scale` converting command units to duty cycle (`value / scale`) and clipping the effective duty command to [-1,+1]. `output-type` selects PWM+direction, up/down, PDM+direction, or swapped direction/PWM. `offset-mode` maps zero command to 50% duty for interfaces which use centered PWM. `dither` increases effective PWM resolution on supported firmware. Module-wide `pwm_frequency` and `pdm_frequency` control PWM wave frequency and PDM pulse-slot frequency respectively.

These are DOC-CONFIRMED public semantics; physical analog voltage/current depends on external interface electronics and is not implied by the FPGA PWM pin alone.

## Pinned source entry points

`src/hal/drivers/mesa-hostmot2/hostmot2.c` places `hm2_pwmgen_prepare_tram_write(hm2)` before the generic `hm2_tram_write(hm2)`. After the TRAM write, `hm2_pwmgen_write(hm2)` handles configuration registers which normally change less frequently.

This establishes two distinct write paths:

1. **cyclic command path** — HAL command state is converted into the PWM value TRAM image by `hm2_pwmgen_prepare_tram_write()`, then sent with the generic HostMot2 TRAM write;
2. **configuration/enable path** — `hm2_pwmgen_write()` detects changes and can invoke `hm2_pwmgen_force_write()`, which writes mode, enable, PWM master-rate DDS, and PDM master-rate DDS registers through LLIO writes.

Evidence: SOURCE-CONFIRMED at pinned revision.

## Frequency/configuration behavior already source-confirmed

Pinned `pwmgen.c` computes PWM master-rate DDS while preferring 12-bit PWM resolution, then 11, 10, and 9 bits as frequency rises. Requests which cannot fit even 9-bit PWM are clipped to the board-dependent maximum and the HAL parameter is rewritten to the achievable value.

PDM uses a fixed 12-bit density pattern and computes its master DDS from requested pulse-slot frequency; too-low or too-high requests are clipped to representable values.

`hm2_pwmgen_force_write()` maps `output-type` into hardware mode bits, selects double-buffering behavior, applies dither where requested, builds the enable bitmask from HAL `enable`, and writes mode/enable/master-rate registers. An invalid output type is diagnosed and repaired to PWM+direction.

## Safety/electrical boundary

- `enable=true` is an ordinary HostMot2 output-control mechanism, not a safety-rated enable.
- PWM/PDM duty command is not itself an analog voltage/current guarantee; downstream Mesa daughtercards, amplifiers, filtering, wiring, and faults matter.
- HostMot2 watchdog behavior is a separate fault path already bounded in HM08; IO04 must later document how output state interacts with ordinary cyclic writes versus watchdog bite without claiming certified safety.

## Community research direction

Field reports about PWM scaling, polarity, enable wiring, and analog-output interfaces are useful experiment/debugging leads, but no community-only claim has been promoted to fact in this initial pass.

## Next source checkpoint

Read the remainder of pinned `pwmgen.c` around `hm2_pwmgen_prepare_tram_write()`, HAL export/descriptor parsing, scale==0 handling, command clipping, sign/direction encoding, offset-mode, PDM versus PWM value encoding, and `hm2_pwmgen_write()` change detection. Then write `call-flows/IO04-pwm-command-to-register.md` from HAL command through TRAM/LLIO and decide whether a write-capturing fake LLIO can test production host encoding without pretending to test FPGA/electrical output.
