# BD73 — Whole-Board Kitchen-Sink Release Review and Evidence Closure

Status: durable board-design curriculum lane

## Purpose

A complete controller is not releasable merely because every individual block looks plausible. Whole-board review is the adversarial step where individually reasonable artifacts are forced to agree with one another on the same revision, interfaces, resources, power domains, authority chains, physical facts, and evidence.

Design flow:

`qualified block evidence + connection closure + FPGA/resource plan + power/return closure + authority/freshness + CAD/ERC + commissioning evidence -> cross-domain release audit -> contradiction/staleness search -> unresolved gate register -> release disposition`

Central rule:

**LOCALLY PLAUSIBLE + LOCALLY PLAUSIBLE does not imply GLOBALLY CONSISTENT.**

A second rule follows:

**A release review must search for contradictions, not merely collect green checkmarks.**

## Learning objectives

Students shall be able to:

1. assemble a release candidate from immutable source revisions rather than moving `main`;
2. reconcile reusable-block contracts against board-specific connection, resource, power, and authority contracts;
3. find stale assumptions introduced when one domain advances after another;
4. distinguish a true contradiction from a deliberate reusable-versus-machine-specific overlay;
5. detect ownerless signals, diagnostics, returns, enables, and shared resources;
6. verify that evidence follows the current subject revision and claimed envelope;
7. preserve unresolved physical-machine facts as release gates rather than guessing them;
8. produce a whole-board gate register with owners, evidence needs, dependencies, and release effects; and
9. issue a bounded release disposition without calling an unqualified board production-proven.

## 1. Freeze the candidate before reviewing it

Record exact revisions for:

- machine requirements and connection authority;
- reusable block manifests and status checklists;
- board integration authority;
- FPGA/resource allocation;
- power/return architecture;
- generated schematic/PCB artifacts;
- firmware/runtime/HAL binding;
- commissioning evidence; and
- qualification evidence.

Do not perform a release review against a mixture of yesterday's block contract and today's board allocator. If engineering changes during review, either restart the affected reconciliation on the new candidate or keep reviewing the frozen candidate and mark the new change as superseding evidence.

## 2. Review by semantic joins, not by folders

A kitchen-sink review joins the same semantic item across domains. For every externally meaningful signal or shared resource, trace:

`machine requirement -> connection block -> reusable block interface -> electrical implementation -> board allocation -> FPGA/firmware resource -> HAL/runtime meaning -> commissioning observation -> qualification claim`

For power and authority, also trace:

`source -> protection -> load -> normal return -> fault/transient return -> enable/default authority -> observation/diagnostic`

A missing join is a defect even when every source file is internally valid.

## 3. Required cross-domain audits

### 3.1 Machine-command envelope

Compare generic reusable capability with the machine-specific authorized envelope. A generic block may support more than the installed machine permits. The board contract and runtime must apply the narrower machine overlay without corrupting the reusable block definition.

### 3.2 Diagnostic ownership

Every required diagnostic must have a concrete route or remain an explicit release gate. `must_detect` is not satisfied by a prose name. Reconcile source pin/electrical ownership, FPGA/shared-bus resource, firmware interpretation, HAL exposure, power-validity dependency, and fault semantics.

### 3.3 FPGA/resource closure

Check unique physical GPIO, shared buses, chip selects, fault inputs, bank voltage, clocks, PLLs, BRAM/LUT/register estimates where relevant, package pins, and reserved headroom. Shared resources count once physically but must list every consumer. An unresolved diagnostic cannot be silently counted as zero GPIO.

### 3.4 Power and return closure

Trace every source and return through normal, startup, transient, and fault states. Typed returns remain distinct until an explicit bonding authority proves otherwise. Confirm that current resource revisions have not added loads omitted from an older power budget.

### 3.5 Output authority and freshness

For every energy-affecting ordinary-control output, reconcile command, freshness, watchdog, FPGA configuration, power-good, hardware enable, electrical default, and recovery behavior. Independent personnel-safety authority remains separate.

### 3.6 Physical connector and harness closure

Electrical pinout authority does not prove manufacturer, series, keying, footprint, pad numbering, mounting coordinates, mating condition, wire size, bend clearance, or harness existence. Any `VERIFY_AT_MACHINE` fact required for the release remains open.

### 3.7 CAD and generated-artifact closure

ERC/DRC and generator success are evidence only for encoded rules. Compare generated artifacts semantically against the current authority: connector identity, net ownership, return domain, pin/pad mapping, resource binding, enable path, markings, and provenance.

### 3.8 Evidence freshness

For each release claim, ask whether its evidence was produced against the current subject revision and whether any dependency changed afterward. Passing old evidence becomes stale when its assumptions or implementation changed.

