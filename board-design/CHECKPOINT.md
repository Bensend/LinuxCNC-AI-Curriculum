# Board-Design Curriculum Checkpoint

Current durable lesson: **BD72 — Qualification Evidence Packages, Traceability, and Release Promotion**

Curriculum lesson commit: `5988944f079a0c6b4a690f449922c710ea9e1b4b`.

OpenPressBrake engineering source inspected for BD72: `f47055c36683ee0f951d62ed3896331285eb0dee`.

## Verified student-facing sources for BD72

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for formal maturity levels, baseline-versus-Rev-1 separation, evidence truthfulness and maintenance/regression rules.
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for the current ISO1212 evidence inventory and explicit SIMULATION-READY boundary; PCB/layout review, cost/dependencies and human Rev-1 signoff remain open.
- `hardware/blocks/digital_input_24v/manifest.yaml` — VERIFIED_FOR_LESSON for the reusable electrical/resource contract and its declared TBD/open qualification items.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for current board-specific allocation, domain/authority contracts and explicit schematic/PCB release gates; not physical-board qualification evidence.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON for electrical pinout authority and explicit unresolved mechanical/harness facts; mechanical identity/coordinates remain VERIFY_AT_MACHINE/TBD.
- `board-design/BD71_BENCH_BRINGUP_EVIDENCE_FAULT_INJECTION_COMMISSIONING.md` — VERIFIED_FOR_LESSON as the prerequisite commissioning-evidence method.
- `board-design/BD72_QUALIFICATION_EVIDENCE_TRACEABILITY_RELEASE_PROMOTION.md` — VERIFIED_FOR_LESSON after post-commit re-open.

## Closure result

BD72 freezes the rule that **EVIDENCE EXISTS is not the same claim as EVIDENCE SUPPORTS THIS RELEASE**.

Qualification is now claim-scoped. Each release claim must carry owner, subject revision, claimed envelope, required evidence type, actual evidence/revision, unresolved dependencies, regression triggers and release effect. Datasheet, calculation, simulation, structural CI, synthesis/timing, ERC/DRC, bench, machine and human-review evidence remain distinct and non-interchangeable.

The current ISO1212 digital-input block is the bounded worked example. It has strong exact-connectivity, BOM, calculation, bounded simulation, provenance and board-integration evidence, but current governance and its own checklist still classify it SIMULATION-READY. Open PCB/layout, dependency/cost and human-signoff gates prevent promotion to SCHEMATIC-READY or REV 1 READY.

The connector example reinforces the block/board/machine boundary. Electrical pinout intent is frozen while manufacturer/series/keying/footprint/coordinates and several harness facts remain physical gates. ERC or a temporary bench fixture cannot close those production claims.

## Catalog stress-test finding

The catalog needs a common machine-readable qualification manifest joining stable claim IDs to evidence type, subject revision, tested envelope, result, unresolved dependencies, regression triggers, staleness and release effect. Existing block checklists contain valuable evidence inventories but do not yet provide that cross-artifact release traceability mechanically.

A future validator should detect unsupported claims, stale evidence after dependency changes, CI evidence used outside its tested scope, board claims depending on downgraded blocks, unresolved VERIFY_AT_MACHINE release gates and human-review obligations triggered by engineering changes.

OpenPressBrake remained read-only because current main had advanced to active RS-485 field-reference integration work. No simulation, synthesis, place-and-route, timing, regression or other executable verification was required; no hosted compute was used.

Both repositories were re-read on current main after the BD72 lesson commit and before this checkpoint update. Curriculum main contained `5988944f079a0c6b4a690f449922c710ea9e1b4b`; OpenPressBrake main remained `f47055c36683ee0f951d62ed3896331285eb0dee`.

## Next run

Develop **BD73 — Whole-Board Kitchen-Sink Release Review and Evidence Closure**:

`qualified block evidence + connection closure + FPGA/resource plan + power/return closure + authority/freshness + CAD/ERC + commissioning evidence -> cross-domain release audit -> contradiction/staleness search -> unresolved gate register -> release disposition`.

Re-open every student-facing source on current main. Build a whole-board review method that deliberately looks for contradictions between individually plausible artifacts, stale assumptions after later block/resource changes, ownerless interfaces, mismatched power/return/authority claims and evidence that does not follow the current revision. Do not call the current OpenPressBrake board production-proven without the required release evidence.