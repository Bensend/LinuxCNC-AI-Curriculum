# 4400 safety continuation — RCD-01 waveform and RCD-02 trip-power / neutral-loss
**Start UTC:** 2026-10-26T11:36:25.291997965Z, captured by clock before substantive work and [durably committed](2026-10-26T113625Z-session-start-safety.md). **End/elapsed/overlap:** append to full LESSON_LOG immediately before session end using current blob SHA.

## Current governance
START_HERE first; MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, BLIND_FEEDBACK_PROTOCOL, FEEDBACK_SCORE_LOG and LAB_COMPUTE_LOG reviewed. 1000/2000/F02/3000 GRADUATED/CLOSED; 4400 safety first. Latest prior checkpoint 2026-10-26T10:35:59Z. 2520–25F0 external evaluator OPEN, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No new private OpenPressBrake Stage A A–G physical evidence. Never infer selected hardware.

## Six new original files — four RCD originals verified from main, IMD pair added
1. [RCD-01 ABB/Rockwell/Schneider/OSHA exact source audit](../research/4400_RCD_01_ROCKWELL_PF527_ABB_SCHNEIDER_WAVEFORM_AND_LEAKAGE_OEM_AUDIT_2026-10-26.md).
2. [RCD-01 learner module, six public PAPER cases UNSCORED and eight no-energy desk gates NOT RUN](../safety-course/4400_RCD_01_DC_LEAKAGE_RCD_TYPE_AND_PE_NO_SHORTCUT_FIELD_MODULE_2026-10-26.md).
3. [RCD-02 ABB/Schneider voltage-dependent trip-power, neutral-loss and FE/PE original audit, with IET scope check](../research/4400_RCD_02_VOLTAGE_DEPENDENT_TRIP_NEUTRAL_LOSS_FUNCTIONAL_EARTH_OEM_AUDIT_2026-10-26.md).
4. [RCD-02 four public PAPER cases UNSCORED and six documentary gates NOT RUN](../safety-course/4400_RCD_02_NEUTRAL_LOSS_TRIP_POWER_AND_RESTART_FIELD_CARD_2026-10-26.md).
5. [IMD-01 original Bender/OSHA first/second and symmetrical insulation-fault control audit](../research/4400_IMD_01_UNGROUNDED_CONTROL_FIRST_FAULT_SECOND_FAULT_AND_VFD_VARIANT_OEM_AUDIT_2026-10-26.md).
6. [IMD-01 five public PAPER cases UNSCORED and seven documentary gates NOT RUN](../safety-course/4400_IMD_01_FIRST_FAULT_REPAIR_AND_SECOND_FAULT_NO_ENERGY_FIELD_CARD_2026-10-26.md).

**Novelty discipline:** existing 2026-10-25 PANEL-01 (multi-feed/SCCR/arc flash), BOND-01 (door hinge/PE) and 2026-10-24 DCB-01 (common DC bus) were inspected before claiming novelty. RCD-01 specifically adds *waveform and OEM RCD/RCM compatibility*; RCD-02 adds *trip-power dependency, neutral loss and FE redundancy*. IMD-01 is a separate *unearthed control-circuit insulation-monitoring* branch, including Bender's original symmetrical high-resistance input-fault mechanism and iso415R/iso685 VFD application mismatch. No previous electrical-isolation discovery was rebranded.

## Source and claim ledger
- **DOC-CONFIRMED direct original ABB 2022 RCD white paper:** AC/A/F/B waveform sensing, Type B smooth-DC detection, RCD internal test button simulates residual current, VI vs VD trip-power, FE is functional not protective earth.
- **DOC-CONFIRMED direct original Schneider OEM pages:** ATV12 Type A SI FAQ is contextual; separate 3-phase Type B guidance; category-1 VD may remain closed under neutral-loss trip-power failure whereas category-2 opens on supply loss; some category-1 variants use FE redundancy. These are product descriptions, not universal standards.
- **DOC-CONFIRMED Rockwell 520-UM002F-EN-E Sept 2025 original manufacturer indexed excerpt only:** PowerFlex 527/520-series PE leakage and Type-B-only upstream RCD/RCM requirement *if used for contact protection for that product*. Direct 27.9 MB PDF fetch failed size limit; do not claim visual page inspection. No contradiction with Schneider ATV12 recommendation because different products and assumptions.
- **DOC-CONFIRMED OSHA 1910.304/1910.333** official indexed and directly opened full e-CFR mirrored text; RCD is not protective-earth substitute or lockout. **IET 2026 E1/E2/E3** professional UK single-dwelling island-mode context only; not U.S. CNC code.
- **DOC-CONFIRMED direct Bender OEM:** two symmetrical high-resistance faults can falsely SET some sensitive control inputs without conventional RCD imbalance or fuse operation; displacement-only detectors may miss symmetrical faults. iso415R main-circuit application without VFDs versus iso685 inverter-compatible family. Bender's EN 60204-1 description is manufacturer summary, not directly inspected standard text.
- **INFERENCE:** nuisance trips may encourage PE/filter bypass or improper threshold increase; RCD correct electrical trip may worsen gravity-loaded machine state; ordinary test button cannot prove installed PE, neutral-loss behavior or physical Y1/Y2 holding; first/second insulation fault consequences require exact machine analysis.
- **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** selected OpenPressBrake drive, RCD, FE/PE, site fault path, leakage, actual machine stop/hold, PL/SIL, electrical safety acceptance, external score.

## Integration and checks
Updated CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, learner index and cumulative Safety Design Package **§§11HG–11HH**. Four RCD originals independently fetched nonempty from main and found in index; their six distinct relative links independently resolved. The IMD original pair and its links must also be independently verified before session end. **Six originals, 15 public PAPER cases UNSCORED, 21 no-energy documentary gates NOT RUN, no independent evaluator executed.** This is not a whole-repository link audit.

## Compute / physical release
**0 GitHub-hosted Actions minutes, 0 local lab compute minutes.** No workflow dispatched, no simulations, builds, synthesis, benchmarks, tests, energized electrical experiments or machine tests. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged because no new authoritative runtime/score. Prior self-hosted runner-access blocker not retested because no compute question justified it. No hosted fallback. **G0/G1 HOLD, no personnel-exposed hazardous operation.**

## Precise next-work priority
1. Obtain qualified **private** OpenPressBrake Stage A A–G as-built evidence for independent Y1/Y2 stop and gravity-load hold, hydraulic pressure-zone isolation, guards/inside escape, maintenance isolation, deliberate local reset/restart. Do not publish private drawings or transfer generic RCD findings into actual machine selection.
2. Execute genuinely information-separated 2520–25F0/4400 competency evaluation with a separate fresh evaluator. All public cases remain UNSCORED; do not inspect hidden answers or self-grade.
3. If external gates unchanged, rotate to a **distinct** high-value 4400 safety mechanism after full learner index/research novelty check. Avoid further unscored RCD-01/02 elaboration without new exact-product or selected-machine evidence; the source-only RCD branch is at a coherent information-gain stop.
4. Keep normal controller-board work in its separate automation. If a *specific* safety question truly requires compute, target only [self-hosted, openpressbrake]; if unavailable, record blocker and continue no-compute work.

## Short-session continuation
After RCD-01 waveform/OEM variant transfer, rotated to RCD-02 neutral-loss trip-power, then to the **distinct** IMD-01 unearthed-control first/second and symmetrical fault mechanism after inspecting the index for novelty. Further generic electrical-source repetition is now low marginal value without selected-machine evidence. Preserve G0/HOLD rather than fabricate a physical lab or score. Recurring curriculum stays enabled.
