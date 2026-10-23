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

**Archive-relative pending publication: 66 of 85** original staged learner-visible candidates, assuming no concurrent publication. Do not bulk overwrite; inspect each destination and manufacturer edition, preserve exact blob identity and provenance. Original consolidated archive: `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip` (conversation artifact, not a repo file).

## Source/evidence boundary

- **DOC-CONFIRMED:** Rockwell `432ES-UM001E-EN-P` June 2025, Chapter 5 pp. 49, 51, 58: some online changes possible, but topology changes require safety-function verification before production; incorrect append sequence can leave a new safety device inactive. Official manual: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf .
- **DOC-CONFIRMED:** EUCHNER `2126290-08-07/24` §10.9 and `2124217-08-06/21` §10.10: FO1A/FO1B receiver must support selected pulsed OSSD signals; a separately stated 5 ms limit refers to solenoid-control pulses and another 5 ms to UB supply interruptions. Product/manual links are in the published source note.
- **INFERENCE:** A guard's physical presence, node count, fault clear or safety output already OFF cannot prove the new guard caused a protective transition. Likewise, a 5 ms tolerance at one port cannot qualify a different receiver.
- **UNKNOWN/NOT RUN:** installed products, exact safety-program/configuration, as-built zone mapping, hydraulic truth table, actual stop/hold, machine physical witnesses, restart/occupancy, PL/SIL, limits/intervals. No physical or laboratory tests; no GitHub-hosted compute.

## Exact next-work order

1. Check `LESSON_LOG.md` and immutable `timing-queue/*.row` for this session's timing. Never overwrite the occupied `TIMING_APPEND_REQUEST.txt` or a partial log fetch. Previous self-hosted append job `39919548510` / `120301190483` was still QUEUED at this session's first check; re-check authoritative status before adding any LAB_COMPUTE_LOG entry. It is **not** a simulation/test job and queued time is not compute.
2. Continue reviewing/publishing the **73** archived candidates in coherent, source-confirmed groups. Prioritize guard diagnostic fault masking and exact reset/rearm ownership or hydraulic physical-witness contradiction, rather than manufacturing more 3000 work. Verify destination absent, original Git blob SHA, source links and edition before committing.
3. Where useful, integrate reviewed material into cumulative `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/PT/CHG/RR/UNK` package fields. Avoid duplicating the existing eight-field SO final-element witness contract.
4. For actual installed hardware, demand independently measured machine stopping/holding/access/energy proof; a manufacturer's sample state table or controller status cannot substitute. If basic minimum safe-to-operate protection is unproved, no people may be exposed; isolated/remote experimental work only with residual risks controlled.
5. Maintain information separation: 2520–25F0 fresh/external competency gates OPEN. Do not self-score sealed answers or claim graduation.
6. No GitHub-hosted Actions compute. Only a concrete unresolved executable question justifies a bounded self-hosted workflow on `[self-hosted, openpressbrake]`; source/documentation study should continue otherwise.

Session end/elapsed to be recorded in `LESSON_LOG.md` immediately before finishing via safe full-file append or immutable request. No authoritative new lab runtime was observed.

## Same-session hydraulic branch addendum — 2026-10-23

Further exact archived Git blob SHA releases:
- `research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` — `773800d6fe8eacb481eb0939aa9ee3245ebda2ed`.
- `safety-course/4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md` — `f9e09db05560cbfe47603de4182cc61f1a47d86e`.

Official HYDAC part 2120394 catalog verified (DOC-CONFIRMED) the normally-open WSM06020Y solenoid bleed option, optional gauge, and the 2SV5/WSM replacement coil incompatibility. The selected-block worksheet now requires exact pressure-zone/tap mapping, separate physical load-holding witness and replacement `CHG` review. None of these catalog observations establishes installed hydraulic response or a maintenance-safe state. Source: https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2120394 .

**Revised next priority:** publish the remaining **66** source-checked archived candidates in coherent groups; highest value includes GuardLink diagnostic event-versus-current-state and independent physical final-element witness, then safe maintenance isolation and reaccumulation. Preserve external evaluator separation, avoid redundant eight-field SO witness template, and do not use hosted runners. No selected-machine tests or authoritative new compute runtime.

## Same-session ENETR diagnostic branch addendum — 2026-10-23

One additional exact archived Git blob release: `safety-course/4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md` — `2de5ab3a3591551cfe01a5261729e61b81658e4a`. One newly authored, separate manufacturer-source review: `research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md`. The official Rockwell `440R-UM009E-EN-P` February 2026 PDF was inspected directly: Table 5 sets all other GuardLink tags to zero when `Active=0`, defines `DeviceTrip` bitmap examples and prints `DeviceFault=6` for nodes 1 and 4 despite apparently different bit mapping. The discrepancy is **UNKNOWN**, not silently repaired; the HMI must qualify source/mode/freshness and remain outside safety authority. The cumulative Safety Design Package `VAL` section and learner navigation now include this gate.

**Revised pending backlog: 72/85** original archived candidates, plus any separately authored documents not in the archive. Next useful work: source-review the pending 432ES/440R diagnostic semantic-contract research, exact selected reset/fault recovery and independent final-element physical witness; do not duplicate the published new ENETR Table 5 audit. Preserve current external evaluator gates and all machine-level UNKNOWNs. No hosted/self-hosted simulation, physical machine test or new authoritative laboratory runtime.

