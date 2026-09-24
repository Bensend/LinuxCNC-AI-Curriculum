# Board-Design Curriculum Checkpoint

Current durable lesson: **BD71 — Bench Bring-Up as Evidence: Semantic I/O Checkout, Fault Injection, and Commissioning Records**

Curriculum lesson commit: `2e3459f261638759b8b0cd87f414ede6cd22555d`.

OpenPressBrake engineering source inspected for BD71: `102a4065e577da37f1a8873184ed11923a2b23cb`.

## Verified student-facing sources for BD71

- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for current machine-specific ordinary-control I/O assignments, domain separation, output-enable qualifiers, safe states, retained safety ownership and explicit release gates; not evidence of completed physical commissioning.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON for frozen electrical pinout intent and explicit unresolved mechanical facts; physical connector manufacturer/series/footprint/mating condition/coordinates remain VERIFY_AT_MACHINE/TBD.
- `hardware/blocks/digital_input_24v/manifest.yaml` — VERIFIED_FOR_LESSON for the reusable ISO1212 input semantic/electrical/resource contract and its declared open/TBD items.
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for the current SIMULATION-READY maturity boundary and open release gates; not schematic-ready or Rev-1-ready evidence.
- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for maturity/status truthfulness and the separation between integration baseline and full qualification.
- `board-design/BD70_LINUXCNC_HAL_SEMANTIC_BINDING_FRESHNESS_DIAGNOSTIC_TRUTH.md` — VERIFIED_FOR_LESSON as the prerequisite semantic/freshness method.
- `board-design/BD71_BENCH_BRINGUP_EVIDENCE_FAULT_INJECTION_COMMISSIONING.md` — VERIFIED_FOR_LESSON after post-commit re-open.

## Closure result

BD71 freezes the rule that **a successful actuation is not commissioning evidence unless the expected inactive, invalid, faulted and recovery states were also tested**.

Bring-up now uses a staged evidence ladder: unpowered inspection/domain checks, core-power checkout, field-interface observation with outputs inhibited, inhibited-output command tests, bounded staged output energization, ordinary-control fault/recovery injection, and only then machine commissioning when machine prerequisites are closed.

The OpenPressBrake digital-input path is a bounded worked example. The ISO1212 reusable contract is rich enough to define field input/return, logic output, protection envelope and resource demand, while the board contract assigns actual machine semantics. A runtime bit change alone does not prove the field connector, polarity, electrical envelope or invalid-state behavior.

For energy-producing outputs, BD71 requires proving the negative case first. The current board contract's proportional-output qualifier is the hardware conjunction of PILZ_VALVE_ENABLE, WATCHDOG_OK, FPGA_CONFIGURED and CORE_POWER_GOOD; a software-only path is forbidden. Bring-up must demonstrate output inactivity with permission denied before energized actuation is allowed. This ordinary-control test receives no personnel-safety credit.

BD71 also carries command freshness into physical commissioning: after a watchdog, reset, transport, power or explicit-inhibit event invalidates the command epoch, restoration of the prerequisite alone must not be treated as evidence that an old active command is valid again. If recovery semantics are not defined, classify the test BLOCKED_BY_CONTRACT rather than passing by observation.

## Catalog stress-test finding

The reusable catalog needs a common machine-readable commissioning contract. Static electrical/resource contracts do not currently join semantic IDs to safe bench stages, stimulus/reference definitions, observation points, power-validity dependencies, default/inhibit expectations, required bounded fault injections, freshness-invalidating events, recovery prerequisites and evidence/promotion records.

The current `digital_input_24v` manifest and checklist illustrate the gap truthfully: they provide strong electrical/resource evidence and remain SIMULATION-READY, but they are not a complete bench-commissioning procedure. The curriculum does not invent missing qualification evidence.

OpenPressBrake remained read-only because current main is actively advancing block resource/power closure. No simulation, synthesis, place-and-route, timing, regression or other executable verification was required for this lesson; no hosted compute was used.

Both repositories were re-read on current main after the BD71 lesson commit and before this checkpoint update. Curriculum main contained `2e3459f261638759b8b0cd87f414ede6cd22555d`; OpenPressBrake main remained `102a4065e577da37f1a8873184ed11923a2b23cb`.

## Next run

Develop **BD72 — Qualification Evidence Packages, Traceability, and Release Promotion**:

`commissioning evidence -> requirement/evidence traceability -> unresolved-fact disposition -> block-versus-board qualification boundary -> regression obligations -> release review -> qualified baseline without overclaiming`.

Re-open every student-facing source on current main. Build a traceability method that distinguishes calculation, datasheet, simulation, automated integration, bench, machine and human-review evidence. Do not let one passing artifact promote unrelated claims. Preserve VERIFY_AT_MACHINE/TBD facts and do not call the current OpenPressBrake board production-proven without the required evidence.