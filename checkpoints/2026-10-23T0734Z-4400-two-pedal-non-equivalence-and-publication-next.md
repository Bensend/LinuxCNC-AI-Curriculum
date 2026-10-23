# 4400 safety checkpoint — dual foot-pedal AND vs two-hand safeguarding

Session start: 2026-10-23T07:34:43Z UTC. Status: source/documentation work; no physical machine operation, simulation or laboratory compute.

## Durable main publications

- `research/4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md` — Fiessler FMSC-FP AND/OR is not proof of a two-hand protective device; explicit ISO 13851:2019 and OSHA press-brake scope; source/evidence classifications and adversarial cases.
- `safety-course/4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md` — technician exercise with input/authority/final-element/physical-witness chain, mode change and held-command adversarial cases.
- `PROGRESS.md` — refreshed current priority and publication state.
- `.github/workflows/append-lesson-log.yml` — immutable `timing-queue/*.row` processing added while preserving the occupied older `TIMING_APPEND_REQUEST.txt`; job still targets `[self-hosted, openpressbrake]` only.

## Provenance

DOC-CONFIRMED: Fiessler product selection has foot-switch 1, foot-switch 2, OR and AND modes: https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php

DOC-CONFIRMED: ISO 13851:2019 applies to two-*hand* devices, is not the rule for enabling/hold-to-run devices and does not decide suitability/distance for a specific machine: https://www.iso.org/standard/70295.html

DOC-CONFIRMED: OSHA press-brake eTool identifies pedal accidental cycling and workpiece motion; 1910.217(a)(5) expressly excludes press brakes: https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes and https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217

INFERENCE: steady-state dual-foot AND does not establish hand location, two-hand simultaneity/reinitiation, other exposed persons' protection, actual stop/hold, or restart freshness.

UNKNOWN: installed FMSC-FP variant/manual, selected wiring, safety-controller image/configuration, exact foot switch models, operator geometry, guard arrangement, machine-level stopping/holding, hydraulic circuit, reset behavior, PL/SIL, timing/distance/pressure acceptance.

## Next exact work

1. Verify the new lesson-log queue workflow's **actual** self-hosted job/run outcome. Never infer a successful append from workflow YAML or from a queued event. Retain the old October 12 timing request; do not overwrite it. If the runner is offline or workflow permission is blocked, leave immutable request files and record the blocker.
2. Reconcile the existing staged publication set (latest `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip`, 85 candidate files, no duplicate destinations in its own manifest). Inspect main destinations and sources; publish coherent reviewed groups through normal authorized writes, not a blind bulk overwrite. Do not re-publish the already-corrected 2500 index or duplicate eight-field SO witness.
3. Integrate the foot-AND versus two-hand distinction into the cumulative `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` as a *scope* example only if this improves an existing section without duplicating it. Preserve `BND/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/UNK/CHG` linkage and the 2520–25F0 external evaluation boundary.
4. For a future selected machine, require exact wiring/manual/safety-program identity and independent physical proof before making any stop, hold, guard-coverage or integrity claim. No personnel-exposed hazardous operation on documentary evidence alone.
5. Rotate to another open 4400 safety branch if this source question is exhausted. Prefer source-confirmed final-element/guard topology change proof or maintenance test/re-isolation continuity over redundant simulations.
6. Do not use GitHub-hosted runners. If a *concrete executable* uncertainty eventually justifies a lab, use only `[self-hosted, openpressbrake]`, and update `LAB_COMPUTE_LOG.md` only from authoritative job timestamps.

## State and overlap

Latest previous known session ended 2026-10-23T06:55:21Z; this session began 2026-10-23T07:34:43Z, 39m22s later. No overlap with that known session; external concurrency not independently verified. End time/elapsed belong in immutable timing request written immediately before session end.

## Session continuation addendum — 2026-10-23 07:47 UTC

Authorized GitHub writes now work. Six archived candidate files were published with exact original Git blob SHA verification; **79/85 staged candidates remain pending**. See `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md` for exact names and hashes. The new FP-vs-two-hand study now also contains direct Fiessler FMSC-FP vs FMSC-THC manufacturer brochure evidence (2025-10-15, printed pp. 3–5 and 8); note the brochure's conflicting `foot pedal 3` bullet. This is DOC-CONFIRMED family documentation, not selected-machine wiring/PL/stop proof.

The immutable timing-queue workflow update is committed and run `39919548510`, job `120301190483`, was observed **queued on self-hosted labels**; no job completion or canonical append is yet verified. If still queued, do not replace legacy `TIMING_APPEND_REQUEST.txt`. Preserve this session's exact end timestamp in its own immutable queue file, and verify the eventual self-hosted append.

**Highest-value next action:** reconcile and publish another coherent subset of the remaining 79 archived files using exact SHA and link checks, especially the GuardLink topology-change physical-proof pair, without treating a source-based proof plan as an executed physical validation. The 2520–25F0 external/fresh gates remain open. No GitHub-hosted compute.
