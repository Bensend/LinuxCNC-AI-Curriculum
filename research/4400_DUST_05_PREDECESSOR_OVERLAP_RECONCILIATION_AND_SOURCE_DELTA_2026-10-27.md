# 4400-DUST-05 — Corrected predecessor/novelty audit for combustible dust

**Date:** 2026-10-27 UTC. **Status:** correction to this session's initial exact-keyword novelty claim. **No machine test.**

## Discovery and correction

During post-publication governance review, a broader semantic scan of `SAFETY_COURSE_RESEARCH.md` and the canonical learner index identified the already-existing **2026-10-25 4400-DUST-01 through DUST-04** curriculum. The earlier 2026-10-27 exact-keyword scan for phrases such as `dust explosion` and `dust collector` was **not sufficient**: it missed entries using `wood dust`, `collector fire/deflagration`, `LEV`, and indirect links. The assertion that combustible dust/collector propagation was a previously uncovered safety mechanism was **WRONG**. Do not repeat it or count this as a newly opened generic safety domain.

## Predecessors (read before the new 2026-10-27 transfer)

1. [Original OSHA/NFPA 660/CSB US Ink + pinned LinuxCNC coolant source audit](4400_OSHA_NFPA660_CSB_WOOD_DUST_LEV_FIRE_VS_CNC_COOLANT_PIN_SOURCE_AUDIT_2026-10-25.md): dust exposure, collector fire/deflagration, machine E-stop vs fan command, NFPA edition, and selected physical capture/vent/isolation.
2. [Original DUST-01 integrated module](../safety-course/4400_DUST_01_WOOD_ROUTER_LEV_CAPTURE_FIRE_AND_CNC_COMMAND_BOUNDARY_MODULE_2026-10-25.md): already separates collector vessel, dust accumulation, return-air strategy, fire/explosion mitigation, and ordinary CNC authority.
3. [DUST-01 18 paper scenarios](../safety-course/4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md): already includes vent-to-walkway, material swap to combustible metal, compressed-air blowdown, shared collectors, fire response, service isolation, and restart.
4. [Donaldson PowerCore CPC Rev6/HSE direct OEM audit](4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md): already establishes vent discharge, collector differential-pressure fallacy, sprinkler load, pneumatic isolation and hood-level capture.
5. [DUST-01 14-gate desk verification plan](../safety-course/4400_DUST_01_NO_ENERGY_COLLECTOR_CAPTURE_AND_FIRE_DESK_VERIFICATION_PLAN_2026-10-25.md): already requires shared duct propagation isolation, exact material, collector placement, maintenance and bypass review.
6. DUST-02/DUST-04 pinned LinuxCNC version/queue/remap traces in the existing 2026-10-25 module: normal request timing is not safety response timing.

## Actual incremental evidence from 2026-10-27

- **DOC-CONFIRMED direct new case:** CSB Imperial Sugar 2009 primary enclosed-conveyor event followed by secondary accumulated-sugar-dust explosions, separate from prior US Ink incident.
- **DOC-CONFIRMED direct new case:** CSB Hoeganaes powdered-iron fatal events, separate from wood/sugar/ink and useful for **material-specific** metal-dust transfer.
- **DOC-CONFIRMED direct new OEM architecture:** Fike dust collector explanation explicitly distinguishes vessel venting/suppression and **inlet/outlet/hopper isolation** (the concept itself was already in the Donaldson/14-gate predecessor). No product model qualification, response time or selected installation proof.
- **DOC-CONFIRMED direct HSE woodworking extraction fire page** is a second original source, not a new physical mechanism.
- **NFPA 660:2025 official publisher metadata** and OSHA dust pentagon/2023 NEP are **reconfirmations**, not new standards discoveries. Normative clauses not read.
- **Public 10-case and 12-gate card** is additional **UNSCORED transfer practice**, largely overlapping predecessor scenarios; not independent competency or a new set of safety functions.

## Corrected classification and work-selection lesson

Reclassify this session's new dust artifacts as **DUST-05: manufacturer/incident corroboration and integrated transfer**, not DUST-01 or a new generic mechanism. The **ABRASIVE-01** wheel-burst and **MAGCHUCK-01** magnetic contact/retention investigations remain distinct novel mechanisms after broader term checking. Source classifications and selected-machine UNKNOWNs remain unchanged.

**Process improvement:** novelty check must combine canonical index **and** `SAFETY_COURSE_RESEARCH.md`, inspect semantic synonyms and existing linked modules, and compare causal mechanisms—not only literal headings or grep hit counts. `WORK_SELECTION_POLICY.md` already requires predecessor reconciliation; this document records a concrete failure and correction, not a claim that policy was absent.

**G0/G1 HOLD, external evaluator NOT RUN, no machine/compute evidence.**
