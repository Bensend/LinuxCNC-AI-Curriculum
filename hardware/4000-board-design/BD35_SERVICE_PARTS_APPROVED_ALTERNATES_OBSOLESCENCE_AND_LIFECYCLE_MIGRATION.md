# BD35 — Service Parts, Approved Alternates, Obsolescence, and Lifecycle Migration

## Purpose

BD34 established truthful `as-maintained` identity after service. BD35 addresses the next lifecycle failure mode: a part, toolchain, or supported configuration changes availability and an organization quietly treats whatever still fits as equivalent.

The governing flow is:

`lifecycle event -> consumed semantic facets -> alternate/equivalence evidence -> affected blocks/releases/installed assets -> new-build vs service-only policy -> qualification/regression -> service-parts baseline -> obsolescence migration -> field applicability`

This lesson develops both linked skills:

1. **block engineering** — define the semantic envelope that a replacement must satisfy and bind qualification to an exact part/revision/applicability envelope; and
2. **board integration** — decide which board variants and installed/as-maintained assets may consume an alternate, which remain legacy-supported, and which require migration.

OpenPressBrake is used only as a current governance/example source. It is not represented as production-proven hardware.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD34_FIELD_RETURN_REPAIR_RETROFIT_AND_AS_MAINTAINED_CONFIGURATION.md` — as-maintained identity, substitution classification, evidence inheritance, and service history.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD35 — board-lane assignment and exact next work.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful readiness/evidence gates and required rechecks after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter, board-integration, machine-fact, and safety-authority boundaries.
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml` — exact AM26LV31E/TPD4E05U06 baseline, generic interface/resource contract, and unresolved configuration/qualification items.
- OpenPressBrake `hardware/blocks/motor_drive_interface/production_bom_rev1.yaml` — exact frozen MPN/value baseline and board-owned connector.
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md` — current `SIMULATION-READY` state and open release gates.
- OpenPressBrake `hardware/blocks/motor_drive_interface/REV1_3V3_POWER_HANDOFF.md` — current scalable source-capacity handoff and explicit distinction between conservative allocation and actual thermal/load evidence.

The current `motor_drive_interface` is not assigned as finished production hardware. It remains `SIMULATION-READY`; abnormal fault qualification, schematic visual review, selected connector/cable integration, board integration, final thermal/SI evidence and human Rev 1 signoff remain open. For finished production use it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. A lifecycle event is not automatically a design change

Examples include:

- manufacturer end-of-life or last-time-buy notice;
- distributor shortage;
- package or ordering-code change;
- supplier process/site change;
- revised datasheet;
- toolchain or FPGA-family support change;
- regulatory/material declaration change;
- counterfeit/supply-chain concern;
- a service stock becoming scarce.

First classify the event. Do not redesign merely because purchasing reported a lifecycle concern, and do not substitute merely because the preferred part is unavailable.

> **PART AVAILABILITY CHANGED != ELECTRICAL CONTRACT CHANGED**

But availability can force a controlled engineering decision about how the contract will continue to be met.

## 2. Start with consumed semantic facets, not headline similarity

For the affected part or tool, identify the facets the design actually consumes. Depending on the function these can include:

- pinout, package, land pattern, assembly process;
- operating and absolute voltage/current limits;
- logic thresholds, leakage, bias and default behavior;
- startup, propagation, pulse-width and timing behavior;
- drive strength and load envelope;
- analog accuracy, noise, drift and reference behavior;
- protection, clamp, fault and diagnostic behavior;
- thermal impedance and dissipation limits;
- isolation/creepage/insulation properties;
- environmental/lifecycle grade;
- FPGA device, synthesis/P&R, timing-model and programming compatibility;
- software/HAL-visible behavior and configuration identity.

An alternate must be compared against the facets actually consumed by the block and its dependents.

> **SAME PACKAGE + SAME HEADLINE RATING != QUALIFIED ALTERNATE**

## 3. Approved alternate is a bounded engineering claim

An approved alternate record should bind at least:

- original exact identity;
- alternate exact identity;
- affected semantic IDs/facets;
- equivalence/delta analysis;
- evidence source and revision;
- qualification/regression evidence;
- applicable block revision(s);
- applicable board/release revision(s);
- operating/environmental envelope;
- population constraints;
- new-build/service-only permissions;
- exclusions and unresolved facts.

Do not approve a family name such as “equivalent RS-422 driver.” Approve an exact part against an explicit envelope.

> **APPROVED SOMEWHERE != APPROVED FOR EVERY CONSUMER**

## 4. Narrower alternates need explicit applicability

An alternate can be valid without being universally interchangeable.

Example: a replacement may meet all required electrical behavior but have a narrower temperature range, lower surge rating, different package thermal performance, or lower supported clock/rate. It may therefore be qualified for one board variant or service population while being excluded from another.

Record that envelope instead of flattening it into a global `approved=true` flag.

> **QUALIFIED ALTERNATE != UNIVERSAL DROP-IN**

## 5. Separate new-build policy from service-only policy

Lifecycle management has at least two populations:

- **new build** — what current manufacturing may populate on new boards;
- **service** — what may be used to maintain an already released legacy population.

A legacy component can remain acceptable for service while being prohibited for new design. Conversely, a new alternate can be preferred for new build while not being an authorized retrofit into old installed units until applicability and regression are established.

Useful policy states include:

- `PREFERRED_NEW_BUILD_AND_SERVICE`
- `APPROVED_NEW_BUILD_AND_SERVICE`
- `SERVICE_ONLY_LEGACY`
- `NEW_BUILD_ONLY_PENDING_RETROFIT_EVIDENCE`
- `LAST_TIME_BUY_CONTROLLED`
- `DO_NOT_USE`
- `OBSOLETE_MIGRATION_REQUIRED`

> **NOT PREFERRED FOR NEW BUILD != INVALID IN INSTALLED LEGACY UNIT**

and

> **NEW DESIGN ALTERNATE QUALIFIED != FIELD RETROFIT AUTHORIZED**

## 6. Last-time-buy is an engineering/configuration decision

A last-time-buy can be correct when it preserves a qualified configuration while redesign cost/risk is unjustified. It is not automatically technical debt and not automatically the best choice.

A defensible decision considers:

- forecast new-build demand;
- installed service population;
- expected service life and failure rate evidence;
- storage/shelf-life constraints;
- counterfeit/traceability risk;
- redesign and qualification burden;
- whether the current part is itself implicated in a defect;
- toolchain/manufacturing support horizon.

Record the stock's permitted use and identity. Do not let controlled legacy stock silently become an unrestricted alternate.

## 7. Redesign must stay at the correct architectural layer

If obsolescence affects an intrinsic component of a reusable block and a new part changes its generic contract/topology, revise that reusable block and propagate `SHOW WHERE USED`.

If compatibility requires a meaningful reusable transformation, create/revise an adapter.

If only connector/pin/population/board mapping changes, keep it in board integration.

Do not contaminate a reusable block with one board's obsolete connector or harness problem.

> **OBSOLESCENCE PRESSURE != PERMISSION TO BREAK BLOCK BOUNDARIES**

## 8. Historical releases remain historical truth

When an alternate becomes approved today, do not rewrite a historical release to pretend that it always allowed the part.

Preserve:

- original released BOM/configuration;
- later alternate approval record;
- engineering-change/release that authorizes it;
- as-built/as-maintained units that actually contain it;
- date/lot/serial applicability where relevant.

> **ALTERNATE APPROVED TODAY != HISTORICAL RELEASE BUILT THAT WAY**

This is necessary for future failure analysis and field applicability.

## 9. Use both dependency and installed-identity graphs

`SHOW WHERE USED` determines which engineering blocks/adapters/boards/releases consume the affected semantic facet.

`SHOW WHAT IS INSTALLED` determines which physical assets currently contain the original, alternate, or migrated configuration, using the current as-maintained identity from BD34.

A lifecycle event can affect new builds, service stock and field units differently. Do not infer field population from design-family membership.

Unknown physical identity remains `VERIFY_AT_MACHINE`.

## 10. Evidence inheritance follows semantic impact

For a proposed alternate, classify evidence as:

- preserved/current;
- directly reusable within the same envelope;
- stale and requiring review/recalculation;
- requiring bounded regression;
- requiring new qualification;
- inapplicable/superseded.

Examples:

- an ordering-code-only change with unchanged die/package/specification may preserve most electrical evidence if manufacturer provenance supports that claim;
- changed input leakage can stale default-state/bias evidence;
- changed output resistance can stale load, thermal and signal-integrity evidence;
- changed ESD structure can stale protection evidence;
- changed package can stale PCB/assembly/thermal evidence even if electrical behavior is nominally similar;
- a new FPGA toolchain can stale timing/resource/bitstream reproducibility evidence without changing field circuitry.

> **LOCAL ALTERNATE CHECK PASSED != DEPENDENT BOARD EVIDENCE CURRENT**

## 11. Toolchain and programmable-device obsolescence are configuration problems too

Lifecycle migration is not limited to BOM components. FPGA devices, programmers, synthesis/P&R versions, LinuxCNC/LiteX-CNC dependencies, firmware toolchains and configuration formats can become unavailable.

A migration must preserve or deliberately revise:

- semantic pin/resource mapping;
- I/O standards and bank voltage;
- clocks/PLL/timing constraints;
- watchdog/default behavior;
- generated-image identity and reproducibility;
- HostMot2/LiteX-CNC/HAL-visible semantics;
- programming/recovery procedure.

A bitstream that builds is not sufficient proof of equivalence.

> **NEW TOOLCHAIN BUILDS != OLD IMPLEMENTATION SEMANTICS PRESERVED**

If synthesis/place-and-route/timing verification becomes genuinely necessary, execute it only on `[self-hosted, openpressbrake]` under the course compute rule.

## 12. OpenPressBrake worked governance example

The inspected `motor_drive_interface` currently freezes an exact TI `AM26LV31EIDR` line driver and `TPD4E05U06DQAR` ESD device in its manifest/BOM. The block exposes two deterministic differential command pairs per primitive, packs two primitives per quad driver, and keeps physical connector choice in board integration.

The current status remains `SIMULATION-READY`, not released. Open fault, schematic, connector/cable, thermal/SI, integration and human-signoff gates remain explicit.

The current 3V3 handoff uses the AM26LV31E manufacturer's output-drive capability as a conservative source-capacity allocation while explicitly refusing to call that normal operating current or package dissipation. Actual receiver/cable/termination and simultaneous-axis thermal behavior remain integration/configuration facts.

Therefore a future AM26LV31E lifecycle event would not justify replacing it with a package-compatible line driver merely because the new device says “RS-422.” Engineering would compare the consumed logic thresholds, supply, differential drive/load envelope, timing, enable/default behavior, package/pinout, thermal behavior and protection interaction, then propagate any changed facets to board 3V3, timing, SI, thermal and qualification evidence.

No actual AM26LV31E obsolescence, OpenPressBrake production release, approved alternate, installed population or service stock is asserted by this lesson.

## 13. Cross-machine reuse

The method applies to mills, lathes, plasma tables, routers, robots, press brakes and custom automation. A generic alternate can be reusable only to the envelope its evidence supports; machine-specific cable, load, ambient, wiring and service facts remain with board/installation configuration.

A part qualified on one machine does not automatically become a universal catalog alternate.

## 14. Safety boundary

An ordinary controller component may carry a status signal from an independent safety system. Migrating that ordinary receiver can establish only the ordinary electrical/status interface claims actually verified.

Do not infer PL/SIL/category, diagnostic coverage, stopping performance, final-element behavior or personnel-safety authority from an alternate-part qualification in the normal controller.

> **SAFETY-STATUS INTERFACE MIGRATED != SAFETY FUNCTION REVALIDATED**

Any lifecycle change inside the independent safety architecture belongs under its own qualified safety design/change/validation process.

---

## Lab — eight adversarial lifecycle cases

Use a fictional controller catalog serving several machine classes. Preserve exact old/new identities and applicability.

### Case 1 — exact-MPN obsolescence

A manufacturer announces EOL for a qualified line driver. Distributor stock remains available. Build a last-time-buy versus redesign decision without claiming that EOL changed the existing electrical evidence.

### Case 2 — approved alternate with narrower envelope

An exact alternate has been qualified electrically but only over a narrower temperature range. One indoor mill fits that envelope; a hot enclosure does not. Define the applicability record and prevent global approval leakage.

### Case 3 — package-compatible non-equivalent part

A same-package device has adequate headline voltage/current but different input leakage, startup state and propagation delay. Identify affected semantic facets, dependents and required evidence.

### Case 4 — last-time-buy versus redesign

Legacy service demand is small but expected to continue for years. Compare controlled service stock, redesign/qualification burden, traceability and future support. Separate service policy from new-build policy.

### Case 5 — service-only legacy part

A component remains supported in installed legacy boards but is banned from new production because the current design has migrated. Show how both configurations can remain truthful without rewriting history.

### Case 6 — mixed installed population

Some machines contain the original part, some an approved alternate, some have unknown service history. Use `SHOW WHERE USED`, `SHOW WHAT IS INSTALLED`, as-maintained identity and `VERIFY_AT_MACHINE` to bound a later field action.

### Case 7 — FPGA/toolchain obsolescence

The original FPGA toolchain is no longer supportable. A newer toolchain builds the source. Define the semantic/resource/timing/reproducibility evidence needed before declaring the new image equivalent or creating a new release baseline.

### Case 8 — ordinary safety-status interface migration

A non-safety input component observing status from an independent safety system becomes obsolete. Qualify the ordinary electrical/configuration migration while refusing unsupported personnel-safety claims.

For each case submit:

- lifecycle event and provenance;
- exact original and proposed identities;
- consumed semantic facets;
- equivalence/delta table;
- affected reusable blocks/adapters/board releases;
- `SHOW WHERE USED` result;
- affected installed/as-maintained assets or unknowns;
- new-build/service-only/last-time-buy policy;
- preserved/stale/new evidence;
- qualification/regression plan;
- historical release treatment;
- migration/retrofit applicability;
- `VERIFY_AT_MACHINE` items;
- safety-authority statement.

### Lab pass criteria

A passing submission must bind alternates to exact identities and explicit envelopes; reject package/headline similarity as qualification; separate new-build from service policy; preserve historical releases; use dependency plus installed-identity graphs; propagate changed semantic facets into evidence; treat FPGA/toolchain identity as part of the controller baseline; keep board-specific connection facts out of reusable blocks; and preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

This lesson exposes a concrete catalog/lifecycle infrastructure need. Future tooling should represent an immutable approved-alternate/lifecycle record joining:

- exact original and alternate identities;
- manufacturer/source/revision provenance;
- consumed semantic IDs/facets;
- equivalence/delta evidence;
- qualification envelope and exclusions;
- block/adapter/board/release applicability;
- new-build versus service-only policy;
- last-time-buy/service-stock identity where used;
- stale/preserved evidence;
- installed/as-maintained applicability;
- migration/rework history;
- lifecycle state and effective dates.

Do not dump procurement status into reusable block manifests as a substitute for this record. Reusable blocks should contain exact engineering identities and generic requirements; lifecycle policy and population applicability require their own traceable layer.

Current OpenPressBrake does not yet provide this repository-wide record. Keep this gap `ENGINEERING_REVIEW_NEEDED`; do not invent approved alternates, service stocks, releases or installed assets.

## Durable freezes

- `PART AVAILABILITY CHANGED != ELECTRICAL CONTRACT CHANGED`
- `SAME PACKAGE + SAME HEADLINE RATING != QUALIFIED ALTERNATE`
- `APPROVED SOMEWHERE != APPROVED FOR EVERY CONSUMER`
- `QUALIFIED ALTERNATE != UNIVERSAL DROP-IN`
- `NOT PREFERRED FOR NEW BUILD != INVALID IN INSTALLED LEGACY UNIT`
- `NEW DESIGN ALTERNATE QUALIFIED != FIELD RETROFIT AUTHORIZED`
- `OBSOLESCENCE PRESSURE != PERMISSION TO BREAK BLOCK BOUNDARIES`
- `ALTERNATE APPROVED TODAY != HISTORICAL RELEASE BUILT THAT WAY`
- `LOCAL ALTERNATE CHECK PASSED != DEPENDENT BOARD EVIDENCE CURRENT`
- `NEW TOOLCHAIN BUILDS != OLD IMPLEMENTATION SEMANTICS PRESERVED`
- `SAFETY-STATUS INTERFACE MIGRATED != SAFETY FUNCTION REVALIDATED`

## Next exact work

Build BD36 on **lifecycle migration planning across multiple board variants and installed populations**: replacement strategy -> compatibility matrix -> coexistence window -> manufacturing cut-in -> service transition -> firmware/FPGA/HAL compatibility -> migration evidence -> field rollout -> rollback/containment -> legacy retirement.

Stress-test mixed old/new boards sharing software, staged manufacturing cut-in, spare-board compatibility, rollback after a field finding, unknown legacy identity, and the temptation to force one reusable block contract to cover incompatible generations.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification is justified by this documentation/evidence lesson. No hosted compute is required. Future executable verification remains restricted to `[self-hosted, openpressbrake]`.
