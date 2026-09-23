# 2580 — Hydraulic and pneumatic safety — source preparation

## Scope

2580 begins from a different premise than electrical drive safety: removing an electrical command does not necessarily remove fluid power, stored pressure, gravity energy, trapped volume, accumulator energy, or a load's ability to move.

The machine-level reasoning chain remains:

`command -> safety-related control -> valve/final element -> fluid path -> pressure/flow/load state -> physical safe-state proposition`

Evidence at one layer must not silently substitute for the next.

## Initial source-confirmed architecture anchors

### Hydraulic area shutoff / decompression

**DOC-CONFIRMED:** Bosch Rexroth's STOM standardized hydraulic STO manifolds are intended as area shutoff devices for presses and other hydraulic systems. The manufacturer states that variants are available for ISO 13849 architectures up to Cat 4 / PL e and that the product provides leakage-free shutoff in the main P1-to-P2 line. The manufacturer also reports closing times under 300 ms in most operating conditions, dependent on system pressure and oil viscosity.

Teaching boundary: a documented manifold closing time is component/application evidence under stated conditions. It is not a universal press stopping time, safe distance, cylinder stop time, pressure-decay time or proof that every trapped downstream volume is depressurized.

### Press control as a system, not a loose valve

**DOC-CONFIRMED:** Parker's PPCC press-control safety information states that the press control is intended for hydraulic presses under specified press standards and must be used with an active protective device and electrical safety controller; its documented safety claim is therefore conditional on system integration rather than the valve block being a stand-alone machine safety solution.

Teaching boundary: **SAFETY-RATED/MONITORED HYDRAULIC COMPONENT != COMPLETE MACHINE SAFETY FUNCTION.**

### Load holding and hose failure

**DOC-CONFIRMED:** Parker describes counterbalance valves as load-holding devices used for overrunning-load control and hose-failure protection; with no pressure applied to the relevant ports, the described valve holds the load. Bosch Rexroth likewise documents load-lowering valve modules mounted close to boom cylinders for hose-failure protection in suspended-load applications.

Teaching boundary: load-holding architecture addresses a different proposition from upstream pump shutdown or directional-command removal. Whether a particular valve can safely hold a particular axis depends on its actual design, setting, installation, load, leakage/failure assumptions and required integrity.

### Hydraulic load holding is a distinct function

**DOC-CONFIRMED:** HAWE describes load-holding valves as pressure-control valves that prevent uncontrolled cylinder/motor load descent, with variants intended to close tightly and prevent leakage.

Teaching boundary: a blocked/closed directional valve or stopped pump must not be assumed to provide equivalent load-holding behavior unless the circuit and component evidence establish that proposition.

## First-principles hazard inventory

A hydraulic or pneumatic axis may remain hazardous after command removal because of:

- gravity acting on a vertical or over-center load;
- trapped pressure between closed valves and an actuator;
- accumulators or compliant volumes storing energy;
- load-induced pressure;
- a valve spool stuck or failed in a flow-producing position;
- internal/external leakage causing drift;
- hose or fitting failure changing the intended flow path;
- cross-port pressure or regeneration paths;
- a mechanical load that can move even after supply pressure is removed;
- pneumatic compressed volume downstream of a dump valve; or
- maintenance activity that opens a circuit believed to be depressurized.

These are architecture questions before they are calculation questions.

## Initial physical-proposition map

| Evidence/state | Proposition it may support | It does NOT by itself prove |
|---|---|---|
| Pump motor de-energized | pump drive command/energy source removed | trapped pressure gone; gravity load held; cylinder stopped |
| Directional valve commanded neutral | controller requested neutral state | spool physically centered; safe flow path exists; load held |
| Valve-position monitor reports safe position | covered valve element reached monitored position | downstream pressure zero; actuator mechanically restrained; all parallel paths safe |
| Main pressure line shut off | upstream supply path isolated under documented conditions | downstream stored energy exhausted; load cannot move |
| Dump/exhaust valve actuated | exhaust/decompression path commanded | residual pressure below a safe threshold at the hazard point |
| Counterbalance/load-holding valve closed | documented load-holding path is closed | universal integrity; zero drift forever; maintenance isolation |
| Pressure sensor reads low at one point | pressure is low at that measurement point within sensor evidence | all trapped volumes are low; mechanical load is blocked |
| Mechanical block/restraint correctly installed | physical motion path is restrained within its design basis | hydraulic pressure absent or maintenance isolation complete |

## Initial freezes

- **PUMP OFF != HYDRAULIC ENERGY GONE.**
- **VALVE COMMANDED SAFE != VALVE PHYSICALLY SAFE.**
- **VALVE POSITION SAFE != DOWNSTREAM PRESSURE PROVED SAFE.**
- **SUPPLY SHUTOFF != TRAPPED ENERGY EXHAUSTED.**
- **DUMP COMMANDED != RESIDUAL PRESSURE PROVED SAFE.**
- **DIRECTIONAL NEUTRAL != GRAVITY LOAD HELD.**
- **PRESSURE LOW AT ONE SENSOR != ALL HAZARDOUS VOLUMES DE-ENERGIZED.**
- **ELECTRICAL STOP != HYDRAULIC/MECHANICAL SAFE STATE.**
- **FUNCTIONAL FLUID-POWER SAFE STATE != MAINTENANCE ENERGY ISOLATION.**

## Press-brake boundary

2580 may use a press-brake axis as a teaching example, but it must not invent an OpenPressBrake machine-specific hydraulic truth table. A press brake can combine gravity/load energy, pump/supply energy, trapped cylinder volumes, valve states, mechanical structure and synchronization/control hazards. The exact safe-state path is circuit- and machine-specific.

Ordinary LinuxCNC/FPGA control may request motion, stop, or inhibit and may display diagnostics. Personnel-safety authority remains in the independent safety-related architecture and the physical hydraulic/mechanical final elements justified for the machine.

## Required next work

1. Build a generic hydraulic press/vertical-axis fault tree beginning at the physical proposition `hazardous closing/descent prevented` and work backward through load holding, supply isolation, exhaust/decompression, monitored valve state and electrical safety control.
2. Distinguish blocked-center, shutoff, dump-to-tank/decompression and load-holding functions without pretending any one schematic is universal.
3. Add accumulator/trapped-volume and hose/cylinder failure branches.
4. Add the pneumatic analogue: safe exhaust, downstream trapped volume, gravity loads and restart/repressurization.
5. Identify which hazards can be addressed electrically and which require fluid-power or mechanical measures.
6. Keep pressure thresholds, stopping times, valve truth tables, diagnostic coverage, PL/SIL and load capacity UNKNOWN unless applicable evidence is supplied.

## Source provenance

- Bosch Rexroth, `STO manifolds STOM — Functional safety out of the box`, 2024-10-22.
- Parker Hannifin, `PPCC Press Control` catalogue/safety information, MSG11-3362/UK.
- Parker Hydraulic Cartridge Systems, E2 Series Counterbalance Valve application material.
- Bosch Rexroth Oil Control, check/metering valves for hose-failure/load-lowering systems.
- HAWE Hydraulik, mobile hydraulics/load-holding valve product guidance.

Claims above are DOC-CONFIRMED unless explicitly labeled otherwise. No physical machine test has been performed.