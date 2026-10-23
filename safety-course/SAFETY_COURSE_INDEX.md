# Practical Machine Safety Engineering — Learner Navigation

This is the concise navigation surface for the 2500 safety course. `../SAFETY_COURSE_RESEARCH.md` remains the broad research/course plan; this index points learners to mature course artifacts without duplicating that plan.

## Current sequence

- **2510 — Safety as an engineering problem:** prerequisite mental model from the research/course plan and existing safety-boundary material.
- **2520 — From hazards to safety functions:** mature learner-facing methodology. Start at `2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; it owns the ordered path through hazard/SRS derivation, composition, fault/diagnostic analysis, architecture/dependency/CCF allocation, integrity-method gate, verification/validation/physical proof, and commissioning/change control.
- **2530 — E-stop systems from first principles:** start at `2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. The methodology is ready for external/fresh evaluation, not self-certified as graduated.
- **2540 — Relays, contactors, and the real meaning of a safety relay:** start at `2540_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`. The route covers relay meaning, five commercial families and switching/reliability physics, machine final elements, and adversarial relay-to-safe-state reasoning. External/fresh evaluation remains open via `../evaluation/2540_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`.
- **2550 — ISO 13849 without the mystique:** begin at `2550_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2560 — IEC 62061 / SIL concepts:** begin at `2560_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2570 — Drives, STO, braking and hazardous motion:** begin at `2570_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2580 — Hydraulic and pneumatic safety:** begin at `2580_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2590 — Guards, interlocks and presence sensing:** begin at `2590_GUARDS_INTERLOCKS_PRESENCE_SENSING_SOURCE_PREP_2026-09-23.md`; verify its independent release/evaluation record before assigning readiness.
- **25A0–25F0 —** follow `../SAFETY_COURSE_RESEARCH.md`, current learner-facing module artifacts and `SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md`; do not infer graduation from a completed lesson or from an unexecuted external gate.

## 4400 safety implementation deepening (does not change 2500 graduation)

The current 4000 safety branch extends the existing 2520–25F0 course without reopening graduated 1000–3000 levels. For the operator-interface distinction `dual foot-pedal AND != two-hand protective function`, read `../research/4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md` and complete `4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md`. These are source-based learning artifacts, **not** a selected press-brake circuit, validated safeguard or external competency score. Additional published 4400 follow-ons: `4400_MODE_DEPENDENT_SAFEGUARD_VALIDATION_MATRIX_2026-10-23.md` (all cases NOT RUN); `../research/4400_AKAS5M_VS_LC5M_VARIANT_TRANSFER_TRAP_2026-10-23.md` with `4400_AKAS_VARIANT_SUBSTITUTION_CHANGE_REVIEW_2026-10-23.md`; `../research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md` with `4400_GUARD_RELEASE_PROPOSITION_AND_MAINTENANCE_TECHNICIAN_EXERCISE_2026-10-22.md`; and `4400_ESTOP_LATCH_FIRST_SCAN_ADVERSARIAL_CARD_2026-10-22.md`. These are published learning materials, not physical validation or new external graduation evidence. All machine-specific stopping/holding and protective coverage remain to be demonstrated.

For a **GuardLink 432ES appended-node topology change**, use `../research/4400_432ES_APPENDED_NODE_INACTIVE_SAFETY_FUNCTION_SOURCE_TRACE_2026-10-23.md` and `4400_GUARDLINK_NODE_CHANGE_PHYSICAL_PROOF_TECHNICIAN_CARD_2026-10-23.md`. Manufacturer documentation warns that an appended node can remain inactive if its documented link sequence is skipped; a pre-existing protective stop can mask an unproven new guard. The cumulative design package now includes section 11C for causal and physical-proof continuity. **Documentary lesson only; all selected-machine `VAL`/`PT` cases remain NOT RUN.**

