# 4400 original-source audit — press-brake ram blocking: deadweight, powered-stroke exposure and scope traps
**Session start:** 2026-10-25T15:33:37.747Z UTC. **Status:** documentary mechanism / standards applicability; **NOT** selected-machine proof or authorization to operate.

## The question
What physically prevents a press-brake ram from descending onto a technician during tooling change, maintenance or emergency rescue, and does a labeled "safety block" or safety relay prove the answer?

**Answer at this evidence level:** a qualified, positively engaged mechanical support or another demonstrably adequate energy-isolation architecture may address the **specified** load path, but its static load capacity, support placement, engagement, ability to withstand accidental powered force, tooling/bed integrity, hydraulic energy and restart prevention are **different propositions**. A normal LinuxCNC stop, E-stop input, valve command, pressure indication, or block-engaged switch alone cannot prove them.

## Source and provenance ledger (retrieval 2026-10-25 UTC)
| ID | Classification and directly supported narrow fact | Original source / scope / access limit |
|---|---|---|
| RB-01 | **DOC-CONFIRMED (OSHA indexed original):** 29 CFR 1910.217(a)(5) explicitly **excludes press brakes** and hydraulic/pneumatic power presses from the *mechanical-power-press* section; §1910.217(d)(9)(iv) mandates safety blocks for dies adjusted/repaired **within its covered scope**. | [OSHA regulation](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217), current page indexed 2026-10-25; direct browser open returned 403. Do not cite the §1910.217 block clause as a blanket press-brake mandate. |
| RB-02 | **DOC-CONFIRMED (OSHA indexed original):** 2007 directive CPL 02-01-043 distinguishes slide locks/safety blocks intended for gravity/deadweight from **powered-stroke dynamic force**. It requires preventing dangerous energization, and treats mechanical blocks/locks as energy-isolating devices under LOTO. Its enforcement-policy discussion addresses mechanical power presses and the appendix discusses broader power-press slide-lock practice. | [OSHA Slide-locks directive](https://www.osha.gov/enforcement/directives/cpl-02-01-043), 2007; original indexed full text, direct open 403. Scope must be reviewed per machine; do not transfer mechanical-press de minimis policy automatically to press brakes. |
| RB-03 | **DOC-CONFIRMED (OSHA indexed original):** 2005 OSHA hydraulic-power-press interpretation rejects inch mode/two-hand controls as substitutes for LOTO during hazardous die service, identifies gravity descent, fluid leakage, dropped tooling and inadvertent foot actuation. | [OSHA 2005-04-22 letter](https://www.osha.gov/laws-regs/standardinterpretations/2005-04-22), original indexed text, direct open 403. This letter concerns **hydraulic power presses**; the §1910.147 hazardous-energy reasoning transfers as an engineering warning, not a press-brake-specific design acceptance. |
| RB-04 | **DOC-CONFIRMED (OSHA indexed original):** 2006 OSHA hydraulic-press letter states safety swing blocks and disconnects may be energy-isolating devices, whereas two-hand/light-curtain control circuits alone cannot prevent hazardous gravity motion. | [OSHA 2006-12-28 letter](https://www.osha.gov/laws-regs/standardinterpretations/2006-12-28), indexed original; direct open 403. Not a selected press-brake test. |
| RB-05 | **DOC-CONFIRMED (OSHA original eTool):** 1910.147 requires shutdown, physical energy isolation, stored-energy restraint/release, independent verification and continued verification where energy can reaccumulate; temporary testing/repositioning requires clearing personnel and re-isolating before service resumes. | [OSHA energy-control procedure](https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition), indexed original. A control-circuit OFF state is not an energy-isolating device. |
| RB-06 | **DOC-CONFIRMED via manufacturer-indexed original text, NOT visually inspected PDF:** Cincinnati Incorporated **BASEFORM 90–175 hydraulic press brake**, manual **EM-558 (N-07-14)**, Section 9 p.9-1: its **specific** LOTO procedure calls for resting ram on closed dies or support blocks and specifies blocks capable of at least **10% of machine capacity without damage**. The same manual separately describes no-power entrapment release, estimated ram weights for two models, qualified lifting/support and multiple pressure test points. It warns options/tooling may add energies and machine-specific procedure is required. | [Cincinnati OEM Section 9 PDF](https://wwwassets.e-ci.com/PDF/Manuals/em_558_n_0714_osmm_90_175bx.pdf) and [full manufacturer PDF](https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-558-n-07-14-90-175-baseform-series-press-brake-operation-safety-and-maintenance-manual.pdf). Search engine extracted manufacturer text; direct PDF open failed due 31 MB size, not a page-visual audit. **10% is an exact OEM instruction for this product family, not a universal support design factor.** |
| RB-07 | **DOC-CONFIRMED (OSHA indexed original):** §1910.147 equipment-specific procedures must identify all hazardous energies and block/secure them. | [OSHA energy-control eTool](https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition). |

### Important source conflict: vendor marketing versus legal scope
A press-block vendor's public page presents OSHA §1910.217(d)(9)(iv) as a universal mandate for press brakes ([vendor claim](https://saftblock.com/)). **COMMUNITY-REPORTED/THIRD-PARTY CLAIM, contradicted as to direct scope by RB-01.** This does **not** make ram blocking optional as an engineering matter: 1910.147 hazardous-energy control and machine-specific safeguarding still apply where their conditions are met. It means the **legal citation must be correct**. No legal opinion or uninspected consensus-standard clause is asserted.

## Six separate physical propositions
| Proposition | What could disprove it | Required independent evidence |
|---|---|---|
| P1 — **Static deadweight captured** | Unsupported Y1/Y2 load path, block buckles/slips, support seated on weak tool/bed | Actual ram/tooling/accessory weight and center of gravity, support rated capacity and geometry, contact and bed/beam structural acceptance; qualified engineer |
| P2 — **Powered-stroke force cannot defeat support** | Hydraulic motor/valve can energize while block engaged, load greatly exceeds deadweight rating | Physical energy isolation/LOTO, independent final-element safe state, machine-specific dynamic-force review; never infer P2 from P1 |
| P3 — **Both sides and lateral loads controlled** | Two-cylinder beam twists around one support; workpiece or tooling shifts load | Actual Y1/Y2 arrangement, eccentric loading, number/placement and lateral stability of restraints; not assumed symmetric |
| P4 — **Hydraulic energy is independently managed** | Cylinder-side trapped pressure, pilot/relief/override path, pressure reaccumulation | As-built hydraulic zones, appropriate qualified measurements and safe bleed/isolation method; upstream gauge zero insufficient |
| P5 — **Service access cannot accidentally remove protection** | Block must be removed to reach bolts; support obscures tooling; stored block never used | Low-friction placement, positively retained supports, visible status, access-compatible layout, operator/maintainer trial *without energy* |
| P6 — **Rearm requires new deliberate action** | Reclosing a guard or removing block causes retained command to move ram | Independent reset/EDM/guard status plus separate fresh ordinary motion command; no personnel in danger zone |

### Failure-tree hypotheses (INFERENCE, not calculated probabilities)
- **Top event A:** worker in die space AND gravity-load path unrestrained (missing block, insufficient rating, off-center support, unsupported tooling, structural failure).
- **Top event B:** worker in die space AND powered stroke reaches support (electrical isolation omitted, wrong energy source locked, bypassed final element, stale restart).
- **Top event C:** rescue creates secondary injury (lifting without rated support, trapped pressure released in wrong order, support removed before stable load transfer).
- **Common-cause:** same maintainer changes hydraulic valve and block placement; common control power and bypass; one ambiguous "safe" HMI LED hides all three. These are questions to evaluate, not claims of an installed defect.

## Counterfactual transfer traps
1. **"10% machine capacity" ≠ universal minimum.** It belongs to Cincinnati's named manual and its machine/conditions; it does not establish OpenPressBrake support sizing, dynamic load capacity, or compliance.
2. **"Ram weight" ≠ "rated press tonnage".** Static weight and potentially available powered force are different loads. The support must not be assumed to survive powered force unless explicitly engineered and validated.
3. **"Two blocks" ≠ automatically independent Y1/Y2 holding.** Actual structure, load distribution, shared bed, support geometry and fault path decide.
4. **"Slide-lock engaged" ≠ personnel-safe to remove LOTO.** The OSHA directive explicitly distinguishes mechanical gravity isolation from powered energy and warns against treating control circuits as isolation.
5. **"Cincinnati pressure taps" ≠ OpenPressBrake pressure map.** Do not transfer MP/M1.1/M2.1/M1.2/M2.2 port names, gauge ranges or rescue steps to a different hydraulic machine.
6. **"E-stop" ≠ maintenance isolation** and **"support installed" ≠ emergency rescue plan**.

## Practical design: make the safer route easier
- Provide **engineer-qualified, serial-marked supports** with obvious approved placement/engagement points, convenient storage, quick visual inspection and an unambiguous LOTO card at the work area. No improvised wood or unverified jack.
- Make normal service access possible **while supports remain installed**; if technicians must defeat/remove them for routine tasks, redesign access or provide a separately qualified alternate safe procedure.
- Separate support-engaged indication (diagnostic) from actual **mechanical load path**. A switch may help the machine refuse motion, but it cannot turn an undersized support into a rated support.
- Keep an accessible **personal lockout** and restoration/shift handoff. Do not make emergency rescue depend on re-enabling ordinary LinuxCNC motion.
- Put a conspicuous **static-only vs powered-load** limitation on the device if justified by its actual engineering documentation; no generic sticker substitutes for design analysis.

## Evidence status and decisions
- **SOURCE-CONFIRMED:** none newly traced in LinuxCNC (normal controller remains outside personnel-safety authority).
- **DOC-CONFIRMED:** narrow OEM and OSHA statements above, with retrieval limitations.
- **TEST-CONFIRMED:** none. No bench, simulated or physical tests.
- **COMMUNITY-REPORTED:** vendor's overbroad legal claim, not used as design authority.
- **INFERENCE:** P1–P6 architecture, common-cause graph, human-factors controls.
- **UNKNOWN:** actual OpenPressBrake support, static/dynamic rating, ram mass, support count, structural contact, Y1/Y2 loads, hydraulic truth table, residual pressure, independent stop/hold, rearm, PL/SIL and test evidence.

**Disposition:** Source/standards scope question answered; physical OpenPressBrake G0/G1 remains **HOLD**, G2 **NOT RUN**, G3/G4 **NOT AUTHORIZED**. No people-exposed operation. A physical lab is **not justified** without selected as-built engineering and an exclusion/measurement plan; use no hosted or local Actions compute.
