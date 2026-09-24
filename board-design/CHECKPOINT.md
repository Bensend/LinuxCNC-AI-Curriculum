# Board-Design Curriculum Checkpoint

Current durable lesson: **BD69 — FPGA/Host Watchdog, Global-Enable, and Stale-Command Containment**

Curriculum lesson commit: `4ffd6743374c0290470bb6041d0d10382bd51123`.

OpenPressBrake engineering source inspected for BD69: `42eb89f170f1faedc38ef943ccb1329272c16982`.

## Verified student-facing sources for BD69

- `docs/BOARD_INTEGRATION_SPEC.md` — VERIFIED_FOR_LESSON for current ordinary-control architecture, independent watchdog/output-qualifier requirement, safe-state rules and explicit separation from retained Pilz safety authority.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — VERIFIED_FOR_LESSON for the machine-specific `PILZ_VALVE_ENABLE + WATCHDOG_OK + FPGA_CONFIGURED + CORE_POWER_GOOD -> PROP_OUTPUT_STAGE_ENABLE` hardware qualifier contract, software-only-path prohibition and safe-state declarations.
- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — VERIFIED_FOR_LESSON for current FPGA watchdog/status resource ownership and the explicit rule that `HARDWARE_OUTPUT_ENABLE` is a board-level fail-low permission fanout rather than an FPGA proportional-command resource.
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current maturity/open gates and safety boundary; it is not evidence that watchdog/global-enable electrical or application qualification is complete.
- `board-design/BD69_FPGA_HOST_WATCHDOG_GLOBAL_ENABLE_STALE_COMMAND_CONTAINMENT.md` — VERIFIED_FOR_LESSON after post-commit re-open.

## Closure result

BD69 freezes the rule that **authority is a chain, not one Boolean**. Board integration must separately account for command authority, command freshness, watchdog authority, independent electrical output qualification, field-power authority and independent personnel-safety authority.

The current OpenPressBrake machine integration is a bounded positive example: proportional output permission is a direct hardware result of `PILZ_VALVE_ENABLE`, `WATCHDOG_OK`, `FPGA_CONFIGURED` and `CORE_POWER_GOOD`, and a software-only enable path is forbidden. The FPGA resource map separately reserves `WATCHDOG_KICK`, `FPGA_RESET_STATUS`, `POWER_GOOD_IN` and `GLOBAL_OUTPUT_ENABLE_STATUS`; hardware output enable is explicitly outside FPGA proportional-command ownership.

The FPGA status checklist further records that LiteX-CNC owns the runtime watchdog while the external hardware output gate remains independent containment, and that the FPGA observes global-enable status rather than owning the global-enable command. This ordinary process-control containment receives no personnel-safety credit.

BD69 adds a command-freshness/control-epoch requirement: after host/comms loss, watchdog timeout, FPGA reset, brownout, configuration restart or explicit global inhibit, pre-event motion commands are stale. Reappearance of field power or a global qualifier must not by itself resurrect those commands.

## Catalog stress-test finding

The current catalog has the correct high-level watchdog/global-enable separation but still lacks a release-consumable machine-readable transition/freshness contract. That contract should publish watchdog kick ownership and what progress a kick proves, timeout evidence, global-enable ownership/fanout, electrical defaults and partial-power behavior, freshness-invalidating events, stale-command clearing/epoch rules, recovery prerequisites, diagnostic power dependencies and accepted process-control loss interval.

The current FPGA checklist itself leaves manufacturer timing/voltage/temperature, downstream fanout/unpowered-input behavior and machine/application acceptance of the final process-control loss interval open. Complete watchdog/global-enable qualification therefore remains **ENGINEERING_REVIEW_NEEDED**, not production-proven.

OpenPressBrake remained read-only. Current main was independently advancing motor-drive package/resource reconciliation, outside the lesson's bounded watchdog audit. No simulation, synthesis, timing, place-and-route or other executable verification was required; no hosted compute was used.

Both repositories were re-read on current main before this checkpoint update. Curriculum main contained the BD69 lesson commit; OpenPressBrake main remained `42eb89f170f1faedc38ef943ccb1329272c16982`.

## Next run

Develop **BD70 — LinuxCNC/HAL Semantic Binding, Command Freshness, and Diagnostic Truthfulness**:

`accepted authority chain -> FPGA semantic resources -> transport/session state -> HAL pins/signals -> command/feedback/fault ownership -> freshness/recovery semantics -> diagnostic truth table -> bench-observable acceptance contract`.

Re-open every student-facing source on current main. Prefer current LiteX-CNC/OpenPressBrake binding artifacts that can prove semantic ownership. Do not invent HAL names, watchdog timeout values, transport guarantees, reset behavior, machine timing or safety-integrity claims. Preserve `VERIFY_AT_MACHINE/TBD` facts and do not claim the current OpenPressBrake board is production-proven.