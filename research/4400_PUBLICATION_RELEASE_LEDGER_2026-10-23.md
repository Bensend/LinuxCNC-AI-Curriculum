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

**61 of the 85 archived candidates remain pending**, assuming no unrelated concurrent publication. This is an archive-relative count, not a claim that every pending item has been checked against all of main. Preserve the ZIP and its manifest; review each candidate's links, provenance, current product edition, and existing main destination before publication. Do not overwrite existing files blindly.

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

### 2026-10-23T09:32Z source-checked GuardLink reset/replacement release

Three additional exact original archive Git blobs were committed and independently fetched/verified on main:

| Candidate | Verified blob SHA | Status |
|---|---|---|
| `safety-course/4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD_2026-10-23.md` | `428387a52841c1da9f387d297b799fb6990eabde` | Published exact |
| `safety-course/4400_GUARDLINK_FAULT_RECOVERY_CHANGE_CONTROL_WORKSHEET_2026-10-23.md` | `42d88d3f5dc5580b06ffe82e9798e92d431f6750` | Published exact |
| `safety-course/4400_GUARDLINK_RESET_AND_REPLACEMENT_TECHNICIAN_CARD_2026-10-23.md` | `3ad0a1f54035834d92a9d0396502a311131f9d11` | Published exact |

**Archive-relative pending: 61/85**, assuming no concurrent publication. New non-archive `research/4400_ENETR_RESET_UNITS_AND_DIAGNOSTIC_XOR_CONFLICT_2026-10-23.md` uses visually inspected manufacturer 2026 pp. 39 and 44 and keeps the units/XOR discrepancies UNKNOWN for actual selected firmware. No machine tests or hosted Actions compute.

### 2026-10-23T09:32Z hydraulic cross-branch publication

Exact archived `research/4400_HYDAC_DSV10_LOW_COST_SHUTOFF_DRAIN_SOURCE_SCOPE.md` Git blob **`c2b819fed1052a3c2276bda3741da16d036d3631`** published and verified against original archive. Original HYDAC `E 3.551.17/08.03` printed p. 10 documents negative P/S/T switching overlap and distinct DSV10 M/EY/EZ variants; current-machine applicability remains UNKNOWN. New non-archive technician worksheet: `safety-course/4400_DSV10_COMBINED_ISOLATION_NEGATIVE_OVERLAP_FIELD_EXERCISE_2026-10-23.md`. **62/85 archive candidates remain pending**, assuming no concurrent changes; no physical validation or hosted compute.

### Further physical-witness release, same session

Exact archive blob `d18eca1d41eab822efbe8a9f042e3f6bfb5de638`: `safety-course/4400_PRESSURE_ZONE_PHYSICAL_WITNESS_TRACEABILITY_WORKSHEET.md`, fetched and verified on main. This supplement maps accumulator/port/gauge/pressure-zone and independent physical witness to existing eight-field SO contract without duplicating the contract. **61/85** original archive candidates pending; all selected-machine validation NOT RUN.


### 2026-10-23T10:39Z safety-source release

Four additional archived learner-visible candidates were published to main and individually fetched for **exact original Git blob** comparison:

| Path | Verified blob |
|---|---|
| `safety-course/4400_EUCHNER_LOCK_SUBSTITUTION_ADVERSARIAL_2026-10-22.md` | `7f2ba171b2251918264e7a4a33b4aa0dcf36dbc3` |
| `safety-course/4400_LOCKABLE_ISOLATOR_TAGOUT_RETROFIT_TECHNICIAN_CARD_2026-10-22.md` | `9cb0588f8f73a8ce74b27a515d570e3f7763ee16` |
| `safety-course/4400_OVERTRAVEL_SOURCE_CONFLICT_AND_WORKPIECE_SWEEP_CASE_2026-10-23.md` | `9d926e12330af482a52cc75aca2f172ae19639ec` |
| `research/4400_EUCHNER_PROCESS_LOCK_VS_SAFETY_LOCK_MONITORING_2026-10-22.md` | `35dc23d3eea0518cdeccc66920a986cf94979e4c` |

**57/85 original archive candidates remain unpublished**, assuming no concurrent release; this count supersedes the older 61/85 headings above. The EUCHNER product-specific claims were cross-checked against current official order-136595 and order-123375 product records (I1 process-locking only, L1 safe lock-monitoring characteristic, different M12/M23 connectors). The OSHA 1910.147 regulatory text was rechecked for isolation, stored energy, test/positioning, group worker protection and restoration. A separate new non-archive source trace was committed: `research/4400_OSHA_LOTO_TEST_POSITION_REISOLATION_STATE_MACHINE_2026-10-23.md`. No physical tests, simulations, or hosted compute; 2520–25F0 external gates remain OPEN.

