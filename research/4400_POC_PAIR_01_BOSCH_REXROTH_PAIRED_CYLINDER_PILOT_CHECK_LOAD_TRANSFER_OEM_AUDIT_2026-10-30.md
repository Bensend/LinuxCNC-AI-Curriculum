# 4400-POC-PAIR-01 — Paired-cylinder pilot-check release can redistribute the entire load
**2026-10-30 | Original manufacturer-source safety addendum | NON-GRADUATED | NO PHYSICAL VALIDATION**

## Question and novelty decision
**Question:** Can a builder replace or augment two Y-axis gravity-load holding circuits with ordinary pilot-operated check valves, assuming that "closed = safe" and that both cylinders will release together?

**Novelty audit:** Direct full-index, research-plan and historical PROGRESS scans found existing 2580 fluid-power, HOLD-01 (Rexroth A-VBC-90 emergency screw/relief and Parker E2), hose-burst fuse, Parker HAS, gravity-load/brake and dual-Y fault lessons. They already warn that one Y axis may drift and that valve families cannot be substituted. The **incremental causal mechanism** here is an original Bosch Rexroth warning about **asymmetric pilot-check opening on paired cylinders, load transfer to the other cylinder, and possible cylinder failure**, plus the non-modulating/hunting distinction. This is **source depth under HOLD-01**, not a new graduated competency or new physical gate.

