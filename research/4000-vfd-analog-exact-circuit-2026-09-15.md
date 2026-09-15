# 4000 — isolated VFD analog exact-circuit freeze — 2026-09-15

Status: WORKING SCHEMATIC CONTRACT

## Objective
Freeze a drawable 0–10 V / potentiometer-replacement channel that preserves galvanic separation and deterministic minimum command on reset/watchdog.

## Evidence
- Mesa 7I96S production behavior already preserved in the curriculum establishes the useful architecture: VFD-provided analog reference, isolated PWM-derived command, preferred 10–20 kHz PWM, and deterministic minimum-command startup.
- TI TLV9101 is current-production, 2.7–16 V, RRIO, 1.1 MHz, low-power op amp suitable for a field-side 10 V supply and near-ground/near-rail output.
  Source: https://www.ti.com/product/TLV9101
- TI TPS7A2450 is current-production, fixed 5 V, 2.4–18 V input, 200 mA LDO, stable with 1 uF output capacitor. This permits the VFD's nominal 10 V reference to power the field-side digital-isolator receiver without a separate isolated DC/DC.
  Source: https://www.ti.com/product/TPS7A24/part-details/TPS7A2450DBVR
- Default-LOW digital isolation remains required from the previously frozen DIO/output architecture. The field-side isolator output LOW must correspond to 0 V analog command.

## Exact working topology — per channel
Connector: `VFD_REF_10V`, `VFD_ANALOG_OUT`, `VFD_ANALOG_COM`.

1. FPGA `VFD_PWM_CMD` is already watchdog/authority gated. Reset, stale command, or watchdog bite forces LOW.
2. Pass `VFD_PWM_CMD` through a default-LOW digital isolator. Logic-side supply is 3.3 V. Field-side supply is `VFD_5V_LOCAL`.
3. Generate `VFD_5V_LOCAL` from `VFD_REF_10V` with TPS7A2450-class 5 V LDO. Use datasheet-required local input/output decoupling; 1 uF minimum output capacitor is supported by the device.
4. The field-side isolated PWM therefore swings 0–5 V and, critically, loss of logic-side authority produces 0 V rather than an inverted/full-scale state.
5. Convert PWM to DC with a unity-gain 2-pole low-pass stage. Working values: R1=10 kΩ, R2=10 kΩ, C1=1.0 uF, C2=1.0 uF, giving an order-of-magnitude pole around 15.9 Hz. This is intentionally slow relative to 10–20 kHz PWM and appropriate for spindle/VFD speed command, not servo control.
6. TLV9101-class RRIO op amp is powered from `VFD_REF_10V` and `VFD_ANALOG_COM`. Configure non-inverting gain = 2.000 with Rg=10.0 kΩ and Rf=10.0 kΩ so nominal 0–5 V filtered command maps to nominal 0–10 V output.
7. Add 100 Ω series output resistor between op-amp output and `VFD_ANALOG_OUT` for cable/capacitive-load isolation. Connector-edge ESD protection must be low-leakage and selected so normal 0–10 V range is not clipped.
8. Add test points for `VFD_REF_10V`, `VFD_5V_LOCAL`, isolated PWM, filtered 0–5 V node, and final analog output.

## Important qualification
The VFD's 10 V reference is both the field-side supply/reference and the full-scale analog authority. This intentionally tracks a VFD whose reference is not exactly 10.000 V. However, TLV9101 cannot produce an ideal zero-headroom output at the positive rail under every load. Therefore `10 V full scale` means potentiometer-replacement behavior approaching the VFD reference, not a metrology-grade guaranteed 10.000 V source. Final prototype verification SHALL measure full-scale headroom into representative VFD analog-input impedance.

## Failure-state contract
- FPGA reset/watchdog/stale command -> PWM LOW -> isolator output LOW -> filter discharges -> analog command approaches 0 V.
- Loss of logic-side isolator supply -> default LOW field-side state -> analog command approaches 0 V.
- Loss of VFD reference -> local 5 V and op-amp supply collapse -> analog command loses authority with the VFD reference; it must not be back-powered from controller logic.
- Communication recovery does not automatically restore stale nonzero command; explicit output-authority rearm remains required.
- This analog path is ordinary control/fault containment, not safety-rated STO or E-stop authority.

## Schematic-AI rejection rules
Reject any generated circuit that:
- inverts fail-safe polarity so LOW/reset creates full-scale analog;
- powers field-side circuitry from controller ground across the isolation barrier;
- substitutes an unisolated DAC without explicitly changing the interface contract;
- claims precision ±10 V servo capability from this VFD channel;
- back-powers `VFD_REF_10V` from board rails;
- omits watchdog gating before the isolation barrier.

## Remaining prototype checks
- verify actual VFD reference range and allowed reference-source current across target drives;
- verify field-side isolator + LDO current is comfortably below VFD reference-source capability;
- measure 0 V offset, full-scale headroom, ripple and settling at 10 and 20 kHz PWM;
- verify output stability with representative cable capacitance/input impedance.

No simulation is required before these standard bench checks.
