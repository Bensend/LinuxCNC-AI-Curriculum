# 25D0 — Low-cost safety architectures: entry and comparison contract

## Mission

Develop educational reference architectures that maximize practical risk reduction per dollar without laundering inexpensive components into unsupported certification claims. Every architecture is evaluated as an end-to-end safety function: input/device -> safety-related logic -> final element -> physical machine state -> reset/restart behavior.

## Required comparison fields

Every 25D0 reference architecture must state:

- hazards addressed;
- hazards explicitly not addressed;
- lifecycle/mode boundary;
- assumed supply, load and environment;
- physical safe-state proposition;
- single faults detected;
- single faults not detected or potentially latent;
- common dependencies/common-cause vulnerabilities;
- reset/rearm behavior;
- power-loss and power-restoration behavior;
- restart behavior;
- final-element feedback/diagnostic proposition and its limits;
- maintenance-isolation boundary;
- approximate parts-cost class with date/source when actual prices are used;
- what the next cost tier buys in physical fault tolerance/diagnostics/usability;
- formal-rating/certification gap;
- UNKNOWN application facts requiring machine-specific evidence.

Freeze: **LOW COST != LOW RIGOR.** A cheaper architecture may address fewer faults, but those limits must be explicit.

Freeze: **MORE COMPONENTS != MORE SAFETY.** Added parts only matter when they close a named failure path without creating an equally important dependency or usability defect.

Freeze: **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM.**

Freeze: **POWER REMOVED FROM A CONTROL COIL != ALL HAZARDOUS ENERGY REMOVED.**

## Architecture ladder

The learner should compare at least these educational tiers, without treating them as universal designs:

### Tier A — single NC E-stop / single final switching path

Purpose: expose the benefits and limits of de-energize-to-trip and broken-wire behavior at minimal cost.

Must analyze: welded/stuck final contact, broken input wire, coil power loss, reset/restart behavior, and why one switching path does not tolerate every dangerous single fault.

### Tier B — dual-channel input with safety relay/module and monitored restart

Purpose: add channel disagreement/cross-fault diagnostics where the selected module/application supports them and intentional reset behavior.

Must analyze: common supply/wiring dependencies, input-device mechanical common cause, reset faults, and the difference between module diagnostic claims and final-element physical state.

### Tier C — redundant final switching paths with EDM/feedback

Purpose: address a dangerous single welded/stuck final element through redundancy plus appropriate monitoring.

Must analyze: what the feedback contacts actually witness, diagnostic timing, common-cause power/wiring/mechanical faults, switching duty, and restart inhibition after detected failure.

### Tier D — drive STO plus appropriate external energy control

Purpose: use certified/integrated drive safety where available while retaining machine-specific treatment of coast, gravity, stored energy, electrical isolation and maintenance.

Must analyze: STO versus standstill, STO versus isolation, braking/gravity axes, external contactor purpose if present, and proof required before guard release.

### Tier E — fluid-power enable/dump/load-holding architecture

Purpose: show why electrical control alone cannot establish every hydraulic/pneumatic safe state.

Must analyze: supply isolation, trapped energy/decompression, stuck valves, downstream pressure, gravity/load holding, hose/cylinder failure and maintenance restraint.

## Cost reasoning rule

Do not optimize for BOM price alone. Compare `incremental cost -> named failure path closed -> residual failure paths -> usability/maintenance consequence`. A $20 change that removes a major single-point failure can be more valuable than a much more expensive diagnostic feature that does not address the dominant hazard; the reverse can also be true. The architecture must show the reasoning rather than claim a universal best tier.

## Human-factors carry-forward

Every tier inherits 25C0: reset location, diagnostics, nuisance-trip behavior, guard restoration and legitimate setup/recovery must be usable enough that bypass is not predictably rewarded. A low-cost architecture that is routinely defeated is not a successful low-cost architecture.

## Evidence discipline

Use manufacturer application manuals and applicable standards guidance for concrete architectures. Preserve `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN` labels. Do not invent contact ratings, B10d, PFHd, stopping times, valve behavior or integrity targets.

## Next work

Build the first comparative table for Tiers A-C using authoritative safety-relay/contactor documentation already traced in 2530-2550. For each tier, enumerate broken wire, welded contact, stuck input, reset fault, power loss/restoration and common-cause outcomes. Then add representative parts-cost classes only from current traceable sources and explain what each incremental cost actually buys.