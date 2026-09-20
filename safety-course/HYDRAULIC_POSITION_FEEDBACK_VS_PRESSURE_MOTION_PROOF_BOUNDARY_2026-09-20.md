# Hydraulic Position Feedback vs Pressure/Motion Proof Boundary

Date: 2026-09-20

## Purpose

Advance the next 4000 safety checkpoint without inventing a machine-specific hydraulic truth table. This is a bounded source trace establishing what monitored hydraulic valve position proves, and what still requires independent pressure/motion evidence.

## Evidence classification

- **DOC-CONFIRMED:** Parker C10C*E monitored 2-way seat valve product documentation.
- **DOC-CONFIRMED:** Parker D3W directional valve with inductive position control documentation.
- **DOC-CONFIRMED:** Bosch Rexroth HSR multi-station manifold guidance and STOM functional-safety product information.
- **INFERENCE:** architecture conclusions below.
- **UNKNOWN:** an authoritative single press-brake commissioning sequence that combines valve-position witness, independent pressure witness, physical ram-motion witness, quantitative acceptance, fault/restart disposition and return-to-service in one procedure.

## Manufacturer evidence

Parker documents C10C*E 2/2-way seat valves as intended for safety-relevant shutoff/load-holding applications. They include an inductive switch monitoring the closed poppet position and a safety overlap intended to prevent opening before the inductive signal changes. This is stronger evidence than a solenoid command: it observes the final hydraulic element's mechanical position.

Parker's D3W family likewise provides inductive monitoring of a defined spool start position and is described for safety-relevant applications.

Bosch Rexroth's current HSR manifold guidance explicitly lists position-monitored shut-off/relief functions and pressure sensors as separate available elements. Rexroth states that machine-specific safety requirements can use valves with integrated spool-position monitoring or pressure sensors in measuring ports. Its standardized hydraulic STO manifold line is aimed at presses and other machinery and implements area shutoff in architectures up to Cat. 4 / PL e when correctly engineered.

## Critical boundary

The sources support a multi-witness design, but the bounded search did **not** locate one authoritative press-brake procedure that says, in one complete test:

1. command the named safety valve;
2. require monitored poppet/spool position within a stated mismatch timeout;
3. independently measure downstream pressure or decompression;
4. independently observe ram motion/retention;
5. apply a quantitative physical acceptance criterion;
6. inhibit restart on mismatch/failure;
7. perform defined reset/requalification and fresh start.

That complete chain remains **UNKNOWN** and must not be synthesized from separate product features as if an OEM had validated it.

## Durable freezes

**VALVE COMMAND SAFE != SOLENOID DE-ENERGIZED != POPPET/SPOOL IN MONITORED SAFE POSITION.**

**POPPET/SPOOL IN MONITORED SAFE POSITION != DOWNSTREAM PRESSURE REMOVED.** Trapped pressure, accumulator energy, plumbing topology, another flow path, leakage, or machine-specific load-holding arrangements can matter.

**PRESSURE SENSOR READS EXPECTED VALUE != RAM PHYSICALLY STOPPED/RETAINED.** Pressure is another witness, not a substitute for machine response where machine response is the safety objective.

**POSITION MONITOR HEALTHY != VALVE FLOW/SEALING PERFORMANCE PROVED.** A position switch can establish mechanical position without by itself proving leakage rate or load-retention performance.

**POSITION + PRESSURE STATUS != QUANTITATIVE STOPPING/RETENTION PERFORMANCE ACCEPTED.** A validated physical performance test remains a distinct layer where the risk assessment requires it.

## Reusable witness ladder

For hydraulic safety teaching, preserve these layers independently:

**SAFETY DEMAND -> ELECTRICAL VALVE COMMAND -> SOLENOID/PILOT STATE -> POPPET/SPOOL POSITION WITNESS -> HYDRAULIC ENERGY/PRESSURE WITNESS -> RAM/ACTUATOR PHYSICAL RESPONSE -> QUANTITATIVE PERFORMANCE ACCEPTANCE -> RESTART/REARM**

Do not collapse them into `hydraulic_safe=true`.

## OpenPressBrake consequence

The normal FPGA/LinuxCNC controller may expose all of these as diagnostics, but personnel-safety authority must remain with the validated safety architecture. A future safety controller can use appropriate independent witnesses, but the actual OpenPressBrake valve topology, sensor locations, mismatch times, pressure thresholds, stop/retention criteria, diagnostic coverage and required performance level must come from the machine's engineered safety function and validation—not this generic study.

## Information-gain stop

The product-level hydraulic position/pressure source path is now bounded. Further generic valve catalog searching is low value unless it yields the missing complete machine/OEM validation sequence. Rotate next to the accessible-cell presence-sensing commissioning/validation lane, while leaving this hydraulic gap explicitly reopenable by a genuine OEM/manifold commissioning procedure.

## Source provenance

1. Parker Hannifin, C10C*E 2-Way Slip-In Cartridge Valve documentation: safety-relevant shutoff/load holding; monitored closed poppet position; safety overlap.
2. Parker Hannifin, D3W Directional Control Valve with Inductive Position Control: monitored defined start position; safety-relevant application.
3. Bosch Rexroth, HSR multi-station manifold guidance: position-monitored shut-off/relief functions and pressure sensors as distinct engineering elements.
4. Bosch Rexroth, STOM hydraulic STO manifold information, 2024: standardized hydraulic area shutoff for metallurgy, presses and test benches, with machine-safety engineering under ISO 13849.
