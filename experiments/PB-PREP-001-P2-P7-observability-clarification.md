# PB-PREP-001 P2–P7 observability clarification

Status: **FROZEN BEFORE FIRST P2–P7 BEHAVIORAL EXECUTION**

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

Parent contracts:
- `experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md`
- `experiments/PB-PREP-001-behavioral-execution-freeze.md`
- `experiments/PB-PREP-001-P2-P7-runner-implementation-contract.md`

During implementation review, two observability requirements in the parent plan were found to be stronger than the 26-field implementation-contract list:

1. Gate G explicitly requires the effective following-error limits in the same atomic stream as each Y-side following error.
2. The P7 oracle requires identifying the last completed realtime cycle with fixture `run=true` and the first completed cycle with `run=false`; the 26-field list did not include a sampled run-state witness.

The first P2–P7 runner therefore appends three **instrumentation-only** fields after the previously frozen 26 fields, without changing any controller equation, plant equation, trajectory, disturbance, duration, threshold, gain, command limit, differential-authority limit, outcome classification, or Gate A–J criterion:

27. `joint.1.f-error-lim`
28. `joint.3.f-error-lim`
29. `pb-prep.0.run-witness`

The first 26 fields retain exactly the previously frozen logical order. `run-witness` is a realtime output copied from the fixture's `run` parameter in `prepare()` so P7 can be scored from the atomic producer stream rather than from userspace command timing.

This clarification strengthens observability only. It cannot be changed after seeing P2–P7 behavioral results. Any missing/mistyped appended witness is `HARNESS INVALID`, not a reason to infer the value from userspace timing.
