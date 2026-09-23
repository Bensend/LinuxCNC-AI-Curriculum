# Board-Design Curriculum Checkpoint

Current durable lesson: **BD67 — Whole-Board Power/Return Graph and Fault-Containment Reconciliation**

Curriculum lesson commit: `a61505a517c31a086b25ef54fb79916f2168a74d`.

OpenPressBrake engineering source inspected for BD67: `324892fac20cc81ca9a3ae00a89e88607d17fc41`.

## Verified student-facing sources for BD67

- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for status truthfulness, shared-resource/integration boundaries and maintenance requirements.
- `hardware/blocks/machine_power/design/REV23_5V_RAIL_HIERARCHY_RECONCILIATION.md` — VERIFIED_FOR_LESSON for the current 5-V parent/child hierarchy, known populated continuous subtotal and explicitly open load/startup gates.
- `hardware/blocks/machine_power/REFERENCE_REBASE.md` — VERIFIED_FOR_LESSON for current Rev23 machine-power authority, source/return boundaries and open production gates.
- `hardware/blocks/machine_power/STATUS_CHECKLIST.md` — ENGINEERING_REVIEW_NEEDED as a complete current status/evidence index because it still identifies Rev17 and omits Rev23 evidence; VERIFIED_FOR_LESSON only for bounded unresolved-gate statements consistent with current authority.
- `board-design/BD66_SCHEMATIC_INTEGRATION_NET_OWNERSHIP.md` — VERIFIED_FOR_LESSON as the prerequisite semantic-net reconciliation method.

## Closure result

BD67 freezes the rule `A POWER BUDGET IS NOT A POWER ARCHITECTURE`. Board-power acceptance requires explicit source ancestry, typed load evidence, normal/startup/transient/fault current graphs, return domains, enable/default dependencies, fault-containment boundaries and evidence locks.

Current OpenPressBrake authority freezes one LMR36520 hierarchy: `5V_MAIN -> ANALOG_BRANCH_FILTER -> 5V_ANALOG`. The 121.36-mA known child load rolls upstream exactly once; with 13.20 mA of direct `5V_MAIN` PVR6 protector demand, the known populated continuous subtotal at the LMR36520 output is 134.56 mA. This remains preliminary rather than a final regulator requirement because direct 5-V consumers and startup/inrush remain open.

## Catalog stress-test finding

The machine-power `STATUS_CHECKLIST.md` is stale relative to current Rev23 authority despite the repository maintenance rule requiring material changes to update the checklist in the same change. Treat it as ENGINEERING_REVIEW_NEEDED as a complete current evidence index. A future machine-readable whole-board power/return graph should encode parent/child rails, separately sourced field branches, typed load evidence, normal/startup/transient/fault paths, return domains, enables, protection ownership and evidence locks.

OpenPressBrake remained read-only. Current main was re-read at `324892fac20cc81ca9a3ae00a89e88607d17fc41`; active engineering has just advanced machine-power and safety-interface integration. Curriculum main was re-read after the BD67 lesson commit before this checkpoint update. No simulation, synthesis, timing, place-and-route or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD68 — Startup/Shutdown Sequencing, Brownout, and Output-Authority Reconciliation**:

`accepted power/return graph -> source ramp/order -> reset/enable dependencies -> brownout behavior -> output default/inhibit states -> watchdog/power-fault interactions -> shutdown energy paths -> sequence fault injection plan -> integration acceptance`.

Re-open every student-facing source on current main. Preserve `VERIFY_AT_MACHINE` facts, keep ordinary controller fault handling separate from independent personnel-safety authority, and do not claim the current OpenPressBrake board is production-proven.