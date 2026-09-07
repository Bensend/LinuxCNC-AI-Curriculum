# IO06 — GPIO input/output path — fresh-AI graduation handoff

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Status: GRADUATED

## What a fresh AI must know

HostMot2 GPIO is implemented by the IOPort module. The IOPort Data register is in both read and write TRAM; direction (DDR), alternate source, open-drain, and output-invert are configuration registers. Full GPIO output data is packed before the generic HostMot2 TRAM write, while direction/open-drain/inversion changes are written afterward through change-detected LLIO writes. DDR is deliberately written last among IOPort configuration writes.

Every physical pin gets `gpio.NNN.in` and `in_not`. Full GPIOs additionally get `out`, `is_output`, `is_opendrain`, and `invert_output`. Active-module output pins may expose aliases for the physical pin's open-drain/inversion parameters, but their logical output data comes from the owning module, not from `gpio.NNN.out`.

Open-drain `out=1` means release/high impedance, not active high drive. A generic read publishes the IOPort Data bit for every pin, but current documentation says normal push-pull output readback through `in/in_not` is undefined. A failed or temporary read can also leave previously published GPIO HAL values unchanged, so unchanged HAL state is not automatically fresh physical feedback.

The optional `read_gpio`/`write_gpio` functions exist only for LLIO drivers that advertise thread safety and are specialized fast-I/O helpers. Normal HostMot2 read/write already transports GPIO.

## Source navigation

- `src/hal/drivers/mesa-hostmot2/ioport.c`: register layout, HAL export, TRAM packing, direct config writes.
- `src/hal/drivers/mesa-hostmot2/hostmot2.c`: generic read/write ordering, force-write path, exported functions.
- `src/hal/drivers/mesa-hostmot2/pins.c`: primary GPIO versus secondary module pin ownership / alternate-source setup.
- `src/hal/drivers/mesa-hostmot2/hm2_test.c`: static fake LLIO, useful to understand why a runtime GPIO experiment needs fixture extension.

## Failure-oriented debugging rules

1. If a GPIO output command is visible in HAL but the connector does not change, first verify pin ownership, `is_output`, HostMot2 write scheduling, and `io_error`; only then move to firmware/electrical diagnosis.
2. If a physical pin is owned by another HostMot2 module, do not invent a GPIO output command path that source explicitly skips.
3. If an input appears frozen, establish that fresh reads are completing before blaming the sensor or FPGA.
4. Do not interpret open-drain release as a driven-high state.
5. Do not use push-pull `gpio.in` as guaranteed electrical feedback without board/firmware evidence.

## Experiment boundary

Pinned stock `hm2_test` reads from an unchanging compiled-in image and discards writes. A valid production-path GPIO experiment therefore requires a mutable IOPort fake board plus write capture. That is promoted to 2000/HIGH. Such a fixture could validate host packing/change detection/order but still could not establish FPGA timing, connector voltage, pull-up strength, transient behavior, drive current or functional safety.

## Graduation decision

The 1000-level objective is satisfied: a fresh AI can locate the implementation, explain pin ownership and HAL export, trace input and output paths through TRAM/config writes, understand stale-read and open-drain traps, and propose a bounded host-only fixture extension without claiming physical evidence. Remaining uncertainty is explicitly promoted and does not invalidate these host-side conclusions.

## Promotion queue

- Mutable IOPort fake-LLIO with write capture: 2000 / HIGH.
- Exact FPGA IOPort/readback implementation: HM04/2000 / HIGH.
- Same-cycle data/direction transition and connector transient measurement: 2000 + hardware / HIGH.
- Board-specific voltage, pull-up, drive-current, isolation and fail-state qualification: commissioning/safety / CRITICAL.
