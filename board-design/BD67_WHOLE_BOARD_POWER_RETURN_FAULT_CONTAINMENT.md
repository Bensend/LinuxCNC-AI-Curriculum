# BD67 — Whole-Board Power/Return Graph and Fault-Containment Reconciliation

Status: student-ready method lesson with audited bounded OpenPressBrake machine-power example  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `324892fac20cc81ca9a3ae00a89e88607d17fc41`

## Purpose

BD66 established that a complete schematic needs semantic net reconciliation beyond ERC. BD67 applies the same adversarial method specifically to energy flow. A board is not power-closed because every IC has a supply symbol and a current subtotal exists.

The flow is:

`accepted semantic net graph -> rail/source tree -> load allocations -> normal return graph -> transient/fault return graph -> enable/startup dependencies -> fault-containment boundaries -> board power acceptance`

Central rule: **A POWER BUDGET IS NOT A POWER ARCHITECTURE.** Current arithmetic is valid only after source ancestry, return paths, operating modes, startup dependencies and fault paths are explicit.

## Learning objectives

The student can:

1. construct a source/rail tree without double-counting child rails;
2. distinguish source capacity, allocated maximum demand, measured demand and unknown demand;
3. trace normal, startup, transient and fault current as separate graphs;
4. identify return-domain collapse and protection paths that bypass intended containment;
5. reconcile enables, UVLO, sequencing, startup capacitance and watchdog/default behavior;
6. keep field-power branches separate from controller-derived rails when authority says they are separate;
7. refuse a board-power acceptance claim when one required consumer or weakest path is still unknown;
8. preserve the boundary between ordinary controller power/fault handling and independent personnel safety.

## Student-facing source audit

Every file named below was opened in its CURRENT form during this run.

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON | status truthfulness, integration versus qualification, shared-resource and maintenance rules |
| `hardware/blocks/machine_power/design/REV23_5V_RAIL_HIERARCHY_RECONCILIATION.md` | VERIFIED_FOR_LESSON | current 5-V parent/child hierarchy, known populated continuous subtotal and explicit open startup/load gates |
| `hardware/blocks/machine_power/REFERENCE_REBASE.md` | VERIFIED_FOR_LESSON | current Rev23 machine-power authority, source/return boundaries and open production gates |
| `hardware/blocks/machine_power/STATUS_CHECKLIST.md` | ENGINEERING_REVIEW_NEEDED as a complete current status/evidence index; VERIFIED_FOR_LESSON only for bounded unresolved-gate statements that remain consistent with current authority | explicit unresolved CORE load, ILIM/dVdT, field protection, PCB/current-path and release work |
| `board-design/BD66_SCHEMATIC_INTEGRATION_NET_OWNERSHIP.md` | VERIFIED_FOR_LESSON | prerequisite semantic-net ownership and cross-block reconciliation method |

The machine-power checklist still identifies itself as a Rev17 partial freeze and its evidence inventory stops at Rev17, while current `REFERENCE_REBASE.md` and Rev23 authority freeze later 5-V hierarchy/load-accounting work. Under the repository maintenance rule this is a catalog-maintenance defect. Do not use the checklist as a complete current evidence index or infer a status promotion from Rev23.

## 1. Build a source tree before adding currents

Represent every source and derived rail as a directed graph. Each node records at least:

- stable rail/source ID;
- parent source or `external`;
- nominal and allowed voltage envelope;
- conversion/filter element;
- continuous source capacity and provenance;
- startup/inrush constraint;
- enable/UVLO/default state;
- normal return domain;
- fault/transient return domain(s);
- branch protection owner;
- consumers and their evidence revisions;
- unresolved consumers or machine facts.

A filtered child rail is not a new source. A separately wired field source is not silently a child merely because it has the same nominal voltage.

## 2. Audited OpenPressBrake 5-V example

Current OpenPressBrake authority freezes one hierarchy:

`LMR36520 -> 5V_MAIN -> ANALOG_BRANCH_FILTER -> 5V_ANALOG`

