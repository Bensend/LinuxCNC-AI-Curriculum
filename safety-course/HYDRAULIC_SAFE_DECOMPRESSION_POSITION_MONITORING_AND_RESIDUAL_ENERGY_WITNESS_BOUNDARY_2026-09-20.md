# Hydraulic safe decompression, position monitoring, and residual-energy witness boundary

Date: 2026-09-20
Course: 4000 safety / professional machine implementation

## Question

After the Lane-B servo-hydraulic acceptance study, what can authoritative hydraulic-manufacturer evidence actually prove about the chain from a safety demand to removal/control of hazardous hydraulic energy, and what still requires machine-specific physical acceptance?

## Evidence

### Bosch Rexroth standardized hydraulic safety manifold

**DOC-CONFIRMED.** Bosch Rexroth describes standardized safety manifolds with three distinct hydraulic safety functions. Its STO implementation uses two-channel, position-monitored blocking between P1 and P2. Its Safe Decompression (SDE) function instead uses dual bypass valves and flow-limiting nozzles to drain downstream pressure in a controlled manner. Rexroth gives an application/product performance statement that downstream pressure is drained in under 300 ms in most applications; that statement is not an OpenPressBrake acceptance criterion and must not be copied into a different machine.

Source: Bosch Rexroth, “Safety Solved: How STO Manifolds Deliver Critical Machine Protection Without the Engineering Headaches,” 2026, https://www.boschrexroth.com/en/us/blog/ih/safety-solved-how-sto-manifolds-deliver-critical-machine-protection-without-the-engineering-headaches-us/

### HAWE press and valve-monitoring evidence

**DOC-CONFIRMED.** HAWE identifies press-brake safety requirements including reliable holding of the press beam, short switching/overtravel behavior, and safe monitoring of individual functions. HAWE separately defines switching-position monitoring as monitoring the valve switching element itself, commonly with proximity sensors or displacement transducers, and names press safety valves as a typical application.

Sources:
- HAWE Hydraulik, “Press brakes,” https://www.hawe.com/en-us/applications/manufacturing-efficiency/press-brakes/
- HAWE Hydraulik Fluid Lexicon, “Switching position monitoring,” https://www.hawe.com/nl-nl/fluid-lexicon/detail/switching-position-monitoring/

### Parker maintenance / measurement evidence

**DOC-CONFIRMED.** Parker’s hydraulic-valve safety guide requires system checkout/functional testing after installation/service and says pressure/flow adjustments are to be made using pressure gauges and/or flow meters (or actuator-speed observation where applicable). This supports a general physical-measurement principle but does not define a safety acceptance test for an OpenPressBrake hydraulic circuit.

Source: Parker Hannifin Hydraulic Valve Division, Safety Guide for Selecting and Using Hydraulic Valves and Related Accessories, current web edition retrieved 2026-09-20.

## Engineering synthesis

The evidence supports a stronger witness decomposition than a generic `hydraulics_safe` state:

`protective/safety demand`
`-> safety logic output`
`-> redundant hydraulic element commanded`
`-> monitored switching element reaches expected position`
`-> pressure/flow path changes as designed`
`-> hazardous downstream pressure/energy changes`
`-> physical load/ram response is acceptable`
`-> quantitative machine criterion passes`
`-> restart/rearm conditions are separately satisfied`

Each arrow is a possible evidence boundary.

### Freeze 1 — valve position is not residual-energy proof

**DOC-CONFIRMED + INFERENCE:** A monitored spool/poppet position is evidence about the switching element. Rexroth treats blocking and decompression as distinct functions, so position confirmation of a blocking element must not be silently interpreted as proof that downstream trapped pressure has been removed.

**VALVE SAFE POSITION CONFIRMED != DOWNSTREAM PRESSURE/ENERGY REMOVED.**

### Freeze 2 — safe decompression is a physical energy-state function

**DOC-CONFIRMED:** Rexroth's SDE description explicitly targets downstream pressure drainage through a separate controlled path. Therefore an architecture that needs safe decompression must validate the decompression function, not merely infer it from electrical command state.

**DECOMPRESSION COMMANDED != DECOMPRESSION PATH OPEN != DOWNSTREAM PRESSURE ACCEPTABLY REDUCED.**

### Freeze 3 — generic manufacturer timing is not machine acceptance

**DOC-CONFIRMED:** Rexroth's “under 300 ms in most applications” is a product/application statement, not a universal machine safety limit.

**MANUFACTURER TYPICAL/PERFORMANCE STATEMENT != MACHINE-SPECIFIC ACCEPTANCE LIMIT.**

OpenPressBrake decompression time, residual-pressure threshold, measurement point, load condition, oil temperature/viscosity condition, allowable ram movement, holding criterion, stopping criterion, and required PL/SIL remain **UNKNOWN**.

### Freeze 4 — holding and decompression are not interchangeable

**DOC-CONFIRMED + INFERENCE:** HAWE identifies reliable beam holding as a press-brake safety concern, while Rexroth separately exposes blocking and decompression functions. A machine may need to prevent motion by retaining/blocking energy in one state and deliberately remove pressure in another. The correct behavior is circuit- and hazard-specific.

**LOAD HELD != HAZARDOUS PRESSURE REMOVED.**

**PRESSURE REMOVED != LOAD MECHANICALLY/HYDRAULICALLY RETAINED.**

Do not create a generic rule that “zero pressure is always safe” for gravity axes or that “valves closed is always safe” for stored-pressure hazards.

## Practical curriculum acceptance pattern

For a future real hydraulic machine, the acceptance record should name the required physical witness rather than recording a single Boolean. Depending on the hazard analysis, evidence may include:

- commanded safety state;
- each monitored valve-element state;
- pressure upstream/downstream at explicitly identified measurement points;
- physical ram/load motion or retention;
- elapsed time or stopping/holding performance when quantitatively required;
- mismatch/fault reaction;
- reset/restart inhibition while the required physical state is absent.

This is a curriculum scaffold, **INFERENCE**, not an OpenPressBrake test specification.

## Human-factors implication

Diagnostics should expose the witness that failed: e.g. `valve 2 position mismatch`, `downstream pressure not relieved`, or `load motion exceeded acceptance`, rather than only `SAFETY FAULT`. Clear localization makes correct repair easier and discourages defeating a safeguard merely to make an opaque fault disappear.

## Information-gain disposition

This source pass materially strengthens the distinction between hydraulic element position and actual residual-energy state, but it still does **not** provide the complete desired OEM chain from protective demand through monitored valve position, pressure/motion/holding witness, quantitative machine acceptance, repair/replacement retest, and production release.

The hydraulic sub-branch is now close to a source-availability stop for generic component/manifold documentation. Continue only if an authoritative machine/OEM acceptance procedure exposes the missing physical chain. Otherwise rotate to another open 4000 safety branch rather than inventing a hydraulic truth table.

No simulation or executable test was justified. No GitHub-hosted compute was used.
