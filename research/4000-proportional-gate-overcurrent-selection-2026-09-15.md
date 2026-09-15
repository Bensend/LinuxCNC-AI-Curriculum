# 4000 proportional-current gate driver / hard overcurrent pass — 2026-09-15

## Gate driver
Working candidate: TI UCC27511A-class single-channel low-side gate driver.

Relevant properties for this block:
- 4.5–18 V gate-driver supply;
- strong source/sink drive with split outputs for independent turn-on/turn-off resistance;
- ~13 ns typical propagation delay;
- output held LOW during VDD undervoltage lockout;
- output held LOW for floating input;
- dual input arrangement permits one input to serve as enable/disable.

This is materially better than driving the selected 80-V MOSFET directly from the FPGA. Use a dedicated ~10–12-V gate-driver rail if the final MOSFET requires a 10-V RDS(on) condition; do not call an 80-V MOSFET 'logic level' based only on threshold voltage.

## Authority gating
Hardware logic should make gate ON require all of:
`FPGA PWM AND FPGA channel-authority AND gate-driver supply valid AND NOT hard-overcurrent-latch`

Loss of FPGA power, watchdog authority or gate-driver UVLO must resolve to gate LOW. The overcurrent latch should require an explicit clear/rearm and should not disappear merely because current falls after PWM is removed.

## Hard overcurrent sensing
The ordinary current loop uses INA240 + ADC. For catastrophic overcurrent, use a separate comparator path so protection does not wait for ADC conversion, SPI transport or FPGA control code.

TLV3201-class comparator is a plausible first candidate: 2.7–5.5 V supply, rail-to-rail input, push-pull output and about 40 ns propagation. It is not yet a final threshold-accuracy freeze; its offset/hysteresis must be included in threshold error.

Preferred topology is to compare a dedicated fast current-sense signal against a fixed/reference-derived ceiling, then set an SR latch whose Q directly inhibits the gate driver and is also reported to FPGA. Do not route the hard cutoff only through FPGA firmware.

## Sense-path caution
INA240 is optimized for accurate PWM current measurement, but the hard-overcurrent path must be checked for worst-case overload response/recovery. If its dynamic response is not fast enough for short-circuit protection, add a separate low-side fast shunt/comparator or select a protected smart gate/power stage. This remains an explicit schematic review item rather than assuming the precision sense amplifier is also the ideal short-circuit detector.

## Working threshold philosophy
Normal first-variant command ceiling: 1.5 A pending coil data.
Hard trip should be above all legitimate command/ripple/tolerance but low enough to protect MOSFET, shunt, connector and coil wiring. Do not freeze an ampere threshold until final shunt/comparator path and fault-current dynamics are bounded.

## Sources
- TI UCC27511A product/datasheet: 4.5–18 V supply, split output, ~13 ns propagation, UVLO/floating-input output LOW behavior.
- TI TLV3201 product/datasheet: 2.7–5.5 V, push-pull, rail-to-rail input, ~40 ns comparator.
