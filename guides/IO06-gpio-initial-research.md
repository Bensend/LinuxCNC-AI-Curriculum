# IO06 — HostMot2 GPIO initial research

Course level: 1000  
Status: RESEARCH  
Pinned LinuxCNC revision baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Documentation model

Current HostMot2 documentation establishes that board pins not claimed by enabled module instances become full GPIOs. Full GPIOs can switch at runtime among input, normal output, and open-drain operation. Pins owned by active module instances retain a restricted GPIO-facing interface.

Key HAL objects:

- `gpio.NNN.in` / `in_not`: logical hardware input state;
- `gpio.NNN.out`: requested output value for full GPIO pins;
- `gpio.NNN.is_output`: selects input versus output for full GPIO;
- `gpio.NNN.is_opendrain`: selects push-pull versus open-drain behavior when output;
- `gpio.NNN.invert_output`: inverts output sense.

The docs explicitly distinguish open-drain logical `1` from actively driving high: in open-drain mode, requested 1 means high-impedance while requested 0 drives low. This distinction will be central to IO06's source and safety/failure trace.

## Architecture questions opened

1. Which pinned `ioport.c` functions export GPIO HAL state and map module-owned pins to restricted aliases?
2. In what order are input state, output data, direction, alternate-source, open-drain, and inversion registers prepared/written?
3. Which registers participate in TRAM and which use change-detected/direct writes?
4. How do active module pins constrain `is_output`/alternate-source ownership?
5. What happens to HAL-visible input state for push-pull outputs versus open-drain high-impedance outputs?
6. How are watchdog/reset states related to IOPort register restoration, and what physical pin state remains board/firmware-specific?
7. Can stock `hm2_test` exercise logical GPIO read state, and what write-capture extension would be needed to verify output/direction register synthesis?

## Evidence boundary

The 1000-level IO06 objective is host register/HAL path mastery, not board electrical qualification. `is_output`, `is_opendrain`, and `out` describe host/FPGA requested state; actual voltage levels, pull-up strength, output drive capacity, fail-safe external wiring, and safety certification require board-specific hardware evidence.

## Exact next checkpoint

Trace pinned `src/hal/drivers/mesa-hostmot2/ioport.c`: `hm2_ioport_gpio_export_hal()`, `hm2_ioport_gpio_process_tram_read()`, `hm2_ioport_gpio_prepare_tram_write()`, force/change-detected register writers, GPIO/module alias creation, and watchdog/reset restoration. Build a complete HAL GPIO input/output -> IOPort register -> TRAM/LLIO call flow before deciding the smallest meaningful fake-LLIO experiment.
