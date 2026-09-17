# Session Checkpoint — Personnel Retention / Restart Prevention

Start UTC: 2026-09-17T22:38:28Z
End UTC: 2026-09-17T22:47:10Z
Elapsed: 8.7 minutes
Overlap status: no conflicting same-file safety work observed during this session; PROGRESS.md was refetched immediately before update.

## Durable work

- Added `safety-course/PERSONNEL_RETENTION_RESTART_AUTHORITY_TRACE_2026-09-17.md`.
- Updated `PROGRESS.md` with the personnel-retention freeze and next evidence target.
- Authoritative manufacturer evidence: Pilz Key-in-pocket safe-list/personnel-retention architecture plus blind-spot check; SICK access + presence detection as a contrasting restart-prevention architecture.
- No simulation/build/test compute was justified or consumed. No GitHub-hosted runner was used.

## Frozen rule

`ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.`

LinuxCNC/HAL/ordinary FPGA may consume and display safety permissive/diagnostic state but are not the sole personnel-retention safety authority.

## Next work

Find a complete professional implementation exposing retained-person/presence logic through safety logic to physical final-element re-enable and separate ordinary START. If the public implementation stops before final elements, preserve that as UNKNOWN and rotate to another high-information safety branch rather than infer circuitry.

## LESSON_LOG safe-append payload

Append the following row using the repository's safe append mechanism; do not reconstruct/overwrite a truncated log:

`2026-09-17T22:38:28Z | 2026-09-17T22:47:10Z | 8.7 min | 4000 safety | personnel-retention/restart-authority professional trace; Pilz Key-in-pocket + SICK presence-detection comparison; no compute | overlap: none observed`

If a later session has a safe complete fetch/append primitive, append this payload once and mark it reconciled.