# 4400 HOSE-ROUTE-01 — Make hydraulic hose safety easier than a shortcut

**NON-GRADUATED learner module, 2026-10-26.** This is a **PAPER / no-energy** course exercise. **12 cases UNSCORED; 8 documentary gates NOT RUN; no physical, hydraulic, machine or independent evaluator execution.** Source: [Gates 2025 / OSHA manufacturer-and-regulatory audit](../research/4400_HOSE_ROUTE_01_GATES_2025_HOSE_ASSEMBLY_ROUTING_CLAMP_TWIST_SERVICE_PROVENANCE_AUDIT_2026-10-26.md). Prerequisites: 2580 hydraulic energy, 4400 pinhole/zone, hose-burst fuse, HOLD-01, lockout and physical load restraint. **OpenPressBrake Stage A machine evidence remains UNKNOWN; G0/G1 HOLD.**

## What a competent technician should learn

A hose is **not** safe merely because its catalog pressure rating is high, it fits the fittings, it passed a static bench check, or LinuxCNC reports STOPPED. Its **complete assembled system** includes exact compatible hose, couplings, crimp, correct end orientation, routing through all relevant travel, bend radius, clamp size, heat/abrasion protection, inspection access and replacement provenance. This preventive layer is distinct from independent protective stopping, cylinder load holding, stored-energy isolation and personal protection against fluid injection.

### Low-friction physical design pattern (generic; no machine prescription)

1. Provide a stable, easy-to-see **route path** with protected bends and correct clamps, away from chips, pinch points, heat and personnel exposure. Use accessible hinged/captive covers; the cover must be easier to restore than leave off.
2. Mark **hose assembly identity**, orientation, supported route, clamp locations and last qualified change, without placing labels where they conceal defects. Make the correct replacement easy to order and wrong substitutions easy to recognize.
3. Place **inspection access** outside the hazardous motion zone where practicable. If access requires reaching the hazard, stop work and use a qualified machine-specific isolation, mechanical restraint and pressure verification procedure.
4. Maintain a **change gate**: replacement is not equivalent until the hose/fitting/crimp system, physical route and all energy/stop/hold/guard assumptions have been reviewed. No automatic restart after service.
5. Keep **four witnesses separate**: normal-control command, safety-controller request/status, actual hydraulic/ram physical state, and verified personal energy isolation. None alone establishes the others.

## Twelve unscored technician scenarios (no answers or scoring key here)

| Case | Prompt — state the hazard, physical witness, safe response, and what remains UNKNOWN |
|---|---|
| HR-P01 | A new hose is longer and rubs a rear Y2 bracket only near full extension. HMI says READY. What changes? |
| HR-P02 | A clamp is present but its bore is visibly oversized; the hose has polished wear marks. Does a clamp count as protection? |
| HR-P03 | The layline rotates half a turn between ports; replacement uses the same nominal pressure rating. What is unverified? |
| HR-P04 | The bend at the crimped fitting is tighter than the selected hose manufacturer's minimum. Can a higher burst rating compensate? |
| HR-P05 | The old coupling is discontinued; a different maker's hose and coupling have matching thread sizes. What evidence is required? |
| HR-P06 | A hose is pulled taut at rest but looks tidy. What happens when pressure and travel change its effective length? |
| HR-P07 | A sleeve conceals the hose behind an inaccessible guard. What tradeoff has the design created? |
| HR-P08 | A technician removes a difficult cover and omits two clamps during reassembly. What physical redesign would reduce repeat defeat? |
| HR-P09 | The pump is off and the ram is mechanically blocked; a gauge at the tank manifold reads zero. May the cylinder hose be opened? |
| HR-P10 | A Gates generic inspection interval is copied as the legally mandated interval for a press brake. Identify the scope error. |
| HR-P11 | After service, LinuxCNC's E-stop has been reset and the hydraulic pump can start. What independent release evidence is missing? |
| HR-P12 | A stationary pressure test passes, but the hose twists only at full stroke. Why was the test insufficient, and what qualified evidence is needed? |