For **guard-lock replacement and safety I/O interface qualification**, use `4400_CTP_STATE_TABLE_REPLACEMENT_ADVERSARIAL_CARD_2026-10-22.md` (EUCHNER CTP-I1 versus CTP-L1 closed/unlocked output semantics) and `../research/4400_CTP_SAFE_RECEIVER_VS_SOLENOID_PULSE_INTERFACE_NOTE_2026-10-22.md` (OSSD test pulses versus solenoid-drive pulses versus supply dips). The selected-safety-block worksheet now requires pulse parameter ownership by signal direction. No replacement equivalence, filter value, stop/hold behavior or machine-level safety claim is established by the examples.

For **hydraulic pressure-zone and residual-energy evidence**, use `../research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` and `4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md`. These distinguish the selected catalog part's optional gauge/bleed features from an installed machine's trapped volumes, elevated-load restraint, maintenance isolation and independently witnessed physical safe state. The selected-block qualification worksheet now requires pressure-port-to-zone mapping. **No selected hydraulic schematic, stopping/holding result, pressure threshold or machine release is implied.**

For **diagnostic tag validity and misleading HMI indications**, read `../research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md` and complete `4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md`. The manufacturer documents inactive-mode zeroed tags and inconsistent fault-example bit interpretation; the cumulative package now requires product/firmware/epoch/freshness and live-versus-event provenance before crediting any diagnostic witness. HMI data cannot prove independent physical safe state.

For **guard-defeat human factors**, complete `4400_GUARD_DEFEAT_INCENTIVE_DESIGN_REVIEW_2026-10-22.md`. The IFA/DGUV MaSeM method examines real task/mode/guard combinations and the benefit of bypass; the cumulative `HF` section now requires observed legitimate workflow friction, practical design mitigation, and revalidation of unchanged physical safety protection. No site observation or MaSeM result has been fabricated.

For **maintenance hydraulic isolation versus production stopping**, use `../research/4400_ROSS_HLOX_MANUAL_ISOLATION_VS_RAM_PROOF_SOURCE_NOTE_2026-10-22.md`. A padlockable valve with a local gauge can aid maintenance energy control but cannot prove every trapped hydraulic volume or gravity-loaded beam restraint; the cumulative package §11A now explicitly preserves that distinction. Manufacturer product-family documentation is not selected-machine physical proof.

For **series-wired guard contact fault masking and current standard edition**, use `../research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md` and `4400_GUARD_SERIES_ORDERED_FAULT_MASKING_FIELD_EXERCISE_2026-10-23.md`. The two-guard Boolean counterexample demonstrates order-dependent masking at shared receiver inputs without pretending to know a particular safety relay's fault memory. ISO 14119:2024 Annex J is the current-edition review route, with ISO/TR 24119:2015 retained as historical scope; selected DCavg/PL and physical machine proof remain UNKNOWN.

For **physical guard escape and mechanical dependency changes**, use `4400_GUARD_EGRESS_DEPENDENCY_CHANGE_WORKSHEET_2026-10-22.md` with `../research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md`. Distinguish an electrical stop demand from a passable escape route and physically stopped/held machine; changes to brackets, hinges, geometry or release access invalidate affected evidence. No live trapped-person test is authorized.

For **accumulator SAF model-code and optional-gauge substitution traps**, use `../research/4400_HYDAC_SAF_MANUAL_AUTO_BLEED_OPTIONAL_GAUGE_VARIANT_AUDIT_2026-10-22.md` alongside the published HYDAC gauge-zero exercise. The exact `M` manual-discharge and `E` solenoid-plus-manual catalog entries differ despite generic family fields; selected hydraulic response, bleed path and physical pressure/holding proof remain UNKNOWN.

## Information-separated competency status

2520–2580 have learner-facing methodology and entry routes; 2520–25F0 external/fresh competency execution gates remain OPEN unless separately supported by independent evaluator records. READY FOR EXTERNAL/FRESH EVALUATION is not graduation. Do not self-score or expose hidden evaluator solutions before learner precommitment.

A blocked external/fresh evaluator is not a reason to idle the safety course. Continue the next unblocked source/research branch while preserving information separation.

