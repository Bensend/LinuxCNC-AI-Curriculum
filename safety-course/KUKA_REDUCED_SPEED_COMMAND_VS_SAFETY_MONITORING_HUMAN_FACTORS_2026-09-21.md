# KUKA reduced-speed command vs safety monitoring — safeguard-defeat human factors

Date: 2026-09-21

## Question

When normal guarding is unavailable during setup/commissioning, is configuring the ordinary controller to move slowly enough to constitute the safety function? What architecture makes the safer setup path easier to use without silently replacing independent safety monitoring with a normal speed command?

## Authoritative implementation evidence

### KUKA Sunrise Cabinet Med

**DOC-CONFIRMED.** KUKA documents T1 (Manual Reduced Velocity), T2 (Manual High Velocity), Automatic, and Controlled Robot Retraction as distinct modes. In T1, program verification and jog are described with a maximum of 250 mm/s. However, KUKA explicitly warns that the T1 reduced velocity in the standard safety configuration is **not safety-rated reduced speed**: the 250 mm/s maximum is not safety-oriented monitoring. Where the application requires safety-oriented velocity monitoring, KUKA says it must be added in the safety configuration, for example with Sunrise.SafeOperation Cartesian velocity monitoring.

Source: KUKA, *KUKA Sunrise Cabinet Med*, issued 2021-11-26, sections 3.5.2.1 and 3.5.2.2: https://www.kuka.com/-/media/kuka-downloads/manual-upload/kuka-sunrise-cabinet-med/kuka_sunrise_cabinet_med_en.pdf

KUKA also documents the three-position enabling-device stop behavior in manual modes and distinct safety-gate behavior by operating mode. These mechanisms are not interchangeable with an ordinary programmed velocity limit.

### FANUC independent corroboration

**DOC-CONFIRMED.** FANUC describes Dual Check Safety Position & Speed Check as certified real-time monitoring using redundant safety processors. The system monitors actual robot position/speed and removes motor power if configured safety limits are violated.

Source: FANUC America, *Dual Check Safety (DCS) — Position and Speed Check*: https://www.fanucamerica.com/products/software/fanuc-dual-check-safety-dcs

This corroborates the architecture distinction: commanding a lower speed and independently monitoring actual motion against a safety limit are different functions.

## Durable freezes

- **COMMANDED REDUCED SPEED != SAFETY-RATED SPEED MONITORING.**
- **T1 / SETUP MODE LABEL != SAFE SPEED PROVED.**
- **NORMAL CONTROLLER SPEED OVERRIDE != INDEPENDENT PROCESS-SPEED WITNESS.**
- **ENABLING DEVICE VALID != MOTION COMMAND.**
- **SAFETY-MONITORED SPEED ENVELOPE != ORDINARY JOG/PROGRAM DEMAND.**
- **SLOWER MOTION != SAFE MOTION unless the machine-specific hazard analysis and safety architecture establish that proposition.**

Do not universalize KUKA's 250 mm/s figure to machine tools, press brakes, hydraulic axes, spindles, conveyors or custom machines. It is product/mode evidence, not an OpenPressBrake acceptance threshold.

## Practical architecture for teaching

For commissioning with normal guarding intentionally unavailable, teach four independent layers:

1. **Mode authority** — setup/service mode is selected and supervised by the applicable safety architecture.
2. **Protective condition** — enabling device or other risk-assessment-derived protective function is valid.
3. **Safety motion envelope** — where required, actual speed/position/motion is independently monitored; an ordinary controller setpoint is not accepted as proof.
4. **Deliberate ordinary demand** — jog/program verification still requires a separate intentional motion command.

LinuxCNC may command a conservative low velocity and make that the default setup UX. The normal FPGA may expose speed/motion diagnostics. Neither acquires personnel-safety authority merely by doing so. If safe speed is a required safety function, the independent safety path must establish/monitor it with appropriate architecture and validation.

## Human-factors / defeat-resistance lesson

A design that makes correct setup painfully difficult encourages operators to seek full-speed modes, tape enabling devices, defeat guards, or create persistent bypasses. That is an engineering problem, not merely a training problem.

Make the safer path the convenient path:

- setup mode should be obvious and quick to enter legitimately;
- the required enabling control should be ergonomic enough for intended work;
- ordinary jog controls should remain deliberate and predictable;
- reduced normal-control setpoints should be automatic defaults rather than relying on memory;
- safety monitoring, when required, should run independently and fail safe rather than depending on an operator remembering a software override;
- exceptional states should be conspicuous and difficult to carry into production;
- leaving setup should invalidate setup-era ordinary demands and require the designed production re-entry sequence.

Do not "solve" nuisance by weakening or bypassing the independent safety function. Fix the workflow that makes defeat attractive.

## Commissioning questions

A learner validating reduced-speed setup must identify:

- who commands the velocity;
- who independently witnesses actual velocity, if required;
- what physical endpoint the witness proves;
- what happens when commanded and witnessed speed disagree;
- what happens on loss of the witness;
- whether enabling-device release stops motion as designed;
- whether the ordinary jog/start demand must be fresh after mode/rearm transitions;
- whether any temporary speed override, force, bypass, jumper, simulation or alternate parameter remains after commissioning.

## Evidence classification

- KUKA distinction between T1 commanded/reduced velocity and optional safety-oriented velocity monitoring: **DOC-CONFIRMED**.
- FANUC DCS independent safety position/speed monitoring: **DOC-CONFIRMED**.
- Human-factors recommendation to make the legitimate safe workflow easier than defeat: **ENGINEERING INFERENCE / curriculum design principle**, not attributed to KUKA or FANUC as a universal product rule.
- OpenPressBrake-specific safe velocity, stopping distance, enabling-device architecture and performance level: **UNKNOWN until risk analysis/design/validation establishes them**.

## Next work

Convert this into a reusable safeguard-defeat review method: identify every foreseeable shortcut (guard bypass, taped/defeated enabling device, software speed override, persistent maintenance key, simulated witness), the inconvenience motivating it, the safety consequence, the engineered usability correction, and the validation test proving the correction did not transfer safety authority into ordinary LinuxCNC/FPGA control.