# 4000 proportional-solenoid/current-driver reference pass — 2026-09-15

## Goal
Start the parameterized proportional-valve block from proven current-control practice, not from the earlier oversized MOSFET choice or from peak/hold relay assumptions.

## Reference findings
Texas Instruments TIDA-020023 is specifically a proportional-solenoid reference design. It uses PWM drive plus high-side current sensing, reports 0.5% full-scale current-sense accuracy, 1 kHz drive, wide -4 to 80 V current-sense common mode, and enhanced PWM rejection. This is directly relevant to a proportional hydraulic valve because coil current, not raw PWM duty, is the useful electrical control variable.

TI DRV110 and TIDA-00289 are useful adjacent evidence for low-side MOSFET + shunt current regulation, peak/hold behavior, undervoltage/thermal fault handling, and the distinction between commanded current and physical plunger movement. They are NOT the baseline proportional-control architecture because DRV110 is optimized around pull-in/hold solenoid behavior rather than continuously variable commanded current.

## Working architecture for OpenPressBrake-class channel
24-V nominal coil, current-controlled PWM channel:

24-V field supply -> coil -> low-side N-MOSFET -> current shunt/return
with a deliberately engineered recirculation/clamp path and independent current measurement returned to FPGA/ADC/control logic.

The command shall be a current setpoint. PWM duty is an internal actuator variable. The block must report measured current and electrical fault state separately.

## Parameterization
The reusable design must expose at least:
- nominal field supply;
- coil resistance and measured/estimated inductance;
- maximum continuous current;
- current command range;
- PWM frequency;
- shunt value and amplifier gain;
- MOSFET VDS/ID/RDS(on)/SOA margins;
- recirculation/clamp voltage and decay mode;
- current-loop bandwidth/limits;
- open-load, short/overcurrent, supply undervoltage and thermal-fault thresholds.

For the current press-brake coils already measured around 22–28 ohm at roughly 24 V, the nominal DC current is on the order of 0.86–1.09 A before hydraulic/control derating. The design should therefore target this light-duty class first while retaining parameterized scaling, rather than defaulting to a 250-V MOSFET.

## Authority and recovery contract
LinuxCNC current request -> FPGA freshness/watchdog gate -> current controller -> MOSFET/coil -> measured current.

Keep distinct:
- requested current;
- PWM/gate activity;
- measured coil current;
- electrical driver fault;
- hydraulic valve/spool response;
- cylinder/ram motion;
- machine safety authority.

Watchdog expiry must force current request to zero and remove gate authority locally. Communications recovery requires explicit rearm. A measured current matching command is not proof of spool motion or hydraulic effect.

## Exact next engineering work
1. Select a modern low-voltage MOSFET for the ~1 A/24 V baseline using transient/clamp SOA, not only headline current rating.
2. Select shunt and current-sense amplifier; compare low-side simplicity against high-side PWM-rejecting measurement.
3. Freeze freewheel/TVS/active-clamp decay strategy from valve dynamics and MOSFET stress calculations.
4. Determine whether the current loop belongs fully in FPGA logic with ADC feedback or in an analog/current-driver IC commanded by FPGA DAC/PWM.
5. Produce a first real schematic before simulation; simulate only loop/stress questions that calculations and datasheets do not resolve.
