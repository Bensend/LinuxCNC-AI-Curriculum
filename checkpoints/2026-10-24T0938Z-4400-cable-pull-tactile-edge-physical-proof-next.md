# Active continuation checkpoint — 4400 cable-pull and tactile edge safety transfer

**UTC session start:** 2026-10-24T09:38:22.738Z, recorded before substantive work. **Date:** 2026-10-24. **Status:** SOURCE-READING / PAPER ONLY / NOT GRADUATED. **Authority:** latest 4000 safety curriculum; 1000, 2000, F02 and 3000 formally closed. Routine controller-board work belongs to separate automation.

## Governing state recovered

Read `START_HERE.md`, `MASTER_MISSION.md`, `LEVEL_ORDER.md`, `WORK_SELECTION_POLICY.md`, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, `PROGRESS.md`, the 08:40Z PWR checkpoint, safety-course index, selected physical intake, `evaluation/BLIND_FEEDBACK_PROTOCOL.md`, `evaluation/FEEDBACK_SCORE_LOG.md` and `LAB_COMPUTE_LOG.md`. Latest `LESSON_LOG.md` prior canonical end **2026-10-24T08:49:39.110Z**, 48.73 minutes before this start; no known lesson overlap, external concurrent activity not independently excluded. Historical original archive **6/85 pending**.

## Durable new original artifacts — seven

1. [Lifeline 5/Lifeline 4/ZQ900 cable-pull original OEM source audit](../research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md).
2. [12-case cable tension/reset/sightline technician card](../safety-course/4400_CABLE_PULL_TENSION_WARNING_RESET_SIGHTLINE_TECHNICIAN_CARD_2026-10-24.md).
3. [Blank cable-pull installation/change/physical witness worksheet](../safety-course/4400_CABLE_PULL_ESTOP_INSTALLATION_CHANGE_AND_RESTART_WITNESS_WORKSHEET_2026-10-24.md).
4. [ISO/Schmersal/Mayser/ASO tactile safety edge source audit](../research/4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md).
5. [10-case tactile contact/overtravel/auto-reset technician card](../safety-course/4400_TACTILE_EDGE_CONTACT_OVERRUN_AND_AUTORESET_TECHNICIAN_CARD_2026-10-24.md).
6. [Prepared **unscored** independent fresh-source cross-device transfer handoff](../evaluation/4400_CABLE_PULL_TACTILE_EDGE_FRESH_SOURCE_TRANSFER_HANDOFF_2026-10-24.md).
7. [Cross-device function-selection and practical anti-defeat matrix](../safety-course/4400_CABLE_PULL_VS_TACTILE_EDGE_FUNCTION_SELECTION_AND_HUMAN_FACTORS_MATRIX_2026-10-24.md).

**Source provenance:** Rockwell 440E-IN008H-EN-P **February 2026** Lifeline 5 (20-page OEM original PDF inspected), Rockwell 440E-IN006D-EN-P **September 2022** Lifeline 4, Schmersal 103000117-EN/G **November 2023** ZQ900 (original OEM PDF inspected), Schmersal current SE40/70 and SE-304C manufacturer product pages, Mayser manufacturer indexed family descriptions (direct fetch failed), ASO SENTIR manufacturer page, ISO 13856-2:2013 public abstract (confirmed 2024, full normative text not inspected). Schmersal SE-304C original PDF indexed but direct retrieval redirected; **do not claim the full manual was inspected**.

**DOC-CONFIRMED exact product findings:**
- Lifeline 5 high/low cable tension warnings can coexist with **OSSD safety outputs ON**; warning ≠ protective trip. 432ES `Data` and device tags are standard/non-safety-rated; five-pin mode changes signal roles and eight-pin is OSSD-only; local reset and full-span visibility/inspection are distinct from machine rearm.
- ZQ900 broken rope causes latched E-stop; proper pre-tension and local release required. No OEM model's dimensions or response time can be copied to another.
- Schmersal SE40/70 tactile edge uses **optical IR** deformation; Mayser/ASO monitored NO resistor/four-wire and NC contact families are **not electrically equivalent**. Schmersal SE-304C catalogue permits manual `0-1-0` or auto-reset; signalling output ≠ safety contact. ISO 13856-2 public abstract does **not** prove particular machine suitability, effective sensing geometry or required PL.
- A tactile edge is **contact-triggered**; the selected mechanism's physical overtravel/force and independent stopping are decisive, not a product's `up to PL d` or 17 ms relay rating.

