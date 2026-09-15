# 3300 cross-process gantry cutting playbook — 2026-09-15

Status: synthesis after bounded plasma, laser, and waterjet breadth/deep passes.

## Purpose

Unify what genuinely transfers across plasma, laser, and waterjet without erasing process-specific physics. This artifact is an architecture playbook, not a claim that all three processes share one state machine.

## 1. Reusable machine skeleton

All three process families can be decomposed into the same outer ownership layers:

1. **trajectory / gantry geometry** — X/Y, tandem joints where applicable, nominal Z, optional rotary/head axes;
2. **process command** — requested on/off plus requested power/current/pressure/recipe values;
3. **process readiness** — independent evidence that the energy/process source is actually able to cut;
4. **height / focus / standoff authority** — process-specific correction layered around nominal geometry;
5. **recipe / CAM authority** — material, feed, kerf, pierce, feature and process parameters;
6. **recovery authority** — pause, abort, cut recovery, restart and state reconstruction;
7. **safeguarding / hazardous-energy isolation** — independent of ordinary LinuxCNC process logic.

The reusable rule is:

`motion command != process command != process-ready witness != height/focus feedback != recipe identity != recovery state != safety state`.

## 2. What gantry/motion logic can genuinely be shared

Reusable across the family:

- Cartesian XY trajectory planning;
- tandem-gantry joint homing/squaring patterns;
- soft limits and machine envelope;
- nominal Z motion;
- synchronized digital/analog output semantics (M62/M63/M67) where the process uses them;
- immediate output semantics (M64/M65/M68) where intentional;
- path blending and velocity behavior;
- machine coordinate / work coordinate separation;
- operator state for run/pause/abort;
- generic breakaway/collision input plumbing where hardware semantics are explicitly defined.

Do **not** share a process-ready bit merely because every machine needs one. Its physical meaning differs by process.

## 3. Plasma contract

Plasma has the richest first-class LinuxCNC process implementation through QtPlasmaC/`plasmac.comp`.

### Distinct plasma authorities

- IHS/probe contact and probe validity;
- pierce-height positioning;
- Torch On request;
- Arc OK / transfer confirmation;
- pierce delay and optional puddle jump;
- cut-height transition;
- THC qualification;
- arc-voltage feedback;
- corner/void/small-feature THC inhibition;
- arc-start failure / arc loss;
- torch-off and retract;
- breakaway/probe faults;
- external Z-offset request and applied correction;
- cut recovery/run-from-line reconstruction;
- optional Powermax RS485 command/telemetry health.

### Plasma-specific lesson

QtPlasmaC's process richness must not become the template for the other processes. In particular, Arc OK and arc-voltage THC are plasma concepts. Even when a laser retrofit reuses QtPlasmaC surfaces, renamed or synthetic signals remain compatibility layers, not evidence that laser physics acquired plasma semantics.

## 4. Laser contract

LinuxCNC has native realtime laser primitives (`laserpower.comp`, `raster.comp`, synchronized outputs) but no equally complete upstream production process manager was found in the bounded pass.

### Distinct laser authorities

- source enable;
- source READY and FAULT;
- modulation/gate versus source-enable state;
- requested power;
- actual velocity and requested velocity for energy-density scaling;
- assist-gas command/readiness where applicable;
- chiller/flow/temperature readiness where applicable;
- focus or capacitive height control for metal-cutting machines;
- vector versus raster mode;
- raster pixel/position ownership;
- pierce strategy for cutting lasers;
- enclosure/exhaust/head-collision state.

### Laser-specific lesson

`laserpower.comp` demonstrates that commanded energy should account for actual path velocity, especially through deceleration/corners. A static spindle-like PWM model is insufficient for many laser processes.

The real Sector67 Raycus integration further shows that source enable, analog power, modulation and READY are distinct physical surfaces. A compatibility `Arc OK` or synthetic ohmic input used to satisfy QtPlasmaC does not become a real laser readiness witness.

CO2 vector cutting, fiber sheet-metal cutting, and raster engraving must remain separate subarchitectures.

## 5. Waterjet contract

The bounded survey found real LinuxCNC waterjet retrofits but no upstream process controller comparable to QtPlasmaC. Preserve this as a source gap, not a claim that no community controller exists.

### Evidence-backed distinct authorities

- water/nozzle command;
- abrasive command;
- nominal Z versus cutting-height/standoff correction;
- pump/high-pressure system as a separate machine subsystem;
- water-only versus abrasive process selection;
- hazardous high-pressure energy isolation independent of ordinary controller state.

### Process-sequence caution