**New non-archive research after the 57/85 release:** `research/4400_432ES_FIRST_TRIP_UNCERTAIN_HISTORICAL_FAULT_TAG_SCOPE_2026-10-23.md` (manufacturer-indexed 432ES-UM001E Table 6 and DEVICE-RM500G Chapter 19). This does **not** change the 57/85 original-archive pending count. Self-hosted-only log workflow run `39919548510` was still QUEUED on recheck, not authoritative runtime. No hosted runner or laboratory test dispatched.

**Additional non-archive learner exercise:** `safety-course/4400_432ES_FIRST_EVENT_STALE_DIAGNOSTICS_TECHNICIAN_EXERCISE_2026-10-23.md`; not one of the original 85 archive candidates and therefore no change to the **57/85** remaining count.

### 2026-10-23T10:45Z cross-machine proof and LinuxCNC software-latch release

Two more original archive candidates published with exact post-write Git blob verification:

| Path | Verified original Git blob |
|---|---|
| `safety-course/4400_STALE_PROOF_CROSS_MACHINE_TRANSFER_2026-10-23.md` | `a2c255f3f3934d19e56a47b28da652add7f8f28c` |
| `safety-course/4400_ESTOP_SOFTWARE_STATE_VS_PHYSICAL_PROPOSITION_WORKSHEET_2026-10-22.md` | `a6d7858f4fb0edc3f742ee2916bbf6660cb4cb5e` |

**55/85 original archive candidates now pending**, assuming no concurrent changes; previous 57/85 count above is superseded. LinuxCNC 2.9 manual confirms ordinary `estop_latch` reset-edge behavior, but pinned first-scan initialization and actual physical behavior are distinct. No simulation, physical tests or hosted compute.

**Non-archive pinned source audit:** `research/4400_LINUXCNC_2_9_10_ESTOP_LATCH_FIRST_SCAN_SOURCE_AUDIT_2026-10-23.md` ties the newly published software-latch worksheet to exact upstream v2.9.10 `estop_latch.comp` and `halcompile.g` Git blobs. Archive pending remains **55/85**; source reasoning only, no lab.

### 2026-10-23T10:47Z guard escape and bracket change-control release

Two further exact original archive blobs verified after publication:

- `safety-course/4400_GUARD_LOCK_ESCAPE_RELEASE_TECHNICIAN_CARD_2026-10-22.md` — `45a1cbab87f12fc6c770721d930b14ab7ca1646d`.
- `safety-course/4400_GUARD_MOUNTING_ESCAPE_FIELD_QUALIFICATION_2026-10-22.md` — `dc3cf11617a9ee9314823e361fcf29d0b805a15b`.

Official Schmersal AZM300 operating instructions distinguish AZM300Z safety-output withdrawal on unlock from AZM300B on guard opening. Pilz manufacturer accessory information cautions that bending escape-release push/pull cables can impair function and service life; bracket geometry, physical egress and selected force data remain machine-specific. **53/85 original archive candidates pending** (supersedes prior 55/85), assuming no concurrent publication. No machine testing, PL/SIL claim or hosted compute.

**Non-archive source companion:** `research/4400_SCHMERSAL_AZM300Z_B_AND_PILZ_ESCAPE_CABLE_SOURCE_2026-10-23.md` adds direct official manufacturer output/cable evidence to the two published escape exercises. It does not alter **53/85** archive pending.

### 2026-10-23T10:48Z hydraulic-zone transfer release

Two further original archive candidates published and exact Git blobs verified:

- `safety-course/4400_ACCUMULATOR_FAMILY_PRESSURE_ZONE_TECHNICIAN_EXERCISE_2026-10-22.md` — `d666565ff0324cab9820b146807adb0b5840affc`.
- `safety-course/4400_HYDRAULIC_COVERAGE_TECHNICIAN_CARD_2026-10-22.md` — `51c82b94dc84f859995cac656fbbf300ef6d9545`.

New non-archive official manufacturer source trace: `research/4400_HAWE_SAKB_FIVE_MONITORED_VALVES_VS_NSV_SOURCE_SCOPE_2026-10-23.md`, directly comparing D 6335 (2025) enumerated two proportional, two holding and one 4/2 monitored positions against the separate NSV family. Manufacturer D 7969/D 7571 and OSHA 1910.147 also rechecked for accumulator energy and isolation. **51/85 archive candidates pending**, assuming no concurrent changes; no hydraulic truth table or machine test inferred.

