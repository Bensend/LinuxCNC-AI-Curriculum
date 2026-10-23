# 4400 — AKFR pressure and valve witness: original-language source audit (2026-10-23)

**Status:** DOC-CONFIRMED interface description, INFERENCE for failure scenarios, UNKNOWN for actual machine circuit and qualification. **No physical test, safety certification, or permission for personnel-exposed operation.**

## Primary sources and edition boundary

1. Fiessler, *AKAS Sicherheits-Interface AKFR*, original German, document 1257, 2010-04-01, PDF pages 2–3: https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfr-si-interface-dt-doc1257-v1.0.pdf
2. Fiessler, *AKAS Safety-Interface AKFR*, English, document 1264, 2010-07-16, PDF pages 2–3: https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfr-si-interface-engl-doc1268-v1.0.pdf
3. Fiessler AKAS product overview: https://www.fiessler.de/en/products/safety-products/press-brakes/press-brake-protection-akas.php
4. Existing course: `research/FINAL_ELEMENT_WITNESS_MATRIX_2026-09-24.md` and `hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md`.

The German original and English version both explicitly say **AKFR reads hydraulic-valve position indicators AND pressure sensors**, combines/forwards that information to AKAS-F, and receives an enable decision back. Both document **five potential-free normally open safety contacts**. The product overview mentions valve position but omits pressure sensing. This omission is not proof that a specific machine has no pressure sensor; nor is the sheet proof that every variant and installation has all sensors installed and wired.

**Translation discrepancy:** German p. 2 calls the enabled circuits *Ventilansteuerungen* (valve controls), while English p. 2 calls them *contactor controls*. Visual comparison of the p. 3 wiring drawings finds both labeled **Ventilschaltung / Valve release**. The drawing shows a particular colored connection to a hydraulic example, not a universal wiring or hydraulic truth table. Use the German original and actual selected-machine electrical drawing to resolve the exact downstream loads. Do not silently treat the English term as a contactor-only requirement.

**Variant-transfer guard:** these AKFR sheets explicitly describe an **AKAS-F + AKFR** combination. They are **not** a wiring or pressure-sensing manual for the separate AKAS-5M/LC-5M **M** variants requiring additional safety control. Do not transfer the 2024 AKAS-5M overrun/DIP setting conclusions from the previous curriculum checkpoint into this 2010 AKAS-F/AKFR arrangement, or vice versa, without exact manufacturer evidence.

The German and English sheets are dated **2010**. Their historical PL e/category assertions and listed electrical timings are **product/document assertions**, not demonstrated machine-level integrity, current-version compatibility, stopping performance, or proof of hydraulic load holding.

## Inspectable diagram labels, not a machine wiring map

The p. 3 German/English example drawings visibly label five contact pairs `1A–1B` through `5A–5B`, `OSSD1`, `OSSD2`, `EDMS`, `EDMO`, `SGO`, `SGS`, `PROP1`, `PROP2`, `EG1`, `EG2`, and `NSV`, and show colored conductors entering a hydraulic example. **DOC-CONFIRMED:** these identifiers occur on the printed example. **UNKNOWN:** the electrical truth table, diagnostic semantics, actual sensor wiring and hydraulic response of an arbitrary installed machine. Do not infer that `PROP1`/`PROP2` are the only hazardous outputs or that the five contact pairs are five independently monitored shutdown channels. A diagram without the exact selected hardware, electrical cabinet and hydraulic manifold identity is a *source example*, not a commissioning witness.

## Claims ledger

| ID | Finding | Class | Evidence / limit |
|---|---|---|---|
| AKFR-01 | Reads valve position indicators and pressure sensors | DOC-CONFIRMED | German doc 1257 p. 2; English doc 1264 p. 2 |
| AKFR-02 | AKAS-F checks valve operation and commands safe release through AKFR | DOC-CONFIRMED | Both p. 2; no internal diagnostic algorithm supplied |
| AKFR-03 | Five potential-free N.O. safety contacts documented | DOC-CONFIRMED | Both p. 2–3; **not** five independent hydraulic channels |
| AKFR-04 | Overview omits pressure sensors; translation says 'contactor' where original says 'valve' | DOC-CONFIRMED | Manufacturer overview and original/translation p. 2 |
| AKFR-05 | Connection drawing labels valve release | DOC-CONFIRMED | Both p. 3, visually inspected |
| AKFR-06 | Exact contact loads, pressure taps, valve position targets, feedback independence, hydraulic fail state, firmware/configuration | UNKNOWN | Requires selected-machine schematic and component evidence |
| AKFR-07 | One plausible pressure input can coexist with hazardous pressure elsewhere or beam drift | INFERENCE | Credible topology-dependent possibility, **not TEST-CONFIRMED** |
| AKFR-08 | Machine PL/SIL, stop distance, holding, maintenance isolation | UNKNOWN | Requires design-specific SRS and physical validation |