Public/vendor evidence shows multiple legitimate pierce strategies, including low-pressure piercing and abrasive/water timing variants. Therefore do not encode a universal `water first -> abrasive second` sequence.

The missing high-value public contract remains:

`pump request -> pressure transition -> pressure-ready/fault -> water/abrasive transaction -> cut authorization -> pause/abort recovery`.

Until inspectable LinuxCNC field evidence exists, this must remain a bounded unknown rather than being copied from plasma.

## 6. CAM and recipe boundary

### Common CAM-owned intent

Usually upstream or strongly CAM-influenced:

- nesting and part order;
- lead-in/out geometry;
- kerf side/compensation strategy;
- small-hole/small-feature treatment;
- pierce location/entry strategy;
- feed schedule;
- bevel/taper toolpath where applicable;
- emitted process-selection and synchronized-output commands.

### Controller-owned execution

LinuxCNC/machine integration owns or may own:

- actual coordinated trajectory;
- synchronized output application;
- process readiness and faults;
- realtime height/focus loops;
- machine-specific recipe activation;
- physical recovery and operator diagnostics.

### Proven plasma example

QtPlasmaC material selection and generated M-codes show that CAM and controller can share recipe responsibility. M190 material identity, M62/M63 process inhibits and M67 velocity changes become part of the executable state that restart/run-from-line must reconstruct.

## 7. Recovery model

A generic `resume motion` is not sufficient for any of these processes.

Before restart, reconcile at least:

- current nominal trajectory location;
- active recipe/material identity;
- process source command;
- actual source readiness;
- height/focus/standoff state;
- queued versus already-applied synchronized outputs;
- auxiliary gas/abrasive/water state;
- external offsets/corrections;
- whether a new pierce is physically required;
- whether the previous process failure damaged consumables/nozzle/lens/material enough to require operator intervention.

QtPlasmaC Run From Line is the strongest first-class example because it reconstructs relevant interpreter/process state rather than merely seeking a line number. That principle transfers; its exact plasma states do not.

## 8. Synchronized output rule

Across plasma/laser/waterjet, M62/M63/M67 are trajectory-coupled state changes, while M64/M65/M68 are immediate. A queued synchronized change needs a following motion boundary to apply. End-of-program or abort cleanup therefore needs explicit ownership rather than assuming a queued final value will execute.

This is especially important for:

- laser power/gate;
- plasma THC inhibit / velocity-reduction features;
- future water/abrasive timing if implemented through synchronized outputs.

## 9. Height/focus architecture

Do not unify the feedback variable:

- **plasma:** IHS establishes material reference; arc-voltage THC modifies Z through qualified external-offset behavior;
- **fiber/metal laser:** capacitive head height/focus may be the process variable; source READY and optical power are separate;
- **CO2/raster laser:** height may be fixed or independently managed, while power/position synchronization dominates;
- **waterjet:** standoff/head-height and collision protection are separate from pump pressure and abrasive state.

Reusable implementation pattern: keep nominal path and process correction distinct, and make correction enable/qualification/fault/reset explicit.

## 10. Diagnostics minimum

A production HMI should avoid one generic green `PROCESS OK` lamp. Show separate surfaces where available:

- requested process state;
- actual readiness/transfer/source state;
- active recipe/material;
- commanded and measured process value;
- height/focus correction enabled/qualified/applied;
- communication health for non-realtime source links;
- probe/breakaway/head collision state;
- auxiliary gas/water/abrasive state;
- current recovery/restart eligibility;
- latched reason for process stop.

## 11. Safeguarding boundary

Normal LinuxCNC HAL/G-code/process state is not automatically a safety-rated layer.

Plasma high voltage/current, laser optical hazards, and waterjet extreme pressure each require hazard-appropriate guarding, interlocks and energy isolation independent of ordinary process software. A software READY bit or communications status must not be promoted into a safety claim without a real safety architecture.

## 12. Promotion / future reopen criteria

3300 has enough evidence for a durable cross-process architecture foundation and should not be over-mined broadly.

Reopen specific branches when evidence can close one of these material gaps:

- **plasma:** a real unresolved external-offset/recovery defect or materially different field implementation;
- **laser:** inspectable production source with source READY/FAULT, gas/chiller/focus/pierce and abort recovery, or a concrete raster boundary defect;
- **waterjet:** inspectable pump/pressure-ready plus water/abrasive timing and recovery implementation;
- **W2:** only after a 3-axis waterjet process contract is evidence-backed, then dual-head / 5-axis / taper compensation;
- **cross-process:** only when new evidence changes an ownership boundary rather than merely adding another machine example.

No lab is justified by this synthesis alone.
