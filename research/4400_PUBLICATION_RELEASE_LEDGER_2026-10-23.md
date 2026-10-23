# 4400 safety publication release ledger — 2026-10-23

Status: **partial authorized publication to main**, not a machine validation or course graduation. Source review bundle: `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip`, `review/PUBLICATION_MANIFEST.json`, 85 unique learner-visible candidate paths. The bundle was previously staged, not committed; the GitHub contents API is now accepting authorized writes.

## Exact archived candidate files now on main

| Candidate path | Git blob SHA verified against original ZIP | Status |
|---|---|---|
| `safety-course/4400_MODE_DEPENDENT_SAFEGUARD_VALIDATION_MATRIX_2026-10-23.md` | `30f785cfc5663ae563f8135cd3f4385602db3388` | Published, exact |
| `safety-course/4400_ESTOP_LATCH_FIRST_SCAN_ADVERSARIAL_CARD_2026-10-22.md` | `4a74d40a509f6a5bcd05b36fb0262e6a63c15ad0` | Published, exact |
| `safety-course/4400_AKAS_VARIANT_SUBSTITUTION_CHANGE_REVIEW_2026-10-23.md` | `71f16b376f05d4f76384f4017875351f3079aa21` | Published, exact |
| `research/4400_AKAS5M_VS_LC5M_VARIANT_TRANSFER_TRAP_2026-10-23.md` | `84018db7e175b683b46dba884fd7a4b7f878eae4` | Published, exact |
| `research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md` | `fba07cf9ff398a7425aafec60a3ad97b615586dc` | Published, exact |
| `safety-course/4400_GUARD_RELEASE_PROPOSITION_AND_MAINTENANCE_TECHNICIAN_EXERCISE_2026-10-22.md` | `0a28ff863dfb4d152fc79a9319b1903d042eb22a` | Published, exact |
| `research/4400_432ES_APPENDED_NODE_INACTIVE_SAFETY_FUNCTION_SOURCE_TRACE_2026-10-23.md` | `9af734c064cc11ed8fcdaee78c55392b582dcb23` | Published, exact; Rockwell 432ES-UM001E-EN-P pp. 49, 51, 58 |
| `safety-course/4400_GUARDLINK_NODE_CHANGE_PHYSICAL_PROOF_TECHNICIAN_CARD_2026-10-23.md` | `3bfb2f158843ddcade042ea703d97ca4df087ce2` | Published, exact; all physical validation NOT RUN |
| `research/4400_CTP_SAFE_RECEIVER_VS_SOLENOID_PULSE_INTERFACE_NOTE_2026-10-22.md` | `0b1b1e7e26160cb90c69515e1fc95f78df89356d` | Published, exact; original EUCHNER manuals rechecked |
| `safety-course/4400_CTP_STATE_TABLE_REPLACEMENT_ADVERSARIAL_CARD_2026-10-22.md` | `de7597dd01334fadf93d176402fdd9527095b8ba` | Published, exact; learner-visible non-blind card |
| `research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` | `773800d6fe8eacb481eb0939aa9ee3245ebda2ed` | Published, exact; current manufacturer catalog verified |
| `safety-course/4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md` | `f9e09db05560cbfe47603de4182cc61f1a47d86e` | Published, exact; learner-visible non-blind exercise |
| `safety-course/4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md` | `2de5ab3a3591551cfe01a5261729e61b81658e4a` | Published, exact; official 440R-UM009E Feb 2026 Table 5 verified |
| `safety-course/4400_GUARD_DEFEAT_INCENTIVE_DESIGN_REVIEW_2026-10-22.md` | `6f5f3f144c8eb263181a1a9db41c556d12d593b6` | Published, exact; IFA/DGUV MaSeM official sources checked |
| `research/4400_ROSS_HLOX_MANUAL_ISOLATION_VS_RAM_PROOF_SOURCE_NOTE_2026-10-22.md` | `7a5556fa6a1b302ca004ce52958a0a6532a3eb1e` | Published, exact; ROSS H L-O-X manufacturer product pages verified |
| `research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md` | `453fd9a01d1d15fda6fb451cc4e7293cb3082327` | Published, exact; ISO catalog and Schmersal 2025 guide checked |
| `safety-course/4400_GUARD_SERIES_ORDERED_FAULT_MASKING_FIELD_EXERCISE_2026-10-23.md` | `cbbcf5da08e2c2904fa2c301108c21e08606699f` | Published, exact; open-book Boolean counterexample |
| `safety-course/4400_GUARD_EGRESS_DEPENDENCY_CHANGE_WORKSHEET_2026-10-22.md` | `d1c812b1303220d290cfdc84e2aa073c66998e5f` | Published, exact; linked to already published manual-release source |
| `research/4400_HYDAC_SAF_MANUAL_AUTO_BLEED_OPTIONAL_GAUGE_VARIANT_AUDIT_2026-10-22.md` | `e43ddbdd67d0189f2d2d3c325b18e2db3f3fc2bb` | Published, exact; HYDAC 2076241/2120394 catalog contrast checked |

**66 of the 85 archived candidates remain pending**, assuming no unrelated concurrent publication. This is an archive-relative count, not a claim that every pending item has been checked against all of main. Preserve the ZIP and its manifest; review each candidate's links, provenance, current product edition, and existing main destination before publication. Do not overwrite existing files blindly.

## New material outside the archived 85

- `research/4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md` — Fiessler FMSC-FP versus ISO 13851:2019, refined with FE-FS2 two-pedal assembly versus multiple operator stations.
- `safety-course/4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md` — adversarial technician exercise, not a sealed evaluator answer.

## Current integration and compute state

