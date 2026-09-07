# IO06 adversarial exam and correction key

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`

## Questions

1. A full GPIO has `out=1`, `is_output=1`, `is_opendrain=1`. An engineer says HostMot2 is actively driving the connector high. Is that correct? Trace the host controls and state what is and is not proven.
2. `gpio.005.in` has held `0` for 20 servo cycles. Prove that the physical input was low on all 20 cycles.
3. A stepgen direction pin exposes `.direction.is_opendrain` and `.gpio.NNN.is_opendrain`. Are these two independent controls? Explain the export/alias logic.
4. In one servo cycle HAL changes `gpio.003.out` and `gpio.003.is_output` from input to output. Which register image is prepared/written first? Does DDR-last imply the complete transition is physically glitch-free?
5. Why does a full GPIO's `out` not control a pin currently owned by PWMGen/StepGen/etc. even though the physical pin still has GPIO input visibility?
6. Misleading premise: "Because `hm2_ioport_gpio_process_tram_read()` publishes input state for every pin, `gpio.NNN.in` is a guaranteed electrical readback of push-pull output voltage." Correct the premise.
7. Failure trace: `hm2_finish_read()` returns `-EAGAIN`. What happens to `gpio.NNN.in` during that call, and what diagnostic mistake could follow?
8. Version-sensitive reasoning: a historical forum thread says HostMot2 used to write DDR before open-drain/inversion and caused a startup pulse. What should be checked before applying that statement to this pinned revision?
9. Small modification task: design the least-invasive host-only test fixture extension needed to verify GPIO packing and DDR-last ordering. Which claims would remain unverified even if it passes?
10. When can `<board>.read_gpio` / `.write_gpio` exist, and why should a normal config not assume they are required?

## Answer / correction key

1. Incorrect. In current documented HostMot2 semantics, open-drain `out=1` requests high impedance/release. The host sets Data plus open-drain/direction configuration; connector voltage depends on pull-up/external circuitry and board hardware. Host source alone cannot prove an actively driven high or safety behavior.
2. You cannot prove freshness from the HAL value alone. Generic `hm2_read()` returns before GPIO publication on existing `io_error`, post-finish `io_error`, or `-EAGAIN`; the old HAL value can remain visible. Confirm transport/read completion or independent hardware evidence.
3. They are aliases when the active module output qualifies. `hm2_ioport_gpio_export_hal()` creates the physical GPIO parameter and aliases it under the module/function name. They address the same underlying HAL parameter/electrical-mode control.
4. `hm2_ioport_gpio_prepare_tram_write()` prepares the Data TRAM image before `hm2_tram_write()`. Only afterward does `hm2_ioport_write()` update/open-drain/invert/DDR configuration, with DDR last among those configuration writes. This ordering is not a physical glitch-free guarantee.
5. Active pin configuration selects the secondary/alternate source and changes the pin's active `gtag`. GPIO Data preparation skips non-IOPort pins, so the owning module supplies logical output data. The IOPort Data input register can still be sampled for physical-pin visibility.
6. The source publishes the Data-register bit, but current documentation explicitly says `in/in_not` are undefined for normal outputs. Source-level publication is not equivalent to a defined electrical feedback guarantee.
7. GPIO processing is skipped for that call; previously published HAL pins stay as they were. A debugger can falsely conclude the physical signal is frozen/stable.
8. Inspect the exact revision's `hm2_ioport_force_write()` and `hm2_ioport_write()` ordering. At the pinned revision DDR is written last. The historical report is rationale/context, not current behavior evidence by itself.
9. Extend a valid fake IOPort board with mutable Data-register read state plus an LLIO write-capture log. Assert Data packing, module-owned exclusion, open-drain/invert/DDR address/value changes and DDR-last order. Even then FPGA semantics, electrical levels, pull-ups, transients, timing and safety remain unverified.
10. Registration exports them only when the LLIO declares `threadsafe`. Current docs say normal `read`/`write` already include GPIO and the GPIO-only functions are for specialized fast I/O; they are not the standard required path.

## Adversarial corrections incorporated

- Corrected the tempting but wrong statement that generic `gpio.in` is always meaningful output readback. The driver publishes the register bit, but documentation leaves normal-output input value undefined.
- Made stale-data behavior explicit: skipped read processing can preserve old HAL values.
- Split "DDR last" into the narrower correct statement: DDR is last among IOPort configuration writes; cyclic Data TRAM is submitted earlier in the standard write path.
- Clarified aliases on module-owned outputs: they are views of the physical IOPort mode parameters, not separate duplicated output controls.
- Preserved the open-drain distinction between logical `1` and actively driven high.

## Result

PASS for 1000-level IO06 reasoning. All ten answers are supported by current documentation and/or pinned host source, and higher-level physical/FPGA claims remain explicitly excluded or promoted.
