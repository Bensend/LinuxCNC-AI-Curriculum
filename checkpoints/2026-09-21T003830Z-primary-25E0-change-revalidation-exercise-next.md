# 4000 safety checkpoint — 25E0 physical-change revalidation exercise

UTC checkpoint: 2026-09-21T00:38:30Z

## Durable advance

The source-limited all-in-one OEM acceptance-matrix search was rotated into reusable curriculum work.

Added `safety-course/PHYSICAL_CHANGE_TO_RETURN_TO_SERVICE_DECISION_PROCEDURE_2026-09-21.md`, which converts accumulated manufacturer evidence into an AI-readable decision chain:

`changed physical item -> affected safety functions -> invalidated evidence classes -> required witness level -> functional/physical/quantitative revalidation -> safeguard requalification -> personnel clear -> reset/rearm -> production release -> fresh ordinary START`.

Added `safety-course/exercises/25E0_PHYSICAL_CHANGE_REVALIDATION_ADVERSARIAL_EXERCISE_2026-09-21.md`. The primary scenario changes light-curtain mounting/alignment without a software change; the adversarial variant leaves the safeguard untouched but replaces a hydraulic servo/proportional valve. The exercise tests whether a learner can scope retained versus invalidated A/B/C/D evidence without either trusting configuration identity or demanding every test mechanically.

## Important curriculum result

The exercise makes a useful teaching distinction explicit:

- Class A is invalidated when the physical protective-demand path changes.
- Class B is dependency-scoped; a bracket change does not automatically invalidate every fault-injection result, but installation-dependent diagnostics cannot be assumed preserved.
- Class C is invalidated when the changed item can affect the physical performance/geometry on which the safety function depends.
- Class D is obligation-scoped; maintenance does not automatically mean every periodic proof test is due, but OEM/architecture-specific post-maintenance requirements must be checked.

This is the intended middle path between unsafe under-testing and ritual all-tests-after-every-change over-testing.

## Exact next primary work

Perform an adversarial review of the new decision procedure/exercise against the existing 25E0 validation syllabus and 25C0 human-factors objectives. Look specifically for loopholes that could let a learner treat `diagnostic healthy`, `configuration restored`, `one favorable physical response`, or `repair complete` as production authority. Strengthen the curriculum only where the review finds a real gap.

Then rotate to another open safety module if no material gap remains. Do not resume generic press-brake OEM matrix searching unless a genuinely new source appears.

## Parallel lane

Lane B reset-station/blind-area work remains separate. No Lane-B artifact was modified.

## Compute

No executable compute was justified. No GitHub-hosted runner was used.