## Original-source provenance
1. **Bosch Rexroth Oil Control S.p.A.**, *PILOT OPERATED CHECK VALVES*, manufacturer-hosted one-page catalog technical note, [original PDF](https://apps.boschrexroth.com/products/compact-hydraulics/CH-Catalog/pdf/Pilot_Operated_Check.pdf), PDF p. 1. **Directly opened and visually inspected the complete one-page PDF on 2026-10-30.** The PDF page has no printed publication date or document revision; do not infer one from web crawler age. Its schematics depict single-acting and double-acting **one-cylinder** check-valve modules with C1/C2/V1/V2 ports. It does **not** depict the selected OpenPressBrake Y1/Y2 circuit.
2. **Sun Hydraulics**, *Technical Tip — Counterbalance & Pilot-to-Open Check Cartridges*, Pub. 999-901-287, **June 2023**, [manufacturer PDF](https://www.sunhydraulics.com/sites/default/files/media_library/tech_resources/TT_US_Ctrbal_POCk_Jun2023_Final_0.pdf), search-indexed excerpt, PDF p. 2. **Provenance limit:** full PDF retrieval returned HTTP 403; only the indexed original-manufacturer excerpt was inspected. It distinguishes non-modulating three-port pilot-to-open checks (CK**) from modulating counterbalance cartridges (CB**) and notes product-specific intentional pilot-piston leakage and emergency manual release options. This corroborates a **narrow functional distinction**, not Bosch's paired-cylinder warning or an installed press-brake design.

## Direct Bosch Rexroth observations (DOC-CONFIRMED for the described valve family)
- A pilot-operated check is **non-modulating**: free supply flow toward the actuator, reverse flow blocked until a pressure-dependent pilot force opens the poppet.
- The OEM says to locate the check **as close to the actuator as possible**, flange-mounted or connected by metallic pipe, for the described hose-failure holding use. A check upstream of an unprotected flexible hose cannot simply inherit that benefit (**INFERENCE**; actual hose/valve topology required).
- It explicitly warns that an overrunning load can lose pilot pressure, causing the valve to close, then reopen when pressure returns: **hunting**, rather than stable proportional descent.
- **Critical paired-cylinder warning:** the OEM states that pilot-operated checks should not be used with paired cylinders because the less-loaded valve can open first, transfer the entire load to the other cylinder, sharply increase pressure and potentially cause cylinder failure. This is a manufacturer **application warning for the discussed check-valve approach**; it is **not** proof that all multi-cylinder circuits or certified load-holding architectures are unsafe.
- The note defines pilot ratio **R = pilot piston area / check seat area** and cylinder ratio **phi = full-bore area / annular area**. In its described annular-chamber arrangement it requires R significantly above phi because intensified load pressure opposes opening. **No numeric ratio, pressure, setting, cylinder area, or selection follows for OpenPressBrake.**

## Source-to-architecture failure path
| Stage | Plausible event | Evidence classification | What a qualified reviewer must establish |
|---|---|---|---|
| 1. Normal command | LinuxCNC/FPGA requests Y1/Y2 descent; ordinary outputs/pressure controls are not safety authority | SOURCE-CONFIRMED course boundary; INFERENCE for this hypothetical circuit | Actual command and hydraulic circuit mapping, independent safety function |
| 2. Pilot opening | Unequal load/pilot forces open one pilot-check first | DOC-CONFIRMED Bosch family warning; selected circuit UNKNOWN | Exact check type, pilot source, cross-pilot routing, paired-cylinder load paths |
| 3. Redistribution | The remaining closed cylinder can take the load, increasing pressure | DOC-CONFIRMED Bosch warning; magnitude UNKNOWN | Actual ram stiffness, coupling, relief paths, cylinder/line ratings, mechanical support |
| 4. Overrunning descent | Pilot pressure collapses and reappears, causing valve hunting | DOC-CONFIRMED Bosch described application; actual machine response UNKNOWN | Distinguish modulating counterbalance circuit from on/off pilot check; OEM application suitability |
| 5. Protective demand | Safety system requests stop while load is moving or asymmetric | INFERENCE; no selected hardware data | Independent safety outputs and hydraulic/mechanical final elements; how both sides stop and remain supported |
| 6. Maintenance / rescue | A technician treats a trapped oil volume as a mechanical lock, or manually releases one side | INFERENCE | Positive mechanical restraint, pressure-zone isolation, documented approved recovery, deliberate restart |

**Important limitation:** Bosch's warning is strong **against casually substituting the described pilot checks for paired-cylinder motion control**. It does not tell us that OpenPressBrake has these check valves, that its existing Pilz-owned fast-poppets are pilot checks, or that a selected qualified multi-cylinder safety circuit cannot be designed. Do not map a catalog schematic onto unknown machine hardware.

## Pinned public OpenPressBrake cross-check (SOURCE-CONFIRMED design intent, not as-built)
At OpenPressBrake commit [`e9bf068940820a5d4ee3e4064d1c25e8060d991c`](https://github.com/Bensend/OpenPressBrake/commit/e9bf068940820a5d4ee3e4064d1c25e8060d991c), [`hardware/REV1_MACHINE_CONFIG.yaml`](https://github.com/Bensend/OpenPressBrake/blob/e9bf068940820a5d4ee3e4064d1c25e8060d991c/hardware/REV1_MACHINE_CONFIG.yaml) blob `37119336acf8113fb59c79865de29edd1c70e285` names three intended Pilz-owned **nonproportional safety valves**: `11Y4_Y1_FAST_POPPET`, `11Y6_Y2_FAST_POPPET`, and `11Y8_PRE_FILL`. [`docs/IO_MAP.md`](https://github.com/Bensend/OpenPressBrake/blob/e9bf068940820a5d4ee3e4064d1c25e8060d991c/docs/IO_MAP.md) blob `3b696947a3b2c400340eb005b4c410de8abae132` identifies wires 189/190/191 and proving switches 30/31/32, explicitly **unverified as-built**. Neither file identifies these as Bosch pilot-operated checks or supplies pilot, pressure, return or independent physical holding evidence. Thus **the Bosch warning is a screening question, not an observed OpenPressBrake defect**. This cross-repository commit was published 2026-10-29T12:37:58Z; audited here on 2026-10-30, not described as a newly changed hydraulic design.

## Practical human-factors engineering
For a small-shop dual-cylinder retrofit, the easiest safe decision is **do not add an apparently cheap check-valve "safety lock" based on a catalog holding claim**. Preserve a clearly labeled, independently reviewed hydraulic safety architecture and positive mechanical support for any person entering the ram hazard. Put paired-cylinder release and load-sharing questions on the same drawing as the normal Y1/Y2 servo valves and independent safety final elements, with a one-page reviewer signoff. Avoid manual overrides hidden under covers, undocumented hoses, ambiguous pressure taps and reset procedures that encourage a technician to defeat a valve.

## Qualified Stage A/conditional Stage B documentary discriminator — NO ENERGIZED TEST
Ask only for already-existing restricted as-built evidence: (1) cylinder type/orientation and mechanical coupling; (2) exact valve family/part numbers and symbols; (3) actuator-side hoses/rigid pipe and check/relief locations; (4) pilot and return paths for both Y1/Y2; (5) safety function/final-element specification; (6) mechanical restraint and maintenance/escape provisions. A qualified hydraulic engineer then determines whether the Bosch warning applies, whether a selected OEM-approved alternative exists, and what physical validation is later required under isolation. **Do not ask anyone to create a load-transfer fault, defeat a valve, move the ram, or enter the hazard to collect evidence.** Do not extend the short owner-facing A–G packet.

## Public open-book transfer prompts — UNSCORED
1. Two cylinders share a crosshead and both pilot checks are commanded open. One side opens first. Identify the **new** hazard even if each valve passed an individual leakage test.
2. A supplier describes a counterbalance valve as "pilot operated." Explain why this is insufficient to classify it as the Bosch on/off pilot check; identify the exact product evidence needed.
3. A technician says "the check is at the manifold, so the hose between manifold and cylinder can rupture without ram drop." What physical segment remains unproven?
4. A machine stops moving after pilot loss. Why does that observation not establish independent safe holding, service isolation, or deliberate restart?

These are practice questions, **not** an independent 2520–25F0 blind evaluation, machine validation, or permission for hazardous operation.

## Adversarial counter-reading (do not turn a strong warning into a false universal rule)
1. **Could a dual-Y machine still be engineered safely?** Yes, potentially, with an appropriate independently validated hydraulic/mechanical safety architecture; the Bosch statement addresses the described pilot-operated check approach, not every multi-cylinder valve or press-brake design. Selected circuit UNKNOWN.
2. **Does a valve being called a "poppet" make it a pilot check?** No. `11Y4/11Y6 FAST_POPPET` are source-derived names, not manufacturer model/function identifications. Require the actual symbol and part number before applying this note.
3. **Does intentional pilot-piston leakage mean the load seat is leaking?** Not necessarily. Sun's indexed 2023 excerpt describes an intentional **port 2-to-port 3 pilot-piston** leakage path in some products; do not confuse that with port 1-to-port 2 load-holding leakage, or assume all variants have it. Full PDF access blocked.
4. **Can a pressure sensor alone detect the asymmetric transfer soon enough to protect people?** Unknown. No sensor placement, dynamics, diagnostic timing, relief behavior, safety-rated reaction or stopping/holding witness is established. Ordinary FPGA telemetry cannot become personnel-safety authority by adding an alarm.
5. **Is a no-load bench opening test sufficient?** No. It does not establish coupled gravity-load redistribution, failure under specified faults or safe maintenance access. Do not deliberately create this dangerous failure without a qualified isolated validation plan.

## Claims, uncertainty and reopen rule
- **DOC-CONFIRMED:** Bosch original one-page paired-cylinder, hunting, location and pilot-ratio warnings; Sun original manufacturer-indexed nonmodulating/modulating distinction with full-PDF retrieval limitation.
- **SOURCE-CONFIRMED (repository only):** prior HOLD-01 and OpenPressBrake public Rev1 describe ordinary Y1/Y2 control separated from intended independent Pilz authority; no selected physical circuit verified.
- **INFERENCE:** a casual twin-cylinder check-valve retrofit can create a pressure-transfer failure and encourage false confidence.
- **UNKNOWN:** selected Y1/Y2 valve types, pilot logic, pressure, load distribution, stop time, hold duration, relief behavior, installed safety program, physical safe state, PL/SIL and personnel exposure.
- **TEST-CONFIRMED:** none. No simulation or hardware operation justified; manufacturer warning already answers the design-screening question. Reopen only with qualified restricted as-built circuit evidence and a concrete unresolved design-specific safety question.
- **Gate:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; **no personnel-exposed hazardous operation**. Independent evaluator OPEN; no hosted/self-hosted compute.

## Predecessors and next work
- [Existing HOLD-01 module](../safety-course/4400_HOLD_01_CYLINDER_SIDE_LOAD_HOLD_RELIEF_OVERRIDE_AND_RESTART_MODULE_2026-10-25.md)
- [Existing Rexroth A-VBC-90/Parker E2 OEM audit](4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md)
- [One-screen qualified Stage A status](../safety-course/4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md)

**Next:** qualified A–G and independent 2520–25F0 evaluation first; if unavailable, continue a genuinely new source-level safety question rather than adding duplicate unscored worksheets. Preserve the separate PI500 upstream review packet.