## Authority chain and the limits of evidence

**Normal control:** LinuxCNC/HAL/ordinary FPGA requests motion and may record diagnostics; not personnel-safety authority. **Safety-related decision:** selected AKAS-F/AKFR arrangement interprets its specified protective demands and configured valve/pressure inputs; actual channel diagnostics and fault handling remain UNKNOWN without selected configuration. **Output:** AKFR safety-release contacts energize whichever valve/contactor circuits are actually wired; contact state is not hydraulic state. **Feedback:** a valve-position indicator proves only the relevant monitored element's position to the extent supported by sensor linkage/diagnostics; a pressure sensor proves pressure at its actual tapping point, not every trapped volume. **Physical proposition:** independently establish required ram/beam stopping, holding/restraint, pressure disposition, and absence/control of credible alternate energy paths.

An expected valve indication and a low pressure reading can both be genuine while an accumulator, another cylinder chamber, gravity, leakage or a cross-port path remains hazardous. Conversely, apparent contradiction might be caused by a faulty physical measurement. Resolve witness independence, provenance, calibration and timing before accepting any result. Neither software display nor electrically plausible status alone closes the physical safe-state claim.

## Commissioning contradiction (paper exercise; not an instruction to provoke hazardous motion)

Scenario: after a protective demand, AKFR reports valve feedback consistent with its expected state, and one pressure channel reports a plausible value. An independent beam-position measurement **appears** to show continued motion outside the selected machine's yet-to-be-determined physical acceptance criterion.

1. Record narrow valve and pressure propositions separately from the broader `PHY-*` safe-state claim. Do not erase useful diagnostics.
2. Verify whether the independent position witness is valid: reference, calibration, sampling, timestamp alignment, sensor mounting and independence.
3. If the valid witness contradicts the safety proposition, mark `PHY-*` **NOT ESTABLISHED**, `VAL-*` **FAIL/NOT ACCEPTED**, and hold the relevant rearm/return-to-service gate. Do not choose an invented pressure threshold or blame a particular valve without evidence.
4. Examine actual pressure tap locations, valve spool/seat targets, common 24 V/0 V, shared pilot supply, hydraulic manifold, trapped volumes/accumulators, gravity, bypasses, replacement wiring and the real loads on the five contacts.
5. Preserve maintenance isolation and positive mechanical restraint as separate requirements. With the minimum safe-to-operate proposition unproved, no people may be exposed; diagnosis is isolated/remote with people outside the danger zone and residual risk stated.
6. Open `UNK-*` for missing machine facts, `DEP-*` for common causes, `HF-*` for bypass incentives, and `CHG-*` after material changes; revalidate affected downstream evidence.

### Adversarial variants

- Pressure sensor is upstream of a blocking valve while downstream chamber remains pressurized.
- Two apparent sensors share the same physical reference or signal conditioning.
- Replacement AKFR wiring assigns an enable contact to the wrong circuit.
- Five contacts all affect a common manifold, not five independent energy-removal paths.
- Fault indication is so difficult to diagnose that technicians habitually defeat a guard: redesign access/diagnostics to make safe restoration the easiest path.

## Qualification handoff and decision

Use the **eight-field final-element record**: (1) commanded action `SRS/AUTH`; (2) exact physical final element `AUTH/ARC`; (3) sensor and exact target `PHY/VAL`; (4) narrow proposition and nonclaims `PHY/SRS/VAL`; (5) dependencies/CCFs `DEP/ARC/VAL`; (6) residual energy `PHY/SRS/ARC`; (7) independent machine witness `PHY/VAL`; (8) maintenance isolation/blocking `SRS/AUTH/ARC/VAL`. Record mode/configuration, manufacturer document identity, actual contact-to-load map, pressure tapping points, measured acceptance and unresolved `UNK-*`. Mark dependent evidence `STALE` on change.

**Freeze decision:** generic schematic NOT FROZEN; selected-machine hydraulic truth table, pressure limits, stopping distances, integrity targets and proof intervals UNKNOWN. No compute lab: the present unresolved question is physical architecture/documentation, not software behavior.

**Fresh-AI transfer question:** A technician shows five AKFR output LEDs, a pressure gauge near the pump and a closed guard. Does this prove a safe maintenance entry? **No.** Identify the actual downstream contact loads, all hazardous volumes, pressure-tap coverage, independent beam/load restraint and lockable isolation; distinguish production protection from servicing.

**Next evidence:** selected AKFR/AKAS hardware revision, matching manuals, safety configuration, terminal-to-valve schematic, actual hydraulic diagram and sensors, pressure tap/accumulator map, gravity/holding mechanism and independent witness plan. If absent, preserve UNKNOWN and do not operate with people exposed.
