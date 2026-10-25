# 4400 safety continuation — SCAN-01/02/03 original S300 EFI restart, geometry and park/standby
**Session UTC start:** 2026-10-25T21:33:55.118Z, captured before START_HERE and source work; [durable start marker](2026-10-25T213355Z-session-start-safety.md). Supersedes [20:39Z TEACH/OVERRIDE checkpoint](2026-10-25T203933Z-4400-teach01-optical-rearm-physical-next.md) for work selection only.

## Governance and status
START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind protocol/score, compute ledger, safety index, cumulative safety package and active checkpoint reviewed. **1000/2000/F02/3000 GRADUATED/CLOSED**; **4400 safety** active. Separate board-design automation owns routine electronics. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. Physical selected OpenPressBrake Y1/Y2 independent stop/hold, hydraulic isolation, guards, escape and deliberate restart remain UNKNOWN.

## Nine original artifacts
1. [S300 2025 EFI field-status versus OSSD restart audit](../research/4400_SICK_S300_2025_EFI_FIELD_STATUS_BYPASSES_INTERNAL_RESTART_INTERLOCK_AUDIT_2026-10-25.md)
2. [S300 2025 near-range/contour/monitor-case timing audit](../research/4400_SICK_S300_2025_UNSECURED_NEAR_FIELD_CONTOUR_AND_MONITOR_CASE_TIMING_AUDIT_2026-10-25.md)
3. [SCAN-01 learner module](../safety-course/4400_SCAN_01_EFI_FIELD_STATUS_VS_OSSD_RESTART_AUTHORITY_MODULE_2026-10-25.md)
4. [SCAN-02 learner module](../safety-course/4400_SCAN_02_UNSECURED_GEOMETRY_CASE_SWITCH_AND_CONTOUR_REFERENCE_MODULE_2026-10-25.md)
5. [24 public SCAN-01/02 PAPER cases UNSCORED](../safety-course/4400_SCAN_01_SCAN_02_TWENTY_FOUR_PUBLIC_TECHNICIAN_CASES_2026-10-25.md)
6. [12 blank G0 documentary gates NOT RUN](../safety-course/4400_SCAN_01_TWELVE_GATE_NO_ENERGY_RESTART_SIGNAL_PATH_REVIEW_2026-10-25.md)
7. [Fresh evaluator PREPARED/NOT RUN](../evaluation/4400_SCAN_01_FRESH_EFI_RESTART_AND_GEOMETRY_TRANSFER_HANDOFF_2026-10-25.md)
8. [S300 park/standby common-versus-separate OSSD audit](../research/4400_SICK_S300_2025_PARK_STANDBY_COMMON_VS_SEPARATE_OSSD_REACTIVATION_AUDIT_2026-10-25.md)
9. [8 additional public SCAN-03 PAPER cases UNSCORED](../safety-course/4400_SCAN_03_EIGHT_PARK_STANDBY_MODE_AND_REARM_PAPER_CASES_2026-10-25.md)

## Original source and claims
**DOC-CONFIRMED exact OEM:** SICK S300 original **8010948/ZD76/2025-08-19**, https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf; §7.10 p.89 explicitly says internal scanner restart interlock does **not** affect Flexi Soft when consuming protective-field EFI status (versus OSSD status), so downstream interlock required. §§4.3.2–4.3.3 pp.31–35: 5 cm near range and monitoring-case switch advance; §§7.12.3–7.12.4 pp.94–96: field auto-suggestion not a distance calculation, contour reference geometry; §7.13.6 pp.104–105: park/standby OSSD effects differ for common vs separate outputs; p.121 non-error park display with laser OFF. **INFERENCE:** independent occupancy, rated rearm, fresh motion request and physical Y1/Y2 stop/hold. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** installed variant, configuration, EFI routing, actual stop time, pressure and performance level. No automatic machine motion or installed S300 claim.

## Integration
Updated CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, learner safety index and cumulative Safety Design Package **§§11FM–11FO**. Nine originals, **32 public PAPER cases UNSCORED**, **12 G0 documentary gates NOT RUN**, external fresh evaluator PREPARED/NOT RUN. No physical testing, simulations, builds, synthesis, benchmark, Actions dispatch or new authoritative runtime; **0 GitHub-hosted and 0 self-hosted lab minutes**. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Previously reported local runner-access blocker not retested because no compute justified; never hosted fallback.

## Precise next work
1. **Highest-value external gate:** qualified private selected OpenPressBrake G0 machine ID and actual Y1/Y2 independent physical stopping/gravity holding, hydraulic isolation and bleed/rescue, guards/whole-body occupancy, reset/restart and actual device configuration. Public repo may record generic gate status only, never proprietary as-built drawings or private configuration.
2. **Independent fresh evaluator:** information-separated 2520–25F0 / 4400 transfer results, including SCAN handoff; do not self-score, expose hidden oracle or credit 32 public cases as blind.
3. **If both unavailable:** select a *distinct* unresolved 4400 safety question from authoritative exact OEM, standards or pinned LinuxCNC source. Do not repeat S300/TEACH/OVERRIDE without new discriminator; consider personnel trapping/escape or faulted hydraulic final-element independence if new inspectable source evidence is available.
4. Compute only if a concrete unresolved executable question survives source reasoning. Use bounded **[self-hosted, openpressbrake]** workflow exclusively; if runner unavailable, record blocker and continue source work. Never hosted fallback.

## Short-session continuation and physical boundary
After SCAN-01 restart signal mapping, rotated to separate SCAN-02 coverage/field switching and then SCAN-03 standby topology from original 2025 OEM. Additional synthetic simulation cannot establish selected machine geometry or Y1/Y2 gravity holding. No personnel-exposed operation authorized; experimental operation must remain isolated/remote with people outside hazard zone and residual risks recorded. UTC end, elapsed and overlap status must be appended safely to full LESSON_LOG immediately before ending.
