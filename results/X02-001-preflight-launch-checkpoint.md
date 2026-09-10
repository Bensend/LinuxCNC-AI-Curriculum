# X02-001 preflight launch checkpoint

## Lineage

- Frozen behavioral contract: `experiments/X02-001-multi-surface-generation-correlation-plan.md`
- Freeze commit: `903036d31e8c1e4d114cf43878c96a4e789744d7`
- Preflight implementation: `lab-jobs/053-x02-001-multi-surface-preflight.sh`
- Implementation commit: `6eb541572e33168dac3e4eb67df3b01a62c02e85`
- Workflow: `34454522362`
- Job: `102797694203`

## Status at checkpoint

The run reached the `Run lab job and capture complete output` step and remained in progress at session close. No behavioral result has been inferred from workflow state.

The preflight implementation preserves the frozen X02-001 experiment intent and records:
- a deterministic realtime servo-cycle witness;
- realtime/HAL `motion.motion-type` through an X01-style bounded sampler stream;
- recorder overrun/depth/continuity evidence;
- Python observer monotonic time;
- Python Task `taskbeat`;
- Python motion `heartbeat`;
- Python `motion_type`, interpreter state, execution state, and commanded X;
- deliberately fast, normal, and slow observation phases.

Pinned `emcmodule.cc` confirms `stat.heartbeat` reads `status.motion.heartbeat` and `stat.taskbeat` reads `status.task.taskbeat`; the two members are documented in-source as servo-cycle and Task-cycle heartbeats respectively.

## Evidence discipline

- Workflow success is not sufficient for a pass.
- The retained run directory/artifact must be inspected independently.
- Exact correlation is forbidden if the realtime recorder reports producer overruns or deterministic payload discontinuity.
- Python monotonic timestamps are observer timestamps only.
- Nearest-time matching is not a same-generation oracle.
- Gates C and E may legitimately be INCONCLUSIVE under the frozen contract.
- Any execution failure before valid P0-P4 evidence is to be classified as a harness/provenance failure and may receive only a harness-only correction under the three-attempt rule.

## Exact next action

Inspect workflow `34454522362`, job `102797694203`, and its retained artifact/run directory. Record exact job runtime. Verify pinned provenance, P0-P4 completion, 20,000 realtime rows, zero producer overruns, deterministic payload continuity, stream continuity, Python trace completeness, ordered `motion_type` relationships, equal-state/new-generation evidence, and slow-observer generation skipping. Only then classify the preflight. If valid, launch a separate unchanged authoritative X02-001 run; if invalid before behavior, diagnose and correct only the harness.
