# 25E0 — Validation Template Physics Stress Test

Date: 2026-09-21
Status: curriculum stress test; examples are deliberately incomplete and are **not validated machine designs**

## Question

Which validation-record fields are reusable across machines, and where must the method branch because the physics differ?

## Case A — hydraulic / gravity-loaded vertical axis

### Hazard proposition set

A hypothetical vertical hydraulic axis may require distinct propositions such as:

1. protective demand was received by independent safety authority;
2. hazardous hydraulic supply path reached its required final-element state;
3. downstream/trapped energy reached the required condition;
4. hazardous axis motion reached the required condition;
5. a gravity load is retained where required;
6. reset/rearm history is valid;
7. ordinary LinuxCNC motion demand is fresh before motion is allowed again.

The exact valve topology, pressure limits, stopping time, speed, retention mechanism and performance level are `UNKNOWN` until the actual design supplies them.

### Why the generic matrix survives

The authority/energy-chain, proposition-to-witness, timing, fault-injection, rearm/freshness, temporary-state and modification-impact sections all remain useful.

### Where physics forces specialization

- A valve-position witness may establish represented spool/valve position but not downstream pressure or ram motion.
- An upstream pressure sensor cannot prove absence of trapped pressure in an isolated downstream volume.
- Zero encoder speed is instantaneous motion evidence, not proof that a gravity load will remain retained.
- Removing drive/valve energy immediately may be unsafe on some gravity axes if controlled torque/pressure must persist until a retaining element is established. Therefore `fault => remove every energy source immediately` is not a generic acceptance rule.
- Mechanical/hydraulic modifications can invalidate prior stopping or retaining evidence without changing safety software.

### Required disagreement tests to design safely

The record should demand bounded tests for: valve safe-position indication while downstream energy remains; motion witness at zero while retaining capability is unavailable; one redundant final element failing to transition; pressure witness loss; and Start/Jog held through a safety interruption. These are test requirements, not instructions to create dangerous faults on an energized exposed machine.

### Acceptance boundary

A generic record cannot accept this machine until actual circuit drawings, component safety manuals, hazard analysis and physical commissioning define the required propositions and quantitative criteria. If gravity retention or downstream-energy state cannot be demonstrated, personnel exposure is not acceptable.

## Case B — rotating spindle / rotary table

### Hazard proposition set

A hypothetical spindle/table safety function may require distinct propositions such as:

1. protective demand was received by independent safety authority;
2. torque-producing capability reached the required safety state or controlled-stop state;
3. rotational speed/deceleration/standstill met the required physical criterion;
4. stored kinetic energy/hazardous coast-down has been accounted for before access where required;
5. a brake/retaining function, if the machine relies on one, has the required state/capability;
6. reset/rearm history is valid;
7. ordinary spindle-start/jog/orient demand is fresh before restart.

Exact speed limits, stop times, inertia/load envelope, guard distance, brake capability and safety-performance targets are `UNKNOWN` until the actual machine supplies them.

### Authoritative implementation evidence

Rockwell's ArmorKinetix Safe Monitor Functions Safety Reference Manual contains function-specific validation checklists for safe-motion functions and calls for I/O verification before safety-logic validation. Rockwell's SLS documentation states that SLS monitors motor/axis speed and that exceeding the active limit can initiate an application-specific action such as STO, SS1 or SS2. Rockwell's safe-motion function summary distinguishes SLS, safe operating stop, SS1 and SS2 rather than treating `drive safe` as one undifferentiated state.

Evidence classification: `DOC-CONFIRMED` for those product/function semantics. They do not establish the thresholds for this hypothetical spindle/table.

### Why the generic matrix survives

Again the same record structure works: authority chain, physical proposition, witness authority, timing endpoints, disagreement injection, restart history, temporary states and modification impact.

### Where physics forces specialization

- STO/status can establish only its documented drive safety state; it does not establish zero rotational speed.
- A speed/position witness can establish represented motion but not automatically the state/capability of a mechanical brake.
- A spindle with high inertia may remain hazardous after torque production is removed; access timing therefore depends on physical motion/energy evidence, not just output transition time.
- A rotary table may require retention against gravity or process load while a horizontal spindle may not; the same record therefore cannot require a universal brake proposition.
- Tooling, chuck/workholding, inertia and mechanical changes may alter physical stopping behavior without changing controller configuration.

### Required disagreement tests to design safely

The record should require applicable cases such as: drive safe-state/status true while the rotor is still coasting; safe-motion witness disagreement/loss; commanded stop whose measured deceleration does not satisfy the machine-specific criterion; brake/status disagreement if a brake is safety-relevant; and a spindle Start command held across guard interruption and rearm.

### Acceptance boundary

A safe-drive status alone cannot authorize access where hazardous rotation may remain. Conversely, measured zero speed alone does not prove every other required hazard-control proposition. The machine-specific safety requirements determine which conjunction is actually required.

## Cross-case result

### Reusable methodology

The following survive both physics domains:

- identify the physical hazard and safe-state proposition before naming signals;
- keep independent safety authority separate from ordinary LinuxCNC/FPGA control;
- trace protective input -> safety logic -> final element -> physical process -> witness;
- type each witness by what it can and cannot prove;
- measure timing to the physical endpoint when the endpoint matters;
- inject disagreement between evidence classes;
- validate reset/rearm and ordinary-demand freshness as history-dependent behavior;
- remove/verify temporary commissioning states;
- revalidate after changes that can invalidate the physical evidence chain;
- block personnel exposure when a required physical proposition remains safety-critical `UNKNOWN`.

### Machine-physics branches

The template must **not** standardize:

- what constitutes the safe physical state;
- which energy paths require removal, controlled dissipation or temporary retention;
- whether a brake/retaining element is required;
- pressure, speed, position, time, force or torque thresholds;
- sensor placement and whether a witness observes the relevant trapped-energy region;
- stopping/load/inertia envelope;
- PL/SIL/category/diagnostic-coverage claims;
- the correct energized fault-injection procedure.

## New curriculum freezes

- `ENERGY REMOVED AT SOURCE != STORED PROCESS ENERGY SAFE`.
- `TORQUE REMOVED != ROTATION STOPPED`.
- `ROTATION STOPPED != RETAINING CAPABILITY PROVED`.
- `PRESSURE MEASURED SAFE AT ONE POINT != ALL HYDRAULIC VOLUMES SAFE`.
- `SAME VALIDATION TEMPLATE != SAME PHYSICAL ACCEPTANCE CRITERIA`.
- `GENERIC METHODOLOGY MAY BE REUSABLE; MACHINE PHYSICS MAY NOT BE ABSTRACTED AWAY`.

## Next curriculum question

Stress the record against **maintenance/bypass human factors**: how temporary bypasses, force states, service keys, test jumpers, simulated witnesses and nuisance-trip workarounds are authorized, made conspicuous, prevented from becoming normal production practice, physically cleared, and revalidated before personnel exposure. Prefer professional safety-controller/commissioning guidance with explicit bypass/override lifecycle semantics over generic warnings.