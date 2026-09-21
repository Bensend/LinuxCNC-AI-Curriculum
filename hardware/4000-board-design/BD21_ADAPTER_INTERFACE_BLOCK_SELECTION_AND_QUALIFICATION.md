# BD21 — Adapter/Interface Block Selection and Qualification During Board Composition

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK ENGINEERING <-> BOARD INTEGRATION  
**Design-flow position:** selected reusable blocks -> interface compatibility audit -> direct integration / block correction / adapter / board mapping / unresolved -> qualification -> board composition

## Purpose

A board assembled from individually valid reusable blocks can still be architecturally wrong at their boundaries. The integrator must not repair mismatches by silently changing a reusable block, hiding circuitry in schematic glue, or turning ordinary pin mapping into a fake reusable block.

The required classification is:

- `DIRECT_INTEGRATION`
- `BLOCK_CONTRACT_DEFECT`
- `ADAPTER_REQUIRED`
- `BOARD_INTEGRATION_MAPPING`
- `UNRESOLVED`

This lesson teaches students to classify boundaries before drawing circuitry and to qualify a real adapter with the same rigor as any other reusable hardware block.

## Student-facing source audit

The following CURRENT files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — current mandatory authority for reusable-block, adapter and board-integration ownership.
- Curriculum `hardware/4000-board-design/BD20_MACHINE_READABLE_POWER_BUDGET_DEPENDENCY_GRAPHS_AND_RELEASE_GATES.md` — current preceding lesson, reopened so this lesson extends rather than contradicts the fail-closed dependency method.
- Curriculum `PROGRESS.md` — current repository-wide curriculum checkpoint; board design remains an independent lane and must not overwrite the safety-course priority.

The current OpenPressBrake main was also re-read immediately before this lesson was written. It was at `39568cda1be5cd28624f593c8098d51deafcd7db` (`lvdt_input: define Rev10 PCB analog handoff constraints`). Because active board engineering is changing interface/integration details, OpenPressBrake is consumed read-only in this lesson.

No current OpenPressBrake board or block is presented here as production-proven.

## 1. Start with two contracts, not two schematic symbols

For every proposed boundary, compare the published interfaces before drawing a wire. At minimum compare:

- signal meaning and direction;
- voltage/current ranges and thresholds;
- source/sink behavior and drive strength;
- logic family and power-domain assumptions;
- analog common-mode/range/impedance;
- differential/single-ended semantics;
- isolation boundary;
- return/reference requirements;
- startup/unpowered/default behavior;
- fault/protection expectations;
- timing/data-rate requirements;
- FPGA/bus resources;
- safety-authority boundary.

A matching pin name is not proof of compatibility.

Freeze:

**SAME SIGNAL NAME != COMPATIBLE INTERFACE CONTRACT.**

## 2. The five-way classification

### `DIRECT_INTEGRATION`

Use this only when both published contracts already match electrically and semantically. Board integration may assign instances, nets, FPGA resources and connection molds, but adds no transformation circuitry.

### `BLOCK_CONTRACT_DEFECT`

Use this when one reusable block's generic contract is wrong, incomplete, unsafe, or unnecessarily restrictive for the function it claims to provide. Correct the block on generic engineering grounds and requalify affected claims. Do not call a board convenience a block defect.

### `ADAPTER_REQUIRED`

Use this when two valid interfaces require a real transformation: level translation, isolation, differential conversion, analog scaling/buffering/filtering, protocol/physical-layer conversion, current/voltage conversion, or independently meaningful conditioning/protection.

The adapter owns only that transformation.

### `BOARD_INTEGRATION_MAPPING`

Use this when the work is board-specific composition only: instance assignment, compatible net connection, connector pin mapping, FPGA pin allocation, placement, silkscreen, harness destination or routing constraints.

A wire is not a catalog block.

### `UNRESOLVED`

Use this when evidence is insufficient. Unknown machine facts remain `VERIFY_AT_MACHINE`/TBD. Do not invent a voltage, pin function, termination, return path or machine destination merely to force a classification.

## 3. Adapter versus connection mold

These are intentionally different artifacts.

A **reusable adapter** owns an electrical transformation and remains meaningful after machine name, board name, connector numbers and instance count are removed.

A **board-specific connection block/mold** owns physical connection facts for this board: connector type/pins, power/ground requirements, semantic mapping, FPGA/logical mapping, board location, labels/silkscreen and harness/machine destination.

A connection mold can consume an adapter output. It does not become the adapter.

Freeze:

**ELECTRICAL TRANSFORMATION != BOARD-SPECIFIC CONNECTION DEFINITION.**

## 4. Adapter qualification contract

A real adapter is a reusable hardware block and needs, as applicable:

1. A-side published interface contract;
2. B-side published interface contract;
3. exact transformation claim;
4. topology/reference provenance;
5. electrical calculations and derating;
6. power and return contract;
7. startup/default/unpowered behavior;
8. protection and fault containment;
9. FPGA/bus/resource requirements, if any;
10. exact connectivity and BOM authority;
11. verification evidence and acceptance criteria;
12. qualification envelope;
13. machine-readable contract data;
14. regression/change triggers;
15. explicit safety boundary.

Do not qualify an adapter merely because a prototype passed one nominal bench test.

## 5. Adversarial classification examples

