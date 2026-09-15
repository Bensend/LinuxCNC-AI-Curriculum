# 4300 Encoder Input Block

Revision: 0.1 WORKING SCHEMATIC CONTRACT

## Identity
- Block ID/name: 4300-ENC4 — four-channel differential quadrature encoder input
- Primary interface: FPGA encoder counters -> LiteX-CNC/LinuxCNC HAL
- Physical authority: observes machine position/velocity/index; commands no actuator
- Reference topology: industrial RS-422 A/B/Z receiver practice; current open CNC reference includes Expatria FlexiHAL 2350 differential encoder ports
- Method: MIXED — proven differential topology + project-specific channel/diagnostic contract

## Functional contract
Each of four channels accepts:
- A+ / A-
- B+ / B-
- Z+ / Z-
- encoder signal common/reference

Each produces 3.3-V FPGA logic A/B/Z.

FPGA/driver layer shall expose at minimum position/count, velocity, index/index-enable semantics, illegal-transition diagnostic count, and feedback generation/VALID/FRESH state.

This block does **not** prove cable presence, encoder mechanical coupling, correct scale, correct direction, plausible machine motion, independent position agreement, or safety-rated feedback integrity.

## Electrical envelope
- Receiver rail: 3.3 V
- Working receiver: TI AM26LV32E, three quad packages for 12 differential inputs
- Receiver common-mode capability: use datasheet +/-7 V envelope; system connector/protection design must not reduce it accidentally
- Board-supported transition-rate contract: 10 MHz per input, subject to final PCB/FPGA integration verification
- Termination: independently configurable/DNP 120 ohm across every differential pair
- Protection: low-capacitance RS-422-suitable TVS/ESD at connector boundary; exact part TBD after capacitance/working-voltage review
- Isolation: none in base block; isolated variant/adapter only when machine requirement justifies it
- Base connector mode: differential only
- Shield: separate chassis/functional-earth strategy; do not use shield as signal common

## Validity/freshness
Electrical receiver output is not equivalent to valid feedback. AM26LV32E open-circuit fail-safe intentionally produces a defined state, so cable disconnect may look like static logic.

Required semantic layers:
`receiver logic -> legal quadrature -> count/index state -> plausibility/activity diagnostics -> FPGA generation -> transport VALID/FRESH`

A failed/stale host read must not relabel the prior count as current-cycle valid.

## Reset/loss behavior
Because this is an input-only block, reset/watchdog does not need to force an external electrical state. On FPGA reset or transport loss, the host-side feedback validity/generation must make stale data distinguishable from a fresh sample. Encoder counters may restart from implementation-defined local state only if the reinitialization is explicitly surfaced so LinuxCNC cannot silently treat a discontinuity as continuous position.

## Diagnostics
Required:
- raw A/B/Z state or debug access;
- illegal quadrature transition counter;
- index seen/latch diagnostic;
- channel count/velocity;
- FPGA feedback generation/age;
- transport read VALID/FRESH.

Optional later diagnostics may include no-motion timeout under commanded motion and redundant-feedback disagreement, but those are machine/application layers rather than proofs provided by the receiver.

## Parameterization
Without topology change:
- encoder scale;
- count mode/firmware filtering where justified;
- index semantics;
- termination populated/DNP per pair.

Requires external adapter/topology change:
- single-ended TTL/open-collector encoder;
- galvanic isolation;
- analog sin/cos encoder;
- SSI/BiSS/EnDat/absolute serial encoder.

## Safety boundary
Normal-control feedback only. Differential signaling, ESD protection, illegal-transition diagnostics and transport freshness improve robustness/fault containment but are not a safety-rated position channel.

## Verification plan
- REFERENCE/DATASHEET: RS-422 receiver topology and AM26LV32E electrical limits.
- CALCULATION: termination/loading and protection capacitance after exact connector/TVS selection.
- INTEGRATION: 10-MHz A/B/Z pattern test through final receiver + FPGA + LiteX-CNC transport.
- INTEGRATION: index-enable/latch behavior.
- FAULT TEST: A/B/Z disconnect, one conductor open, swapped pair, illegal transition injection, transport read failure/stale generation.
- BENCH/EMC: ESD/transient behavior on final PCB.

## Evidence/open items
See `research/4000-encoder-electrical-reference-and-receiver-selection-2026-09-15.md`.

Before PCB freeze:
1. select exact connector and low-capacitance TVS;
2. verify AM26LV32E availability/package choice;
3. define shield-to-chassis implementation;
4. run FPGA timing and final-board 10-MHz integration test;
5. confirm LiteX-CNC encoder module exposes/accepts the required index and freshness semantics or extend it.