**Non-archive Pilz manufacturer source follow-up:** `research/4400_PILZ_PSENML_MOUNTING_FZH_ESCAPE_1004710_EN10_2026-10-23.md` pins official 1004710-EN-10 p.42, 79, 83–85 and prevents transfer of direct-mount force figures to a bracket/handle installation. **51/85** original archive candidates pending unchanged.

### 2026-10-23T10:50Z access-ordering and guard-chain proof release

Two further exact archive blobs published and verified:

- `safety-course/4400_ACCESS_RELEASE_ORDERING_PROOF_TECHNICIAN_WORKSHEET_2026-10-22.md` — `0dd07a94e9bb1914d2404ab9ad5350c4dd99c613`.
- `safety-course/4400_GUARD_CHAIN_QUALIFICATION_AND_CHANGE_CONTROL_WORKSHEET_2026-10-22.md` — `3796844472e74ff3f9f0196fdeffa875b829c54c`.

Both remain learner-visible NOT RUN and preserve external blind-evaluation separation. **49/85 original archive candidates pending**, assuming no concurrent changes. Stop-request versus completed stop, normal access versus inside escape, guard series fault masking and physical causal verification remain distinct propositions.

**Additional exact archived guard-series release:** `safety-course/4400_GUARD_SERIES_FAULT_MASKING_TECHNICIAN_FIELD_CARD_2026-10-22.md` Git blob `7c5b73bb2e94b4adfbe9b35bd63da56e62f32b92` fetched and matched. This card separates series-contact fault masking from ordinary LinuxCNC gate-specific diagnostics and a 432ES first-event address. **48/85** original archive candidates remain pending, assuming no concurrent change.

**Session-integrity cross-check:** all **13/13** archived candidates published in this session independently matched the consolidated archive's SHA-256 manifest locally, in addition to each post-write Git blob match on `main`. This is file-publication integrity evidence only, not a machine test, simulator result or external competency score.

### 2026-10-23T11:35Z guard-release / standstill / AKAS mode proof release

Three more **original consolidated archive candidates** were published to `main`. Each post-write Git blob was independently fetched and compared against the original ZIP member's Git blob; the archive's 96/96 declared SHA-256 manifest entries also verified locally before release.

| Exact archive candidate | Original and published Git blob | Status |
|---|---|---|
| `safety-course/4400_GUARD_RELEASE_TRACEABILITY_CHANGE_WORKSHEET_2026-10-22.md` | `10b4d9b0822f9d1c0ab782a9d294dcbc9c3c854c` | **PUBLISHED EXACT** |
| `safety-course/4400_STANDSTILL_GATE_ADVERSARIAL_QUALIFICATION_2026-10-22.md` | `5b2a0acee7de9e96a66294f46686b295047e9e54` | **PUBLISHED EXACT** |
| `safety-course/4400_AKAS_MUTING_MODE_CHANGE_TECHNICIAN_PROOF_CARD_2026-10-23.md` | `0b715b5a34a0f9454038138de3d8fddc86538b8e` | **PUBLISHED EXACT** |

**Original consolidated archive pending: 45/85**, down from the previous checkpoint's 48/85, subject to any concurrent publication outside this ledger. This count is **archive-relative**, not a full current Git-tree reconciliation. Existing published GuardLink cards were not duplicated. The still-unpublished higher-priority `research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md` and `research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md` remain publication priorities.

**New non-archive research/training:** `research/4400_OSHA_LED_INDICATION_VS_PHYSICAL_ISOLATION_AND_GUARDLINK_EVENT_2026-10-23.md` and `safety-course/4400_THREE_INDICATORS_ZERO_ISOLATION_PROOF_TECHNICIAN_EXERCISE_2026-10-23.md`. Source scope: official OSHA 1910.147 and 2012-12-12 LED interpretation, OSHA Appendix A and Rockwell 432ES-UM001E-EN-P p.64. These do **not** affect the 45/85 archive count. No hardware validation, simulator, hosted compute, external score or selected-machine safety acceptance.

### 2026-10-23T11:41Z current-edition HYDAC corroboration

One further original archive member published byte-exactly and fetched back with the original Git blob SHA:

| Candidate | Verified original/published Git blob | Status |
|---|---|---|
| `research/4400_HYDAC_HISTORICAL_LOCKABLE_SHUTOFF_POSITION_WITNESS_2026-10-22.md` | `def6af2adaac3fe613b90674633599b4929a814c` | **PUBLISHED EXACT** |

