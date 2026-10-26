# 4400 FLUID-FIRE-01 — Oil mist can ignite; 'fire resistant' is not 'safe to substitute'

**NON-GRADUATED, 2026-10-26. Eight public PAPER cases UNSCORED; eight documentary gates NOT RUN.** No ignition, spray, energized, pressurized or physical machine tests. [Source audit and limits](../research/4400_FLUID_FIRE_01_HSE_MISTS2_FIRE_RESISTANT_HYDRAULIC_FLUID_AND_SEAL_COMPATIBILITY_AUDIT_2026-10-26.md).

## Learner outcome

Explain why bulk-fluid flash point does not by itself settle a pressurized-mist ignition risk; why an HSE diesel experiment does **not** yield a press-brake clearance; why changing hydraulic fluid to lower fire risk is a **whole-system change** requiring seal/hose/valve/holding requalification; and why independent physical stop/hold/isolation remains required regardless of normal CNC status.

## Eight learner-visible scenarios — UNSCORED, no hidden answers

| Case | Prompt — identify hazard, authority boundary, source scope, missing physical witness |
|---|---|
| FF-P01 | A shop calls a hydraulic oil 'high flashpoint' and dismisses a mist near an electric heater. What does HSE RR1210 actually establish? |
| FF-P02 | A designer uses HSE's diesel test maximum ignition distance as the required press-brake exclusion distance. What is invalid? |
| FF-P03 | A catalog calls a fluid 'fire-resistant' and a technician concludes hose rupture/injection no longer matters. |
| FF-P04 | A proposed ester fluid is described as compatible with 'most' elastomers, but the machine's seal material is unidentified. |
| FF-P05 | A water-glycol reservoir is topped up with an ester fluid because both carry fire-resistant marketing claims. |
| FF-P06 | A fluid conversion is approved for fire risk, but no one has rechecked Y1/Y2 valve response or load holding. |
| FF-P07 | A fire sensor requests LinuxCNC stop and the pump turns off; a check-isolated pressure zone and suspended ram remain. |
| FF-P08 | Fireproof sleeving hides an abrasion-prone hose behind a cover technicians routinely leave off. Redesign for lower foreseeable defeat. |

## Eight documentary gates — ALL NOT RUN

| Gate | Selected-machine evidence to collect privately | State |
|---|---|---|
| FF-G1 | Exact current hydraulic fluid, revision, fill records and manufacturer approval | UNKNOWN |
| FF-G2 | Actual potential leak points, fluid atomization, enclosure/ventilation and nearby ignition sources | UNKNOWN |
| FF-G3 | Hose/fitting/seal/pump/valve materials and exact fluid compatibility | UNKNOWN |
| FF-G4 | Proposed replacement fluid and explicit manufacturer mixing/conversion/cleaning guidance | UNKNOWN |
| FF-G5 | Protected hose routing, accessible guards, fire/injection exposure and maintenance usability | UNKNOWN |
| FF-G6 | Independent physical Y1/Y2 stop/hold and stored-pressure zone control before/after change | UNKNOWN |
| FF-G7 | Safety/fire system independence from LinuxCNC/FPGA, plus qualified risk assessment and physical validation plan | UNKNOWN |
| FF-G8 | Change-control stale-evidence review, restoration, occupied-zone clearance and deliberate restart | UNKNOWN |

**Do not self-score:** independent unseen evaluator must receive a precommitted response and score separately. **Do not perform spray, mist ignition, open-line or fluid-conversion experiments as curriculum labs.** HSE's 4.75 m diesel test is not a transferable safe distance. Manufacturer fluid compatibility claims are exact-product evidence, not authorization to substitute.

**Fail-safe / practical design:** use correct labeled fluids, compatible parts and accessible hoses; physically segregate likely leak paths and ignition sources; protect and inspect hoses; retain independent stop, holding, isolation and restart. If basic minimum protection cannot be demonstrated, **no personnel-exposed hazardous operation**; isolated/remote experimental work only under a separately qualified plan. **G0/G1 HOLD.**
