# 4400-OPB-PWR-AGG-01 — “Seven inputs” does not mean seven chips or a safe press brake

**2026-10-29 | technician / board-integration review card | PAPER ONLY — NOT RUN**

Read the [exact source audit](../research/4400_OPB_PWR_AGG_01_SAFETY_INTERFACE_CHILD_PACKAGE_FIELD_LOAD_AND_SWITCHED_DOMAIN_SOURCE_AUDIT_2026-10-29.md) after [OPB-CUTOVER-02](../research/4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) and [OPB-ISO-03](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). The new lesson is **accounting-unit discipline and missing field-load evidence**, not a new safety relay, a new installed circuit, or a scored exam.

## Four questions to ask before a board or machine is released

1. **Which unit are we counting?** Seven semantic input channels need a packing plan for dual-channel ISO1212 receivers; the documented **1.9 mA maximum** is per populated dual package, not per channel. Six ordinary handshake outputs use six STISO621 and three STISO620 devices under the child-manifest packing rule. The complete board has additional ordinary outputs: do not double count a subset.
2. **Which rail and return does each term belong to?** Separate 3V3 FPGA/receiver power, switched process-side isolator power, L7/L07 actual output-load current and inrush, and physical return paths. Unknown load current is **NOT ZERO**. Do not bridge L07 to L06 for convenience.
3. **What does a status LED really prove?** A Pilz→FPGA bit and an output-fault bit are **observations**. If switched field power is absent, mark field diagnostics **INVALID/UNAVAILABLE**, not “no fault.” The independent Pilz program and actual safety final elements must be reviewed separately.
4. **What physically prevents hazardous motion?** The retained wire-75 hardware permission, wire-63 Pilz→drive path, independent Y1/Y2 hydraulic stop/hold, guards, isolation and deliberate restart require exact as-built and qualified evidence. A green power spreadsheet, FPGA watchdog or software inhibit does **not** prove them.

## Fail-closed review outcomes

| Observation | Review decision |
|---|---|
| Child package count and logic rail current reconciled, but field load/connector/contact envelope TBD | **BOARD INTEGRATION HOLD** for that electrical release; **machine G0/G1 HOLD**. |
| 11K2-switched L7/L07 field supply unavailable while FPGA logic remains powered | Display **FIELD POWER INVALID / DIAGNOSTICS UNAVAILABLE**; do not infer physical safe state from low ordinary status bits. |
| Wire 44 mute request or wire 45 CNC OK remains high through a mode/reset transition | **Safety program truth and physical effects UNKNOWN** until selected Pilz application and qualified witness are reviewed. No assumed timing/permission. |
| Owner supplies only the seven-input/six-output YAML and an apparently passing software model | **No physical safety release.** Request existing restricted Stage A A–G records; do not enlarge the owner-facing packet. |
| A qualified engineer proves all required physical and independent safety functions for the exact machine | Record actual scope, version, witness and limitations. Do not backfill a test result from this paper card. |

**Easy-safe workflow:** make “unknown/invalid” visible and actionable, keep ordinary handshakes and independent safety wiring physically distinct, use keyed/clearly labeled connectors where practical, and provide a short documented route for qualified diagnosis instead of encouraging jumper wires or guard bypasses.

**Classification:** exact public project contracts **SOURCE-CONFIRMED**; package arithmetic **INFERENCE (checkable)**; machine wiring, selected load ratings, independent stop/hold and operator behavior **UNKNOWN**; **TEST-CONFIRMED none**. **G0/G1 HOLD; no personnel-exposed hazardous operation.**

**Manufacturer-source correction:** [TI's ISO1212 product page](https://www.ti.com/product/ISO1212/part-details/ISO1212SDBQR) distinguishes ISO1211 *channel-to-channel isolation* from ISO1212 *space-constrained multichannel* design. **Seven input status labels are not seven independent safety channels.** Shared dual-package/supply faults must be considered for ordinary diagnostic validity, and TI's “functional safety capable” documentation label does not make the proposed FPGA/Pilz-status monitor safety-rated. Exact package placement and fault coverage remain UNKNOWN.

**J10 status-source nuance:** the published Rev1 J10 connector uses the L7/L07 switched I/O reference, while seven status signals originate at Pilz outputs. The exact Pilz source/return behavior after 11K2 opens is not established. Display **FIELD REFERENCE UNVERIFIED / STATUS VALIDITY UNKNOWN** until each source and return is reconciled; do not claim every status must fall LOW or remain trustworthy. ISO1212 needs no dedicated field-side supply, but still needs a valid input circuit.
