# Safety curriculum Lane-B checkpoint — selective protective-field stop

Date: 2026-09-17

## Parallel-work check

Newest pre-run durable main checkpoint was `acffd779`, diagnostic annunciation / SAFE-overclaim boundary. Lane B selected a different artifact and evidence package: SICK Sim-4-Safety selective protective-field shutdown behavior. Immediately before writing, main still ended at `acffd779`; after the artifact write, `e385f141` was directly above it, with no intervening overlapping commit.

## Durable work

Commit `e385f141` adds `safety-course/PROTECTIVE_FIELD_SELECTIVE_STOP_EVIDENCE_TRACE_SICK_SIM4_2026-09-17.md`.

Evidence gain:
- SOURCE-CONFIRMED SICK application: far protective fields stop tire-press loading-arm movement while nearer fields stop press movement; neighboring presses can remain independently productive.
- SOURCE-CONFIRMED S3000 + Flexi Soft architecture performs simultaneous protective-field monitoring and configurable shutdown paths.
- DOC-CONFIRMED SICK restart-interlock boundary: reset restores monitoring/release state and must not itself cause motion; separate start follows.
- DOC-CONFIRMED SICK guidance treats field selection as safety-relevant when selection determines the active protective function.
- Frozen rule: `PROTECTIVE-FIELD SPAN != E-STOP SPAN` until machine-specific evidence proves they coincide.
- Selective stopping is valid only when the hazard boundary and safety-related sensing/selection/logic/final elements/validation support the exact span.

## Deliberate evidence boundary

The public Sim-4 material does not expose exact tire-press contactors, drive safe-motion inputs, hydraulic valves, blocking/dump elements, EDM, stop distances/times or complete-system PL/SIL. Those remain UNKNOWN rather than inferred.

## Compute

None. Documentation/source work resolved the question. No GitHub-hosted runner or self-hosted runner compute was needed.

## Precise next independent work

Find a complete OEM/manufacturer machine or cell implementation that exposes both protective-device demand and E-stop demand through safety logic to physical final elements. Build a side-by-side demand-to-final-element matrix including what remains energized, feedback/EDM, reset and separate restart. Prefer a full manual/drawing package over another application summary. If public evidence again stops at safety-controller outputs, rotate to another open safety branch rather than invent the physical layer.
