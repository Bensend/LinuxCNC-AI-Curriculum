# Board-Design Curriculum Checkpoint

Current durable lesson: **BD63 — Connection-Definition Validation and Authority-Reconciliation Tests**

Curriculum lesson commit: `c61d7e947255cb8d9e97b37a9e37dad2e4a12ad5`.

OpenPressBrake engineering source inspected for BD63: `0f0b7bede913e27cdc249255cf6fb28bc6d46b0b`.

## Verified student-facing sources for BD63

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — VERIFIED_FOR_LESSON for ownership, required fields, release gates and safety boundary.
- `hardware/connection_definition_schema.yaml` — VERIFIED_FOR_LESSON as the current fail-closed mold and validation-rule source; checkpoint remains `SCHEMA_DEFINED_NOT_MIGRATED`.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON only as bounded electrical-pinout authority; ENGINEERING_REVIEW_NEEDED as a completed physical connection-definition set.
- `hardware/REV1_MACHINE_CONFIG.yaml` — VERIFIED_FOR_LESSON for bounded first-machine Y1 encoder allocation.
- `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — VERIFIED_FOR_LESSON for field-pair/receiver/post-receiver boundaries, 3V3 allocation, termination and field-power ownership.
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` — VERIFIED_FOR_LESSON for current ENC1 post-receiver A/B/Z -> A15/A14/B14 -> `encoder_1` binding.
- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for evidence/status truthfulness and the rule that passing tests do not establish qualification beyond what they exercise.

## Validation result

BD63 freezes four distinct gates: structural validity, source-authority reconciliation, cross-domain semantic reconciliation, and promotion validity. A connection record can be structurally complete while still being engineering-wrong.

For the Y1 encoder path, a future validator must preserve the nine-position source pin authority, explicit legacy NC, typed field +5-V/encoder-return/CHASSIS_PE domains, differential-encoder functional ownership, and post-receiver ENC1 FPGA/LiteX-CNC binding. It must reject direct field-to-FPGA shortcuts, return-domain collapse, unsupported termination or physical-connector facts, repurposed NC contacts, and premature `board_capture_ready` promotion.

Unknowns are first-class states: `TBD`/`VERIFY_AT_MACHINE` may be acceptable during integration while still blocking board-capture promotion. A validator must never reward invented values merely because they make the record syntactically complete.

## Catalog stress-test finding

The current schema contains strong fail-closed prose rules, but the audited repository still lacks a release-consumable migrated Y1 connection instance plus executable cross-file authority-reconciliation evidence. That infrastructure gap is ENGINEERING_REVIEW_NEEDED. The bounded source artifacts above remain valid for the specific claims inspected.

OpenPressBrake remained read-only because current main is independently advancing board-integration resource work. No simulation, synthesis, timing, place-and-route, regression or other executable verification was required; no hosted compute was used. An executable validator, when justified, must run only on `[self-hosted, openpressbrake]`.

## Next run

Develop **BD64 — Connection-Definition Instance Closure and Generator-Ready Contracts**:

`validated semantic record -> physical connector evidence -> footprint/pad proof -> electrical derating -> placement/marking/harness closure -> generator inputs -> KiCad capture eligibility -> evidence lock`.

Prefer a bounded non-safety connector whose physical facts can actually be supported from current evidence. Do not invent machine measurements. Re-open every student-facing source on current main before assigning it, and avoid modifying an OpenPressBrake area that current main shows is actively changing.