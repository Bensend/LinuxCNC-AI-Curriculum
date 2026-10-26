# LASER-ENC-01 — embedded high-power laser, housing, viewport and service-access safety
**4400 safety source audit | 2026-10-26 | DOC-CONFIRMED scoped | NON-GRADUATED**

## Question and novelty
Can a CNC retrofit rely on the original machine's Class I label, a generic clear window, a LinuxCNC M-code OFF bit, or an operator's key to authorize access after changing a laser enclosure? **No such transfer is established.** The safety-course index and research plan were searched for `laser radiation`, `laser class`, `laser enclosure`, and `laser safety` before this work: no dedicated laser-radiation course branch was present. This is a **4000 safety-function boundary**, not renewed 3300 plasma/laser/waterjet specialization.

## Directly inspected primary evidence (2026-10-26)
1. **U.S. eCFR 21 CFR §1040.10**, https://www.ecfr.gov/current/title-21/chapter-I/subchapter-J/part-1040/section-1040.10 , displayed up to date **2026-10-22** (last amended 2026-10-21). Relevant exact subsections:
   - **(b)(5), (b)(11), (c)(1)**: product class depends on *accessible* radiation during operation; Class IV means hazardous accessible emission, not merely the existence of a Class IV-capable source inside a housing.
   - **(b)(15)**: human access for products containing Class IIIb/IV radiation includes direct reflection by a single introduced flat surface through an opening. A shiny workpiece or open service port can invalidate a simplistic straight-beam-only assumption.
   - **(e)(1)–(2)**: classification/compliance evidence must consider uncertainty, aging, maximum-access configurations, start-up/shutdown and relevant service/maintenance; a one-time green software indicator is not an emission measurement.
   - **(f)(1)–(2)**: protective housing and required access-panel interlocks; provisions for single-interlock failure, interlock defeat indication and prevention of panel replacement while interlock is defeated. These are product-standard provisions subject to applicability, not an invented safety PLC wiring diagram.
   - **(f)(3)–(6)**: remote interlock, key control, emission indication and a **separate** beam attenuator requirement for specified classes. A key, laser enable bit or supply contactor is not automatically a beam attenuator.
   - **(f)(8)**: viewing optics/viewports must limit eye-accessible laser and collateral radiation. Clear color, acrylic thickness or green tint alone is not proof of suitability.
   - **(f)(9)**: scanned-laser failure of scan velocity/amplitude has an explicit radiation-access safety boundary; a CNC velocity estimate is not a safety-rated scan safeguard.
   - **(f)(10)**: **Class IV laser systems manufactured after 1986-08-20** require manual reset after remote-interlock interruption or unexpected main-power interruption of **more than five seconds**. This is an exact regulatory scope, **not** a generic five-second LinuxCNC restart timer and not automatically a requirement for an enclosed Class I-classified product.
2. **TRUMPF manufacturer safety article**, *Better safe than sorry: unmasking dangerous lasers*, https://www.trumpf.com/en_US/newsroom/stories/better-safe-than-sorry-unmasking-dangerous-lasers/ (direct manufacturer page, sections “Enclosed beams”, “Hoods for shielding”, “Lasers only seen through protective windows”, “The intervention of light barriers and sensors”, “The clean extraction…”). TRUMPF documents gaps, fake/non-qualified windows, bridged barriers, head hoods, tube-exit strip curtains, material-processing UV collateral emission, fiber delivery connection/damage monitoring and post-service cladding checks. This is manufacturer **design guidance**, not proof of a selected machine's installed safety circuit, spectral attenuation or beam shutdown time.
3. **FDA Laser Notice 56**, February 2023, https://www.fda.gov/regulatory-information/search-fda-guidance-documents/laser-products-conformance-iec-60825-1-ed-3-and-iec-60601-2-22-ed-31-laser-notice-no-56 (direct FDA guidance landing page). FDA identifies IEC 60825-1 Ed.3 provisions comparable to portions of 21 CFR; **not** a blanket equivalence of every clause. Exact applicability and current certification must be reviewed for a real product. FDA FAQ https://www.fda.gov/radiation-emitting-products/electronic-product-radiation-control-program/getting-radiation-emitting-product-market-frequently-asked-questions clarifies manufacturer certification is **not FDA approval**.
4. **OSHA Technical Manual III:6**, https://www.osha.gov/otm/section-3-health-hazards/chapter-6 (official search-indexed excerpts only; direct fetch 403). It describes Class IV direct/diffuse/fire hazards and controlled areas during service. **Not claimed directly inspected**; no normative ANSI Z136 clauses reproduced or asserted.