- `safety-course/SAFETY_COURSE_INDEX.md` now links the new 4400 foot-pedal scope study; the prior 2500 course-numbering correction was already on main.
- `PROGRESS.md` and a precise 4400 checkpoint are updated. The eight-field SO witness contract already exists; do not duplicate it.
- `.github/workflows/append-lesson-log.yml` now reads immutable `timing-queue/*.row` files while preserving the old occupied request. The initial queue-triggered run `39919548510` was observed **QUEUED** on `[self-hosted, openpressbrake]` (job `120301190483`) at 2026-10-23T07:42–07:44Z, **not completed**. This is not evidence of an appended canonical row or compute runtime.
- No GitHub-hosted runner was dispatched. No simulation, build, bench test, physical machine test, or new authoritative laboratory runtime occurred.

## Safety and competency boundary

2520–25F0 external/fresh evaluation gates remain OPEN. Source/documentary claims are not selected-machine physical proof. Stopping/holding, guard-zone coverage, selected controller program, hydraulic truth table, response limits, integrity targets and residual-energy disposition remain UNKNOWN/NOT RUN. Do not operate hazardous machinery with people exposed absent the minimum proven protection.

## 2026-10-23 08:31 UTC continuation

Published the manufacturer-traced 432ES appended-node failure path and its causal physical-proof technician card with exact original Git blob SHA verification. Reviewed the official Rockwell 432ES-UM001E June 2025 manual and retained the distinction between online topology-change capability and mandatory safety-function revalidation. Integrated section 11C into the cumulative Safety Design Package and linked the pair from learner navigation. No machine test, lab simulation, or hosted Actions compute; self-hosted append job `39919548510` remained QUEUED at the time of this review. Archive-relative pending count is 77; external 2520–25F0 competency gates remain open. Do not treat this documentation as a validated installed guard.

### Further source-checked release — same session

Published exact SHA-matched CTP I1/L1 replacement and pulse-port scope artifacts; rechecked original EUCHNER 2126290-08-07/24 and 2124217-08-06/21 PDFs. Added a producer/receiver/pulse-direction qualification gate to `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` and linked both from learner navigation. **75/85** original archive candidates remain pending, assuming no unrelated concurrent publication. These are documentary training artifacts; no physical acceptance test or selected-device compatibility proof was performed.

### Hydraulic witness branch — same session

Published exact SHA-matched HYDAC SAF selected-catalog qualification note and zero-gauge adversarial technician exercise. Rechecked the manufacturer's part 2120394 catalog: model `SAF20E12Y1T330A`, normally-open WSM06020Y bleed variant, optional gauge and explicit incompatibility of legacy 2SV5 versus WSM coil kits. Added pressure-port/zone mapping and coil-replacement change-control cautions to the selected-block worksheet, and linked the lesson from safety navigation. No hydraulic circuit was energized or measured. **73/85** original archive candidates remain pending; all selected-machine physical safe-state propositions remain UNKNOWN/NOT RUN.

### GuardLink diagnostic-data validity — same session

Published one more exact SHA-matched learner worksheet on 440R-ENETR bitfield ambiguity (13th of 85 archived files now published). Independently added `research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md` using direct original Rockwell 440R-UM009E-EN-P February 2026 Table 5/6 inspection, not an archived candidate. Integrated a diagnostic-source freshness/event-versus-state gate into the cumulative Safety Design Package. **72/85** original candidates remain pending. No installed-machine or physical validation evidence.

### Human-factors branch — same session

Published exact SHA-matched IFA/DGUV MaSeM guard-defeat incentive field exercise. Official IFA sources were checked for task/mode/benefit assessment and the ergonomic/fault-remediation drivers of defeat. Added observed-workflow and safeguard-restoration requirements to the cumulative `HF` template and linked the worksheet from learner navigation. No site task times, user feedback or risk-reduction performance was fabricated. **71/85** original archived candidates remain pending; no physical machine tests or hosted compute.

### Manual hydraulic isolation branch — same session

Published exact SHA-matched ROSS H L-O-X maintenance-isolation source note; manufacturer landing/series pages verified, original downloadable PDF not independently parsed. Linked the narrow maintenance isolation versus dynamic stop and suspended-ram physical-witness distinction in the cumulative Safety Design Package and learner index. No selected circuit, hydraulic truth table, physical stopping/holding, or maintenance release verified. **70/85** original archived candidates remain pending.

### ISO 14119:2024 series fault-masking branch — same session

Published exact SHA-matched current-edition ISO 14119:2024 Annex J bridge and ordered-guard Boolean field exercise. Checked ISO 14119:2024 and ISO/TR 24119:2015 official catalogs plus Schmersal's 2025 manufacturer guide; do not infer licensed clause text or a numeric diagnostic coverage. Integrated the receiver-specific fault masking unknowns into cumulative section 11C and learner navigation. **68/85** original archive candidates remain pending; no test or safety calculation performed.

### Guard egress physical-witness branch — same session

Published exact SHA-matched mechanical escape/egress change worksheet, linked to already published `research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md`. The cumulative Safety Design Package and learner index now require distinct guard release, physical door opening/egress, independent stopping/holding and maintenance isolation propositions. No live trapped-person test or physical release was conducted. **67/85** original archived candidates remain pending.

### SAF option/substitution ambiguity — same session

Published exact SHA-matched HYDAC SAF `M` manual versus `E` solenoid/manual bleed variant audit. Direct catalog checks confirmed part 2076241's manual-discharge code alongside its misleading generic `Valve Type: Solenoid` field, contrasted with 2120394's solenoid/manual model. Selected-block worksheet and learner index now require exact option/port/witness evidence before schematic or personnel-exposed release. **66/85** original archived candidates remain pending.
