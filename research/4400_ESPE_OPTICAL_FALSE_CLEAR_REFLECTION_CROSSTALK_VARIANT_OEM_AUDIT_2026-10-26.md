# 4400 ESPE-OPT-01 — optical false-clear from reflections, crosstalk, and installation geometry

**2026-10-26 | OEM primary-source investigation | DOCUMENTARY ONLY / NOT SELECTED-MACHINE VALIDATION**

## Engineering question and novelty check

Can a safety light curtain report a clear/ready field even though an appropriately sized obstruction is present? **Yes, under the optical-short-circuit failure mechanisms described by the examined manufacturers.** Electrical OSSD diagnostics, a green HMI, and nominal resolution do not alone establish actual optical detection at every protected location.

**Novelty boundary:** Earlier [SICK S3000 scanner optical shadow/front-screen study](4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md) already documents reflection/occlusion for a *laser scanner*. Earlier [SICK C4000 Standard/Advanced blanking study](4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md) covers intentional *configuration* holes/effective resolution; [press-brake optical guarding scope study](4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md) covers hazard reach and late detection. **This audit is narrower and distinct:** unintended *optical* bypass of a light curtain due to shiny material, sensor orientation, nearby emitters and corner-mirror geometry, including an exact-model formula-transfer trap. No novel generic 'optics can fail' claim.

## Primary manufacturer sources actually opened

1. **Banner Engineering, SLC4 Safety Light Curtain Instruction Manual**, original instructions **204371 Rev. E, 1 August 2022**, 55-page manufacturer PDF, printed pp. **16–19, 26–29**. Direct PDF: https://info.bannerengineering.com/cs/groups/public/documents/literature/204371.pdf . §§4.5.1–4.5.4, 5.3.2–5.3.5. Directly inspected manufacturer text and original diagrams.
2. **SICK, C4000 Select Safety Light Curtain**, operating instructions **8012247/YU76/2016-03-14**, 104-page manufacturer PDF, printed pp. **39–41**, §§5.1.5, 5.2. Direct PDF: https://www.sick.com/media/docs/9/49/649/Operating_instructions_C4000_Select_Safety_Light_Curtains_en_IM0027649.PDF .
3. **SICK, senSe2 Safety Light Curtain**, operating instructions **8027557/2022-11-11**, 76-page manufacturer PDF, printed pp. **19–21**, §§4.3.3–4.3.4. Direct PDF: https://www.sick.com/media/docs/6/46/746/operating_instructions_sense2_safety_light_curtain_en_im0103746.pdf .
4. **Leuze, electro-sensitive protective devices — specialist knowledge**, manufacturer explainer, https://www.leuze.com/en-au/contact-and-support/specialist-knowledge/safety-at-work/functions-and-applications-of-protective-devices/electro-sensitive-protective-devices . This supports the mechanism but is not a selected product manual and is not used to override the three exact OEM manuals.

All OEM manuals are **DOC-CONFIRMED for the named product/edition**, not a claim that the sensor is installed on OpenPressBrake. The ISO/IEC standards referenced *inside* OEM manuals were **not** directly inspected for this audit.

## Causal evidence table

| ID | Direct source location | OEM fact (DOC-CONFIRMED, scoped) | Engineering failure proposition / limit |
|---|---|---|---|
| OPT-01 | Banner SLC4 §4.5.1 printed p.16 | Glossy machine paint, workpieces, table, floor or walls can reflect beam(s) around an object; the manual calls this an **optical short circuit**. The receiver may continue to show clear while a nominal-resolution object passes. | **INFERENCE:** 'green OSSD' is compatible with an undetected obstruction if the optical path is bypassed. Not evidence of any installed failure. |
| OPT-02 | Banner SLC4 §5.3.5 printed pp.28–29 | OEM requires a correctly sized test piece swept near emitter, near receiver and at midpoint; with mirrors, test **each leg**. The blocked indication must persist throughout obstruction. Failure prohibits use. | Passing one test point or checking OSSD voltage alone cannot validate full sensing coverage. A documentary plan is not a TEST-CONFIRMED result. |
| OPT-03 | Banner SLC4 §4.5.3 printed p.18 | Emitter/receiver must be parallel and oriented with cable ends pointing the same way; opposite-end orientation can create sensing **voids** even though some beams align. | Sensor replacement/re-mounting is a safety change, not cosmetic maintenance. |
| OPT-04 | Banner SLC4 §4.5.4 printed p.19; SICK senSe2 §4.3.4 printed pp.20–21 | Adjacent light curtains can interfere/crosstalk. Banner warns unintended synchronization; SICK warns one emitter may affect another receiver. OEM describes reversed transmission or optical barriers as possible mitigations. | 'Each curtain works by itself' is not evidence that adjacent pairs work simultaneously. Exact model-specific remedies must be reviewed, not improvised. |
| OPT-05 | Banner SLC4 §4.5.2 printed p.17 | Corner mirrors reduce optical range (manual says approximately 8% per glass mirror for its examined family); improper angles may create **false proxing** or optical short circuits. Manual prohibits mirrors where they permit undetected entry. | No mirror count, angle, range, or numerical transfer to another model without OEM and as-built evidence. |
| OPT-06 | SICK C4000 **Select** §5.1.5 printed p.39, table 19 | For **that edition**, reflective-surface clearance: **131 mm** at D ≤ 3 m, and approximately **43.66 D mm** at D > 3 m (D in meters; model/range caveats apply). | Numerical illustration only, NOT a generic rule and NOT a selected-machine acceptance criterion. |
| OPT-07 | SICK **senSe2** §4.3.3 printed p.20, table 2 | For **that different edition**, clearance: **262 mm** at D ≤ 3 m, and approximately **87.49 D mm** at D > 3 m. It includes horizontal, vertical, diagonal and end-of-field clearance and dispersive media. | Same manufacturer does **not** imply interchangeable clearance formula. At 2 m the two printed minima differ by a factor of two. This is an **exact-device transfer trap**, not a calculation for OpenPressBrake. |
| OPT-08 | SICK C4000 Select §5.2 printed p.40 | Sender/receiver not parallel or mounted 180° opposed can invalidate rectangular field; OEM also addresses under/over/around access. | Mechanical installation geometry is part of protective coverage, separate from downstream stop logic. |
| OPT-09 | Banner SLC4 §5.3.2 p.26 and §5.3.5 pp.28–29 | Manufacturer specifically calls for checking reflective workpieces and performing the trip test with an especially reflective workpiece in place. | **INFERENCE:** a polished die or stock change may invalidate a prior optical validation even when wiring/configuration are unchanged. |