`ANALOG_5V` is a legacy spelling of `5V_ANALOG`, not another source. Current repository-backed populated continuous contributions are:

- 120.10 mA preliminary on the `5V_ANALOG` child for the shared ADC/reference plus TPS65131 bipolar resource;
- 1.26 mA preliminary on `5V_ANALOG` for two LT6015 valve-position buffers;
- 13.20 mA maximum normal directly on `5V_MAIN` for four PVR6 protector pairs;
- 134.56 mA known populated continuous subtotal at the LMR36520 output after child current is rolled upstream exactly once.

This is a **known populated subtotal**, not the final regulator operating requirement. Remaining direct 5-V consumers still require audit. Startup/inrush remains a separate problem.

Reject both errors:

- adding 121.36 mA once on `5V_ANALOG` and again as an independent 5-V source load;
- omitting the child current from the LMR36520 parent because it is named differently.

## 3. Use typed load evidence

Every load entry must say what its number means. Useful types include:

- `CAPACITY_LIMIT` — what a source/component can supply, not expected consumption;
- `ALLOCATED_MAX` — conservative design allocation for a populated consumer;
- `GUARANTEED_MAX_OPERATING` — datasheet/contract-backed operating maximum;
- `PRELIMINARY_SUBTOTAL` — current closed subset, explicitly incomplete;
- `MEASURED_OPERATING` — bench/machine evidence with conditions;
- `STARTUP_OR_INRUSH` — transient startup demand;
- `VERIFY_AT_MACHINE/TBD` — unknown and not numerically substituted.

Never substitute regulator capacity for board demand. Never replace an unknown FPGA or field load with a convenient typical value merely to close arithmetic.

## 4. Separate normal, startup, transient and fault graphs

For each rail, build four views.

### Normal

`source -> protection/distribution -> load -> intended return -> source`

Use this for continuous loading, drop and thermal allocation.

### Startup

Add capacitor charging, converter soft-start, sequenced loads, enable dependencies and source current limiting. A continuous-current pass does not prove startup.

### Transient

Trace TVS/clamp/protection current to its actual return. A protection component without a verified low-impedance current loop is not a closed protection claim.

### Fault

Trace shorts, reverse energy, inductive demagnetization and branch faults through the weakest credible path. Record what opens, limits, latches or remains energized.

Do not merge these graphs simply because they share copper during normal operation.

## 5. Return domains are part of the power graph

The current OpenPressBrake authority treats ordinary non-isolated controller returns as one `CTRL_0V` electrical domain while preserving PCB current-path geometry. It separately preserves L07 switched-I/O return and requires proportional field return to bypass quiet analog/core paths. Final chassis/PE/shield EMC treatment remains an integration/release obligation.

Therefore `same electrical net` does not mean `any physical return route is acceptable`, and `different schematic label` does not prove galvanic separation.

For each high-current or noisy branch identify:

- outgoing source path;
- normal return path;
- fault return path;
- transient/clamp return path;
- sensitive regions it must not traverse;
- chassis/PE interface if any;
- evidence for the physical implementation.

## 6. Keep separately sourced field power separate

Current OpenPressBrake authority identifies `PVR_SENSOR_24V` as separately sourced from L6/L06 and outside the TPS26633 CORE load budget. `PROP_FIELD_24V` and L7/L07 field-load current are likewise outside the CORE ILIM boundary.

Do not pull these branches behind the logic eFuse merely to make a tidy tree. Board integration must preserve source authority and independently close each branch's source, protection, conductor/connector, copper/via, return and thermal envelope.

If actual sensor current, reused harness rating or connector ampacity requires machine inspection, keep it `VERIFY_AT_MACHINE`; do not infer it from the semiconductor rating.

## 7. Reconcile enable and startup dependencies

A rail graph also needs control edges. For every source/protector/converter record:

- default state with control logic unpowered;
- enable source and voltage domain;
- UVLO/brownout behavior;
- current-limit behavior;
- soft-start/dVdT mechanism;
- downstream capacitance boundary;
- whether a child rail is required to enable its own parent;
- fault indication receiver and its power dependency.

