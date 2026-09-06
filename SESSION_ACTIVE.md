# Active Curriculum Session

- Start UTC: `2026-09-06T11:14:15Z`
- End UTC: `2026-09-06T11:20:28Z`
- Module: `M03 One servo-period source-level trace`
- State: `CLOSED`
- Outcome: completed the pinned one-period controller/command-handler call flow, located exact `joint.N.motor-pos-fb` sampling and `joint.N.motor-pos-cmd` publication boundaries, derived the canonical linuxcncrsh one-cycle loopback prediction, and launched bounded experiment `008` as Actions run `34029848545`, job `101477262140`, from SHA `10f187e8a33b741f9af5c12975150ddbb497af1a`. The run was still in progress at session close, so no M03 runtime semantic claim was promoted.
- Next checkpoint: inspect exactly run `34029848545` / job `101477262140`; require fresh metadata, `motion-command-handler < motion-controller < sampler.0`, zero sampler overruns, at least 100 moving samples, declared lag-vs-same-sample gates, same-sample joint-command agreement, and the completion marker. If valid, accept the precise canonical-loopback result and proceed to M03 exam/corrections/handoff; if harness-invalid, correct only the demonstrated defect before one materially corrected rerun.

This file is a crash/concurrency marker. Closed sessions remain here until the next session overwrites the marker with its own start state.
