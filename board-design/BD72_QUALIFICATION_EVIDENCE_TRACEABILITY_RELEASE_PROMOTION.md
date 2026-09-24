# BD72 — Qualification Evidence Packages, Traceability, and Release Promotion

Status: durable board-design curriculum lane

## Purpose

A design is not qualified because it has many artifacts, because CI is green, or because a machine moved correctly once. Qualification is a controlled argument that each release claim is supported by evidence of the right type, on the right revision, over the claimed envelope, with unresolved facts and regressions visible.

Design flow:

`commissioning evidence -> requirement/evidence traceability -> unresolved-fact disposition -> block-versus-board qualification boundary -> regression obligations -> release review -> qualified baseline without overclaiming`

Central rule:

**EVIDENCE EXISTS is not the same claim as EVIDENCE SUPPORTS THIS RELEASE.**

## Learning objectives

Students shall be able to:

1. build requirement-to-evidence traceability without allowing one artifact to prove unrelated claims;
2. distinguish datasheet, calculation, simulation, structural automation, synthesis/timing, bench, machine and human-review evidence;
3. preserve exact source/revision and declared operating envelope for every qualification claim;
4. distinguish reusable-block qualification from board integration and machine qualification;
5. keep TBD and VERIFY_AT_MACHINE facts visible through release review;
6. derive regression obligations when a source, component, contract, PCB, firmware or machine assumption changes;
7. reject stale, superseded or scope-mismatched evidence; and
8. promote only the claims actually closed by current evidence.

## 1. Qualification is claim-scoped

Write the release claim before collecting evidence. A useful qualification item contains:

- stable requirement/claim ID;
- owner: reusable block, shared resource, board connection, complete board, firmware/runtime, or machine;
- exact subject revision;
- claimed envelope and exclusions;
- evidence type required;
- evidence artifact/revision actually supplied;
- result and reviewer;
- unresolved dependencies;
- regression triggers; and
- promotion state.

Do not use a generic `verified: true` field. Qualification is many claims with different owners and evidence strengths.

## 2. Evidence classes and what they can prove

| Evidence class | Appropriate claim | Does not by itself prove |
|---|---|---|
| manufacturer datasheet/reference | device limits, reference topology, manufacturer-stated behavior | board implementation or machine wiring |
| calculation | bounded electrical/thermal/resource result under stated assumptions | implementation correctness outside those assumptions |
| simulation/model | modeled behavior for named cases | physical manufacturing, unmodeled faults, machine behavior |
| structural/CI check | encoded invariants and file consistency actually checked | electrical qualification or unencoded requirements |
| FPGA synthesis/P&R/timing | implementation fit/timing for exact constraints/tool revision | board wiring or machine behavior |
| ERC/DRC | CAD-rule compliance for encoded rules | semantic authority, connector identity, full qualification |
| bench test | physical board behavior under recorded fixture/conditions | machine harness/load/environment outside test scope |
| machine verification | installed behavior for recorded machine/configuration | reusable block's entire generic envelope |
| human review/signoff | reviewed release decision and disposition | missing technical evidence |

Evidence can be complementary. It is not interchangeable.

## 3. Traceability matrix

For each release candidate construct a matrix with at least:

`claim_id | owner | requirement | source_revision | required_evidence | evidence_ref | evidence_revision | envelope | result | unresolved | regression_triggers | release_effect`

Use these release effects:

- `SUPPORTS_CLAIM`
- `PARTIAL_SUPPORT`
- `BLOCKS_PROMOTION`
- `INFORMATION_ONLY`
- `SUPERSEDED`

A passing artifact is `INFORMATION_ONLY` for a claim it was not designed to test.

## 4. Unresolved-fact disposition

Every `TBD`, `VERIFY_AT_MACHINE`, open checklist item, waiver, and deferred qualification item must have one disposition:

- close with evidence;
- explicitly exclude from the release envelope;
- defer to a later release while proving it cannot invalidate the present claimed use;
- block promotion; or
- mark the affected artifact deprecated/superseded.

