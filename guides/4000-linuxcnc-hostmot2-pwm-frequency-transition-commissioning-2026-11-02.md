# 4000 — HostMot2 PWM carrier changes: source-to-register commissioning card

**MESA-PWM-151 | 2026-11-02 | source-grounded 4000 implementation; 3100 mill / 3200 lathe / 3400 router transfer | NOT RUN.**

Read [the source investigation](../research/4400_LINUXCNC_MESA_PWM_151_RUNTIME_FREQUENCY_BIT_WIDTH_TRAM_ORDER_SOURCE_AUDIT_2026-11-02.md) and [prior MESA-66](../research/4400_LINUXCNC_MESA_66_SMITHY_5I20_PWM_ENABLE_STOP_AND_OFFSET_MODE_SOURCE_AUDIT_2026-10-31.md) first. Do not mistake a PWM carrier-frequency setting for spindle RPM or a spindle contactor. The real Smithy 622 config is a wiring example, **not** proof of any transient.

## Trace this implementation, not a generic PWM model

In pinned v2.9.10 `src/hal/drivers/mesa-hostmot2/hostmot2.c::hm2_write`, annotate the exact sequence `prepare_tram_write` (line 138) → `hm2_tram_write` (150) → `hm2_pwmgen_write` (156). Then in `pwmgen.c`, locate `hm2_pwmgen_prepare_tram_write` (606–674), `hm2_pwmgen_write` (310–350), `hm2_pwmgen_force_write` (181–301), and `hm2_pwmgen_handle_pwm_frequency` (33–106). Recheck the development commit `06864e23559e70463fc7112d5ce77138bcbc288c`; its HAL accessor refactor does not reverse the three-step order.

The implementation-level invariant for glitch-free width transitions would require the **mode and value to be mutually consistent at the FPGA observation boundary**. The existing source does not establish that invariant on a dynamic frequency change. A HAL `setp` that returns successfully does not certify an external waveform or drive response.

## Reproducible arithmetic preflight (no machine)

Use the **hypothetical** `ClockHigh=100000000` Hz, not an asserted 5I20 hardware descriptor. For each frequency `f`, select the first `bits` in 12,11,10,9 for which `floor(f*65536*2^bits/100000000)<65536`. If none fits, use 9 bits and DDS=65535. Compute `actual=100000000*DDS/(65536*2^bits)`.

For `value=0.5`, `scale=1`, `enable=TRUE`, `offset_mode=0`, `dither=FALSE`, compute `encoded=floor(0.5*(2^bits-1)*65536)`. Expected source-derived values: 20 kHz → **12 bits**, DDS **53687**, encoded **134184960**; 60 kHz → **10 bits**, DDS **40265**, encoded **33521664**. A frequency change across this boundary will cause the first `hm2.write` to prepare the old-width encoded value and only then program the new mode. On PCI the TRAM queue fallback writes immediately; on hm2_eth the old-width value and new mode writes are queued for a single packet flush. The **next** `hm2.write` prepares the new-width value. The batching difference does not prove atomic FPGA application. Do not infer a 4× measured duty; register interpretation is unverified.

## Bounded disconnected acceptance (qualified self-hosted only)

| Case | Input / action | Frozen oracle | Required evidence |
| --- | --- | --- | --- |
| A | Static 20 kHz, 100 MHz descriptor | 12-bit mode, DDS 53687, half-scale value register 134184960 | C source version/blob, register log |
| B | Static 60 kHz, same descriptor | 10-bit mode, DDS 40265, half-scale value register 33521664 | Register log |
| C | Runtime 20→60 kHz between servo callbacks | Old-width value prepared **before** new mode/rate; PCI immediate versus Ethernet batched write paths differ | Timestamped LLIO enqueue/send/flush trace; no waveform verdict |
| D | Next callback after C | Value register uses new 10-bit scaling | Trace with callback/sequence numbers |
| E | Runtime change without width change, e.g. 10→20 kHz | Same 12-bit value scaling; master rate changes | Negative control |
| F | Disabled PWM, normal vs offset mode | Driver zeros scaled value; normal mode yields zero-width command, offset mode yields midpoint command; separate /Enable output still matters | Mode/value/enable register traces; **not** safety test |
| G | Request above supported maximum, e.g. 200 kHz at 100 MHz | 9-bit mode, DDS 65535, nominal 195309.52 Hz and HAL frequency clipped | Source/parameter readback and register trace |
| H | Stable v2.9.10 versus pinned development | Same ordering; note HAL accessor and signed-bit literal differences from MESA-66 | Exact commit/blob and diff |

**Harness validity gates:** (1) no physical IO or drives attached; (2) fake-LLIO records **each** write, queue operation, flush and address with a servo callback identifier; (3) record both value TRAM and mode/master-rate writes; (4) do not call a standalone reimplementation of the formulas a LinuxCNC execution test; (5) test a no-width-change negative control; (6) log actual source commit and firmware descriptor clock; (7) preserve unmodified raw traces; (8) compare with source oracle before making any FPGA claim; (9) discriminate PCI's `dummy_queue_write` immediate fallback from `hm2_eth`'s realtime batching in `tram.c`/`hm2_finish_write`. A simulated register trace alone cannot prove FPGA output behavior.

## Practical machine configuration review

Read the real [Smithy 622 HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/622.hal): `spindle.0.speed-out` goes to `pwmgen.00.value`; `pwmgen.pwm_frequency` is set to **100 Hz**; `pwmgen.00.enable` is held TRUE by a separate constant signal; `spindle.0.on` drives a **different** GPIO. A VFD/drive may use PWM as a speed reference and a separate contactor/enable line; check the **actual** wiring and drive manual before transferring settings to another machine. The Smithy config does not dynamically modify carrier frequency and should not be used as evidence of the transition problem.

For commissioning, document the actual Mesa firmware module descriptor clock, output-type, offset-mode, dither, scale, PWM frequency, physical pin assignment, watchdog, servo-thread `addf` order, and downstream drive response. Freeze the carrier configuration before enabling normal machine motion. A dynamic carrier change is a software/FPGA integration change requiring its own disconnected validation, not a routine tuning shortcut.

## Open engineering decision

A future upstream change might update width/mode before preparing value, or stage both register families coherently. **Neither correction is proven** without knowing FPGA buffering and the LLIO transport semantics. Do not submit a patch merely by reordering functions; first establish whether a register-order change causes a different intermediate inconsistency or violates write batching. Keep MOTION-144 as the higher-priority disconnected motion-state experiment if qualified compute becomes available.

**Evidence:** SOURCE/DOC-CONFIRMED, source-derived arithmetic; dynamic physical effect INFERENCE/UNKNOWN; runtime TEST-CONFIRMED none. Independent personnel safety and previously graduated levels remain unchanged.
