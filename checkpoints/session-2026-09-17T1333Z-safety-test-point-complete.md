# Safety curriculum checkpoint — test-point/witness maintainability

- UTC start: 2026-09-17T13:33:14Z
- UTC end: 2026-09-17T13:35:31Z
- Actual elapsed: 2 minutes 17 seconds
- Overlap: none observed; current main was checked after primary write and the new work remained at HEAD.
- Compute: NONE. No GitHub-hosted Actions minutes used and no executable question justified self-hosted `[self-hosted, openpressbrake]` compute.

## Governance/current state

Read `START_HERE.md` first, then current level/work-selection/curriculum/progress evidence and newest checkpoint. Current repository state keeps 1000/2000/3000 closed and 4000 safety/professional-machine implementation active. Newest checkpoint `18db4201` selected test-point/witness maintainability and warned against duplicating the already-existing broad isolation witness work.

## Durable work

- `92584c17` — `safety-course/SAFETY_TEST_POINT_AND_WITNESS_MAINTAINABILITY_AUDIT.md`
- `6a4b7a17` — `safety-course/SAFETY_VERIFICATION_POINT_DESIGN_REVIEW_CARD.md`

Frozen rule:

> A safety verification witness is not durable merely because it once worked. Its complete physical observation path must remain accessible, identifiable, capable, protected from silent isolation, and restorable over machine life.

The audit covers inaccessible points that drive HMI-only shortcuts, closed/blocked gauge paths, open sensing fuses/references, stale labels, temporary test hardware, unknown witness capability/status, reaccumulation blind spots, replacement sensors/aux contacts, and restoration after testing. It explicitly preserves LinuxCNC/HAL/FPGA indications as diagnostic evidence rather than automatic proof of physical isolation.

## Source gain

`SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147 and its energy-control guidance require verification of effective isolation/deenergization and continued verification where hazardous stored energy can reaccumulate; verification can require combined methods and monitoring instruments.

`SOURCE-CONFIRMED` — OSHA's 2012 LED interpretation rejects relying solely on a safe-looking LED as affirmative isolation verification.

`SOURCE-CONFIRMED` — OSHA interpretation guidance recognizes physical/visual witnesses such as installed safety blocks and sight glasses and appropriate test instruments for different energy types.

`DOC-CONFIRMED` — SICK's published functional-safety validation/inspection service material treats physical testing, fault simulation, safety-feature functionality, dangerous-motion stopping and correct safety-device installation/function as validation evidence; calibrated/certified measurement equipment is specifically identified for stop-time measurement. This supports lifecycle attention to witness capability without inventing a universal calibration interval.

## Short-session continuation check

A second coherent task existed, so the compact design-review card was added rather than stopping after the audit. Further work in this same narrow test-point branch would now risk low-value repetition without installed-machine evidence.

## Precise next work

Rotate to a higher-information safety branch: build a **professional-machine safety maintenance evidence trace** using one complete OEM/manufacturer implementation that exposes periodic inspection/test expectations together with final elements and physical hazard controls. Explicitly trace what is challenged periodically, what physical result is observed, what latent failure the test can reveal, what remains energized, and what change/repair forces scoped revalidation. Prefer a press brake or other hydraulic/gravity machine if a sufficiently complete authoritative source exists; otherwise use a servo/robot machine with complete safety-maintenance evidence. Do not invent test intervals or acceptance thresholds.

## LESSON_LOG safe append payload

Because `LESSON_LOG.md` is a large shared append-only file and was not fetched completely, do not overwrite it through the contents API. Safe append row to apply with the repository append mechanism when available:

`2026-09-17T13:33:14Z | 2026-09-17T13:35:31Z | 2m17s | 4000 safety | test-point/witness maintainability audit + design-review card | compute NONE | overlap NONE | commits 92584c17,6a4b7a17 | next professional-machine safety maintenance evidence trace`
