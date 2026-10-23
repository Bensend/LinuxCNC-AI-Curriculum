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

Hydraulic fault-path transfer: [automatic accumulator bleed versus energy needed for a protective cycle](../research/4400_HYDAC_SAF_PROTECTIVE_STOP_VS_AUTO_BLEED_ADVERSARIAL_REVIEW.md). The qualitative fault tree explicitly distinguishes machine-specific protective action, gravity holding, accumulator discharge, trapped pressure and maintenance isolation; it is **not** an invented hydraulic truth table or a completed machine test.

Additional exact archived open practice: [EUCHNER I1/L1 guard-lock output semantics versus physical machine safe-state transfer](4400_GUARD_LOCKING_CROSS_MACHINE_TRANSFER_AND_PROOF_PLAN_2026-10-22.md). Exact output meaning depends on the selected device/receiver; guard status, safe access, independent stop/hold, egress and maintenance isolation are different propositions.

For actual guard release and trapped-person escape evidence, use the [physical egress, maintenance and change-control field witness card](4400_GUARD_EGRESS_FIELD_WITNESS_AND_CHANGE_CONTROL_CARD_2026-10-22.md). It explicitly distinguishes ordinary access, inside escape and maintenance LOTO; all machine-specific `VAL/PT` remain NOT RUN.

Human-factors companion: [SAF pressure-witness test-point usability and anti-bypass design review](../research/4400_SAF_TEST_POINT_HUMAN_FACTORS_DESIGN_REVIEW.md). Label actual S/P/trapped-volume zones, make verification visible without exposure or guard defeat, and distinguish an HMI zero or padlock from physical isolation proof. Proposed hardware changes require selected-machine engineering and revalidation.


### 2026-10-23T12:39Z GuardLink/HMI diagnostic safety-boundary release

Read the exact archived manufacturer-source studies: [GuardLink reset/fault/topology authority](../research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md), [ENETR bitmask and conflicting manufacturer examples](../research/4400_ENETR_DIAGNOSTIC_TAG_BITMASK_AND_DOCUMENT_CONFLICT_AUDIT_2026-10-23.md), and [432ES first-event versus current state/HMI semantics](../research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md). Then study the new [event-epoch/freshness and release-gate integration](../research/4400_GUARDLINK_DIAGNOSTIC_EVENT_EPOCH_FRESHNESS_AND_RELEASE_GATE_2026-10-23.md) and cumulative Safety Design Package §11K. Two more archived learner exercises are now published: [mode-dependent safeguard acceptance](4400_MODE_DEPENDENT_ACCEPTANCE_TECHNICIAN_WORKSHEET_2026-10-23.md) and [overrun selected-setting freshness](4400_OVERRUN_FRESHNESS_SELECTED_SETTING_TECHNICIAN_CARD_2026-10-23.md).

**Boundary:** the 432ES CIP Safety channel status and 440R-ENETR ordinary diagnostic tags are not interchangeable. First-event address, node bitmap, fault-reset command, safety-related output, physical stopped/held state, access permission and maintenance isolation are separate claims. These documents are `DOC-CONFIRMED` or `INFERENCE`, **not** `TEST-CONFIRMED` selected-machine validation. All physical `VAL/PT` remain `NOT RUN`, and 2520–25F0 external competency gates remain OPEN.


### 2026-10-23T12:46Z AKFR physical-witness source release

For the historical **AKAS-F + AKFR** interface (not the AKAS-5M/LC-5M M-variant), read the [German/English original-language source audit](../research/4400_AKFR_PRESSURE_AND_VALVE_WITNESS_SOURCE_AUDIT_2026-10-23.md) and complete the [sensor-target versus hazard technician exercise](4400_AKFR_SENSOR_TARGET_AND_PHYSICAL_WITNESS_TECHNICIAN_EXERCISE_2026-10-23.md). The 2010 manufacturer documents explicitly mention **valve-position and pressure-sensor** inputs and five release contacts, but the German original says valve controls while the English translation says contactor controls; their drawings say valve release. Cumulative Safety Design Package **§11L** preserves the translation/variant uncertainty. These are component-document findings, **not** an as-built hydraulic truth table, achieved PL/SIL, physical ram stop/hold proof or maintenance-isolation acceptance. All selected-machine `VAL/PT` remain NOT RUN.


### 2026-10-23T12:49Z Physical witness and maintenance transition exercises

