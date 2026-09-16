# Safety Curriculum Lane B checkpoint — spare parts / obsolescence — 2026-09-16

## Parallel-lane check

Lane B read the required curriculum entry/order/policy/progress files, the current primary safety checkpoint, recent commits, and the preceding Lane-B checkpoint before selecting work.

Primary safety work most recently completed the Piranha complete-machine electrical/hydraulic energy-boundary trace and reusable complete-machine trace worksheet. Its next work remains modern CNC press-brake OEM safety/hydraulic mapping plus servo-machine and automated-cell complete traces. Lane B did not modify those files or duplicate those evidence packages.

Current primary checkpoint: `checkpoints/session-2026-09-16-safety-wiring.md`.

## Durable work completed

Created:

- `safety-course/SAFETY_SPARE_PARTS_OBSOLESCENCE_LIFECYCLE_WORKSHEET.md`

Commit: `8d2b6edbb69be98e05e25638809f0dd66af183b3`

## Frozen rule

`part sitting on shelf` does not equal `validated safety spare`, even when the label matches.

Safety-spare readiness follows identity/provenance, manufacturer lifecycle classification, storage/environment and product-specific aging evidence, firmware/configuration/device identity, physical condition, substitution/change-impact review, and bounded physical revalidation after installation.

No generic shelf-life, useful-life, proof-test interval, pressure, stopping distance, hydraulic truth table, PL/SIL/category or machine-specific performance value was invented.

## New architecture / human-factors controls

The worksheet establishes explicit inventory states:

1. `UNREVIEWED`;
2. `QUARANTINE`;
3. `APPROVED-SPARE`;
4. `INSTALLED-PENDING-VALIDATION`;
5. `IN-SERVICE-VALIDATED`;
6. `REMOVED / FAILED / INVESTIGATION`.

It separates exact/direct/functional/migration replacement language rather than flattening every manufacturer successor into "compatible." It also treats repaired, refurbished, cannibalized, long-stored and unknown-source parts as distinct provenance cases.

## Evidence provenance

- `SOURCE-CONFIRMED`: OSHA LOTO interpretive guidance identifies replacement of machine/process components such as valves, gauges, linkages and support structure as maintenance requiring hazardous-energy isolation rather than routine production-mode work.
- `SOURCE-CONFIRMED`: Rockwell current lifecycle pages expose explicit lifecycle and replacement categories; current examples include GuardLogix items listed with direct replacements and a discontinued GuardShield Safe4 item listed with a functional replacement.
- `SOURCE-CONFIRMED`: Rockwell publishes a 20-year useful life for a specific GuardLogix 5580 Logix SIS context under stated assumptions. This was used only to prove that useful-life evidence is product/context specific, not as a generic interval.
- `SOURCE-CONFIRMED`: OSHA robot-system guidance calls for documented maintenance/inspection including manufacturer recommendations and associated system equipment because wear, breakage, component malfunction and documented/undocumented changes can create hazards.
- `INFERENCE`: a safety-spare program therefore needs provenance/lifecycle/storage/configuration/change-impact evidence and post-installation physical validation; possession of inventory is insufficient.
- `UNKNOWN`: OpenPressBrake-specific approved safety spares, component shelf lives, hydraulic replacement equivalence and physical safety performance remain unasserted pending actual machine/component evidence.

## Compute

None. Documentation/source/architecture work only. No GitHub-hosted runner and no hosted Actions minutes were used.

## Re-read-main conflict check

Immediately after the worksheet commit, current `main` was re-read through the recent-commit list. HEAD was `8d2b6ed...`; the newest primary checkpoint remained `66ddd1b...`. No primary-lane file changed during this Lane-B write, and the new worksheet is independent of the primary OEM complete-machine trace artifacts.

## Precise next independent work

Build `safety-course/SAFETY_SPARE_READINESS_EVIDENCE_CARD.md`: a compact one-spare/one-safety-function card suitable for attaching to a physical spare bin or CMMS record. It should reference, not duplicate, the lifecycle worksheet and must capture exact identity/revision, source/provenance, approved substitution basis, lifecycle status, storage/aging limitations from manufacturer evidence, required firmware/configuration, affected safety functions, installation checks, mandatory revalidation challenges, unresolved `UNKNOWN`s, and state (`UNREVIEWED` through `IN-SERVICE-VALIDATED`).

Then evaluate whether a separate **repair-return / refurbished safety-component acceptance** failure-path worksheet adds genuine information beyond the lifecycle and replacement-equivalence artifacts. If it would duplicate them, rotate to another independent safety branch rather than manufacturing paperwork.
