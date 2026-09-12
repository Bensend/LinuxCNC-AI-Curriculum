# Press-brake operator program state contract

Date: 2026-09-12
Status: 3600 preparation / architecture contract
Evidence dependency: `research/press-brake-bend-program-execution-recovery-2026-09-12.md`

## Purpose

Define the smallest operator-visible state model that preserves the LinuxCNC distinction between pause/resume and abort/reconciliation while keeping bend-program identity separate from runtime authority.

## States

### READY
An accepted ProgramRevision, selected BendStepId and accepted TargetSetGeneration exist. Required reference/reconciliation predicates are current. No ExecutionEpisode is active.

Allowed: start selected step -> RUNNING with a fresh episode.

### RUNNING
A fresh ExecutionEpisode binds the accepted program revision, bend step and target generation. Commands may be active. The UI may display the semantic bend row, but row selection is not completion evidence.

Allowed transitions:
- supported hold/pause -> PAUSED;
- positive completion witnesses -> READY for next step, or COMPLETE after final step;
- abort-class event -> ABORTED_NEEDS_RECONCILIATION.

### PAUSED
LinuxCNC pause semantics remain active and the current episode has not been invalidated by a separate abort-class condition.

Allowed:
- Resume -> RUNNING only if the same episode remains valid;
- any abort-class event -> ABORTED_NEEDS_RECONCILIATION.

A PAUSED indication must never mask a simultaneously detected reference/drive/feedback/authorization fault.

### ABORTED_NEEDS_RECONCILIATION
The prior ExecutionEpisode is permanently invalid. LinuxCNC Task abort may have cleared pending/interpreter state and closed/reset the task plan. ProgramRevision/BendStepId may remain as historical/domain context, but they carry no motion authority.

Required reconciliation records at minimum:
- accepted/current ProgramRevision;
- semantic BendStepId that was active;
- accepted/current TargetSetGeneration;
- current reference/homing validity;
- current drive/feedback/controller validity;
- current mechanism positions/state witnesses;
- whether material/tool state permits retry, skip, scrap, manual recovery, or requires human engineering/operator judgment.

No automatic transition to RUNNING is permitted.

### REARM_READY
Reconciliation is complete and the domain/operator policy has explicitly selected the next semantic action. No old episode is revived.

Allowed:
- explicit rearm/start -> fresh ExecutionEpisode -> RUNNING;
- revision/target/reference validity change -> READY or ABORTED_NEEDS_RECONCILIATION as appropriate.

### COMPLETE
All required bend steps have completed under their own valid episodes and positive completion witnesses. Program completion is a domain result, not merely LinuxCNC interpreter IDLE.

## Persistence

Persist semantic/history data across application restart only where provenance is strong: ProgramRevision, last active BendStepId, TargetSetGeneration, last episode ID, last terminal state, and reason/timestamp for abort/completion.

Never persist `RUNNING`, `PAUSED`, or `REARM_READY` as automatically authoritative across process/machine restart. On restart, any nonterminal prior episode is treated as `ABORTED_NEEDS_RECONCILIATION` until current machine state is re-established.

## Priority rules

Abort-class invalidation dominates pause. Revision/generation invalidation dominates numeric equality. Current physical/reference/feedback validity dominates stored UI state. A fresh episode is mandatory after abort/reconciliation.

## Adversarial checks

- Application crashes while PAUSED: restart enters reconciliation, not PAUSED.
- Power cycles while row 3 is highlighted: highlight may be restored as context, but no episode authority is restored.
- Operator regenerates identical targets: generation changes; stale rearm is rejected.
- Abort then LinuxCNC reports IDLE: IDLE is not COMPLETE.
- Completed backgauge positioning but ram bend interrupted: bend step is not COMPLETE because all required mechanism witnesses did not complete.

## Next evidence target

Compare this contract against an inspectable public press-brake Run UI/state implementation. If no implementation exposes recoverable source, preserve SOURCE UNAVAILABLE and use this contract as the design basis for the later 3600 implementation lesson rather than adding synthetic simulations.
