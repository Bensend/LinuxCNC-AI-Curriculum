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


For **guard-lock power-loss polarity, inside escape and variant-specific rearm**, read [the 2026-10-23 SICK/EUCHNER/Pilz source matrix](../research/4400_GUARD_POWER_LOSS_ESCAPE_AND_REARM_VARIANT_SOURCE_MATRIX_2026-10-23.md) and complete [the technician field card](4400_GUARD_POWER_LOSS_ESCAPE_RESTART_TECHNICIAN_FIELD_CARD_2026-10-23.md). The matrix treats early access, trapped-person egress and unexpected restart as **three different** failure propositions. The selected exact device's spring/solenoid principle and reset behavior must be verified; no product's local output substitutes for physical stop/hold/escape/energy evidence. These are new original learner artifacts, **not** releases from the historical 85-file archive; all selected-machine physical tests remain NOT RUN.


For **AKAS-5M box-bending/muting**, use [the source-grounded replacement-protection contract](4400_AKAS_MUTING_LOSS_OF_COVERAGE_MINIMUM_FUNCTION_CONTRACT_2026-10-23.md). The Fiessler 2024 manual warns that formerly active laser elements become muted, that fingers can escape detection beside a large die, and that independent slow-motion/position evidence is required for its described integration. The worksheet requires an explicit alternative protective proposition for each exposed zone; `SGA` or LinuxCNC commanded speed is not physical safe-speed proof. Product-specific settings are not universal, all machine `VAL/PT` NOT RUN. This is new original curriculum material, not an exact release from the historical archive.


For **whole-body access, multi-person personnel keys and the boundary with maintenance lockout**, read [the original Fortress/Rockwell/EUCHNER/OSHA source audit](../research/4400_PERSONNEL_KEY_WHOLE_BODY_ACCESS_VS_LOTO_SOURCE_AUDIT_2026-10-23.md) and complete [the open-book two-worker technician challenge](4400_PERSONNEL_KEY_MULTIPERSON_ENTRY_LOTO_ADVERSARIAL_FIELD_CARD_2026-10-23.md). An in-hand key can inhibit a selected interlock's reset path; it cannot count all people, prove stopped motion, release a trapped worker or establish OSHA energy isolation. Keep a selected worker's personal LOTO protection separate from a production access key, and verify all physical `PHY` propositions independently. **No selected-machine test or external evaluation was performed.**


**Exact coded-key qualification trap:** The EUCHNER CKS-A-L1B-SC 2019 manual restricts lockout-*mechanism* use to **unicode** CES evaluation; the current product page explicitly prohibits that role with **multicode** evaluation. Read [the exact-evaluator source gate](../research/4400_EUCHNER_CKS_UNICODE_MULTICODE_PERSONNEL_KEY_GATE_2026-10-23.md) before using a generic CKS family PL claim. The manufacturer term is not proof of OSHA maintenance energy isolation. The whole-body entry field card includes the new substitution challenge; no selected-machine validation.