### Example A — FPGA 3.3-V logic to a block that already publishes compatible 3.3-V CMOS input thresholds

No electrical transformation is required. FPGA pin assignment belongs to the board resource plan.

Classification: `DIRECT_INTEGRATION` plus board-specific mapping.

### Example B — valid 3.3-V logic output to a valid 5-V-only logic input whose VIH cannot be guaranteed by 3.3 V

Neither neighboring block is necessarily defective. A real level transformation is required.

Classification: `ADAPTER_REQUIRED` unless another already-qualified compatible block is selected instead.

### Example C — differential sensor receiver block feeding FPGA differential resources when the receiver's published output is actually single-ended logic

If the integrator assumed differential semantics from the field side and the receiver contract clearly says single-ended FPGA output, the error is board composition, not a reason to modify the receiver.

Classification: choose compatible FPGA resources / `BOARD_INTEGRATION_MAPPING`; if genuine conversion is still required, classify that conversion independently.

### Example D — a reusable block lacks its own required unpowered-input limit

If that limit is intrinsic to safe generic use of the block, the omission belongs to the block contract rather than every board integration.

Classification: `BLOCK_CONTRACT_DEFECT` / engineering review.

### Example E — installed machine connector identity is unknown

No adapter can be justified merely to avoid inspecting the machine.

Classification: `UNRESOLVED`, physical fact `VERIFY_AT_MACHINE`.

## 6. Catalog search comes before new adapter design

When classification returns `ADAPTER_REQUIRED`:

1. derive required A-side and B-side contracts;
2. search the qualified catalog for an adapter satisfying both;
3. verify its actual current files and qualification evidence under the hard student-facing rule;
4. only if no suitable qualified adapter exists, open a new reusable adapter development task.

Do not create near-duplicate adapters because their net names differ.

## 7. Hidden-glue audit

During full-board review, search for circuitry that has no clear reusable owner. Typical warning signs include:

- a level shifter drawn directly on a top integration sheet;
- one-off RC/filter networks inserted between otherwise reusable blocks;
- clamps/TVS parts whose protection envelope is not owned anywhere;
- transistor inversions used to reconcile active-high/active-low assumptions;
- analog divider/op-amp stages described only in board notes;
- protocol translators whose timing/resources are absent from the catalog.

For each, run the five-way classification. Real transformation circuitry must not remain anonymous glue.

## 8. Do not over-block the board

The opposite failure is catalog clutter. Do not create reusable blocks for:

- net renaming;
- pin swaps with no electrical effect;
- connector J-number assignment;
- board location;
- silkscreen wording;
- one machine's harness destination;
- FPGA pin allocation;
- instance count.

Those are board integration or connection-mold data.

Freeze:

**REUSABILITY REQUIRES AN ENGINEERING CONTRACT, NOT MERELY REPEATED SYNTAX.**

## 9. Safety boundary

An ordinary adapter between LinuxCNC/FPGA hardware and an independent safety system does not acquire personnel-safety authority because it is isolated, redundant-looking, fail-low, or packaged as a reusable block.

If an adapter is claimed as part of a safety function, that claim requires a separately engineered and validated safety architecture. Otherwise it remains ordinary control/interface hardware.

## 10. Catalog stress-test result

The current OpenPressBrake methodology is strong on the ownership decision itself. The next machine-readable improvement should make boundary classification a first-class board-composition artifact with:

- `boundary_id`;
- source block/interface ID and revision;
- destination block/interface ID and revision;
- classification;
- compatibility evidence;
- selected adapter ID/revision when applicable;
- board-mapping owner when applicable;
- unresolved facts/blockers;
- safety-authority classification;
- invalidation triggers.

This would let a future configurator fail closed when either neighboring interface changes instead of relying on remembered schematic intent.

## 11. Lab

Given a mixed controller for a mill, lathe, plasma table, router, robot, press brake, or custom machine, classify at least twelve boundaries. Include at least:

- four already-compatible interfaces;
- two true board-only mappings;
- two intentionally incompatible but individually valid interfaces;
- one genuine reusable-block contract defect;
- one unresolved machine fact;
- one ordinary interface adjacent to an independent safety system;
- one tempting but invalid 'adapter' that is only a wire/pin rename.

For every `ADAPTER_REQUIRED` boundary, write the A/B contracts before selecting circuitry. For every `BLOCK_CONTRACT_DEFECT`, explain why the correction is generic rather than board convenience. For every `UNRESOLVED`, name the evidence required to close it.

## 12. Exit criteria

The student passes when they can compose a board without contaminating reusable blocks and can explain, for every boundary:

- what each neighboring block owns;
- whether the contracts match;
- which of the five classifications applies;
- whether real transformation circuitry exists;
- who owns that circuitry;
- which facts remain board-specific;
- what evidence qualifies the result;
- what future change invalidates it.

A working board is not sufficient evidence. The architecture must remain explainable and reusable after the current machine name is removed.

## Checkpoint

Next: **BD22 — boundary-compatibility matrices and machine-readable interface matching**. Stress-test whether block contracts are structured enough for a configurator to reject mismatched voltage, direction, reference, isolation, timing and lifecycle semantics without human tribal knowledge, while still leaving board-specific connector molds and physical machine facts outside reusable electrical blocks.
