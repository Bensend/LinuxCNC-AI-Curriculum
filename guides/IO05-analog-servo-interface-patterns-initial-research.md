# IO05 — analog-servo interface patterns, initial research

Course level: 1000  
Status: RESEARCH  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this module is not just "more PWMGen"

LinuxCNC/Mesa systems can present an analog-looking servo or spindle command through materially different host/firmware/electrical paths. A fresh AI must not assume that every `±10 V` command originates in the generic HostMot2 PWMGen module.

The first useful taxonomy is:

1. **generic HostMot2 PWM/PDM + board/interface conversion** — HAL command enters `hm2_pwmgen.*`, then the IO04 cyclic PWM value / slow configuration paths reach HostMot2 PWM registers. A specific daughtercard or integrated board converts the digital waveform/control signals into an analog voltage or drive command. Centered interfaces may require `offset-mode=1`, making zero command correspond to 50% PWM duty.
2. **Smart Serial remote analog outputs** — the HAL object is dynamically exported from the smart-serial remote's descriptors. The 7I77 is the canonical servo example: its analog outputs are smart-serial devices even though its encoder inputs use conventional HostMot2 encoders. HAL exposes `analogoutN`, `analogena`, and board/remote-derived scaling and min/max parameters.
3. **Smart Serial spindle/VFD analog outputs** — e.g. 7I76 `spinout`, with `spinena`, `spindir`, `spinout-scalemax`, and min/max command parameters. The public interface describes requested engineering units and output limiting, not raw PWM duty.

These categories can coexist on the same Mesa ecosystem and can share LinuxCNC motion/PID command sources while diverging below HAL.

## Documentation-confirmed 7I77 boundary

Pinned/current `sserial(9)` documentation explicitly states that the 7I77 is a six-axis servo control card whose **analog outputs are smart-serial devices**, whereas its encoders are conventional HostMot2 encoders.

It exposes:

- `.7i77.0.1.analogena` — drives the board's analog-enable terminals;
- `.7i77.0.1.analogoutN` for N=0..5 — analog command inputs;
- `analogoutN-scalemax` — engineering-unit command corresponding to full-scale output;
- `analogoutN-maxlim` / `-minlim` — requested-command limits.

This is a different abstraction from generic `pwmgen.N.value/scale/output-type/offset-mode`.

## Pinned source boundary: descriptor-driven Smart Serial HAL

Pinned `src/hal/drivers/mesa-hostmot2/sserial.c` does not hard-code one generic analog servo formula under a `7i77` branch. It parses remote configuration metadata and exports HAL objects according to each field's data type and direction.

For signed/unsigned numeric remote fields it:

- exports a HAL real pin named from the remote/channel descriptor;
- exports `*-scalemax`, initialized from the remote descriptor's `ParmMax`;
- for command/output-direction fields, also exports `*-maxlim` and `*-minlim`, initialized from descriptor `ParmMax` / `ParmMin`.

The remote's communication/status and read/write registers are registered into HostMot2 TRAM by `hm2_sserial_register_tram()`. Thus the initial command boundary is:

`HAL remote analog pin -> sserial host data packing/scaling -> smart-serial TRAM/registers -> HostMot2 Smart Serial engine -> remote firmware/electronics -> physical analog output`.

The exact packing/scaling function after HAL publication still needs source tracing; that is the next IO05 lesson rather than something inferred from names.

## Comparison with IO04 generic PWM path

| Layer | Generic PWM/PDM interface | 7I77 Smart Serial analog |
|---|---|---|
| HAL command | `pwmgen.N.value` | `.7i77...analogoutN` |
| Host scaling | `value / scale`, clipped to ±1 in `pwmgen.c` | remote-field `scalemax` plus min/max semantics, exact pack path still to trace |
| Enable | `pwmgen.N.enable` plus HostMot2 PWM enable register | remote `analogena` field/terminal behavior |
| Command transport | PWM value TRAM register + slow mode/rate/enable writes | smart-serial remote data via sserial TRAM/engine |
| Analog conversion | board/daughtercard/interface specific | 7I77 remote firmware/electronics specific |
| Encoder path | unrelated to analog command unless machine config connects it | 7I77 encoders are conventional HostMot2 encoder modules, not smart serial |

## Community finding carried forward

Mesa developer PCW's field corrections for centered analog-output hardware show why this taxonomy matters: on a PWM-derived centered interface, `offset-mode=1` can be required so 50% duty represents zero analog voltage. That behavior belongs to the generic PWM/interface pattern; it must not be projected onto the 7I77's smart-serial numeric command representation merely because both ultimately control `±10 V` servo drives.

## Safety and commissioning boundary

None of these host abstractions establishes a safety-rated torque-off path.

`analogena`, `pwmgen.enable`, drive-enable wiring, smart-serial watchdogs, HostMot2 watchdogs, amplifier fault inputs and external safety relays may all participate in a machine design, but their names do not establish certified safety behavior. Physical voltage range, polarity, disabled output state, fault reaction and safe torque removal require the exact board/drive manuals and representative commissioning/safety analysis.

## Questions now opened for source tracing

1. Which pinned Smart Serial functions transform a HAL signed/unsigned numeric output field into the outbound packed register value?
2. Where are `scalemax`, `minlim`, and `maxlim` applied, and what happens for zero/invalid scaling?
3. How does remote `analogena` share a packed write cycle with analog commands, and are there ordering/staleness implications?
4. What source path reports Smart Serial communication/watchdog faults back to HAL?
5. Which behavior is defined by the generic HostMot2 Smart Serial engine versus remote EEPROM/descriptor metadata versus 7I77 firmware/electronics?
6. Can a fake remote/fixture exercise the production packing/scaling path without claiming physical voltage evidence?

## Exact next checkpoint

Trace pinned `sserial.c` output packing from exported `LBP_SIGNED` / `LBP_UNSIGNED` HAL input fields through scale/limit handling into `chan->write[]` and the generic `hm2_sserial_prepare_tram_write()` / state-machine path. Use the 7I77 analog command as the representative interface but keep the implementation descriptor-driven. Document a complete `HAL analogout -> packed smart-serial command -> TRAM -> LLIO` call flow, then inspect existing smart-serial tests/fake remote facilities for a no-hardware experiment. Do not yet assert physical ±10 V behavior beyond applicable public board documentation.