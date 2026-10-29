# 2026-10-29T16:40:47.419Z — 4400 rope-pull E-stop OEM safety continuation

## Session start and governance
- Start UTC: **2026-10-29T16:40:47.419Z**, captured in tool output before substantive work and preserved in [start witness](2026-10-29T164047Z-session-start-safety.md).
- START_HERE read first; mission, level order, work selection, source policy, module template, curriculum, progress, 2530 entry, latest 15:31Z checkpoint, safety entry/index/research, blind feedback protocol/score and lab ledger consulted.
- 1000/2000/F02/3000 CLOSED; 4000 safety course remains primary. Last known completed same-curriculum session ended 2026-10-29T15:45:55.483Z, **54.87 minutes** before this start; no known same-curriculum overlap; other-automation overlap UNKNOWN.

## New evidence — original source and practical transfer
- [Rockwell/Schmersal original-manual audit](../research/4400_ROPE_STOP_01_ROCKWELL_SCHMERSAL_PULL_WIRE_TENSION_BREAK_RESET_VISIBILITY_OEM_AUDIT_2026-10-29.md) and [unscored technician card](../safety-course/4400_ROPE_STOP_01_CABLE_PULL_ESTOP_TENSION_WARNING_RESET_VISIBILITY_TECHNICIAN_CARD_2026-10-29.md) document a distinct **long-span E-stop input** mechanism, not duplicate general 2530 E-stop teaching. Exact OEM manuals inspected: Rockwell Lifeline 5 **440E-IN008H-EN-P February 2026** (20 pages) and Schmersal ZQ700 **573753-EN/C September 2021** (six pages). Official ISO 13850:2015 catalog abstract inspected; full normative text NOT read.
- **DOC-CONFIRMED** Rockwell Table 6/7: low/high marginal tension may show GREEN with amber flash and safety outputs still ON, while cable cut/not-tensioned is safety OFF. **DOC-CONFIRMED** Schmersal ZQ700: pull/break activates latched stop; correct pretension and cause inspection required before reset. **DOC-CONFIRMED** Rockwell manual: cable span must be visible at reset or inspected along its full length before/after, and all pull directions require qualified validation. This does not establish personnel clearance or physical safe state.
- **INFERENCE:** obscured tension warnings and inconvenient reset/inspection create predictable defeat/maintenance risk. **TEST-CONFIRMED:** none. **UNKNOWN:** actual installed cable, physical routing, controller inputs, final elements, stopping/holding, zone-clear, restart behavior and operator practice.
- Updated CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, and full learner index. No duplicate graded competency. Existing 2530, 4400-GUARD-01 and RST-01 remain prerequisites.

## Unchanged release and evaluation boundaries
- No qualified restricted OpenPressBrake Stage A A–G evidence and no information-separated 2520–25F0 external score. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. No personnel-exposed hazardous operation.
- Zero hosted and zero self-hosted compute. No workflow, test suite, simulation, build, synthesis, physical test, machine actuation or evaluator. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. GitHub connector has no exposed self-hosted runner inventory/dispatch; panel-PC physical isolation UNKNOWN. Do not use hosted fallback or dispatch local compute until both verified.

## Precise next work
1. Briefly recheck qualified restricted OpenPressBrake Stage A A–G and independent 2520–25F0 evaluator, without self-scoring or requesting hazardous field tests.
2. If no new evidence, select a *different* high-consequence 4400 safety failure-path or OEM source discrepancy after scanning full index/research/progress and nearest predecessor. Do not repeat rope-pull, trapped-key or VFD-exit audits just to fill time.
3. For any actual cable-pull installation, request exact model/edition, passive routing/reset-visibility evidence, selected independent safety circuit and final-element documents; qualified physical validation only under separately approved energy-controlled procedures. Do not imply the press brake uses a rope switch.
4. Frozen two-spindle software-only discriminator from 15:31Z remains NOT RUN pending local runner access **and** independently verified physical I/O isolation.
5. Append complete LESSON_LOG using current verified SHA immediately before end; preserve actual UTC end/elapsed/overlap, commit to main, keep automation enabled.
