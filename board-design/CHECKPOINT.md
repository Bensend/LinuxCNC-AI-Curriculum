# Board-Design Curriculum Checkpoint

Current durable lesson: **BD70 — LinuxCNC/HAL Semantic Binding, Command Freshness, and Diagnostic Truthfulness**

Curriculum lesson commit: `f794463b94b24517d3030e7f2e6c80daa741d64d`.

OpenPressBrake engineering source inspected for BD70: `15bb483b01e85540355d9709534bb703d8888540`.

## Verified student-facing sources for BD70

- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — VERIFIED_FOR_LESSON for current FPGA resource ownership, rebased shared-resource accounting, watchdog/status reservations, and the external hardware-output-enable boundary.
- `hardware/blocks/fpga_core_ecp5_25/integration/rev32_openpressbrake_litexcnc_binding.json` — VERIFIED_FOR_LESSON for current LiteX-CNC binding/provenance rules and explicit MAX22216 rebase/open production-engine item; not proof of exact runtime HAL names or complete proportional runtime behavior.
- `hardware/blocks/fpga_core_ecp5_25/integration/rev31_litexcnc_rev1_proven_modules.json` — VERIFIED_FOR_LESSON only as bounded historical/proven GPIO/encoder/stepgen module provenance; DEPRECATED_OR_SUPERSEDED as current proportional-output runtime authority.
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md` — ENGINEERING_REVIEW_NEEDED as a completely current resource summary because human-readable resource counts retain pre-MAX22216 figures while the current resource map publishes the rebased unique GPIO totals; usable only for bounded open-gate/safety-boundary teaching where consistent with current authority.
- `board-design/BD69_FPGA_HOST_WATCHDOG_GLOBAL_ENABLE_STALE_COMMAND_CONTAINMENT.md` — VERIFIED_FOR_LESSON as the prerequisite authority/freshness method.
- `board-design/BD70_LINUXCNC_HAL_SEMANTIC_BINDING_FRESHNESS_DIAGNOSTIC_TRUTH.md` — VERIFIED_FOR_LESSON after post-commit re-open.

## Closure result

BD70 freezes the rule that **a name match is not semantic proof**. Board integration must separately reconcile machine intent, board connection endpoint, reusable block interface, FPGA physical resource, firmware module, transport/session validity, exact HAL object, application binding and physical observation.

No exact LinuxCNC HAL pin spelling is asserted from an FPGA resource name. Exact HAL names require current generated/runtime or driver-source evidence; otherwise the lesson requires `TBD_FROM_GENERATED_RUNTIME`.

The current OpenPressBrake LiteX-CNC binding provides a useful subset-validity example. The older proven module configuration remains valid provenance for bounded GPIO/encoder/stepgen structure, but its discrete proportional PWM/enable/fault model is superseded by the current MAX22216/shared-SPI rebase. The current binding explicitly removes/transforms that obsolete subset and still leaves the production MAX22216 transaction/register engine open.

BD70 also carries BD69 freshness into HAL semantics: transport connected, watchdog healthy, output qualification present and command fresh are distinct facts. Diagnostics may claim only what their observation point and valid power/freshness domain actually prove.

## Catalog stress-test finding

The catalog needs a machine-readable semantic-binding manifest joining stable semantic IDs across connection definition, reusable block, FPGA physical resource, firmware module, generated runtime/HAL object, authority class, freshness dependency, diagnostic claim and evidence revision. It should reconcile against the actual generated/runtime namespace rather than depend on hand-written names.

Provenance artifacts also need subset validity. A historical file can remain authoritative for one semantic subset while being superseded for another after a hardware rebase.

The FPGA status checklist contains pre-rebase resource totals while the current resource map reports the MAX22216/shared-SPI rebased totals. Treat the checklist as ENGINEERING_REVIEW_NEEDED for complete current resource-summary use; do not propagate stale totals into board decisions.

OpenPressBrake remained read-only because current main is actively advancing independent block resource contracts. No simulation, synthesis, timing, place-and-route or other executable verification was required; no hosted compute was used.

Both repositories were re-read on current main after the BD70 lesson commit and before this checkpoint update. Curriculum main contained `f794463b94b24517d3030e7f2e6c80daa741d64d`; OpenPressBrake main remained `15bb483b01e85540355d9709534bb703d8888540`.

## Next run

Develop **BD71 — Bench Bring-Up as Evidence: Semantic I/O Checkout, Fault Injection, and Commissioning Records**:

`accepted semantic binding -> powered-domain checkout -> known input stimuli -> inhibited output observation -> staged output energization -> fault/inhibit injection -> freshness/recovery test -> evidence record -> commissioning gate`.

Re-open every student-facing source on current main. Do not invent machine wiring, HAL names, test voltages/currents, watchdog timing, actuator behavior or safety-integrity claims. Keep outputs inhibited until the applicable electrical path and machine facts are verified. Preserve `VERIFY_AT_MACHINE/TBD` facts and do not claim the current OpenPressBrake board is production-proven.