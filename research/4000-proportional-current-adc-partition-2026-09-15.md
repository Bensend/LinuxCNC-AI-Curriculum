# 4000 proportional-current ADC/control partition — 2026-09-15

## Question
Can the proportional-current loop reasonably live in the FPGA using a shared external ADC, or is a dedicated analog current-control IC required per channel?

## Working answer
A shared FPGA-facing SAR ADC is practical for the light-duty multi-channel baseline. Do not freeze the final loop bandwidth until coil L/R is measured.

## Candidate
TI ADS7953 is a 12-bit, 1-MSPS, 16-channel multiplexed SAR ADC with SPI interface, 0-to-reference single-ended inputs and -40 to 125 C rating. That is enough channel density to carry multiple proportional-current channels plus useful slow analog diagnostics without adding one ADC per valve.

With four current channels, even a simple round-robin allocation can provide up to ~250 kSPS/channel before protocol/settling overhead. This is far above the demonstrated 1-kHz proportional-solenoid PWM reference rate in TIDA-020023 and leaves room to synchronize sampling to quiet PWM phases. Actual usable sample timing must be verified in FPGA implementation rather than inferred from the headline conversion rate.

## Resolution check
Using the current working INA240A1 + 50-milliohm shunt:
- transimpedance from coil current to ADC voltage = 0.05 ohm * 20 V/V = 1.0 V/A;
- 1.1 A -> ~1.1 V;
- 1.5 A ceiling -> ~1.5 V.

With a 3.3-V ADC reference and 12 bits, one ideal count is ~0.806 mV, corresponding to ~0.806 mA at the 1 V/A scaling. This is already finer than needed for a roughly 1-A hydraulic proportional valve before analog noise, tolerance and calibration are considered.

A lower ADC reference or higher current-sense gain could improve span use, but is not required to prove feasibility. Preserve headroom for PWM-edge artifacts and fault conditions.

## Control timing contract
The FPGA current controller SHALL:
- trigger/sequence ADC conversions deterministically;
- tag every sample with channel and generation/age;
- update each loop only from a fresh sample belonging to that channel;
- preferably sample at a repeatable PWM phase after INA240/output settling;
- detect missed/stale conversions and remove output authority rather than integrating stale feedback;
- implement anti-windup and deterministic reset/rearm state.

## Independent protection
The ADC/FPGA loop is ordinary control, not the sole short-circuit protection. A hardware comparator/current-limit path must independently inhibit the gate above a hard current ceiling. The comparator threshold can be deliberately above normal 0–1.5-A command range so normal regulation remains in FPGA while catastrophic overcurrent does not wait on ADC/SPI/firmware.

## Decision
Working baseline: **FPGA current loop + shared ADS7953-class SAR ADC + INA240-class high-side current sense + independent hardware overcurrent gate inhibit.**

Keep a dedicated analog regulator as fallback only if measured coil dynamics or FPGA/ADC timing later show a real reason. No simulation is justified until coil inductance and desired hydraulic current response are known.

## Sources
- TI ADS7953 product/datasheet page: 12 bit, 1 MSPS, 16 channel, multiplexed SAR, SPI.
- TI INA240 product/datasheet page: PWM rejection and -4 to 80 V common mode.
- TI TIDA-020023 proportional-solenoid reference: demonstrated 1-kHz drive/current-sense architecture.
