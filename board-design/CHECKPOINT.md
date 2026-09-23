# Board-Design Curriculum Checkpoint

Current durable lesson: **BD68 — Startup/Shutdown Sequencing, Brownout, and Output-Authority Reconciliation**

Curriculum lesson commit: `7ae7ee7fd08fa314df60197184a01f357c456021`.

OpenPressBrake engineering source inspected for BD68: `83f07de87e300f0fb87bbaf81f79e72e5275ea8b`.

## Verified student-facing sources for BD68

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for status truthfulness, integration/qualification distinction and maintenance requirements.
- `hardware/blocks/machine_power/REFERENCE_REBASE.md` — VERIFIED_FOR_LESSON for current Rev23 machine-power source/control authority, TPS26633 static modes, fault output and open startup gates.
- `hardware/blocks/machine_power/STATUS_CHECKLIST.md` — ENGINEERING_REVIEW_NEEDED as a complete current status/evidence index because it still identifies Rev17; VERIFIED_FOR_LESSON only for bounded unresolved ILIM/dVdT/startup/FPGA-power/release gates consistent with current authority.
- `hardware/blocks/digital_output_24v/design/REV1_ISOLATED_INTERFACE_CONTRACT.md` — VERIFIED_FOR_LESSON for frozen isolated-output topology, separated L7/L07 domain and deterministic field-side OFF authority; not evidence of schematic-ready or production-qualified hardware.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — VERIFIED_FOR_LESSON for current maturity/open gates and safety boundary.
- `board-design/BD67_WHOLE_BOARD_POWER_RETURN_FAULT_CONTAINMENT.md` — VERIFIED_FOR_LESSON as prerequisite power/return/fault-containment method.

## Closure result

BD68 freezes the rule `A SAFE STEADY STATE DOES NOT PROVE A SAFE TRANSITION`. Board integration must distinguish command authority, actuator-facing electrical default authority, field-power authority and independent safety authority across no-power, partial-power, reset, host-loss, brownout, shutdown and recovery states.

The current Rev1 isolated digital-output contract provides a bounded positive example: `FPGA OUTPUT_COMMAND_L -> STISO621 -> OUTPUT_COMMAND_P -> IPS1025H`, with the IPS1025H field-side input pull-down retained as final deterministic ordinary OFF authority. Loss of FPGA command, logic-side 3.3 V, field-side isolation supply or switched L7 field power must leave the output OFF. This ordinary controller behavior receives no personnel-safety credit.

Current machine-power authority also demonstrates why fault indication is not fault containment: `LOGIC_POWER_FAULT_N` is an open-drain diagnostic pulled to `3V3_CORE` and observed by FPGA logic, while TPS26633 UVLO/latch behavior exists independently of software observation. The 134.56-mA known 5-V continuous subtotal does not close startup; remaining direct loads and startup/inrush still block TPS26633 ILIM/dVdT freeze.

## Catalog stress-test finding

Reusable resources need a machine-readable transition contract in addition to steady-state electrical/resource data: default bias authority, power dependencies, partial-power assumptions, startup/inrush/effective capacitance, reset/enable dependencies, watchdog/inhibit semantics, fault-indication power dependency, shutdown/stored-energy behavior and unresolved machine facts. Without this, board-level sequencing still depends on unwritten knowledge.

The machine-power status checklist remains stale relative to Rev23 and is ENGINEERING_REVIEW_NEEDED as a complete evidence index. OpenPressBrake remained read-only because current main is actively advancing resource contracts.

OpenPressBrake main was re-read at `83f07de87e300f0fb87bbaf81f79e72e5275ea8b` immediately before checkpointing. Curriculum main was re-read after the BD68 lesson commit. No simulation, synthesis, timing, place-and-route or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD69 — FPGA/Host Watchdog, Global-Enable, and Stale-Command Containment**:

`transition-closed output paths -> watchdog authority chain -> host/FPGA failure classes -> stale-command containment -> global-enable fanout -> LinuxCNC/HAL state mapping -> fault/recovery semantics -> verification matrix -> integration acceptance`.

Re-open every student-facing source on current main. Do not invent watchdog timeout values, FPGA reset behavior, machine timing, or safety-integrity claims. Preserve `VERIFY_AT_MACHINE/TBD` facts and do not claim the current OpenPressBrake board is production-proven.