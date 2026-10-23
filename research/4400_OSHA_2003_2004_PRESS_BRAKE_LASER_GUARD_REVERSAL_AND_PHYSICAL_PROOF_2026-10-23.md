# 4400 — OSHA press-brake laser-guard interpretation reversal: device eligibility is not machine proof
Date: 2026-10-23 UTC. **Research / source interpretation; not legal advice, machine acceptance, or an external evaluation key.**

## Source provenance and status
- **DOC-CONFIRMED (primary regulatory text):** OSHA 29 CFR 1910.212(a)(1), (a)(3)(ii), current online text: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 . Requires guarding of exposed points of operation; a particular guard technology does not by itself establish coverage.
- **DOC-CONFIRMED (historical interpretation):** OSHA March 10, 2003 memorandum, quoted and described in the February 11, 2004 interpretation below; earlier categorical objection to a particular under-blade laser-guard arrangement.
- **DOC-CONFIRMED (subsequent correction):** OSHA February 11, 2004 letter, https://www.osha.gov/laws-regs/standardinterpretations/2004-02-11 . OSHA rescinded the March 2003 memorandum *to the extent* it treated laser guarding as inherently prohibited for hydraulic press brakes. It did **not** approve or certify the device, installation, or machine.
- **DOC-CONFIRMED (follow-up and scope warning):** OSHA March 25, 2004 archived interpretation, https://www.osha.gov/laws-regs/standardinterpretations/2004-03-25-0 . It says suitability depends on whether the device, in conjunction with the specific hydraulic press brake and worksite use, effectively and reliably prevents injury; timely ram stopping before contact is material. OSHA labels this page archived and potentially no longer current policy.
- **DOC-CONFIRMED (application guidance, historical):** OSHA CPL 02-01-025 dated 1997-02-14, https://www.osha.gov/enforcement/directives/cpl-02-01-025 , covers press-brake point-of-operation guarding and other hazards. Historic safe-distance exceptions are conditional; do not transfer them into a new machine design without current applicability review.
- **DOC-CONFIRMED (scope boundary):** OSHA 29 CFR 1910.217(a)(5), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217 , excludes press brakes from that mechanical-power-press section. Do **not** copy the 1910.217 press-stop formula as an automatic legal press-brake acceptance criterion. Determine the selected current standard and applicable design method first.

## The apparent contradiction is historical, not a design license
A reader finding the March 2003 rejection alone might conclude *all* laser guarding on hydraulic press brakes is forbidden. A reader finding only the February 2004 correction might conclude a laser device is approved. **Both are wrong.** The later interpretation permits consideration of laser safeguarding **if the installed machine-level protective function is effective and reliable**. The letter is a case-specific OSHA interpretation, not a third-party safety-component certificate and not proof of a particular stopping distance or protective coverage.

A press-brake laser can be correctly wired and pass its own internal self-test yet fail to prevent finger entry before hazardous closure. It can also leave secondary hazards: moving-sheet sweep, pinch between workpiece and frame, backgauge motion, side/rear access, ejecta and trapped-person escape. These require separate `HAZ/SF/PHY` entries and selected-machine evaluation.

## Causal evidence chain required for any proposed safeguard
| Stage | Proposition | Evidence that can support it | What it cannot establish |
|---|---|---|---|
| Detection | Selected sensing field detects the defined intrusion for the actual tooling/mode | Manufacturer variant/configuration, coverage map, protected geometry, field observations | Physical ram stop or every adjacent hazard |
| Safety-related decision | Independent safety controller receives a valid demand and withdraws the appropriate enable | As-built safety wiring, verified config, input/output trace, selected device manual | Hydraulic response or mechanical hold |
| Final element | Selected monitored valve/drive/contactors take the commanded protective action | Device-specific physical feedback and qualified test | Beam displacement, pressure in every volume, safe access |
| Physical stop | Ram ceases hazardous movement in time and position for actual exposure | Independent qualified displacement/time witness under specified machine modes/conditions | Continued hold or maintenance isolation |
| Hold and release | Ram remains restrained; safe access and egress are established | Independent holding/guard/escape evidence | Absence of stored hydraulic or gravity energy |
| Maintenance | Each hazardous energy source isolated, dissipated or restrained and verified | Machine-specific LOTO and physical energy-zone verification | Production restart authority |
| Recovery | Reset clears only the appropriate fault and requires a new deliberate start | Independent safety reset test plus ordinary-command retention test | Prior stopping proof after a configuration or hardware change |

**INFERENCE:** Passing the first three rows is insufficient to accept the fourth. A physically observed ram movement after a purported safe stop is a contradiction, not a nuisance alarm to acknowledge away.

## What to collect before any physical test is even designed
1. Exact machine identity, tooling, front/side/rear access, operator tasks and exposure envelope. Include setup, production, jam clearing, tool change and maintenance separately.
2. Selected laser variant/manual revision, field/muting/blanking configuration, tool-change method and any reduced-speed mode; selected safety controller/firmware and I/O mapping.
3. Electrical and hydraulic **as-built** drawings, including all relevant valve types, pilot paths, accumulators, cylinder chambers, gravity restraints, relief paths and independently isolatable pressure zones.
4. Measurable selected-machine acceptance propositions and their authoritative basis, instrumentation/calibration, expected uncertainties and failure/stop response; **no numeric limit is supplied by this research**.
5. Authorized isolated/remote validation method with people outside danger zone; prohibit exposed operation until minimum protective proof is actually complete.

## Adversarial review / information-gain decisions
- **False shortcut A:** “OSHA said laser guards are permitted, so this one is compliant.” Reject: category eligibility is not installed protective performance.
- **False shortcut B:** “The AKAS self-test passed, therefore the press stops soon enough.” Reject: self-test is not an independent ram-motion witness.
- **False shortcut C:** “The operator can keep hands clear.” Reject: actual foreseeable tasks and incentives to bypass must be considered; redesign awkward guard/fixture workflows rather than assuming ideal compliance.
- **False shortcut D:** “Use the 1910.217 formula.” Reject: wrong regulatory machine scope without a separate justified engineering applicability analysis.
- **False shortcut E:** “One fast no-load stop proves all modes.” Reject: selected speeds, tooling, load, sensing configuration, hydraulic temperature and fault cases require a justified coverage matrix. The matrix and numeric acceptance criteria remain **UNKNOWN** pending machine data.

## Durable curriculum disposition
- **DOC-CONFIRMED:** OSHA's interpretation history and scope; `1910.212` guarding obligation.
- **INFERENCE:** the staged causal-evidence matrix and suggested data-intake procedure.
- **UNKNOWN:** selected machine, present OSHA interpretation applicability to a specific installation, current consensus-standard clauses not independently inspected, sensor geometry, actual stopping behavior, pressure/holding and reset behavior.
- **TEST-CONFIRMED:** **none**. All physical `VAL/PT` are **NOT RUN**. No PL/SIL, stopping distance or hydraulic truth table has been assigned.
- **Operational restriction:** no personnel-exposed hazardous operation while minimum protective function is unproved; isolated/remote investigation only, with people outside the hazard zone and residual risk reviewed.

Cross-reference `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` (stable `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/VAL/PT/HF/CHG/UNK/RR` IDs) and `safety-course/4400_HYDRAULIC_PHYSICAL_WITNESS_WORKED_PACKAGE_2026-10-22.md`. This note adds **historical source reconciliation and explicit safeguard-category-versus-physical-proof distinction**, not another fictional circuit.
