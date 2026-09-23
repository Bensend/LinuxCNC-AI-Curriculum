# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD53 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD53_SEMANTIC_MIGRATION_VERIFICATION_GOLDEN_CORPORA_AND_NEGATIVE_COMPATIBILITY_TESTS.md`.

BD53 teaches:

`migration rules -> representative historical corpus -> expected canonical outputs -> negative/ambiguous cases -> round-trip/loss checks -> consumer-impact oracle -> regression gate -> migration release`

## BD53 hard student-material audit

Every repository file named to students as finished material by BD53 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `hardware/4000-board-design/BD52_SEMANTIC_SCHEMA_EVOLUTION_BACKWARD_COMPATIBILITY_AND_MIGRATION_SAFETY.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/integration/REV1_ISOLATED_INTERFACE_BOM.yaml`
- OpenPressBrake `hardware/blocks/digital_output_24v/integration/validate_rev1_board_contract.py` as current validator source

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` for current progress reporting. It still leaves the Rev1 validator-source update item unchecked even though current validator source already contains the named isolation/BOM/domain assertions. This does not prove authorized execution and does not advance formal block status.

BD53 itself was re-opened from current main after commit.

## Rules frozen by BD53

- parser acceptance is not proof of safe semantic migration;
- positive golden fixtures and negative/ambiguous fixtures are both required;
- historical fixtures must retain exact provenance rather than silently tracking current main;
- expected migration outputs compare canonical engineering semantics, including owner/evidence/unresolved state;
- every “must not infer” rule should have a negative case that attempts the prohibited inference;
- round-trip byte success is insufficient without target-schema semantic assertions;
- unit migrations require limit-boundary and precision behavior checks where engineering decisions depend on the value;
- migration verification includes downstream consumer-impact disposition, not only transformed data;
- golden fixtures themselves require stale/supersession checks;
- status checkbox, source implementation, authorized execution evidence, formal block status, and release state are separate facts;
- ordinary-control migration cannot manufacture personnel-safety authority;
- required executable migration regressions use only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake Rev1 isolated digital-output authority publishes explicit board-level scaling and domain invariants: `STISO621=N`, `STISO620=ceil(N/2)`, two 100-nF decouplers per isolator package, three 220-kOhm field pull-downs per output, logic-side `LOGIC_3V3/LOGIC_GND`, field-side `SWITCHED_IO_5V/L07_SWITCHED_IO_RETURN`, and no copper bridge between logic ground and L07.

The current board-contract validator source asserts those population/domain/pin/provenance relationships and also preserves the ordinary-control versus retained-Pilz safety boundary. These make strong negative migration/generation cases: ground-domain collapse, side-direction reversal, machine population leaking into reusable primitive definition, quantity loss, invented machine load values, and safety-authority transfer must all fail or remain unresolved.

The block is not presented as schematic-ready or Rev-1 released. Current checklist still leaves exact KiCad symbol/footprint binding, rendered connectivity/ERC, PCB isolation/return-path, thermal/current-path, machine facts, FPGA assignment, and human release open.

## Catalog stress-test result

The hard audit exposed a concrete status-maintenance defect: current validator source has advanced beyond the checklist's unchecked “update validator” progress item. This is **ENGINEERING_REVIEW_NEEDED** status drift, not proof of validator execution.

BD53 also confirms missing durable infrastructure for a provenance-pinned migration regression corpus and a status/evidence consistency layer that distinguishes source implementation, authorized execution evidence, formal block status, and release state.

OpenPressBrake remained read-only because current main is actively integrating the digital-output Rev1 path.

## Current repository reconciliation

At run start the board-design lane ended at BD52. Curriculum main also contained concurrent safety-course work; it was preserved. OpenPressBrake current main was `e6a674da9afb5b30a2e3ee207bd27ddaf91908ff` (`digital output: enforce Rev1 isolated integration invariants`).

BD53 was committed as `9776c84c6762ac3db37c532a075388973bbdce41` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD53 commit and OpenPressBrake remained at `e6a674da9afb5b30a2e3ee207bd27ddaf91908ff`. OpenPressBrake stayed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD54 on **semantic dependency coverage, mutation testing, and validator adequacy**:

`semantic rules -> validator claims -> targeted mutations -> expected detection -> undetected mutation analysis -> dependency-coverage map -> validator improvement -> adequacy gate`

Stress validators that pass happy-path fixtures but do not actually detect wrong return domains, wrong resource ownership, missing default states, quantity/accounting drift, stale authority, or ordinary-control/safety-boundary leakage. Teach that a validator's adequacy claim requires demonstrated detection of representative faults, not merely a green current tree.

## Compute

No simulation, synthesis, place-and-route, timing run, migration executable, or other executable engineering verification was justified for BD53. Current validator source was inspected but not represented as executed evidence. No GitHub-hosted runner was used.

## Safety boundary

BD53 teaches migration verification for ordinary board-design authority. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. A migration negative corpus should explicitly prove that ordinary-control source data cannot acquire safety authority through schema transformation.