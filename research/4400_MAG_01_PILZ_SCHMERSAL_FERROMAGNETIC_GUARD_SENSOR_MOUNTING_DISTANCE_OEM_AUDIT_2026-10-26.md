# 4400 MAG-01 — magnetic guard sensors: the mounting steel changes the sensing envelope

**2026-10-26 | Direct manufacturer manuals | DOCUMENTARY ONLY / NOT MACHINE VALIDATION**

## Question and scope
Can a low-cost noncontact guard sensor that behaved correctly on a bench become unreliable after mounting on a steel guard or replacing its mounting bracket? **Yes, manufacturer manuals explicitly warn that ferromagnetic mounting, metal swarf, strong fields and actuator alignment can change operating/release distances.** The actual installed failure direction and magnitude remain unknown until exact-product, as-built evaluation.

**Novelty:** [25D0 low-cost guard interlock comparison](25D0_GUARD_INTERLOCK_LOW_COST_COMPARISON_2026-09-23.md) already establishes the generic guard-open vs safe-state boundary and mounting/defeat risks; [PSENml mechanical mounting audit](4400_PILZ_PSENML_MOUNTING_FZH_ESCAPE_1004710_EN10_2026-10-23.md) covers a different mechanical guard-lock family. **MAG-01 adds the exact ferromagnetic material / actuator variant / assured-release-distance mechanism**, not a new generic interlock concept. No claim of installed OpenPressBrake sensors.

## Primary source provenance

1. **Pilz PSEN ma1.4p-50, Operating Manual 22126-EN-08**, original 24-page manufacturer PDF directly opened: https://www.pilz.com/download/open/PSEN_ma1_4p-50_Operat_Manual_22126-EN-08.pdf . Inspected printed pp. **5, 8–9, 12–14, 18–21**, §§Safety, Function, Operating distances, Installation, Adjustment, Technical details. Device is a *magnetic* safety switch with selected actuators and compatible evaluation device; not a universal reed-switch rating.
2. **Schmersal BNS 33, Safety Sensor Operating Instructions**, original manufacturer PDF directly opened (manual version V4; exact PDF footer to be checked if product is selected): https://products.schmersal.com/upload/orig/10/00/20/10/DOC_MAN_MEC_mrl-bns33_SEN_AIN_V4.pdf . §3.1 Mounting and §3.3 axial misalignment; product-specific material and spacing effects.
3. **Omron D40A/G9SX-NS original manufacturer catalog**, https://www.ia.omron.com/data_pdf/cat/d40a_g9sx-ns_c140-e1_10_6_csm1815.pdf?id=1832 . **Manufacturer-indexed excerpt only, not directly inspected PDF**: mounting near magnetic body changes its operating distance; used as corroboration, not a source of machine acceptance numbers.

## Exact manufacturer findings

| ID | Evidence | DOC-CONFIRMED OEM proposition | Transfer limit |
|---|---|---|---|
| MAG-01 | Pilz p.13 §Installation | Avoid ferromagnetic mounting where possible; electrically/magnetically conductive material can change switching and assured release distances `Sar`. | A previously documented bench gap is not a qualified steel-door installed gap. |
| MAG-02 | Pilz pp.13–14 | Nonflush conductive mounting can change `Sar`; use nonmagnetic fixing materials, secure against loosening, keep iron swarf away, avoid strong magnetic fields and vibration. | Exact fastener/spacer and anti-defeat design require selected-product instructions. |
| MAG-03 | Pilz p.20 §Technical details | With the named two actuator variants, catalog assured operating `Sao` values are **3 mm** and **10 mm**, and assured release `Sar` values **12 mm** and **22 mm** respectively. | Same switch family does not imply interchangeable actuator/gap or operating/release threshold. Values are **NOT** OpenPressBrake criteria. |
| MAG-04 | Pilz pp.12, 18 | Evaluation device output must be re-enabled only after both reed contacts have opened and closed (partial operation lock); OEM calls for a **monthly function test** by qualified personnel with evaluation device connected. | These are exact-product instructions, not a universal proof interval or a validated machine safety function. |
| MAG-05 | Schmersal BNS 33 §3.1 | Ferromagnetic mounting 0–5 mm from material can reduce the **switching distance to about 40%** of the original; at 5–8 mm about 80%; >10 mm no change in the documented installation example. | These are BNS 33 **approximate** manufacturer statements, not a general ferromagnetic derating factor. |
| MAG-06 | Schmersal BNS 33 §3.1 | Do not use sensor as mechanical backstop; protect against displacement, vibration, metal chips and magnetic fields; actuator should be permanently fixed against tampering. | Better mechanical design and accessible maintenance can reduce nuisance failures and bypass pressure. |
| MAG-07 | Pilz p.5 / p.14 | Switch/actuator only work as safety function with specified compatible evaluator and installation; guard misalignment must not defeat function; real operating/release distances must be tested. | A 'guard closed' LED or normal LinuxCNC pin is not independent safety authorization. |

## Causal and adversarial analysis

`steel bracket or replacement actuator / swarf / guard sag -> changed magnetic field or relative gap -> unexpected switch/release threshold -> guard can appear closed when geometry is unsafe OR nuisance fault prompts bypass -> safety receiver may see wrong permissive -> independently valid stopping elements never receive an open-guard demand`.

The **direction** of actual field change is product and geometry dependent; do not invent a universal 'stays ON' fault. The Schmersal example is a *reduced* switching distance; Pilz warns that assured release distance can change. The wrong engineering inference would be 'metal always holds the switch ON'. Qualified evidence must show the actual worst-case installed opening/release behavior.

Separate path: `correct guard-open detection -> safety controller demands stop -> final element/ram fails to stop or hold`. Interlock testing alone does not validate physical stopping, energy isolation, gravity support, trapped-person escape or restart.

## Human-factors and inexpensive design choices

- Mount with the manufacturer's appropriate nonmagnetic hardware/spacers and fixed mechanical reference; guard sag, slamming and metal swarf are foreseeable in a shop.
- Use robust hinges, repeatable locating features, captive/secured fasteners, accessible swarf cleaning and a protected actuator that is harder to dislodge than to maintain correctly.
- A guard that nuisance-trips after every adjustment is a design defect to investigate, not an invitation to tape an actuator in place.
- Make replacement identity visible: exact sensor + actuator part/revision, gap, mounting surface and evaluation-device compatibility.
- Keep the sensor away from high-field equipment where manufacturer specifies; use qualified no-energy review and later independent functional/physical validation, not a magnet workaround.

## Evidence classes and release

**DOC-CONFIRMED:** Pilz and Schmersal exact manufacturer documents; Omron indexed corroboration lower confidence. **SOURCE-CONFIRMED LinuxCNC:** none newly traced. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** mounting and swarf changes can invalidate prior guard sensing; bad human factors promote bypass. **UNKNOWN:** selected OpenPressBrake interlocks, mounting geometry, actual gap, safety controller/final elements, Y1/Y2 stop/hold, PL/SIL and external score. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No physical/energized tests, no numerical machine thresholds and no compute. Reopen only with exact selected device/as-built drawings, competent qualified review and controlled independent physical witnesses.
