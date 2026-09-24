# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-24

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD62 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD62_CONNECTION_CONTRACT_AGGREGATION_CONNECTOR_PANEL_ALLOCATION_AND_COLLISION_CHECKING.md`.

BD62 teaches:

`qualified connection contracts -> connector population/placement plan -> pin/contact/current aggregation -> shared field-power/return/shield resources -> FPGA/function bindings -> mechanical/label/access collisions -> harness-service review -> machine-readable board connector manifest -> whole-board consistency gate`

## BD62 hard student-material audit

Every repository file named to students as finished material by BD62 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD61_CONNECTION_BLOCK_COMPLETENESS_SEMANTIC_ENDPOINT_IDENTITY_AND_HARNESS_CLOSURE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml`
- OpenPressBrake `hardware/blocks/lvdt_input/integration/REV1_RESOURCE_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md`

`ENGINEERING_REVIEW_NEEDED` as a complete evidence-discovery surface:

- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md` — bounded status claims are useful and current, but its `Evidence currently present` list does not name the newly current `integration/REV1_RESOURCE_CONTRACT.yaml`. This is status/evidence-index drift, not proof that the resource contract is invalid.

BD62 itself was re-opened from current main after commit.

## Rules frozen by BD62

- individually valid connection contracts do not prove a valid connector panel;
- aggregate board allocation is a separate engineering layer from reusable block definition and per-instance connection definition;
- duplicate physical pins, semantic endpoints, FPGA resources, ADC/DAC channels, logical-function instances, and shared-resource claims fail closed;
- contact/device current ratings do not substitute for complete source/protection/copper/connector/harness/thermal/simultaneity closure;
- power and return aggregation must preserve domain identity and trace source-to-load-to-return paths;
- unlike rail currents must not be naively summed across conversion boundaries;
- FPGA aggregation includes package/bank/electrical constraints plus logical-function and shared-bus/peripheral capacity;
- connector allocation includes mating body, insertion/removal direction, latch/screw access, cable bend/strain relief, enclosure interfaces, labels, and service space, not merely PCB footprint area;
- unsupported physical-machine and harness facts remain `VERIFY_AT_MACHINE`/`TBD` and cannot be guessed to make the panel fit;
- reusable shared resources are instantiated at board scale rather than duplicated inside machine-count variants; and
- ordinary LinuxCNC/FPGA connector completeness receives zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `lvdt_input` is historically named but its current Rev-1 contract is a powered three-wire 0–12 V valve-position feedback primitive. Per instance it requires `SENSOR_24V`, `SENSOR_RETURN`, `POSITION_0_12V`, one ADS7953 channel, and no direct FPGA GPIO.

Its newly current `integration/REV1_RESOURCE_CONTRACT.yaml` publishes three field connector positions, one protected sensor-power branch, and one ADS7953 channel per primitive. It records two first-machine instances as configuration only, not reusable primitive scope. Therefore first-machine aggregation implies six field positions, two protected sensor-power branches, and two ADC channels before any connector family or physical packing is accepted.

The same authority refuses to invent installed sensor current, valid endpoint, source impedance, return arrangement, or cable/shield facts. The manifest keeps connector current rating and installed wire range parameterized. The status checklist keeps sensor-power branch protection, board integration, CAD/ERC/DRC, bench validation, and human release review open.

BD62 therefore demonstrates truthful aggregate requirements while intentionally refusing to claim that a particular connector family, contact rating, branch fuse/current limit, wire gauge, or enclosure placement is accepted.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for a first-class machine-readable board connector manifest that aggregates all connection contracts and mechanically checks uniqueness/capacity/collisions across physical pins, semantic IDs, electrical classes, field power/returns/shields, shared resources, FPGA/logical functions, placement/access, harness destinations, and unresolved machine facts.

This is board-integration infrastructure, not a reason to turn the reusable `lvdt_input` primitive into a fixed two-channel/six-terminal machine-specific block.

A secondary defect is the `lvdt_input` status/evidence-index drift described above. OpenPressBrake remained read-only because current main had just advanced this block's Rev1 resource contract; the curriculum records the defect rather than racing active engineering work.

## Current repository reconciliation

At run start the durable board-design lane ended at BD61. Concurrent safety-curriculum work had advanced curriculum main after the BD61 checkpoint and was preserved.

Immediately before BD62 was written, curriculum main was `62e9a1baa3606f33edeb242db3c254b7f0f34972` and OpenPressBrake main was `180331961cce34e952d852cdae0a36a2d271b99a` (`lvdt input: publish Rev1 board resource contract`). OpenPressBrake stayed read-only.

BD62 was committed as `201e2f07ce2f1b0fd3dc2977e7e8ce48cddead4f` and re-opened from current main before this checkpoint update.

## Next exact work

Build BD63 on **board-wide power-domain, return-current, shield/chassis, and fault-containment closure**:

`connector manifest + block power contracts -> source/protection tree -> per-domain load/current ledger -> startup/inrush/simultaneity -> return-current tracing -> shield/chassis bonds -> partial-power/backfeed states -> fault containment -> machine-readable power/ground manifest -> whole-board release gate`

Stress that individually protected blocks can still fail as a board through shared-source limits, return coupling, wrong bond topology, startup/inrush, back-power paths, or fault propagation. Do not infer installed-machine current, grounding, shielding, or transient facts.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD62. No GitHub-hosted compute was initiated. Future target executable checks, when justified, must use `[self-hosted, openpressbrake]` only.

## Safety boundary

BD62 teaches aggregate connector/resource closure for ordinary controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. LinuxCNC/FPGA feedback, watchdogs, inhibits, STO interfaces, status monitoring, and collision-free ordinary wiring remain zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
