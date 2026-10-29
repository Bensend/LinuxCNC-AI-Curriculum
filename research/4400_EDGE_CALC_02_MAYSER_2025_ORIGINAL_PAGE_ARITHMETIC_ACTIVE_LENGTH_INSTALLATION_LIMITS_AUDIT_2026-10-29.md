# 4400-EDGE-CALC-02 — Original Mayser 2025 SL NC II manual resolves excerpt provenance and exposes active-length/installation exclusions

**2026-10-29 | Original OEM PDF text + page-image audit | NON-GRADUATED | NO PHYSICAL TEST / NO MACHINE RELEASE**

## Incremental evidence and predecessor

This is a **direct-original-source upgrade**, not a new safety-edge competency. The predecessor [EDGE-CALC-01](4400_EDGE_CALC_01_MAYSER_NCII_OVERTRAVEL_EXAMPLE_ARITHMETIC_AND_SYSTEM_RESPONSE_AUDIT_2026-10-29.md) checked arithmetic against an indexed **050320 v2.11-RiA** catalogue excerpt but could not open the complete PDF. The new evidence is an independently opened **28-page original manufacturer product-information PDF**, edition **080925 v2.13-RiA**, and visual inspection of its printed pages 6, 8 and 17. A complete byte hash could not be obtained: the available web PDF reader rendered the original, but the container could not download it. Distinguish **directly rendered page proof** from immutable-byte proof.

**Exact original source:** Mayser GmbH & Co. KG, *Normally closed safety edges SL NC II — Product information*, footer **080925 v2.13-RiA**, https://www.mayser.com/media/1769/download/PI-SL%20NC%20II_EN.pdf?v=3 ; accessed 2026-10-29. Original PDF web-reader reference: printed p.17/28 (PDF page index 16), p.8/28 (index 7), p.6/28 (index 5). The PDF was opened and page 17 visually inspected; this is **DOC-CONFIRMED from original manufacturer-rendered pages**, not merely a search snippet. Earlier catalogue **050320 v2.11-RiA** remains a separate edition, not silently replaced.

## Original 2025 printed arithmetic: mismatch persists

Printed example 1 on p.17/28 states **v = 10 mm/s**, **t1 = 1300 ms**, **t2 = 250 ms**, **T = 1.55 s**, **s1 = (1/2) × v × T**, **C = 1.2**, printed **s1 = 6.55 mm** and **s = 7.86 mm**; selected profile **GP 48-2 NBR** overtravel **12.4 mm**.

| Quantity | Original 2025 printed value | Independent arithmetic from printed inputs |
|---|---:|---:|
| T | 1.55 s | 1.300 + 0.250 = **1.550 s** |
| s1 | 6.55 mm | 0.5 × 10 × 1.55 = **7.75 mm** |
| C × s1 | 7.86 mm | 1.2 × 7.75 = **9.30 mm** |
| Margin to quoted 12.4-mm profile | 4.54 mm | **3.10 mm** |

**DOC-CONFIRMED / INDEPENDENT ARITHMETIC-CONFIRMED:** the arithmetic discrepancy exists on the directly rendered original **v2.13** page, not just the older indexed excerpt. The 7.86-mm product is internally consistent with the incorrect 6.55-mm intermediate; it is not an independent multiplication error. Under the *printed OEM formula* and stated 12.4-mm overtravel, the example's selection result remains arithmetically above 9.30 mm. **Do not infer that the profile is safe for a particular machine.** The manufacturer's intended derivation, force–compression curve, time-history assumptions, and any erratum are **UNKNOWN**. Do not assert the manufacturer has issued or accepted a correction.

**Separate model-assumption warning:** The printed `0.5 × v × (t1+t2)` is not a general integral of velocity if there is an initial constant-speed detection delay followed by braking. Under a *hypothetical* constant v during 1.3 s and uniform deceleration over 0.25 s, displacement would be `v×t1 + 0.5×v×t2 = 14.25 mm`, and `C×distance = 17.10 mm`, exceeding 12.4 mm. This is a **counterexample to treating the printed equation as a universal kinematic law**, **not** a valid replacement for the OEM method or a finding that the product fails. The 1300-ms term can reflect a dynamic sensor actuation process; actual profile/force behavior and stopping trajectory require manufacturer interpretation and qualified machine validation.