## 4. Contradiction taxonomy

Classify findings before fixing them:

- `DIRECT_CONTRADICTION` — two current authorities make incompatible claims about the same scope.
- `STALE_DOWNSTREAM_ASSUMPTION` — a later upstream decision has not propagated into a dependent artifact.
- `UNRESOLVED_BINDING` — the required semantic function exists but its concrete resource/connectivity is not closed.
- `OWNERLESS_INTERFACE` — no artifact owns a required signal, return, enable, diagnostic, or physical fact.
- `SCOPE_OVERLAY_NOT_PROPAGATED` — generic capability is valid, but a narrower machine overlay is missing downstream.
- `EVIDENCE_STALE` — evidence predates a material dependency change.
- `PHYSICAL_GATE_OPEN` — electrical intent exists but machine/mechanical evidence is absent.
- `QUALIFICATION_GAP` — design is defined but required calculation/simulation/bench/machine/human evidence is absent.

Do not “resolve” a contradiction by deleting the stricter requirement unless source authority proves that requirement was wrong.

## 5. Current OpenPressBrake worked-example audit

OpenPressBrake main inspected for this lesson: `d7b621e34ceec693a72fa75e2096af2c1bf8ef62`.

The following student-facing sources were opened and inspected in their current form during this run:

- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for maturity, truthfulness, baseline/qualification separation, and same-change maintenance obligations.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for current board-level machine allocation, power domains, output authority, safe states, and explicit schematic/PCB release gates. It is not evidence that those gates are closed.
- `hardware/REV1_CONNECTOR_MAP.yaml` — **VERIFIED_FOR_LESSON** for electrical connector/pin authority and explicit unresolved mechanical/harness gates.
- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — **VERIFIED_FOR_LESSON** for the current static GPIO/shared-resource budget and its explicit open local synthesis/place-route/timing gates.
- `hardware/blocks/analog_output/manifest.yaml` — **VERIFIED_FOR_LESSON** for reusable analog-output capability, required diagnostics, default/rearm behavior, electrical limits, and open qualification items.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — **VERIFIED_FOR_LESSON** for the current machine-specific analog-output overlay and its fail-closed unresolved diagnostic binding.
- `board-design/BD72_QUALIFICATION_EVIDENCE_TRACEABILITY_RELEASE_PROMOTION.md` — **VERIFIED_FOR_LESSON** as the prerequisite evidence/traceability method.

These sources are suitable for teaching a release audit precisely because they expose current open gates. They do not support calling the present OpenPressBrake board production-proven.

## 6. Adversarial finding A — generic bipolar capability versus machine command authority

The reusable analog-output manifest intentionally supports a `[-10 V, +10 V]` output range. That is a valid reusable capability.

The current machine-specific analog-output resource contract is narrower: for the retained Commander SK X-axis drive it records the manufacturer-standard T4 profile as `0..10 V`, keeps direction ownership on separate B5/B6 digital inputs, and states that negative command is **not authorized** until installed configuration evidence proves a different mode.

The current board integration authority still describes `x_axis_analog.range_v` as `[-10, 10]`.

This is not evidence that the reusable block should be narrowed. It is a **SCOPE_OVERLAY_NOT_PROPAGATED** finding at the whole-board contract: board/runtime command authority must distinguish reusable electrical capability from the presently authorized first-machine command envelope.

Release effect: the installed-machine command envelope cannot be considered closed until the board/runtime authority consumes the narrower overlay or machine evidence explicitly authorizes bipolar command.

## 7. Adversarial finding B — analog diagnostic resource binding

The reusable analog-output manifest requires logical outputs `DAC_FAULT` and `TPS26611_SGOOD` and lists them among faults that must be detected.

The newest machine-specific resource contract correctly refuses to guess how those diagnostics reach controller logic. It declares the dedicated FPGA input count unresolved and prohibits silently dropping the diagnostics or inventing an unverified status path.

Meanwhile the current FPGA resource map allocates the shared ADC/DAC control group including `DAC_FAULT`, but it does not establish the complete current binding for both required analog-output diagnostics. Therefore the whole-board resource review must not treat the analog-output diagnostic cost as fully closed.

Classification: **UNRESOLVED_BINDING**.

Release effect: final FPGA pin/shared-bus allocation and any diagnostic qualification claim depending on both statuses remain blocked until electrical ownership and controller binding are proven.

## 8. Adversarial finding C — static FPGA fit is not implementation fit

The current FPGA resource map reports 123 unique runtime GPIO for the full reusable architecture out of 191 conservatively available runtime I/O, leaving 68 GPIO / 35.60 percent headroom. It also explicitly marks actual LiteX-CNC logic fit and routed timing as open pending a local self-hosted rebuild.