**Original consolidated archive pending: 44/85**, down from 45/85 above, subject to concurrent publication. New **non-archive** `research/4400_HYDAC_2024_SAF_LOCK_OPEN_CLOSED_OPTION_CURRENT_SCOPE_2026-10-23.md` checks manufacturer **EN 3551.25/05.24**, §4 pp.171–172, directly confirming that `L`/`LPI`/`LPM` lockable shut-off options may be locked OPEN or CLOSED and that `LS` refers to pressure-release locking. This narrows the historical-only uncertainty but does not validate a selected hydraulic system or change the archive count. New non-archive Pilz `research/4400_PILZ_PNOZS30_CONFIG_CRC_TRANSFER_VS_FUNCTION_TEST_2026-10-23.md` independently confirms CRC identity is not functional commissioning. No laboratory compute, hosted runner, physical test, external blind score or machine release.

### 2026-10-23T11:44Z additional cross-machine transfer release

`safety-course/4400_GUARD_LOCK_STANDSTILL_CROSS_MACHINE_TRANSFER_2026-10-22.md` published byte-exactly from the original archive; independently fetched Git blob **`774cfb232c78065d9c6a279ae1f06729bcc3e930`** matches the archive member. **43/85 original archive candidates remain pending**, superseding 44/85 above (archive-relative; concurrent publication unverified). This learner-facing card transfers hazard-boundary reasoning across mill/VMC, lathe, press brake, plasma/laser, robot and feeder classes without transferring machine-specific safety thresholds. No physical test, new lab runtime or external score.

### 2026-10-23T11:45Z protective-cycle energy versus automatic bleed release

Original archive `research/4400_HYDAC_SAF_PROTECTIVE_STOP_VS_AUTO_BLEED_ADVERSARIAL_REVIEW.md` published to `main` and independently fetched: original/published Git blob **`09d16c92b5117226f55e474cc613a2c68ad0c401`**. **42/85 original archive candidates remain pending** (supersedes 43/85; archive-relative and concurrent changes unverified). Qualitative HYDAC/HAWE fault tree preserves that accumulator pressure may be both hazardous stored energy and intentionally required for a selected protective action. This is NOT a machine hydraulic truth table, stop/hold test, or physical validation. The cumulative Safety Design Package §11J and learner index now link this source.

### 2026-10-23T11:46Z EUCHNER cross-machine output-semantics release

`safety-course/4400_GUARD_LOCKING_CROSS_MACHINE_TRANSFER_AND_PROOF_PLAN_2026-10-22.md` published byte-exactly and independently fetched with original Git blob **`91b6642deb380c0ab04d7ee2bd060d5e9a9783a6`**. **41/85 original archive candidates remain pending**, superseding 42/85 (archive-relative; concurrent publication unverified). The card contrasts EUCHNER I1 versus L1 closed/unlocked FO semantics and separate physical safe-state evidence across machine classes; no selected machine validated.

### 2026-10-23T11:47Z physical egress field witness release

`safety-course/4400_GUARD_EGRESS_FIELD_WITNESS_AND_CHANGE_CONTROL_CARD_2026-10-22.md` published byte-exactly and independently fetched with original Git blob **`ebbc7482bac6da6ed5f477fa1ae9b29465cefad2`**. **40/85 original archive candidates remain pending**, superseding 41/85 (archive-relative; concurrent publication unverified). The worksheet separates normal production access, inside escape and maintenance isolation and keeps physical `VAL/PT` NOT RUN.

### 2026-10-23T11:48Z pressure-test-point anti-bypass human-factors release

`research/4400_SAF_TEST_POINT_HUMAN_FACTORS_DESIGN_REVIEW.md` published byte-exactly and independently fetched with original Git blob **`7fd40e6f736eec407640a8c268e91646c77c417c`**. **39/85 original archive candidates remain pending**, superseding 40/85 (archive-relative; concurrent publication unverified). The source-based design review prioritizes zone-labeled, externally observable pressure/holding evidence and easy guard restoration; redesign candidates are INFERENCE, no physical validation.


### 2026-10-23T12:39Z GuardLink source release — five exact archive members

Re-read `START_HERE.md`, current governance and the 11:42Z checkpoint before publication. Locally rechecked the consolidated ZIP: archive integrity passed, **96/96 SHA-256 entries matched**. Before creation, each destination was confirmed absent on `main`; after creation, each Git blob was fetched independently and matched its original archive member byte-exactly.

