# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD46 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD46_CORRECTIVE_ACTION_EFFECTIVENESS_LEADING_INDICATORS_AND_PREVENTION_EVIDENCE.md`.

BD46 teaches:

`systemic correction -> preventive/detective controls -> leading indicators -> exposure-normalized monitoring -> escape detection -> effectiveness review -> control tuning -> sustained closure or recurrence reopen`

## BD46 hard student-material audit

Every repository file named to students as finished material by BD46 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD45_EXCEPTION_RECURRENCE_SYSTEMIC_DEFECT_DETECTION_AND_CATALOG_PROCESS_FEEDBACK.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml` for the current lower-clamp/LT6015 architecture and explicit unresolved facts
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md` for current status, shared-resource cleanup, and open qualification gates
- OpenPressBrake `hardware/blocks/lvdt_input/integration/ANALOG_5V_CLAMP_RESOURCE_CONTRACT.md` specifically as a `DEPRECATED_OR_SUPERSEDED` historical example; it is not current design authority

The current `lvdt_input` remains `SIMULATION-READY`, not production-proven, schematic-ready, safety-rated, or REV 1 READY. The newly created BD46 lesson was re-opened from current main after commit and checked against these inspected sources.

## Rules frozen by BD46

- correction merged does not establish correction effectiveness;
- preventive and detective controls are distinct and must be described truthfully;
- a green validator is not evidence against a cause it does not inspect;
- effectiveness controls need targeted negative tests against the escaped semantic defect;
- leading indicators must be causally connected to the failure mechanism rather than merely easy to count;
- recurrence and escape monitoring should use meaningful exposure denominators;
- fewer reports do not establish a lower defect rate when exposure or detection effort changed;
- block correction does not automatically refresh dependent board evidence;
- escapes through an expected control reopen effectiveness review and may reopen recurrence/systemic closure;
- historical/superseded artifacts remain provenance evidence but must not be silently consumed by current board generation or resource budgeting;
- ordinary-controller corrective-action effectiveness does not establish independent personnel-safety validation;
- required executable effectiveness verification uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake `lvdt_input` provides a bounded real authority-transition example. The retained `ANALOG_5V_CLAMP` resource contract is explicitly `SUPERSEDED / DO NOT POPULATE / DO NOT BUDGET`. Current authority uses a lower-clamp-only LT6015 signal front end and consumes no positive shared clamp sink. The superseded record explicitly requires current board integration to omit the historical TLV431 branch, its approximately 0.309 mA `5V_ANALOG` bias load, and associated capacitance from current power/filter inventories. The current `lvdt_input` checklist separately records the shared-resource cleanup.

BD46 uses this to teach that source correction, dependency reconciliation, downstream resource-budget consumption, negative-control detection, and continued monitoring are separate pieces of effectiveness evidence. Retaining historical evidence is correct; resurrecting it as current authority is not.

## Catalog stress-test result

BD46 exposes a missing corrective-action-effectiveness layer above block qualification. It should join systemic cause IDs, correction revisions, changed semantic facets, preventive/detective controls, targeted negative-test evidence, leading indicators, exposure denominators, escape records, reverse dependencies, board/population reconciliation, monitoring windows, and closure authority.

The worked example also exposes a need for machine-readable authority state on retained artifacts/resources so search, board generation, resource budgeting, and automated composition can distinguish `CURRENT` from `SUPERSEDED/DEPRECATED` without deleting useful history.

This proposed infrastructure is `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD45. Curriculum main also contained concurrent safety/timing work. OpenPressBrake had advanced from the BD45 RS-485 state into active machine-power/LVDT reconciliation.

BD46 was committed as `659504dbcc4e1b5b7733dc99dec1907ba6132596` and re-opened from current main. Immediately before this checkpoint write, curriculum main still had BD46 as the newest board-design lesson; concurrent non-board-design curriculum work remained intact. OpenPressBrake current main was `692589530a44daad8379e2bbb78a912923f5f387` (`lvdt: retire obsolete shared upper-clamp resource`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD47 on **authority-state propagation, supersession-safe discovery, and configuration consumption**:

`current/superseded/deprecated artifacts -> machine-readable authority state -> search/discovery -> consumer eligibility -> stale-consumer detection -> board generation/resource budgeting -> audit -> safe historical retention`

Stress a search result that finds a technically detailed but superseded contract before current authority, a generated board that accidentally consumes a retired resource, an old release that legitimately retains historical authority while new builds must not, and a safety-related historical artifact whose discoverability must not imply present safety authority.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD46. No GitHub-hosted runner was used.

## Safety boundary

BD46 teaches corrective-action effectiveness for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Improving detection or prevention on an ordinary safety-status monitor, watchdog, handshake, STO request, or inhibit path proves only its ordinary-controller contract unless a separate safety-rated design and validation establishes more.
