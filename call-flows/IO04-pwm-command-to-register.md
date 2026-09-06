# IO04 call flow — HAL PWM/PDM command to HostMot2 register write

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This is the 1000-level host-side execution path for the standard HostMot2 PWMGen module. It intentionally stops at the LLIO/register boundary. It does not claim FPGA waveform timing, daughtercard analog transfer, amplifier behavior, watchdog-safe electrical state, or functional safety.

## Registration prerequisites

`hm2_pwmgen_parse_md()` validates the PWMGen module descriptor, derives register addresses, registers the PWM value array as a TRAM write region, and exports the module/global HAL parameters and per-instance HAL pins/parameters.

The key architectural consequence is that the PWM **value** registers participate in normal TRAM batching, while PWM **mode/enable/master-rate** registers are handled by direct/change-detected LLIO writes.

## Runtime flow

### 1. HAL scheduler calls board `write`

During HostMot2 registration the board exposes the generic HostMot2 `write` realtime function. A HAL realtime thread which has that function scheduled invokes `hostmot2.c::hm2_write(void *void_hm2, long period)` once per scheduled thread cycle.

`hm2_write()` immediately returns while LLIO `io_error` is asserted. This prevents new normal cyclic PWM command publication during the generic HostMot2 communication-error state.

### 2. Cyclic PWM command preparation

`hm2_write()` calls:

`hm2_pwmgen_prepare_tram_write(hm2)`

For each PWMGen instance:

1. read HAL `value`;
2. divide by HAL `scale`;
3. clip finite values outside `[-1,+1]`;
4. if `enable==false`, replace the scaled command with zero;
5. choose normal or offset-mode encoding;
6. choose PDM fixed-width or current PWM-resolution encoding;
7. apply dither top-end adjustment where enabled;
8. encode magnitude in the register value and set bit 31 for a negative command.

The resulting 32-bit word is written into `hm2->pwmgen.pwm_value_reg[i]`, which points into the previously registered HostMot2 TRAM write image.

Important semantic branch:

- normal mode + disabled -> command zero -> nominal zero duty command;
- offset mode + disabled -> command zero -> **midpoint / 50% duty command**.

Therefore “disable” and “force PWM output pin low” are not synonymous.

### 3. Generic combined TRAM write

After all module `prepare_tram_write()` functions have populated their memory images, `hm2_write()` calls:

`hm2_tram_write(hm2)`

This sends the registered cyclic write regions through the LLIO abstraction. The PWM value region is part of that combined transaction.

At this boundary the host has encoded the requested command into a HostMot2 register image. The actual transport could be PCI, Ethernet, SPI/parallel or another LLIO provider; IO04 does not assign transport-specific semantics here.

### 4. Configuration/enable change detection

After the TRAM write, generic `hm2_write()` calls:

`hm2_pwmgen_write(hm2)`

It compares current HAL state with cached values for:

- `output-type`;
- `offset-mode`;
- `dither`;
- `pwm_frequency`;
- `pdm_frequency`;
- each instance's `enable`.

If nothing changed, PWMGen returns without a configuration LLIO write.

If any field changed, control jumps to:

`hm2_pwmgen_force_write(hm2)`

### 5. Slow-path register synthesis

`hm2_pwmgen_force_write()` first resolves master frequencies:

- PWM attempts 12-bit resolution, then 11, 10, 9 bits as frequency increases; an unrepresentable high request is clipped to the board-clock maximum.
- PDM computes the DDS for its pulse-slot rate and clips too-low/high requests to representable values.

It then constructs each instance mode register:

- standard PWM + Direction -> output-mode bits 0, double-buffered;
- swapped Direction/PWM -> mode 1, double-buffered;
- Up/Down -> mode 2, double-buffered;
- PDM + Direction -> mode 3, not double-buffered;
- invalid mode -> diagnostic + HAL parameter repaired to standard PWM.

Dither, where requested, contributes its mode bit.

The function also builds one enable bitmask from all PWMGen instance `enable` pins.

### 6. Direct LLIO configuration writes

`hm2_pwmgen_force_write()` performs direct LLIO writes for:

1. PWM mode register array;
2. PWMGen enable bitmask;
3. PWM master-rate DDS;
4. PDM master-rate DDS.

If LLIO `io_error` is asserted afterward, the function returns without refreshing its cached `written_*` state. Otherwise current HAL values become the new shadow state.

This distinction matters during recovery: failed configuration publication is not silently marked as successful in the PWMGen cache.

### 7. Generic write completion

After the remaining HostMot2 module slow writes, generic `hm2_write()` calls `hm2_finish_write(hm2)`. Transport-specific LLIO implementations may use this to flush/complete queued writes.

## Same-cycle command + enable change

A same-cycle HAL change to both `value` and `enable` traverses two related but separate host paths:

1. `prepare_tram_write()` sees the current enable state while constructing the PWM **value** register image and forces the command to zero if disabled;
2. the generic TRAM write sends that value image;
3. the later `hm2_pwmgen_write()` detects the changed `enable` state and writes the PWMGen **enable register** through the slow path.

Do not collapse this into a fictional single atomic PWM register write. Exact hardware/transport ordering and the electrical interval between effects require lower-level transport/firmware study.

## Failure / debugging decision tree

If HAL `pwmgen.NN.value` changes but the physical analog/output signal does not:

1. verify HostMot2 generic `io_error` and board communication first;
2. verify the HAL `enable`, `scale`, `output-type`, `offset-mode`, frequency and dither state;
3. distinguish 0% duty from centered 50% offset-mode duty;
4. verify that the expected PWMGen instance/pins exist in the loaded firmware;
5. verify transport/register publication separately from FPGA pin generation;
6. verify the specific Mesa daughtercard / analog converter / amplifier wiring and transfer function;
7. only then investigate physical faults.

A correct HAL value alone proves neither successful register transfer nor correct physical output.

## Evidence classes

- Generic `hm2_write()` ordering: **SOURCE-CONFIRMED** at the pinned revision.
- `hm2_pwmgen_prepare_tram_write()` scaling/clipping/disable/offset/register encoding: **SOURCE-CONFIRMED**.
- `hm2_pwmgen_write()` change detection and `hm2_pwmgen_force_write()` configuration register path: **SOURCE-CONFIRMED**.
- Public scale/output-mode/frequency/offset semantics: **DOC-CONFIRMED** in current HostMot2 documentation.
- Disabled offset mode retaining centered duty on relevant analog-interface configurations: **SOURCE-CONFIRMED host behavior + COMMUNITY-REPORTED field behavior**.
- Actual FPGA waveform/electrical analog voltage: not test-confirmed here.

## Exact next symbols for deeper study

- `hm2_tram_write()` and `hm2_finish_write()` for transport batching semantics;
- HostMot2 firmware PWMGen HDL/register documentation for mode/value/sign interpretation;
- `hm2_eth` write path for Ethernet-specific ordering/error behavior;
- Mesa analog daughtercard manuals for PWM-to-voltage transfer;
- HostMot2 watchdog/IOPort interaction for fault-state output behavior.