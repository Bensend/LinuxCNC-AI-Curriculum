# IO05 graduation handoff — analog-servo interface patterns

Course level: 1000  
Status: GRADUATED  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## What a fresh AI must retain

Do not model all Mesa analog servo outputs as generic PWMGen.

Two important patterns are now distinguished:

1. HostMot2 PWM/PDM command generation followed by board/interface-specific analog conversion. IO04 owns the host PWM register path; centered interfaces may require offset-mode semantics.
2. Descriptor-driven Smart Serial numeric outputs such as the 7I77 servo analog channels. Here the HAL fields are created from remote descriptors and are packed into Smart Serial process data by `sserial.c`.

## Representative 7I77 host path

`HAL analogoutN -> hm2_sserial_prepare_tram_write() -> hm2_sserial_write_pins() -> clamp min/max -> normalize by scalemax -> encode signed/unsigned DataLength -> setbits() into chan->write[] -> command_reg_write Do-It -> HostMot2 TRAM -> LLIO`

Writable boolean descriptor fields, including an analog-enable-like field, are packed by the same descriptor-order process-data walk. Exact remote field offsets/order are descriptor data, not universal constants.

## Critical fault/debugging model

A current HAL command is not proof of a fresh remote command.

Before packing, Smart Serial checks whether the previous Do-It cleared and tracks transfer errors with a fault accumulator. Persistent faults can stop the port in state 10; the run pin must be cycled low to leave that serious-error state. Generic HostMot2 `io_error`, HostMot2 watchdog state, Smart Serial remote watchdog behavior, and amplifier/safety faults are separate mechanisms.

Use this diagnostic layering:

1. requested HAL command/scale/limits;
2. Smart Serial port state and fault counters;
3. HostMot2 transport state;
4. FPGA Smart Serial engine and remote communication;
5. board analog electronics/enable terminals;
6. wiring, amplifier enable/fault/STO, and physical machine.

## Safety boundary

`analogena=true` is not a safety conclusion. It is a requested HAL field. This module does not establish certified safe torque removal, safe output voltage, fault reaction time, or the electrical state of a representative drive.

## Experiment sufficiency

Stock pinned `hm2_test` uses static reads and discards writes, and no upstream Smart Serial-specific no-hardware fixture was found. A meaningful production-path packing test would require a mutable fake remote with descriptor discovery, command/status transitions, and write capture. That experiment is promoted to 2000/HIGH rather than replaced with a stand-alone simulation that would not test the production driver.

## Adversarial corrections incorporated

- 7I77 Smart Serial analog output is not generic PWMGen and does not inherit PWM `offset-mode` semantics.
- `analogena`, numeric command, remote transfer, physical voltage, drive enable, and functional safety are distinct states.
- a non-cleared previous Do-It can suppress a fresh command while HAL continues to display the requested value;
- pathological zero/NaN/Inf scale behavior is not a supported design assumption; use finite nonzero `scalemax`.

## Promotion queue

- mutable production-path fake Smart Serial remote: 2000/HIGH;
- exact descriptor/firmware version comparison for 7I77 field layouts: 2000/MEDIUM;
- pathological scaling/cast behavior: 2000/HIGH;
- Smart Serial remote watchdog interaction with HostMot2 and machine fault handling: S02/S03/2000 HIGH;
- physical analog transfer, disabled state, polarity, tolerance and reaction time: commissioning/CRITICAL;
- safety-rated drive-enable/STO architecture: advanced safety/CRITICAL.

## Graduation sufficiency

The 1000-level objective is satisfied: a fresh AI can distinguish the two major analog-command architectures, locate the production 7I77-style Smart Serial packing path, trace numeric/boolean fields into TRAM/LLIO, reason about important communication failure gates, avoid false physical/safety claims, and identify the advanced experiment required for stronger runtime evidence.

## Next unblocked module

IO06 — GPIO input/output path. Trace HostMot2 IOPort/GPIO HAL objects through read/write TRAM preparation and pin-source/direction behavior, then distinguish logical GPIO state from physical pin electrical behavior and watchdog/fault semantics.
