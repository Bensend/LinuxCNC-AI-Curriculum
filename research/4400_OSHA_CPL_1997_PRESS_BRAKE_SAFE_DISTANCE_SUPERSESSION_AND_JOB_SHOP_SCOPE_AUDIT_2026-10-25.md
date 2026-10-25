# 4400-GUARD-01 — Original 1997 OSHA press-brake safeguarding directive and supersession audit
**2026-10-25 | regulatory/OEM research | NON-GRADUATED | selected OpenPressBrake UNKNOWN**

## Evidence question
Can a retrofit press brake or job shop replace physical safeguarding with a claimed generic “safe distance,” and which historic OSHA documents control that claim? This is a **source/edition and human-factors** question, not a physical safety test.

## Direct primary source
- **DOC-CONFIRMED, original full five-page text inspected:** OSHA Instruction **CPL 2-1.25 / CPL 02-01-025**, dated **1997-02-14**, *Guidelines for Point of Operation Guarding of Power Press Brakes*, official state-government-hosted original: https://www.labor.nc.gov/osh/osh-enforcement-procedures/cpl-02-01-025-cpl-2-125-guidelines-point-operation-guarding-power-press-brakes/open ; parallel OSHA directive listing https://www.osha.gov/enforcement/directives/cpl-02-01-025 . PDF pp. 1–4 sections D, E–K, O; p.5 federal-state-plan implementation.
- **DOC-CONFIRMED regulatory text (OSHA indexed):** 29 CFR 1910.212 machine guarding; 29 CFR 1910.147(d)(5) hazardous stored/reaccumulating energy and (d)(6) authorized-employee verification: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 .
- **DOC-CONFIRMED historical correction:** OSHA's 1986 *Safeguarding of power press brakes and a definition of “Safe Distance”* is explicitly edited in 2002 to direct readers to the **1997** instruction: https://www.osha.gov/node/30001 . The 1997 instruction §O expressly **cancels the 1978 STD 1-12.12 and rescinds the 1983 job-shop memorandum**. Do not cherry-pick their older dimensions, exceptions or training criteria as current rules.
- **DOC-CONFIRMED applicability boundary:** OSHA 1991 interpretation distinguishes power press brakes under **1910.212** from mechanical power presses under **1910.217**: https://www.osha.gov/laws-regs/standardinterpretations/1991-11-07-0 . The OSHA mechanical-power-press safety-distance formula is **not automatically** a hydraulic press-brake rule. ANSI B11.3-2022 publisher scope was separately audited in [RESCUE-01](4400_PRESS_BRAKE_TYPE_C_SCOPE_AND_TRUBEND_ESTOP_RESCUE_CONFLICT_AUDIT_2026-10-25.md); 1997 instruction cites B11.3-1982, **not** the full 2022 normative text.

## Exact 1997 findings — scope matters more than a number
1. **§D.5–6 (pp.1–2):** OSHA's “safe distance” enforcement alternative is **conditional on demonstrating physical barrier/device infeasibility**, plus qualifying one-time/custom or defined small-quantity work, documented program, training/supervision and safe-work history. It is **not** the preferred default for a new retrofit.
2. **§D.6.b (p.2):** Directive's small-quantity definition includes repeated pieces in a continuous timeframe of **no more than four hours per month**; this is an edition-specific enforcement definition, **not** a universal engineering allowance or blanket exemption.
3. **§D.7 (p.2):** the directive contains a **4-inch** conditional minimum in its particular program. It even prints **10.16 cm** and **10.6 cm** for the same four-inch figure — an internal metric transcription inconsistency. Do not use this as a modern minimum safety distance, stop-distance calculation, or OpenPressBrake safe-access criterion.
4. **§D.1–4 (pp.1–2):** nearby employees/helpers, non-point-of-operation exposures and servicing require **separate** protection; a hypothetical hand position at the front die does not protect a helper at the rear backgauge or a technician under a gravity ram.
5. **§F–J (pp.3–4):** written exposure procedure, actual operator/helper competency, part-specific whip/tooling risk, supervision, retraining and at least **annual** inspection by a trained person other than the user are part of this conditional historical enforcement route.
6. **§O (p.4):** express supersession means the old 1983 permissive language cannot silently override the 1997 conditions. **§P (pp.4–5):** state plans may adopt their own implementation; selected jurisdiction and current applicability must be separately verified.
7. **OSHA 1910.147:** servicing energy control remains a distinct requirement; the alternative does **not** authorize servicing under a ram on the basis of a front-hand clearance.

## Adversarial contradictions
| Claim | Source-grounded correction |
|---|---|
| “The 1986 OSHA letter says six inches, so that is our safe guard distance.” | Historical letter directs to 1997 instruction; older and newer distances conflict. Neither gives this retrofit's measured stopping/approach distance. |
| “1997 says four inches, so a four-inch gap is compliant.” | Four inches is a **conditional enforcement program limit**, not an independent machine safety proof. Physical feasibility, actual application, exposure and current rules remain unresolved. |
| “We make one-off parts; physical guards are optional.” | One-off status does not itself demonstrate device infeasibility or protect helpers, backgauge and maintenance zones. |
| “Our laser says SAFE; the press can run.” | Requires installed coverage, muting/blanking, reaction time, independent Y1/Y2 stop/hold, actual guard geometry and deliberate rearm evidence. |
| “We have a good safety program; we can service under the ram.” | Maintenance needs qualified isolation, gravity restraint and stored-energy verification; front point-of-operation production rules do not cover it. |

## Claims and limitations
- **SOURCE-CONFIRMED:** no new LinuxCNC implementation trace; prior pinned normal-control source studies stand.
- **DOC-CONFIRMED:** the original 1997 directive and cited OSHA sources only, within their historical/regulatory scopes.
- **INFERENCE:** prioritize low-friction physical safeguards and engineering change rather than exploiting an administrative exception.
- **UNKNOWN:** selected state-plan/adopted standard, exact OpenPressBrake machine class/guard variants, stopping time/distance, front/rear coverage, operating modes, physical hold, PL/SIL and independent evaluation.
- **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on.

**Consequence:** Keep G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED until selected as-built review and independent physical evidence. Do not operate with people exposed to unproven hazards; isolated/remote development needs separately qualified exclusion and residual-risk controls. No hosted or local lab needed to answer this source question.
