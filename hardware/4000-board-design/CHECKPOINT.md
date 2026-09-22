# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD43 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD43_RELEASE_TRAIN_OBSERVABILITY_GATE_DASHBOARDS_AND_EXCEPTION_AUTHORITY.md`.

BD43 teaches:

`change waves -> gate graph -> machine-readable status -> evidence freshness -> blocked/waived/failed states -> exception authority -> expiry/revalidation -> promotion visibility -> audit reconstruction`

## BD43 hard student-material audit

Every repository file named to students as finished material by BD43 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected

No moving OpenPressBrake block implementation is assigned as finished student material in BD43. Current OpenPressBrake main is in active Rev1 whole-board work, so the lesson deliberately uses stable governance semantics instead of freezing a changing implementation as authority.

The newly created BD43 lesson was re-opened from current main after commit and checked against the inspected sources.

## Rules frozen by BD43

- dashboard green does not equal release authorized;
- a dashboard is a projection of authoritative records, not a second source of truth;
- last result PASS does not equal current gate PASS;
- evidence freshness is semantic, not merely time-based or filename-based;
- unknown freshness is not current;
- a gate graph must preserve prerequisites rather than flattening release state into a checklist;
- downstream success does not erase an upstream failure;
- waived does not equal passed;
- every exception requires exact scope, rationale, authority, applicability, expiry/revalidation trigger, and closure evidence;
- a board-specific exception does not qualify or mutate a reusable block unless generic engineering evidence justifies the block change;
- skipped executable verification is not passed verification;
- when executable verification is genuinely required, unavailable `[self-hosted, openpressbrake]` compute means BLOCKED/NOT_RUN rather than fallback to hosted compute;
- engineering state, candidate state, promotion state, and population applicability remain distinct;
- historical release decisions and negative evidence remain reconstructable after later fixes;
- ordinary controller release authority cannot validate an independent personnel-safety function.

## Catalog stress-test result

BD43 exposes a release-observability layer above the reusable catalog. A future machine-readable implementation should join stable semantic IDs, exact candidate lineage, dependency snapshots, gate prerequisites/results, evidence digests and freshness, exception authority/scope/expiry, promotion state, population applicability, and immutable historical audit snapshots.

This infrastructure is `ENGINEERING_REVIEW_NEEDED`. Board release waivers, fleet applicability, and dashboard state must not be pushed down into generic reusable-block manifests merely because the release view consumes block data.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD42. Curriculum main had concurrent safety/timing work but no post-BD42 board-design lesson. Immediately before the BD43 write, current OpenPressBrake main was `5e4f4d19164479d658a1eb876f2779e46e72b972` (`Start Rev1 whole-board footprint audit`), following active safety-interface and machine-power changes. OpenPressBrake was therefore consumed read-only.

BD43 was committed as `6a8a30a3076b069fb9ea3e49e33a803a09762032` and re-opened from current main before this checkpoint update.

## Next exact work

Build BD44 on **exception debt, waiver burn-down, and temporary-control retirement**:

`active exceptions -> risk/expiry queue -> dependency/population reach -> compensating controls -> permanent correction -> targeted regression -> exception closure -> temporary-control removal -> evidence preservation`

Stress an exception whose expiry is approaching, a compensating control that became permanent by neglect, a fix that closes the local defect but leaves dependent evidence stale, a service-only exception accidentally applied to new builds, and a safety-status-monitor exception that must not become personnel-safety acceptance.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD43. No GitHub-hosted runner was used.

## Safety boundary

BD43 teaches observability and exception control for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. A green release dashboard for ordinary monitors, handshakes, watchdogs, or control outputs proves nothing about validation of the independent safety function.