The new [cross-boundary contradiction card](4400_CROSS_BOUNDARY_CONTRADICTION_COMMISSIONING_CARD_2026-10-22.md), [guard-lock semantics versus access release](4400_GUARD_LOCK_SEMANTICS_VS_PHYSICAL_RELEASE_2026-10-22.md), [worked hydraulic SRS/PHY/VAL package](4400_HYDRAULIC_PHYSICAL_WITNESS_WORKED_PACKAGE_2026-10-22.md), [accumulator protective-cycle-to-LOTO transition](4400_ACCUMULATOR_SAFE_CYCLE_TO_MAINTENANCE_TRANSITION_EXERCISE_2026-10-22.md), and [guard/valve/accumulator eight-field composition worksheet](4400_ACCESS_RELEASE_ENERGY_WITNESS_COMPOSITION_WORKSHEET_2026-10-22.md) are now published. Each is a learner-visible documentary exercise with selected-machine `VAL/PT` **NOT RUN**. Keep stop/hold, pressure-zone evidence, inside escape, fresh restart and maintenance isolation independent; no single HMI flag or gauge proves all of them.


### 2026-10-23T12:50Z mode selector, foot-pedal overtravel and fresh restart

Read the [cross-machine mode-selector and restart worksheet](4400_MODE_SELECTOR_RESTART_AUTHORITY_CROSS_MACHINE_WORKSHEET_2026-10-23.md) and [three-position foot-pedal overtravel/restart technician card](4400_THREE_POSITION_PEDAL_RESTART_AND_OVERTRAVEL_TECHNICIAN_CARD_2026-10-23.md). Fiessler FMSC-FP permits selected pedal 1, pedal 2, OR and AND arrangements; OR is not interchangeable with a required two-operator AND function. Pedal overtravel, reset acceptance, final-element action, physical stop/hold and fresh ordinary start are separate claims. These are learner-visible exercises, not a selected machine's validated safety function or blind evaluator score.


### 2026-10-23T12:52Z enabling-device source audit

Read the [manufacturer source comparison of safety-related mode selection, three-position enabling and separate E-stop](../research/4400_SAFE_MODE_SELECTOR_VS_THREE_POSITION_ENABLING_DEVICE_SOURCE_TRACE_2026-10-23.md) alongside the two new pedal/mode worksheets above. Pilz PITenable, Rockwell 440J and Fiessler FMSC-FP are **different products and safety functions**. Ordinary LinuxCNC setup mode cannot certify safe speed, occupancy, physical standstill or an E-stop; no selected-machine validation has occurred.


### 2026-10-23T13:40Z — OSHA interpretation reversal and actual-machine qualification

For **press-brake laser-guard applicability versus machine acceptance**, read the [2003/2004 OSHA interpretation reconciliation](../research/4400_OSHA_2003_2004_PRESS_BRAKE_LASER_GUARD_REVERSAL_AND_PHYSICAL_PROOF_2026-10-23.md). The later interpretation rescinds a categorical prohibition but does **not** certify the device, installed safeguarding, or measured stopping performance. Press brakes are not governed by mechanical-power-press `1910.217` solely because a general press stop-distance eTool describes it.

