# Safety Lane B — periodic-test failure escalation / trend review — 2026-09-17

- Status: CHECKPOINTED — independent safety Lane B remains active.
- Parallel-work check: primary lane newest durable work was `SAFETY_REPLACEMENT_PART_EQUIVALENCE_VALIDATION_WORKSHEET.md` / checkpoint `6aeb5f3`; Lane B selected a different module and file package.
- Main re-read immediately before durable write: no competing work on the periodic-test trend artifact.
- Main re-read after artifact commit `94bf141`: no intervening overlapping commit appeared.
- Compute: NONE. This was architecture/documentation work; executable verification was not justified. No GitHub-hosted runner was used.

## Durable work completed

Added `safety-course/SAFETY_PERIODIC_TEST_FAILURE_ESCALATION_AND_TREND_REVIEW.md`.

Frozen rules:

1. A failed safety challenge that later passes after reset/power-cycle remains evidence; the later PASS does not erase the failure.
2. Intermittent discrepancies, nuisance trips, worsening physical evidence, and repeated bypass pressure are engineering-review triggers.
3. Escalation is qualitative and evidence-based; do not invent universal event-count, time, cycle, or nuisance-trip thresholds.
4. `FAIL — OUT OF SERVICE` and safety-critical `UNKNOWN — NOT CLEARED` preserve the affected operating restriction until evidence closes the claim.
5. Trend records must preserve demand/input, safety logic/output, final-element/EDM, physical energy response, reset/rearm/start, configuration identity, and evidence provenance as separate layers.
6. LinuxCNC/HAL/FPGA logs can aid diagnosis but do not become independent personnel-safety proof.
7. Repeated pressure to defeat an inconvenient safeguard is treated as a design/maintenance signal; improve the safe path rather than normalizing the bypass.
8. Suspected shared wiring, power, configuration, network, environment, plumbing, or witness dependencies widen the review to common-cause scope.

## Evidence status

This pass synthesized already-established curriculum evidence and engineering rules. It did not create new machine-specific physical facts. All OpenPressBrake stopping values, hydraulic truth tables, pressure/force limits, PL/SIL/DC, EDM timing, accumulator thresholds, safe-drive values, and universal failure-count thresholds remain `UNKNOWN` unless separately established.

## Precise next independent work

Create `safety-course/SAFETY_NUISANCE_TRIP_BYPASS_PRESSURE_ROOT_CAUSE_WORKSHEET.md` **only if the primary lane has not entered nuisance-trip/human-factors maintenance work**. It should trace `symptom -> evidence layer -> temporary recovery action -> recurrence context -> likely failure families -> independent physical witness -> controlled corrective action`, explicitly distinguish a production nuisance from a valid protective demand, and prevent diagnostic suppression or widened settings from becoming the default fix.

If primary work overlaps that topic before the next Lane-B run, switch instead to an independent safety-documentation audit: trace every safety-relevant drawing/configuration identifier to the installed field device/final element and mark mismatches `UNKNOWN — NOT CLEARED` rather than editing primary-lane files.