Never silently turn a physical unknown into a design assumption. A machine connector marked `VERIFY_AT_MACHINE` remains unresolved even if the electrical pinout is frozen.

## 5. Block qualification versus board qualification

A reusable block owns its electrical function and generic contract. Its qualification can support many boards only within the tested/calculated envelope.

Board integration owns instance count, package packing, connector choice, resource allocation, rail loading, return paths, placement, inter-block interactions, FPGA mapping and board-specific enable/authority chains.

Machine qualification owns installed harness identity, real loads/sensors, direction/scaling, machine timing, environment and machine-specific acceptance.

Therefore:

`qualified reusable block + qualified reusable block != qualified board`

and:

`qualified board on bench != qualified installed machine`.

## 6. Current OpenPressBrake worked-example audit

OpenPressBrake main inspected for this lesson: `f47055c36683ee0f951d62ed3896331285eb0dee`.

The following student-facing sources were opened and inspected in their current form during this run:

- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for formal maturity levels, baseline-versus-Rev-1 separation, truthfulness, and maintenance/regression rules.
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current ISO1212 evidence inventory and explicit `SIMULATION-READY` boundary. It has concrete production-connectivity, BOM, calculation and bounded simulation evidence, but PCB/layout review, cost/dependencies and human Rev-1 signoff remain open.
- `hardware/blocks/digital_input_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for the reusable electrical/resource contract and declared TBDs, including ambient/temperature, PCB dimensions and qualification items.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for current board-specific allocation, domain/authority contracts and explicit schematic/PCB release gates. Its status does not constitute physical board qualification.
- `hardware/REV1_CONNECTOR_MAP.yaml` — **VERIFIED_FOR_LESSON** for electrical pinout authority and explicit unresolved mechanical/harness facts. Its status remains `electrical_pinout_frozen_mechanical_parts_and_coordinates_tbd`.
- `board-design/BD71_BENCH_BRINGUP_EVIDENCE_FAULT_INJECTION_COMMISSIONING.md` — **VERIFIED_FOR_LESSON** as the prerequisite commissioning-evidence method.

These files are usable to teach qualification boundaries. They do not support calling the current OpenPressBrake board production-proven.

### Worked traceability example: ISO1212 input

The current checklist provides several different evidence classes for the reusable digital-input circuit: exact intended connectivity, exact production BOM/value consistency, datasheet/boundary calculations, a bounded ngspice endpoint run, vendor-model provenance inspection, board-contract integration checks and a proven-reference rebase.

Those artifacts support different claims. The bounded ngspice run supports only the cases it executes. The board-contract check supports encoded integration invariants. Neither closes PCB/layout review or human Rev-1 signoff. Under current status governance the block therefore remains `SIMULATION-READY`, not `SCHEMATIC-READY` or `REV 1 READY`.

The manifest also retains unresolved board-level quantities such as trace/via rules, ambient design and temperature rise. Those must not disappear merely because the electrical topology is mature.

### Worked traceability example: connector authority

The current connector map freezes electrical pinout intent while explicitly leaving connector manufacturer/series/keying/footprint/coordinates and several harness facts to physical verification. The board integration file also carries pre-PCB physical release gates.

Therefore an ERC-clean schematic or successful bench test using a temporary fixture cannot close the production connector/mechanical claims. Those claims remain `VERIFY_AT_MACHINE`/TBD until the required physical evidence exists.

## 7. Regression obligations

Every accepted evidence item needs triggers that make it stale. Typical triggers include:

- component MPN/value/package change;
- declared voltage/current/temperature/transient envelope change;
- topology or protection change;
- PCB stackup/layout/return-path change relevant to the claim;
- connector/pin/footprint change;
- power-domain or shared-resource allocation change;
- FPGA pin/bank/clock/resource change;
- firmware transport or watchdog semantic change;
- generated HAL/runtime binding change;
- machine harness/load/sensor change; or
- correction to the source authority.

When a trigger fires, mark affected evidence stale before promotion. Re-run only the checks whose assumptions or implementation were affected, plus dependent checks identified by the dependency graph. Do not rerun unrelated simulation merely for ceremony.

## 8. Evidence package

A release evidence package should include:

1. release candidate identity and immutable revisions;
2. claimed envelope and exclusions;
3. requirement/claim traceability matrix;
4. block maturity/status snapshots;
5. board connection/resource/power authority revisions;
6. calculation and datasheet evidence;
7. simulation/structural/synthesis/ERC/DRC evidence where required;
8. bench and machine records where required;
9. unresolved-fact register and waivers;
10. anomaly/failure/retest history;
11. regression/staleness report; and
12. human release decision with scope.

Preserve failures and superseded evidence. A qualification package is an audit trail, not a folder containing only green results.

## 9. Promotion decision

Use claim-scoped promotion gates:

- `REQUIREMENTS_BASELINED`
- `EVIDENCE_REQUIREMENTS_DEFINED`
- `TRACEABILITY_COMPLETE`
- `NO_UNDISPOSITIONED_UNKNOWNS`
- `REQUIRED_BLOCK_EVIDENCE_CURRENT`
- `BOARD_INTEGRATION_EVIDENCE_CURRENT`
- `REQUIRED_BENCH_EVIDENCE_CURRENT`
- `REQUIRED_MACHINE_EVIDENCE_CURRENT`
- `REGRESSION_OBLIGATIONS_CLEAR`
- `HUMAN_RELEASE_REVIEW_COMPLETE`

A release may deliberately omit a gate only when its claim/envelope does not require that evidence and the exclusion is explicit. For example, a reusable block qualification need not prove one machine's connector coordinates; a machine PCB release does.

## 10. Catalog stress-test result

Teaching release promotion exposes a catalog infrastructure gap: block checklists contain valuable evidence inventories, but there is not yet a common machine-readable qualification manifest joining stable claim IDs to evidence type, subject revision, tested envelope, result, unresolved dependencies, regression triggers, staleness and release effect.

A future catalog qualification schema should permit automatic questions such as:

- Which release claims have no supporting evidence?
- Which evidence predates a changed dependency?
- Which passing CI result is being asked to support a claim outside its scope?
- Which board claim depends on a block whose maturity was downgraded?
- Which `VERIFY_AT_MACHINE` fact still blocks PCB or machine release?
- Which claims require human review after an engineering change?

This is a catalog/tooling defect, not a reason to add unwritten knowledge to the lesson. OpenPressBrake remains read-only because current main has advanced active engineering work; this curriculum run does not race those changes.

## 11. Transfer beyond OpenPressBrake

The same qualification structure applies to mills, lathes, plasma tables, routers, robots and automation cells. A reusable 24-V input can carry electrical qualification across machines; connector, allocation, harness and machine acceptance remain instance-specific. A proven encoder receiver does not prove a lathe spindle index scaling, and a qualified output driver does not prove a robot brake sequence.

## 12. Lab deliverable

Given a release candidate with block contracts, board integration authority, commissioning records and current status files, produce:

1. a minimum 12-row claim/evidence traceability matrix spanning block and board claims;
2. at least five examples where an existing artifact is insufficient for a stronger claim;
3. an unresolved-fact disposition table;
4. a regression-trigger map for at least six evidence items;
5. a release evidence-package index;
6. a promotion decision that names exactly which scope is qualified and which is not; and
7. one catalog defect/action item exposed by the exercise.

A passing answer must reject overclaiming even when every available automated test is green.

## Safety boundary

Ordinary controller qualification does not certify an independent personnel-safety function. Monitoring Pilz/SICK/AKAS state, testing an ordinary watchdog/output inhibit, or proving a board's normal-control safe default does not transfer safety authority to LinuxCNC or FPGA logic. Safety-rated design and validation remain separate.

## Next checkpoint

BD73 — Whole-Board Kitchen-Sink Release Review and Evidence Closure:

`qualified block evidence + connection closure + FPGA/resource plan + power/return closure + authority/freshness + CAD/ERC + commissioning evidence -> cross-domain release audit -> contradiction/staleness search -> unresolved gate register -> release disposition`
