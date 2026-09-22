# BD34 — Field-Return Evidence, Repair/Retrofit Reconciliation, and As-Maintained Configuration

## Purpose

BD29–BD33 established released, as-built, installed, production-test, and field-finding identity. BD34 addresses the next failure mode: a machine is serviced and then silently stops matching the configuration that its old evidence describes.

The governing flow is:

`installed identity -> service finding -> repair/substitution/configuration change -> semantic impact -> post-service as-maintained identity -> affected evidence -> regression/functional verification -> installed-baseline update -> future field applicability`

This lesson develops both linked skills:

1. **block engineering** — determine whether a service replacement or substitute still satisfies a reusable block contract and which semantic facets/evidence remain valid; and
2. **board integration** — reconcile actual fitted hardware, FPGA/HAL, wiring, jumpers, machine facts, and repair history so the serviced machine has a truthful as-maintained baseline.

OpenPressBrake is used only as a current governance/example source. It is not represented as production-proven hardware.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD33_PRODUCTION_ESCAPE_CONTAINMENT_NONCONFORMANCE_TRENDS_AND_CATALOG_FEEDBACK.md` — containment, finding ownership, preserved negative evidence, installed-asset applicability, and effectiveness.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD34 — exact board-lane assignment and catalog gaps.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful readiness/evidence gates and maintenance after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter, board-integration, machine-fact, and safety-authority boundaries.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — current evidence scope and unresolved Rev1 isolated-path release work.
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml` — generic interfaces, unresolved board/machine envelope, FPGA/shared-resource requirements, and non-safety role.