**Exam handling:** These prompts are learner-visible and **UNSCORED**. A separate evaluator must use an unseen variant, receive the learner's precommitted diagnosis before revealing the oracle, and score independently. Do not publish hidden answers in this module or count self-review as external evaluation.

## Eight documentary review gates — all NOT RUN

| Gate | Required artifact and pass question | Current |
|---|---|---|
| HR-G1 | Qualified machine route drawing/photos **restricted**, with exact hose IDs, ports, all relevant movement envelopes and exposure boundary | UNKNOWN / NOT RUN |
| HR-G2 | Selected hose/fitting/crimp manufacturer compatibility, working pressure incl. surge, fluid, temperature and documented assembler | UNKNOWN / NOT RUN |
| HR-G3 | Bend radius, twist, clamp sizing, heat, swarf, pressure-length change and wear/access review for the installed path | UNKNOWN / NOT RUN |
| HR-G4 | Protected segment and load-hold/rupture valve location identified without assuming an excavator or catalog valve transfers | UNKNOWN / NOT RUN |
| HR-G5 | Independent Y1/Y2 physical stop/hold and gravity restraint reviewed; no reliance on pump OFF or ordinary HAL | UNKNOWN / NOT RUN |
| HR-G6 | Covered service energy-isolation procedure: personal lockout, zone pressure/residual energy, reaccumulation and verified mechanical restraint | UNKNOWN / NOT RUN |
| HR-G7 | Guard/access usability, correct reinstallation, replacement provenance and stale-evidence change control demonstrated | UNKNOWN / NOT RUN |
| HR-G8 | Qualified restoration, independent physical proof and deliberate restart/rearm plan; evaluator results kept information-separated | UNKNOWN / NOT RUN |

No gate can be marked PASS from a manufacturer catalog alone. No hazardous live-pressure leak search, deliberate line rupture, bypass, ram-drop experiment or personnel-exposed machine test is authorized.

## Practical no-bypass maintenance card (conceptual sequence, not a machine procedure)

**Before work:** identify hazard and exact task; qualified personnel obtain machine-specific energy isolation and load-restraint plan; keep people outside exposure. **During work:** verify each relevant physical pressure/energy zone and support, use the specified compatible hose assembly, protect route/guards/clamps, record deviations. **Before return:** inspect and restore all safeguards and covers, confirm no one remains exposed, independently verify stop/hold/pressure behavior under an approved commissioning plan, then use a deliberate fresh start. Any UNKNOWN or contradictory witness means **HOLD**.

**Stop threshold:** If basic stop/hold/guard/isolation cannot be demonstrated, no personnel-exposed hazardous operation. Any experimental operation must be physically isolated/remote with residual risks explicitly controlled and documented.

## Evidence / promotion

**DOC-CONFIRMED:** Gates 2025 routing/assembly/inspection guidance; OSHA 1910.147 maintenance energy controls. **INFERENCE:** ergonomic/clamp/route change gates. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used. **UNKNOWN:** selected machine and independent physical proof. This source-only lesson does not graduate 4400, does not authorize operation and does not change 2520–25F0 external evaluator status. **Next:** qualified private Stage A A–G and conditional Stage B routing evidence; external unseen competency; else a different unblocked 4400 safety mechanism.


**2026-10-29 exact-OEM protective-cover source-depth:** [Parker UHP / Gates LifeGuard audit](../research/4400_HOSE_SHIELD_01_GATES_LIFEGUARD_PARKER_UHP_ABRASION_VS_PRESSURE_CONTAINMENT_SOURCE_DELTA_2026-10-29.md) → [one-pass technician card](4400_HOSE_SHIELD_01_ABRASION_WRAP_IS_NOT_SPRAY_CONTAINMENT_FIELD_CARD_2026-10-29.md). Ordinary abrasion wrap does **not** imply rated pinhole/burst containment; pressure sleeves have selected end clamps, discharge paths and limited product envelopes; hose-end whip grips and support grips are different. Gates' advertised five-minute conditional envelope is not permission for human exposure, and its “nonconductive” sleeve material is not proof the complete hydraulic hose/fittings are electrically isolated. This is a **source-depth addendum** to existing routing/injection lessons, not a new scored case or machine safety validation.
