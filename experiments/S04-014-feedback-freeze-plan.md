# S04-014 — simulated feedback-freeze experiment plan

Status: PREDECLARED — do not change acceptance gates after observing the run.  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Independently verify two paired predictions through the production motion following-error path:

1. feedback frozen while command moves far enough will produce a following-error fault and disable motion;
2. feedback frozen while command is genuinely stationary is not, by itself, detectable by following error.

The second prediction is as important as the first because it prevents teaching following error as a universal freshness detector.

## Harness concept

Use a minimal one-joint simulation derived from an existing headless lab configuration. Insert a controllable HAL feedback selector between `joint.0.motor-pos-cmd` and `joint.0.motor-pos-fb`.

Healthy mode passes command position through as feedback. Freeze mode holds the last/explicit feedback value while leaving the command/motion path otherwise unchanged.

Prefer an existing realtime HAL component capable of sample/hold or muxing a captured value. If no stock component can provide deterministic hold semantics without contaminating the command path, implement the smallest test-only HAL component. Do not modify production motion source.

## Predeclared numerical configuration

Target values, unless the selected existing simulation imposes a stricter compatible limit:

- `MIN_FERROR = 0.010` machine units
- `FERROR = 0.100` machine units
- joint velocity limit: `1.0` unit/s
- commanded test velocity: approximately `0.5` unit/s
- expected active ferror limit at that velocity: approximately `0.050` units (subject to exact runtime `joint.0.f-error-lim`)
- moving-freeze commanded travel: at least `0.20` units after freeze, comfortably exceeding both the expected threshold and `FERROR`
- stationary observation interval: at least 250 servo cycles after freeze

Runtime `joint.0.f-error-lim`, not the arithmetic estimate, is the acceptance threshold oracle.

## Gate A — healthy baseline

Require before injection:

- machine/motion enabled;
- `joint.0.amp-enable-out = TRUE`;
- healthy selector mode active;
- command changes during a bounded move;
- feedback follows command within less than `MIN_FERROR`;
- `joint.0.f-errored = FALSE` and `joint.0.error = FALSE`.

Failure here is HARNESS INVALID.

## Gate B — freeze during motion

While enabled and moving, switch only the feedback selector to hold/freeze. Require evidence that:

- `joint.0.motor-pos-cmd` continues changing after freeze for enough distance to exceed the observed `joint.0.f-error-lim`;
- `joint.0.motor-pos-fb` remains unchanged within numerical tolerance;
- `abs(joint.0.f-error)` grows past `joint.0.f-error-lim`.

## Gate C — expected production fault/disable

Require realtime or sufficiently high-rate capture of the transition showing:

- `joint.0.f-errored = TRUE` at/after threshold crossing;
- diagnostic contains `joint 0 following error`;
- `joint.0.error = TRUE` is observed in the transition or status path;
- `motion.motion-enabled = FALSE`;
- `joint.0.amp-enable-out = FALSE`.

A late asynchronous snapshot alone must not be used to disprove a transient state.

## Gate D — stationary-frozen adversarial control

Use a fresh/re-enabled instance or controlled reset so Gate C's latched/error state cannot contaminate this case. Establish command and feedback equal and stationary, then freeze feedback without commanding movement. Observe at least 250 servo cycles and require:

- command remains stationary;
- feedback remains unchanged;
- `abs(joint.0.f-error) <= joint.0.f-error-lim` throughout;
- no following-error diagnostic attributable to this interval;
- `joint.0.f-errored = FALSE` and motion remains enabled.

This is a PASS, not a detector failure: it demonstrates the identifiability limit.

## Failure classification

- configuration cannot enable/move before injection: **HARNESS INVALID**;
- freeze changes command path or unrelated enable/fault input: **HARNESS INVALID**;
- moving freeze exceeds the observed limit without ferror assertion: **PREDICTION FAIL — investigate source/harness before rerun**;
- stationary freeze trips despite command/feedback remaining equal: **PREDICTION FAIL — inspect actual cause before explanation**.

Apply the curriculum three-similar-attempt safeguard.

## Evidence boundary

A PASS verifies LinuxCNC software behavior for this simulated fault injection only. It does not establish real encoder failure modes, physical stop time, drive/STO behavior, redundant diagnostic coverage, or functional-safety performance.