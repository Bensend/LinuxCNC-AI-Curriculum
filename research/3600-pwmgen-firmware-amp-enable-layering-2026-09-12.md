# 3600 — PWMgen, custom-firmware, and amplifier-enable layering

Date: 2026-09-12
LinuxCNC source revision: `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`

## Question

After the prior gravity-loaded R-axis brake failure trace, can a concrete field configuration clarify where actuator enable authority actually lives between LinuxCNC HAL, HostMot2 firmware routing, and the external servo amplifier?

## Community evidence

The Ursviken/Pullmax retrofit thread supplies a useful sequence:

- the machine uses custom 7i80 firmware with a Mesa 7i54 for valve-coil PWM and a separate Cybelec amplifier for the R-axis DC servo;
- when the builder initially obtained no 7i54 PWM output, PCW asked whether `hm2_7i80.0.pwmgen.00.enable` was true and stated that this custom firmware had PWMGEN 0 enabling all 7i54 PWMgens;
- the builder later concluded that the R-axis brake required dynamic enable/disable of the Cybelec amplifier while other outputs remained usable, and proposed keeping the relevant HostMot2 PWMgen enabled from machine-on while using a discrete output to independently enable the R-axis amplifier.

Classification: **COMMUNITY-REPORTED** for the exact custom-firmware topology and machine behavior. The forum statements are valuable implementation evidence but are not a substitute for the unavailable custom VHDL/config attachment.

## Stock HostMot2 source trace

Pinned `src/hal/drivers/mesa-hostmot2/pwmgen.c` establishes a different, generic software layer:

1. `hm2_pwmgen_parse_md()` creates one HAL `...pwmgen.%02d.enable` input per PWMgen instance.
2. The enable register is assembled as a bitmask: for each instance whose HAL enable is true, bit `1 << i` is set.
3. `hm2_pwmgen_prepare_tram_write()` separately forces the instance's scaled PWM value to zero when that HAL enable is false. Its comment explains that PWM/Dir may otherwise continue while physical `/Enable` is inactive and that zeroing accommodates downstream equipment that does not honor `/Enable` as expected.

Classification: **SOURCE-CONFIRMED** at the pinned revision.

## Reconciliation

There is no contradiction between stock HostMot2 exposing per-instance enable bits and PCW reporting that PWMGEN 0 enabled all 7i54 PWMgens on this machine. The latter statement is about the machine's **custom firmware/output routing**, not a universal property of `pwmgen.c`.

This yields a more precise authority chain:

`LinuxCNC machine/joint intent`
→ `HAL PWMgen instance enable/value`
→ `HostMot2 enable/value registers`
→ `FPGA firmware pin/module routing`
→ `physical output-stage enable/current path`
→ `external servo-amplifier enable/readiness`
→ `mechanical brake release/holding state`
→ `actuator motion`

A true value at an earlier stage is not proof of a later stage. In particular:

- HAL `pwmgen.N.enable` is a requested HostMot2 output state, not proof that a custom FPGA mapping independently enables only the intended physical channel;
- a PWM value/register is not proof that the external amplifier is enabled or ready;
- amplifier enable is not proof that a mechanical brake is released;
- brake release is not proof of motion, feedback validity, or absence of a hard stop.

## Function / call-flow notes

### `hm2_pwmgen_parse_md()`

Purpose: instantiate PWMgen software state and HAL interface from the HostMot2 module descriptor.

Behaviorally important output: per-instance `value` and `enable` HAL pins.

### enable-register preparation

The driver rebuilds the module enable register from the per-instance HAL enable pins, assigning one bit per instance in stock HostMot2 software.

### `hm2_pwmgen_prepare_tram_write()`

Purpose: convert HAL values to hardware register values before the TRAM write.

Important failure/authority boundary: a disabled HAL instance has its scaled command forced to zero, but this is still only controller-side behavior. Physical routing and downstream equipment remain separate evidence domains.

## Adversarial checks

1. **Claim:** `pwmgen.00.enable=true` proves every 7i54 channel is independently enabled. **Reject.** The field statement is specific to custom firmware; stock source uses per-instance enable bits.
2. **Claim:** stock per-instance HAL enables prove independent physical channel authority under arbitrary custom firmware. **Reject.** Firmware pin/module routing can couple physical outputs differently.
3. **Claim:** a nonzero PWM register proves the Cybelec R-axis amplifier can move. **Reject.** External amplifier enable/readiness and brake state are downstream.
4. **Claim:** machine-on can safely substitute for all per-axis authority logic. **Reject.** The field retrofit itself separated shared PWM availability from dynamic R-amplifier enable; safety adequacy is not established by this ordinary-control evidence.
5. **Claim:** the forum proves a universal architecture for press brakes. **Reject.** It demonstrates a real integration boundary and failure mode, not a universal design.

Result: **5/5 boundary checks passed.**

## Durable 3600 rule

For custom Mesa/HostMot2 systems, document actuator authority at **three distinct electrical/control layers at minimum**:

1. LinuxCNC/HAL command and enable state;
2. FPGA firmware physical routing/output-stage enable semantics;
3. downstream amplifier/valve/brake readiness and feedback.

Never infer layer 2 from generic HostMot2 software when custom firmware is in use, and never infer layer 3 from either layer 1 or 2 without an explicit witness.

## Unknowns / stop condition

Still unknown from inspectable source:

- the exact custom `PIN_SV10_7I36_7I54_NWE_72.vhd` routing;
- the final R-axis discrete amplifier-enable/brake component and its timing;
- whether amplifier-ready/fault feedback was eventually incorporated;
- final stall/tracking thresholds and recovery behavior;
- safety-rated architecture.

Do not invent these values or infer them from the interim forum design. Reopen this branch only if the final custom firmware/config/component becomes inspectable.

No laboratory run was launched: stock software behavior is source-visible, while a synthetic fixture cannot establish the unavailable custom FPGA routing or physical amplifier/brake behavior.
