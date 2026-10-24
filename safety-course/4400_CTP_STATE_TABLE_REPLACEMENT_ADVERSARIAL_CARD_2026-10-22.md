# Technician card — Same latch, different safety truth

**Use:** 4400/2590 guard-lock substitution; learner-facing, non-blind practice. **No physical hazardous fault injection.** Refer to manufacturer manuals EUCHNER 2126290-08-07/24 §6.8 and 2124217-08-06/21 §6.8 before answering. A future information-separated evaluator must use a fresh, sealed case; this card is not a blind challenge.

## Scenario

A cell was designed with a CTP-L1 safety switch. The SRS says a guard must stay locked until hazardous motion has independently stopped and the appropriate load is held. A replacement CTP-I1 has a similar spring-to-lock mechanism, the same named FO1A/FO1B outputs, an OL indicator, and a similar mechanical rating. After replacement, the gate is **closed but unlocked**. An operator asks whether a healthy FO pair means the original protection has been restored.

## Student tasks

1. Fill this table from the **two different manufacturer switching-state diagrams**: FO1A/FO1B, OL and OD for locked, closed-unlocked, and open. Cite manual revision and page.
2. Explain what the I1's switch-on locking check does **not** prove. Identify which manufacturer's PL e claim concerns guard position and which concerns lock monitoring.
3. Explain why the two devices' spring-to-lock behavior does not settle either personnel-protection eligibility or the inside-escape question.
4. Trace the change through `CHG -> SRS/PHY/AUTH/ARC/DEP/VAL/PT` and identify the independent physical witness needed before allowing access.
5. Explain why neither `OL=OFF` nor `FO=OFF` alone proves that the guard physically opened or that dangerous motion ended.
6. Design a **documentary-first** acceptance process and a bounded, safely isolated physical check, explicitly excluding live person-exposed testing.

## Expected engineering disposition (learner-readable feedback, not a sealed evaluator key)

The replacement is **not approved as equivalent** merely because it mechanically locks. I1 FO is ON for a normally closed-but-unlocked guard; L1 FO is OFF in that state. A healthy I1 FO pair may therefore be a **guard-position** signal, not the required **guard-lock** signal. The I1 diagnostic lock check is explicitly not safety-rated lock monitoring. The L1's external control of unlocking must itself be justified, including safe standstill/holding and access timing. All installed-machine facts remain UNKNOWN pending selected design evidence. Mark affected records STALE, retain original evidence, and block exposed-person release until requalified.

## Human-factors redesign

A spare part must be selected by **safety function and exact approved SKU**, not shape, force headline or connector adapter. Put the approved part/revision and functional acceptance test on the inside of the service panel; use a keyed/controlled spare and easy-access test point. Make the correct replacement quicker than a plausible wrong one. Keep inside escape reachable and outside release controlled without encouraging defeat.

## 2026-10-24 original-manual verification extension
The [direct original 32-page I.-AP 2126290-08-07/24 and 36-page CTP-AP 2124217-08-06/21 audit](../research/4400_EUCHNER_CTP_I1_L1_L2_LOCK_MONITORING_POWER_LOSS_AND_TEACHIN_OEM_RECONCILIATION_2026-10-24.md) independently verifies the closed-unlocked FO difference and adds **external safety authority for the L1 unlock solenoid**, **L1/I1 spring-lock entrapment versus L2/I2 power-to-lock release on power loss**, and **Unicode vs Multicode/teach-in change control**. The OEM manuals cite 2013 ISO 14119 while the publisher's current edition is 2024; full new normative clauses were not inspected. These are extra service acceptance discriminators, not physical machine proof or a new blind score.
