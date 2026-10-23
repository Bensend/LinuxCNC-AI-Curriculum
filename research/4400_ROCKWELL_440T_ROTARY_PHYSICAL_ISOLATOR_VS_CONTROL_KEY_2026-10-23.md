# 4400 — A keyed device that *can* open an energy path: Rockwell 440T rotary versus control-key interlock

**2026-10-23 UTC | Original selected-product source comparison; not a machine isolation approval.** Complements the [personnel-key / maintenance-LOTO study](4400_PERSONNEL_KEY_WHOLE_BODY_ACCESS_VS_LOTO_SOURCE_AUDIT_2026-10-23.md) and [EUCHNER CKS coding-mode gate](4400_EUCHNER_CKS_UNICODE_MULTICODE_PERSONNEL_KEY_GATE_2026-10-23.md).

## Evidence at exact published scope

**DOC-CONFIRMED** — Rockwell Automation's 440T rotary trapped-key family page, https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440t-rotary.html , describes *direct-drive, positively opening contacts* and product variants intended for **electrical isolation** (family maximum 100 A, not every model). The **exact** 440T-MRPSE110F cut sheet, https://configurator.rockwellautomation.com/api/Product/440t-mrpse110f/cutsheet , lists a panel-mounted single-key unit with **2 NO + 2 NC contacts, 20 A**; the family 100 A claim must not be assigned to that catalog number. Rockwell installation instructions `440T-IN027_-MU-P`, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440t-in027_-mu-p.pdf , show multiple contact configurations, require qualified installation and application-specific risk assessment, and call for inspections for wear, tampering and switching faults. The older instructions contain historical directive references: they are product evidence, not proof of current jurisdictional compliance.

**DOC-CONFIRMED** — EUCHNER CKS-A-L1B-SC 2019 instructions, https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Key-Adapter-CKS-A-L%E2%80%A6_Multilang_06_09-19_2113903.pdf , describe key removal switching **CES evaluator safety outputs** off, not physically opening machine power conductors in the adapter. The manufacturer restricts key-as-lockout-mechanism use to **unicode** evaluation. This can support a production personnel-key inhibit in a qualified architecture, but it is not automatically an OSHA energy isolator.

**DOC-CONFIRMED from indexed official regulation** — OSHA 29 CFR 1910.147(b),(d), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 , distinguishes devices that physically prevent energy transmission from control-circuit devices. Direct OSHA page open returned 403; indexed official text was reviewed. This is not a legal opinion about the selected product.

## Narrow authority comparison

| Candidate | What can be supported from inspected documentation | What remains unproven |
|---|---|---|
| 440T **rotary power-path isolator**, exact 440T-MRPSE110F | Positively opening rotary contacts, published exact 20 A/contact arrangement and key sequence; **could** physically interrupt a properly designed *specific* electrical energy path | Which installed conductors/poles are opened, short-circuit protection, load ratings/duty, alternative supplies, isolation verification, padlock/individual LOTO provisions, stored electrical/hydraulic/gravity energy |
| 440T **mechanical Slamlock** 440T-MDSLE11ABCE | Key/actuator mechanical gate-release sequence and secondary personnel-key option | No automatic proof of power isolation or physical standstill |
| EUCHNER **CKS + permitted unicode CES evaluator** | Coded-key recognition and output inhibit with key fully withdrawn, when integrated per manuals | Does not directly isolate machine conductors; evaluator mode/teach-in, safety output to final element, stopping/holding and LOTO are separate |
| Ordinary LinuxCNC **key selector / HMI** | Operator mode/request and diagnostics only | No independent personnel-safety or energy-isolation authority |

**INFERENCE:** it is wrong to say *every* key switch is only a control device, but equally wrong to infer physical isolation from the presence of a removable key. A selected 440T rotary switch **may** be a suitable physical isolating element for one electrical circuit if the as-built power path, ratings, physical lockout and verification support it. It cannot, by itself, render a press-brake's hydraulic accumulator, suspended ram, pneumatic line or gravity load safe. Its key can participate in a transfer sequence without proving that every hazardous source has been controlled.

## Adversarial design and human factors

- If a 20 A rotary switch only disconnects a PLC enable, it is a **control-circuit** application despite the isolator-family label; do not credit it as main-power isolation.
- If a rotary switch physically opens the selected motor feeder, still identify **alternate feeds**, drive DC bus/residual voltage, brake/holding behavior and downstream hydraulic/gravity loads. Qualified absence-of-energy verification remains separate.
- If a single key is shared among two maintenance workers, it does not establish the required **individual** group LOTO control where 1910.147 applies. Design a practical group lockbox/individual locks workflow and preserve personnel keys for whole-body rearm inhibit as an additional function.
- If a replacement rotary variant changes contact topology or current rating, `ARC/DEP/CHG/VAL` become **STALE**. Do not assume a visually similar key barrel or actuator preserves isolation.
- If accessing the key exchange requires awkward reach or removal of panels, redesign the location/captive mounting and key storage so the safe path is the convenient path. Do not encourage bypass by making restoration difficult.

## Selected-machine gate

For `SRS-ENERGY/PHY-ENERGY` record **each physical isolating pole and exact conductor/zone**, selected device ratings and installation, independent verification method, residual energy, worker-owned LOTO, and return-to-service procedure. For `SRS-ACCESS/RESTART` separately record key-exchange and rearm behavior. For `PHY-STOP/HOLD` record independent motion/load witnesses. The [selected-machine intake](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) is still `IN-01..10 UNKNOWN`; physical `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`.

**No laboratory compute justified:** product/OSHA scope distinguishes the classes; actual selected machine energy mapping is missing. No machine may be operated with personnel exposed to an unproven hazard boundary.
