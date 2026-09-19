# HAWE ePrAX NSV replacement — return-to-service evidence boundary

Session start UTC: `2026-09-19T13:35:15Z`

## Question

For a real press-brake hydraulic final element, what does the component manufacturer's replacement procedure actually require before, during, and after replacement, and does it itself establish an individual retaining-function proof or a machine-level return-to-production test?

## Authoritative source

HAWE Hydraulik SE, **B 6340 NSV — Maintenance instructions suction valve unit**, 03-2021, for the ePrAX modular CNC press-brake control. Current HAWE product-download pages still list this maintenance instruction as valid in 2026.

Source: https://productfinder.hawe.com/downloads/B6340_NSV-en.pdf

Evidence class: `DOC-CONFIRMED` unless explicitly marked otherwise.

## What the service procedure actually proves

The manual is unusually useful because it is not generic hydraulic advice: section 3.1.1 is an explicit replacement procedure for the ePrAX suction-valve unit.

Before replacement HAWE requires the hydraulic cylinders fully retracted and the press beam/piston rod secured in that position. The hydraulic system must be switched off and secured against unintended restart, the system must be pressureless, and the work environment clean. The broader maintenance section additionally requires pumps off, loads relieved, accumulators relieved, and protection against unintended reconnection.

For the valve replacement itself HAWE requires venting/depressurization paths through named measurement connections. Where rod-side valves are disassembled, the rod side must also be depressurized; the slow-up option adds another relief path. The procedure then explicitly requires checking depressurization with a pressure gauge at M2 and, when applicable, M4 before disassembly continues.

After installing the replacement valve, control lines, cylinder block, Servo Power Module, and hoses, the final step in this component-specific replacement procedure is to bleed the hydraulic system according to the separate B 6340 assembly instructions.

These are strong physical maintenance controls. They establish that safe service preparation is not equivalent to merely commanding a valve or reading a pressure value from normal control software.

## Important boundary discovered

The B 6340 NSV replacement procedure does **not** contain a post-replacement individual load-retention challenge, drift criterion, test load, test duration, dynamic stopping-distance test, or production-restart authorization. It explicitly identifies the ePrAX hydraulic product as partly completed machinery controlled through the machine/plant controller and instructs the reader to follow the machine manufacturer's operating instructions.

Therefore the absence of a machine-level proof sequence in this component manual must not be interpreted as evidence that none is required. It establishes a documentation/authority boundary instead:

`COMPONENT REPLACEMENT PROCEDURE COMPLETE != MACHINE SAFETY FUNCTION REVALIDATED != PRODUCTION AUTHORITY`

and:

`BEAM MECHANICALLY SECURED FOR SERVICE != RETAINING VALVE FUNCTION PROVED`

`PRESSURE GAUGE CONFIRMS DEPRESSURIZED SERVICE STATE != POST-REPAIR LOAD RETENTION PROVED`

`HYDRAULIC SYSTEM BLED != INDIVIDUAL VALVE PROVED != STOPPING PERFORMANCE PROVED`

## Evidence classification

### DOC-CONFIRMED

- The serviced product is a suction-valve unit used in HAWE ePrAX modular CNC press-brake controls.
- Before replacement the cylinders are fully retracted and the press beam/piston rod is secured.
- The system is shut down, protected against unintended restart, and made pressureless.
- Rod-side and optional slow-up circuits have explicit depressurization paths.
- Pressure-gauge verification is required before disassembly continues.
- The replacement procedure ends with reassembly and bleeding according to B 6340.
- The component is partly completed machinery and HAWE directs the integrator/operator to the machine manufacturer's instructions.

### INFERENCE

- The component manual intentionally stops at the component/integration boundary; machine-level return-to-service proof belongs to the complete-machine safety lifecycle rather than being safely inferred from successful mechanical replacement alone.

### UNKNOWN — preserve

- Whether a particular complete ePrAX press brake must automatically run a stopping/start-up test after this NSV replacement.
- Whether the NSV is a load-retaining safety element in every ePrAX machine configuration.
- Whether a particular OEM requires an individual unmasked static retention challenge after NSV replacement.
- Test load, allowable drift, duration, pressure thresholds, stopping thresholds, PL/SIL/DC, or production-release sequence for any specific machine.

## Curriculum consequence

Freeze the following proof ladder for hydraulic service lessons:

`HAZARD PHYSICALLY CONTROLLED FOR SERVICE -> CIRCUIT DEPRESSURIZATION PHYSICALLY VERIFIED -> COMPONENT REPLACED/REASSEMBLED -> HYDRAULIC SYSTEM BLED -> MACHINE-SPECIFIC SAFETY FUNCTIONS REVALIDATED -> SAFETY REARM -> FRESH PRODUCTION INITIATION`

Only the first four stages are established by this HAWE component-service document. The remaining stages require complete-machine/OEM evidence.

This is a useful human-factors lesson as well: a maintenance procedure should make the physical safe-service state explicit and verifiable before a wrench is applied. Normal-control indications are not a substitute for restraint, isolation, pressure relief, and an appropriate physical witness.

## Next evidence target

Follow the reference into the complete-machine/integrator layer rather than repeatedly searching the component manual. Prefer an ePrAX-equipped OEM press brake, HAWE B 6340 commissioning material, or another authoritative complete-machine procedure that explicitly joins final-element replacement to functional safety revalidation and production release. Continue to seek an unmasked individual retaining-element proof, but do not manufacture one from this source.