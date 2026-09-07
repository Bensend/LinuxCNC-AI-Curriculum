# S04-014 accepted result — same-runtime stationary and moving feedback freeze

- Module: S04 — stale/frozen feedback
- Course level: 1000
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Curriculum source commit: `bb0b6ce8e7a630a837079aadb39964d04ea66e66`
- Workflow run: `34127182365`
- Artifact: `linuxcnc-lab-014-s04-feedback-freeze-single-runtime-34127182365-1`
- Artifact digest reported by GitHub: `sha256:83bde681d123949feba28d5a69cd1ef69da642a202750ee285955f164dd00e56`
- Lab exit code: `0`
- Lab UTC interval: `2026-09-07T13:24:08Z` to `2026-09-07T13:29:48Z`
- Classification: **TEST-CONFIRMED / ACCEPTED**

## Why this is the authoritative S04 experiment

Earlier S04-014 attempts were rejected for instrumentation precision or cross-runtime lifecycle problems. After the three-attempt safeguard, the experiment was materially redesigned so the stationary-frozen adversarial control runs first and the moving frozen-feedback fault injection runs afterward in the same LinuxCNC/HAL runtime. This removes teardown/restart behavior from the evidence path without changing the immutable S04 numerical or behavioral gates.

The accepted run used the predeclared `MIN_FERROR=0.010`, `FERROR=0.100`, joint maximum velocity `1.0`, approximately half-limit commanded motion, the runtime `joint.0.f-error-lim` as threshold oracle, stock realtime `abs` + `comp` for strict crossing, and sampler overrun checks.

## Gate D first — stationary frozen control

Observed:

- Combined runtime ready on readiness probe 4.
- Realtime order: `motion-controller=5`, freeze `mux2=6`, strict comparator `comp=16`, sampler `17`.
- Before freeze: `motion=TRUE`, `amp=TRUE`, `f-errored=FALSE`, `error=FALSE`.
- Held feedback value and command were both `0`.
- **600 sampled servo cycles** were observed, exceeding the required >=250 cycles.
- `max_cmd_move=0` and `max_fb_move=0`.
- `overlim=0` — no strict comparator crossing.
- `ferrored=0`.
- `errors=0`.
- `motion_off=0`.
- `amp_off=0`.
- sampler overruns: `0`.
- Result: `gate-D-stationary-frozen-control=PASS`.

After unfreezing, the same runtime returned to live feedback and remained healthy: `motion=TRUE`, `amp=TRUE`, `f-errored=FALSE`, `error=FALSE`.

### Interpretation

This independently verifies the central negative S04 claim: an unchanged feedback value is not by itself evidence of staleness. When command and frozen feedback remain equal while stationary, ordinary following-error logic has no mismatch to detect and can remain fault-free indefinitely. This is an identifiability boundary, not a defect claim.

## Gates A/B/C — moving feedback freeze

Healthy moving baseline:

- `cmd=0.03075`
- `fb=0.03225`
- reported `ferror=0`
- runtime `f-error-lim=0.05`
- `f-errored=FALSE`
- `error=FALSE`
- `motion=TRUE`
- `amp=TRUE`
- Result: `gate-A-healthy-baseline=PASS`.

Freeze injection:

- held feedback: `0.04525`
- command at freeze: `0.05025`
- the requested move retained at least the predeclared remaining travel margin before freeze
- moving sampler overruns: `0`

Realtime analysis across the frozen interval:

- frozen samples: `6349`
- maximum observed command travel before disable: `0.05`
- maximum runtime following-error limit: `0.05`
- rounded text alone did **not** prove strict crossing (`text_crossed=0`), reproducing the known precision limitation
- the realtime stock comparator did prove strict `abs(f-error) > f-error-lim` (`rt_crossed=1`)
- following-error flag observed (`ferrored=1`)
- exact following-error diagnostic observed (`exact_fault=1`)
- disable observed (`disable=1`)
- Results: `gate-B-moving-freeze-threshold=PASS`, `gate-C-following-error-disable=PASS`.

The lab ended with: `S04 frozen-feedback experiment completed successfully.` and exit code `0`.

## Prediction check

Predeclared prediction: stationary frozen feedback that remains equal to command will not create a following-error fault merely because it is unchanged; during commanded motion, frozen feedback will eventually make command/feedback mismatch exceed the actual runtime following-error threshold and propagate into LinuxCNC's ordinary joint/motion disable path.

Observation: **MATCH**. Both halves were demonstrated in one runtime with zero sampler overruns.

## What this proves

At the pinned revision, for the representative ordinary active-joint path:

1. LinuxCNC following error detects command-versus-feedback mismatch, not generic sample age.
2. A frozen feedback value can be observationally indistinguishable from valid stationary feedback when no independent freshness information exists.
3. When command moves away from frozen feedback far enough to exceed the runtime following-error limit, the production motion path can assert following error and disable ordinary motion/joint enable state.
4. Realtime instrumentation is necessary when a strict threshold crossing can be hidden by rounded textual snapshots.

## What this does not prove

This software/simulation experiment does **not** prove physical encoder behavior, drive behavior, stopping time/distance, STO operation, contactor state, safety-rated diagnostic coverage, PL/SIL/category, or that any downstream actuator actually became torque-free. It also does not establish device-specific timestamp/heartbeat freshness mechanisms.

## Earlier attempts

The accepted result does not erase the rejected attempts. They remain useful evidence about experiment design:

- decimal text could not establish a strict transition;
- an obsolete text gate can invalidate an otherwise improved oracle;
- cross-runtime teardown/restart created false readiness and HAL namespace races;
- after three similar failures the required ESSENTIAL NOW decision caused the successful same-runtime material redesign.

These are curriculum-method findings as well as S04 history.
