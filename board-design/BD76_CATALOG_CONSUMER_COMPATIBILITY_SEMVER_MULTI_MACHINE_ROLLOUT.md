# BD76 — Catalog Consumer Compatibility, Semantic Versioning, Deprecation, and Multi-Machine Rollout

Status: durable board-design curriculum lane

## Purpose

BD76 teaches how a reusable hardware block evolves without silently breaking existing board consumers. The catalog is an engineering API: compatibility is determined by the electrical/function/resource contract actually consumed, not by a filename or a belief that a schematic “looks similar.”

Design flow:

`qualified reusable block + consumer Where Used graph -> compatibility classification -> semantic contract version -> migration/deprecation window -> per-board adaptation -> targeted regression -> staged rollout -> consumer baseline updates`

Central rules:

**IMPLEMENTATION COMPATIBILITY IS NOT CONTRACT COMPATIBILITY.**

**A REUSABLE BLOCK MAY EVOLVE; A BOARD-SPECIFIC CONNECTION MUST ADAPT EXPLICITLY.**

**DEPRECATION IS A CONTROLLED MIGRATION STATE, NOT SILENT DELETION.**

## Learning objectives

Students shall be able to:

1. identify the public reusable-block contract separately from implementation details;
2. perform reverse `Where Used` review before changing a consumed semantic;
3. classify changes as compatible, conditionally compatible, migration-required, or breaking;
4. apply semantic contract versioning to electrical/function/resource interfaces;
5. keep machine-specific connector, harness, placement, scaling, and configuration facts outside reusable circuitry;
6. construct a per-consumer compatibility matrix and migration plan;
7. preserve applicable old evidence while marking genuinely affected evidence stale;
8. deprecate and supersede a contract without erasing historical baselines;
9. stage rollout across different machine classes with targeted regression; and
10. preserve independent personnel-safety authority during ordinary-controller migration.

## 1. Treat the reusable contract as an API

The public contract includes every property a consumer is entitled to rely on: semantic I/O, direction, electrical envelope, rails and returns, default/de-energized behavior, fault behavior, diagnostics, protection assumptions, resource demand, shared-resource scaling, timing where relevant, and qualification envelope.

Implementation-only details may change compatibly only when they do not invalidate a public claim or consumer assumption. A component substitution that changes input leakage, startup current, default bias, thermal envelope, isolation, diagnostic polarity, pin-bank demand, or protection behavior is not “implementation-only” merely because the signal names remain unchanged.

## 2. Compatibility classes

For every material block change assign one class:

- `COMPATIBLE` — all declared consumer-facing semantics and envelopes remain satisfied; no consumer adaptation is required.
- `CONDITIONALLY_COMPATIBLE` — contract remains usable only when an explicit consumer precondition is true; every consumer must be checked against that condition.
- `MIGRATION_REQUIRED` — the new contract can serve the consumer, but board connection/resource/runtime artifacts must change.
- `BREAKING` — at least one prior public contract guarantee is removed or changed so existing consumers cannot be assumed valid.
- `UNKNOWN_REVIEW_REQUIRED` — evidence is insufficient to classify safely.

Unknown is fail-closed. Do not call a change compatible because no failure has yet been observed.

## 3. Semantic contract versioning

Use a three-part semantic contract version `MAJOR.MINOR.PATCH` for the reusable interface, independent of repository commit identity.

- **MAJOR**: breaking change to a consumed electrical/function/resource semantic or removal of a supported contract.
- **MINOR**: backward-compatible added capability or widened supported envelope with evidence.
- **PATCH**: correction/clarification that does not change what a conforming consumer must do.

A commit SHA still identifies the exact implementation/evidence subject. Semantic version identifies compatibility intent. Neither replaces the other.

Do not use a PATCH bump to hide a changed return domain, supply requirement, output default, diagnostic meaning, connector requirement, resource count, safety boundary, or qualification envelope.

## 4. Consumer compatibility matrix

Before release, build:

`consumer_id | machine_class | baseline_id | block_contract_version | consumed_semantic_ids | connection_block_id | resource_binding_ids | machine_overlay_ids | compatibility_class | required_adaptation | stale_evidence_ids | required_regression | migration_state`

At minimum exercise several consumer shapes: mill/lathe discrete I/O, plasma/router field I/O, robot/custom automation, and press-brake control. These may be design exercises rather than invented physical-machine facts. Any real machine-specific current, connector, harness, environment, or configuration value not evidenced remains `VERIFY_AT_MACHINE/TBD`.

The purpose is to expose hidden assumptions. If a block cannot be reused without tribal knowledge, that is a catalog defect.

## 5. Connection blocks absorb board-specific adaptation

A reusable block owns electrical function and reusable contract. A board-specific connection block owns connector family/pins, harness destination, physical placement, labels/silkscreen, board FPGA/logical mapping, and machine overlay.

When a new block version changes a reusable interface, adapt each affected connection block explicitly. Never bake “PRESS_BRAKE_X_FORWARD” or another machine-specific name into the reusable primitive merely to avoid migration work.

## 6. Evidence carry-forward

For every prior evidence item ask:

`evidence_id | tested_subject_revision | tested_contract_semantics | tested_envelope | changed_dependency? | isolation_boundary_reviewed? | carry_forward_or_stale | reason`

A footprint-only correction does not automatically invalidate an unrelated electrical calculation. A return-domain change may invalidate connectivity, isolation, power, fault-path, CAD, and commissioning evidence. A widened current rating requires evidence for the new envelope; evidence for the old envelope may remain valid for old consumers.

Carry-forward is an engineering decision with a recorded boundary, not a convenience flag.

## 7. Deprecation and supersession

Deprecation requires a durable record:

