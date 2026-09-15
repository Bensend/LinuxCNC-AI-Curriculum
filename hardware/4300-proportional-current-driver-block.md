# 4300 proportional-current / solenoid driver block

Status: WORKING SCHEMATIC CONTRACT — component values requiring coil L/transient measurements remain open.

## Purpose
Reusable light-duty current-controlled output for proportional hydraulic solenoids. Present machine baseline is nominal 24 V and approximately 22–28 ohm coils (~0.86–1.09 A DC). The architecture is parameterized so higher-current variants can reuse the contract without pretending the same MOSFET/shunt/clamp values fit every valve.

## Authority chain
`LinuxCNC current request -> transport generation/freshness -> FPGA watchdog + channel enable -> FPGA current loop -> gate driver -> low-side N-MOSFET -> coil`

Feedback chain:
`coil current -> high-side Kelvin shunt -> PWM-rejecting current-sense amplifier -> ADC -> FPGA current loop + diagnostics -> LinuxCNC`

Independent containment:
`hardware overcurrent comparator -> gate disable/latch`

A current command is not proof of current; measured current is not proof of spool displacement; spool displacement is not proof of hydraulic pressure/flow; hydraulic response is not proof of safe ram motion. Machine safety authority remains external to this ordinary control block.

## Working electrical baseline
- field supply: nominal 24 V machine rail, final tolerance/transient envelope TBD;
- channel continuous-current class: 0–1.1 A present requirement, 1.5 A engineering ceiling for first variant pending measurements;
- switching device: **80-V N-MOSFET class**, avalanche/SOA qualified; CSD19502Q5B-class reference candidate, not final procurement freeze;
- gate drive: dedicated gate-driver stage sized for selected MOSFET; do not drive a large power MOSFET directly from FPGA I/O;
- current shunt: 50 mOhm, Kelvin-routed, >=0.25-W working rating with thermal margin;
- current sense: INA240A1-class high-side PWM-rejecting amplifier (20 V/V working gain), feeding ADC;
- recirculation: engineered fast-decay clamp, not plain diode-only baseline; exact TVS/Zener/active-clamp voltage TBD after coil inductance and response measurement;
- local hardware overcurrent cutoff independent of Ethernet/software loop;
- connector-edge transient/ESD protection and machine-power protection coordinated with the 4000 core power-entry contract.

## FPGA contract
Per channel expose at minimum:
- `current_cmd`;
- `enable_request`;
- command generation/age;
- `current_measured`;
- ADC sample generation/age/VALID;
- PWM duty;
- loop saturation/high-limit state;
- overcurrent fault;
- open-load/no-current diagnostic after qualified command window;
- short/overcurrent diagnostic;
- watchdog/output-authority state;
- explicit fault clear/rearm.

Watchdog expiry or stale current feedback must force gate authority OFF. Restoration of Ethernet traffic must not automatically replay a stale nonzero current request.

## Current-loop behavior
Current setpoint, not PWM duty, is the public actuator command. FPGA-local loop timing must be deterministic and tied to fresh ADC samples. Do not update the integrator from stale samples. Anti-windup is required when PWM saturates or output authority is removed. On disable/fault/watchdog, integrator state must be cleared or otherwise reconciled before rearm so the first post-rearm PWM command cannot inherit stale accumulated error.

Working PWM frequency is not yet frozen. TI TIDA-020023 demonstrates proportional-solenoid operation at 1 kHz, but this controller may choose another rate after coil inductance, current ripple, acoustic response, ADC timing and switching loss are reconciled.

## Clamp/decay contract
A proportional valve must be able to reduce current deliberately; therefore turn-off dynamics are part of the actuator contract. A plain diode-only flyback is not the default because it can make current decay unnecessarily slow.

The selected clamp SHALL:
- keep worst-case MOSFET VDS below a documented derated limit including supply tolerance and wiring overshoot;
- absorb/recycle worst-case 0.5*L*I^2 energy at the commanded repetition rate;
- meet measured current fall-time requirement;
- have a documented thermal/repetitive-pulse rating;
- fail toward loss of drive authority rather than uncontrolled sustained current where practical.

## Required measurements before first schematic value freeze
1. Measure coil inductance for each current machine coil family.
2. Measure/confirm hot resistance or hot steady current.
3. Establish desired current fall/rise time from hydraulic behavior.
4. Measure/define 24-V rail maximum and transient envelope.
5. Choose ADC/reference/sample rate and confirm resolution/noise at low current.
6. Select final MOSFET/gate driver/clamp from those bounds.

## Verification plan
Use standard calculations first. Bench or simulate only uncertainties calculations cannot close:
- current-loop stability/ripple with measured L/R;
- clamp overshoot and repetitive energy;
- PWM-edge current-sense settling/ADC aperture;
- watchdog/feedback-stale/rearm adversarial behavior.

Do not run repetitive MOSFET simulations merely to prove Ohm's law or steady-state dissipation.

## Source basis
- TI TIDA-020023 proportional-solenoid reference: high-side proportional drive/current sensing, 1-kHz demonstrated drive, 0.5% FSR current-sense result.
- TI INA240: enhanced PWM rejection, -4 to 80 V common-mode range, solenoid flyback compatibility.
- TI CSD19502Q5B: 80-V avalanche-rated N-MOSFET reference class.
- `research/4000-proportional-solenoid-electrical-sizing-2026-09-15.md`.
