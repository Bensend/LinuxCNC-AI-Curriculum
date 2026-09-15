# 4000 proportional driver — gate/fault net contract

Date: 2026-09-15
Status: WORKING FREEZE; clamp voltage remains measurement-bound.

## Purpose
Close the deterministic-OFF and independent-overcurrent portions of the light-duty proportional-solenoid driver without pretending coil inductance or machine-rail transient limits are known.

## Gate driver selection
Working part class: TI UCC27511A.

Evidence-backed properties relevant to this block:
- 4.5–18 V supply range;
- split source/sink outputs permit separate turn-on/turn-off gate resistors;
- output is held LOW during VDD UVLO;
- output is held LOW when input pins float;
- dual inputs allow one input to carry PWM and the other to be used as a hard enable/inhibit.

This is a containment property, not a safety-rated function.

## Deterministic authority topology
Per channel use the driver's non-inverting input for `PWM_ALLOWED` and its inverting input as an active-high hardware inhibit. The logical contract is:

`PWM_ALLOWED = FPGA_PWM AND FPGA_CHANNEL_AUTHORITY`

`GATE_INHIBIT = OC_LATCH OR POWER_NOT_GOOD OR LOCAL_DISABLE`

The gate driver must be wired so `GATE_INHIBIT=1` forces output LOW independent of FPGA PWM. FPGA reset/watchdog separately removes `FPGA_CHANNEL_AUTHORITY`; therefore either the FPGA authority path or independent hardware trip can remove gate drive.

Do not implement the comparator trip merely as an FPGA input.

## Independent overcurrent path
Use a fast comparator in the TLV3201-class or equivalent, referenced from the same analog current-sense signal by a dedicated threshold divider/reference. Comparator output SETs a hardware latch. The latch output drives `GATE_INHIBIT` directly and is also reported to FPGA diagnostics.

Working threshold policy:
- software/FPGA current limit: <= 1.5 A first-variant ceiling;
- hardware catastrophic trip: intentionally above the normal regulation ceiling but below the MOSFET/shunt/connector destructive envelope;
- exact trip current remains a schematic value to freeze with sense-chain tolerance and transient/noise analysis.

The hardware trip is latched. Restoring Ethernet, clearing the FPGA watchdog, or lowering the current request must not automatically clear it. Explicit rearm is required after command is zero and the fault input is no longer asserted.

## Startup/rearm sequence
1. Power-up: FPGA authority false; gate driver UVLO/floating-input behavior holds output LOW.
2. FPGA config complete and watchdog healthy: channel remains disabled.
3. ADC/current sense becomes VALID/FRESH; measured current must be within zero-current plausibility band.
4. Hardware OC latch must be clear.
5. Host explicitly requests rearm with zero current command.
6. FPGA clears loop/integrator state, advances command generation, then grants channel authority.
7. Nonzero current command may then be accepted.

Any watchdog expiry, stale ADC feedback, FPGA reset, local power-not-good, or hardware overcurrent removes gate authority. No stale nonzero request may replay automatically.

## Clamp boundary retained
Do not choose a final TVS voltage from nominal 24 V alone. Final clamp requires:
- measured coil L/current decay requirement;
- bounded maximum steady machine rail;
- surge/load-dump strategy at board power entry;
- wiring overshoot allowance;
- derated MOSFET VDS ceiling;
- repetitive 0.5*L*I^2 energy and thermal calculation.

The 80-V MOSFET class remains a working baseline because it leaves useful clamp headroom while avoiding the previous unjustified 250-V device.

## KiCad/schematic-AI net naming
Per channel `n`:
- `SOLn_24V_IN` — coil positive/current-shunt supply node;
- `SOLn_COIL_SW` — coil negative / MOSFET drain switching node;
- `SOLn_ISENSE_P`, `SOLn_ISENSE_N` — Kelvin shunt taps;
- `SOLn_ISENSE_A` — amplified analog current signal;
- `SOLn_ADC` — conditioned ADC input;
- `SOLn_PWM_REQ` — FPGA PWM request;
- `SOLn_AUTH` — FPGA-local watchdog/channel authority;
- `SOLn_PWM_ALLOWED` — gated PWM to driver;
- `SOLn_OC_RAW` — comparator trip;
- `SOLn_OC_LATCH` — latched independent trip;
- `SOLn_GATE_INHIBIT` — hard driver inhibit;
- `SOLn_GATE` — MOSFET gate;
- `SOLn_FAULT` — diagnostic return to FPGA;
- `SOLn_REARM` — qualified explicit latch-clear request.

Keep `SOLn_OC_LATCH -> SOLn_GATE_INHIBIT` as a direct hardware path. Firmware may observe it but must not be required for it to shut the MOSFET off.

## Next evidence
The highest-information missing physical data remains coil inductance/current decay and the actual 24-V rail envelope. Until those exist, schematic-AI may draw the clamp as a parameterized `CLAMP_FAST` network with voltage/energy fields marked TBD rather than inventing a TVS part.

## Source
TI UCC27511A product/datasheet page, checked 2026-09-15. TI documents outputs held LOW during VDD UVLO and with floating inputs, 4.5–18 V operation, and split outputs for independent turn-on/off slew control.
