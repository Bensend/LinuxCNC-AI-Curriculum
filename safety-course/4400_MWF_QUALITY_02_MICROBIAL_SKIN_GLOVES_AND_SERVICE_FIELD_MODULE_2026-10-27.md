# 4400-MWF-QUALITY-02 — Sump biology, skin protection and the rotating-tool glove trap

**2026-10-27 | NON-GRADUATED | Water-mix MWF systems on mills, lathes, grinders and related CNC machines | 6 PUBLIC PAPER cases UNSCORED / 8 documentary gates NOT RUN.** Source: [original HSE MW2/MW5, NIOSH and OSHA audit](../research/4400_MWF_01_02_NIOSH_HSE_OSHA_MIST_SKIN_MICROBIAL_EXPOSURE_SOURCE_AUDIT_2026-10-27.md). Do not assume the selected OpenPressBrake has a coolant sump or any MWF exposure.

## Central causal distinction
A machine can have normal spindle/servo behavior while its fluid becomes unsuitable for human contact or breathing. A coolant level OK, pH within the supplier range, clear appearance or absence of odor **does not prove** acceptable microbial control. Conversely, a microbial sample result is **not** evidence of hazardous-motion stop, independent gravity holding, safe maintenance isolation or a worker's medical diagnosis.

**DOC-CONFIRMED — HSE MW5 (UK water-mix guidance):** monitor actual concentration/pH, tramp oil, stagnation/dead legs, temperature, fluid condition and microbial dip slides. HSE suggests weekly dip slides unless documented evidence supports another interval; ≥10^4 CFU/ml indicates growth and ≥10^6 CFU/ml poor control calling for prompt action, normally drain/clean or equally effective measures. These values are fluid-management indicators in that guidance, not universal US regulatory limits or clinical thresholds. Biocide should not be a first shortcut; correct fluid management and supplier-approved dosing matter.

**DOC-CONFIRMED — HSE MW2:** chemical/biocide/metal contamination and prolonged wet work can produce skin harm. Suitable gloves for *stopped and isolated* cleaning can reduce contact, but wearing gloves near rotating tools can increase entanglement risk. HSE warns barrier creams are not complete protection. **NIOSH 2008:** inhalation and dermal exposure require different control and assessment; a single airborne TWA cannot certify skin safety.

## Design for the shortcut that will actually happen
- Provide a safe sample point and fluid-service access **without reaching rotating tools**, easy labels for supplier concentration and approved test method, and a simple log of fluid identity, age, pH, concentration, microbial trend, maintenance and corrective action.
- Make wet swarf removal feasible using suitable tools and a swarf vacuum; do not make compressed air the only convenient method. Provide wash facilities and contamination-free storage for PPE.
- Keep tool motion physically prevented during service; distinguish **routine sample/inspection** from **sump entry/cleaning** requiring task-specific isolation and stored-energy controls. Gloves are not a substitute for stationary machinery or correct isolation.
- A contaminated sump may require controlled drain/clean and worker-exposure assessment. Do not invent a biocide recipe, microbial test, disposal method or chemical compatibility without the selected supplier and competent hygiene review.
- Preserve evidence for all machine/health hazards separately: fluid quality, skin contact, mist capture, mechanical guarding, energy isolation and deliberate restart.

## Six PUBLIC adversarial paper cases (UNSCORED)
| Case | Scenario | Learner's required output |
|---|---|---|
| QUAL-P01 | Sump looks clear, pH normal, no microbial record | Distinguish absent microbiological witness from good appearance |
| QUAL-P02 | Odor develops; worker proposes double biocide dose | Explain supplier guidance, corrective workflow and exposure hazards |
| QUAL-P03 | One dead-leg branch remains unused for weeks | Map stagnation risk and justified evidence without opening live pipe |
| QUAL-P04 | Gloves reduce dermatitis but snag near spinning chuck | Resolve competing risks by changing task/access, not removing all PPE |
| QUAL-P05 | New coolant chemistry introduced with unchanged LinuxCNC config | Identify changed SDS, fluid, skin, mist and service validation despite same G-code |
| QUAL-P06 | HSE 10^6 CFU/ml used as universal automatic safety-stop threshold | Correct source scope, role of occupational health and independent motion protection |

For each response: evidence class, exact fluid/machine applicability, worker-exposure route, practical lowest-friction control, separate machine-energy safety authority, change impact and unverified claim. These are open-book practice, **not** an independent evaluator score.

## Eight documentary gates (NOT RUN)
| Gate | Qualified selected-machine document | Status |
|---|---|---|
| QUAL-D01 | Actual coolant type, SDS, supplier limits, materials and sump map | NOT RUN |
| QUAL-D02 | Water-mix applicability and stagnation/dead-leg/flow paths | NOT RUN |
| QUAL-D03 | Sampling port and tool-motion/access hazard analysis | NOT RUN |
| QUAL-D04 | Concentration/pH/tramp oil/temperature and microbial trend procedure | NOT RUN |
| QUAL-D05 | Qualified response to bad results, disposal and biocide control | NOT RUN |
| QUAL-D06 | Skin exposure, PPE and glove-entanglement task/mode review | NOT RUN |
| QUAL-D07 | Independent maintenance isolation and guard restoration witness | NOT RUN |
| QUAL-D08 | Fluid, piping, enclosure and cleaning-method change/revalidation owner | NOT RUN |

**Authority/evidence:** ordinary LinuxCNC can log a maintenance reminder or prevent a normal machining cycle; it is not a microbiological instrument, exposure monitor, safety-rated guard, maintenance isolator or medical evaluator. HSE/NIOSH are **DOC-CONFIRMED** for cited scopes, transfer design **INFERENCE**, selected machine **UNKNOWN**, physical and hygiene tests **NOT RUN**. No live sump sampling, pressure opening, rotating-glove experiment, chemical dosing or personnel-exposed hazardous operation is authorized by this module. **G0/G1 HOLD.**