Before physical commissioning, use the new [selected-machine physical witness intake and release gate](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and cumulative Safety Design Package §11M. Collect ten as-built input artifacts, keep stop/hold/guard access/inside escape/maintenance isolation/fresh restart independent, and withhold physical `VAL/PT` acceptance until independent evidence exists. These are **DOC-CONFIRMED** regulatory source facts and **INFERENCE** generic qualification methods, **not TEST-CONFIRMED** machine performance. No personnel-exposed operation is authorized; 2520–25F0 external evaluations remain OPEN.


### 2026-10-23T13:46Z — Temporary LOTO testing and restoration

The [temporary maintenance-test reenergization technician module](4400_TEMPORARY_REENERGIZATION_LOTO_TESTING_AND_FRESH_RESTART_2026-10-23.md) source-traces OSHA 1910.147(f)(1), (e), (d)(5)–(6), (f)(3) and Appendix A. It separates isolated maintenance, employee clearance, authorized remote/isolated test, **return to personal isolation**, and final production rearm. Safety reset and LinuxCNC Ready are not maintenance energy-control authority. The cumulative package §11N preserves distinct transition/worker/energy witnesses. **No actual test, maintenance release or personnel-exposed operation authorized.**


### 2026-10-23T13:49Z — HAWE general manual versus selected-machine evidence

The exact archived [HAWE B 5488 general manual scope audit](../research/4400_HAWE_B5488_GENERAL_MANUAL_SCOPE_AND_VERIFICATION_2026-10-22.md) is now on `main` (original/post-write Git blob `76f988b239248a959716b5cca9ee37b37dd1cf91`). Manufacturer B 5488 10-2024 rev 3.1 is a **general** manual requiring product-specific and machine-specific instructions; its multi-instrument commissioning discussion and inspection examples do not establish a press brake's physical stop/hold, pressure-zone map, test intervals or safe access. All selected-machine `VAL/PT` remain NOT RUN.


### 2026-10-23T13:51Z — CTP manual release and actual escape

Exact archived [EUCHNER CTP manual-release observability and access-authority audit](../research/4400_CTP_MANUAL_RELEASE_OBSERVABILITY_AND_ACCESS_AUTHORITY_2026-10-22.md) is now published (original/post-write Git blob `cee68b88f26df00f30b41c3d360f5fc5cc72896c`). For the cited CTP-L manual, FO and OL go OFF on documented manual release while OD may be **undefined**; this does not establish physical gate opening, inside egress or machine stop/hold. CTP-I process locking cannot be substituted for personnel-protective CTP-L lock monitoring. Verify exact product, mechanical release under load, independent safe state and restart on the installed machine; `VAL/PT` NOT RUN.


### 2026-10-23T13:52Z — Three-position pedal manufacturer-source audit

The exact archived [Fiessler FE-FS overtravel and FMSC-FP mode/restart source audit](../research/4400_FIESSLER_THREE_POSITION_PEDAL_RELEASE_RESTART_SOURCE_AUDIT_2026-10-23.md) is now on `main` (original/published Git blob `e5a2b9e5b2b51b1dbe06825e3482b8557690b054`). The catalogue's prose conflicts with its safety-contact diagrams; the current official Fiessler product page confirms **overtravel initiates a stop**, not hazardous motion. Selected single/double pedal contact arrangements, FMSC-FP OR/AND selection, restart request and actual fresh-start/physical stop must be validated separately. The documented model-specific pressure point force is not a universal design limit. No selected-machine `VAL/PT`, achieved PL/SIL or operator-protection conclusion.


### 2026-10-23T13:53Z — AKAS device check versus machine acceptance

The exact archived [Fiessler AKAS-5M inspection versus complete-machine safety acceptance study](../research/4400_AKAS_DEVICE_INSPECTION_VS_MACHINE_SAFETY_ACCEPTANCE_2026-10-23.md) is now on `main` (original/published Git blob `18e2955280b38a688b8f04c5a683b0d924e96d68`). Its cited 2024 manufacturer inspection sheet explicitly distinguishes the device's functional inspection from machine-level safety inspection. Tool/muting/box mode, independent speed, final element, physical stop/hold, workpiece hazards and reset require separate `SRS/PHY/VAL/PT` evidence. This is **DOC-CONFIRMED** manufacturer scope, not a passed machine validation.


### 2026-10-23T13:54Z — Pressure-witness counterexamples

The exact archived [HYDAC pressure/gas/gravity witness counterexamples and change-impact study](../research/4400_PRESSURE_WITNESS_LOGICAL_COUNTEREXAMPLES_AND_CHANGE_IMPACT.md) is now published (original/published Git blob `06cd199700d353a9e9f55197873bcfab0e46f558`). A calibrated zero gauge at one SAF S-side tap does not establish isolated P-side pressure, accumulator gas precharge, ram holding or maintenance release. Changes to tap position, isolation valve, gauge plumbing or part suffix invalidate dependent `DEP/PHY/VAL/PT` evidence. This is manufacturer-backed logic, **not** a selected-machine hydraulic truth table or physical test.


### 2026-10-23T14:37Z — AKAS-5M serial diagnostic freshness versus physical safety

Read the [manufacturer-source serial diagnostic investigation](../research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md), then complete the [cross-machine stale-green technician card](4400_SERIAL_DIAGNOSTIC_STALE_GREEN_CROSS_MACHINE_TECHNICIAN_CARD_2026-10-23.md). Fiessler document 1581 (2024-02-15), printed p. 32, documents RS-232 repeated messages, even parity and three-message receiver acceptance; this does **not** establish a host-side maximum data age or safety authority. Separate ordinary HMI transport freshness, safety controller authority, physical stop/hold and maintenance isolation. No physical `VAL/PT`, blind score or compute. External 2520–25F0 gates OPEN.


### 2026-10-23T14:43Z — Overrun text and secondary press-brake hazards

The exact original archived [AKAS-5M 13/11-mm overrun text conflict and non-laser hazards study](../research/4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md) is now on main (Git blob `ff7709e6792192780df099f88443a9bc4c1b45b9`). Fiessler 2024 pp. 5/14 give differing numeric statements; actual selected setting, acceptance quantifier, physical stop and independent sheet-sweep/ejection/foot-control hazards remain open. See cumulative Safety Design Package §11O; no numerical limit is approved by this source release.


### 2026-10-23T14:48Z — Selected overrun setting and monitor freshness

The exact archived [AKAS-5M DIP-selected overrun and automatic-retest source adjudication](../research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md) is now on main (original Git blob `5e0b14b723308ed86ca2090834a248e4d3071d71`). Manufacturer pp. 25–26 tie the test to the selected receiver-support DIP setting and documented periodic retest, but pp. 5/14 quantifier and equality ambiguity remains. Separate selected setting, fresh monitor execution, physical machine stop/hold, and cancellation of setup muting. No physical acceptance.


### 2026-10-23T14:49Z — Accumulator product-family exception and pressure zones

Read the exact archived [HAWE D 7969 versus D 7571 accumulator-family source comparison and pressure-zone witness study](../research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md) (Git blob `b690bcb1d0f11cf6aacae0fa5f23ed060e258e43`). The miniature family has a manufacturer-scoped separate-valve exception; this cannot be generalized to other accumulators, substituted for a selected circuit's pressure-zone map, or used as maintenance isolation/ram restraint. Cumulative Safety Design Package §11P; all physical `VAL/PT` NOT RUN.


### 2026-10-23T14:51Z — Normal access, inside escape and maintenance temporal proof

The exact archived [EUCHNER CTP-L normal-unlock versus inside-escape source study](../research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md) is on main (original Git blob `95070fff954dca5add555bcbd93e8e35ab915edc`). Inside escape physically unlocks and generates an FO OFF stop demand; it does not prove stop completion before opening. Treat normal access, escape and maintenance isolation as distinct physical propositions. Cumulative Safety Design Package §11Q; all selected-machine physical `VAL/PT` NOT RUN.


### 2026-10-23T14:54Z — Qualitative hydraulic energy fault-tree review

The exact archived [three-top-event hydraulic fault tree and common-cause review](../research/4400_HYDRAULIC_ENERGY_FAULT_TREE_QUALITATIVE_2026-10-22.md) is now on main (Git blob `5d1c6cb200af8cb1cbe6ee3864caec60b5c5c8de`). Separate hazardous motion, service pressure release and restart; do not mistake electrical channel count, a valve-position sensor or one pressure tap for independent hydraulic/gravity proof. HAWE SAKB/NSV are manufacturer examples, not an as-built machine truth table. Cumulative Safety Design Package §11R; selected physical `VAL/PT` NOT RUN.


### 2026-10-23T14:57Z — SAKB manifold monitoring versus NSV physical witness

The exact archived [HAWE SAKB S-variant monitored-valve and NSV suffix/pressure-witness source audit](../research/4400_SAKB_MONITORING_COVERAGE_NSV_WITNESS_2026-10-22.md) is on main (Git blob `2864efe988192ed293bfe33d4e56229997f2d65b`). Manufacturer documents five monitored manifold valves, not independent proof of NSV state, ram restraint, isolated pressure or maintenance release. Cumulative Safety Design Package §11S; physical `VAL/PT` NOT RUN.


### 2026-10-23T14:59Z — Diagnostic cascade versus safety outputs

The exact archived [Rockwell GuardLink versus Pilz SDD safety/diagnostic authority comparison](../research/4400_VENDOR_DIAGNOSTIC_CASCADE_GUARDLINK_SDD_BOUNDARY_2026-10-22.md) is on main (Git blob `be62e46bfffa9401274f8f7fdb8c9714487b3c47`). Pilz's product page explicitly marks diagnostic reaction time as not safety-related; the selected safety receiver, outputs, final elements and physical witness must be qualified separately. Cumulative Safety Design Package §11T; physical `VAL/PT` NOT RUN.


### 2026-10-23T15:31Z — Accumulator protective-cycle versus maintenance isolation

The exact original archived [accumulator dual-role source study](../research/4400_ACCUMULATOR_DUAL_ROLE_SAFE_CYCLE_VS_ISOLATION_2026-10-22.md) is now published on main (verified original Git blob `737131a69b48393b3a6118e6052ddabd2b0b26c7`). Follow it with the new [protective-cycle, reaccumulation and independent witness contract](../research/4400_ACCUMULATOR_PROTECTIVE_CYCLE_REACCUMULATION_WITNESS_CONTRACT_2026-10-23.md). Parker describes retained hydraulic energy for a fail-safe cycle as a possible application; OSHA 1910.147(d)(5)–(6) separately requires stored-energy control, verification and continued verification where reaccumulation is possible. Cumulative design package §11U separates protective response, maintenance isolation and fresh restart. No selected-machine physical `VAL/PT` or external safety evaluation has been executed.


### 2026-10-23T15:36Z — Pinned LinuxCNC software reset startup counterexample

The exact archived [LinuxCNC v2.9.10 `estop_latch` first-scan source trace](../research/4400_LINUXCNC_ESTOP_LATCH_FIRST_SCAN_RESET_AUTHORITY_2026-10-22.md) is now on main (original Git blob `06ab264878abdd4920af7ab78707b06767ce9e20`). The component's zero-initialized edge history permits an already-high reset input to count as an initial software edge; it is not a deliberate human safety rearm. Source, generator and simulation HAL example were re-fetched at the pinned upstream tag. Design package §11V preserves independent safety reset, physical stop/hold and fresh ordinary start. No software simulation, physical test or external evaluation was performed.


### 2026-10-23T15:38Z — Lockable energy isolation and anti-bypass retrofit design

Read the exact archived [lockable isolator, tagout equivalence and retrofit maintenance access source audit](../research/4400_LOCKABLE_ISOLATION_TAGOUT_RETROFIT_EVIDENCE_2026-10-22.md) (original Git blob `a902445214ac5adebbcacda1839215adb1ee3379`). OSHA 1910.147 distinguishes actual energy-isolating devices from control-circuit E-stops, and Siemens/Schneider catalog examples distinguish a padlockable operating accessory from a selected installed isolator. Cumulative design package §11W records backfeeds, stored energy, worker-specific lockout and easy-to-use guarded isolation. No selected-machine legal determination or physical `VAL/PT` was performed.


### 2026-10-23T15:41Z — Standstill threshold is not held load

The exact archived [Pilz PNOZ s30 standstill-gated guard release and sensor diagnostics study](../research/4400_SAFE_STANDSTILL_UNLOCK_PNOZ_S30_SENSOR_DIAGNOSTIC_SCOPE_2026-10-22.md) is published (original Git blob `3c0646e98b35b1ef6493ae62b7992420bb3851ad`). The manufacturer manual documents a low-frequency plausibility-check cut-off, broken-select-conductor parameter selection, and different 2 Hz versus 100 Hz basic configuration defaults. These are input frequencies, not machine-specific safe speed, stop distance or proof of hydraulic load holding. Design package §11X records selected sensor coupling and physical witness obligations; no `VAL/PT` performed.


### 2026-10-23T15:43Z — HYDAC fluid-side gauge zero versus trapped energy

The exact archived [HYDAC SAF fluid/gas pressure-zone and zero-gauge source audit](../research/4400_HYDAC_SAF_GAUGE_TOPOLOGY_ZERO_READING_PHYSICAL_WITNESS_2026-10-22.md) is published (Git blob `4e34a51de7cfa6b9929613e60ea48c40e0647b42`). HYDAC's own 2011 precharge check intentionally produces a fluid-side gauge reading of zero while gas precharge remains; current catalog part 2205492 has inconsistent generic solenoid/manual fields. The selected machine's S/P/T/gas/actuator/ram topology must be independently witnessed; §11Y and the selected physical intake remain HOLD/NOT RUN.


### 2026-10-23T15:44Z — EUCHNER process-lock versus safety-lock output semantics

The exact archived [CTP-I1 versus CTP-L1 manufacturer switching-state comparison](../research/4400_EUCHNER_CTP_I1_L1_MANUAL_OUTPUT_SEMANTICS_2026-10-22.md) is published (original Git blob `3f2ecca5498833e2a6df005c16eb172feb168d8c`). EUCHNER's official tables show FO1A/FO1B **ON** for CTP-I closed/unlocked but **OFF** for CTP-L closed/unlocked; equal-looking outputs do not monitor the same physical proposition. Design package §11Z preserves change-control invalidation, physical stop/hold, escape and independent rearm requirements. No machine-specific receiver/guard compatibility or physical `VAL/PT` has been proven.
