# Siemens SINAMICS S120 — speed witness, torque removal, and restart-window boundary

Date: 2026-09-21
Course branch: 4000 safety / 25E0 professional final-element and process-witness tracing

## Question

What changes when a safety architecture observes a physical process quantity (motor speed) rather than only final-element command/position, and what does that evidence actually authorize during stopping and restart?

## Authoritative evidence

### Safe Brake Ramp / Safe Acceleration Monitor

**DOC-CONFIRMED.** Siemens `SINAMICS S120 Function Manual Safety Integrated`, 12/2018, 6SL3097-5AR00-0BP1, overview of Safety Integrated Extended Functions, describes two process-monitoring stop mechanisms:

- SBR monitors whether motor speed decreases against a configured braking ramp after SS1 selection.
- SAM continuously tracks decreasing motor speed and prevents an unnoticed re-acceleration from remaining inside a fixed original threshold.
- In the documented SS1 behavior, reaching the configured shutdown/standstill speed threshold leads to safe removal of motor torque (STO); expiration of the maximum stopping interval can also lead to STO.
- Siemens explicitly distinguishes SS1E with external stop: SBR/SAM are not active there; an external user program must perform the stop during the delay, after which STO becomes active.

Official source: Siemens, `SINAMICS S120 Function Manual Safety Integrated`, 12/2018, document 6SL3097-5AR00-0BP1.
https://cache.industry.siemens.com/dl/files/292/109763292/att_971633/v1/S120_safety_fct_man_1218_en-US.pdf

This is materially different evidence from a contactor auxiliary contact, brake switch, or valve-spool switch: the monitored quantity is motor motion itself. It therefore supports a bounded claim about the drive's measured speed trajectory, not merely the commanded state of the element intended to stop motion.

### SSM restart behavior

**DOC-CONFIRMED.** Siemens `Commissioning Manual Safety Integrated (with SINAMICS S120)` documents a restart sequence for one SSM/pulse-inhibit configuration in which STO must be selected and deselected again to restart safely. After STO deselection a five-second window is opened; pulse enable within that window permits start, while absence of pulse enable causes internal STO to become active again. The manual also documents different behavior when the relevant SSM pulse-inhibit feedback setting is deactivated.

Official source: Siemens, `Commissioning Manual Safety Integrated (with SINAMICS S120)`, section 4.11 SSM.
https://cache.industry.siemens.com/dl/files/925/109769925/att_993663/v1/MC_SI_commiss_man_en-US.pdf

The important curriculum result is not the five-second value. That number is configuration/version-specific and must not be copied into another machine. The useful result is that Siemens explicitly couples monitored motion state to a defined re-entry/restart protocol rather than allowing us to infer restart semantics from `speed below threshold` alone.

## Evidence-chain interpretation

A useful typed chain for this implementation is:

`ordinary stop demand -> drive deceleration -> safely monitored speed trajectory -> shutdown/standstill criterion -> STO -> restart/re-entry protocol -> ordinary motion demand`

Each arrow has different evidence authority.

### What the speed witness can prove

**DOC-CONFIRMED / INFERENCE bounded by the cited function definition:** a correctly validated SBR/SAM/SSM implementation can provide safety-related evidence about the motor speed quantity covered by its configured measurement architecture and thresholds.

It does **not** automatically prove:

- hydraulic pressure is zero;
- a ram, slide, load, or tool has no independent motion path;
- gravity cannot move the mechanism after motor torque is removed;
- a mechanical brake has its required holding torque;
- stored pneumatic/hydraulic/mechanical energy is dissipated;
- the machine has achieved a design-specific stopping distance;
- a downstream transmission has not failed mechanically;
- an ordinary LinuxCNC cycle/jog request is fresh.

Those claims need their own witnesses, calculations, tests, or safety architecture.

## New freezes

1. **FINAL-ELEMENT COMMAND/STATUS != PROCESS RESPONSE.** A commanded STO, valve state, or brake command is not the same evidence as observed motion/pressure.
2. **PROCESS WITNESS VALID != ALL HAZARDOUS ENERGY SAFE.** Motor speed below a threshold does not establish zero hydraulic pressure, gravity-load restraint, brake torque, or absence of stored energy.
3. **SAFE SPEED/SSM CONDITION TRUE != ORDINARY START AUTHORIZED.** Siemens documents additional restart/re-entry behavior; process state alone is not a start command.
4. **STO ACTIVE != MECHANICAL LOAD SECURED.** For vertical/gravity axes, torque removal can itself change the hazard unless another validated retaining mechanism exists.
5. **MONITORED STOP SUCCESS != STOPPING PERFORMANCE UNIVERSALLY VALIDATED.** Thresholds, delay, encoder/measurement architecture, machine mechanics and acceptance criteria remain design-specific.
6. **SS1E != SS1 WITH INTERNAL PROCESS MONITORING.** Siemens explicitly distinguishes external-stop timing from SBR/SAM monitored stopping; do not collapse them into one generic `safe_stop` behavior.
7. **RESTART WINDOW != DEMAND FRESHNESS.** A safety function permitting re-entry during a documented window does not prove an ordinary controller's pre-existing start/jog/cycle request is fresh.

## OpenPressBrake / LinuxCNC teaching boundary

A generic press-brake lesson may teach that final-element feedback and process feedback answer different questions. For example, a valve-position witness may establish a spool/contact state while an independent motion/pressure witness can establish a process response. Neither should be represented in ordinary LinuxCNC/HAL as a universal `SAFE=true` authority.

LinuxCNC may consume diagnostic/status copies, inhibit ordinary production, require a fresh ordinary start edge, and present useful diagnostics. Personnel-safety authority, safety-rated motion/pressure evaluation, and physical energy-removal authority remain in the validated independent safety architecture.

No machine-specific pressure threshold, speed threshold, stopping distance, delay, PL/SIL, diagnostic coverage, or hydraulic truth table is inferred here.

## Cross-family comparison

- Siemens 3SK1 feedback study: external final-element feedback can block switching, but held-start/recovery semantics depend on the selected circuit.
- Rockwell Safe Brake Control: brake-feedback mismatch has explicit timing/fault/reset semantics, but brake feedback does not prove holding torque.
- SMC/Festo/Bosch Rexroth valve study: valve position is a bounded final-element witness; supply isolation and downstream decompression are distinct.
- Siemens S120 here: measured speed supplies process evidence beyond element state, yet still does not prove every hazardous-energy path and still has separate restart semantics.

The reusable methodology is therefore to type every witness by **what physical quantity it observes**, **where it sits in the energy chain**, **what failure modes it can detect**, **what it cannot prove**, and **what reset/restart state machine consumes it**.

## Information-gain decision

This branch answered the checkpoint's process-evidence question without simulation. No lab is justified merely to reproduce documented S120 behavior. A lab would become justified only if a concrete LinuxCNC/OpenPressBrake-independent software question remains that authoritative documentation/source cannot resolve.

Next evidence target: a professional implementation combining two different physical witness classes (for example final-element position plus pressure/motion, or brake status plus motion) in one documented restart/return-to-service decision. If public authoritative material does not expose that complete chain, record the limit and rotate rather than inventing it.
