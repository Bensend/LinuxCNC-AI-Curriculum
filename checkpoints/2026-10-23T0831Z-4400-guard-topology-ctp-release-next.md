# 4400 safety checkpoint — GuardLink topology causal proof + EUCHNER CTP interface boundaries

Session start UTC: **2026-10-23T08:31:58Z**. Previous known completed session ended 2026-10-23T07:49:37Z (42m21s before this start). No overlap with that known session; external concurrency unverified.

## Durable results on main

1. Exact archived Git blob SHA `9af734c064cc11ed8fcdaee78c55392b582dcb23`: `research/4400_432ES_APPENDED_NODE_INACTIVE_SAFETY_FUNCTION_SOURCE_TRACE_2026-10-23.md`.
2. Exact archived Git blob SHA `3bfb2f158843ddcade042ea703d97ca4df087ce2`: `safety-course/4400_GUARDLINK_NODE_CHANGE_PHYSICAL_PROOF_TECHNICIAN_CARD_2026-10-23.md`.
3. Exact archived Git blob SHA `0b1b1e7e26160cb90c69515e1fc95f78df89356d`: `research/4400_CTP_SAFE_RECEIVER_VS_SOLENOID_PULSE_INTERFACE_NOTE_2026-10-22.md`.
4. Exact archived Git blob SHA `de7597dd01334fadf93d176402fdd9527095b8ba`: `safety-course/4400_CTP_STATE_TABLE_REPLACEMENT_ADVERSARIAL_CARD_2026-10-22.md`.
5. Cumulative `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` §11C now requires causal guard-change proof, independent physical witness, and stale dependency tracking.
6. `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` now separates OSSD output-test pulse, solenoid-control pulse, and UB supply interruption parameters.
7. `safety-course/SAFETY_COURSE_INDEX.md`, `PROGRESS.md` and `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md` updated.

**Archive-relative pending publication: 75 of 85** original staged learner-visible candidates, assuming no concurrent publication. Do not bulk overwrite; inspect each destination and manufacturer edition, preserve exact blob identity and provenance. Original consolidated archive: `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip` (conversation artifact, not a repo file).

## Source/evidence boundary

- **DOC-CONFIRMED:** Rockwell `432ES-UM001E-EN-P` June 2025, Chapter 5 pp. 49, 51, 58: some online changes possible, but topology changes require safety-function verification before production; incorrect append sequence can leave a new safety device inactive. Official manual: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf .
- **DOC-CONFIRMED:** EUCHNER `2126290-08-07/24` §10.9 and `2124217-08-06/21` §10.10: FO1A/FO1B receiver must support selected pulsed OSSD signals; a separately stated 5 ms limit refers to solenoid-control pulses and another 5 ms to UB supply interruptions. Product/manual links are in the published source note.
- **INFERENCE:** A guard's physical presence, node count, fault clear or safety output already OFF cannot prove the new guard caused a protective transition. Likewise, a 5 ms tolerance at one port cannot qualify a different receiver.
- **UNKNOWN/NOT RUN:** installed products, exact safety-program/configuration, as-built zone mapping, hydraulic truth table, actual stop/hold, machine physical witnesses, restart/occupancy, PL/SIL, limits/intervals. No physical or laboratory tests; no GitHub-hosted compute.

## Exact next-work order

1. Check `LESSON_LOG.md` and immutable `timing-queue/*.row` for this session's timing. Never overwrite the occupied `TIMING_APPEND_REQUEST.txt` or a partial log fetch. Previous self-hosted append job `39919548510` / `120301190483` was still QUEUED at this session's first check; re-check authoritative status before adding any LAB_COMPUTE_LOG entry. It is **not** a simulation/test job and queued time is not compute.
2. Continue reviewing/publishing the **75** archived candidates in coherent, source-confirmed groups. Prioritize guard diagnostic fault masking and exact reset/rearm ownership or hydraulic physical-witness contradiction, rather than manufacturing more 3000 work. Verify destination absent, original Git blob SHA, source links and edition before committing.
3. Where useful, integrate reviewed material into cumulative `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/PT/CHG/RR/UNK` package fields. Avoid duplicating the existing eight-field SO final-element witness contract.
4. For actual installed hardware, demand independently measured machine stopping/holding/access/energy proof; a manufacturer's sample state table or controller status cannot substitute. If basic minimum safe-to-operate protection is unproved, no people may be exposed; isolated/remote experimental work only with residual risks controlled.
5. Maintain information separation: 2520–25F0 fresh/external competency gates OPEN. Do not self-score sealed answers or claim graduation.
6. No GitHub-hosted Actions compute. Only a concrete unresolved executable question justifies a bounded self-hosted workflow on `[self-hosted, openpressbrake]`; source/documentation study should continue otherwise.

Session end/elapsed to be recorded in `LESSON_LOG.md` immediately before finishing via safe full-file append or immutable request. No authoritative new lab runtime was observed.