## Safety-authority boundary

Ordinary LinuxCNC, HAL, normal FPGA control, PC software and ordinary communications may request stops, inhibit production behavior, display state and support diagnostics. They do not acquire personnel-safety authority merely because they participate in the machine-control architecture. Safety-related control and physical energy/motion control must be allocated and evidenced independently for the actual safety function.

## Evidence discipline

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Machine-specific stopping times/distances, hydraulic/pneumatic truth, required PL/SIL, diagnostic coverage, reliability values and physical safe-state facts remain `UNKNOWN` until supported by the appropriate design-specific evidence.

### GuardLink reset/rearm, diagnostic conflicts and replacement (4400)

For the **separate authority of DG safety relay, non-safety-rated ENETR diagnostics and 432ES CIP Safety architecture**, read `4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD_2026-10-23.md`. Use `4400_GUARDLINK_FAULT_RECOVERY_CHANGE_CONTROL_WORKSHEET_2026-10-23.md` and `4400_GUARDLINK_RESET_AND_REPLACEMENT_TECHNICIAN_CARD_2026-10-23.md` for change-control and adversarial commissioning cases. Original manufacturer 2026 ENETR Table 2 versus Table 6 reset units and Table 5 diagnostic-XOR ambiguity are documented in `../research/4400_ENETR_RESET_UNITS_AND_DIAGNOSTIC_XOR_CONFLICT_2026-10-23.md`. **Manufacturer printed contradiction is not a selected firmware fact**; all actual `VAL/PT` remain NOT RUN, and normal LinuxCNC/HMI never owns personnel-safety decisions.

For a **historical compact hydraulic shut-off/discharge example**, read `../research/4400_HYDAC_DSV10_LOW_COST_SHUTOFF_DRAIN_SOURCE_SCOPE.md` and complete `4400_DSV10_COMBINED_ISOLATION_NEGATIVE_OVERLAP_FIELD_EXERCISE_2026-10-23.md`. HYDAC's 2003 brochure documents a brief P/S/T interconnection during manual changeover. This is not evidence of current product suitability, safe load holding or downstream depressurization. Preserve exact selected hydraulic topology and independent physical witnesses as UNKNOWN/NOT RUN.

For pressure-zone traceability across `BND/ENE/ARC/DEP/SRS/PHY/AUTH/VAL/PT/CHG/RR`, use `4400_PRESSURE_ZONE_PHYSICAL_WITNESS_TRACEABILITY_WORKSHEET.md` as a conditional supplement to the existing eight-field SO final-element specification. It is a blank qualification card, not machine proof.


### 4400 safety transfer — process locking, maintenance isolation, and workpiece sweep (2026-10-23)

- [EUCHNER I1 process-lock versus L1 safety-lock source comparison](../research/4400_EUCHNER_PROCESS_LOCK_VS_SAFETY_LOCK_MONITORING_2026-10-22.md) and [substitution adversarial exercise](4400_EUCHNER_LOCK_SUBSTITUTION_ADVERSARIAL_2026-10-22.md): equal holding-force numbers, RFID and a green `OL` diagnostic do **not** transfer safety-rated guard-lock monitoring. Order 136595 M12 8-pin versus order 123375 M23 19-pin are not plug-compatible assumptions.
- [OSHA maintenance energy-control/test-position source trace](../research/4400_OSHA_LOTO_TEST_POSITION_REISOLATION_STATE_MACHINE_2026-10-23.md) and [lockable-isolator retrofit technician exercise](4400_LOCKABLE_ISOLATOR_TAGOUT_RETROFIT_TECHNICIAN_CARD_2026-10-22.md): E-stop/control-circuit devices are not maintenance isolators; after a necessary powered positioning test, isolate and verify again.
- [AKAS overrun-text conflict and moving-workpiece sweep exercise](4400_OVERTRAVEL_SOURCE_CONFLICT_AND_WORKPIECE_SWEEP_CASE_2026-10-23.md): no unqualified 11/13 mm acceptance limit and no transfer from laser test to sheet-sweep/secondary hazards.

