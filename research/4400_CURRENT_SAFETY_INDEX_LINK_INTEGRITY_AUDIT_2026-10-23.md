# 4400 — Current safety-course navigation integrity versus historical archive route audit

**2026-10-23 UTC | Original repository-state evidence, not a machine safety validation or a historical ZIP release.**

## Question and method

The staged archive includes a `4400_SAFETY_COURSE_ROUTE_REGRESSION_AND_RELEASE_AUDIT_2026-10-22.md` whose previous checkpoint identifies a **stale main SHA and outdated publication blocker**. Publishing it unchanged as the current state would be misleading. Can the **actual present** learner index be verified without fabricating that archived document or invoking GitHub Actions?

**SOURCE-CONFIRMED repository state:** queried GitHub's read-only recursive Git tree endpoint for `main` after the 2026-10-23T17:37Z safety-source commits. Response was **not truncated**, included **4,080 tree entries**, and reported `sha=656a1d2f2f2c5e09c2df955cc525d0da335296b8`. Independently fetched `safety-course/SAFETY_COURSE_INDEX.md` at blob `38f3c8d9e20c677dde4d7ce1d3442ce881b71ffd`. Parsed all Markdown inline links of the form `[label](relative/path[#anchor])`; normalized `.`/`..` against the `safety-course/` directory, deduplicated resolved paths and checked membership in the tree.

**Result: 77 distinct relative links; 77 present, 0 missing.** This is a repository-path integrity check, **not** a proof of anchor correctness, substantive lesson accuracy, live external URLs, learner comprehension or physical machine validation. External URL reachability and implicit bare references were not checked. It is not a claim that every archived document has been published.

## Six archived paths still absent from main

1. `research/4400_AKAS5M_MUTING_SLOW_SPEED_SAFETY_AUTHORITY_2026-10-23.md`
2. `research/4400_CROSS_DOMAIN_SAFETY_PROPOSITION_CONTRADICTION_AUDIT_2026-10-22.md`
3. `research/4400_GUARD_LOCKING_POWER_LOSS_ESCAPE_RELEASE_AUTHORITY_2026-10-22.md`
4. `research/4400_PILZ_GUARD_MOUNTING_ESCAPE_MECHANICS_2026-10-22.md`
5. `research/4400_SAFETY_COURSE_ROUTE_REGRESSION_AND_RELEASE_AUDIT_2026-10-22.md`
6. `research/4400_SERIES_GUARD_INTERLOCK_FAULT_MASKING_AND_SELF_MONITORING_2026-10-22.md`

All six are **SOURCE-CONFIRMED absent** from this full `main` tree. The current learner index does **not** contain relative links to any of these absent paths, so it is not currently broken by their absence. Original consolidated ZIP bytes were not available through the connected file surfaces in this invocation. Do not recreate/paraphrase a file and label it an exact archived release; wait for original bytes and original manifest validation, then review editions/links/claims before publication.

## Existing current routes that cover adjacent questions

- Guard power-loss/escape: `research/4400_GUARD_POWER_LOSS_ESCAPE_AND_REARM_VARIANT_SOURCE_MATRIX_2026-10-23.md` and its technician field card.
- AKAS muting replacement protection: `safety-course/4400_AKAS_MUTING_LOSS_OF_COVERAGE_MINIMUM_FUNCTION_CONTRACT_2026-10-23.md`.
- Series guard masking: `research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md` and its ordered fault-masking field exercise.
- Personnel-key versus maintenance lockout: `research/4400_PERSONNEL_KEY_WHOLE_BODY_ACCESS_VS_LOTO_SOURCE_AUDIT_2026-10-23.md` and the two-worker exercise.

These are **separately authored** artifacts, not substitutes for byte-identical historical archive candidates. Reconcile the old route audit only as **historical/superseded** with this live tree result. A later index edit, rename or release must repeat the path check; the result is revision-scoped.

## Safety and evaluation boundary

All selected-machine `IN-01..10` and independent `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` evidence remain UNKNOWN; physical `VAL/PT` NOT RUN, `G0/G1 HOLD`, `G2 NOT RUN`, `G3/G4 NOT AUTHORIZED`, `G5 HOLD`. 2520–25F0 external information-separated evaluations remain OPEN. No runner, simulation, physical test or GitHub-hosted compute was used for this read-only tree audit.

## Reproduction

Read `main` recursive Git tree through the GitHub API and the exact current `safety-course/SAFETY_COURSE_INDEX.md` blob. Parse Markdown inline relative links, resolve them against the index directory and compare normalized paths against tree entries. Record the commit/tree response SHA, index blob SHA, link count, absent paths and any truncated-tree condition. This method intentionally excludes external URLs, fragment IDs and implicit references; a broader navigation audit would need to extend the parser and independently verify those categories.


## Follow-up route verification after the CKS source link (same session)

After adding the exact EUCHNER CKS evaluator-mode link to the learner index, repeated the **same** read-only full-tree comparison. The new `main` tree response reported `sha=29fc02af9b99e62eacf1dca373570971da38e4ce`, **4,082 entries**, `truncated=false`; index blob `020321f7080b7c3c29039491373e89ea0e4d0ceb`. **78 distinct relative links; 78 present; zero missing.** The original 77/77 result remains a correct prior snapshot, not the latest result. All six archive candidates remain absent and unlinked.


## Final in-session route check after 440T ETU/SMU source addition

Read-only full-tree response at `main`: `sha=9ea83611d05aae9346ef9d6ee65a4a58b5bf846a`, **4,084 entries**, `truncated=false`. Learner index blob `daade860ab8fddfb79cc1d4eb3229b4f4a0dfab8`. **80 distinct relative links, 80 present, 0 missing.** The earlier 77/77 and 78/78 are revision-scoped snapshots; none is a claim about external links, anchors, or unpublished ZIP candidates.


## 2026-10-23T18:35Z — new stopped-motion source and field-card routes

After publishing two new original stopped-motion learner routes and the original Pilz auto-reenable source route, repeated the complete **read-only** GitHub main-tree/index comparison. Tree response `sha=6977b311a06aa4d3922b15639cccf6270df80121`, `truncated=false`, **4,088 entries**; index blob `4b6fad00aaf11d0659f4836d2a14de6d4abfd0a6`. **83 distinct relative Markdown links / 83 present / zero missing**. This supersedes the previous 80/80 snapshot for current navigation. Still excludes anchors, external URLs, implicit references, source correctness and physical validation. The six original historical archive candidates remain separately pending; new original research does not count as exact archived publication.


## 2026-10-24T01:49Z — current safety index and hydraulic source publication integrity

Performed **read-only** GitHub Git-tree/index comparison at main commit `68f73440ccbf507abe5c84313671fe48d6bc4f83`, tree `3824ec9b786214dd01a0b23de66976182c459d70`, `truncated=false`. Index blob `ae0904a1127788331434f4aa216beee8a586b34a`: **112 total relative Markdown link occurrences, 110 distinct target paths, 112 existing targets, zero missing**. All **seven** new 2026-10-24 Bosch/HAWE research/technician/module artifacts exist in the same tree. Checked internal relative links in the new research/cards/module/checkpoint separately: **no missing paths**. These are **repository navigation and publication-presence checks**, not validation of external manufacturer URL availability, normative content, safety correctness, fresh evaluator results or physical machine behavior. Exact historical archive remains **6/85 missing**; new originals do not fill that backlog. No GitHub Actions compute used.
