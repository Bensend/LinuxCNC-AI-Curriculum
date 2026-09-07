# IO06 — HostMot2 GPIO source guide

Course level: 1000  
Status: SOURCE  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This lesson traces the host-side HAL ↔ HostMot2 IOPort register path. It does **not** establish connector voltage, FPGA pad drive strength, pull-up value, isolation behavior, electrical fail-safe state, or functional safety.

## Intended/public behavior

Current HostMot2 documentation says unused board pins are exported as full GPIOs. Full GPIOs can be inputs, push-pull outputs, or open-drain outputs; pins owned by active module instances retain a restricted GPIO interface. `read`/`write` normally move GPIO together with the rest of HostMot2, while `read_gpio`/`write_gpio` are optional faster GPIO-only functions on low-level drivers that declare themselves thread-safe.

Open-drain semantics are important: requested `out=0` drives low; requested `out=1` releases the pin to high impedance. The observed level is then available through `in`/`in_not`. For normal push-pull outputs, documentation says `in`/`in_not` are undefined.

Evidence: DOC-CONFIRMED by current HostMot2 documentation. Historical/community reports are used only as investigation leads.

## Source inventory

| Path | Symbols | Why it matters |
|---|---|---|
| `src/hal/drivers/mesa-hostmot2/ioport.c` | `hm2_ioport_parse_md`, `hm2_ioport_gpio_export_hal`, `hm2_ioport_update`, `hm2_ioport_force_write`, `hm2_ioport_write`, `hm2_ioport_gpio_process_tram_read`, `hm2_ioport_gpio_prepare_tram_write`, `hm2_ioport_gpio_read`, `hm2_ioport_gpio_write` | Core GPIO HAL/register implementation |
| `src/hal/drivers/mesa-hostmot2/hostmot2.c` | `hm2_read_request`, `hm2_read`, `hm2_write`, `hm2_read_gpio`, `hm2_write_gpio`, `hm2_register`, `hm2_force_write` | Generic cycle ordering and registration |
| `src/hal/drivers/mesa-hostmot2/pins.c` | `hm2_configure_pins` and pin-source helpers | Determines primary GPIO vs active-module alternate source |
| `src/hal/drivers/mesa-hostmot2/hm2_test.c` | `hm2_test_read`, `hm2_test_write`, static test patterns | Bounds the no-hardware experiment capability |

## Register model

`hm2_ioport_parse_md()` validates an IOPort module descriptor and derives five register addresses from the module base plus register stride:

1. Data register — registered for both TRAM read and TRAM write.
2. DDR register — direction control; non-TRAM buffer with cached last-written copy.
3. Alternate-source register — selects primary GPIO or the pin descriptor's secondary module source.
4. Open-drain register — non-TRAM buffer with cached last-written copy.
5. Output-invert register — non-TRAM buffer with cached last-written copy.

At parse time the host mirrors initialize to all inputs, primary/GPIO source, non-open-drain, non-inverted. GPIO HAL export is deliberately delayed until after module allocation because active modules may claim pins.

Evidence: SOURCE-CONFIRMED.

## HAL export and module-owned aliases

`hm2_ioport_gpio_export_hal()` allocates GPIO state for **every** physical HostMot2 pin and always exports `gpio.NNN.in` and `gpio.NNN.in_not` as HAL outputs.

A full GPIO (`gtag == HM2_GTAG_IOPORT`) gets:

- HAL input pin `gpio.NNN.out`;
- RW parameter `gpio.NNN.is_output`;
- RW parameters `gpio.NNN.is_opendrain` and `gpio.NNN.invert_output`.

A pin owned by another active module does not get a usable GPIO `out`/`is_output`. If that active-module pin is an output, HostMot2 still exposes open-drain and inversion controls and creates HAL aliases based on the owning module/function name. Thus names such as a PWM/step output's `.is_opendrain` are aliases to the same per-physical-pin GPIO parameter, not separate electrical controls.

Evidence: SOURCE-CONFIRMED.

## Input path

The IOPort Data register participates in TRAM reads. After `hm2_finish_read()` succeeds, generic `hm2_read()` invokes `hm2_ioport_gpio_process_tram_read()`. That function publishes **every** pin bit from `data_read_reg[]` to `gpio.NNN.in` and its complement to `in_not` without checking direction.

