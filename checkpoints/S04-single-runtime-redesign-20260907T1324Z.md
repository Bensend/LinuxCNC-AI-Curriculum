# S04 checkpoint — single-runtime material redesign

Session start: `2026-09-07T13:18:41Z`

## Durable state

- S04 remains **EXPERIMENT** at pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.
- Workflow `34123752488` is the third and final teardown/restart comparator-family attempt. Its artifact passed moving Gates A/B/C but failed before Gate D because the previous LinuxCNC/HAL runtime never fully disappeared.
- `experiments/S04-014-run-34123752488-analysis.md` classifies the repeated experiment **ESSENTIAL NOW** under the three-attempt safeguard.
- Material redesign: `lab-jobs/014-s04-feedback-freeze-single-runtime.sh` runs stationary Gate D first and moving Gates A/B/C afterward in the same LinuxCNC/HAL runtime, preserving immutable acceptance criteria and eliminating cross-runtime teardown from the evidence path.
- Redesigned run `34127066178` failed before LinuxCNC execution due a Python wrapper-generation quoting defect; classify **HARNESS INVALID**, attempt 1 of the redesigned family.
- Commit `bb0b6ce8e7a630a837079aadb39964d04ea66e66` fixes that quoting defect and the embedded Python generator was parse-checked before commit.
- Workflow `34127182365` is the authoritative redesigned attempt 2 and was still `in_progress` at the last inspection.

## Corroborating research

Current official LinuxCNC INI documentation continues to describe `MIN_FERROR`/`FERROR` as a velocity-dependent command-versus-sensed-position tolerance and explicitly notes the stationary allowance. A 2026 LinuxCNC forum response by Andy Pugh likewise identifies `joint.N.motor-pos-cmd` versus `joint.N.motor-pos-fb` plus scaling/servo-thread placement as the diagnostic comparison for following-error problems. These are corroboration only; pinned source and the lab remain authoritative for S04's implementation claims.

## Exact next work

Inspect workflow `34127182365` and its own artifact/exit code. Accept S04-014 only if the artifact shows all of:

1. Gate D-first stationary freeze: >=250 sampled servo cycles, zero sampler overruns, no realtime strict comparator crossing/over-limit condition, no `f-errored`, no joint error, and motion/amp enable retained.
2. Feedback unfreezes to live loopback and the same runtime remains healthy.
3. Moving Gates A/B/C: healthy baseline; requested move still has >=0.20 units remaining at freeze; explicit held feedback; realtime strict `|f-error| > f-error-lim`; following-error diagnostic; `f-errored`; joint error; motion disable; amp-disable; zero sampler overruns.

If PASS: commit accepted result, audit/correct the existing adversarial exam and fresh-AI handoff, apply the minimum-evidence-floor and counterfactual-promotion test, graduate S04, and activate S05.

If FAIL: diagnose the preserved artifact. One further materially similar single-runtime attempt remains before the safeguard must be applied again. Do not return to teardown/restart variants.
