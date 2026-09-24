# Board-Design Curriculum Checkpoint

Current durable lesson: **BD76 — Catalog Consumer Compatibility, Semantic Versioning, Deprecation, and Multi-Machine Rollout**

Curriculum lesson commit: `71334604f28e1fad2170749a6ed2d2c5f7512781`.

OpenPressBrake engineering source inspected for BD76: `15d52092689b6cb8f8aa05591c0c3005581bada7`.

## Verified student-facing sources for BD76

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for primitive/shared-resource rules, material-change maintenance, evidence truthfulness, and baseline-versus-qualification separation.
- `hardware/blocks/digital_output_24v/manifest.yaml` — VERIFIED_FOR_LESSON for the current one-channel reusable primitive, semantic interfaces, logic/process domain separation, shared-resource scaling, FPGA resource declaration, non-safety role, and unresolved machine/board envelope facts.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current isolated Rev1 topology status, separate 27.20-mA LOGIC_3V3 and 18.88-mA SWITCHED_IO_5V static handoffs, open CAD/connector/thermal/qualification work, and safety boundary.
- `board-design/BD75_CONTROLLED_ENGINEERING_CHANGE_BASELINE_SUPERSESSION_AUDIT_HISTORY.md` — VERIFIED_FOR_LESSON as prerequisite controlled-change and immutable-baseline method.
- `board-design/BD76_CATALOG_CONSUMER_COMPATIBILITY_SEMVER_MULTI_MACHINE_ROLLOUT.md` — VERIFIED_FOR_LESSON after creation and current-main re-read.

## Closure result

BD76 freezes three rules: **IMPLEMENTATION COMPATIBILITY IS NOT CONTRACT COMPATIBILITY**, **A REUSABLE BLOCK MAY EVOLVE; A BOARD-SPECIFIC CONNECTION MUST ADAPT EXPLICITLY**, and **DEPRECATION IS A CONTROLLED MIGRATION STATE, NOT SILENT DELETION**.

The lesson defines compatibility classes, semantic contract versioning, reverse Where Used review, per-consumer compatibility matrices, evidence carry-forward/staleness decisions, deprecation/supersession records, and staged multi-machine rollout.

The current digital-output block supplies the adversarial example. Signal names alone cannot establish compatibility: a future isolator change must also preserve or deliberately migrate rail demand, return-domain isolation, deterministic OFF behavior, diagnostic semantics, unpowered behavior, FPGA/shared-resource demand, and package/resource scaling. Current eight-output Rev1 static loads remain 27.20 mA maximum on LOGIC_3V3 and separately 18.88 mA maximum on SWITCHED_IO_5V; these domains must not be collapsed.

## Catalog stress-test finding

The catalog has useful manifests and status governance but still lacks a machine-readable contract-version/consumer registry joined to the dependency/change graph. It should record contract semantic versions, changed semantic IDs, compatibility ranges/classes, consumer/connection/baseline IDs, migration state, deprecation/supersession, evidence, unresolved physical facts, and safety boundary. This is required for durable reverse Where Used and controlled multi-board rollout rather than relying on tribal knowledge.

OpenPressBrake remained read-only because current main is actively advancing block engineering. No simulation, synthesis, place-and-route, timing, regression, or other executable verification was required; no hosted compute was used.

Immediately before checkpointing, current mains were re-read: curriculum `71334604f28e1fad2170749a6ed2d2c5f7512781`; OpenPressBrake `15d52092689b6cb8f8aa05591c0c3005581bada7`.

## Next run

Develop **BD77 — Catalog Selection Decision Records and Design-Space Trade Studies**:

`machine requirement + qualified catalog candidates -> mandatory-contract filter -> evidence/maturity filter -> resource/power/connector trade study -> board-specific adaptation cost -> risk/unknown comparison -> selection decision record -> connection/resource plan`

Re-open every student-facing source on current main. Teach selection from requirements rather than familiarity or first-machine precedent. Compare multiple reusable candidates without inventing machine values, preserve reusable-block versus connection-block boundaries, distinguish qualification evidence from cost/convenience, and record rejected alternatives and unresolved VERIFY_AT_MACHINE/TBD gates. Preserve the independent personnel-safety boundary and keep OpenPressBrake read-only if active engineering overlaps.