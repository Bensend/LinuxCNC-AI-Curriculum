# M03 — accepted result for lab 008

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Curriculum SHA: `10f187e8a33b741f9af5c12975150ddbb497af1a`

Actions run/job: `34029848545` / `101477262140`

Lab artifact: `lab-results/run-34029848545-1/`

## Acceptance

The run is valid and all predeclared semantic gates passed.

- Metadata is fresh for the intended curriculum SHA and `008-m03-servo-cycle-loopback.sh`.
- HAL order was `motion-command-handler` before `motion-controller` before `sampler.0`; observed source-output line numbers were 4, 5, and 14 respectively.
- `sampler-overruns=0`.
- Moving sample count was 2175, exceeding the required 100.
- `lag_avg=0` and `lag_max=0` for `joint.0.pos-fb[n]` versus prior-sample `Xpos[n-1]`.
- Same-sample feedback error was materially nonzero: `same_avg=4.16551724138e-06`.
- `joint.0.pos-cmd[n]` matched same-sample `Xpos[n]` exactly in the measured interval: `cmd_avg=0`, `cmd_max=0`.
- Explicit completion marker was present and the lab exited 0.

## Promoted conclusion

**TEST-CONFIRMED for this pinned canonical simulation:** with `joint.0.motor-pos-cmd` looped directly to `joint.0.motor-pos-fb`, and a sampler scheduled after `motion-controller`, motion publishes `joint.0.pos-fb` from the signal value sampled earlier in that controller invocation while publishing the new command later in the same invocation. Thus during the measured ordinary zero-compensation move:

`joint.0.pos-fb[n] == Xpos[n-1]`

while

`joint.0.pos-cmd[n] == Xpos[n]`.

This confirms the source-derived phase relationship documented in `call-flows/M03-one-servo-period.md`.

## Boundaries

This does not establish a universal one-cycle lag for arbitrary LinuxCNC machines. HAL composition is configuration-defined; a hardware feedback-read function scheduled before motion can make new feedback available to that same controller invocation. The result also does not establish realtime deadlines, scheduler latency, physical I/O timing, network timing, encoder validity, following-error safety behavior, or functional-safety properties.