Therefore `logical_gpio_fit_status: PASS` is useful static evidence but cannot be promoted into synthesis, place-and-route, or timing evidence.

Classification: **QUALIFICATION_GAP**, not a contradiction.

Release effect: any release scope requiring real FPGA implementation fit remains open until the justified local runner verification is performed on `[self-hosted, openpressbrake]`.

## 9. Adversarial finding D — physical connector closure remains open

The connector map freezes electrical intent while retaining `VERIFY_AT_MACHINE` for legacy mechanical identity and several harness facts. The board integration authority independently lists exact legacy connector parts/coordinates and PVR6 X2 return-harness confirmation among pre-PCB release gates.

Classification: **PHYSICAL_GATE_OPEN**.

A temporary fixture, ERC-clean schematic, or successful logical I/O test cannot close these physical production claims.

## 10. Whole-board unresolved gate register

For every release candidate maintain a register with at least:

`gate_id | domain | finding_class | exact_claim | owner | source_revision | dependency_ids | evidence_needed | current_state | release_effect | closure_revision`

Use current states:

- `OPEN_BLOCKING`
- `OPEN_NONBLOCKING_FOR_DECLARED_SCOPE`
- `CLOSED_WITH_EVIDENCE`
- `SUPERSEDED`
- `WAIVED_WITH_EXPLICIT_SCOPE_AND_RATIONALE`

A waiver cannot manufacture missing technical evidence. It can only narrow the release scope when doing so is technically defensible.

## 11. Release disposition

The review ends with one bounded disposition:

- `REJECTED_CONTRADICTORY_BASELINE`
- `ENGINEERING_INTEGRATION_ONLY`
- `SCHEMATIC_RELEASE_ELIGIBLE`
- `PCB_RELEASE_ELIGIBLE`
- `BENCH_RELEASE_ELIGIBLE`
- `MACHINE_COMMISSIONING_ELIGIBLE`
- `QUALIFIED_FOR_EXPLICIT_SCOPE`

Do not use `production proven` as a synonym for any intermediate state.

For the current OpenPressBrake evidence inspected here, the appropriate teaching conclusion is **not production-proven**. The board has useful integration authority and strong fail-closed governance, but physical connector/harness gates, real FPGA implementation evidence, analog diagnostic binding, machine-specific X-axis command-envelope reconciliation, and additional qualification work remain open.

## 12. Catalog stress-test result

Whole-board teaching exposes a catalog infrastructure gap: there is no single machine-readable release graph that joins stable semantic IDs across block contracts, board connections, resource allocations, power/return ownership, authority/freshness, generated CAD, firmware/HAL binding, commissioning evidence, qualification claims, and staleness.

A future release-graph validator should mechanically answer:

- Does every required semantic output have exactly one concrete owner and route?
- Did a newer machine overlay narrow a generic capability without propagating downstream?
- Is a resource counted as zero because its binding is actually unresolved?
- Did a changed block/resource contract stale a board-level evidence item?
- Does every machine-facing pin have one block interface and one typed return/power authority?
- Are shared resources counted once physically while retaining all consumers?
- Does a release claim depend on an open `VERIFY_AT_MACHINE` fact?
- Are safety-owned paths still independent of ordinary LinuxCNC/FPGA control?

This is a catalog/tooling defect, not permission to add unwritten integration knowledge.

OpenPressBrake remains read-only in this lesson because current main is actively advancing analog-output resource closure. The curriculum consumes the newest state and records the defects without racing that engineering work.

## 13. Transfer beyond OpenPressBrake

The same review applies to a mill spindle board, lathe I/O board, plasma controller, router, robot, feeder, or custom automation controller. Typical cross-domain contradictions include a generic ±10-V spindle output applied to a 0–10-V-only drive, an encoder block whose field supply was never budgeted, a robot brake output whose watchdog status is only diagnostic, a plasma torch-enable whose return domain was collapsed into logic ground, or a lathe index input whose connector shield strategy never propagated into PCB placement.

The catalog is successful only when these contradictions can be discovered from explicit contracts rather than tribal knowledge.

## 14. Lab deliverable

Given a frozen board release candidate, produce:

1. a source/revision lock table;
2. a minimum 20-row semantic join matrix spanning connections, blocks, power, FPGA, runtime, commissioning, and qualification;
3. at least one deliberate search for each contradiction class in Section 4;
4. a whole-board unresolved gate register;
5. at least five stale-evidence/dependency checks;
6. a block-versus-board-versus-machine scope table;
7. a release disposition naming the exact eligible scope and blocked scopes; and
8. one catalog/tooling defect exposed by the audit.

A passing submission must include at least one negative finding or a defensible explanation of how each contradiction class was searched and ruled out. A review that only restates green statuses is incomplete.