`deprecated_contract_version | replacement_version | reason | affected_consumers | last_supported_baseline | migration_deadline_or_gate | compatibility_notes | retained_evidence | required_regression | removal_condition`

Deprecated does not mean false. Existing frozen baselines may continue to reference the old contract within their proven envelope. New designs should select the replacement unless a documented exception exists.

Removal occurs only after `Where Used` proves no supported consumer silently depends on the old contract, or after each remaining consumer has an explicit accepted exception.

## 8. Staged multi-machine rollout

Roll out by evidence risk, not by machine prestige:

1. publish the new reusable contract and compatibility classification;
2. run reverse `Where Used` and freeze the consumer matrix;
3. migrate one bounded connection/board consumer;
4. perform targeted CAD/resource/power/runtime/bench regression required by the changed semantics;
5. compare observed results with compatibility claims;
6. correct the reusable contract if migration exposes unwritten assumptions;
7. migrate additional machine classes independently; and
8. supersede each consumer baseline only after its own evidence closes.

One successful press-brake migration does not prove a mill, plasma table, robot, or router consumer compatible.

## 9. Current OpenPressBrake worked example

OpenPressBrake main inspected for this lesson: `15d52092689b6cb8f8aa05591c0c3005581bada7`.

Student-facing sources opened and inspected in current form during this run:

- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for primitive/shared-resource rules, material-change maintenance, evidence truthfulness, and baseline-versus-qualification separation.
- `hardware/blocks/digital_output_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for the current one-channel reusable primitive, explicit semantic interfaces, separate logic/process domains, shared-resource scaling, FPGA-resource declaration, non-safety role, and unresolved machine/board envelope facts.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current isolated Rev1 topology status, 27.20-mA `LOGIC_3V3` and separate 18.88-mA `SWITCHED_IO_5V` static handoffs, open KiCad/connector/thermal/qualification work, and explicit safety boundary.
- `board-design/BD75_CONTROLLED_ENGINEERING_CHANGE_BASELINE_SUPERSESSION_AUDIT_HISTORY.md` — **VERIFIED_FOR_LESSON** as prerequisite controlled-change and immutable-baseline method.

These bounded teaching uses do not establish production qualification of the OpenPressBrake board or digital-output block.

## 10. Adversarial example — digital-output contract evolution

The current `digital_output_24v` manifest demonstrates why compatibility needs more than signal names. One reusable primitive is one protected high-side channel. Board integration separately chooses population, connector details, load envelope, shared isolator packing, and process supply sizing.

The current Rev1 path has two distinct static isolation-side loads: for eight outputs, 27.20 mA maximum belongs to `LOGIC_3V3`, while 18.88 mA maximum belongs separately to `SWITCHED_IO_5V`. The returns remain separated; L07 must not be silently bridged to `LOGIC_GND`.

Suppose a future block revision changed isolator technology but preserved `OUTPUT_COMMAND`, `FAULT_OVERLOAD`, and `FAULT_OVERTEMP` names. Compatibility could still be breaking if the new isolator changed rail demand, default state, diagnostic direction/polarity, isolation boundary, unpowered behavior, or shared package/resource scaling. The consumer matrix must review those semantics explicitly.

Conversely, replacing a production part with a proven pin/function/electrical-equivalent device may be PATCH-compatible only if evidence demonstrates that every public guarantee consumed by boards remains valid. “Same footprint” is insufficient.

## 11. Catalog stress-test result

The current catalog has useful manifests and status governance, but it does not yet provide a durable machine-readable contract-version/consumer registry capable of answering:

- which boards consume each semantic ID?
- which exact contract version did each baseline accept?
- is a proposed change compatible for every consumer or only some?
- which board-specific connection blocks require migration?
- which evidence remains valid after the change?
- when may a deprecated contract be removed?
- did a machine-specific adaptation leak back into reusable circuitry?

Required catalog/tooling addition:

`contract_id | semantic_version | semantic_ids | compatibility_from_versions | changed_semantics | consumer_ids | connection_ids | baseline_ids | migration_state | deprecated_by | evidence_ids | unresolved_fact_ids | safety_boundary`

This should integrate with the BD74/BD75 dependency/change graph and reverse `Where Used` capability rather than create a second disconnected source of truth.

## 12. Safety boundary

Ordinary controller compatibility cannot confer safety qualification. A migrated LinuxCNC/FPGA output may monitor safety status or obey an externally supplied enable, but a catalog version bump cannot transfer independent Pilz/AKAS/SICK/STO authority into ordinary logic.

Any changed interface touching a safety-owned boundary requires explicit external safety-owner review. The board-design course records the boundary; it does not replace the independent safety course.

## 13. Lab deliverable

Given one reusable output-block change and four hypothetical consumers (mill, plasma table, robot, press brake), produce:

1. old/new semantic contract versions and change classification;
2. a `Where Used` report;
3. a per-consumer compatibility matrix;
4. board-specific connection adaptations without machine names leaking into the primitive;
5. evidence carry-forward/staleness decisions;
6. targeted regression plans;
7. a deprecation/supersession record when required;
8. staged rollout and rollback gates; and
9. an explicit safety-authority boundary.

At least one consumer must be conditionally compatible and at least one must require migration. Do not invent real machine values; mark unavailable physical facts `VERIFY_AT_MACHINE/TBD`.

## 14. Exit criteria

BD76 is complete when a student can evolve a reusable catalog block across multiple board consumers without confusing implementation similarity with contract compatibility, can prove why old evidence is retained or stale, can migrate board-specific connection blocks independently, and can preserve historical baselines and independent safety authority.

Next curriculum step: **BD77 — Catalog Selection Decision Records and Design-Space Trade Studies**: convert machine requirements into an auditable selection among qualified catalog blocks without choosing by familiarity or first-machine precedent.