**INFERENCE:** ignored warning margins, trapped cable, nuisance trips, incompatible replacement, automatic monitor reset with retained CNC demand, and insufficient contact-edge compression can create unsafe failure paths. **UNKNOWN:** selected installation, exact machine safety controller, Y1/Y2 final elements, actual physical stop/hold/occupancy/restart and all numeric criteria. No product-specific PL/SIL transfer.

## Integration and integrity

- Updated `PROGRESS.md`, `CURRICULUM.md`, `SAFETY_COURSE_RESEARCH.md`, safety-course index, cumulative Safety Design Package **§§11BP–11BQ**, conditional selected-machine intake **IN-04n/o**.
- Seven original documents independently re-fetched from `main` with Git blob SHAs; their relative Markdown links all resolve.
- Complete non-truncated Git tree audit at head `f956e06291f86c930cbea131d94f4dcda15bc5fd`: **4,183 entries, 157 safety index relative links / 155 distinct targets / zero missing** (before adding this checkpoint, which does not add an index link).
- **22 learner-visible paper cases**, `CP-01..12` and `TE-01..10`; none is an independent blind score.
- Separate OpenPressBrake engineering project was inspected **only to assess evidence maturity**. Provisional controller-interface documentation is not independent physical machine validation; no private machine drawings, wiring identifiers or hardware details were copied to this public curriculum.

## Compute, safety and external evaluation

- GitHub-hosted Actions minutes **0**; local self-hosted laboratory minutes **0**; **no workflow dispatched**, no simulations/builds/bench/physical tests. Previous self-hosted-only workflow cancelled without authoritative job runtime; **LAB_COMPUTE_LOG unchanged**. Do not fall back to hosted runners.
- Fresh-source cross-device evaluation **PREPARED / NOT ADMINISTERED / NOT SCORED**. 2520–25F0 and 4400-HY/ESPE/RET/PWR independent fresh gates remain OPEN. No sealed answers accessed.
- Selected `G0/G1 HOLD`, `G2/VAL/PT NOT RUN`, `G3/G4 NOT AUTHORIZED`; no personnel-exposed hazardous operation. Any experimental operation requires qualified isolation/remote arrangement, people outside danger zone and documented residual risk.

## Precise next-work selection

1. **Primary selected OpenPressBrake physical evidence:** obtain revision-controlled as-built independent safety PLC wiring, Y1/Y2 hydraulic/final-element paths, gravity/load holding, guard/rear access and actual reset/restart; keep private drawings in the private project. Resolve physical `PHY-STOP/HOLD/ENERGY/ACCESS/RESTART` with qualified machine-specific witnesses, not generic OEM catalogues.
2. **Independent external evaluation:** administer one prepared 4400 transfer packet with genuinely fresh evaluator/learner, hidden source, immutable precommit, independent scoring, then novel transfer and delayed retention; do not self-score. This new cable/tactile handoff is an option, not a replacement for existing overdue foundational gates.
3. **If selected physical/evaluator inputs unavailable:** rotate to a high-information-gain **different** 4400 safety source gap, keeping the independent safety/ordinary control boundary. Avoid repeated generic 3000 work or duplicate cable/edge paper cases.
4. **Compute:** no GitHub-hosted runners; only question-driven bounded self-hosted `[self-hosted, openpressbrake]` if a genuine unresolved test is frozen and dispatchable. Update lab ledger only from authoritative actual job start/end.
5. **End of session:** append actual UTC end/elapsed/overlap immediately before exit to **complete** `LESSON_LOG.md` via SHA-guarded safe update; verify resulting row. Do not overwrite truncated log.

**Short-session continuation check:** this invocation rotated from cable E-stop source tracing into tactile-edge OEM/ISO comparison, physical human-factors selection and an independent transfer contract. A further unrelated safety source branch would enlarge the already seven-document uncheckpointed evidence set; persist and resume coherently next invocation rather than manufacture redundant labs or prose. **Freeze:** WARNING + GREEN ≠ SAFE CABLE SPAN; EDGE CONTACT ≠ SAFE FORCE/STOP; STANDARD STATUS ≠ SAFETY PATH; DEVICE RESET ≠ PHYSICAL PROOF OR FRESH START.
