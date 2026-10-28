# 4400-COIL-DECAY-01 — A quiet contactor can be a slow contactor
**Technician one-pass review | 2026-10-28 | PAPER ONLY — no operating instructions**

Read the [original manufacturer/source audit](../research/4400_COIL_DECAY_01_SUPPRESSION_DROPOUT_TIME_VS_CONTACT_LIFE_SOURCE_AUDIT_2026-10-28.md) after [CYCLE-01](4400_CYCLE_01_ON_STATE_DIAGNOSTIC_GAPS_AND_SAFE_PROOF_WORKFLOW_MODULE_2026-10-26.md) and [RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md).

**Problem:** A coil suppressor reduces switching transients but can slow a DC contactor's physical release. Original Schneider catalogues describe **6–10× normal dropout** for specified diode accessories, while Pilz recommends flywheel diodes for contact-life protection on certain relay outputs. Both statements can be true. The ratio is **not** a measured press-brake stop time, and no generic component substitution is approved.

**Never treat these as equivalent:** safety controller says OFF → external coil current is gone → contactor main contacts opened → hydraulic energy was removed → gravity-loaded ram is held. Each arrow needs appropriate evidence. EDM/mirror feedback is useful but is not automatically a stop-time measurement.

| Field question | Evidence to request without operating the machine |
|---|---|
| What was changed? | Before/after coil, contactor, suppression module, driver, power source and exact part/edition. |
| Is suppression already integrated? | OEM coil/contactor datasheet, wiring and manufacturer-approved accessory list. |
| Is this a safety final element? | Independent safety function, output, contactor and physical energy-removal mapping. Normal FPGA driver has **zero personnel-safety credit**. |
| Is a previous stop-time result still valid? | Qualified change assessment and independently witnessed selected-machine stop/hold after approved revalidation. |
| Can reset reissue motion? | Independent area-clear/rearm and separately deliberate fresh cycle start. |

**Safer and easier maintenance design:** label each coil/suppressor combination as a matched approved assembly, use keyed/plug-in OEM modules and keep a small photo/part-number record at the cabinet. Do not invite ad-hoc diode additions to solve electrical noise or ad-hoc removal to gain speed. Investigate the noise and preserve the safety-response envelope together.

**Paper-only challenge (UNSCORED):** A replacement contactor has the same voltage/current ratings but integrated suppression. An OFF LED and EDM both change as expected. What remains unproven? **Answering requires identifying actual release timing, final-element physical behavior, hydraulic/gravity holding and safe rearm; do not invent a numeric acceptance limit.**

**Release:** G0/G1 HOLD; no personnel-exposed hazardous operation. Selected OpenPressBrake safety configuration, actual Y1/Y2 stop/hold and independent evaluator remain UNKNOWN/NOT RUN. No live stop test, fault injection, simulation or compute performed.