| Exact original candidate | Original and post-publication Git blob | Status |
|---|---|---|
| `safety-course/4400_MODE_DEPENDENT_ACCEPTANCE_TECHNICIAN_WORKSHEET_2026-10-23.md` | `bc768bccd8c9644778968439e2328c1a0421d30d` | PUBLISHED EXACT |
| `safety-course/4400_OVERRUN_FRESHNESS_SELECTED_SETTING_TECHNICIAN_CARD_2026-10-23.md` | `0044a358f58bf01c797fe4a1469592ce7c172ded` | PUBLISHED EXACT |
| `research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md` | `c53304c2b50d2f2a6be806f344d0d59ed43f72b8` | PUBLISHED EXACT |
| `research/4400_ENETR_DIAGNOSTIC_TAG_BITMASK_AND_DOCUMENT_CONFLICT_AUDIT_2026-10-23.md` | `59ad64b5eb1ee202cbbe88a7bf4676384315c9dc` | PUBLISHED EXACT |
| `research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md` | `1fbed3b653127a13010eca071f878ece38e61a7d` | PUBLISHED EXACT |

**Original consolidated archive pending: 34/85**, superseding the prior 39/85 count, assuming no unrelated concurrent publication. This is archive-relative, not an exhaustive live-tree count. New **non-archive** `research/4400_GUARDLINK_DIAGNOSTIC_EVENT_EPOCH_FRESHNESS_AND_RELEASE_GATE_2026-10-23.md` advances ordinary-HMI freshness/first-event state design without assigning it personnel-safety authority. Cumulative package §11K and learner index updated. All selected-machine `VAL/PT` remain **NOT RUN**, external 2520–25F0 evaluation gates OPEN. No physical tests or laboratory compute; no GitHub-hosted runner dispatched. Self-hosted lesson-log job 120301190483 of run 39919548510 remains QUEUED without authoritative runtime.


### 2026-10-23T12:46Z AKFR pressure/valve physical-witness release

Two more exact archive members published, original/post-write Git blob SHA independently matched:

| Candidate | Exact original and published blob | Status |
|---|---|---|
| `research/4400_AKFR_PRESSURE_AND_VALVE_WITNESS_SOURCE_AUDIT_2026-10-23.md` | `1d4fb76908766bcd56ba297d9a4a3881204bd29a` | PUBLISHED EXACT |
| `safety-course/4400_AKFR_SENSOR_TARGET_AND_PHYSICAL_WITNESS_TECHNICIAN_EXERCISE_2026-10-23.md` | `30ec8a5f67d9a4abfcdfbaf76b2cab6ac94a822c` | PUBLISHED EXACT |

**Original archive pending: 32/85**, superseding 34/85, subject to concurrent updates. Fiessler original German `doc1257` and English internal `doc1264` (hosted filename `doc1268`) were independently re-opened from the manufacturer site; both document valve-position **and** pressure-sensor inputs, but disagree on downstream "valve" versus "contactor" wording. The English diagram says "Valve release." Cumulative Safety Design Package §11L and index updated. All selected-machine `VAL/PT` NOT RUN; no machine hydraulic truth table, PL/SIL or maintenance-entry proof inferred. No compute dispatched.


### 2026-10-23T12:48Z Physical access, stop/hold and maintenance energy release

Five more original archive members were independently fetched after publication and matched exact original Git blobs:

| Candidate | Original/post-write Git blob | Status |
|---|---|---|
| `safety-course/4400_CROSS_BOUNDARY_CONTRADICTION_COMMISSIONING_CARD_2026-10-22.md` | `ff7192cd376801a9dfbad49ac368f19e5547d9be` | PUBLISHED EXACT |
| `safety-course/4400_GUARD_LOCK_SEMANTICS_VS_PHYSICAL_RELEASE_2026-10-22.md` | `f2a5e9bd7366a574d1d50abfb52fd09c00012a13` | PUBLISHED EXACT |
| `safety-course/4400_HYDRAULIC_PHYSICAL_WITNESS_WORKED_PACKAGE_2026-10-22.md` | `33fe8f8b7dcd9afd26a339d354ebce96aa939034` | PUBLISHED EXACT |
| `safety-course/4400_ACCUMULATOR_SAFE_CYCLE_TO_MAINTENANCE_TRANSITION_EXERCISE_2026-10-22.md` | `784dd5f032f27a698195c723dcb8ecddf997114c` | PUBLISHED EXACT |
| `safety-course/4400_ACCESS_RELEASE_ENERGY_WITNESS_COMPOSITION_WORKSHEET_2026-10-22.md` | `fe1bb8b7e70124e7928310bf40de67dc49edefe5` | PUBLISHED EXACT |

