# 4000 reusable controller block map — first pass

Status: FOUNDATION DRAFT. This map translates LinuxCNC/HostMot2 interfaces plus 3000 machine-specific authority lessons into reusable hardware blocks. It is not yet a schematic BOM.

## Design rule

Prefer a proven open-source circuit as the baseline when one exists, preserving topology first and modifying only for a documented requirement. Colorlight-family LinuxCNC/FPGA hardware is a priority source for applicable digital/FPGA/Ethernet circuits. A machine-specific block without a suitable proven equivalent is independently engineered from component datasheets/reference designs and standard engineering principles.

| Block | LinuxCNC / HostMot2 surface | Physical authority | Important witness / feedback | Required failure posture | Baseline path |
|---|---|---|---|---|---|
| Core FPGA + configuration | HostMot2 modules, watchdog, GPIO/encoder/stepgen/PWM register authority | realtime I/O generation and sampling | FPGA config-good, clocks, watchdog state, rail supervisors | machine-facing commands inhibited until configured/healthy; watchdog expiry drives defined safe normal-control state | COPY/ADAPT proven LinuxCNC FPGA topology where possible |
| Ethernet | `hm2_eth` transport | host-to-FPGA command/feedback transport | link/PHY state plus HostMot2 protocol/watchdog freshness; link alone is not command freshness | loss must not leave indefinite uncontrolled command authority; HostMot2 watchdog contract preserved | COPY/ADAPT proven LinuxCNC Ethernet FPGA interface |
| USB-C service/programming | configuration/debug/service, optional non-realtime control | service/programming access | attach/config state | must not silently bypass realtime/safety authority | ADAPT proven USB/programming topology; role to be frozen |
| Power entry / rails / supervision | supports all hardware, not a HAL substitute | board energy and reset sequencing | power-good, UV/OV/thermal where justified | deterministic reset/inhibit during brownout and invalid rails | COPY/ADAPT reference power topology after load budget |
| Digital inputs | HostMot2 GPIO | sense switches, faults, readiness, pressure/contact/etc. | raw state plus optional diagnostics | defined state under open wire/power loss where interface permits; do not claim semantic validity from voltage alone | COPY/ADAPT proven isolated/industrial input topology |
| Protected digital outputs | HostMot2 GPIO | valves, relays, contactors, lamps, enables | output-driver fault/current witness where useful; external physical proof remains separate | defined OFF/inhibit on reset/watchdog unless a documented process requires another normal-control state | COPY/ADAPT proven protected output topology |
| Encoder inputs | HostMot2 encoder | position/velocity feedback acquisition | differential signal integrity, index where used; freshness/count plausibility in FPGA/software | loss/invalid feedback detectable; never substitute last plausible value as fresh proof | COPY/ADAPT proven RS-422 encoder receiver topology |
| Step/dir outputs | HostMot2 stepgen | motion-drive command | drive ready/fault external to step pulses | pulses disabled deterministically on reset/watchdog/disable | COPY/ADAPT proven FPGA step/dir output topology |
| PWM/PDM / analog-command output | HostMot2 PWM/PDM | speed/torque/valve command via PWM or converted analog | command-path enable plus optional analog/current readback | neutral/inhibited defined state on reset/watchdog | COPY/ADAPT known LinuxCNC analog/PWM interfaces; validate converter accuracy/bandwidth |
| Proportional-solenoid current driver | PWM/current-loop command | hydraulic proportional valve coil current | actual coil current, driver fault, supply/thermal status as justified | current forced to defined neutral/zero on inhibit/watchdog/fault; inductive energy safely handled | INDEPENDENT ENGINEERING unless a genuinely equivalent open reference is found |
| Drive enable/fault interface | `amp-enable`, drive fault/status HAL | permit external servo/VFD/stepper drive operation | independent ready/fault/STO status as available | enable removed on normal-control fault/watchdog; safety-rated STO remains external unless separately engineered/certified | ADAPT isolated I/O topology; preserve safety boundary |
| Watchdog / failsafe gating | HostMot2 watchdog + local hardware gates | removes normal command authority when realtime control is stale | watchdog state/reset reason | deterministic inhibit independent of stale numeric command | COPY/ADAPT HostMot2-proven watchdog/gating behavior plus hardware gating where justified |
| Expansion / service diagnostics | HAL GPIO/SPI/I2C/UART as deliberately exposed | optional expansion, commissioning and test | connector presence/ID where needed | expansion failure must not corrupt core command authority | independently contract each expansion interface |

## Cross-block requirements inherited from 3000

1. Do not collapse request and physical completion into one signal.
2. Keep value, validity and freshness separate where stale data can remain plausible.
3. Every output block must state behavior for FPGA reset, host loss, watchdog expiry and brownout.
4. Physical/process witnesses should enter through independent channels where practical; software may compose readiness but hardware should not erase diagnostic distinctions.
5. Ownership changes between modes/controllers need explicit neutralization and rearm semantics.
6. Process cleanup is not implied by motion abort. Hardware outputs need explicit inhibit/reset behavior and software-visible state.
7. Safety-chain interfaces are boundaries to an independent safety architecture unless a later block is explicitly designed and evidenced as safety-rated.

## Immediate source/schematic survey order

1. Core FPGA + Ethernet + configuration/service path.
2. Power/reset/watchdog architecture because it constrains every block's failure state.
3. Encoder + digital input/output + step/dir circuits with proven LinuxCNC/Colorlight examples.
4. PWM/analog output.
5. Proportional-solenoid current driver as the first independently engineered machine-specific block.

## Questions to resolve before schematic freeze

- Which proven Colorlight board/revision is the canonical baseline for FPGA, PHY, oscillator/configuration, power and I/O voltage domains?
- Which FPGA family/package and I/O bank voltages are retained?
- Is USB-C service-only, configuration/programming, or also a supported LinuxCNC control transport? These roles must not be conflated.
- Required board input supply and machine-field voltage domains.
- Isolation policy by interface class rather than blanket isolation.
- Required encoder electrical standards and maximum rates.
- Digital I/O channel count and field-voltage envelope.
- Analog command range(s), resolution and bandwidth.
- Proportional-valve nominal first target and parameterized current/voltage envelope.
- Exact hardware relationship between HostMot2 watchdog, FPGA output enable and external drive/valve enables.
