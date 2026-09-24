# Board-Design Curriculum Checkpoint

Current durable lesson: **BD74 — Release-Graph Dependency/Staleness Propagation and Change-Control Regression Planning**

Curriculum lesson commit: `3e7d4bd429941e834f57f84cd7611b2dffafac1e`.

OpenPressBrake engineering source inspected for BD74: `86915569066300908b0cfdc6e67739d0f8388fb9`.

## Verified student-facing sources for BD74

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for material-change maintenance/regression obligations and qualification truthfulness.
- `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current maturity, machine-profile correction, open qualification gates, and readiness limits.
- `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml` — VERIFIED_FOR_LESSON for the first-machine 0..10-V T4 overlay, separate B5/B6 direction ownership, independent B4 safety ownership, and CONFIGURATION_PENDING state.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — VERIFIED_FOR_LESSON for current resource ownership and fail-closed unresolved DAC_FAULT/TPS26611_SGOOD binding.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for current board integration authority and the still-stale `x_axis_analog.range_v: [-10, 10]` downstream field.
- `board-design/BD73_WHOLE_BOARD_KITCHEN_SINK_RELEASE_REVIEW.md` — VERIFIED_FOR_LESSON as prerequisite contradiction/gate-register method.
- `board-design/BD74_RELEASE_GRAPH_STALENESS_CHANGE_CONTROL_REGRESSION.md` — VERIFIED_FOR_LESSON after creation and current-main re-read.

## Closure result

BD74 freezes two rules: **A PASS BELONGS TO A CLAIM, SUBJECT REVISION, ENVELOPE, AND DEPENDENCY SET — NOT TO A FILENAME**, and **CHANGE PROPAGATION MUST BE TRANSITIVE, BUT REGRESSION MUST BE JUSTIFIED**.

The lesson defines a typed release graph spanning requirements, reusable blocks, board-specific connections/overlays, FPGA/shared resources, power, CAD, firmware/HAL, physical-machine facts, tests, evidence, claims, and safety-authority boundaries. Material changes propagate staleness through explicit semantic dependencies. Unrelated evidence may remain current only when the isolation boundary is reviewed and recorded.

The current analog-output command-profile correction remains the primary adversarial example. The reusable primitive remains validly bipolar, while current first-machine authority restricts Commander SK T4 to 0..10 V until installed configuration evidence authorizes otherwise. The downstream board integration authority still carries `[-10,10]`. Therefore board/runtime scaling, command regression and commissioning evidence are review/staleness targets; generic bipolar electrical evidence does not automatically become stale when its hardware/envelope did not change.

The unresolved DAC_FAULT/TPS26611_SGOOD route supplies the second example. It remains explicitly unresolved and must not be counted as zero. When engineering closes that route, the closure itself is a material RESOURCE_BINDING_CHANGE that triggers review of FPGA allocation, electrical pin/bank compatibility, schematic connectivity, shared-resource ownership, firmware/HAL semantics, diagnostic power validity, fault injection and dependent release claims.

## Catalog stress-test finding

The catalog still lacks a machine-readable dependency/release graph with stable semantic IDs, typed dependency edges, subject revisions, envelopes, unresolved states, evidence/claim IDs, change events, staleness reasons, regression records and release effects. This prevents mechanical reverse lookup of “where used” and automatic stale-evidence propagation after a material engineering change.

OpenPressBrake remained read-only because current main is actively advancing board/block engineering. No simulation, synthesis, place-and-route, timing, regression, or other executable verification was required; no hosted compute was used.

Both repositories were re-read on current main immediately before checkpointing. Curriculum main was `3e7d4bd429941e834f57f84cd7611b2dffafac1e`; OpenPressBrake main was `86915569066300908b0cfdc6e67739d0f8388fb9`.

## Next run

Develop **BD75 — Controlled Engineering Change, Review Ownership, Baseline Supersession, and Auditable Release History**:

`accepted release graph + change event -> impact owner assignment -> proposed engineering change -> affected evidence/regression plan -> review/approval -> regression evidence attachment -> old-baseline supersession -> new immutable release baseline -> auditable history`

Re-open every student-facing source on current main. Teach that change approval is not technical evidence, that old baselines remain historically traceable rather than silently rewritten, and that reusable-block changes versus board-specific overlays have different blast radii. Include rollback/supersession semantics, ownership for unresolved physical-machine facts, and preservation of the independent personnel-safety boundary. Keep OpenPressBrake read-only if active engineering overlaps.