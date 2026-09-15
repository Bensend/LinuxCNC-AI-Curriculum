# 4000 proportional-solenoid electrical sizing — 2026-09-15

## Scope
Light-duty baseline for the presently measured nominal 24 V proportional coils, approximately 22–28 ohm. This is a standard-engineering sizing pass, not a simulation result. Coil inductance is not yet measured, so magnetic stored energy and turn-off time remain parameterized by L.

## DC current bounds
At 24 V:
- 22 ohm: I = 24/22 = 1.091 A; coil copper dissipation = 26.18 W.
- 25 ohm: I = 0.960 A; coil copper dissipation = 23.04 W.
- 28 ohm: I = 0.857 A; coil copper dissipation = 20.57 W.

This confirms that the present machine needs roughly a 0–1.1 A continuous-current class, not a many-amp driver. Keep a 1.25–1.5 A engineering ceiling for the first hardware variant pending hot-coil resistance/current requirements.

## Shunt working point
A 50 mOhm shunt gives:
- 1.091 A -> 54.5 mV sense drop, 59.5 mW shunt dissipation.
- 1.50 A ceiling -> 75 mV, 112.5 mW.

With INA240A2 (50 V/V), those become about 2.73 V at 1.091 A and 3.75 V at 1.5 A. Therefore A2 is too high for a direct 3.3-V ADC if the 1.5-A ceiling must be measurable. INA240A1 (20 V/V) gives about 1.09 V at 1.091 A and 1.50 V at 1.5 A and leaves generous ADC/transient headroom. A larger shunt can trade dissipation for ADC span later.

TI INA240 is particularly suitable for this PWM environment because it specifies enhanced PWM rejection, -4 to 80 V common-mode operation and negative-common-mode accommodation for solenoid flyback. Primary source: https://www.ti.com/product/INA240 .

Working choice: **high-side INA240A1-class sensing + 50 mOhm Kelvin shunt**, subject to final ADC resolution/noise analysis. High-side sensing preserves ground integrity and observes coil current even when the low-side switch node is moving.

## MOSFET conduction loss
At 1.091 A:
- 60 V CSD18540Q5B at 3.3 mOhm max (4.5-V gate figure): about 3.9 mW conduction loss at 100% duty.
- An 80 V CSD19502Q5B-class part at roughly 4.1 mOhm max (10-V gate figure): about 4.9 mW.

Conduction loss is negligible relative to the coil. Voltage transient margin and switching/avalanche behavior dominate selection. A 60-V device is not automatically wrong, but a 24-V machine rail plus intentionally elevated fast-decay clamp can consume its margin quickly. The working baseline therefore moves to an **80-V MOSFET class** rather than the previous 250-V device. CSD19502Q5B is a reference candidate, not yet a final BOM freeze; its required gate-drive voltage and SOA/avalanche details must be honored.

## Inductive energy is parameterized until L is measured
Stored energy at current I is E = 0.5*L*I^2.
At 1.091 A this is 0.595*L joule when L is expressed in henries.
Examples only for scale, not assumed coil values:
- 10 mH -> 5.95 mJ
- 50 mH -> 29.8 mJ
- 100 mH -> 59.5 mJ
- 500 mH -> 0.298 J

This is why no avalanche-energy or TVS-energy claim can be frozen until actual inductance (or a defensible manufacturer bound) is obtained.

## Decay topology reasoning
A plain flyback diode minimizes switch stress but produces slow current decay because the coil sees only roughly a diode drop in the reverse-decay direction. That is attractive for holding relays but can make a proportional hydraulic valve sluggish on command reduction.

For the present proportional-valve use, the working topology is **diode + engineered elevated clamp (TVS/Zener or equivalent controlled clamp)** so turn-off voltage is high enough to reduce current promptly while remaining below MOSFET VDS margin under supply tolerance and wiring overshoot. Exact clamp voltage is deliberately not frozen before L and desired current fall-time are measured.

First-order turn-off approximation while clamp dominates: |di/dt| approximately V_decay/L. This makes the trade explicit: higher allowed reverse coil voltage -> faster current fall, but higher MOSFET/clamp stress.

## Loop partition
Do not command raw PWM from LinuxCNC as the physical process variable. LinuxCNC/FPGA command is requested coil current.

Working partition:
1. LinuxCNC sends current request plus enable/generation.
2. FPGA applies command-freshness/watchdog/output-authority gating.
3. FPGA-local current controller generates PWM from requested current and fresh ADC current feedback.
4. High-side shunt + INA240-class amplifier measures actual coil current.
5. Hardware overcurrent/comparator path independently removes gate authority above a hard ceiling; it must not depend on Ethernet or the software current loop.
6. FPGA reports requested current, measured current, PWM duty, current-loop saturation, ADC freshness and electrical fault separately.

Reason for choosing FPGA+ADC as the working baseline: the project already has an FPGA realtime authority layer, proportional setpoint/diagnostics are naturally parameterized, and the design needs multiple machine-specific current profiles. A local analog regulator remains a fallback if ADC/control-loop timing proves inadequate. The hard overcurrent cutoff remains local hardware regardless.

## Remaining measurements before schematic freeze
- actual coil inductance for each present coil type;
- hot resistance/current requirement;
- desired current rise/fall time or acceptable hydraulic response;
- machine 24-V rail tolerance and transient environment;
- final ADC architecture/sample rate/reference;
- final gate-driver voltage and hard overcurrent threshold.

No circuit simulation is justified yet: these measurements dominate the remaining uncertainty.
