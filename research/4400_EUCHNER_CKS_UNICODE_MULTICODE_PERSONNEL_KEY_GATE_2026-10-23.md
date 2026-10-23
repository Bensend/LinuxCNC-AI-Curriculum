# 4400 — EUCHNER CKS coding-mode trap: an electronic personnel key is not a generic lockout

**2026-10-23 UTC | Exact manufacturer-manual source investigation, not selected-machine validation.** Complements [the whole-body access/LOTO source study](4400_PERSONNEL_KEY_WHOLE_BODY_ACCESS_VS_LOTO_SOURCE_AUDIT_2026-10-23.md).

## Exact evidence and edition

**DOC-CONFIRMED** from EUCHNER operating instructions `2113903-06-09/19`, *Key Adapter CKS-A-L1B-SC*, English pages 3–4 in the multilingual official PDF: https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Key-Adapter-CKS-A-L%E2%80%A6_Multilang_06_09-19_2113903.pdf . The current manufacturer's product page for exact order no. `158081` independently says the CKS key adapter must **not** be used as a lockout bar with **multicode** evaluation: https://www.euchner.com/en-us/products/transponder-coded-read-heads-with-external-evaluation/cks-key-adapter/cks-a-l1b-sc-158081/ .

- The manual names the compatible **CES-AZ-.ES** and **CES-FD** evaluation families, but requires the **specific evaluator manual** for wiring, teach-in and setup.
- Its safety precautions restrict use as a *lockout mechanism* to **unicode evaluation units**. A visually similar key/adapter on a **multicode** evaluator does not inherit that application claim.
- With the correctly integrated selected evaluator, removal of the key causes its safety outputs to switch off; the white LED only indicates that a valid key is recognized. The manual requires **complete withdrawal** of the key for safe switch-off.
- The manual's functional check explicitly distinguishes power-up (machine must not automatically start), valid-key insertion, control-system enable and removal (machine must stop and remain unable to start while the key is absent). It calls for rechecking after installation, component replacement and faults, with people **outside the danger area**.
- The 2019 manual references EN 14119:2013; the public ISO catalog now identifies ISO 14119:2024 as the current edition. This is a **revision/applicability review trigger**, not a claim that the old selected product is automatically invalid or that the licensed 2024 clauses were inspected.

## Why the coding mode changes the safety argument

**INFERENCE grounded in the explicit manufacturer restriction:** a commissioning worksheet that records only `CKS adapter installed` and `key removed` is incomplete. It must capture the exact evaluator model, firmware/configuration, **unicode versus multicode** mode, learned-key identity, approved replacement keys, full-withdrawal geometry, and output/final-element behavior. The wrong evaluator mode may invalidate the personnel-key inhibit proposition even when a normal HMI says the key reader is healthy. **Do not invent a specific failure waveform or assert that all multicode configurations necessarily restart; the manufacturer states a prohibited application, not a universal measured failure trace.**

**Terminology collision:** EUCHNER's product/manual use of *lockout mechanism/bar* describes a safety-system key-inhibit application. It does **not** establish that this adapter is an OSHA 1910.147 energy-isolating device for maintenance. A safety output switched off is not a physical disconnect, hydraulic depressurization, gravity restraint or group-worker individual LOTO protection.

## Adversarial selected-chain review

| Claim presented by installer | Required counter-question / evidence | Status here |
|---|---|---|
| “It is a CKS, so PL e” | Which exact CES evaluator and configuration? What machine safety function and actual final elements? | UNKNOWN |
| “The LED went out” | Was key fully withdrawn; did selected evaluator outputs change; did independent stop/hold occur? | NOT RUN |
| “Any coded key is fine” | Is the exact evaluator in manufacturer-permitted unicode mode for this use? How is learned key/replacement controlled? | UNKNOWN |
| “The key is my LOTO” | Which **physical energy isolators** and stored-energy/pressure/ram restraints are independently locked and verified? | UNKNOWN |
| “We replaced the evaluator with a similar one” | Are coding mode, key learning, compatibility and downstream `SRS/DEP/VAL/PT` revalidated? | STALE |
| “Power came back; key inserted; start now” | Did independent safety reset and a new deliberate ordinary start occur; can a held pedal/old command move it? | NOT RUN |

**No lab needed now.** The selected coding-mode prohibition is documentary and definitive at the stated manufacturer scope. A bounded bench test could be justified only for a selected permitted CKS+CES configuration with an unresolved interface behavior after the exact evaluator manual is inspected, with an independently safe low-energy arrangement on `[self-hosted, openpressbrake]` only. Do not test by defeating a live machine interlock.

## Package fields and release state

Record `BND/HAZ` (entrants/whole-body access), `SRS` (retained-key inhibit, independent stop, fresh restart), `AUTH` (ordinary HMI versus safety evaluator versus final element), `DEP` (coding mode, learned keys, supplies, common wiring, duplicate key), `ARC` (exact adapter/evaluator), `HF` (key return/replacement friction), `PHY` (independent stop/hold/escape/energy), `CHG` (replacement) and `VAL/PT` (negative cases). Selected machine `IN-01..10` UNKNOWN; physical tests NOT RUN; `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`. No personnel-exposed hazardous operation is authorized.