For the **keyed-control versus physical-isolator distinction**, read [Rockwell's exact 440T rotary product/installation source comparison](../research/4400_ROCKWELL_440T_ROTARY_PHYSICAL_ISOLATOR_VS_CONTROL_KEY_2026-10-23.md). Some keyed rotary devices directly interrupt selected electrical conductors; a CKS/CES key reader changes safety outputs. Neither device's label proves the as-built power path, all stored energy, group-worker maintenance LOTO or physical stop/hold. The exact 440T-MRPSE110F is 20 A in the inspected cut sheet, not the family's maximum 100 A. No selected-machine energy map or physical validation exists.


For **guard key release after stopping**, read [the exact Rockwell 440T ETU versus SMU/CU2 source comparison](../research/4400_TRAPPED_KEY_TIMED_RELEASE_VS_SENSED_STOP_MOTION_2026-10-23.md). A timer measures elapsed time; a stopped-motion detector observes its selected shaft/sensor and may add a delay. Neither proves all axes, downstream load holding or hydraulic gravity restraint without a selected-machine physical witness. The ordinary LinuxCNC stop command and HMI “key free” indicator are not release authority.


For **stopped-motion guard release under sensor/coupling faults**, read [the CU2/440T, Pilz PNOZ s30 and Schmersal FWS product-scope comparison](../research/4400_STOP_MOTION_SENSOR_COVERAGE_FAULT_AND_COUPLING_SOURCE_AUDIT_2026-10-23.md), then work through [the false-standstill technician field card](4400_STOP_MOTION_FALSE_STANDSTILL_TECHNICIAN_DIAGNOSTIC_FIELD_CARD_2026-10-23.md). Rockwell's historical CU2 document does **not** establish an exact both-sensors-lost fault truth table; Pilz explicitly identifies encoder slippage/broken shear pins and a configurable low-frequency plausibility-check cut-off. More sensors on the same disconnected shaft do not prove the hazardous load stopped. These are new original source/teaching artifacts, **not** exact historical ZIP releases or physical tests. No selected-machine `VAL/PT`, release authority, or external blind score.


For **standstill-monitor automatic output reenable versus fresh machine restart**, read [the exact Pilz PNOZ s30 start-mode, reset and device-version source trace](../research/4400_PNOZ_S30_AUTOMATIC_OUTPUT_REENABLE_VS_FRESH_MACHINE_RESTART_2026-10-23.md). The current manufacturer manual explicitly warns that automatic start can reenable outputs after a safeguard resets and calls for external prevention of unexpected restart. The basic proximity/encoder configurations use automatic output start, while monitored-edge selection is configurable per output. Neither option is a complete machine-level fresh-start or physical stop/hold proof. This is original documentary research, not an exact archive release or physical validation.

For **brake-feedback faults on gravity-loaded axes versus hydraulic load holding and controlled lowering**, read [the Rockwell SBC / Siemens SBT / Parker HAS manufacturer-source audit](../research/4400_BRAKE_FAULT_TORQUE_RETENTION_AND_HYDRAULIC_LOAD_CONTROL_SCOPE_2026-10-23.md) and complete [the open-book technician scenarios](4400_BRAKE_FAULT_GRAVITY_HOLD_AND_LOAD_LOWERING_TECHNICIAN_CARD_2026-10-23.md). Rockwell's SBC fault example conditionally retains drive torque rather than asserting TOR before brake confirmation, but its TOR **retains its prior state**, not always OFF. Siemens SBT deliberately commands torque against a brake and is unavailable for HLA in the inspected 2018 manual; Parker's HAS pilot-to-open check is not a controlled lowering valve in that application. Neither a brake-feedback bit nor a hydraulic valve catalog claim proves physical restraint. New original documentary research only, **not** one of the six outstanding historical ZIP releases or a machine physical test.

For **hydraulic load-hold manual override and false port-to-chamber assumptions**, read [the Parker HAS exact order-code/orientation source audit](../research/4400_PARKER_HAS_LOAD_HOLD_OVERRIDE_CODE_AND_MANIFOLD_ORIENTATION_2026-10-23.md). The manufacturer documents a “no load holding” option that still contains an R-coded PO check with its manual override engaged, plus orientation-dependent a/b push/pull mapping. Physical presence of a valve and a green HMI bit therefore do not establish active load holding or a valid pressure-zone witness. This is a scoped original manufacturer investigation, not a selected-machine test or historical ZIP release.

For **counterbalance pilot pressure, thermal relief, trapped hydraulic energy and hydraulic motor braking**, read [the Sun/Parker manufacturer-source audit](../research/4400_COUNTERBALANCE_PILOT_THERMAL_RELIEF_AND_MOTOR_BRAKE_BOUNDARY_2026-10-23.md) and complete [the seven-scenario technician card](4400_PILOT_THERMAL_RELIEF_AND_MOTOR_BRAKE_TECHNICIAN_CARD_2026-10-23.md). A powered-off pump does not prove pilot pressure has vanished, and a cylinder load-hold example must not be transferred to a hydraulic motor without a separate brake/physical witness. These are new documentary teaching materials, **not** exact historical archive releases or machine validation.

**Follow-on brake sequencing caution:** Parker's illustrative hydraulic-motor example permits a load-dependent counterbalance to open before the mechanical brake releases; its equal-area variant avoids that example's race but lacks built-in thermal relief. The linked source audit and technician card now include this eighth scenario. Do not generalize either valve's behavior or copy catalog pressure values into a machine.

For a **manufacturer-manual scope trap**, read [the Parker TDP/TEP versus D3DW pilot/fail-safe source audit](../research/4400_PARKER_TDP_TEP_FAILSAFE_PILOT_AND_D3DW_MANUAL_SCOPE_TRAP_2026-10-23.md) and answer scenario 9 in the [pilot/thermal-relief technician card](4400_PILOT_THERMAL_RELIEF_AND_MOTOR_BRAKE_TECHNICIAN_CARD_2026-10-23.md). The combined manual's D3DW spring-return paragraph cannot establish TDP's physical power-loss safe state. The supplier's “fail safe” label is not a selected-machine safety function, nor is a TEP monitored shut-off bit independent proof of a restrained load.


### 4400 OSHA press-brake applicability and service-zone transfer (2026-10-23)

Use the [official-source applicability reconciliation](../research/4400_PRESS_BRAKE_OSHA_SCOPE_SAFE_DISTANCE_AND_MAINTENANCE_TRANSFER_AUDIT_2026-10-23.md) and [technician field card](4400_PRESS_BRAKE_GUARDING_SCOPE_AND_SERVICE_ZONE_FIELD_CARD_2026-10-23.md) to distinguish the 1910.217 press-brake exclusion from 1910.212 guarding, dated OSHA safe-distance exceptions from protective-device placement, and production stopping from 1910.147 maintenance energy isolation. Do **not** use a historical four- or six-inch figure as a universal design acceptance criterion. Selected-machine physical proof remains UNKNOWN/NOT RUN.


### 4400 OEM press-brake maintenance and rescue transfer (2026-10-23)

Read the [Cincinnati PROFORM+ ram support / LOTO / power-loss rescue / manual-reference audit](../research/4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md), then work the [ram support, isolation and rescue technician card](4400_RAM_SUPPORT_LOTO_AND_POWER_LOSS_RESCUE_TECHNICIAN_CARD_2026-10-23.md). The official 2014 Cincinnati manual provides a concrete example of ram support, isolated energy and no-power rescue but contains conflicting figure item references. The 2026 Haas public manual provides a differently scoped comparison. **Neither OEM's settings or POWER OFF instruction transfers to an unverified OpenPressBrake.** All physical `VAL/PT` remain NOT RUN; no person-exposed operation authorized.


For **manufacturer-confirmed option-dependent protection and auxiliary-energy scope**, read the [Cincinnati PROFORM+ guard mute / programmable footswitch / ADI default plug / hydraulic option audit](../research/4400_PROFORM_OPTIONAL_MUTING_ADI_PLUG_FOOTSWITCH_AND_HYDRAULIC_ADDON_AUDIT_2026-10-23.md) and cases 13–17 in the [technician card](4400_RAM_SUPPORT_LOTO_AND_POWER_LOSS_RESCUE_TECHNICIAN_CARD_2026-10-23.md). A documented removable plug is **not** proof of bypass or safety equivalence without pinout; guard mute does remove the described AOPD protection. Optional rear guarding and auxiliary hydraulic cylinders must be confirmed on the actual machine. All physical `VAL/PT` NOT RUN.


For a **second independent commercial press-brake safety architecture**, study the [TRUMPF TruBend B35 2023 guard-state, BendGuard mute, backgauge STO, remote service and disassembly source audit](../research/4400_TRUMPF_B35_SIDE_DOOR_ASYMMETRY_MUTE_REMOTE_SUPPORT_AND_DISASSEMBLY_AUDIT_2026-10-23.md) and [eight-case technician exercise](4400_TRUMPF_B35_ACCESS_REMOTE_DIAGNOSTIC_AND_DISASSEMBLY_FIELD_CARD_2026-10-23.md). Different side/rear guard reactions and an inactive optic below mute do not establish a selected OpenPressBrake circuit. The manufacturer explicitly warns about unbraked moving assemblies after power separation and beam fall when hydraulic components are removed first. Remote UI access is **not** personnel-safety or motion authority. No physical tests performed.


For **remote diagnostics and a future web HMI without remote personnel-safety authority**, use the [4400 remote-support / web-UI authority contract](4400_REMOTE_SUPPORT_WEB_UI_AUTHORITY_AND_INDEPENDENT_SAFETY_CONTRACT_2026-10-23.md). It cites NIST SP 800-82r3 (2023 final) and TRUMPF B35's OEM remote-service warning, and proposes a deliberately small R&D design: local safety reset and deliberate start, remote diagnostics read-only by default, staged settings, visible bounded sessions, and independent physical safety even when offline. `REM-01..08` are paper-only and NOT RUN.


### 4400 pinned LinuxCNC 2.9.10 remote-command source trace (2026-10-23)

Study the [v2.9.10 `linuxcncrsh` socket/enable/ESTOP/MDI/RUN/stale-status source audit](../research/4400_LINUXCNCRSH_2910_REMOTE_COMMAND_AUTHORITY_AND_STALE_STATUS_SOURCE_TRACE_2026-10-23.md) and [eight-case open-book technician card](4400_LINUXCNCRSH_REMOTE_COMMAND_STALE_STATE_AND_REARM_FIELD_CARD_2026-10-23.md). The pinned Git blob establishes that a normal network UI can request software E-stop reset and motion, `GET` may read stale Task status, and a TCP disconnect does not by itself prove a protective stop. The session password, software enable gate and command ACK are **not** independent personnel-safety authority or physical stopping/holding evidence. Proposed read-only exporter is INFERENCE; `NET-01..08 NOT RUN`; selected `PHY/VAL/PT` UNKNOWN/NOT RUN.


### 4400 ISO 13855:2024 stop-time, protective distance and excluded-hazard boundary (2026-10-24)

Read the [publisher-scope/2024-edition and manufacturer stop-time source audit](../research/4400_ISO13855_2024_SEPARATION_DISTANCE_SCOPE_STOP_TIME_AND_GRAVITY_EXCEPTION_2026-10-24.md) and work the [ten-scenario technician card](4400_STOP_TIME_PROTECTIVE_DISTANCE_AND_GRAVITY_SCOPE_FIELD_CARD_2026-10-24.md). A measured stop and approach-distance calculation are not proof against gravity fall, mechanical breakage, emissions, hidden occupants or stored hydraulic energy. The 2024 standard covers single foot-operated control positioning but does not make a foot pedal a two-hand safeguard. The SICK 2021 ANSI example and Pilz ten-run service practice are not claimed as universal ISO 2024 normative criteria. `SD-CASE` physical witnesses NOT RUN; selected-machine acceptance UNKNOWN.


For a **manufacturer stop-time purpose/outlier trap**, study the [Rockford SSC3000 2025 downstroke distance versus upstroke brake-monitor source audit](../research/4400_SSC3000_DOWNSTROKE_DISTANCE_VS_UPSTROKE_BRAKE_MONITOR_SOURCE_TRAP_2026-10-24.md) and [six-case technician exercise](4400_STOP_TIME_OUTLIER_AND_BRAKE_MONITOR_SCOPE_TECHNICIAN_CARD_2026-10-24.md). The OEM's upstroke threshold-setting discussion of high readings is not a general license to discard a credible long stop from protective-distance evidence. Mechanical clutch/brake crank-angle settings and OSHA 1910.217 must not be transferred to hydraulic press brakes. No machine tests or numerical acceptance criteria.


### 4400 Bosch Rexroth valve-feedback, die-cushion leakage and replacement scope (2026-10-24)

Read the [RE 63124-B general IH04 versus RE 63129-MON IH04E die-cushion source audit](../research/4400_BOSCH_IH04_VALVE_FEEDBACK_LEAKAGE_REPLACEMENT_SCOPE_AUDIT_2026-10-24.md), then the [ten-case technician card](4400_HYDRAULIC_VALVE_FEEDBACK_LEAKAGE_SCOPE_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** manufacturer instructions reject using ordinary analog valve actual-value signals for safety shutdown, explicitly note pressure may remain in OFF, require reaction-time rechecks after safety-valve replacement, and identify cylinder/valve/manifold leakage invisible to valve limit switches. General IH04 5 mm/s and IH04E die-cushion 1/5 mm/s references describe **different test conditions and machine parts**; neither is an OpenPressBrake Y1/Y2 criterion. `IH-01..12` source audit, paper-only `HF-01..10`; selected `IN/PHY/VAL/PT UNKNOWN/NOT RUN`. ISO 6909:2026 public scope does not provide uninspected numerical requirements.


### 4400 HAWE ePRAX 2026 OEM press-brake safety architecture (2026-10-24)

Use the [manufacturer-hosted HAWE B 6340 source trace](../research/4400_HAWE_EPRAX_2026_GRAVITY_VALVE_ACCUMULATOR_SAFETY_SOURCE_TRACE_2026-10-24.md) and [ten-case field exercise](4400_HAWE_EPRAX_GRAVITY_VALVE_STORED_ENERGY_TECHNICIAN_CARD_2026-10-24.md). This is a **real press-brake** hydraulic servo architecture, unlike the earlier IH04E die-cushion example. **DOC-CONFIRMED**: separate ordinary per-axis drive control and safety-related valve/linear-scale monitoring; gravity-assisted FAST DOWN; potential uncontrolled acceleration if drive speed control is inactive; optional Slow Up accumulator energy; machine-builder responsibility for safety controller and final validation. OEM orifice sizes and thresholds are conditional and **not** OpenPressBrake acceptance criteria. `HW-01..14` source ledger, `HW-F01..10` paper-only, selected `IN/PHY/VAL/PT UNKNOWN/NOT RUN`.


**HAWE variant check:** the same source audit now reconciles newer [HAWE D 6340 07-2026 product documentation](https://productfinder.hawe.com/downloads/D6340-en.pdf): `S` cylinder-module code supplies valve-position monitoring, **no code** does not; Slow Up `X` is absent, `A/B` are optional accumulator variants. Identify **both** actual Y1/Y2 order codes before crediting feedback or stored-energy assumptions. Additional `HW-F11..13` paper traps.


### 4400 HAWE SAKB/NSV seal suffix and A/B port reversal (2026-10-24)

Read the [D 6335 / D 6368 original OEM source audit](../research/4400_HAWE_SAKB_NSV_SEAL_SUFFIX_PORT_REVERSAL_SOURCE_AUDIT_2026-10-24.md) and [ten-case technician card](4400_HAWE_SAKB_NSV_SUFFIX_PORT_REVERSAL_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED:** SAKB `S` monitors five specified central-block valves, not automatically the two separate NSVs; NSV `L` means **without seal / with leakage flow**; NSV `050` versus `060` reverses A/B pressure/suction assignment; NSV is normally open and requires pilot pressure to close, unlike the different ePRAX integrated normally-closed family. Never infer ram holding, port pressure zone or safe state from a name, letter, HMI bit or generic diagram. `NS-01..10`, `NS-F01..10` paper-only, selected `IN/PHY/VAL/PT UNKNOWN/NOT RUN`.


### 4400-HY-01 — hydraulic press-brake safety source-to-architecture lesson (2026-10-24)

The [complete 4000-level teaching module](4400_HY_01_HYDRAULIC_PRESS_BRAKE_SAFETY_ARCHITECTURE_TRANSFER_MODULE_2026-10-24.md) synthesizes the Bosch IH04/IH04E, HAWE ePRAX, and HAWE SAKB/NSV source audits into a practical hazard/energy/control/physical-witness curriculum. Includes manufacturer-edition matrix, `BND/ENE/PHY/AUTH/DEP` reasoning, three paper learning activities, human-factors redesign, failure paths, adversarial questions, and **predeclared OPEN** prediction/handoff gates. **SOURCE-READING / NOT GRADUATED**; no blind score, physical machine test or safety release.


**4400-HY-01 fresh handoff prepared:** [independent, novel two-concept source-transfer assignment](../evaluation/4400_HY_01_FRESH_HANDOFF_CONTRACT_2026-10-24.md). No solution key or score included; **NOT RUN / NOT GRADUATED**. This does not alter 2520–25F0 external gates.


### 4400 relay reset-edge and power-restoration scope — Rockwell MSR142RTP (2026-10-24)

Read the [original Rockwell 440R-IN089A-EN-P reset-edge, power-up and Y1–Y2 feedback audit](../research/4400_MSR142_RESET_EDGE_POWERUP_FEEDBACK_WIRING_SOURCE_AUDIT_2026-10-24.md) and complete the [ten-case technician field card](4400_RESET_EDGE_POWER_RESTORATION_AND_FEEDBACK_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED:** T-mode reset is **not edge-monitored** and can reenable on power-up with closed inputs; R-mode requires a transition; negative-edge 440R-xxxxxM resets on release. Y1–Y2 actuator feedback and cross-loop monitoring depend on actual installed wiring and **do not** prove a hydraulic load is held. Separate safety reset, fresh production START, physical stop/hold and maintenance isolation. `RE-01..10 PAPER ONLY`, `IN/PHY UNKNOWN`, `VAL/PT NOT RUN`; no selected-machine safety release, test, compute or blind score.


### 4400 hydraulic injection injury and hose-pressure service-zone safety (2026-10-24)

Study the [Parker 4400-B.1 / HSE FOD 4-2014 / Enerpac original-source audit](../research/4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md) and complete the [eight-case pinhole and trapped-pressure technician card](4400_HYDRAULIC_PINHOLE_LEAK_AND_PRESSURE_ZONE_TECHNICIAN_CARD_2026-10-24.md). A barely visible hose jet can cause injection injury; pump-off, a zero gauge in another zone, or a supported ram do not establish safe hose pressure. Never search for leaks by touch, loosen a fitting as an improvised pressure test, patch a failed hose, or force a coupler check ball. Suspected injection injury needs **immediate emergency medical assessment**. Make correct zone-specific isolation/test-point access easier than the shortcut. `PI-01..08 PAPER ONLY`, selected hose/port identity UNKNOWN, `VAL/PT NOT RUN`, no personnel-exposed release.


### 4400 pneumatic safe-exhaust / connector-variant / trapped-air boundary (2026-10-24)

Read the [Festo MS6-SV-E/D and ROSS DM1/DM2 Series C source-scope audit](../research/4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) and complete the [ten-case paper technician card](4400_PNEUMATIC_EXHAUST_TRAPPED_AIR_AND_RESET_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** Festo 2023/05 warns that downstream components and silencers must not impair exhausting, explicitly excludes its MS6-SV-D/E as press safety valves, and allocates different cross-circuit monitoring for NECA MP3 versus MP5. ROSS manufacturer pages distinguish DM1 auto fault reset from DM2 latched fault reset and exclude Series C from press clutch/brake service. **INFERENCE** that check-isolated chambers, gravity/spring loads, vacuum and blocked exhaust can defeat a generic machine-level 'air off = safe' claim. Actual selected pneumatic components, pressure zones and physical witnesses **UNKNOWN**; `VAL/PT NOT RUN`, no external score, no personnel-exposed release. This is original 4400 documentary work, not recovery of the six historical archive files.


**Vertical pneumatic axis counterexample:** [Festo manufacturer page 49/52/56 source reconciliation](../research/4400_VERTICAL_PNEUMATIC_HOLD_VS_EXHAUST_FESTO_SOURCE_RECONCILIATION_2026-10-24.md) demonstrates that some qualified vertical-axis stopping/holding concepts **retain compressed air intentionally** and require standstill-before-clamp, while Festo explicitly warns that a clamping/end lock alone is not a complete safety solution. **DOC-CONFIRMED for those exact OEM examples**, not selected OpenPressBrake hardware. Separate protective stop/hold from maintenance isolation and gravity restraint; all selected physical witnesses UNKNOWN/NOT RUN.

**Prerequisite distinction:** 2580's existing [fluid-power fault-tree and pneumatic analogue](2580_FLUID_POWER_FAULT_TREE_AND_PNEUMATIC_ANALOGUE_2026-09-23.md) already teaches the generic energy propositions and is READY FOR EXTERNAL/FRESH EVALUATION. These 4400 Festo/ROSS investigations add **manufacturer-specific application and diagnostic allocation evidence**, not a duplicate 2580 module or an external score.


### 4400 hose-burst velocity-fuse flow-window and hazardous test transfer (2026-10-24)

Read the [HYDAC RB / HIDROS VUBA / Winner HB-18A original manufacturer source audit](../research/4400_HOSE_BURST_VELOCITY_FUSE_FLOW_WINDOW_AND_UNSAFE_TEST_TRANSFER_AUDIT_2026-10-24.md) and [ten-case paper technician exercise](4400_HOSE_BURST_FUSE_LOW_FLOW_AND_HAZARDOUS_TEST_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED:** HYDAC RB closes on selected excess 2→1 flow, needs normal/fault flow separation, warns against repeated cycling and discloses pressure-dependent leakage; HIDROS VUBA explicitly is not a continuous load-holding valve; Winner has different selection/tolerance guidance. **INFERENCE:** partial leak, minimum load, wrong location, bypass or normal transient may defeat a claimed fuse safety proposition. The manufacturer describes a hazardous line-opening rupture test; **not authorized** as a curriculum lab. Selected OpenPressBrake installation, trip window, protected segments, stop/hold and hose-injection physical witnesses **UNKNOWN**; `VAL/PT NOT RUN`, no exposed hazardous operation, no external score or compute. This is original research, not historical archive recovery.


**Critical same-manufacturer correction:** [HYDAC part 710028 opposite-port-direction original source audit](../research/4400_HYDAC_RBE_710028_OPPOSITE_PORT_DIRECTION_OEM_CONFLICT_2026-10-24.md) finds **US HYDAC 710028 catalogue: 2→1 closes** versus **HYDAC International EN 5.174.14/10.21 pp. 1–2, same part 710028: 1→2 closes**. Both are **DOC-CONFIRMED document claims**, actual physical closing direction **UNKNOWN**. Do not install, replace or qualify a fuse based on either unchecked arrow; obtain manufacturer written reconciliation and exact installed port/consumer map. `HB-11` in the technician card tests this. No physical test or operation authorized.


### 4400 workpiece whip-up and powered sheet-follower safety boundary (2026-10-24)

Read the [Oregon OSHA/AMADA/Fab Supply/ENUTRON/SHENCHONG original-source investigation](../research/4400_PRESS_BRAKE_SHEET_WHIP_UP_AND_INDEPENDENT_FOLLOWER_SAFETY_BOUNDARY_2026-10-24.md) and complete the [15-case sheet-follower/part-trajectory technician card](4400_SHEET_FOLLOWER_WORKPIECE_WHIP_UP_AND_STOP_COVERAGE_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** Oregon OSHA p.33 shows sheet-to-slide pinch and upward strike beyond the simple die-gap model; AMADA describes optional sheet followers reducing handling/whip-up risk; Fab Supply and ENUTRON describe independently operated or portable follower systems; SHENCHONG 2022 documents a follower-local magnetic scale, PLC learn mode and E-stop. **UNKNOWN:** actual selected follower existence, reciprocal press/follower stop integration, safe hold, geometry and restart. A stopped ram or healthy laser does not establish safe workpiece trajectory. Vendor energized calibration directions are not student labs. Conditional `IN-04e` added; `WF-01..15 PAPER ONLY`, `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED, no fresh external score or personnel-exposed release. New original 4400 work, not historical archive recovery.


### 4400 press-brake tool anti-drop versus bending clamp and die-fragment protection (2026-10-24)

Read the [WILA Safety-Click / Mate Maglock / AMADA original manufacturer comparison](../research/4400_PRESS_BRAKE_TOOL_RETENTION_MAGLOCK_SAFETY_CLICK_AND_CLAMP_AUTHORITY_2026-10-24.md) and [12-case paper technician card](4400_PRESS_BRAKE_TOOL_RETENTION_VS_CLAMPING_AND_FRAGMENT_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** WILA's product-specific Safety-Click tool weight suitability **up to 12.5 kg**, Mate's explicit **Maglock is not a holder clamp** warning, and AMADA's separate die-fragment fly-off mitigation. Temporary retention, process-force clamping, die-fragment containment, ram load holding and maintenance energy isolation remain **different physical propositions**. Exact installed tool/holder/adapter identity, condition and witnesses **UNKNOWN**. Conditional selected `IN-04f`, `TR-01..12 PAPER ONLY`, `VAL/PT NOT RUN`; no machine test, numerical safety transfer, external score or exposed-operation release. New original documentary work, not historical archive restoration.

### 4400 scanner-to-safety-controller EFI restart and rear-access boundary (2026-10-24)

Read the [SICK S300 2025 OEM EFI restart signal-selection source audit](../research/4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md), work the [16-case rear-zone technician card](4400_S300_EFI_SIGNAL_SELECTION_RESTART_AND_REAR_ACCESS_TECHNICIAN_CARD_2026-10-24.md), and complete the [rear-access/safety-PLC interface review worksheet](4400_REAR_ACCESS_AND_EFI_RESTART_SAFETY_INTERFACE_REVIEW_WORKSHEET_2026-10-24.md). **DOC-CONFIRMED SICK 8010948/ZD76/2025-08-19 §7.10:** S300 internal restart interlock affects Flexi Soft when the controller consumes **OSSD status**; it does **not** affect Flexi Soft when it consumes raw **protective-field status**; in that latter integration, the interlock must be implemented in Flexi Soft. SICK also warns that a person behind an access protective field is not detected, scanner mounting can create blind areas, universal I/O is non-safe, and field-set switching timing matters. **INFERENCE:** a rear-zone retrofit can silently lose restart prevention when a safety-PLC variable is changed; **UNKNOWN** whether S300/Flexi Soft is installed on OpenPressBrake. Conditional selected-machine `IN-04g`, `EF-01..16 PAPER ONLY`, no scanner numerical rating or machine test, `VAL/PT NOT RUN`, no exposed hazardous operation.
