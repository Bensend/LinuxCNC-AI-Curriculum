# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD60 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD60_RELEASE_MANIFEST_CLOSURE_CANDIDATE_COMPLETENESS_AND_CROSS_DOMAIN_PROMOTION_GATES.md`.

BD60 teaches:

`required board claims -> claim coverage matrix -> block/connection/resource/evidence locks -> generated electrical + FPGA + LinuxCNC/HAL artifacts -> unresolved-fact closure -> cross-domain consistency gate -> candidate completeness decision -> release handoff`

## BD60 hard student-material audit

Every repository file named to students as finished material by BD60 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD59_EVIDENCE_CONSUMPTION_LOCKS_RELEASE_MANIFESTS_AND_STALE_PROOF_REJECTION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/integration/REV1_RESOURCE_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml`

`ENGINEERING_REVIEW_NEEDED` as complete current-status/evidence-discovery authority:

- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md` — its `Evidence currently present` list does not name the already-current `integration/REV1_RESOURCE_CONTRACT.yaml`. Its bounded status and engineering claims remain useful, but complete current evidence discovery cannot be proven from the status surface alone. This is status/evidence-index drift under `STATUS_RULES.md` maintenance expectations.

BD60 itself was re-opened from current main after commit.

## Rules frozen by BD60

- release completeness is a conjunction over required semantic claims, not the average maturity of component blocks;
- all reusable blocks usable does not imply the board candidate is release-complete;
- ERC success, synthesis success, HAL load success, or a device rating cannot substitute for cross-domain closure;
- every required claim must have a stable identity, owner domain, current authority/evidence lock, consumer set, negative scope, dependencies, and closure state;
- release-satisfying states are `CLOSED_CURRENT`, justified `CLOSED_CURRENT_NARROWED`, and justified `NOT_REQUIRED`; unresolved, missing, conflicting, stale, or superseded claims fail closed;
- complete field-I/O closure traces machine semantic through HAL, FPGA logical/physical resources, electrical block, board connection, connector/harness/load, return path, and source/protection;
- reusable blocks own generic electrical function/contracts while board-specific connection blocks own connector/pins, location, labels, harness destination, and board mappings;
- component/device ceilings must not be promoted into board channel ratings without the complete current-path/thermal/protection/load envelope;
- unlike rail currents must not be naively summed across power-conversion boundaries;
- generated electrical, FPGA, and LinuxCNC/HAL consumers must agree on the same semantic identities and exact current authority;
- promotion must recheck claim-relevant dependency heads immediately before release; and
- ordinary LinuxCNC/FPGA controller closure receives zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `relay_contactor_driver/integration/REV1_RESOURCE_CONTRACT.yaml` correctly keeps one protected 24-V external coil per reusable primitive and separates generic block resources from board configuration. Per instance it publishes one FPGA `COIL_COMMAND`, diagnostic inputs as declared by the manifest/frozen netlist, a conservative 4.2-mA `LOGIC_3V3` source allocation, and field-electronics overhead separately from external coil current.

Most importantly, its 2.4-A IPS1025H value is explicitly a semiconductor device ceiling, not a released OpenPressBrake board/connector channel rating. Release rating is constrained by the complete path: device electrical/thermal envelope, PCB copper/vias, connector/contact/wire, branch protection, shared 24-V source/distribution, ambient/enclosure, simultaneous channels, and repetitive inductive-demagnetization assumptions.

Current `manifest.yaml` agrees and still leaves the published controller continuous-current value, connector rating, copper geometry, simultaneous-load qualification, branch coordination, field return, output-short, inductive-turnoff, and repeated-cycle thermal evidence open. A hypothetical board with current reusable block evidence plus valid FPGA/HAL mappings therefore still fails release closure if its installed coil facts, connector/current path, simultaneity, or protection remain unresolved.

The adversarial finding is that the authoritative relay-driver status checklist does not yet name the new resource contract in its evidence list. This repeats the evidence-index drift class exposed by BD59 and reinforces the need for machine-readable claim closure rather than heuristic evidence discovery.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for board-level closure infrastructure joining stable claim IDs, reusable block/adapter authority, board-specific connection blocks, power/return resources, FPGA allocation, generated schematic/PCB/BOM, LinuxCNC/HAL mapping, physical-machine facts, evidence locks, cross-domain consistency, reverse Show Where Used, and race-safe candidate promotion.

OpenPressBrake remained read-only because the relay-driver integration/resource-contract area had just advanced on current main. The evidence-index drift was recorded rather than racing active engineering work.

## Current repository reconciliation

At run start the board-design lane ended at BD59. Curriculum main also contained concurrent non-board-design curriculum work and was preserved. OpenPressBrake had advanced from the prior RS-485 handoff through DAC power work to the current relay/contactor-driver machine-readable resource handoff.

BD60 was committed as `8765c26a7adad4f2141dbabc49587c30d2c00383` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD60 commit and OpenPressBrake main was `62b74e77b265cf2ab60861890d066e0622c6391c` (`relay driver: publish machine-readable Rev1 resource contract`). OpenPressBrake stayed read-only.

## Next exact work

Build BD61 on **connection-block completeness, semantic endpoint identity, and harness closure**:

`machine endpoint -> board connection requirement -> connector family/pin -> signal/power/return semantics -> FPGA/logical endpoint -> physical placement/silkscreen -> harness destination -> verification -> release-consumable connection contract`

Stress the distinction between a reusable electrical block and the board-specific connection mold. Require a connection contract to be complete enough that schematic generation, PCB placement, FPGA/HAL mapping, harness documentation, commissioning, and release closure can consume it without unwritten machine knowledge. Treat any missing pin, return, enable/default, location, label, destination, current/voltage class, or unresolved machine fact as an explicit closure defect rather than leaking it into the reusable block.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD60. No GitHub-hosted compute was initiated.

## Safety boundary

BD60 teaches complete-controller release closure for ordinary board-design/controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Ordinary LinuxCNC/FPGA watchdogs, inhibits, diagnostics, STO interfaces, and status monitoring remain zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