## Failure-path / authority decomposition
`CNC laser ON command` → ordinary LinuxCNC/HAL/FPGA control only. Independent radiation safety architecture must establish **(A)** access prevented by a physically qualified enclosure (including loading/unloading openings and viewports), **(B)** protective door/panel interlocks and independent beam-inhibiting final elements, **(C)** physical attenuation/shutter/source-safe state after safety demand, **(D)** controlled and indicated authorized service bypass if applicable, **(E)** no surprise re-emission on reset/power restoration, and **(F)** separate motion, fire/fume and maintenance-energy controls. No single M-code, HMI icon, window color, key switch or interlock-contact LED proves A–F.

**Distinct fault examples:**
- **Reflective material:** normal cutting path is shielded but a newly loaded flat polished sheet sends a specular reflection through an unintended aperture. Inspect optical geometry, not only normal beam travel.
- **Service replacement:** transparent generic polycarbonate replaces wavelength-rated optical material; the machine appears usable but actual attenuation across source and process-generated wavelengths is unverified. Make exact marked OEM replacement simple and affordable.
- **Defeat/reinstall:** a technician wedges a door sensor for alignment, then replaces the cover without removing the defeat. The regulatory provisions and manufacturer guidance require explicit treatment of defeat indication and reinstall state; do not publish bypass instructions.
- **Control confusion:** LinuxCNC task reports laser OFF or stopped axes while beam energy, shutter state, or optical path is unknown. Ordinary task acknowledgment is not radiation proof.
- **Power interruption:** a held start command resumes after interlock closure. For the scoped Class IV product, §1040.10(f)(10) creates a specific manual-reset requirement; even after manual reset, the complete machine still needs separate deliberate start and independent access protection.
- **Scan head:** galvanometer/sweep failure concentrates exposure; do not substitute CNC feed-rate monitoring for product-specific scan safeguard.

## Practical engineering choice
Favor complete enclosed beam paths, externally loaded/unloaded workpieces, fixed/positively located rated viewports, captive non-defeatable guards where feasible, manufacturer-compatible replacement kits, accessible visual inspection, labeled service procedure and **no automatic beam re-emission** after a safety event. Any needed open-beam service is a separate qualified controlled-area design, not a convenient normal production mode. Glasses/PPE are secondary, wavelength/OD-specific and do not convert an open unverified Class IV beam into acceptable ordinary operation.

## Evidence classification and limits
| Claim | Classification | Scope / remaining witness |
|---|---|---|
| Class I product may contain more hazardous source with accessible radiation controlled by enclosure | DOC-CONFIRMED | 21 CFR (b)/(c); exact assembled-product classification UNKNOWN |
| Reflected path through housing aperture matters | DOC-CONFIRMED | 21 CFR (b)(15); installed reflection geometry UNKNOWN |
| Interlock, viewport, attenuator, reset have distinct provisions | DOC-CONFIRMED | 21 CFR (f); exact applicability/product/validation UNKNOWN |
| Manufacturer documents false glass, enclosure gaps, damaged delivery fiber and service reinspection | DOC-CONFIRMED | TRUMPF article, not selected-machine test |
| Normal LinuxCNC laser command is not independent personnel-safety authority | INFERENCE from control/safety boundary | No new LinuxCNC source trace in this branch; no selected hardware |
| Actual beam shutdown time, wavelength/OD, Class I enclosure proof, PL/SIL, safe distance, restart and smoke control | UNKNOWN | Qualified machine-specific design, laser safety specialist and measured validation required |
| Laser machine physical/evaluator experiment | TEST-CONFIRMED **NONE** | No beam operation, simulation, energized work or external scoring |

**No inference of a laser installed on OpenPressBrake.** This module is a cross-machine 4400 safety branch applicable only where laser emission is actually present; it does not displace the priority selected press-brake G0 physical evidence. **G0/G1 HOLD; no personnel-exposed hazardous operation.**

## Next-work information gain
Existing qualified documents: selected laser system and wavelength(s), actual classification in each operation/service configuration, laser safety officer/risk assessment, enclosure/viewport markings, emission path, safety interlock/shutter architecture, reset/restart, loading openings, service procedure and independent validation plan. No exposure-based experiments authorized by this audit. Cross-compare laser generated fumes/filters as a **separate hazard function**, not a proxy for beam containment.