These are learner-visible documentary exercises, **not** hidden evaluator answers or selected-machine acceptance evidence. All physical `VAL/PT` remain NOT RUN.

For **432ES GuardLink HMI quality**, use [the 432ES first-trip/uncertain/historical-fault manufacturer trace](../research/4400_432ES_FIRST_TRIP_UNCERTAIN_HISTORICAL_FAULT_TAG_SCOPE_2026-10-23.md). Its `Ch0.Status` is a manufacturer-described safety bit for the selected 432ES CIP Safety path, while `DeviceTripAddress` is first-event evidence, `Uncertain` flags questionable data, and Safety Device Library fault rows 2–4 are historical. None of these tags proves a physical ram stop, safe access, or occupancy; ordinary LinuxCNC/HMI remains outside personnel-safety authority.

Open-book practice: [432ES first-event versus stale diagnostics technician exercise](4400_432ES_FIRST_EVENT_STALE_DIAGNOSTICS_TECHNICIAN_EXERCISE_2026-10-23.md). No live fault injection; separate HMI diagnostics from independent safety authority and actual physical stop/hold.

Further 4400 transfer exercises: [stale proof across press brake, mill, lathe, plasma and robot cell](4400_STALE_PROOF_CROSS_MACHINE_TRANSFER_2026-10-23.md) and [LinuxCNC software E-stop latch three reset timelines versus independent physical safety](4400_ESTOP_SOFTWARE_STATE_VS_PHYSICAL_PROPOSITION_WORKSHEET_2026-10-22.md). These do not qualify normal LinuxCNC as personnel-safety control, and do not transfer old machine proof across hardware, mode or configuration changes.

Pinned-source companion for the software reset timelines: [LinuxCNC v2.9.10 `estop_latch.comp` and `halcompile.g` first-scan audit](../research/4400_LINUXCNC_2_9_10_ESTOP_LATCH_FIRST_SCAN_SOURCE_AUDIT_2026-10-23.md), including upstream Git blob IDs and zero-initialized `old_reset`. SOURCE-CONFIRMED software logic does not authorize machine rearm.

Guard/escape technician practice: [guard locking, inside escape and reset/restart distinctions](4400_GUARD_LOCK_ESCAPE_RELEASE_TECHNICIAN_CARD_2026-10-22.md) and [Pilz bracket, cable-route and actual egress qualification](4400_GUARD_MOUNTING_ESCAPE_FIELD_QUALIFICATION_2026-10-22.md). A locked indication does not prove an unobstructed escape path, a qualified mounting force, actual machine stop/hold or maintenance isolation.

Manufacturer source companion: [Schmersal AZM300Z/B unlock-versus-guard-open output semantics and Pilz PSEN ml escape-cable routing](../research/4400_SCHMERSAL_AZM300Z_B_AND_PILZ_ESCAPE_CABLE_SOURCE_2026-10-23.md). Product-specific documentary evidence, not installed-machine stop/hold or physical egress validation.

Hydraulic safety transfer: [HAWE SAKB five monitored manifold positions versus separate NSV source scope](../research/4400_HAWE_SAKB_FIVE_MONITORED_VALVES_VS_NSV_SOURCE_SCOPE_2026-10-23.md), [valve-coverage technician exercise](4400_HYDRAULIC_COVERAGE_TECHNICIAN_CARD_2026-10-22.md), and [accumulator-family/pressure-zone adversarial exercise](4400_ACCUMULATOR_FAMILY_PRESSURE_ZONE_TECHNICIAN_EXERCISE_2026-10-22.md). A single low gauge or five healthy valve tags cannot prove elevated load restraint or every trapped hydraulic volume.

Original Pilz 1004710-EN-10 source proof for the bracket exercise: [PSEN ml direct-mount versus bracket holding-force and escape-release accessory scope](../research/4400_PILZ_PSENML_MOUNTING_FZH_ESCAPE_1004710_EN10_2026-10-23.md). The manufacturer lists different `FZh` values for different mounting arrangements and an accessory release-force specification that does not establish jammed-gate egress.

