# 4400-LC-REFLECT-01 — A clear-looking light curtain can miss an intrusion through reflected or cross-coupled light

**2026-10-29 | 4000 safety | original manufacturer manual source study | NON-GRADUATED | NO PHYSICAL TEST**

## Question, prior-art scan and scope

Can a qualified safety light curtain be assumed to detect a person simply because the sender/receiver are aligned and the OSSD indication is healthy, even after a shiny work table, material bin, weld spark shield or second curtain is installed nearby?

**No.** The manufacturer explicitly documents optical paths that can make an object **not detected**. This is a *different* failure path from the existing 2590 generic safeguard distance, 4400 deTec4 HG muting, S3000 scanner optical shadows and Banner floor-mat step-over lessons. The full safety index, research plan and progress were scanned for `reflective surface`, `retroreflective`, `weld spark guard`, `light curtain reflection`, and related synonyms; no exact deTec4 Core reflective-surface/weld-guard source audit was found. This does **not** assert the installed OpenPressBrake uses deTec4 Core or any light curtain variant.

## Direct original OEM evidence (retrieved 2026-10-29)

1. **SICK AG**, *deTec4 Core — Operating Instructions*, original OEM PDF, document **8014253/1S7O/2025-04-08**, **80 pages**, https://www.sick.com/media/docs/1/11/011/operating_instructions_detec4_core_en_im0048011.pdf . Directly opened full rendered PDF text, verified printed footer on page images (printed pp.20 and 66), and inspected sections **4.3.3 pp.19–20**, **4.3.4 p.21**, **4.4 pp.22–24**, **4.5.1 pp.26–27**, **14.3 p.66**. No immutable PDF byte hash retained, so cite exact visible printed edition/page, not a byte-stable archive.
2. **Rockwell Automation**, *GuardShield Micro 400 Safety Light Curtains — Installation Instructions*, **445L-IN005C-EN-P, January 2024**, original **24-page** OEM PDF, https://literature.rockwellautomation.com/idc/groups/literature/documents/in/445l-in005_-en-p.pdf . Directly opened; printed **p.7** section *Minimum Distance from Reflecting Surfaces* and Table 2 independently warn reflected light can cause an intruding object to go undetected. This is **corroboration of the mechanism**, not permission to exchange product formulas.
3. **OSHA** 29 CFR **1910.212(a)(1)–(3)**, https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 ; general machine and point-of-operation safeguarding requirement, not a selected light-curtain acceptance certificate.

**Evidence labels:** direct OEM statements **DOC-CONFIRMED**, example math below **INDEPENDENT ARITHMETIC**, installed-machine behavior **UNKNOWN**, physical **TEST-CONFIRMED none**.

## Source-confirmed optical failure mechanisms

### 1. Reflections and dispersive media defeat detection, not merely alignment

SICK §4.3.3 pp.19–20 explicitly warns that sender beams may be deflected by **reflective surfaces** and **dispersive media**, potentially preventing detection. It requires clearance **on all sides** of the protected field — horizontal, vertical, diagonal and at the ends — and notes dust, fog and smoke. The manufacturer gives a device/edition-specific rule for **automatic protective-field-width calibration**:

| SICK deTec4 Core sender–receiver distance `D` | OEM minimum distance `a` to reflective surfaces |
|---|---|
| `D ≤ 3 m` | **131 mm** |
| `D > 3 m` | `a = tan(2.5°) × 1000 × D ≈ 43.66 × D` mm, with `D` in m |

**Illustrative arithmetic only:** at **D=5 m**, `a≈43.66×5=218.3 mm`. This is **not** a machine-specific clearance recommendation; real device identification, dimensions, geometry, optical modifications and edition must be established. Do not transfer these figures to a different product, mirror system or configuration.

Rockwell 445L-IN005C printed p.7 independently describes the same reflection/missed-object mechanism and its own table (0–3 m: **135 mm**; 5 m: **220 mm**) for **GuardShield Micro 400**. The near agreement at 5 m is *not* proof of universal equivalence: OEM models, apertures and configuration differ.

### 2. A weld spark guard changes the optical safety geometry

SICK §14.3 p.66 says the **weld spark guard reduces scanning range by 15%**. More importantly, for **30-mm resolution deTec4 Core with weld spark guard**, the reflective-surface clearance calculated under §4.3.3 **must be doubled**. At the purely illustrative D=5 m above, the manufacturer's conditional rule would change `a≈218.3` to **436.6 mm**. **Do not apply this doubling to 14-mm versions or other guards without exact OEM evidence.**

**Adversarial design scenario:** a maintainer adds a protective film/weld shield to preserve optical surfaces, or a metal parts bin is moved close to the sensing plane. The change may increase missed-detection risk even if the ordinary CNC/HMI shows a healthy status. **INFERENCE:** treating such modifications as cosmetic rather than `CHG` events can invalidate earlier coverage checks.

### 3. Adjacent light curtains can interfere with one another