Reject circular startup dependencies that are hidden by steady-state schematics.

For current OpenPressBrake machine power, TPS26633 ILIM and dVdT programming remain open because the final CORE operating load and downstream startup/capacitance boundary are not yet closed. Do not freeze programming passives from the 134.56-mA 5-V subtotal alone.

## 8. Fault-containment boundaries

For every branch define what a fault is allowed to disturb. A useful record includes:

- fault origin;
- first limiting/protective element;
- maximum supported fault energy/current claim;
- upstream source affected;
- sibling rails affected;
- return path;
- latch/retry behavior;
- fault-status propagation;
- reset/recovery behavior;
- evidence level;
- unresolved qualification.

A common upstream source can create common-cause behavior even when branches have separate fuses or eFuses. Conversely, a separately sourced field branch must not be charged against a controller protector that cannot actually interrupt it.

## 9. Board-power acceptance gate

A board power baseline may advance only when:

- source ancestry for every rail is explicit and acyclic;
- every populated consumer is represented exactly once at its physical rail;
- child-rail demand rolls upstream exactly once through justified conversion relationships;
- capacity numbers are not substituted for operating demand;
- unknown required consumers remain visible and block affected claims;
- normal return paths are closed;
- startup/inrush dependencies are separately reconciled;
- transient and fault-current paths are explicit;
- branch protection is checked against the weakest supported path, not only the semiconductor;
- typed return/chassis domains are preserved;
- enable/default/brownout behavior is compatible across dependencies;
- field branches are not silently moved behind controller protection;
- safety authority remains independent;
- evidence revisions are locked and rechecked before promotion.

This means **board-power baseline accepted**, not production-qualified hardware.

## Negative cases

Reject these arguments:

- `The regulator is rated 1.5 A, so the board draws less than 1.5 A.`
- `5V_ANALOG has its own name, so it gets a separate regulator budget.`
- `The continuous subtotal fits, so startup is proven.`
- `All grounds connect eventually, so return routing does not matter.`
- `The TVS is present, so the transient is contained.`
- `The output IC is rated for the current, so the connector and copper are too.`
- `The sensor is 24 V, so it belongs behind the controller 24-V eFuse.`
- `The eFuse fault output is monitored by the FPGA, so the FPGA is personnel-safety authority.`

## Catalog stress-test result

The current machine-power work demonstrates why the catalog needs a machine-readable whole-board **power/return graph**, not only per-block current fields. The graph should encode parent/child rails, separately sourced branches, typed load evidence, normal/startup/transient/fault paths, return domains, enables, branch-protection ownership and evidence locks.

The audit also exposes a concrete maintenance defect: `machine_power/STATUS_CHECKLIST.md` is stale relative to current Rev23 authority. It is **ENGINEERING_REVIEW_NEEDED** as a complete status/evidence index. Because the active OpenPressBrake engineering lane has just advanced machine-power and safety-interface integration, this curriculum run leaves OpenPressBrake read-only rather than racing those changes.

No simulation, synthesis, place-and-route or other executable verification is required for this deterministic authority-reconciliation lesson. Any later executable verification must run only on `[self-hosted, openpressbrake]`.

## Transfer exercise

Apply the method to one different machine: mill spindle/VFD controls, lathe turret/solenoids, plasma torch-height electronics, router I/O, robot joint drives or custom automation. Build the parent/child source tree, identify separately sourced field branches, classify every load number, trace normal/startup/transient/fault returns, and list the evidence still required before board-power acceptance.

## Checkpoint

BD67 is complete. Next develop **BD68 — Startup/Shutdown Sequencing, Brownout, and Output-Authority Reconciliation**:

`accepted power/return graph -> source ramp/order -> reset/enable dependencies -> brownout behavior -> output default/inhibit states -> watchdog/power-fault interactions -> shutdown energy paths -> sequence fault injection plan -> integration acceptance`.

Re-open every student-facing source on current main. Preserve `VERIFY_AT_MACHINE` facts and do not treat the current OpenPressBrake board as production-proven.