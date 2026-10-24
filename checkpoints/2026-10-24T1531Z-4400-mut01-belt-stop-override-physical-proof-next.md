# Active continuation — 4400-MUT-01 conveyor muting, override, belt-stop timers and fresh restart
**Session UTC start:** 2026-10-24T15:31:25.990Z recorded before substantive work. **SOURCE-READING / NOT GRADUATED / NO PHYSICAL TEST.** Supersedes 2026-10-24T1438Z SET-01 for next-work selection, preserving all previous safety gates and evidence.

## Governance recovered
Read START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind feedback protocol/log, LAB_COMPUTE_LOG, full latest 14:38Z checkpoint, safety index, SET-01, selected-machine intake, cumulative design package and lesson log. Main head at session entry 76ebd0702724cacec0ffa370e46303a0d7df7d5d. Previous session ended 14:45:51.105Z, 45.58 min before start. No known overlap; external concurrent edits not independently excluded. 1000/2000/F02/3000 formally CLOSED; 4000 safety priority, routine board design belongs elsewhere.

## Seven new original documents
1. [SICK original deTec4 HG February 2026 muting/belt-stop/override source audit](../research/4400_SICK_DETEC4_HG_MUTING_BELT_STOP_OVERRIDE_TIMER_SOURCE_AUDIT_2026-10-24.md).
2. [Rockwell FSBM zero-timer/override/restart source audit](../research/4400_ROCKWELL_FSBM_ZERO_TIMER_OVERRIDE_AND_RESTART_SOURCE_AUDIT_2026-10-24.md).
3. [IEC 62046:2026 publisher edition/scope audit](../research/4400_IEC_62046_2026_MUTING_WHOLE_BODY_STANDARD_EDITION_SCOPE_AUDIT_2026-10-24.md).
4. [4400-MUT-01 integrated non-graduated module](../safety-course/4400_MUT_01_MUTING_SEQUENCE_OVERRIDE_BELT_STOP_AND_RESTART_MODULE_2026-10-24.md).
5. [18-case paper technician card](../safety-course/4400_MUTING_TIMEOUT_OVERRIDE_HUMAN_ENTRY_TECHNICIAN_CARD_2026-10-24.md).
6. [Blank qualified selected-machine witness](../safety-course/4400_MUTING_AS_BUILT_STOP_HOLD_RESTART_BLANK_WITNESS_2026-10-24.md).
7. [Independent novel evaluation handoff](../evaluation/4400_MUT_01_FRESH_MUTING_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT RUN/NOT SCORED.

## Source/provenance boundaries
**DOC-CONFIRMED from directly inspected original 284-page SICK 8023856/1SWC/2026-02-05 pp42–60:** SP2 24-hour total/concurrence default, belt-stop pauses timer but monitors active sensor/field state, override can restore OSSD ON with blocked field, counter resets on power, connector-specific 50 ms sensor offset. **DOC-CONFIRMED official Rockwell 38-03 manufacturer online instruction help (indexed content, direct HTML timeout):** FSBM 0 disables various timers, override O1 can energize despite Input Status false/fault, automatic/manual restart and change-application caveats. **DOC-CONFIRMED publisher scope only:** IEC 62046:2026 issued July 28, revised muting/whole-body topics; full normative clauses UNKNOWN. **INFERENCE:** ergonomics, side gaps/tailgating and maintenance recovery controls. **TEST-CONFIRMED:** none. Exact installed OpenPressBrake muting equipment, Y1/Y2 stop/hold and physical rearm UNKNOWN. Never assign personnel safety authority to LinuxCNC/FPGA.

## Release/compute
Design §§11CD–11CF, selected conditional IN-04w. All 18 cases PAPER ONLY; fresh evaluator OPEN; selected physical VAL/PT NOT RUN, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Zero hosted and local Actions compute, no workflow dispatched or simulation, no new authoritative runtime. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged; historical exact archive 6/85 pending. No personnel-exposed hazardous operation authorized; experimental machine work only isolated/remote with people outside hazard and explicit residual risk.

## Precise next-work selection
1. Briefly check for restricted actual OpenPressBrake Y1/Y2 safety drawings, installed optical/guard/override device identity, physical independent stop/hold/restart evidence and an external evaluator result. Do not publish private as-built information. If muting absent, mark device-specific IN-04w N/A after inventory; still prove actual guarding/stop/hold.
2. If muting present, obtain exact OEM revision/firmware, as-built muting sensor/field geometry, time/zero semantics, belt-stop/override trust boundary, final-element and occupancy evidence. Only qualified independent physical measurements can close gates.
3. If a qualified adopted-standards review becomes available, reconcile IEC 62046:2026 actual clauses with prior edition and machine-specific standards; publisher abstract alone cannot support numeric rules.
4. Obtain a genuinely information-separated fresh evaluator; never self-score the public 18 cases.
5. If physical/evaluator gates blocked, rotate to a different high-value 4400 safety source path (e.g. loss of safety-controller configuration authenticity/firmware identity, independent mechanical restraint or other uncovered failure mode), not old 3300 work or arbitrary simulation. Preserve start/end/elapsed/overlap via full SHA-guarded LESSON_LOG immediately before exit; commit. Keep hourly curriculum enabled.

## Learning-method observation
The same word 'muting timeout' hides opposite vendor configuration semantics: SICK SP2 default 24 h and paused belt-stop timers versus Rockwell FSBM zero-disabled timers. A product/firmware/configuration identity is a prerequisite for teaching a safe decision; cross-OEM generalization without it is a source-interpretation failure.

## Same-session second branch (2026-10-24, after MUT-01 source audit)
Original [SICK Smart Box Detection and object-pattern recognition audit](../research/4400_SICK_SMART_BOX_OBJECT_PATTERN_RECOGNITION_OVERRIDE_AND_COVERAGE_AUDIT_2026-10-24.md) plus [12 technician paper cases](../safety-course/4400_SMART_BOX_VS_MUTING_AND_PATTERN_RECOGNITION_TECHNICIAN_CARD_2026-10-24.md) add the *alternative to muting* selection question. **DOC-CONFIRMED** exact 2026 OEM: SBD normally monitors field for invalid objects; **SBD Override suspends field monitoring**; product-specific 14 mm/geometry/0.1–1.0 m/s, person+object recognition exclusion and configuration readback matter. This is not selected machine proof. Add cumulative §11CG and conditional IN-04x UNKNOWN. **Nine original documents and 30 PAPER scenarios total this session.** No compute, external evaluation or physical validation. Next priority remains actual independent Y1/Y2 safety/guard/restart evidence and fresh evaluator; if blocked, rotate to another genuinely uncovered 4400 safety source branch.

## Same-session third original source transfer
[Leuze SPG and five-lane scanner-field OEM case audit](../research/4400_LEUZE_SPG_MULTILANE_DYNAMIC_FIELD_REAL_INSTALLATION_TRANSFER_AUDIT_2026-10-24.md) adds real manufacturer-reported implementations and adjacent-lane human-entry failure path. **DOC-CONFIRMED OEM case reports, NOT TEST-CONFIRMED**. Cumulative §11CH. Total **10 original documents, 30 paper scenarios**, zero hosted/local compute, zero physical validation, zero external evaluation. Still prioritize actual OpenPressBrake independent Y1/Y2 stop/hold/guard/restart; conditional conveyor branches do not displace it.
