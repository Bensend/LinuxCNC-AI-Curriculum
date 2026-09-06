# IO04 — HostMot2 PWM/PDM source guide

Course level: 1000  
Status: SOURCE  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer should be able to trace a HostMot2 PWMGen command from HAL `value`, `scale`, `enable`, mode and frequency configuration into the host-side TRAM/register images and LLIO write boundary, distinguish cyclic command data from slow configuration writes, explain offset/PDM/PWM mode differences, and avoid treating PWMGen or an external analog interface as a safety-rated output stage.

## Public behavior

Current `hostmot2(9)` documents:

- `value` is the per-instance command input.
- `scale` converts command units to duty command as `value / scale`; the effective duty range is clipped to `[-1,+1]`.
- `enable` controls whether the instance is enabled.
- `output-type` selects PWM+Direction, Up/Down, PDM+Direction, or swapped Direction/PWM.
- `offset-mode=true` maps command zero to 50% duty, -1 to 0%, and +1 to 100% with default scaling. It is intended for centered PWM motor drives and PWM-to-analog interfaces; direction is typically unused there.
- `dither` increases effective PWM resolution on firmware which supports it and does not apply to PDM.
- module-wide `pwm_frequency` and `pdm_frequency` set the respective carrier / pulse-slot rates and are clipped to what the board clock can represent.

Classification: DOC-CONFIRMED for current documentation, not automatically version-generalized to every historical HostMot2 revision.

## Descriptor and HAL export path

Pinned `src/hal/drivers/mesa-hostmot2/pwmgen.c::hm2_pwmgen_parse_md()`:

1. accepts old PWM firmware descriptor version 0 or dither-capable version 1 after `hm2_md_is_consistent()` checks;
2. rejects duplicate PWM descriptors or a requested instance count larger than firmware provides;
3. derives five register addresses from the descriptor base and register stride:
   - PWM value;
   - PWM mode;
   - PWM master-rate DDS;
   - PDM master-rate DDS;
   - enable;
4. registers the PWM value area as a TRAM **write** region;
5. allocates non-TRAM mode-register storage;
6. exports module-wide `pwm_frequency` and `pdm_frequency`, both initially 20 kHz;
7. exports per-instance `value`, `enable`, `offset-mode`, `scale`, `output-type`, and dither where firmware supports it;
8. initializes `written_*` shadows so the first slow-path write is forced.

The registration structure is important: cyclic PWM values participate in the generic TRAM write, while mode/enable/rate registers are written by the separate slow/change-detected path.

## Cyclic command conversion

Pinned `hm2_pwmgen_prepare_tram_write()` executes for every active PWMGen instance before the generic `hm2_tram_write()`.

### 1. Scale and clip

`scaled_value = value / scale`, then positive values above +1 are clipped to +1 and negative values below -1 to -1.

There is **no explicit scale==0 guard in this function**. The public default is 1.0. Exact behavior for pathological zero/NaN scale inputs is intentionally not promoted to a supported semantic guarantee; it belongs in the uncertainty queue because floating-point exceptional values can reach later integer conversion.

### 2. Disable behavior

If HAL `enable` is false, the host forces `scaled_value = 0.0` before register encoding.

This does not imply that all physical output pins become electrically zero. The source comment explicitly notes that PWM/Direction hardware normally continues its pattern while the downstream equipment is expected to obey the separate `/Enable` signal. The host-side zeroing exists for downstream equipment which does not behave that way.

A crucial exception follows from offset mode: command zero represents **50% duty**. Thus disabled + offset-mode intentionally encodes centered duty, not 0% duty.

### 3. Normal PWM/PDM mode encoding

For non-offset mode:

- PDM uses 12 magnitude bits.
- PWM/Up-Down/swapped PWM uses the selected `pwm_bits` (9–12 depending on frequency).
- dither changes the top-end magnitude allowance (`topdrop` 1.0625 instead of 1), avoiding a top register value incompatible with the dither representation.
- magnitude is `abs(scaled_value) * ((1 << bits) - topdrop)`.

The result is stored as a 16.16-style value in the 32-bit PWM value register (`register_value * 65536`). Negative commands additionally set bit 31.

### 4. Offset-mode encoding

For offset mode:

- PDM uses 11 magnitude bits around a midpoint;
- PWM uses `pwm_bits - 1` around a midpoint;
- register value is shifted so command zero maps to the midpoint and therefore 50% duty.

The code still sets the sign bit for negative `scaled_value`; current documentation notes that direction is typically unused in offset mode. Do not infer external polarity or analog-voltage semantics without the actual firmware/output-stage documentation.

## Frequency and resolution handling

`hm2_pwmgen_handle_pwm_frequency()` chooses the highest feasible PWM resolution in order 12, 11, 10, then 9 bits. If the request cannot fit at 9 bits it clips `pwm_frequency` to the board-clock-dependent maximum and records 9-bit operation.

