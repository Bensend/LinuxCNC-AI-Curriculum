# C02-024 authoritative run checkpoint

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

Frozen plan: `experiments/C02-024-independent-feedback-disturbance-plan.md`

Implementation commit: `fd7e812108f1161e2e575aad6b864b3dd04bdfcc`

Authoritative GitHub Actions workflow: `34219392130`

Authoritative job: `102038671214`

State when this checkpoint was written: **IN PROGRESS** in the lab execution step.

No duplicate run has been launched and no TEST-CONFIRMED claim is made before the authoritative artifact/exit code is available.

## Required reconciliation

When the run completes, preserve the artifact ID, job runtime, inner lab exit code, stdout/stderr, and raw sampler evidence. Reconcile frozen Gates A-H without changing thresholds. If the harness itself is invalid, classify that before changing any test condition. If valid and passing, continue through accepted-result writeup, `LAB_COMPUTE_LOG.md`, adversarial exam, fresh-AI novel-scenario handoff, promotion/counterfactual audit, and C02 graduation decision before starting C03.

The one-servo staging rule remains binding: sampler runs after both `integ` plants, while each PID error was calculated before its plant update in that cycle. Same-row `command - post-plant feedback` must not be incorrectly demanded to equal same-row `pid.error`.
