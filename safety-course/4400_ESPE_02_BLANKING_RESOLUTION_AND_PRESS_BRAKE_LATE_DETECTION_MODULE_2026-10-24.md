# 4400-ESPE-02 — Blanking, effective resolution, optical holes and late press-brake detection
**Status:** SOURCE-READING / NOT GRADUATED. **Level:** 4000 safety-oriented implementation. **Date:** 2026-10-24.
**Prerequisites:** 2520, 2530, 2590, 25E0, 4400-ESPE-01; source-reading branch does not reopen graduated 1000–3000.

## Learning outcomes
A fresh engineer should be able to (1) distinguish monitored fixed blanking, floating complete/partial object monitoring, reduced resolution, muting and bypass; (2) identify a logical green field that still contains a physically accessible hole; (3) select *effective* rather than nameplate physical resolution for inspection and protective-distance review; (4) reject transferring 1910.217 mechanical-power-press rules to a press brake; (5) distinguish sensor detection, independent stop, gravity holding and fresh restart; and (6) design guards that make legitimate tooling changes practical without encouraging defeat.

## Required reading (in order)
1. [SICK C4000 original-manual source audit](../research/4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md), then original OEM C4000 8009861/YT64/2016-02-25 §§4.8–4.11 and 7.3.3.
2. [OSHA press-brake vs mechanical-press scope and late laser detection](../research/4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md), then OSHA 1910.217(a)(5), 1910.212, CPL 02-01-025 and 2004 laser interpretation with stated direct-page retrieval limits.
3. Existing [4400-ESPE-01 scanner signal semantics](4400_ESPE_01_SAFETY_SCANNER_EFI_SIGNAL_SEMANTICS_AND_RESTART_MODULE_2026-10-24.md) and [ISO 13855:2024 source-scope audit](../research/4400_ISO13855_2024_SEPARATION_DISTANCE_SCOPE_STOP_TIME_AND_GRAVITY_EXCEPTION_2026-10-24.md) to avoid confusing field selection and response time with machine physical stopping.

## Functional chain — NOT an installed circuit
```text
Hazard/reach geometry -> exact sensing field + any blanked aperture
                       -> exact safety-rated output and controller
                       -> qualified independent final element(s)
                       -> physically witnessed stop / hold / access
                       -> independent restart inhibit + fresh start
LinuxCNC/FPGA/HMI: ordinary motion request + non-authoritative diagnostics ONLY.
Service: independent all-energy isolation and load restraint.
```

## Distinguishing six questions
1. **Which area is actually sensed?** Plot each protected sub-area, blocked beam, blanked object and reachable aperture from every side and for each tooling/stock state.
2. **What does an absent object mean?** In SICK C4000 Advanced 2016, monitored fixed object removal demands red; floating partial monitoring does **not** require an object to occupy the region. Do not treat “object monitoring” as a universal boolean.
3. **What size is detected?** Record effective resolution at every relevant location, tolerance and mode. SICK's 14-to-22 mm example is *only* its specified configuration, not a selected-machine value.
4. **Does red arrive before harm?** Optical interruption and machine physical stop are different propositions. A blade-mounted detector that trips after the hand enters the die is not protective by virtue of being safety-rated.
5. **Who prevents restart?** OSSD restoration, scanner reset, PLC rearm and new ordinary cycle command must be distinct where the risk requires it. Do not let retained LinuxCNC start demand restart motion.
6. **Is protection usable?** If operators routinely remove a guard to load parts, redesign stock feed, slot geometry, accessible clamps, sensor position and quick-reinstall barrier. Do not encode bypass as a normal convenience feature.

## Worked source-reading discriminators
| Scenario | Correct boundary |
|---|---|
| Fixture present in fixed monitored blanking; OSSD green | Device state may be expected; independently prove that hard guards close all remaining reach gaps. |
| Fixture removed from floating **partial** object-monitoring region; OSSD remains green | Consistent with cited OEM behavior; **not** proof of safe access. |
| 14 mm physical, reduced by one beam in cited C4000 configuration | 22 mm effective **in that OEM example**; test rod and separation review follow effective value. |
| PLC OSSD off and ram still descends due to gravity | Optical chain does not prove load holding; safety architecture/physical restraint still missing. |
| 1910.217 mechanical-power-press example used to justify press-brake muting | Reject direct regulatory transfer: 1910.217(a)(5) excludes press brakes; assess under 1910.212 and applicable current standards. |
| Laser under die changes state only when hand is in point of operation | Late detection can be nonprotective; 2004 OSHA letter rejects the specific proposed arrangement. |

## Practice and evidence
Complete [16 paper adversarial cases](4400_BLANKING_RESOLUTION_LATE_DETECTION_TECHNICIAN_CARD_2026-10-24.md) and [blank selected-machine verification worksheet](4400_OPTICAL_BLANKING_FIELD_AND_RESTART_BLANK_WITNESS_2026-10-24.md). All paper cases are **NOT PHYSICAL TESTS**. No human-as-target motion tests. Use safe isolated test objects and qualified engineering acceptance procedures only when selected machine evidence exists.

## Claims and limitations
**DOC-CONFIRMED:** original SICK C4000 2016 product-specific behavior and OSHA regulatory scope. **INFERENCE:** transferable human-factors and fault-path design. **UNKNOWN:** selected OpenPressBrake optical model, blanking, reach geometry, effective resolution, physical stop/hold, safety PLC wiring, restart and machine-level integrity. **TEST-CONFIRMED:** none. Exact current standard/edition, actual machine safety performance and release remain open.

## Graduation / promotion
**NOT GRADUATED.** Missing selected machine physical `PHY/VAL/PT`, fresh information-separated external evaluation and actual configuration proof. Transfer retest must use a *different* manufacturer/model and a different obstruction geometry; no self-scored benchmark. Revisit original OEM if a current edition supersedes 2016. Lab frozen: no simulation resolves selected geometry or measured hydraulic stop/hold. Conditional `IN-04u UNKNOWN`, `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`. No personnel-exposed hazardous operation authorized.
