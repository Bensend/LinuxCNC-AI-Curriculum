# 4400 safety — source overlap reconciliation and novelty-check correction (2026-10-26)
**Engineering/source-method audit; no new machine test or competency score.** The mission values source provenance, reusable learning, and information gain over volume. This record corrects the initial mistaken assumption that keyword/code search found unworked mechanisms.

## What went wrong
Repository code search returned no hits for `surge suppressor`, `flyback`, `relay dropout`, `sneak current`, `pneumatic silencer`, and `quick exhaust`. A subsequent **full canonical `safety-course/SAFETY_COURSE_INDEX.md` read and direct line filtering** revealed that these concepts were already covered. A zero-result code search is **not** proof of novelty, especially for a large rapidly growing repository with delayed/incomplete search indexing. The first novelty statement in the PNEU-EXH checkpoint was explicitly corrected in the same session.

## Precise predecessor → current increment crosswalk
| Topic | Prior durable work | What this session genuinely adds | What is **not** new |
|---|---|---|---|
| DC coil suppression/dropout | [Rockwell LVSAM original 2012 guide](4400_ROCKWELL_COIL_SUPPRESSION_LONG_CABLE_FALSE_HOLD_RETROFIT_AUDIT_2026-10-24.md), [OMRON/Schneider SUPPRESS-01 audit](4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md) | Direct [Rockwell Safebook 5 printed p.54](4400_COIL_SUP_01_ROCKWELL_OMRON_DC_COIL_SUPPRESSION_DROPOUT_STOP_TIME_SOURCE_AUDIT_2026-10-26.md) explicitly ties dropout to safeguarding distance; official **ISO 13855:2024 / ANSI B11.19 R2024 edition-scope check**, and integrated symbolic physical-witness chain | Diode release delay, output-OFF not physical-stop, suppressor replacement CHG already taught |
| Leakage/sneak-current | [OMRON SUPPRESS-01](4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md), [Rockwell IntelliVAC LEAK-01](4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md), [Rockwell PointMax output crossfeed](4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md) | Direct [historical Banner MM-TA/MM2-TA catalog 1.2 mA OSSD OFF leakage example](4400_SNEAK_CUR_02_OMRON_SAFETY_RELAY_LEAKAGE_SNEAK_CURRENT_AND_SUPPRESSOR_LOCATION_SOURCE_AUDIT_2026-10-26.md); [three-branch physical failure tree](../safety-course/4400_COIL_SUP_SNEAK_CUR_CROSSCUT_PHYSICAL_WITNESS_AND_CHANGE_IMPACT_REVIEW_2026-10-26.md) separates delay/backfeed/stuck final element | Contact-bypass CR, series sneak current, off-state leakage, command/feedback ambiguity already taught |
| Pneumatic exhaust/trapped pressure | [Festo MS6-SV-E/D and ROSS DM1/DM2 prior audit](4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) and [existing ten-case technician card](../safety-course/4400_PNEUMATIC_EXHAUST_TRAPPED_AIR_AND_RESET_TECHNICIAN_CARD_2026-10-24.md) | Direct [Parker P33 Oct 2019 3FA105 explicit energy-isolation-NOT-E-stop and silencer sizing/clogging warning; SMC DXT1215 Dec 2024 explicit non-safety valve, product-specific residual-voltage and slow cylinder](4400_PNEU_EXH_03_PARKER_SMC_ROSS_CLOGGED_EXHAUST_TRAPPED_ZONE_AND_RESET_SOURCE_AUDIT_2026-10-26.md) | Silencer restriction, downstream check/closed-center trapped zone, valve feedback not pressure proof already taught |

## Consequences for evaluation and progress
- All **30 newly written public paper cases** are **UNSCORED transfer practice**, not 30 newly proven competencies; all 30 documentary gates are **NOT RUN**. The independent evaluators are only **PREPARED/NOT RUN**.
- No prior external score, laboratory runtime or physical machine evidence is altered. Do not claim independent confirmation by citing a second document that merely repeats the same manufacturer claim.
- Retain the new exact-source deltas and their public transfer exercises, but future sessions should **prefer external evaluation, selected-machine physical evidence or genuinely different failure mechanisms** over more variants of the same OFF/coil/pressure warning.

## Improved mandatory novelty procedure (proposed reusable practice)
1. Read current `START_HERE.md`, `PROGRESS.md`, latest checkpoint and **the canonical safety-course index in full**; search within the *fetched text* for synonyms, mechanism, OEM model and likely predecessor section.
2. Compare candidate's causal failure mechanism and physical proposition to predecessor artifacts, not just title/part number.
3. Classify the candidate **NEW MECHANISM**, **NEW EXACT OEM EVIDENCE**, **TRANSFER/INTEGRATION**, or **DUPLICATE/NO INFORMATION GAIN**.
4. For exact OEM evidence, name the genuinely new product/edition/page and why it changes a qualified decision; label older claims as predecessor, not discovery.
5. If the candidate is only transfer practice, preserve UNSCORED status and do not inflate competency/graduation metrics.
6. If no meaningful delta remains, rotate to an unworked safety module or await the independent physical/evaluator gate while leaving automation enabled.

This is a **study-method correction**, not proof that search indexing is universally unreliable. It is a concrete counterexample in this repository and should guide future session initialization. G0/G1 HOLD, no personnel-exposed hazardous operation.
