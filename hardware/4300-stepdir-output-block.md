# 4300-STEP6 — Differential STEP/DIR output block

Status: **WORKING SCHEMATIC CONTRACT** — component/layout verification still required

## Purpose

Provide robust high-speed pulse/direction commands from the FPGA to external stepper or servo drives without confusing command transport, drive readiness, motion feedback or safety authority.

## Channel contract

- 6 independent axes.
- Per axis: STEP+/STEP-, DIR+/DIR-.
- Base electrical standard: buffered 5-V differential signaling suitable for RS-422-style receivers and common 5-V pulse-input drives.
- Working maximum STEP rate: 10 MHz per axis.
- Single-ended 5-V compatibility: use one polarity of each pair where the drive supports it; leave the complement unconnected.
- 24-V pulse interfaces are external adapters/variants, not base-board capability.

## Working topology

Per logical STEP or DIR signal:

`ECP5/LiteX-CNC signal -> default-inactive authority/level gate -> 5-V differential transmitter -> connector pair`

Six axes require twelve logical transmitters. Working driver implementation is three quad MAX3042B-class 5-V differential transmitter ICs. ISL32174E-class parts operated at 5 V remain candidate alternates pending final BOM/threshold review.

The authority/level gate SHALL accept 3.3-V FPGA logic and force deterministic inactive transmitter data when global FPGA output authority is false. A 74AHCT-family or equivalent explicitly verified 3.3-V-to-5-V logic solution is a candidate, not yet a frozen part.

## Watchdog/startup truth contract

Normal operation:
- output authority true;
- STEP follows stepgen;
- DIR follows direction command.

Watchdog bite / communications stale / explicit output-authority false:
- STEP transmitter data forced static inactive immediately by FPGA-local/hardware authority path;
- no pulse train may continue;
- DIR is preferably forced to deterministic inactive state;
- diagnostic watchdog/freshness fault remains visible;
- communications recovery alone does not restore output authority;
- explicit rearm is required.

FPGA unconfigured/reset:
- external gate bias/polarity must prevent a STEP train regardless of raw FPGA startup pin state.

5-V line-driver disabled or unpowered:
- outputs may be high impedance; this is containment only and is not relied upon as the normal watchdog-safe state.

## Separate authorities

Do not merge these concepts:
1. LinuxCNC trajectory/step request;
2. FPGA stepgen state;
3. command freshness/output authority;
4. electrical STEP/DIR waveform;
5. external drive ENABLE;
6. drive READY/FAULT;
7. encoder/position feedback;
8. physical motion;
9. safety-rated STO/guarding.

A valid STEP waveform proves only that a command waveform was emitted.

## Driver enable/fault relationship

Drive enable is not part of STEP/DIR timing. It belongs to protected machine I/O or a dedicated drive interface. Drive READY/FAULT returns through isolated input authority. Safety-rated STO remains external to this ordinary control block.

The differential transmitter's OE may be used as a secondary containment mechanism, but watchdog pulse suppression SHALL occur by forcing transmitter data static rather than depending only on a floating/tri-stated cable.

## Connector and cable contract

- Twisted pair for each STEP and DIR differential pair.
- Provide deliberate signal-reference/shield/chassis treatment; do not use shield as signal return by accident.
- No source-side 120-ohm terminator by default. Receiving-end termination follows the external drive manual.
- Connector pinout should keep each +/- pair adjacent and avoid interleaving high-current field power.
- TVS/protection selection must preserve the 10-MHz edge-rate requirement.

## Performance budget

Working contract: 10-MHz maximum STEP rate.

Selected transmitter class must provide >=20-Mbps switching capability with adequate differential output for 5-V CNC pulse inputs. PCB release requires timing/skew review across:
- LiteX-CNC stepgen;
- FPGA output;
- authority/level gate;
- differential transmitter;
- connector/cable load.

Do not advertise the 10-MHz rate until prototype signal-integrity and pulse-width tests pass.

## Diagnostics

Firmware/HAL should expose at minimum:
- requested axis enable;
- requested STEP/DIR state where useful;
- global output-authority/watchdog state;
- transport generation/freshness state.

Do not invent a "step output healthy" feedback unless hardware actually observes the field-side waveform. The present transmitter is command-only.

## Evidence basis

- Mesa 7I76/7I96S production pattern: 5-V differential STEP/DIR, single-ended use of one polarity supported, 10-MHz-class Ethernet step generation.
- Mesa startup guidance: external circuitry must make FPGA configuration/startup state safe.
- LinuxCNC community guidance from Mesa designer Peter Wallace distinguishes ordinary ~3-V RS-422 driver swing from stronger 5-V signaling needed by some optocoupled drive inputs.
- Analog Devices MAX3042B: production 5-V quad differential transmitter, up to 20 Mbps, hot-swap behavior, protected outputs.
- Renesas ISL32174E: production 3-to-5.5-V quad RS-422 transmitter, 32 Mbps, candidate alternate.

Detailed trace: `research/4000-stepdir-output-reference-and-driver-selection-2026-09-15.md`.

## Open before schematic freeze

1. Freeze exact MAX3042B/alternate ordering code and availability.
2. Select exact default-inactive 3.3-V-to-5-V authority gate/translator.
3. Draw and review startup/watchdog/rearm truth table including FPGA unconfigured state.
4. Select connector and low-capacitance protection.
5. Calculate simultaneous-switching/thermal/5-V rail load.
6. Verify external drive classes targeted by the board against representative manuals.
7. Prototype-measure 10-MHz pulse width, skew, overshoot and cable behavior.

## Safety boundary

This block is ordinary machine-control command hardware. Watchdog pulse suppression is fault containment. It is not safety-rated STO, guard monitoring or personnel protection.
