# 4400 — SICK FX3-XTIO: disabling a test pulse can weaken every output on the module

**Status:** manufacturer-source research (2026-10-24), **DOC-CONFIRMED for the stated SICK hardware/firmware scope**, no actual OpenPressBrake installation or `TEST-CONFIRMED` evidence. This is a separate discovery from the [lost-0 V/common-return audit](4400_SICK_FLEXISOFT_LOST_0V_REVERSE_CURRENT_COMMON_CAUSE_SOURCE_AUDIT_2026-10-24.md).

## Original source and revision warning

SICK *Flexi Soft Modular Safety Controller — Hardware*, original manufacturer PDF https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf , web-extracted edition footer **8012478/1WLY/2026-05-05**, §§4.4.6.2–4.4.6.4, printed pp.26–28; §13.3 XTIO output technical table, printed pp.141–142. The public PDF URL is not immutable; page-render services surfaced older footers. Verify the actual downloaded PDF edition/checksum before design transfer.

## Source-confirmed distinctions

1. **Test pulse deactivation is not a local convenience switch.** FX3-XTIO Step ≥2.xx / firmware ≥V2.00.0 permits deactivation of Q1–Q4 output test pulses. SICK explicitly says disabling pulses on **one or more** outputs reduces safety parameters of **all Q1–Q4 outputs of that module**. With pulses disabled, a cross-circuit to 24 V cannot be recognized while the output is high. Under an internal hardware fault, 24 V reverse current through a pulse-disabled output can impair other outputs' switch-off capability. This is **DOC-CONFIRMED OEM warning**, not proof of a fault on any machine.
2. **The manufacturer adds compensating conditions.** For disabled output test pulses, SICK calls for protected/separate cabling and at least annual simultaneous shutdown of all pulse-disabled outputs for ≥1 s **or** a power-cycle restart of the Flexi Soft system. This is an OEM product-specific maintenance requirement; it is **not** a license to power-cycle an unsafe machine or a general annual proof-test interval for all safety equipment.
3. **Higher-capacitance support changes fault detection.** FX3-XTIO Step ≥3.xx / firmware ≥V3.00.0 permits extended cross-circuit detection for higher capacitive loads. SICK's Table 5 gives the maximum time to reach LOW (≤3.5 V) after an output is deactivated: older ≤V2.11.0: **3 ms**; newer ≥V3.00.0 with extension disabled: **3 ms**; extension enabled: **43 ms**. These are **configuration-dependent output-level diagnostic criteria**, **not** physical machine stopping times or universal permissible guard response delays.
4. **Brief unintended HIGH is explicitly possible under internal fault.** In §4.4.6.4 SICK warns that single-channel Q outputs normally low may briefly go high or switch off late until an internal hardware fault is recognized. Table 6 states fault detection plus reaction ≤**10 ms** for the old/nonextended cases, versus ≤**50 ms** for V3 with higher-capacitance detection enabled. These are **OEM fault response limits**, not a guarantee that an actuator or machine is safe throughout that interval.
5. **PLC-output-card power switching is conditional.** When a safety Q output switches the supply of a PLC output card, the OEM warns that output-card faults, capacitive buffering, or cross-circuits can impair safety-related switch-off. The card must be suitable for safety-related deactivation by supply switching; protect wiring and account for capacitor discharge. **Never** replace this with a generic FPGA-board supply-switch assumption.
6. **Inductive suppressor details matter.** XTIO output technical data warn against some RC elements parallel to inductive loads because post-induction overshoot may trigger cross-circuit errors; the OEM gives firmware-specific overshoot allowances. The actual selected suppressor, load energy, receiver and physical stop time must be reviewed.

## Why this matters to the LinuxCNC/OpenPressBrake retrofit

A builder might disable safety-output test pulses to prevent nuisance trips after adding a large capacitive PLC/FPGA input or a new contactor suppressor. The normal LinuxCNC screen may become quieter, yet the OEM warns that **other safety outputs on the same module** can lose fault-detection capability. This is a **common-cause safety architecture change**, not merely a diagnostic tuning adjustment.

Separate chains:

`guard/E-stop → safety sensor/input → configured safety PLC Q + pulse/error detection → selected qualified receiver/final element → independent physical stop/hold`

`LinuxCNC/FPGA → ordinary motion, HMI, diagnostics, optional ordinary stop request`

`lockable isolator + residual energy control + mechanical restraint → qualified maintenance entry`

Never grant ordinary LinuxCNC or the generic FPGA personnel-safety authority. The source does **not** establish that any SICK FX3-XTIO is present on OpenPressBrake.

## Eight paper adversarial scenarios (not a test suite)

| ID | Change or claim | Correct engineering question |
|---|---|---|
| TP-01 | Q1 test pulse disabled to stop nuisance trips; Q2–Q4 untouched. | Does the **entire module's** safety parameter claim change, per OEM? |
| TP-02 | An installer assumes 43 ms is the maximum press-brake stopping time. | Which *output LOW threshold/diagnostic* is 43 ms actually about? |
| TP-03 | A single-channel output is normally low; a fault transient briefly makes it high. | What physical actuator might react, and what independent safeguard contains that hazard? |
| TP-04 | Safety Q supplies an ordinary FPGA/PLC output board with bulk capacitance. | Is that board **qualified** for safety-related supply disconnection and verified discharge? |
| TP-05 | One protected cable is shared by multiple pulse-disabled outputs. | Does OEM protected/separate cabling and cross-circuit exclusion actually hold? |
| TP-06 | A technician schedules the OEM annual simultaneous output-off condition during production with people near the ram. | Why is this not an authorized live hazardous experiment or substitute for safe maintenance? |
| TP-07 | Firmware is upgraded from V2 to V3 and extended detection enabled. | Which `CHG/DEP/ARC/VAL/PT` evidence becomes stale and why? |
| TP-08 | A coil suppressor is changed to an RC element and cross-circuit errors appear. | Check OEM overshoot/coil data and final-element physical dropout; do not merely suppress diagnostics. |

## Low-friction design and evidence contract

Inventory each output's module, hardware Step, firmware, test-pulse enabled state, output load/capacitance, conductor route, fault-detection configuration, suppression device, receiver and final element. Keep a one-page `SAFETY-OUTPUT-CONFIG` label near the cabinet drawings. Make the compatible receiver/wiring and correct pulse settings the default; **do not** solve nuisance trips by hiding diagnostics. Preserve protected/separate cables, accessible terminal identification and a safe qualified maintenance/validation procedure.

**Conditional selected-machine intake `IN-04l`:** exact safe output/test-pulse/capacitive-load configuration, compensating OEM conditions, firmware and independent physical witness. **UNKNOWN** installed components, fault response, machine stop/hold, PL/SIL, stopping distance, selected acceptance criteria. `VAL/PT NOT RUN`, `G3/G4 NOT AUTHORIZED`.

**Evidence labels:** DOC-CONFIRMED manufacturer instructions, INFERENCE cross-machine integration consequences, SOURCE-CONFIRMED none new for LinuxCNC, TEST-CONFIRMED none, COMMUNITY-REPORTED none, UNKNOWN selected-machine behavior. No compute, simulations or physical tests justified by these documentary questions.
