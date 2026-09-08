# C02-024 preimplementation source clarification — PID error target

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

This clarification was recorded **after experiment gates were frozen but before the harness was written or any C02-024 runtime result was observed**. It does not change Gates A–H.

Pinned `calc_pid()` has a behaviorally important option: `pid.N.error-previous-target` defaults true. Unless an index-reset exception applies, that mode computes the presented/control error against `prev_cmd - feedback` rather than the current command. The function still reads current command and feedback once per invocation and keeps per-instance state, but the one-cycle target convention would make a simple `command-feedback` interpretation imprecise.

For C02-024 the harness must explicitly set both `pid.0.error-previous-target` and `pid.1.error-previous-target` **false**. This keeps the experimental oracle aligned with the frozen teaching claim that the observed error is the same-cycle sampled current command minus that instance's feedback. Both loops receive the same setting, so this is not an asymmetric disturbance.

This is a source-driven fixture-definition clarification, not post-result threshold tuning. If the runtime fixture cannot prove both pins are false, Gate A/topology is invalid.

The disabled-loop source path remains suitable for Gate H: `calc_pid()` still computes/stores error, resets integral state when disabled, and forces final output to zero for that instance.