## Architecture / fault chain

`Reflective/adjacent emitter/incorrect orientation or mirror -> optical beam bypass or void -> receiver sees apparent clear -> OSSD(s) remain permitted -> safety controller sees valid 'clear' input -> no optical demand to independent stopping elements -> person may reach moving tooling`.

This is a **detection failure**, not proof that a safety relay, LinuxCNC, FPGA or hydraulic valve malfunctioned. Independently correct stop/hold equipment cannot stop on an intrusion it never detects. The protective design therefore needs **both** credible detection/coverage **and** independently effective stopping/holding; neither alone is sufficient.

A second, separate hazard path is `curtain correctly detects intrusion -> independent stop command -> ram continues due to inadequate stop/hold`. Optical trip tests do **not** establish hydraulic stopping time, gravity-load holding, stored-energy isolation, personnel-clear restart or a PL/SIL value.

## Human factors and inexpensive practical engineering

- Treat shiny dies, polished stock, foil, metal bins, stainless guarding, reflective paint, nearby second curtains and temporary material racks as **normal foreseeable shop changes**, not exotic abuse. Make the protected optical corridor visually obvious and keep reflective storage out by convenient rack placement, guards or durable markings.
- Choose sensor brackets with unambiguous keyed orientation, cable-end labels and retained settings. Prefer fixed mechanical geometry and accessible cleaning/test points over a complicated alignment ritual that encourages bypass.
- Keep the manufacturer's test piece captive near the sensor or maintenance station; provide a short, readable no-energy preflight and an explicit 'FAIL = do not operate' path.
- A change to dies, workpiece finish, guarding, adjacent optical system, sensor type, alignment, mirrors or floor/wall finish should trigger optical coverage review. Do not treat green LEDs as the acceptance test.
- Avoid using a reflective shield or software filter to conceal a failed sensing field. Where the OEM's prescribed geometry cannot be maintained, redesign physical guarding/coverage or prohibit personnel exposure.

## Claims, unknowns and evidence requirements

- **DOC-CONFIRMED:** OPT-01 through OPT-09 within named manufacturer manual/edition scopes; specific model formulas intentionally kept separate.
- **SOURCE-CONFIRMED (LinuxCNC):** none newly traced; normal LinuxCNC status is not independently safety-rated by these sources.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** changed reflective stock, adjacent light curtains, or mount orientation can invalidate a previous machine optical-coverage claim; optical and physical stopping require separate witnesses.
- **UNKNOWN:** whether OpenPressBrake has a light curtain, exact sensor/firmware, separation D, reflective geometry, other optical sources, guarding modes, actual stop/hold and PL/SIL, qualified reviewer, test-piece results, and independent competency score.
- **Release:** G0/G1 **HOLD**, G2 **NOT RUN**, G3/G4 **NOT AUTHORIZED**, G5 **HOLD**. No personnel-exposed operation, energized optical trip test, or physical-machine test authorized by this audit. Qualified isolated/remote validation only after proper documentary and physical risk controls.

## Reopen condition

Exact selected-device type plate, current OEM manual/revision, as-built layout and reflective material inventory, adjacent emitter/mirror layout, safety function/stop/hold architecture, qualified no-exposure test plan and independent physical witnesses. Until then this is a source-grounded teaching example, not an installation design or release.
