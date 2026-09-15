# 4300 PWM / analog output block — working schematic contract

Status: WORKING FREEZE; precision servo daughterboard topology still open.

## Resources
- >=4 FPGA PWM/PDM resources, all consumed through the global FPGA watchdog/output-authority gate.
- 1–2 base-board isolated VFD/potentiometer-replacement analog channels.
- Precision multi-axis +/-10 V servo command stays daughterboard/variant unless machine inventory justifies base-board inclusion.

## Base-board VFD analog channel
Functional model follows the proven Mesa 7I96S class:
- field terminals REF+, WIPER/OUT, REF-;
- intended for an externally supplied VFD potentiometer reference;
- working reference span target 5–18 V;
- FPGA PWM working carrier target 10–20 kHz;
- analog output spans REF- to REF+;
- startup/watchdog/rearm state = minimum command (REF- for unipolar wiring);
- bipolar use is permitted only when system configuration explicitly defines the 50% zero point and verifies startup consequences.

Implementation must preserve galvanic isolation between FPGA logic and the drive-side analog domain. Exact converter/isolator parts remain BOM work.

## Precision +/-10 V daughterboard
Required contract:
- dedicated bipolar DAC or equivalent precision conversion, not a generic RC-filtered PWM assumed to be servo-grade;
- command range at least -10 to +10 V with calibration provision;
- deterministic zero on power-up, watchdog loss and disabled state;
- separate floating/isolated drive-enable authority where needed;
- explicit recovery/rearm before nonzero command is restored;
- output fault/rail/saturation diagnostics where practical;
- analog output command does not substitute for encoder, drive-ready/fault, actual motion, brake state or STO.

## Verification before schematic freeze
VFD channel: transfer linearity, ripple across PWM carrier range, startup state, reference loss, isolation withstand/creepage, watchdog bite, rearm and load impedance.

Servo daughterboard: offset/gain/temp drift, noise/bandwidth, power sequencing, zero-state accuracy, watchdog-to-zero latency, enable ordering, cable/load stability and rail/saturation behavior.

No safety-rated claim is made for this block.
