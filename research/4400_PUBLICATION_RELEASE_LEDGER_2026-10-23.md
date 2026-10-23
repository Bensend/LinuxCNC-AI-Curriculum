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

**79 of the 85 archived candidates remain pending**, assuming no unrelated concurrent publication. This is an archive-relative count, not a claim that every pending item has been checked against all of main. Preserve the ZIP and its manifest; review each candidate's links, provenance, current product edition, and existing main destination before publication. Do not overwrite existing files blindly.

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