## Same-session human-factors branch addendum — 2026-10-23

One further exact archived Git blob release: `safety-course/4400_GUARD_DEFEAT_INCENTIVE_DESIGN_REVIEW_2026-10-22.md` — `6f5f3f144c8eb263181a1a9db41c556d12d593b6`. Official IFA/DGUV MaSeM and bypass-incentive research were inspected. The cumulative `HF` section now requires observed work/task friction and human feedback, not fabricated time savings; usability changes must retain independent physical safety-function proof and create `CHG`/STALE dependencies. The lesson is learner-facing and NOT RUN; no on-site assessment occurred.

**Revised pending backlog: 71/85** original archived candidates. Continue exact source-checked publication and targeted 4400 safety architecture work; avoid duplicate CTP I1/L1 material. Keep 2520–25F0 external/fresh gates open, no invented machine limits, no hosted compute, and no personnel-exposed machine testing.

## Same-session manual hydraulic isolation addendum — 2026-10-23

One further exact archived Git blob release: `research/4400_ROSS_HLOX_MANUAL_ISOLATION_VS_RAM_PROOF_SOURCE_NOTE_2026-10-22.md` — `7a5556fa6a1b302ca004ce52958a0a6532a3eb1e`. Manufacturer ROSS H L-O-X product-family landing/series pages were inspected. DOC-CONFIRMED: padlockable manual OFF, optional pressure indicator, separate T1/T2 paths; manufacturer distinguishes maintenance isolation from automatic E-stop. INFERENCE: one port gauge or OFF signal cannot prove every trapped volume, ram restraint or absence of gravity hazards. UNKNOWN: exact selected hydraulic schematic, installation, physical witness, original PDF content not fully parsed. The cumulative package §11A and learner index now link this boundary.

**Revised pending backlog: 70/85** original archived candidates. Highest-value next research: 432ES/440R exact diagnostic semantic-contract comparison; hydraulic energy-reaccumulation and selected final-element witness; guard series fault masking. Keep external/fresh gates OPEN, no invented physical safety facts, and no hosted Actions compute.

## Same-session ISO 14119 series-fault branch addendum — 2026-10-23

Two exact archived Git blob releases:
- `research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md` — `453fd9a01d1d15fda6fb451cc4e7293cb3082327`.
- `safety-course/4400_GUARD_SERIES_ORDERED_FAULT_MASKING_FIELD_EXERCISE_2026-10-23.md` — `cbbcf5da08e2c2904fa2c301108c21e08606699f`.

Official ISO 14119:2024 and ISO/TR 24119:2015 catalog pages and the Schmersal 2025 interpretation were inspected. Current-edition Annex J route recorded; no licensed standard clause text reproduced. Settled-state Boolean counterexample `R1=A1&B1, R2=A2&B2` demonstrates opening-order-dependent contact-fault masking without asserting a selected receiver's internal fault latch, pulse detection or DCavg/PL. Cumulative Safety Design Package §11C and course navigation updated. No simulation was needed.

**Revised pending backlog: 68/85** original archive candidates. Continue 4400 safety source publication and exact physical-witness/restart authority work; no personnel-exposed hazardous operation without independent machine proof.

## Same-session physical egress addendum — 2026-10-23

One exact archived Git blob release: `safety-course/4400_GUARD_EGRESS_DEPENDENCY_CHANGE_WORKSHEET_2026-10-22.md` — `d1c812b1303220d290cfdc84e2aa073c66998e5f`. Linked to already published EUCHNER `research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md`. Cumulative Safety Design Package and index now require distinct release command, physical door opening/escape, independent machine stopping/holding and maintenance isolation propositions. No physical escape/stop test was performed.

**Revised pending backlog: 67/85** original archive candidates. Maintain current safety-course priority and 2520–25F0 external gate separation. Next high-value source group: GuardLink reset/fault recovery and physical final-element witness, or hydraulic maintenance energy reaccumulation. No GitHub-hosted compute.

## Same-session SAF catalog variant addendum — 2026-10-23

One exact archived Git blob release: `research/4400_HYDAC_SAF_MANUAL_AUTO_BLEED_OPTIONAL_GAUGE_VARIANT_AUDIT_2026-10-22.md` — `e43ddbdd67d0189f2d2d3c325b18e2db3f3fc2bb`. HYDAC manufacturer catalog part 2076241 (`SAF20M16-N350C S60`, manual discharge) and part 2120394 (`SAF20E12Y1T330A`, solenoid/manual discharge) inspected directly. The manual model's generic `Valve Type: Solenoid` field is contradictory/ambiguous, not proof of an installed automatic bleed. Selected-block qualification and course navigation now require exact SKU/options, gauge/ports and independent physical witness before freeze. No installed-machine hydraulic truth table or pressure decay established.

**Revised pending backlog: 66/85** original archive candidates. Continue source-first safety course; prioritize physical final-element witness, maintenance reaccumulation, guard diagnostics and restart/occupancy. No GitHub-hosted compute.
