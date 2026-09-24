# Board-Design Curriculum Checkpoint

Current durable lesson: **BD77 — Catalog Selection Decision Records and Design-Space Trade Studies**

Curriculum lesson commit: `18582886e132bc7b34445661b4f4df120bdfd12b`.

OpenPressBrake engineering source inspected for BD77: `0ea6b60e883821ffc022e53e85ff63aa17634f48`.

## Verified student-facing sources for BD77

- `hardware/blocks/README.md` — VERIFIED_FOR_LESSON for primitive/shared-resource decomposition, request-to-board assembly order, connector/function separation, evidence hierarchy, and explicit TBD policy.
- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for maturity terminology, integration-versus-qualification separation, evidence truthfulness, and material-change maintenance.
- `hardware/blocks/digital_output_24v/manifest.yaml` — VERIFIED_FOR_LESSON for the current protected high-side primitive contract, isolation/return domains, FPGA/shared-resource demand, deterministic OFF authority, diagnostics, unresolved board envelope, and non-safety role.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current evidence maturity and open CAD/connector/thermal/qualification gates.
- `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for the distinct voltage-free SPDT function, current NOT READY state, 24-V coil power handoff, open physical/CAD/machine gates, and non-safety role.
- `board-design/BD76_CATALOG_CONSUMER_COMPATIBILITY_SEMVER_MULTI_MACHINE_ROLLOUT.md` — VERIFIED_FOR_LESSON as prerequisite contract/consumer compatibility method.
- `board-design/BD77_CATALOG_SELECTION_DECISION_RECORDS_TRADE_STUDIES.md` — VERIFIED_FOR_LESSON after creation and current-main re-read.

`hardware/blocks/catalog.yaml` was opened but is **ENGINEERING_REVIEW_NEEDED** as a complete student selection authority because several top-level entries remain broad concept/provisional summaries with TBDs and can lag block-local manifests/status. It is explicitly excluded as finished assigned selection material.

## Closure result

BD77 freezes three rules: **SELECT FROM THE REQUIREMENT, NOT FROM THE FAVORITE CIRCUIT**, **A CANDIDATE THAT FAILS A MANDATORY CONTRACT IS NOT SAVED BY A HIGHER SCORE ELSEWHERE**, and **UNKNOWN EVIDENCE IS A DECISION RISK, NOT ZERO COST**.

The lesson adds requirement-first decomposition, fail-closed mandatory filtering, evidence/maturity filtering, engineering trade-study dimensions, explicit selection states, auditable Selection Decision Records, rejected-alternative/reopening records, and downstream connection/resource-plan handoff.

The current protected high-side digital output and voltage-free SPDT relay output provide the adversarial example: both are ordinary outputs, but they are not interchangeable. A voltage-free contact requirement eliminates the high-side output before scoring; a protected sourced-24-V output requiring overload/overtemperature diagnostics eliminates the simple relay-contact primitive. An underspecified generic 'output' requirement is itself a decomposition defect.

## Catalog stress-test finding

Block-local contracts/status are stronger than the current top-level catalog as a selection authority. Future tooling needs a machine-readable candidate index that joins exact contract/maturity revisions, semantic functions, envelopes, defaults, diagnostics, protection, isolation, resource/power vectors, connector requirements, shared resources, cost evidence, unresolved facts, qualification evidence and supersession state to requirement IDs and the dependency/Where-Used graph. Stale catalog summaries should be mechanically flagged rather than silently preferred over block-local truth.

OpenPressBrake remained read-only because current main is actively advancing block power/resource engineering. No simulation, synthesis, place-and-route, timing, regression, or other executable verification was required; no hosted compute was used.

Immediately before checkpointing, current mains were re-read: curriculum `18582886e132bc7b34445661b4f4df120bdfd12b`; OpenPressBrake `0ea6b60e883821ffc022e53e85ff63aa17634f48`.

## Next run

Develop **BD78 — Catalog Gap Escalation and New-Block Authorization**:

`failed/held selection record -> prove no existing qualified contract fits -> classify new primitive vs variant vs adapter/connection need -> reusable requirement charter -> anti-duplication/Where-Used review -> engineering/evidence plan -> authorization gate -> block-development handoff`

Re-open every student-facing source on current main. Teach students not to create a new block merely because a machine has a different connector, label, harness, quantity, or operating point already covered by a reusable envelope. Require explicit proof of the gap, stable semantic IDs, scope/variant decision, resource/power/connector consequences, evidence plan, and independent safety boundary. If a selection gap is actually a stale or incomplete catalog contract, record/fix that defect rather than duplicating circuitry. Keep OpenPressBrake read-only if active engineering overlaps.