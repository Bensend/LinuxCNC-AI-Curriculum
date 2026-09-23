# BD48 — Configuration Selection Closure, Ambiguity Resolution, and Fail-Closed Board Generation

## Purpose

BD47 separated discoverability from consumption authority. BD48 addresses the next failure mode: several artifacts may all be individually eligible, yet the requested board configuration may still be ambiguous, incompatible, or under-specified.

Design flow:

`eligible authorities -> exact configuration intent -> compatibility/constraint solving -> ambiguity detection -> explicit selection/VERIFY_AT_MACHINE -> deterministic board/resource output -> provenance lock -> generation audit`

This lesson links reusable-block engineering to board integration. A reusable block publishes a stable contract and declared resource demand. Board generation must choose a mutually compatible set for one explicit configuration without modifying those contracts, inventing machine facts, or hiding unresolved alternatives.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD47_AUTHORITY_STATE_PROPAGATION_SUPERSESSION_SAFE_DISCOVERY_AND_CONFIGURATION_CONSUMPTION.md` — **VERIFIED_FOR_LESSON** for scoped authority and consumption eligibility.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when this work was selected — **VERIFIED_FOR_LESSON** for the board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, readiness levels, and the distinction between integration readiness and full qualification.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts during composition, adapter classification, and fail-closed `VERIFY_AT_MACHINE` handling.
- OpenPressBrake `hardware/blocks/machine_power/design/REV20_5V_ANALOG_CAPACITANCE_AND_BUCK_STARTUP_BOUNDARY.md` — **VERIFIED_FOR_LESSON** for the bounded board-integration startup accounting and explicit unresolved effective-capacitance/startup gates.
- OpenPressBrake `hardware/blocks/machine_power/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current incomplete machine-power status and remaining ILIM/dVdT, FPGA/core-load, exact-connectivity, PCB, integration, and release gates.

The machine-power material is not presented as schematic-ready, production-proven, safety-rated, or `REV 1 READY`.

## Learning objectives

The student must be able to:

1. translate machine intent into explicit configuration constraints before selecting blocks;
2. distinguish individual artifact eligibility from whole-configuration compatibility;
3. detect multiple valid solutions rather than silently selecting the first one found;
4. distinguish engineering choice from unresolved physical-machine fact;
5. keep reusable blocks immutable while resolving board-specific composition;
6. fail closed on unsatisfied or ambiguous hard constraints;
7. generate deterministic board/resource outputs only after selection closure;
8. lock generated outputs to exact consumed authorities and configuration decisions; and
9. preserve the independent personnel-safety boundary.

## 1. Eligibility is necessary but not sufficient

BD47 established that an artifact must be eligible for the intended scope before consumption. BD48 adds the board-level requirement that the selected set must also be mutually compatible.

Two blocks can each be `CURRENT` and individually suitable while jointly exceeding:

- FPGA pins or bank capabilities;
- LUT/register/BRAM/PLL resources;
- bus addresses, chip selects, timers, DMA channels, or interrupt resources;
- rail current, startup current, thermal, or capacitance budgets;
- connector positions or mechanical edge space;
- isolation/return-domain constraints;
- package sharing or population constraints; or
- board area/routing constraints.

**INDIVIDUALLY ELIGIBLE ≠ JOINTLY FEASIBLE.**

A configurator must solve the composed constraint set rather than treating block selection as independent shopping.

## 2. Start from exact configuration intent

Before solving, state what is being configured. At minimum record:

- target board/revision or design intent;
- required machine functions and channel counts;
- electrical interface classes;
- performance/timing requirements;
- required optional features;
- allowed board variants;
- new-build versus service/historical scope;
- known machine/harness/drive identities;
- explicit unknown physical facts;
- resource ceilings and reserved resources; and
- independent safety-system interfaces without assigning ordinary control safety authority.

Do not let the solver manufacture intent from whichever blocks happen to exist.

**CATALOG CONTENT ≠ MACHINE REQUIREMENT.**

## 3. Hard constraints, preferences, and unknowns are different

Classify every selection input.

### Hard constraint

Violation makes the candidate invalid: voltage/domain incompatibility, insufficient FPGA bank capability, rail overload, incompatible protocol, missing required isolation, impossible connector/contact rating, or an explicitly prohibited return bridge.

### Preference

A ranked choice among otherwise valid solutions: lower cost, fewer packages, preferred connector family, lower board area, more spare FPGA resources, or greater reuse.

### Unknown physical fact

A fact that cannot be legitimately optimized around because it must be established from the real machine or authoritative configuration: installed drive identity, undocumented harness mapping, actual cable construction, legacy connector contact population, or an unverified field supply.

**UNKNOWN FACT ≠ FREE DESIGN VARIABLE.**

Unknown physical facts remain `VERIFY_AT_MACHINE`/blocked unless a bounded design can truthfully support all admissible cases.

## 4. Ambiguity is a first-class result