**Original archive pending: 27/85**, superseding 32/85. These learner-visible documents separate ordinary LinuxCNC E-stop, safety controller demand, valve/guard feedback, actual beam/pressure/escape/occupancy, protective-cycle accumulator energy, maintenance LOTO and fresh start. They are educational/INFERENCE or DOC-CONFIRMED examples, **not** selected-machine physical `VAL/PT` or external blind scores. No test/simulation/hosted compute.


### 2026-10-23T12:50Z mode selector and three-position pedal release

Two further original archive members independently fetched and Git-blob verified:

| Candidate | Original/post-write Git blob | Status |
|---|---|---|
| `safety-course/4400_MODE_SELECTOR_RESTART_AUTHORITY_CROSS_MACHINE_WORKSHEET_2026-10-23.md` | `bc3a7f69cb40ed6a09d5eb0e87d28bfba509437f` | PUBLISHED EXACT |
| `safety-course/4400_THREE_POSITION_PEDAL_RESTART_AND_OVERTRAVEL_TECHNICIAN_CARD_2026-10-23.md` | `a3a2521da16df18f80b4799d6a5ada079ccefaef` | PUBLISHED EXACT |

**Original archive pending: 25/85**, superseding 27/85. These learner-facing exercises distinguish OR versus AND operator authorization, pedal overtravel safety demand, independent physical stop/hold, reset, fresh start and maintenance isolation. Manufacturer document ambiguities remain labeled, and no selected-machine `VAL/PT` or external blind evaluation was performed. Session cumulative **14 original archive members** published exact, plus **one new source-grounded HMI epoch/freshness research note**. All physical machine evidence NOT RUN; zero GitHub-hosted compute.


### 2026-10-23T12:52Z safe mode selector versus enabling-device source release

Original archive `research/4400_SAFE_MODE_SELECTOR_VS_THREE_POSITION_ENABLING_DEVICE_SOURCE_TRACE_2026-10-23.md` published exact, post-write Git blob **`c34dbbbba6368997440d65a2fa2bd4b9fa2e5be2`** matched original. Pilz mode selector guidance and PITenable, Rockwell 440J and Fiessler FMSC-FP are compared without confusing ordinary mode selection, three-position enabling, E-stop, selected safe speed or physical stop. **Original archive pending: 24/85**, superseding 25/85. Session cumulative **15 exact original archive releases** and one new GuardLink/HMI source-grounded architecture note; no selected-machine physical `VAL/PT`, external score or compute.


### 2026-10-23T13:40Z non-archive safety engineering addition

Two **new original** files, not members of the 85-file staged archive, were published and independently fetched from `main`:
- `research/4400_OSHA_2003_2004_PRESS_BRAKE_LASER_GUARD_REVERSAL_AND_PHYSICAL_PROOF_2026-10-23.md` — current Git blob `5384904c79b8128afab004f733be0fa1d88c6d1c` after 1986/1997 source-scope addendum.
- `safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md` — Git blob `4910585ec8384533ec3334f13570cdf7c0ae23b4`.

**Original archive backlog remains 24/85**, not 22/85; no previously staged archive member was published this session. The new artifacts reconcile OSHA's 2003/2004 press-brake laser interpretation and supply a ten-artifact as-built physical-proof intake and release gate. All machine physical `VAL/PT` **NOT RUN**; no new blind score, local lab compute or hosted Actions compute.


**Same-session non-archive follow-on (13:46Z):** `safety-course/4400_TEMPORARY_REENERGIZATION_LOTO_TESTING_AND_FRESH_RESTART_2026-10-23.md` committed on `main` as new original technician material, source-grounded in OSHA 1910.147(f)(1)/(e)/(d)/(f)(3) and Appendix A; not an original archive member. Cumulative package §11N and learner index updated. **Original archive backlog unchanged: 24/85**; physical `VAL/PT` NOT RUN.


### 2026-10-23T13:49Z exact HAWE archive release

Original consolidated ZIP `research/4400_HAWE_B5488_GENERAL_MANUAL_SCOPE_AND_VERIFICATION_2026-10-22.md` published on `main`, independently fetched and **Git blob SHA `76f988b239248a959716b5cca9ee37b37dd1cf91` matched the original ZIP exactly**. Source: manufacturer HAWE B 5488 10-2024 rev 3.1, https://productfinder.hawe.com/downloads/B5488-en.pdf ; general instructions do not substitute for product-specific instructions or selected-machine `VAL/PT`. Archive manifest rechecked locally **96/96 SHA-256 PASS**. **Original archive pending now 23/85**, superseding the earlier 24/85 count. This is documentary/source release, not machine acceptance. Three separate new non-archive originals remain outside the archive count.


### 2026-10-23T13:51Z exact EUCHNER CTP manual-release archive release

