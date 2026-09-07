# IO06 call flow — HostMot2 GPIO HAL ↔ IOPort register path

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Registration / ownership setup

1. Low-level board driver calls `hm2_register(llio, config)`.
2. HostMot2 reads and validates cookie, ConfigName, IDROM, pin descriptors and module descriptors.
3. `hm2_parse_module_descriptors()` registers the IOPort Data register as both TRAM-read and TRAM-write regions and allocates non-TRAM mirrors for DDR, alternate source, open-drain and output-invert.
4. TRAM regions are allocated.
5. `hm2_configure_pins()` resolves enabled secondary modules against each pin descriptor. A primary-source pin remains GPIO/IOPort; a secondary-source pin is assigned to its owning module and its alternate-source bit is set.
6. `hm2_ioport_gpio_export_hal()` exports some GPIO presence for every physical pin. Full GPIO pins get `out`, `is_output`, `is_opendrain`, `invert_output`; module-owned output pins retain only the applicable electrical-mode controls and receive aliases tied to their module/function names.
7. `hm2_force_write()` pushes default/configuration state to hardware; within IOPort force write, output inversion and open-drain precede alternate-source and DDR, with DDR deliberately last.
8. Initial TRAM read populates `gpio.NNN.in/in_not`; initial TRAM write initializes output Data images.
9. Standard `<board>.read` and `<board>.write` HAL functions are exported. If the LLIO advertises `threadsafe`, `<board>.read_gpio` and `<board>.write_gpio` are also exported.

## Normal input/read path

Typical servo-thread sequence:

`HAL thread` → `<board>.read` → `hm2_read()`

`hm2_read()`:

1. If no split read was already requested, call `hm2_read_request()`.
2. `hm2_read_request()` records the period, aborts on existing `io_error`, starts the aggregate TRAM read and any additional queued reads, then records `read_requested`/timestamp.
3. `hm2_read()` clears `read_requested`, aborts if `io_error` is asserted, calls `hm2_finish_read()`, and returns early on `-EAGAIN` or communication error.
4. Only after successful read completion does it call `hm2_ioport_gpio_process_tram_read()`.
5. For each port bit, `data_read_reg[port]` is converted to `gpio.NNN.in`; its complement goes to `gpio.NNN.in_not`.
6. Remaining HostMot2 modules process their TRAM input state afterward.

Failure consequence: if the read does not complete successfully, GPIO HAL publication for that cycle is skipped. Previously published values can remain visible, so a steady HAL input is not proof of a fresh physical sample.

## Normal full-GPIO output/data path

Typical servo-thread sequence:

HAL signal/parameter writes → `<board>.write` → `hm2_write()`

1. First invocation initializes each pin's runtime direction from `direction_at_start`.
2. `hm2_ioport_gpio_prepare_tram_write()` walks every physical pin.
3. Pins currently owned by active non-IOPort modules are skipped.
4. For full GPIO pins, `gpio.NNN.out` is packed into the corresponding bit of `data_write_reg[]`.
5. Other HostMot2 cyclic modules prepare their own TRAM outputs.
6. `hm2_tram_write()` submits the aggregate cyclic write image, which includes the IOPort Data register.

The owning module, not `gpio.NNN.out`, supplies output data for module-owned pins.

## Direction/open-drain/inversion path

After the cyclic TRAM write, the same `hm2_write()` cycle calls `hm2_ioport_write()`:

1. `hm2_ioport_update()` derives current host IOPort configuration.
2. For full GPIOs, `is_output` selects direction.
3. Output pins set the DDR bit and reflect `is_opendrain` and `invert_output` into their register mirrors.
4. Input pins clear DDR and clear open-drain.
5. `hm2_ioport_write()` compares each mirror against its cached last-written value.
6. Changed open-drain register(s) are written directly through LLIO.
7. Changed output-invert register(s) are written directly through LLIO.
8. Changed DDR register(s) are written last, reducing startup/mode-transition glitches.

Important same-cycle ordering: GPIO Data TRAM submission happens before these changed direction/mode writes. DDR-last is only the ordering *inside* IOPort configuration updates; it is not a blanket guarantee of glitch-free physical transitions.

## Open-drain interpretation

For a full GPIO configured as output:

- `is_opendrain=0`: `out` requests an actively driven push-pull state, subject to inversion.
- `is_opendrain=1`, `out=0`: request drive low.
- `is_opendrain=1`, `out=1`: request high impedance/release, **not an actively driven high**.

When released, external circuitry/pull-up determines the connector voltage. The sampled value can be observed through the input path, but board-level electrical behavior is outside this source-only call flow.

## Module-owned output path and aliases

If an enabled HostMot2 module claims a pin as a secondary output:

- pin source selection is established at configuration/registration time through the alternate-source register;
- the pin does not gain the full GPIO `out` / `is_output` command interface;
- output data comes from the owning module's register path;
- `invert_output` and `is_opendrain` may still be exported and aliased under the module/function HAL namespace while referring to the same physical IOPort configuration bit.

This prevents the false model that every visible `.gpio.NNN.*` object independently drives the pin.

## Force/recovery path

`hm2_force_write()` re-pushes configuration state during initialization and broader HostMot2 recovery. IOPort force write recomputes HAL-derived configuration, writes inversion, open-drain and alternate-source, then writes DDR last. The force path is a host configuration-restoration mechanism; physical-safe-state behavior still depends on firmware, board hardware, external wiring and safety architecture.

## GPIO-only functions

When LLIO is marked thread-safe:

`<board>.read_gpio` → `hm2_read_gpio()` → `hm2_ioport_gpio_read()`

- direct LLIO read of IOPort Data;
- publishes only pins whose current host direction is input.

`<board>.write_gpio` → `hm2_write_gpio()` → `hm2_ioport_gpio_write()`

- first updates/writes IOPort configuration;
- then packs full-GPIO `out` values and directly writes IOPort Data;
- invokes watchdog configuration/recovery write afterward.

These are specialized fast-I/O paths. Standard read/write already carries GPIO with the rest of HostMot2.

## Debugging decision tree

**HAL `out` toggles, connector does not:** check active pin ownership → `is_output` → scheduling of `<board>.write` → `io_error` → board/firmware/electrical layer.

**No `gpio.NNN.out`:** check whether the pin is owned by an enabled module. If so, use that module's logical command path.

**HAL input frozen:** distinguish failed/skipped transport read from stable register state before diagnosing the sensor.

**Open-drain appears high:** determine whether the pin is released and externally pulled up; do not describe that as HostMot2 actively driving high.

**Need physical fault detection from output readback:** do not assume generic `in` on a push-pull output is a guaranteed electrical feedback channel; current HostMot2 documentation explicitly leaves that value undefined.

## Evidence boundary

SOURCE-CONFIRMED: host register mapping, HAL export, ownership, TRAM/direct-write ordering, change detection, stale-publication behavior.

DOC-CONFIRMED: public GPIO semantics, open-drain release behavior, optional read_gpio/write_gpio roles.

COMMUNITY-REPORTED: historical startup-pulse diagnosis that motivated DDR-last ordering; board-specific raw-register testing guidance.

UNKNOWN / promoted: exact FPGA IOPort internals, transient timing, board electrical levels, pull-ups, drive strength and safety behavior.
