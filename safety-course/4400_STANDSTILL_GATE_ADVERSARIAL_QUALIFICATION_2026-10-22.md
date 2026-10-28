# 4400 technician exercise — Standstill monitor is not machine safe state

Read the manufacturer Pilz PNOZ s30 Operating Manual 1001715-EN-24 §§5.3, 11.3, 13.3.9–13.4.1, and the linked research note. No actual machine operation is required or permitted by this exercise.

**Case A — press-brake retrofit:** two PNP proximity sensors watch a motor shaft. The standstill monitor's output is true and a guard unlock request is asserted. An independent beam witness shows downward movement. What narrow proposition remains supported? What does the motor sensor *not* prove? Which `PHY/DEP/VAL` status and operational restriction apply?

**Case B — plausible agreement:** two sensors share supply and mechanical mounting; both report below threshold after an intermittent coupling failure. Name the common cause, required independence evidence and why a two-channel label alone is insufficient.

**Case C — copy/paste threshold:** a trainee proposes copying the manufacturer's **≤2 Hz example** to a machine with a different encoder resolution and mechanical transmission. Identify the missing calculations and physical validation; do not supply invented values.

**Case D — configuration drift:** a selected arrangement changes from the stronger-diagnostic proximity-switch option to reduced diagnostics. What manufacturer subsystem-characteristic difference is documented? Why is the achieved machine PL/SIL still UNKNOWN? What `CHG` invalidation follows?

**Case E — proof test:** a maintainer sees a 'standstill' light and wants to enter for hydraulic repair. Explain why the indication is not isolation; specify the separate lockable energy-control, stored-energy and gravity-restraint propositions to verify.

**Case F — restart:** a standstill monitor is configured for automatic output start. Guard closed and monitor true while ordinary cycle-start remains asserted. Distinguish monitor output re-enablement, independent safety rearm and deliberate production start.

**Assessor boundary:** require exact manual edition, no invented machine thresholds, no unproved safety-performance target, a physical contradiction witness and the minimum safe-to-operate restriction. Keep the external sealed 2520–25F0 evaluations untouched; this is an open practice card, not an evaluator answer key.

**Case G — diagnostic gap at low frequency:** a learner claims 'two proximity switches continuously cross-check each other, even at standstill.' Use Pilz §§5.3.6 and 8.7.5 to challenge that claim. Which prerequisites/validation cut-off may suspend plausibility? What independent mechanical/physical witness is needed?

**Case H — broken mode-select wire:** a product is configured in `All 16` parameter-set mode and one select conductor opens. Use Pilz §5.4.1 to explain how another valid set may be selected, why ordering limits matters, and why selecting a `No 2 encoder diagnostics` mode is a change-control risk. Do not assert a specific machine's selected set without the configuration.

**Case I — filter and proof interval:** the monitor is set to a slow filter to eliminate nuisance speed chatter, and a technician copies a monthly relay-test statement from Pilz §11.3 into a different safety controller's plan. Identify the response-time validation impact and why the manufacturer's product/claim-specific relay interval cannot be generalized.

**Case J — false equivalence of defaults:** the PNOZ s30 screen shows a standstill default of 100 Hz in one encoder basic configuration and 2 Hz in the proximity-switch basic configuration. Explain why neither is a transferable physical zero-speed criterion; identify the necessary scaling and access-time evidence without inventing values.

## 2026-10-28 source-level cross-check — normal LinuxCNC M19 acknowledgment
Before using this card for a LinuxCNC mill/lathe/ATC, read the [exact v2.9.10 M19/ordinary-lock source trace](../research/4400_SPINDLE_ORIENT_01_LINUXCNC_2910_CUMULATIVE_ACK_VS_PHYSICAL_LOCK_SOURCE_AUDIT_2026-10-28.md). The stock `orient.comp` completion criterion counts cumulative (not necessarily consecutive) position-error samples and has **no velocity term**; Motion then sets a `locked` status and a **brake output command**. The normal `spindle.N.at-speed` input is initialized TRUE if unwired. None substitutes for the **selected independent** standstill-monitor/guard-release function, its mechanical coupling or physical restraint. This is a source-depth reconciliation, not an eleventh exam case, no physical proof and no change to the Pilz product-specific criteria above.