Additional field templates: [stop request, normal access, inside escape and reset/restart temporal ordering](4400_ACCESS_RELEASE_ORDERING_PROOF_TECHNICIAN_WORKSHEET_2026-10-22.md) and [guard-chain topology, fault masking, independent physical proof and change control](4400_GUARD_CHAIN_QUALIFICATION_AND_CHANGE_CONTROL_WORKSHEET_2026-10-22.md). Both explicitly prohibit live hazardous fault injection with people exposed.

Guard-chain fault masking field practice: [three series-wired gates, masked faults and 432ES first-trip diagnostic trap](4400_GUARD_SERIES_FAULT_MASKING_TECHNICIAN_FIELD_CARD_2026-10-22.md). Do not substitute ordinary HMI gate inputs for independent safety diagnostics or infer physical stopping from relay state.

### 4400 maintenance indicator and selected-mode transfer (2026-10-23)

Read [OSHA's LED-versus-isolation and Rockwell 432ES event-tag source audit](../research/4400_OSHA_LED_INDICATION_VS_PHYSICAL_ISOLATION_AND_GUARDLINK_EVENT_2026-10-23.md) and complete [three indicators, zero isolation proof](4400_THREE_INDICATORS_ZERO_ISOLATION_PROOF_TECHNICIAN_EXERCISE_2026-10-23.md). The OSHA December 12, 2012 letter rejects substituting its described redundant disconnect LEDs for 1910.147(d)(6) verification; a GuardLink first-event address is not current state or a physical energy witness. All selected-machine `VAL/PT` remain **NOT RUN**.

Newly published archive-exact learner worksheets: [guard release/lock variant traceability](4400_GUARD_RELEASE_TRACEABILITY_CHANGE_WORKSHEET_2026-10-22.md), [Pilz standstill monitor versus machine safe state](4400_STANDSTILL_GATE_ADVERSARIAL_QUALIFICATION_2026-10-22.md), and [AKAS muting/tool-change mode proof](4400_AKAS_MUTING_MODE_CHANGE_TECHNICIAN_PROOF_CARD_2026-10-23.md). They teach separate physical stop/hold/escape, maintenance isolation, mode-specific protection and independent safety authority. These open-book exercises are not external blind scores or permission for personnel-exposed operation.

**Configuration identity versus function test:** [Pilz PNOZ s30 CRC transfer and change-control source trace](../research/4400_PILZ_PNOZS30_CONFIG_CRC_TRANSFER_VS_FUNCTION_TEST_2026-10-23.md) checks manufacturer manual 1001715-EN-24 §§8.5–10: a matching configuration CRC is not proof that the correct application project was chosen or that the installed safety function operates. A project rename or older-version upgrade can change CRC; the manufacturer separately requires functional checks after changes/downloads. Use the published standstill exercise for transfer. No selected-machine `VAL/PT` performed.

**Current HYDAC SAF source correction:** [May 2024 manufacturer catalog comparison](../research/4400_HYDAC_2024_SAF_LOCK_OPEN_CLOSED_OPTION_CURRENT_SCOPE_2026-10-23.md) independently confirms that `L`/`LPI`/`LPM` lockable shut-off options may secure the valve **OPEN or CLOSED**, and `LS` is a different pressure-release locking option. The old 2003 example is no longer the only documentary evidence for this family-level trap; the installed model/position, isolation and ram restraint still require physical verification.

Open-book cross-machine transfer: [guard-lock and standstill hazards across mills, lathes, press brakes, plasma, robots and feeders](4400_GUARD_LOCK_STANDSTILL_CROSS_MACHINE_TRANSFER_2026-10-22.md). This archive-exact card is documentary reasoning only; it does not transfer a component's standstill setting, guard-lock performance or machine-specific stop/hold proof to another machine class.