This is subtly different from the optional GPIO-only function. `hm2_ioport_gpio_read()` performs a direct LLIO Data-register read and publishes only pins whose current host direction is input. The generic TRAM path therefore exposes the sampled Data register for outputs too, but public documentation still defines normal push-pull output input values as undefined. Source visibility must not be upgraded into an electrical guarantee.

Evidence: SOURCE-CONFIRMED host behavior; connector/electrical meaning remains board/firmware evidence.

## Output data path

`hm2_ioport_gpio_prepare_tram_write()` walks each physical pin, skips any pin whose active `gtag` is not `HM2_GTAG_IOPORT`, and packs the full-GPIO `out` HAL pin into `data_write_reg[]`. The combined `hm2_tram_write()` later queues/writes that Data-register image with other HostMot2 cyclic outputs.

Therefore a module-owned pin's actual function output is produced by its owning module's register path, not by `gpio.NNN.out`. The GPIO-facing aliases on such output pins affect IOPort configuration (open-drain/inversion), not the owning module's logical command source.

Evidence: SOURCE-CONFIRMED.

## Direction, open-drain, inversion and ownership

`hm2_ioport_update()` reconstructs IOPort configuration from HAL/host state every write cycle:

- only full GPIOs take direction from `is_output`;
- if a pin's current direction is output, the DDR bit is set and its open-drain/invert parameters are reflected into the respective register mirrors;
- input direction clears DDR and forcibly clears the open-drain bit; inversion is irrelevant in input mode.

`hm2_ioport_write()` change-detects open-drain, output-invert and DDR mirrors and performs direct LLIO writes only when a mirror differs from its cached last-written copy. **DDR is written last** to reduce startup transition glitches.

`hm2_ioport_force_write()` writes output-invert, open-drain, alternate-source, then DDR last. It is used during registration and broader HostMot2 recovery/configuration restoration.

The alternate-source register is not rebuilt from runtime GPIO HAL parameters. It is established by pin/module configuration: primary source clears the bit and leaves the pin as GPIO/IOPort; secondary source sets the bit and assigns the pin's active `gtag` to its module function.

Evidence: SOURCE-CONFIRMED.

## Generic cycle ordering

Pinned `hostmot2.c` orders the standard functions as follows.

Read:

`hm2_read_request()` → TRAM read/queued reads → `hm2_finish_read()` → watchdog status → `hm2_ioport_gpio_process_tram_read()` → encoder/other module processing.

If `io_error` is already asserted, or becomes asserted, processing returns early. `-EAGAIN` from `hm2_finish_read()` also returns before GPIO HAL publication, so stale previously published HAL values can remain visible.

Write:

`hm2_write()` first initializes pin directions once, then prepares watchdog and GPIO Data TRAM images, then all other cyclic output images → `hm2_tram_write()` → `hm2_ioport_write()` performs change-detected configuration writes → other slow/config writes → `hm2_finish_write()`.

Thus GPIO **data** is prepared before the combined TRAM write, while direction/open-drain/inversion changes are written afterward. DDR itself is last within the IOPort configuration update, but a same-cycle change of `out` and `is_output` can place the Data-register write before the DDR transition. This is a host ordering fact, not a promise of glitch-free connector behavior.

Evidence: SOURCE-CONFIRMED.

## GPIO-only functions

If the low-level driver declares `threadsafe`, registration additionally exports `<board>.read_gpio` and `<board>.write_gpio`.

- `read_gpio` does a direct IOPort Data-register read and publishes only current input-direction pins.
- `write_gpio` calls `hm2_ioport_write()` first, builds the full-GPIO Data image, directly writes it, then services watchdog configuration/recovery.

They are optional specialized functions and are not required for normal servo-thread GPIO operation.

Evidence: SOURCE-CONFIRMED, consistent with current official documentation.

## Community findings retained as leads

A 2021 LinuxCNC forum report described a very short unwanted startup pulse on a Mesa GPIO. PCW identified IOPort register-write ordering as the likely mechanism and specifically recommended writing DDR after inversion/open-drain setup. The pinned source now does exactly that: both force and change-detected paths write DDR last. This is useful historical corroboration of why the ordering exists, but it is not experimental evidence that all startup glitches are eliminated on all boards.

