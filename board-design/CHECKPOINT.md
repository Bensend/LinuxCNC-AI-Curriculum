# Board-Design Curriculum Checkpoint

Current durable lesson: **BD66 — Schematic Integration Reconciliation and Cross-Block Net Ownership**

Curriculum lesson commit: `dd626c13b8aa0d7c28421bc60fdbee1bd6b4a10b`.

OpenPressBrake engineering source inspected for BD66: `fc47ed9b86db9998cad7549fce82a192809e4068`.

## Verified student-facing sources for BD66

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for status truthfulness, primitive/shared-resource ownership and integration-versus-qualification boundaries.
- `hardware/blocks/differential_encoder/integration/REV1_RESOURCE_CONTRACT.yaml` — VERIFIED_FOR_LESSON for current encoder resources, board-owned obligations, integration invariants and unresolved machine facts.
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — ENGINEERING_REVIEW_NEEDED as a complete current evidence inventory because it does not yet list the new resource contract; VERIFIED_FOR_LESSON only for bounded maturity/open-gate statements.
- `board-design/BD65_KICAD_GENERATION_PROVENANCE_ERC_BOUNDARIES.md` — VERIFIED_FOR_LESSON as the prerequisite capture/ERC evidence-boundary method.

## Closure result

BD66 freezes the rule `BLOCK-CORRECT + BLOCK-CORRECT != BOARD-CORRECT`. Complete-board schematic review requires a semantic net graph that reconciles functional owner, electrical driver/load, power and typed return domains, protection-current return, shared-resource dependencies, startup/default state and FPGA/logical endpoints. ERC and semantic reconciliation are separate evidence records.

The current differential-encoder contract provides a bounded worked example: raw A/Abar, B/Bbar and Z/Zbar field pairs must pass through the AM26LV32E primitive; connector-edge protection returns to CHASSIS_PE; receiver LOGIC_3V3 capacity allocation is separate from encoder field power; termination population, field power, connector mapping, FPGA allocation and board-level bonding remain integration responsibilities.

## Catalog stress-test finding

The newly published encoder `integration/REV1_RESOURCE_CONTRACT.yaml` is not yet indexed by the authoritative encoder `STATUS_CHECKLIST.md`, despite the maintenance rule requiring material integration evidence to update that checklist in the same change. Treat the checklist as ENGINEERING_REVIEW_NEEDED as a complete evidence index. The curriculum does not infer a status promotion from the new contract.

OpenPressBrake remained read-only because its latest main commit is the resource-contract change being audited and the active engineering lane owns that area. No simulation, synthesis, timing, place-and-route or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD67 — Whole-Board Power/Return Graph and Fault-Containment Reconciliation**:

`accepted semantic net graph -> rail/source tree -> load allocations -> normal return graph -> transient/fault return graph -> enable/startup dependencies -> fault-containment boundaries -> board power acceptance`.

Re-open every student-facing source on current main. Use current OpenPressBrake evidence only within its actual maturity, preserve VERIFY_AT_MACHINE facts, and do not claim the current board is production-proven.