`hm2_pwmgen_handle_pdm_frequency()` keeps the PDM density pattern at 12 bits and computes the master DDS from requested pulse-slot frequency. Too-low or too-high requests are clipped to representable limits and the HAL parameter is rewritten to the achievable frequency.

These calculations are SOURCE-CONFIRMED at the pinned revision.

## Slow configuration / enable path

`hm2_pwmgen_write()` compares current HAL configuration against `written_*` shadows. Any change in output type, offset mode, dither, PWM frequency, PDM frequency, or enable jumps to `hm2_pwmgen_force_write()`; otherwise it performs no PWMGen configuration write.

`hm2_pwmgen_force_write()`:

1. recomputes PWM/PDM master-rate DDS values;
2. maps PWM resolution into width bits;
3. maps `output-type` into mode bits;
4. enables double buffering for PWM, Up/Down and swapped PWM, but not PDM;
5. applies dither bit where requested;
6. builds one enable bitmask from all per-instance `enable` HAL pins;
7. performs LLIO writes for mode array, enable mask, PWM DDS and PDM DDS;
8. if LLIO `io_error` is clear, copies current HAL configuration into the `written_*` shadows.

An invalid output type is diagnosed, repaired to standard PWM+Direction, and then written.

## Interaction with generic HostMot2 write

Pinned `hostmot2.c::hm2_write()` first returns immediately if LLIO `io_error` is asserted. Otherwise it:

1. initializes GPIO direction state once if required;
2. calls each module's `*_prepare_tram_write()` including `hm2_pwmgen_prepare_tram_write()`;
3. executes the combined `hm2_tram_write()` containing the cyclic PWM value region;
4. runs change-detected slow writes, including `hm2_pwmgen_write()`;
5. eventually calls `hm2_finish_write()`.

Thus a PWM command value and an enable/mode change in the same invocation are not one identical register operation: value data is prepared for the combined TRAM transaction, whereas mode/enable/rate changes are emitted afterward by the PWMGen slow path.

## Failure boundaries

- `io_error` asserted before `hm2_write()` prevents the write cycle from beginning.
- PWMGen slow writes do not update their `written_*` cache if `io_error` is asserted after the LLIO writes, preserving the need to retry when communication recovers.
- This source trace does not establish what a physical board pin does during packet loss, watchdog bite, board reset, driver disable, or external amplifier fault. Those are separate HostMot2/hm2_eth/firmware/electrical questions.
- `enable` is ordinary machine-control state, not a certified safety channel.

## Community leads reconciled

Mesa developer PCW has repeatedly corrected configurations for centered analog-output cards to use `offset-mode=1`, explaining that centered mode represents zero analog output at 50% PWM duty. A 2023 forum answer also explicitly states that disabled offset mode remains at 50% duty and suggests external/HAL selection if a user truly requires 0% PWM while disabled. These reports agree with the pinned host-side encoding and are retained as COMMUNITY-REPORTED field evidence, not as generic guarantees for every daughtercard.

## Higher-level promotion / uncertainty queue

| Item | Evidence | Why deferred | Consequence | Destination | Priority | Blocks IO04? |
|---|---|---|---|---|---|---|
| Production-path write-capture experiment using mutable fake LLIO + valid PWM descriptor | source feasibility only | stock `hm2_test` discards writes and its existing patterns do not provide a usable PWM command fixture | stronger runtime verification of host register encoding | IO04/2000 or synthetic-I/O advanced lab | HIGH | No |
| scale=0 / NaN / Inf behavior through floating-to-register conversion | source shows no explicit guard | pathological input; needs bounded adversarial runtime/compiler test | could create surprising output command if misconfigured | 2000 | HIGH | No, guide explicitly prohibits relying on it |
| Exact FPGA interpretation of mode/value/sign/dither bits | host source only | requires HostMot2 firmware HDL / board-specific verification | needed for deeper firmware mastery | HM06/2000 | HIGH | No |
| Physical PWM-to-analog voltage/current transfer and polarity | board/interface dependent | requires specific Mesa daughtercard/manual/hardware | machine commissioning impact | IO05 / commissioning | CRITICAL | No, explicitly bounded |
| Watchdog-bite/output electrical state and safe-state timing | HM08 docs/source only at host level | representative hardware/firmware required | safety/reliability critical | advanced hardware/safety | CRITICAL | No, no safety claim made |

## 1000-level sufficiency

The host-side command/register architecture is source-grounded, agrees with public documentation, and is cross-checked against a real field configuration failure involving offset mode. A stock no-hardware fixture cannot currently observe the relevant PWM writes; extending it would be synthetic host-path verification rather than FPGA/electrical verification and is valuable but not required to understand the 1000-level command path. The physical/safety boundaries are explicit rather than inferred.