A 2024 forum GPIO-test answer from PCW also reinforces that hardware I/O does not update merely because HAL parameters changed: HostMot2 read/write functions must run, and raw IOPort addresses can be inspected with Mesa tooling. Treat the exact addresses in that board-specific example as board/firmware-specific, not universal constants.

Evidence: COMMUNITY-REPORTED.

## Failure/debugging boundaries

1. **HAL `out` changes but connector does not:** verify the pin is actually a full GPIO, `is_output=1`, HostMot2 `write` is scheduled, and no `io_error` blocks the write path before suspecting hardware.
2. **Module-owned pin has no GPIO `out`:** expected; its logical output belongs to the active module. Use module command pins plus the aliased open-drain/inversion controls when applicable.
3. **`in` appears unchanged:** a failed/skipped generic read can leave the last HAL sample visible. Stale HAL is not proof of stable physical input.
4. **Open-drain `out=1`:** means release/high impedance, not driven logic-high. External pull-up/wiring determines the observed voltage.
5. **Push-pull output `in`:** generic source publishes the sampled Data-register bit, but documentation labels the physical meaning undefined; do not use it as a guaranteed readback/fault detector without board-specific evidence.
6. **Startup/recovery:** `hm2_force_write()` restores IOPort configuration with DDR last, but physical transient behavior remains board/firmware/electrical evidence.

## Experiment feasibility audit

Stock pinned `hm2_test` is useful as a static HostMot2 registration parser fixture, but its LLIO read copies bytes from an unchanging compiled-in register image and its write callback discards address/data and returns success. It therefore cannot verify multi-cycle GPIO input transitions or inspect generated output/configuration writes without modification.

A meaningful 2000-level production-path fixture would need:

- a valid IOPort descriptor and pin descriptor set that survives registration;
- mutable Data-register read state;
- write capture with address/size/value history;
- assertions for GPIO Data packing, DDR last ordering, open-drain/invert change detection, module-owned pin exclusion and optional read_gpio/write_gpio behavior.

Such a fixture would verify **host logic only**. It would not test FPGA register semantics, connector voltage, drive strength, pull-ups, latency, transients, or safety.

Decision: PROMOTE to 2000/HIGH rather than mislabel static inspection as TEST-CONFIRMED GPIO behavior.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---|
| Full GPIO output data uses the IOPort Data TRAM write image | SOURCE-CONFIRMED | High |
| Generic read publishes every IOPort Data bit to `in/in_not` after successful TRAM completion | SOURCE-CONFIRMED | High |
| Full-GPIO direction/open-drain/invert are non-TRAM config writes with DDR last | SOURCE-CONFIRMED | High |
| Module-owned output pins can expose aliases for open-drain/inversion but not a full GPIO command path | SOURCE-CONFIRMED | High |
| Open-drain `out=1` means high impedance, not driven high | DOC-CONFIRMED | High |
| Normal output `in/in_not` have defined electrical readback meaning | UNKNOWN / docs say undefined | Do not rely on it |
| Stock `hm2_test` can prove changing GPIO runtime behavior | False; source audit rejects | High |

## Higher-level promotion / uncertainty queue

| Item | Current evidence | Destination | Priority | Blocks 1000 graduation? |
|---|---|---|---|---|
| Mutable IOPort fake-LLIO production-path experiment | Source-only host behavior | 2000 | HIGH | No |
| Same-cycle data + direction transition and measurable connector glitch behavior | Host ordering only | 2000 + hardware commissioning | HIGH | No, bounded |
| FPGA IOPort implementation/readback semantics | Host source + docs only | HM04/2000 | HIGH | No |
| Board-specific pull-up, voltage, drive-current and fail-state behavior | Not established here | commissioning | CRITICAL | No, explicitly excluded |
| Whether specific board/firmware combinations ever violate expected open-drain/readback behavior | Community leads only | 2000/hardware | MEDIUM | No |

## 1000-level sufficiency

The host HAL/register path, ownership model, cycle ordering, error/stale-data boundary, and open-drain semantic trap are source/doc grounded. A software-only runtime experiment would require extending the fixture; that experiment is valuable but does not invalidate the 1000-level architecture if clearly promoted. Physical behavior remains outside the cloud evidence boundary.
