# 4000 Colorlight LinuxCNC firmware/watchdog first pass — 2026-09-15

Status: **SOURCE PASS — architecture decision not yet frozen**

Pinned implementation: `faeboli/Lcnc` revision `f6c0d75a3ddb4fb592a41a1b564773deaeca4d5c`.

## Why this implementation matters

This is an inspectable LinuxCNC-oriented FPGA implementation explicitly focused on Colorlight 5A-75B/5A-75E. It provides a useful counterexample to assuming that a Colorlight CNC board must use upstream HostMot2. The design consists of FPGA firmware, a LinuxCNC driver and configuration-generation tooling; host communication is Gigabit Ethernet via Etherbone.

## Exposed realtime resources

The pinned documentation describes configurable:

- digital inputs and outputs;
- encoder inputs;
- PWM generators;
- step generators;
- watchdog and board enable state.

The host driver discovers the FPGA's configuration structure at startup and creates corresponding LinuxCNC pins/parameters. This supports a reusable/parameterized board philosophy, but it is a custom driver/firmware contract rather than HostMot2 compatibility.

## Watchdog / enable transaction

The implementation exposes a notably useful authority chain:

- `Lcnc.00.enable` — global software permission for the board to become enabled;
- `Lcnc.00.enable-request` — rising-edge request to enter enabled state;
- `Lcnc.00.enabled` — feedback confirmation that the board is enabled;
- `Lcnc.00.watchdog-write` — configured watchdog time;
- `Lcnc.00.watchdog-read` — remaining watchdog time observed from the board;
- external hardware reset input.

The documented behavior says the board disables if global enable is false, if the onboard watchdog expires, or if hardware reset is asserted. Enable request is edge-sensitive rather than a permanently held request.

This is directly aligned with the 3000-derived hardware rule that request, freshness, physical/electrical enable state and rearm should not be collapsed into one boolean.

## Timing evidence

The project's example reports roughly 200 microseconds component update time on the author's system and a default 10 ms watchdog. Treat these as implementation/host observations, **not universal design requirements**. A new board must derive watchdog margin from its actual LinuxCNC servo period, network behavior, firmware update path and desired fault-containment latency.

## Stepgen architecture difference

The pinned Lcnc stepgen is velocity-commanded and reports internally generated position/velocity feedback. LinuxCNC position command is converted to requested velocity through a HAL PID in the documented example. This differs materially from assuming a Mesa/HostMot2 stepgen command model. The hardware may be reusable while the firmware contract is not interchangeable.

## 4000 design implications

1. A watchdog should be treated as a first-class FPGA resource with observable state, not merely a host timeout.
2. Board enable should use an explicit request/ack/rearm contract where practical.
3. External hardware reset/inhibit is valuable and should remain independent of normal numeric command registers.
4. Parameterized FPGA peripheral counts are proven practical on Colorlight-class hardware.
5. Firmware architecture must be frozen before pin/register/HAL contracts are treated as stable.
6. A watchdog expiry must ultimately gate machine-facing outputs in hardware/FPGA logic; merely reporting timeout to LinuxCNC would be insufficient.

## Architecture comparison queue

Before selecting the 4000 core firmware contract, compare:

- upstream HostMot2 + `hm2_eth` semantics and existing Mesa ecosystem;
- this Lcnc/ColorCNC-style Etherbone custom-driver architecture;
- LiteX-CNC's current architecture and module/watchdog model.

Score them on LinuxCNC-native integration, deterministic watchdog/output-disable behavior, Ethernet latency/freshness semantics, open ECP5 toolchain support, implementation complexity, extensibility for custom proportional-valve/current-control modules, maintainability and ability for a fresh AI/EDA workflow to reproduce the design.

No lab is justified yet; the next gain is source comparison, not simulation.
