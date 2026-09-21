# 4000 Safety Checkpoint — Runtime Exceptional-State Observability

UTC checkpoint: 2026-09-21T05:50Z

## Durable result

Added `safety-course/ROCKWELL_RUNNING_APPLICATION_EXCEPTION_STATE_OBSERVABILITY_AND_AUDIT_BOUNDARY_2026-09-21.md` and `safety-course/25C0_RUNTIME_MANIFEST_VS_BASELINE_INTEGRITY_EXERCISE_2026-09-21.md`.

Rockwell authoritative documentation establishes two distinct runtime evidence mechanisms: `MODULE.ForceStatus` via GSV gives current I/O-force installed/enabled state, while Controller Audit Value/ChangesToDetect supplies change/baseline evidence for monitored events such as online edits and force operations. Safety object state is separately readable for diagnostics but remains a separate authority class.

Key correction: current exceptional-state absence is not production-baseline identity. An assembled edit may no longer appear as a pending edit while changed logic remains. Likewise, an audit-value change is evidence requiring disposition, not proof that an exception is currently active.

## Exact next work

1. Seek an authoritative real implementation combining multiple *live* exceptional-state classes in running logic and explicitly gating automatic production/return-to-service.
2. Prioritize machine-readable maintenance bypass/service/test state with explicit clearing semantics plus force/change state.
3. Preserve the split between live-state evidence, baseline/change evidence, physical inspection evidence, and independent safety readiness.
4. If public sources expose only individual mechanisms or engineering-UI summaries, mark the aggregate-runtime-gate search source-limited and rotate to another open 25C0/25E0 safety branch.
5. Do not infer that an engineering UI status has a running-program API without explicit documentation.

No executable compute was justified or consumed. No GitHub-hosted runner was used.
