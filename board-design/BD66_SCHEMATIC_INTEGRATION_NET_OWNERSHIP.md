# BD66 — Schematic Integration Reconciliation and Cross-Block Net Ownership

Status: student-ready method lesson with audited bounded OpenPressBrake encoder example  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `fc47ed9b86db9998cad7549fce82a192809e4068`

## Purpose

BD65 established that generated CAD and clean ERC are not engineering authority. BD66 addresses the next board-integration failure: individually reasonable blocks can form an invalid complete schematic when ownership, direction, return, power, protection, or shared-resource assumptions collide.

The flow is:

`captured blocks + connection definitions + shared resources -> complete schematic net graph -> owner/driver/load/return reconciliation -> power-domain and authority checks -> ERC/structural evidence -> integration-defect loop -> accepted schematic baseline`

Central rule: **BLOCK-CORRECT + BLOCK-CORRECT does not imply BOARD-CORRECT.**

## Learning objectives

The student can:

1. build a semantic net graph from block contracts, connection definitions and shared resources;
2. assign one engineering owner to every externally meaningful net while distinguishing drivers, loads and infrastructure owners;
3. trace signal, power, return, shield/chassis and protection-current paths end to end;
4. detect direct field-to-FPGA shortcuts, hidden shared resources and domain collapse;
5. distinguish ERC evidence from cross-block semantic reconciliation;
6. turn integration ambiguity into a catalog defect rather than undocumented board glue;
7. preserve the boundary between ordinary control and independent personnel safety.

## Student-facing source audit

Every file named below was opened in its CURRENT form during this run.

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON | status truthfulness, primitive/shared-resource ownership, integration versus qualification |
| `hardware/blocks/differential_encoder/integration/REV1_RESOURCE_CONTRACT.yaml` | VERIFIED_FOR_LESSON | current encoder primitive resources, invariants, board-owned resources and unresolved machine facts |
| `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` | ENGINEERING_REVIEW_NEEDED as complete current evidence index; VERIFIED_FOR_LESSON for its explicit open release gates and bounded maturity claims | current block maturity and unresolved termination/field-power/PCB/release work |
| `board-design/BD65_KICAD_GENERATION_PROVENANCE_ERC_BOUNDARIES.md` | VERIFIED_FOR_LESSON | prerequisite generated-capture/ERC evidence boundary |

The encoder status checklist does not yet list the newly current `integration/REV1_RESOURCE_CONTRACT.yaml` in its evidence inventory. Repository maintenance governance says material integration evidence should update the checklist in the same change. Treat that omission as a catalog-maintenance defect; do not infer that the new contract promotes block status.

## 1. Convert the schematic into a semantic net graph

For integration review, a net is more than a KiCad label. Normalize each meaningful connection as an edge with at least:

- stable semantic net ID;
- source/driver endpoint;
- destination/load endpoint(s);
- functional owner;
- electrical class and direction;
- voltage/current domain;
- signal-return or field-return domain;
- chassis/PE/shield relationship when applicable;
- protection owner and transient-current return;
- startup/default/de-energized state;
- shared-resource dependency;
- FPGA/logical endpoint where applicable;
- authority/evidence revision.

A visually connected schematic is not accepted until the graph is semantically closed.

## 2. Owner, driver and load are different roles

Do not use `owner` as a synonym for `driver`.

- **Functional owner** defines what the net means and its contract.
- **Driver** electrically drives the net in a given operating state.
- **Load** consumes or senses it.
- **Infrastructure owner** may supply power, return, reference, protection or shared conversion without owning the machine function.

A net with two incompatible functional owners is a design conflict. A net with no owner is undocumented glue. Multiple electrical drivers require an explicitly supported topology; they are not made safe by a shared net name.

## 3. Reconcile complete paths, not labels

For every field signal, trace:

`machine endpoint -> connector/contact -> protection -> reusable interface block -> logic-domain endpoint -> FPGA resource -> firmware/LinuxCNC semantic endpoint`

For every powered function, separately trace:

`source -> branch protection -> distribution -> load -> intended return -> source`

For transient protection, trace the transient current path separately from normal signal return. Do not silently collapse `GND`, field return and `CHASSIS_PE` because ERC accepts a common symbol.

## 4. Audited OpenPressBrake encoder example

The current differential-encoder resource contract defines one primitive as one AM26LV32EIPWR package receiving A/Abar, B/Bbar and Z/Zbar and producing three ordinary 3V3 FPGA inputs. It explicitly forbids raw field differential pairs from connecting directly to the FPGA. It allocates up to 17 mA of `LOGIC_3V3` source capacity per instance, but does **not** own encoder field power. Connector-edge PESD2CANFD24V-T transient current returns to `CHASSIS_PE`; the primitive must not create a GND-to-CHASSIS_PE bond.

Therefore an integrated schematic is wrong if it:

- bypasses the receiver and lands A/Abar directly on FPGA pins;
- counts encoder field-supply current inside the receiver's 17 mA logic allocation;
- returns connector-edge transient current through FPGA logic ground;
- assumes 120-ohm termination populated without verified cable topology;
- exposes the unused fourth receiver channel as unrelated machine I/O;
- invents encoder field voltage/current or machine harness facts.

The same contract leaves FPGA ball allocation, LiteX-CNC instance allocation, physical connector mapping, field-power implementation, GND/CHASSIS_PE bonding policy and termination population at board-integration scope. Those are not omissions to fill by intuition; they are explicit integration obligations.

## 5. Shared-resource reconciliation

For each shared resource, prove all consumers are represented and compatible. At minimum reconcile:

- source capacity versus allocated maximum demand;
- voltage/tolerance compatibility;
- startup and default behavior;
- enable/disable authority;
- fault propagation and containment;
- bus/address/chip-select ownership;
- FPGA pin/bank and logical-instance allocation;
- reference/ground domain;
- decoupling and return-path assumptions;
- simultaneity assumptions.

If a block requires a shared resource that exists only as tribal knowledge, that is a catalog defect. Add the dependency to the block contract rather than hiding it in the board schematic.

## 6. Power and return closure

A complete-board review must answer, for every load: what sources it, what protects it, what maximum allocation is consumed, where normal current returns, where fault/transient current returns, and what happens when its source is absent or starting.

Reject arithmetic that adds currents from different rails without conversion efficiency and source relationships. Reject a rail budget that uses typical current where the contract requires a capacity allocation. Reject an apparently complete power tree whose field load current is still `VERIFY_AT_MACHINE`.

## 7. Output authority and default state

For each actuator-capable net, identify every entity capable of causing energization and the de-energized/startup/watchdog state. Ordinary FPGA/LinuxCNC watchdogs and output inhibits are useful control protections, but they do not become independent personnel-safety authority.

If independent safety hardware controls STO, contactors, dump valves or other safety final elements, the ordinary controller may monitor or interface with that boundary only as supported by the safety architecture. Never merge the safety authority into ordinary board logic to simplify the schematic.

## 8. ERC and structural evidence

ERC can detect electrical-capture classes such as conflicting pin types, missing connections and power-driver problems when the symbols/rules encode them. Cross-block reconciliation must additionally test semantic facts ERC generally cannot know:

- field signal passed through the required interface block;
- correct functional owner and direction;
- correct typed return/chassis domain;
- shared-resource consumer counted exactly once;
- no hidden source or duplicate driver;
- FPGA resource matches the board allocation authority;
- startup/default state remains compatible across blocks;
- unresolved machine facts remain unresolved;
- safety-credit boundary is unchanged.

`ERC PASS` and `SEMANTIC RECONCILIATION PASS` are separate evidence records.

## 9. Integration-defect loop

When reconciliation fails, classify the defect before editing circuitry:

1. **capture defect** — schematic does not implement an already-clear contract;
2. **connection-definition defect** — board-specific endpoint/pin/harness ownership is incomplete;
3. **block-contract defect** — reusable block depends on unwritten assumptions;
4. **shared-resource defect** — resource ownership/capacity/enable/fault behavior is incomplete;
5. **machine-fact blocker** — physical fact must be measured and remains `VERIFY_AT_MACHINE`;
6. **architecture conflict** — two valid contracts cannot coexist as allocated.

Fix the lowest authoritative layer that is actually wrong. Do not mutate a reusable block merely to hide a board-specific mapping problem.

## 10. Schematic-baseline acceptance gate

A schematic baseline may advance only when:

- all intended block instances and connection instances are enumerated;
- every meaningful net has reconciled owner/driver/load semantics;
- power and return paths close without hidden domains;
- shared-resource allocations reconcile to current authority;
- FPGA/logical bindings are current and collision-free;
- startup/default/watchdog authority is explicit;
- unresolved physical facts are either closed or explicitly prevent the affected release claim;
- required ERC and structural checks are tied to the exact schematic revision;
- cross-block semantic reconciliation passes;
- waivers have owner, rationale and bounded claim;
- consumed authority revisions are locked and rechecked against current main before promotion.

This gate means **accepted schematic baseline**, not production-qualified board.

## Negative cases

Reject these arguments:

- `Both blocks are verified, so their connection must be valid.`
- `The net names match, so ownership matches.`
- `ERC passed, so the return path is correct.`
- `The FPGA has spare pins, so this signal can use one.`
- `The 3V3 regulator has enough typical current.`
- `The protection diode is present, so surge current has a safe return.`
- `The encoder connector has +5 V, so the board must provide it.`
- `Watchdog disables outputs, so the FPGA is the safety authority.`

## Catalog stress-test result

The current encoder resource contract is a strong example of reusable-block ownership because it explicitly separates primitive resources from board-owned connector, FPGA, field-power, bonding and termination decisions. The audit also exposed a maintenance defect: the authoritative encoder status checklist has not yet indexed the newly published resource contract. That checklist is therefore **ENGINEERING_REVIEW_NEEDED** as a complete current evidence inventory even though its bounded maturity/open-gate statements remain useful.

A future machine-readable whole-board net graph should support reverse lookup from each semantic net to block contract, connection definition, shared resource, FPGA binding and evidence lock. That would allow automated detection of ownerless nets, duplicate drivers, hidden shared-resource consumers, domain collapse and stale authority.

No simulation, synthesis, place-and-route or timing run is required to establish this method. If later executable checks are needed, use only `[self-hosted, openpressbrake]`.

## Transfer exercise

Apply the method to a mill spindle encoder, lathe spindle encoder, plasma torch-height feedback, router axis encoder, robot joint encoder or custom automation sensor. Identify reusable interface ownership, board-specific connector ownership, shared power, FPGA/logical resources, normal and transient return paths, unresolved machine facts and the exact semantic checks required beyond ERC.

## Checkpoint

BD66 is complete. Next develop **BD67 — Whole-Board Power/Return Graph and Fault-Containment Reconciliation**:

`accepted semantic net graph -> rail/source tree -> load allocations -> normal return graph -> transient/fault return graph -> enable/startup dependencies -> fault-containment boundaries -> board power acceptance`.

Re-open every student-facing source on current main. Do not treat the current OpenPressBrake board as production-proven.