Published original archived `research/4400_CTP_MANUAL_RELEASE_OBSERVABILITY_AND_ACCESS_AUTHORITY_2026-10-22.md` on `main`. Independently fetched Git blob **`cee68b88f26df00f30b41c3d360f5fc5cc72896c`** matched original ZIP exactly. EUCHNER CTP-L 2124217-08-06/21 manual-release FO/OL/OD and inside escape scope retained, CTP-I 2126290-08-07/24 process-protection distinction source-checked against official manufacturer product page. No selected-machine guard/physical test. **Original archive pending 22/85**, superseding 23/85; cumulative session two exact archived releases + three new non-archive originals.


### 2026-10-23T13:52Z exact Fiessler three-position pedal source release

Published original archived `research/4400_FIESSLER_THREE_POSITION_PEDAL_RELEASE_RESTART_SOURCE_AUDIT_2026-10-23.md` on `main`; independently fetched Git blob **`e5a2b9e5b2b51b1dbe06825e3482b8557690b054`** matched original ZIP exactly. Current Fiessler official FE-FS product page confirms overtravel stops motion and full release is required before restart, resolving the catalogue prose-vs-diagram conflict at documentary level only. FMSC-FP OR/AND and reset-request diagnostic remain selected-machine validation obligations. **Original archive pending now 21/85**, superseding 22/85. Session cumulative **three exact archived releases plus three new non-archive original safety documents**; no physical `VAL/PT`, external score or lab compute.


### 2026-10-23T13:53Z exact AKAS inspection versus machine acceptance archive release

Published original archived `research/4400_AKAS_DEVICE_INSPECTION_VS_MACHINE_SAFETY_ACCEPTANCE_2026-10-23.md` on `main`; independently fetched Git blob **`18e2955280b38a688b8f04c5a683b0d924e96d68`** matched original ZIP exactly. Fiessler AKAS-5M manufacturer document 1581 (2024-02-15) explicitly distinguishes device inspection from complete machine safety acceptance. Muting, box mode, actual speed, physical stopping/holding and reset remain selected-machine obligations. **Original archive pending now 20/85**, superseding 21/85. Session cumulative **four exact archived releases plus three new original safety artifacts**; no physical `VAL/PT`, external score or lab compute.


### 2026-10-23T13:54Z exact pressure-witness counterexample archive release

Published original archived `research/4400_PRESSURE_WITNESS_LOGICAL_COUNTEREXAMPLES_AND_CHANGE_IMPACT.md` on `main`; independently fetched Git blob **`06cd199700d353a9e9f55197873bcfab0e46f558`** matched original ZIP exactly. Distinguishes SAF S-side gauge, isolated P-side volume, accumulator gas precharge, gravity restraint and maintenance isolation; change impact on tap/valve/plumbing requires evidence invalidation. No hydraulic truth table or physical validation. **Original archive pending now 19/85**, superseding 20/85. Session cumulative **five exact archived releases plus three new original safety artifacts**, no physical `VAL/PT`, blind score or compute.


### 2026-10-23T14:37Z original non-archive diagnostic source continuation

Committed `research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md` and `safety-course/4400_SERIAL_DIAGNOSTIC_STALE_GREEN_CROSS_MACHINE_TECHNICIAN_CARD_2026-10-23.md` as **new original learner-visible work**, not as exact releases from the original 85-file archive. Fiessler AKAS-5M 2024 document 1581 pp. 3–5, 25–26 and 29–34 directly inspected; serial RS-232 status repetition is a diagnostic interface, not independent physical stopping/holding or maintenance isolation. Prior published backlog baseline **19/85 pending** is carried forward without a claimed decrement; re-evaluate main/manifest for concurrent releases. No hosted/local compute, physical test or external blind score. No exposed-person machine release.


### 2026-10-23T14:43Z exact original-archive AKAS source release

Published `research/4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md` on `main`; independently fetched Git blob **`ff7709e6792192780df099f88443a9bc4c1b45b9`** matches the original consolidated ZIP's exact Git blob. The 2024 Fiessler AKAS-5M manual pp. 5 and 14 shows differing 13/11 mm overrun text; DIP-selected values and measurement quantifier require source reconciliation, not parameter guessing. The document also separates laser-covered point-of-operation from sheet sweep, ejection, foot control and stored energy. OSHA eTool URL remains cited from the original archived source; a fresh OSHA fetch in this session was blocked (403), so no claim of fresh OSHA verification. **Original archive pending 18/85**, decrementing the prior durable 19/85 baseline by one exact previously absent file; other concurrent publications require future reconciliation. Cumulative Safety Design Package §11O added. No physical test or hosted/local laboratory compute.