SICK §4.3.4 p.21 states that one curtain's sender can interfere with another's receiver and disrupt protection. It recommends appropriate separation/optical barriers or reversing the direction of transmission by switching sender/receiver positions for one system, subject to qualified installation. This is a distinct failure from a reflective workpiece.

**INFERENCE:** adding a second curtain on the rear of a CNC cell without checking cross-coupling can undermine a previously working front field. No actual interference has been observed or tested in this curriculum.

### 4. A green OSSD during a correctly controlled test is a STOP-WORK result

SICK §4.5.1 pp.26–27 specifies a matching OEM test rod and requires the dangerous state **off and kept off**, with the light-curtain outputs having **no effect on the machine** during component testing. It warns that a **green OSSD indication even briefly during the test** requires work to stop and qualified investigation. It includes edge and mirror-zone coverage, not only the middle of the field.

**This document is not a procedure to perform that test on an operating machine.** The selected-machine G0/G1 hold remains in force; any qualified commissioning procedure must separately establish isolation, exclusion, safe test conditions, competency and independent physical witness. No owner should be asked to break a beam while hazardous motion is possible.

### 5. OSSD and restart authority are downstream safety functions

SICK §4.4 p.22 requires downstream safety processing and notes deTec4 Core lacks an integrated restart interlock. It distinguishes OSSD1/OSSD2 and requires appropriate external control. Therefore:

`optical detection -> two OSSD channels -> independent safety logic -> final elements -> physical stop/hold -> zone clear -> deliberate reset -> separate fresh start`.

**INFERENCE:** a normal LinuxCNC/HAL/FPGA "curtain clear" bit, alignment LED or CNC feed-hold is not a substitute for the independent safety path, physical stopping or restart control.

## Failure-path and adversarial matrix

| Field change/fault | Plausible failure | Provenance | Required review |
|---|---|---|---|
| Shiny metal stock/bin or polished table moved near field | Reflected beam may mask intrusion | **DOC-CONFIRMED** OEM mechanism; installed result UNKNOWN | Recheck exact OEM clearance in all directions; selected geometry/coverage |
| Weld spark guard added to 30-mm deTec4 Core | Old reflective clearance may be insufficient; scan range lower | **DOC-CONFIRMED** 2× clearance and −15% range | `CHG`, model/option verification, qualified revalidation |
| Second adjacent curtain installed | Cross-sender interference can defeat detection | **DOC-CONFIRMED** | OEM-approved separation/orientation, qualified independent check |
| Curtain green/aligned | Misinterpreted as complete hazard protection | **INFERENCE** | Coverage, OSSD safety circuit, final elements, restart and physical proof |
| Test rod borrowed from another curtain | Detection check may not represent selected resolution | **DOC-CONFIRMED** SICK warns against wrong rod | Exact supplied OEM rod; only isolated qualified procedure |
| Film/optical cover changed, dusty/smoky cell | Optical properties/clearance may change | **DOC-CONFIRMED** OEM cautions; exact result UNKNOWN | Maintenance plan and change revalidation, no bypass |
| OSSD green briefly during qualified rod check | Protective field effectiveness not established | **DOC-CONFIRMED** | Stop work, qualified investigation; do not operate |

## Practical human-factors architecture

Use a **physical layout** that makes the protected field easy to see and keep clear: locate bins and reflective fixtures outside the selected OEM exclusion envelope; mark the clearance zone; protect the mounting from knocks; avoid mounting a maintenance bin in the beam corridor; provide simple cleaning and OEM-compatible replacements. Include the weld-shield option and optical surface conditions on the change checklist. A field that regularly nuisance-trips or is hard to inspect is an engineering redesign problem, not permission to defeat the device.

Separate status labels: **optical alignment**, **OSSD state**, **safety-controller demand**, **final-element feedback**, **physical stop/hold verified**, **zone clear**, **reset eligible**, and **fresh start**. Never collapse these into a single "SAFE" HMI light.

## Boundaries and next evidence

- No claim of **SOURCE-CONFIRMED LinuxCNC behavior**: this is manufacturer safety architecture and installation research.
- **DOC-CONFIRMED:** SICK 8014253/1S7O/2025-04-08 pp.19–21, 22, 26–27, 66; Rockwell 445L-IN005C Jan 2024 p.7; OSHA general regulation.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used.
- **INFERENCE:** hypothetical bypass after metal-bin/film/second-curtain changes and human-factor consequences.
- **UNKNOWN:** installed light curtain model, configuration, actual reflective layout, optics, clearance, stop-time, force, physical final elements, reset, selected PL and qualified witness.
- **No selected OpenPressBrake deTec4 claim.** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; independent 2520–25F0 evaluator OPEN.
- **Compute:** zero hosted/self-hosted workflows, zero lab minutes, no physical test. Source/PDF reading only.
- **Next:** qualified Stage A A–G must first identify whether any such ESPE is installed; then review exact OEM model/edition/option, as-built optical geometry, adjacent devices, physical stop/restart and approved isolated validation. Do not request ad hoc energized beam interruption or access to hazardous areas.