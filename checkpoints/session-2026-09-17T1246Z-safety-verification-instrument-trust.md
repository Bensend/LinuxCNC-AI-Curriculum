# Safety curriculum Lane-B checkpoint — verification instrument trust chain

- Date: 2026-09-17
- Lane: independent safety Lane B
- Overlap check: current `main` was re-read immediately before durable work. Newest primary durable package was energized-test/positioning boundary plus physical-restraint/blocking verification (`71443589`, `52cde29b`, checkpoint `6ddda620`). Lane B did not modify those files.
- Compute: NONE. No executable question justified self-hosted `[self-hosted, openpressbrake]` compute; no GitHub-hosted Actions minutes used.

## Governance/current-state read

Read `START_HERE.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, current safety-course directory/artifacts, latest checkpoint, recent commits and the primary lane's newest durable work before selection. Active level remains 4000 safety/professional-machine implementation.

## Selection decision

The previous checkpoint proposed a broad isolation-verification instrument/observation matrix. Existing `safety-course/ENERGY_ISOLATION_VERIFICATION_WITNESS_DESIGN.md` already covers much of that ground, so repeating it would violate the information-gain/parallel-work rules.

Selected instead: a narrower independent evidence gap — whether the *verification witness itself* is capable of supporting the claimed physical state.

## Durable work

Added `safety-course/SAFETY_VERIFICATION_INSTRUMENT_TRUST_CHAIN_WORKSHEET.md` in commit `c86ffa48`.

Frozen rule:

> A reading is not stronger than its complete trust chain: correct hazard -> correct test point -> suitable instrument/witness -> proven usable measurement path -> fresh observation -> interpretation bounded to what that observation can actually prove.

The worksheet challenges dark voltage indicators, zero readings at the wrong test point, pressure gauges isolated from trapped volumes, sensor-power/common-reference false-safe failures, auxiliary-contact overclaim, failed try-start ambiguity, stale HMI values, mechanical-block overclaim, reaccumulation/backfeed and silent witness failure.

It preserves the separation between LinuxCNC/HAL ordinary control, FPGA watchdog containment, independent safety authority, final elements, feedback, independent physical witness, restraint and task-level exposure decision.

## Source gain

`SOURCE-CONFIRMED` from OSHA 29 CFR 1910.147: control-circuit devices are not energy-isolating devices; stored/residual energy must be rendered safe; reaccumulation may require continued verification; isolation/deenergization must be verified before covered servicing.

`SOURCE-CONFIRMED` from OSHA's lockout guidance: verification can require a combination of methods and monitoring instruments can contribute to verification.

`SOURCE-CONFIRMED` from OSHA's 2012 LED interpretation: a safe-looking LED indication alone does not satisfy the affirmative isolation-verification requirement.

`SOURCE-CONFIRMED` from 29 CFR 1910.333(b)(2)(iv): electrical deenergization verification requires testing exposed circuit elements and checking for induced/backfeed voltage; for >600-V nominal circuits the rule explicitly requires checking test-equipment operation immediately before and after the test.

The artifact deliberately does **not** generalize that >600-V instrument rule into a universal procedure for hydraulic/mechanical verification. Cross-domain trust-chain use is labeled `INFERENCE` and machine-specific instruments/thresholds remain `UNKNOWN`.

## Post-write overlap check

After commit `c86ffa48`, current `main` showed that commit directly on top of `6ddda620`; no intervening primary-lane or overlapping-file commit appeared.

## Precise next independent work

Build `safety-course/SAFETY_TEST_POINT_AND_WITNESS_MAINTAINABILITY_AUDIT.md` unless a newer primary checkpoint enters the same topic first.

Focus on whether physical test points, gauge/test ports, electrical verification points, bleed points, restraint inspection points and witness diagnostics remain accessible, labeled, protected and maintainable over machine life. Include capped/blocked test ports, isolation valves left closed, replaced sensors with changed failure behavior, inaccessible meter points that drive HMI-only shortcuts, damaged labels, temporary hoses/adapters, calibration/status uncertainty, and post-maintenance restoration. Keep exact test-point locations, ratings, instrument categories, pressure/voltage thresholds and service intervals `UNKNOWN` until installed evidence exists.

If primary work enters test-point/witness maintainability before the next Lane-B run, switch to another independent open safety evidence package rather than duplicate it.