The current `digital_output_24v` is not assigned as finished production hardware. Its reusable non-isolated variant remains `SIMULATION-READY`; its first-machine isolated path is not yet `SCHEMATIC-READY`. For finished production use it remains `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Service creates a new configuration state

A repair does not merely restore function. It may change what hardware and configuration physically exist.

Keep these identities distinct:

- **released** — engineering baseline authorized for a variant;
- **as-built** — what a serialized board actually contained when built;
- **as-installed** — what board/configuration/wiring was installed in a machine;
- **as-maintained** — what remains after service, rework, substitution, retrofit, jumper/wiring change, or programming/configuration change.

Freeze:

> **REPAIR COMPLETE != ORIGINAL INSTALLED BASELINE STILL TRUE**

A machine may function after service while its old evidence no longer applies.

## 2. Preserve the service finding and pre-service state

Before replacing parts or reprogramming a board, preserve what can reasonably be established:

- machine/asset identity;
- board/serial identity;
- PCB/BOM and fitted-part identity;
- FPGA/software/HAL/configuration identity;
- connector, jumper, option, and harness state relevant to the finding;
- symptom and negative evidence;
- machine/environment facts relevant to the failure;
- prior deviations/repairs if known;
- unknowns.

Do not overwrite a failed configuration with the repaired state.

> **POST-REPAIR PASS != PRE-REPAIR FAILURE NEVER EXISTED**

This is required both for engineering feedback and future applicability decisions.

## 3. Unknown installed identity fails closed

A legacy machine may have no trustworthy serial, BOM, FPGA image, HAL mapping, jumper state, or prior repair history. Do not infer identity from family name, cabinet appearance, or the part that happens to be visible.

Use `VERIFY_AT_MACHINE` for unresolved physical facts and reconstruct only what evidence supports.

> **UNKNOWN INSTALLED IDENTITY != RELEASE BASELINE BY DEFAULT**

The service record may begin as `PARTIALLY_RECONCILED` and become more complete as physical/configuration facts are verified.

## 4. Classify every service change by semantic impact

A useful service classification is:

### Exact replacement
Same approved part/revision and no consumed semantic facet changes. Lot/date identity may still matter for traceability.

### Qualified alternate
A pre-approved alternate whose equivalence and evidence envelope explicitly cover the current consumer.

### Engineering substitution
An apparently equivalent part that is not already covered by qualification. It requires semantic comparison and engineering disposition before inheritance.

### Reusable-block revision
The generic block contract/topology/component set changes on engineering grounds. `SHOW WHERE USED` and requalification apply.

### Adapter revision
A real transformation/protection boundary changes. Treat it as an independently engineered block revision.

### Board/integration change
Connector/pin mapping, shared-resource allocation, board-only wiring, test access, population, placement, routing, or other board composition changes.

### Machine/installation change
Harness, load, grounding/bonding, external wiring, cabinet option, machine parameter, or other physical-machine fact changes.

### FPGA/HAL/software configuration change
The PCB may be unchanged while pin mapping, polarity, watchdog behavior, resource assignment, timing, or machine logic changes materially.

Freeze:

> **SAME FUNCTIONAL DESCRIPTION != SAME SEMANTIC CONTRACT**

and:

> **SAME PCB != SAME CONTROLLER CONFIGURATION**

## 5. Like-for-like still needs identity

Replacing a failed part with the exact approved MPN normally preserves more evidence than an engineering substitution. But traceability still matters when a finding may be lot- or date-related.

Record at least the removed and installed identities when practical. If the lot/date identity is unavailable, preserve that uncertainty rather than claiming the replacement is outside a suspected population.

> **LIKE-FOR-LIKE ELECTRICALLY != TRACEABILITY COMPLETE**

## 6. Apparently equivalent substitutes require facet comparison

Do not approve a substitute from headline voltage/current/package alone. Compare the facets actually consumed by the design, such as:

- pinout and package/land pattern;
- operating/survival voltage and current;
- logic thresholds and default behavior;
- leakage/bias/current draw;
- timing and startup behavior;
- protection/fault behavior;
- thermal characteristics;
- analog accuracy/noise/reference behavior;
- isolation ratings where applicable;
- diagnostics;
- lifecycle/temperature/environmental grade;
- PCB/layout constraints.

If a consumed facet changes, locate its dependents and determine which evidence is stale.

> **DROP-IN PHYSICALLY != QUALIFIED ELECTRICALLY**

## 7. Replacement boards require complete configuration identity

A replacement PCB that is electrically correct can still be the wrong controller if it carries a different FPGA bitstream, firmware, HAL configuration, parameter set, option population, or connection mapping.

Before returning a machine to service, reconcile the intended and actual:

`PCB/BOM + options/jumpers + FPGA image + firmware/software + LinuxCNC/HAL + machine mapping`

Do not use a generic “programming succeeded” result as identity evidence.

> **PROGRAMMING SUCCESS != CORRECT PROGRAMMED BASELINE**

## 8. Technician wiring and jumper changes are configuration changes

A field jumper, crossed pair, rerouted return, added bond, bypass wire, changed terminal, or harness repair can materially change the electrical architecture even if no PCB component changed.

Classify it at the correct layer. Board/machine-specific wiring remains integration/installation authority; do not rewrite a reusable block to legitimize a one-machine field modification.

If a change creates real reusable transformation/protection circuitry, it belongs in a qualified adapter rather than undocumented service glue.

> **FIELD WIRE FIX != REUSABLE BLOCK REVISION**

unless generic engineering evidence actually shows the reusable contract is defective.

## 9. Recompute evidence inheritance after service

For every material service change, determine:

- changed semantic IDs/facets;
- owning artifact/configuration revision;
- `SHOW WHERE USED` consumers;
- installed assets affected by the same service action;
- evidence that remains current;
- evidence made stale/superseded;
- required regression/functional verification;
- unresolved `VERIFY_AT_MACHINE` facts.

Do not blindly requalify everything, but do not preserve evidence by convenience.

Examples:

- exact approved connector replacement may preserve generic electrical qualification while requiring workmanship/continuity inspection;
- changed output-device leakage can stale bias/default-state evidence;
- different FPGA image can stale pin/resource/watchdog/HAL evidence without changing PCB qualification;
- changed field return/bonding can stale fault-current, EMC, and isolation assumptions while leaving unrelated block evidence current.

## 10. Functional service test is bounded evidence

A post-service functional test should prove named claims. “Machine runs” is not enough to establish every affected electrical, configuration, or protection claim.

Use the smallest sufficient regression set derived from changed facets and dependencies. Preserve the evidence class:

- visual/structural inspection;
- continuity/pin mapping;
- powered electrical test;
- FPGA/configuration identity check;
- HAL/logical mapping test;
- machine functional verification;
- machine measurement;
- qualification/regression where a reusable claim changed.

> **MACHINE OPERATES != ALL AFFECTED EVIDENCE CURRENT**

## 11. A retrofit can solve one problem while creating stale evidence elsewhere

A retrofit may intentionally change a reusable block, adapter, board resource, connector, FPGA image, or machine wiring. Treat it as engineering change control plus installed-asset execution, not merely repair.

After the retrofit:

1. bind the exact engineering change/release;
2. record actual installed parts/configuration;
3. propagate stale evidence from changed facets;
4. execute justified regression;
5. update as-maintained identity;
6. preserve the pre-retrofit identity and finding history.

> **RETROFIT FIXES TARGET ISSUE != RETROFIT FULLY REQUALIFIED**

## 12. `SHOW WHERE USED` and `SHOW WHAT IS INSTALLED` remain paired

`SHOW WHERE USED` answers which engineering releases consume a changed semantic facet.

`SHOW WHAT IS INSTALLED` answers which physical assets currently contain a release/as-built/as-maintained configuration.

Service adds another requirement: installed records must point to the **current as-maintained configuration**, while preserving prior states historically.

A future field action cannot be bounded correctly if service changes are invisible.

## 13. OpenPressBrake worked governance example

The inspected `digital_output_24v` manifest deliberately leaves board channel current, inrush, duty, simultaneous-use assumptions, connector rating, PCB limits, and machine load facts unresolved. Its reusable block therefore cannot authorize a technician to substitute a field connector, reroute a return, increase load current, or infer a new machine envelope.

Its inspected status checklist also preserves a critical first-machine boundary: the Rev1 isolated path keeps the L7/L07 switched field domain isolated from L06/logic ground, with no L07-to-L06 bridge permitted, while exact KiCad mapping, structural validation, fault/abnormal qualification, PCB thermal/current evidence, integration, and human release remain open.

A hypothetical service jumper bonding those returns because “the output works that way” would be a material architecture change, not a harmless repair. It would contradict the current first-machine contract and would require engineering disposition rather than retroactive modification of the reusable primitive.

No actual OpenPressBrake field repair, production serial, released board, or service population is asserted here.

## 14. Cross-machine reuse

The method applies to mills, lathes, plasma tables, routers, robots, press brakes, and custom automation. Machine-specific service facts stay with the installed asset; generic corrections flow back to reusable blocks only when evidence justifies a generic engineering change.

This prevents a repair discovered on one machine from silently contaminating every catalog consumer.

## 15. Safety boundary

Servicing an ordinary controller input that observes independent safety-system status proves only the ordinary electrical/status path actually checked.

A technician replacement, wiring repair, FPGA/HAL correction, or successful machine function test does not establish PL/SIL/category, stopping performance, safety diagnostic coverage, or independent personnel-safety validation.

Any physical work on the independent safety architecture belongs under its own qualified safety design/service/validation process.

> **SAFETY STATUS RESTORED != SAFETY FUNCTION REVALIDATED**

---

## Lab — eight adversarial service cases

Use a fictional multi-machine controller family. Preserve pre-service and post-service identity separately.

### Case 1 — like-for-like replacement, uncertain lot

An approved output IC is replaced with the same MPN, but the removed and replacement lot/date identities are incomplete while a supplier-lot investigation is open. Decide what evidence can inherit and what traceability remains unresolved.

### Case 2 — apparently equivalent substitute

A technician fits a same-package device with equal headline voltage/current ratings. Its input leakage and fault behavior differ. Identify consumed facets, affected evidence, ownership, and required engineering disposition.

### Case 3 — replacement board, wrong FPGA/HAL

A known-good spare PCB is installed but carries a different FPGA image and HAL mapping. The machine powers up and some I/O works. Determine why PCB identity alone is insufficient and define the configuration reconciliation/regression needed.

### Case 4 — field jumper/wiring change

A technician adds a return jumper to make an output operate. Determine whether the change is reusable-block, adapter, board-integration, or machine-installation owned; identify fault/isolation evidence affected and whether the machine may return to service.

### Case 5 — repaired unit with preserved negative evidence

A board with an intermittent open is reworked and passes retest. Build the history so the original failure remains available for trend/effectiveness analysis while the current as-maintained state can be conforming.

### Case 6 — unknown legacy installed identity

A machine family name is known, but PCB revision, BOM, FPGA/HAL, prior repairs, and harness changes are not. Create a `VERIFY_AT_MACHINE` reconciliation plan without assigning a guessed release.

### Case 7 — retrofit closes one issue, leaves stale dependent evidence

A revised reusable block fixes a verified field weakness. The local block regression passes, but the new current draw affects a shared regulator and thermal budget that have not been rerun. Determine release/return-to-service state and remaining evidence.

### Case 8 — ordinary safety-status interface repair

A non-safety receiver that reads status from an independent safety system is repaired and its electrical/HAL status path works. State exactly what was verified and refuse unsupported personnel-safety claims.

For each case submit:

- pre-service identity and unknowns;
- preserved finding/negative evidence;
- service action and exact fitted/programmed/wired change;
- owning architectural layer;
- changed semantic facets;
- `SHOW WHERE USED` impact;
- `SHOW WHAT IS INSTALLED`/asset impact;
- preserved, stale, and superseded evidence;
- `VERIFY_AT_MACHINE` items;
- post-service regression/functional test plan;
- post-service as-maintained identity;
- return-to-service/release-inheritance disposition;
- safety-authority statement.

### Lab pass criteria

A passing submission must keep released/as-built/as-installed/as-maintained identities distinct; preserve pre-service negative evidence; reject unqualified substitutions; treat FPGA/HAL as configuration identity; classify field wiring changes at the correct layer; propagate evidence impact from semantic changes; keep unresolved physical facts explicit; update the installed baseline without rewriting history; and preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

BD34 exposes a concrete service/configuration infrastructure need: future tooling should represent an immutable **service event** that references pre-service installed identity, finding evidence, removed/installed parts, board/adapter revisions, FPGA/software/HAL identities, wiring/jumper/harness changes, engineering disposition, changed semantic facets, stale/preserved evidence, regression results, `VERIFY_AT_MACHINE` facts, and the resulting as-maintained identity.

Do not place raw machine service history inside reusable block manifests. Feed back only justified generic engineering consequences.

This remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing production releases, serial numbers, installed assets, repairs, or retrofit history.

## Durable rules from BD34

- released, as-built, as-installed, and as-maintained identity are distinct;
- repair completion does not prove the old installed baseline remains true;
- post-repair PASS does not erase pre-repair negative evidence;
- unknown installed identity does not default to a release baseline;
- like-for-like electrical replacement does not complete lot traceability;
- physical drop-in does not establish qualification inheritance;
- same PCB does not establish the same FPGA/HAL controller configuration;
- field wiring/jumper changes are configuration changes and remain at the correct ownership layer;
- service changes invalidate evidence by semantic impact, not by convenience;
- machine operation does not prove all affected evidence current;
- a retrofit can fix its target issue while dependent evidence remains stale;
- current as-maintained identity must drive future installed-asset applicability;
- ordinary safety-status restoration is not personnel-safety revalidation.

## Next exact work

Build BD35 on **service-parts policy, approved-alternate envelopes, obsolescence, and lifecycle migration without corrupting reusable qualification**.

Teach:

`part lifecycle event -> consumed semantic facets -> alternate/equivalence evidence -> affected blocks/releases/installed assets -> new-build vs service-only decision -> qualification/regression -> service-parts baseline -> obsolescence migration -> field applicability`

Stress exact-MPN obsolescence, approved alternates whose envelope is narrower than the original, package-compatible non-equivalence, last-time-buy versus redesign, service-only legacy parts, mixed installed populations, FPGA/toolchain obsolescence, and safety-status interfaces without granting safety authority.
