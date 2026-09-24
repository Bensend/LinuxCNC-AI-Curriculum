# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-24

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD61 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD61_CONNECTION_BLOCK_COMPLETENESS_SEMANTIC_ENDPOINT_IDENTITY_AND_HARNESS_CLOSURE.md`.

BD61 teaches:

`machine endpoint -> board connection requirement -> connector family/pin -> signal/power/return semantics -> reusable block endpoint -> FPGA/logical endpoint -> physical placement/silkscreen -> harness destination -> verification -> release-consumable connection contract`

## BD61 hard student-material audit

Every repository file named to students as finished material by BD61 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD60_RELEASE_MANIFEST_CLOSURE_CANDIDATE_COMPLETENESS_AND_CROSS_DOMAIN_PROMOTION_GATES.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/differential_encoder/manifest.yaml`
- OpenPressBrake `hardware/blocks/differential_encoder/integration/REV1_RESOURCE_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`

BD61 itself was re-opened from current main after commit.

## Rules frozen by BD61

- a reusable block contract does not define a board connection;
- reusable blocks own generic electrical function/contracts, while board-specific connection blocks own connector/pins, placement, labels, harness destination, machine mapping, and board-specific resource bindings;
- every connection needs a stable semantic endpoint identity that survives schematic, PCB, FPGA, firmware/HAL, harness, commissioning, and release representations;
- a signal without its return/reference is not a complete electrical connection;
- connection contracts must state power, return, shield/chassis, default/de-energized, enable, protection, and partial-power dependencies when relevant;
- a connection block may map compatible interfaces but must not secretly contain unqualified transformation circuitry;
- real translation/isolation/conditioning/protection belongs in a reusable adapter/interface block when it is an independently meaningful electrical function;
- FPGA connection closure includes both physical I/O allocation and required logical-function allocation; counting GPIO alone is insufficient;
- physical connector family, footprint, mating hardware, pinout, placement, silkscreen, harness destination, and installed-machine facts are evidence-bearing release facts rather than convenient assumptions;
- unsupported machine facts remain `VERIFY_AT_MACHINE`/`TBD` and fail closed when required by the release claim; and
- ordinary LinuxCNC/FPGA controller connections receive zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `differential_encoder` remains a good reusable primitive: one encoder per instance, A/Abar/B/Bbar/Z/Zbar field inputs, A/B/Z 3.3-V logic outputs, explicit terminated/unterminated variants, connector-edge protection to `CHASSIS_PE`, and board-owned optional encoder field power.

Its current `integration/REV1_RESOURCE_CONTRACT.yaml` now explicitly requires one LiteX-CNC encoder function instance for every populated primitive in addition to three FPGA inputs. LUT/register counts remain unresolved until target synthesis or authoritative accounting; they were not invented for the lesson.

The same contract deliberately leaves physical connector/pin mapping, installed encoder type, cable topology/termination, field voltage/current/startup demand, return arrangement, existing machine protection, and final machine wire mapping as board/machine obligations. The status checklist independently keeps termination selection, protected encoder field-supply implementation, cable/reflection qualification, PCB integration, and release gates open.

Therefore the reusable encoder/resource contract is useful evidence but is not itself a complete board connection contract. BD61's example schema intentionally remains `BLOCKED_UNKNOWN` rather than fabricating connector facts.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for first-class board connection-contract infrastructure joining stable machine endpoint IDs to connector/pin/physical placement/silkscreen, reusable block endpoints, power/return/shield ownership, FPGA physical and logical resources, harness destination, assembly variant, commissioning evidence, and unresolved physical facts.

This is a board-integration infrastructure gap, not a reason to contaminate the reusable encoder primitive with OpenPressBrake-specific connector or harness assumptions.

OpenPressBrake remained read-only because current main had just advanced the differential-encoder resource contract. No active engineering files were overwritten.

## Current repository reconciliation

At run start the durable board-design lane ended at BD60 despite newer chat summaries describing later BD numbers; repository artifacts were treated as authoritative. Concurrent safety-curriculum work on curriculum main was preserved.

BD61 was committed as `33b593a1db71fd1ccbc4bd6eeb0a407f2b880deb` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD61 commit and OpenPressBrake main was `4845ab6ab2355b677fd54f8cdf2f028180fd10d2` (`encoder: close LiteX-CNC logic instance resource contract`). OpenPressBrake stayed read-only.

## Next exact work

Build BD62 on **connection-contract aggregation, connector-panel allocation, and collision checking**:

`qualified connection contracts -> connector population/placement plan -> pin/contact/current aggregation -> shared field-power/return/shield resources -> FPGA/function bindings -> mechanical/label/access collisions -> harness-service review -> machine-readable board connector manifest -> whole-board consistency gate`

Stress that individually correct connection blocks can still conflict at board level through connector density, contact/current limits, duplicated pins/resources, shared field-power/return capacity, shield/chassis topology, inaccessible placement, ambiguous labels, mating-clearance constraints, or FPGA-function collisions. Preserve physical machine and harness facts as `VERIFY_AT_MACHINE` until evidence exists.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD61. No GitHub-hosted compute was initiated. Future target synthesis/resource checks, when justified, must use `[self-hosted, openpressbrake]` only.

## Safety boundary

BD61 teaches board-specific connection closure for ordinary controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Encoder feedback, LinuxCNC/FPGA mappings, watchdogs, inhibits, STO interfaces, and status monitoring remain zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
