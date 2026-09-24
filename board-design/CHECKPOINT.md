# Board-Design Curriculum Checkpoint

Current durable lesson: **BD75 — Controlled Engineering Change, Review Ownership, Baseline Supersession, and Auditable Release History**

Curriculum lesson commit: `07df5ec7d56027890745fe53fa417ccd25d5fab8`.

OpenPressBrake engineering source inspected for BD75: `c668851b8db322682d08eedce6436eff5b1f4cbe`.

## Verified student-facing sources for BD75

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for material-change maintenance, evidence truthfulness, baseline-versus-qualification separation, and CI evidence limits.
- `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current maturity, first-machine command-profile correction, open configuration/qualification gates, and safety boundary.
- `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml` — VERIFIED_FOR_LESSON for current first-machine 0..10-V T4 authority, CONFIGURATION_PENDING state, separate B5/B6 direction ownership, and retained Pilz B4 authority.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — VERIFIED_FOR_LESSON for current resource ownership, unresolved DAC_FAULT/TPS26611_SGOOD binding, and explicit VERIFY_AT_MACHINE gates.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for current board-level authority and the still-stale `x_axis_analog.range_v: [-10, 10]` downstream field.
- `board-design/BD73_WHOLE_BOARD_KITCHEN_SINK_RELEASE_REVIEW.md` — VERIFIED_FOR_LESSON as prerequisite whole-board contradiction/gate-register method.
- `board-design/BD74_RELEASE_GRAPH_STALENESS_CHANGE_CONTROL_REGRESSION.md` — VERIFIED_FOR_LESSON as prerequisite dependency/staleness/regression method.
- `board-design/BD75_CONTROLLED_ENGINEERING_CHANGE_BASELINE_SUPERSESSION_AUDIT_HISTORY.md` — VERIFIED_FOR_LESSON after creation and current-main re-read.

## Closure result

BD75 freezes three rules: **APPROVAL IS NOT TECHNICAL EVIDENCE**, **A NEW BASELINE SUPERSEDES AN OLD BASELINE; IT DOES NOT REWRITE HISTORY**, and **ROLLBACK IS A NEW CONTROLLED CHANGE, NOT TIME TRAVEL**.

The lesson adds immutable baseline records, stable change IDs, role-specific ownership, proposal/implementation separation, technical-acceptance gates, evidence attachment, supersession, and rollback semantics on top of the BD74 release graph.

Reusable-block changes and board-specific connection/overlay changes now have explicitly different blast-radius rules. Reusable electrical/interface changes require reverse Where Used review across consumers; machine-specific overlays remain outside the reusable primitive and propagate only to the boards/runtime/commissioning paths that consume them.

The current Commander SK 0..10-V correction remains the bounded board-overlay example: the reusable bipolar primitive remains unchanged, the installed configuration evidence remains open, and current board integration still carries the stale [-10,10] field. The unresolved DAC_FAULT/TPS26611_SGOOD binding remains the resource-change example and cannot be counted as zero.

## Catalog stress-test finding

The catalog needs more than a dependency graph: it needs machine-readable immutable baseline/change records with stable semantic IDs, role-specific owners, proposal and implementation revisions, affected claims, stale evidence, regression plans, unresolved physical facts, technical acceptance, release disposition, supersession, rollback links, and reverse Where Used lookup.

Approval must never substitute for calculation, simulation, synthesis/timing, ERC/DRC, bench, machine, or physical-fit evidence. TBD/VERIFY_AT_MACHINE facts require owners and remain release gates until evidence closes them.

OpenPressBrake remained read-only because current main is actively advancing block power/resource engineering. No simulation, synthesis, place-and-route, timing, regression, or other executable verification was required; no hosted compute was used.

Before the lesson commit, current mains were re-read: curriculum `7107cca17aee72aaa652d1ae33d8c28bfd12a32c`; OpenPressBrake `c668851b8db322682d08eedce6436eff5b1f4cbe`.

## Next run

Develop **BD76 — Catalog Consumer Compatibility, Semantic Versioning, Deprecation, and Multi-Machine Rollout**:

`qualified reusable block + consumer Where Used graph -> compatibility classification -> semantic contract version -> migration/deprecation window -> per-board adaptation -> targeted regression -> staged rollout -> consumer baseline updates`

Re-open every student-facing source on current main. Teach how one reusable block evolves without silently breaking mills, lathes, plasma tables, routers, robots, press brakes, or custom automation consumers. Separate electrical/function contract compatibility from implementation-only changes, board-specific connection adaptation, and machine-specific evidence. Include deprecation/supersession rules, compatibility matrices, migration evidence, and preservation of independent safety authority. Keep OpenPressBrake read-only if active engineering overlaps.