### 2026-10-23T14:48Z exact selected-setting overrun/retest archive release

Published `research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md` on `main`, independently fetched and verified Git blob **`5e0b14b723308ed86ca2090834a248e4d3071d71`** equal to original ZIP. Fiessler AKAS-5M 2024 pp. 14, 25–26 establish selected DIP/table-dependent overrun monitoring and the documented power-restoration/30-hour retest arrangement, while pp. 5/14 still contain unresolved prose/quantifier/equality differences. No universal 11/13 mm acceptance criterion, no machine-specific numeric proof. **Original archive 17/85 pending**, superseding 18/85, absent unobserved concurrent release. No hosted/local lab compute or physical tests.


### 2026-10-23T14:49Z exact HAWE accumulator family source release

Published `research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md` to `main`; independently fetched exact original ZIP Git blob **`b690bcb1d0f11cf6aacae0fa5f23ed060e258e43`**. Manufacturer HAWE D 7969 (06-2022 rev 1.10 p.31) versus D 7571 (03-2024 rev 1.1 pp.11,18) directly rechecked in original PDFs: dedicated accumulator valve language differs by family; both still require fluid-side service pressure-release consideration. Product-family exception is not machine-level stop/hold, maintenance isolation or universal legal interpretation. Cumulative Safety Design Package §11P added. **Original archive 16/85 pending**, superseding 17/85, absent concurrent publication. No hosted/local lab compute, physical test or blind score.


### 2026-10-23T14:51Z exact EUCHNER temporal guard-release source release

Published `research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md` on `main`; initial transcription had a two-character formatting mismatch, corrected by a SHA-guarded update, then exact original Git blob **`95070fff954dca5add555bcbd93e8e35ab915edc`** verified. EUCHNER original manual 2124217-08-06/21 directly reviewed: CTP-L escape release physically unlocks and produces FO OFF stop demand, which is not evidence that stopping preceded opening. Normal access, inside escape and maintenance energy isolation require different physical propositions. Cumulative Safety Design Package §11Q added. **Original archive 15/85 pending**, superseding 16/85, absent concurrent release. No physical test or hosted/local lab compute.


### 2026-10-23T14:54Z exact qualitative hydraulic fault-tree archive release

Published `research/4400_HYDRAULIC_ENERGY_FAULT_TREE_QUALITATIVE_2026-10-22.md`; independently fetched Git blob **`5d1c6cb200af8cb1cbe6ee3864caec60b5c5c8de`** matched original ZIP. HAWE SAKB D 6335 (2025) and NSV D 6368 (2026) manufacturer PDFs directly rechecked for version/scope; the source's three top events and four CCF candidates remain qualitative `INFERENCE`, not selected-machine Boolean cut sets or PL/SIL. OSHA 1910.147 link retained from archived research; fresh OSHA access 403. Cumulative Safety Design Package §11R added. **Original archive 14/85 pending**, superseding 15/85. No hosted/local lab compute, physical test or blind score.


### 2026-10-23T14:57Z exact HAWE SAKB/NSV monitoring coverage source release

Published `research/4400_SAKB_MONITORING_COVERAGE_NSV_WITNESS_2026-10-22.md`; independently fetched exact original Git blob **`2864efe988192ed293bfe33d4e56229997f2d65b`**. HAWE D 6335 2025 p.9 five monitored S-version manifold valve positions and D 6368 2026 NSV seal/L-suffix and nominal pilot guidance directly checked in original manufacturer PDFs. Monitoring does not establish pressure zones, NSV state, physical ram restraint or maintenance isolation. Cumulative Safety Design Package §11S added. **Original archive 13/85 pending**, superseding 14/85, assuming no concurrent release. No hosted/local laboratory compute, physical test or blind score.


### 2026-10-23T14:59Z exact GuardLink/Pilz SDD diagnostic cascade archive release

Published `research/4400_VENDOR_DIAGNOSTIC_CASCADE_GUARDLINK_SDD_BOUNDARY_2026-10-22.md`; independently fetched exact original Git blob **`be62e46bfffa9401274f8f7fdb8c9714487b3c47`**. Rockwell GuardLink and Pilz SDD current official product pages rechecked; Pilz expressly marks its diagnostic reaction time not safety-related, and the 16-sensor configuration is product-specific. Safety outputs, ordinary network diagnostics and physical machine witnesses remain separate. Cumulative Safety Design Package §11T added. **Original archive 12/85 pending**, superseding 13/85, assuming no concurrent release. No physical test or hosted/local laboratory compute.
