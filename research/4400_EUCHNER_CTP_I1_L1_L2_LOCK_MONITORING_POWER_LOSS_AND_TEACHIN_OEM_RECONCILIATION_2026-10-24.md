# 4400 — Original EUCHNER manuals: identical FO pins can protect different propositions

**2026-10-24 | Original OEM source reconciliation of existing CTP replacement exercise | DOC-CONFIRMED exact manual versions | no selected machine/test**

## Why this source pass was justified

The curriculum already contains [a CTP-I1 versus L1 adversarial replacement card](../safety-course/4400_CTP_STATE_TABLE_REPLACEMENT_ADVERSARIAL_CARD_2026-10-22.md). This new source pass does **not** recreate that card. It independently inspects the **original OEM operating instructions** and adds three missing discriminators: **external guard-unlock control authority**, **power-loss/entrapment variant behavior**, and **Unicode teach-in/change-control failure**. Those can materially change a service substitution decision even if both devices have FO1A/FO1B and identical-looking mechanics.

## Direct original manufacturer sources

- EUCHNER *CTP-I.-AP Unicode/Multicode*, **2126290-08-07/24**, 32-page original manufacturer PDF: https://cdn.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_08_07-24_2126290.pdf . Directly read printed **pp.5–12**, particularly §2, §3, §6.1–6.8, §7, §9.
- EUCHNER *CTP-AP Unicode/Multicode*, **2124217-08-06/21**, 36-page original manufacturer PDF: https://cdn.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf . Directly read printed **pp.5–11, 15, 22–23, 26**, especially §3, §6.1–6.8, §10, §11.2–11.3 and §13.
- Official product identifiers independently inspected: [CTP-I1 126954](https://www.euchner.com/en-us/a/126954/), [CTP-L1 Unicode 123375](https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-l1-ap-u-ha-ae-sh-123375/), [CTP-L1 Multicode 123376](https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-l1-ap-m-ha-ae-sh-123376/).
- **Edition boundary:** these manuals refer to **ISO 14119:2013** in their installation instructions. The current ISO edition is **ISO 14119:2024**, official publisher catalog https://www.iso.org/standard/75942.html . Full paid normative text **not inspected**; do not claim 2024 clause-level conformity from an older OEM manual.

## Exact OEM propositions

| Variant/function | Manufacturer evidence | Safety consequence |
|---|---|---|
| **I1**, guard position | I.-AP §3/§6.8: FO1A/FO1B ON when guard closed **even if unlocked**; OFF when open. | Its FO pair is a safety output for **guard-position monitoring**, **not safety-rated locking**. |
| **I1**, process lock | I.-AP §6.1–6.2: locking does not control FO state; its switch-on check can turn FO off if locking fails but is **not guard-lock monitoring under EN 14119**. | An apparently successful startup check is not an independent proof that access stays locked until physical safe state. |
| **L1**, lock and door | CTP-AP §3/§6.8: FO pair OFF if locking released or door open. | This is a **different protective proposition** despite shared FO names and similar mechanics. |
| **L1**, unlock permission | CTP-AP §3: **control of guard locking** for personnel protection is itself a safety function, but the solenoid is controlled externally and the device does **not** assign a safety characteristic to that external control. | A correctly rated L1 sensor is not proof that ordinary PLC/HMI solenoid output may unlock a moving hazard. External standstill/holding safety logic must be designed and validated. |
| **L1/I1**, spring-to-lock power loss | CTP-AP §6.6 and I.-AP §6.6: loss of solenoid voltage retains lock; if an open door closes after loss of power, people may be unintentionally trapped. | Loss of power may preserve barrier but create **egress hazard**; select suitable inside escape and prevent occupancy/restart. |
| **L2/I2**, power-to-lock power loss | CTP-AP §6.7 and I.-AP §6.7: loss of solenoid voltage **releases** lock. CTP-AP warns personnel protection with L2 only in special cases after strict risk assessment. | A seemingly minor suffix change can reverse loss-of-power access behavior. |
| **Unicode vs Multicode** | Both manuals §6: Unicode requires learned unique actuator; Multicode recognizes any permitted type, described as **low coding level**. | Replacing an actuator with a generic spare may alter anti-defeat resistance or require teach-in. |
| **Teach-in/replacement** | CTP-AP §11.2: learning a new actuator disables prior code; only most recently taught-in actuator operates, with specified power-cycle commissioning. | Service personnel need correct labeled spare, documented teach-in, functional test and safe rearm; do not bypass a faulted switch to restore throughput. |
| **Diagnostics vs safety** | CTP-AP §10 explicitly says evaluate both FO channels and **do not use monitoring outputs as safety outputs**. | OL/OD/OI or ordinary HMI data is not interchangeable with FO safety channels. |

## Human-factors failure path and affordable design

A wrong replacement may **appear to work** in the normally locked state. If the technician tests only *door open* and *door closed-and-locked*, the decisive **door closed-but-unlocked** difference can remain invisible. A spare actuator or unlocked guard may be harder to troubleshoot than a simple jumper; prevent that incentive with a clear on-machine approved SKU/revision label, dedicated controlled spare, accessible alignment and test instructions, easy legitimate reset, and proper inside escape. A controlled spare is not a reason to make normal access cumbersome.

**Minimum documentary service test:** compare exact part/firmware/manual; derive required SRS physical proposition; record expected FO/OL/OD for **open, closed-unlocked, closed-locked**; verify power-to-lock vs power-to-unlock; identify external unlock authority; identify release/escape and coding/teach-in; mark prior evidence **STALE**; qualify physical stop/hold/restart under an independently reviewed safe test plan. Never perform person-exposed tests or deliberate guard bypass.

## Disposition

**DOC-CONFIRMED:** exact OEM manual claims above. **SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **INFERENCE:** service mis-selection and bypass incentive; **UNKNOWN:** any installed EUCHNER device, safety wiring, external unlock control, physical Y1/Y2 hold, actual egress, PL/SIL of machine. This is **not a new safety certification or a second scored evaluation**. G0/G1 HOLD, G3/G4 NOT AUTHORIZED; no compute. Existing [GUARD-01](../safety-course/4400_GUARD_01_ACCESS_RELEASE_ESCAPE_AND_REARM_BOUNDARY_MODULE_2026-10-24.md) and CTP card remain primary learner routes; this source reconciliation adds precise OEM authority and edition context.