A solver can produce four useful top-level outcomes:

- `UNIQUE_VALID_SELECTION` — one justified solution remains;
- `MULTIPLE_VALID_SELECTIONS` — more than one solution satisfies all hard constraints;
- `NO_VALID_SELECTION` — constraints cannot be satisfied with current eligible authorities;
- `BLOCKED_UNKNOWN_FACT` — selection depends on evidence that is not established.

Do not collapse the last three into an arbitrary default.

**FIRST VALID MATCH ≠ JUSTIFIED SELECTION.**

If multiple solutions remain, resolve them with an explicit engineering preference/decision and record the rationale. If no solution exists, select different qualified blocks, create/qualify a real adapter where appropriate, revise a genuinely defective generic contract, or revise the board requirement with authority. Do not silently mutate reusable blocks.

## 5. Connection blocks close board-specific choices

Once compatible reusable functions are selected, board-specific connection blocks own composition facts such as:

- physical connector family and pinout;
- exact field signal names;
- power/ground pins and return requirements;
- FPGA/logical instance mapping;
- board-edge/location constraints;
- silkscreen/labels;
- harness or machine destination; and
- board-specific population choices.

They do not own hidden level translation, isolation, filtering, clamping, protocol conversion, or other real circuitry. Such circuitry remains a reusable block/adapter engineering problem.

**CONNECTION BLOCK ≠ PLACE TO HIDE ELECTRICAL TRANSFORMATION.**

## 6. Resource solving must include interactions

The configuration solver must aggregate resources with the same semantics used by the electrical design. Examples:

- primitive GPIO count plus exact bank/voltage/differential requirements;
- shared package packing rather than one-package-per-channel assumptions;
- shared rails counted once with all consumers;
- startup modes rather than only steady-state current;
- direct-node capacitance distinguished from downstream converter loads;
- bus/address collisions;
- mutually exclusive pin functions;
- connector/contact current limits; and
- return/current-path restrictions.

A numerically sufficient total can still be electrically invalid if the topology is wrong.

**RIGHT NUMBER ON WRONG NODE ≠ VALID RESOURCE BUDGET.**

## 7. Worked bounded example: machine-power startup closure

Current OpenPressBrake machine-power evidence provides a useful fail-closed example.

The current Rev20 board-integration contract freezes **15.3 uF nominal direct `5V_ANALOG` capacitance** as a downstream buck-startup load and **4.92 uF nominal direct `24V_LOGIC_PROTECTED` capacitance** as the present simple TPS26633 protected-node inventory. It explicitly prohibits summing those values across the LMR36520 as if all capacitance were directly on the 24-V protected node.

The same artifact explicitly leaves final TPS26633 dVdT unresolved until effective 5-V MLCC capacitance, LMR36520 startup behavior into the real network/load, and final FPGA/core startup demand are established. The machine-power checklist independently keeps TPS26633 ILIM/dVdT, FPGA-core startup/current, remaining low-voltage consumer aggregation, complete exact connectivity, PCB/integration qualification, and human release open.

This is exactly the distinction BD48 requires:

- topology/accounting facts already frozen may be consumed;
- unresolved effective-capacitance and startup facts may not be replaced with convenient nominal values;
- the generator may produce a **partial deterministic resource model** for closed facts;
- it may not produce a falsely final dVdT/component selection while required constraints remain unresolved.

**PARTIAL DETERMINISM ≠ CONFIGURATION CLOSURE.**

A useful generator should report the closed values and the blocking dependency chain rather than fabricate the missing result.

## 8. Deterministic generation requires a selection lock

Once configuration selection is closed, create a machine-readable selection lock that pins at least:

- exact configuration-intent identity/revision;
- each consumed reusable block/adapter authority and revision/digest;
- board-specific connection-block revisions;
- resolved options and explicit rationale;
- `VERIFY_AT_MACHINE` facts and evidence used to close them;
- FPGA/bus/power/connector resource allocations;
- unresolved items, which must be empty for a final generation claim;
- generator/tool/schema version; and
- resulting output digests.

The same selection lock must reproduce the same semantic board/resource result given the same authoritative inputs.

**DETERMINISTIC TOOL ≠ DETERMINISTIC CONFIGURATION IF INPUT SELECTION IS AMBIGUOUS.**

## 9. Provenance lock applies to derived outputs

Generated artifacts should retain dependency edges back to every authority that materially shaped them:

- schematic/netlist;
- BOM;
- resource and power budgets;
- FPGA pin/bank map;
- gateware configuration;
- LinuxCNC/HAL map;
- connection/connector tables; and
- programming/service package.

A later upstream supersession can then mark affected outputs stale through `SHOW WHERE USED` instead of relying on filename matching.

## 10. Generation audit

After generation, independently audit that:

1. every consumed artifact was eligible for the exact scope;
2. every hard constraint was satisfied;
3. every ambiguity was explicitly resolved;
4. no unresolved machine fact was invented;
5. reusable block contracts were not modified by composition;
6. real adapter circuitry was not hidden in connection mappings;
7. resource totals preserve topology/domain semantics;
8. generated outputs match the selection lock;
9. output provenance includes every material authority; and
10. ordinary controller configuration is not represented as personnel-safety validation.

A successful file-generation process is not itself proof of a valid board.

**GENERATION SUCCEEDED ≠ ENGINEERING CLOSED.**

## 11. Adversarial lab

### Case A — two eligible blocks exceed a shared resource

Each selected block is individually current and fits the FPGA in isolation, but together they exceed a bank-specific GPIO constraint.

Expected reasoning: reject the combined candidate. Do not move pins across incompatible banks or edit block contracts merely to make totals fit.

### Case B — multiple valid connector choices

Two connector families satisfy all electrical and mechanical hard constraints, and neither is otherwise mandated.

Expected reasoning: return `MULTIPLE_VALID_SELECTIONS`, apply an explicit documented preference/engineering decision, then lock the choice. Directory order is not engineering rationale.

### Case C — selected drive fact unresolved

Two motor-drive configurations differ in timing/cable requirements, but installed drive/cable identity is unverified.

Expected reasoning: `BLOCKED_UNKNOWN_FACT` / `VERIFY_AT_MACHINE`. Do not infer the physical machine from the preferred reusable block.

### Case D — power arithmetic crosses a converter boundary

A generator adds downstream 5-V capacitance directly to the protected 24-V node because both ultimately load the same source.

Expected reasoning: reject the budget. Preserve the converter/topology boundary and model startup demand through the buck.

### Case E — no direct interface match

Two qualified blocks cannot mate electrically.

Expected reasoning: apply the block/adapter/integration decision test. Search for a qualified adapter; if none exists, open adapter engineering rather than hiding circuitry in a connection block.

### Case F — ordinary safety-status interface closes cleanly

An FPGA input monitoring an independent safety relay has a unique compatible mapping and passes ordinary controller checks.

Expected reasoning: configuration closure proves only the declared monitoring interface. It does not prove PL/SIL/category, stopping performance, final-element behavior, or personnel-safety authority.

## 12. Machine-readable selection record

A future configurator should support a record conceptually like:

```yaml
configuration_selection_id: CFG-<stable-id>
intent_revision: null
scope:
  board_revision: null
  new_build: true
requirements:
  required_functions: []
  hard_constraints: []
  preferences: []
  verify_at_machine: []
selection_state: BLOCKED_UNKNOWN_FACT
consumed_authorities: []
connection_blocks: []
resource_solution:
  fpga: {}
  buses: {}
  power: {}
  connectors: {}
ambiguities: []
blocking_unknowns: []
decisions: []
generation:
  allowed: false
  generator_version: null
  output_digests: []
provenance:
  evidence_refs: []
```

This is schema direction, not a claim that OpenPressBrake currently implements it.

## 13. Catalog stress-test result

BD48 exposes a missing **configuration-selection closure layer** above authority-state filtering. The catalog needs a consumer that can combine exact machine/board intent, eligible block/adapter authorities, board-specific connection blocks, topology-aware resource constraints, explicit preferences, and unresolved physical facts into a deterministic selection state.

The machine-power example also exposes an important requirement for **partial closure**: automation must be able to consume frozen topology/accounting facts while preventing unresolved effective-capacitance/startup facts from being promoted into a final component/programming decision.

Proposed infrastructure remains **ENGINEERING_REVIEW_NEEDED**. No OpenPressBrake engineering file is changed by this lesson because current main is actively advancing Rev-1 integration.

## 14. Compute rule

No simulation, synthesis, place-and-route, timing/resource run, or executable regression is required merely to teach the selection/closure method. When a real configuration constraint genuinely requires executable verification, it must run only on `[self-hosted, openpressbrake]`. If authorized local compute is unavailable, preserve `BLOCKED/NOT_RUN`; never substitute hosted compute.

## 15. Safety boundary

A configuration solver may select ordinary status monitors, watchdogs, output inhibits, and interfaces to STO/enable mechanisms. It must not interpret a uniquely solvable ordinary-controller configuration as independent personnel-safety validation.

**UNIQUE CONFIGURATION ≠ SAFETY-RATED CONFIGURATION.**

## Completion criteria

The student passes BD48 when they can define exact configuration intent, separate hard constraints/preferences/unknowns, solve whole-board compatibility rather than individual eligibility, report ambiguity explicitly, preserve block/adapter/connection boundaries, fail closed on unresolved machine facts, generate only from a locked deterministic selection, and audit derived outputs back to exact consumed authorities.

## Next lesson

BD49 should cover **configuration change control, deterministic regeneration, and semantic diff review**:

`locked configuration -> requested change -> semantic intent diff -> affected authority/resource set -> re-solve -> deterministic regeneration -> semantic output diff -> targeted verification -> promotion/release decision`
