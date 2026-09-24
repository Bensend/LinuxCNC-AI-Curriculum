# Board-Design Curriculum Checkpoint

Current durable lesson: **BD73 — Whole-Board Kitchen-Sink Release Review and Evidence Closure**

Curriculum lesson commit: `bdbe23aa4c3ec1f2fadc54d6e4a97b31e5011628`.

OpenPressBrake engineering source inspected for BD73: `d7b621e34ceec693a72fa75e2096af2c1bf8ef62`.

## Verified student-facing sources for BD73

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for maturity, truthfulness, baseline/qualification separation, and maintenance/regression obligations.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for current board-level allocation, power domains, output authority, safe states, and explicit release gates; not evidence that those gates are closed.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON for electrical pinout authority and explicit unresolved mechanical/harness facts.
- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — VERIFIED_FOR_LESSON for current static GPIO/shared-resource accounting and explicit open local synthesis/place-route/timing gates.
- `hardware/blocks/analog_output/manifest.yaml` — VERIFIED_FOR_LESSON for reusable analog-output capability, required diagnostics, default/rearm behavior, electrical limits, and open qualification items.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — VERIFIED_FOR_LESSON for the current first-machine command overlay and fail-closed unresolved diagnostic binding.
- `board-design/BD72_QUALIFICATION_EVIDENCE_TRACEABILITY_RELEASE_PROMOTION.md` — VERIFIED_FOR_LESSON as the prerequisite evidence/traceability method.
- `board-design/BD73_WHOLE_BOARD_KITCHEN_SINK_RELEASE_REVIEW.md` — VERIFIED_FOR_LESSON after post-commit re-open.

## Closure result

BD73 freezes the rule that **LOCALLY PLAUSIBLE + LOCALLY PLAUSIBLE does not imply GLOBALLY CONSISTENT** and requires release review to search actively for contradictions rather than merely aggregate passing statuses.

The whole-board method now joins machine requirement, connection block, reusable block, electrical implementation, board allocation, FPGA/firmware resource, HAL/runtime meaning, commissioning observation and qualification claim. It separately traces source/protection/load/normal return/fault return/enable-default authority/diagnostic for power and authority paths.

The current OpenPressBrake audit produced four bounded findings:

1. **SCOPE_OVERLAY_NOT_PROPAGATED:** the reusable analog block validly supports ±10 V, but the current first-machine Commander SK contract authorizes only the standard 0..10-V T4 profile until installed configuration evidence proves otherwise. `REV1_BOARD_INTEGRATION.yaml` still describes `x_axis_analog.range_v` as `[-10, 10]`; board/runtime authority must consume the narrower machine overlay rather than narrowing the reusable primitive.
2. **UNRESOLVED_BINDING:** the analog manifest requires both `DAC_FAULT` and `TPS26611_SGOOD`, while the newest resource contract correctly refuses to guess their controller binding. The FPGA map includes `DAC_FAULT` in shared converter control but does not prove the complete binding for both required diagnostics. Final diagnostic resource closure remains open.
3. **QUALIFICATION_GAP:** static FPGA GPIO fit passes at 123 unique runtime GPIO of 191 conservatively available, but actual LiteX-CNC synthesis/place-route/resource/timing remain explicitly open for the self-hosted panel runner.
4. **PHYSICAL_GATE_OPEN:** legacy connector mechanical identity/coordinates and several harness facts remain VERIFY_AT_MACHINE and are explicit pre-PCB gates.

The inspected evidence therefore does not support calling the current OpenPressBrake board production-proven.

## Catalog stress-test finding

The catalog needs a machine-readable whole-board release graph joining stable semantic IDs across reusable blocks, board connections, FPGA/shared resources, power/returns, output authority/freshness, generated CAD, firmware/HAL binding, commissioning evidence, qualification claims and staleness.

A future validator should detect missing semantic owners/routes, stale downstream assumptions after overlays change, unresolved resources accidentally counted as zero, evidence made stale by dependency changes, shared resources double-counted or missing consumers, open VERIFY_AT_MACHINE release gates, and ordinary-control paths incorrectly credited with independent safety authority.

OpenPressBrake remained read-only because current main is actively advancing analog-output resource closure. No simulation, synthesis, place-and-route, timing, regression or other executable verification was required; no hosted compute was used.

Both repositories were re-read on current main immediately before the BD73 lesson commit. Curriculum main was `dbfaffdbdb4a94654a1b33d0564702b73765b7d6`; OpenPressBrake main was `d7b621e34ceec693a72fa75e2096af2c1bf8ef62`.

## Next run

Develop **BD74 — Release-Graph Dependency/Staleness Propagation and Change-Control Regression Planning**:

`whole-board gate register + stable semantic IDs + dependency edges -> upstream engineering change -> affected-claim discovery -> stale evidence propagation -> minimum justified regression set -> re-review -> release-baseline update`

Re-open every student-facing source on current main. Teach how a component, machine overlay, connector, power domain, FPGA resource, firmware semantic, or physical-machine fact change propagates through the board without either rerunning everything blindly or leaving stale evidence credited. Use the current analog-output command-envelope/diagnostic-binding findings as candidate examples only if current OpenPressBrake main has not superseded them. Keep reusable block definitions separate from board-specific connection/overlay facts, preserve the independent safety boundary, and do not claim production proof without evidence.