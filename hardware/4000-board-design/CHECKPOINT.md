# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD44 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD44_EXCEPTION_DEBT_WAIVER_BURNDOWN_AND_TEMPORARY_CONTROL_RETIREMENT.md`.

BD44 teaches:

`active exceptions -> risk/expiry queue -> dependency/population reach -> compensating controls -> permanent correction -> targeted regression -> exception closure -> temporary-control removal -> evidence preservation`

## BD44 hard student-material audit

Every repository file named to students as finished material by BD44 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD43_RELEASE_TRAIN_OBSERVABILITY_GATE_DASHBOARDS_AND_EXCEPTION_AUTHORITY.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

No moving OpenPressBrake block implementation is assigned as finished student material in BD44. Current OpenPressBrake main is actively changing Rev1 integration and low-voltage allocations, so the lesson deliberately uses inspected stable governance rather than freezing a moving implementation as authority.

The newly created BD44 lesson was re-opened from current main after commit and checked against the inspected sources.

## Rules frozen by BD44

- exception approved does not mean defect resolved;
- burn-down priority is driven by consequence, uncertainty, expiry urgency, dependency reach, population reach, and control fragility rather than FIFO age;
- expiry is a release/use gate, not a reminder;
- renewal is a new bounded authority decision, not silent extension of the old record;
- temporary controls remain configuration/evidence dependencies until explicitly retired;
- long use of a compensating control does not make it a permanent requirement;
- service-only authority cannot leak into new-build authority;
- repeated board deviations do not qualify a reusable block or adapter by repetition;
- a permanent correction requires semantic affected-consumer analysis;
- a local fix/pass does not make dependent evidence current;
- exception closure and temporary-control retirement are separate gates;
- removal of a temporary control requires its own dependency/impact check;
- corrected defects and closed exceptions retain negative evidence and historical authority records;
- required executable regression uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains BLOCKED/NOT_RUN rather than falling back to hosted compute;
- ordinary-controller exception closure cannot establish independent personnel-safety validation.

## Catalog stress-test result

BD44 exposes a release-management need above the reusable catalog: a machine-readable exception-debt/temporary-control lifecycle should join stable exception IDs to affected semantic claims, exact candidate/population scope, risk/uncertainty, expiry/revalidation triggers, compensating controls, authority, permanent-correction revisions, changed semantic facets, regression evidence, closure, temporary-control retirement, and retained historical/negative evidence.

This infrastructure is `ENGINEERING_REVIEW_NEEDED`. Board/fleet exceptions and compensating controls must not be pushed into generic reusable-block manifests merely because the release layer consumes block contracts.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD43. Curriculum main had concurrent safety/timing work but no post-BD43 board-design lesson. OpenPressBrake had advanced to active Rev1 low-voltage allocation/integration work.

BD44 was committed as `a5eeb79a6ec2fdcfe129ac5b0c3cb05e2d2345fd` and re-opened from current main. Immediately before this checkpoint write, curriculum main still had BD44 as the newest board-design lesson and OpenPressBrake main was `6aea3b411a6238ed98e410bea69627d23ef3b4a3` (`encoder: freeze Rev1 installed 3V3 allocation`). OpenPressBrake was therefore consumed read-only.

## Next exact work

Build BD45 on **exception recurrence, systemic defect detection, and catalog/process feedback**:

`closed/current exceptions -> recurrence clustering -> common semantic cause -> board-only pattern vs reusable defect vs process defect -> corrective action -> cross-population impact -> catalog/process update -> regression -> recurrence monitoring`

Stress repeated board-specific deviations that actually reveal a missing adapter, repeated status/checklist drift that reveals a process defect, superficially similar exceptions with different electrical causes, a recurring service-only substitution that should not silently become a new-build alternate, and an ordinary safety-monitor recurrence that must not be promoted into safety-function authority.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD44. No GitHub-hosted runner was used.

## Safety boundary

BD44 teaches exception-debt retirement for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Closing an exception on an ordinary safety-status monitor, watchdog, handshake, or output proves nothing about validation of the independent safety function.
