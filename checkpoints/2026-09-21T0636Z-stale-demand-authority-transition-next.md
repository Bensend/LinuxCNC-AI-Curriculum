# Checkpoint — stale demand across authority transitions

## Completed this session
- PlantPAx runtime bypass aggregation / production-gate boundary traced.
- PlantPAx Maintenance ownership persistence across powerup and PROG-to-RUN traced.
- 25C0 reboot/handoff adversarial exercise added.
- Rockwell/Pilz exception-cleanup vs safety-reset vs fresh-start separation traced.
- `PROGRESS.md` advanced.

## Durable freezes
- POWER CYCLE != MAINTENANCE STATE SANITIZED.
- BYPASS CLEARED != MAINTENANCE OWNERSHIP RELEASED.
- MAINTENANCE RELEASE != START COMMAND.
- SAFETY RESET != START COMMAND.
- AUTHORITY RESTORED != OLD MOTION DEMAND FRESH.
- ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE.

## Exact next work
Seek authoritative implementation evidence for stale/queued production demand across command-authority transitions: Maintenance -> Program/Operator, Hand -> automatic, Override -> normal, or Service/Setup -> Production. Determine whether old demand is cancelled, retained, tracked for bumpless transfer, or can resume automatically. Preserve platform/object specificity.

If authoritative public material does not expose those semantics, record a source-limit promptly and rotate to another open 25C0/25E0 safety branch. Do not infer a universal behavior.

## Compute
No executable question justified a lab. No GitHub-hosted compute used.