## Distinct, newly original-page-confirmed geometry and service restrictions

1. **Printed p.8/28, effective length:** `L_WB = L_SL − 2×L_NE`. For **GP 48-2 NBR**, `L_NE=50 mm` at **each** end, so a hypothetical **1000-mm** installed edge has **900 mm** of effective actuation length *before* further geometry/angle constraints. This is an **illustration**, not an actual installed device. **DOC-CONFIRMED** page table and formula; the 900-mm arithmetic is independent.
2. **Printed p.8/28, actuation angle:** GP 48-2 **NBR** effective angle is **60°**, whereas the **EPDM** variant is shown as **90°**. Mayser explicitly states that the NBR angle is below ISO 13856-2 and EN 12978 requirements; do not silently transfer a profile's geometric suitability to another material or claim a complete ISO conformity verdict.
3. **Printed p.6/28, installation and use exclusions:** the SL NC II family is **not suitable** for **installation position D (vertical)**, high vibration, or continuous sealing compression; the OEM caps series connection at **10 sensors**. This is a manufacturer product-specific exclusion, not a general ban on vertical protective devices.
4. **Printed p.11/28, protected wiring:** the manufacturer requires fixed, protected cable routing and separated sheaths when protection is otherwise impossible, to prevent line termination/loss of protective function and degraded classification.
5. **Printed p.19/28, maintenance:** inspect at least **monthly**, depending on use, for operation, damage and fixing. “Virtually maintenance-free” is not “inspection-free.”
6. **Printed p.20/28, response-time context:** the technical table lists **60 ms** at **v_test = 200 mm/s** for GP 48-2 NBR, whereas example 1 uses **1300 ms** at a much slower 10 mm/s. These values refer to different actuation conditions and must not be swapped to shorten a safety calculation.

## Practical design consequence / adversarial review

An edge that appears to cover a one-meter closing lip may have at least 50 mm of non-sensitive length at **each** end for this selected profile. A user could hit an unprotected corner while a midspan test still passes. Recessed mounting, stock geometry, pinch direction, and approach angle can create additional blind regions. The simpler safe design is a positively located, easily inspectable mounting profile with an explicit corner/side-approach hazard review and replaceable protected wiring; do not “solve” nuisance trips by tying off, taping or bypassing the sensor. Do not assume a tactile edge is suitable for a press-brake point of operation: if residual travel/force cannot be made acceptable, use independent exposure-prevention safeguards.

**Qualified selected-machine evidence chain (all UNKNOWN):** exact edge profile/material/edition and wiring; installed orientation; end positions and corners; effective sensing region; independent safety-logic and physical stop/hold final elements; actual response/force and residual travel; reset/occupancy/fresh start; change/maintenance history. An as-built drawing alone does not prove those physical propositions. Any replacement of NBR with EPDM, shortening, relocation, addition of a shield, or controller timing change creates `CHG` and invalidates dependent `CALC/VAL/PT` until reviewed. Do not ask an unqualified person to place a body part in the hazard or run an energized test.

## Claim ledger and release

- **DOC-CONFIRMED:** original Mayser v2.13 printed pp.6/8/11/17/19/20, accessed 2026-10-29 via manufacturer-hosted PDF; exact URL above. Edition footer and example values visually verified for pp.6/8/17.
- **SOURCE-CONFIRMED:** no LinuxCNC source claim in this OEM review.
- **TEST-CONFIRMED:** **none**; arithmetic and paper geometry checks are not machine tests.
- **INFERENCE:** hypothetical piecewise kinematics, corner exposure and bypass incentives.
- **UNKNOWN:** byte-identical PDF hash, manufacturer erratum/intent, actual OpenPressBrake sensor selection, selected force/stopping characteristics, physical validation, independent evaluator result.
- **No workflow, simulation, build, machine test or hazardous operation; hosted/self-hosted compute 0/0 min.** Independent 2520–25F0 evaluation remains OPEN; **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. No personnel-exposed hazardous operation.

**Next discriminator:** seek OEM clarification of the persistent printed arithmetic and the simplified kinematic model; only after exact installed machine selection may qualified reviewers assess actual edge placement, full safety path, physical stop/force and restart. This documentary correction does not reopen graduated courses or authorize a new lab.
