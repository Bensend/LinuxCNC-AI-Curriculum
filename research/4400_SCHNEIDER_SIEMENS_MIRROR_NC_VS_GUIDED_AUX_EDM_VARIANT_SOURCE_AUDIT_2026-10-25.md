# 4400-MIRROR-01 — Mirror NC contact is not just any auxiliary NC: EDM variant audit
**2026-10-25 | manufacturer-source investigation | NON-GRADUATED | no machine-specific test**

## Question and why it matters
A retrofit has a safety relay with an EDM feedback loop. A technician replaces the power contactor or adds an NC auxiliary block. Can any NC contact be assumed to report welded power poles? **No.** The manufacturer's exact mirror-contact claim must cover the **selected contactor and selected auxiliary assembly**. A generic NC may report its own position without the guaranteed relationship to the main poles.

## Original manufacturer evidence
1. **Schneider Electric, FA136111**, updated 2025-08-08, https://www.se.com/ie/en/faqs/FA136111/ . **DOC-CONFIRMED:** IEC 60947-4-1 *mirror contact* concerns a normally closed auxiliary that cannot be closed while an NO **main power pole** is closed. The manufacturer distinguishes this from the IEC 60947-5-1 mechanically linked/positively guided concept for NO and NC **auxiliary contacts**. It explicitly warns that using the terms interchangeably can mislead.
2. **Schneider Electric, FA142116**, updated 2025-08-22, https://www.se.com/ie/en/faqs/FA142116/ . **DOC-CONFIRMED:** TeSys K 0601 models identify 21–22 NC as mirror; corresponding 0610 variants have no NC mirror. TeSys Deca LC1D09–LC1D95 21–22 base NC is listed as mirror; LC1D115/150 have variant-dependent factory-mounted lateral versus revised suffix variants. The manufacturer recommends base-product NC over removable front auxiliaries where possible to improve reliability of correct installation.
3. **Schneider Electric TeSys Giga installation guide, auxiliary contacts**, https://productinfo.se.com/tesysgigainstallationguide/tesys-giga-series-giga-contactors-and-giga-thermal-overload-relays-installation-guide/English/TeSys%E2%84%A2%20Giga%20Series%20Giga%20Contactors%20and%20Giga%20Thermal%20Overload%20Relays%20Installation%20Guide_0000447511.xml/%24/PanGu_AuxiliaryContactsCPT_0000476929 . **DOC-CONFIRMED:** exact 1 NO + 1 NC auxiliary module family describes NC mirror to IEC 60947-4-1 and auxiliary NO/NC mechanically linked to IEC 60947-5-1. These are **two different** relationships, not interchangeable certification of every NC.
4. **Siemens, Contactors in safety applications, entry 109807687 V1.1 07/2023**, https://support.industry.siemens.com/cs/attachments/109807687/109807687_Contactors_in_safety_applications_V11_en.pdf . Search-indexed official original PDF describes the IEC 60947-4-1 Annex F mirror condition and the distinct IEC 60947-5-1 Annex L positively guided auxiliary relation. **ACCESS LIMIT:** direct PDF open returned 403; treat this as *manufacturer indexed corroboration*, not a directly re-read page. Do not infer its example DC percentages apply to a selected design.

**Source conflict/format limitation:** Schneider FA142116's rendered HTML table loses column alignment around LADN**/LAD8N** blocks and the adjacent “not mirror” sentence. Therefore **UNKNOWN** exactly which optional block each phrase applies to from this rendering alone. Use the exact assembly datasheet/certificate and photograph, not a guessed table interpretation.

## Failure-path analysis
| Case | Incorrect shortcut | Correct evidence boundary |
|---|---|---|
| A power pole welds, ordinary NC opens/closes | “Every NC follows the power poles” | Mirror NC claim for exact main/aux assembly, monitored by selected safety logic |
| Replaced LC*K0601 with similarly sized 0610 | “Same series, same feedback” | Schneider's explicit part-family difference; as-built variant review |
| Added/removable auxiliary block | “More feedback contacts means safer” | Confirm specific mirror property, attachment integrity and monitored path |
| Mirror NC feedback is good | “Motor and hydraulic ram are now safe” | Feedback covers main-pole/contact relation, not hydraulic valves, gravity, trapped pressure, backfeed or independent physical stop/hold |
| Safety PLC shows healthy EDM | “No jumper/short possible” | Qualified as-built EDM path audit and change control; avoid unverified wiring fault exclusions |
| Contactor replaced with different coil voltage | “Same mirror means same switching performance” | Separate load category, contact ratings, power supply, suppression, switching time and machine-level validation |

## Practical design and human factors
Prefer manufacturer-qualified base NC mirror feedback with clearly keyed/retained components where the exact assembly supports it. Keep accessible as-built part-number photographs and an operator-readable “EDM contactor mismatch” diagnostic. Use a replacement checklist that explicitly identifies the main pole, mirror NC, wiring, safety input and changed variant before rearm. Do **not** solve nuisance trips with a feedback jumper or by transferring EDM into ordinary LinuxCNC/HAL/FPGA.

**DOC-CONFIRMED:** exact Schneider manufacturer claims above. **SOURCE-CONFIRMED:** no LinuxCNC source read. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** proposed design/verification and fault scenarios. **UNKNOWN:** selected OpenPressBrake contactor or even whether one exists in the protective chain; actual circuit, PL/SIL, physical stop/hold, external score. No authorized energized fault test or personnel exposure.

## Required next restricted evidence
Actual manufacturer/part/suffix for each contactor and installed auxiliary, exact mirror-contact declaration and mounting configuration, NC feedback path, safety controller EDM config, supply/load categories and qualified physical stop/hold witness. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.
