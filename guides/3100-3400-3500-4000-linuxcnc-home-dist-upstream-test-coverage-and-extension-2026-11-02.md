# LinuxCNC home-dist: reproduce the upstream test, then close the missing abort oracle

**4000-LC-HOMING-167 — disconnected software-lab commissioning card, 2026-11-02. NOT RUN.** Companion [source and upstream-test audit](../research/4400_LINUXCNC_HOMING_167_UPSTREAM_HOME_DIST_REGRESSION_ORACLE_COVERAGE_AUDIT_2026-11-02.md). For mill/router/gantry and custom kinematics; **not** an actual-machine commissioning authorization.

## Reuse the upstream fixture, do not invent a second one

Pin the source tree to LinuxCNC commit `67437d8865e431a9a33f74cee912dbf891d3b4c5`, build/activate that tree's LinuxCNC run-in-place environment according to its build instructions, then inspect `tests/home-dist/{test.ini,home-dist.hal,test-ui.py,test.sh}`. In a **verified isolated, physically disconnected** LinuxCNC simulation environment:

```sh
git rev-parse HEAD                     # must equal pinned commit
cd tests/home-dist
cat test.ini home-dist.hal test-ui.py   # confirm exact fixture, no unexpected edits
bash ./test.sh                          # runs linuxcnc -r test.ini; NOT RUN HERE
```

Capture `git rev-parse HEAD`, installed/build version, command exit code, stdout/stderr, `linuxcnc` error-channel messages, HAL state traces and exact job start/end timestamps. The `linuxcnc -r` invocation requires the source tree's appropriate run-in-place setup; do not substitute an installed stable binary for a development fixture. Use **only** an independently verified isolated `[self-hosted, openpressbrake]` runner if remote compute is justified. No GitHub-hosted runners, no fallback, no workflow dispatched by this guide.

## Frozen test-source expectations (not observations)

A. J0 dead switch: `HOME_SEARCH_DIST` error; peak |delta|=5.00±0.01 mm and end delta=-5.00±0.01 mm. This is a **stay at search endpoint** case.

B. J0 stuck-on: `did not clear` error; peak |delta|=2.00±0.01 mm; endpoint returns within 0.01 mm of **backoff-move start**.

C. J0 intermittent after search: `HOME_LATCH_DIST` error; final delta from home-command start in (-3.6,-2.6) mm; farthest delta <-4.9 mm. The latch return target is not the original command start.

D. J1/J2 both stuck on, synchronized `HOME_SEQUENCE=-1`: J1 peak 2.00±0.01 mm; J1 and J2 end within 0.01 mm of their respective move starts; J2 must not reach its independent 3 mm bound.

E. J0 working switch: `s.homed[0]` becomes true within 20 s. Failure cases A–D also require `STATE_ON` and all three unhomed; exit zero and printed `success` are the overall harness pass, not proof of physical motion.

## Extension F — missing version-sensitive previously-homed witness (design only)

**Question:** Does a failed home attempt on a *different* joint invalidate an already homed, unrelated joint? Existing HOMING-90 and HOMING-131 source predicts development all-joint invalidation versus v2.9.10 local invalidation; the upstream home-dist test cannot answer it.

1. Prepare **separate version-compatible** minimal three-joint simulations: no `HOME_SEARCH_DIST/HOME_LATCH_DIST` keys in the stable control; use identical `HOME_SEQUENCE`, `HOME_IS_SHARED`, homing-switch wiring and feedback simulation where supported. Do not compare different failure causes.
2. Successfully home independent J0 and assert `homed[0]==1` *before* injecting the fault. Retain a timestamped status snapshot.
3. Make J1's `HOME_IS_SHARED=1` switch input already asserted, then request J1 homing. This enters `HOME_START` shared-switch abort in both inspected revisions; confirm actual error-channel string and whether the J1 homing state machine ran.
4. After the state machine returns idle, capture **all** joint homed/homing/home-state flags and Task state. Source-predicted discriminator: stable preserves J0 homed, development clears J0. Both require J1 unhomed; do not treat Task remaining on as proof of motion safety.
5. Run a no-fault control (J0 remains homed after J1 successful home) and a single-joint failure control without prior J0 homing. Record any disagreement as a source/test mismatch; do not change the oracle after seeing results.
6. Explicitly handle fast aborts: the upstream `home()` helper may miss a transient `homing==1` and return the wrong tuple shape. The extension should observe `home-state`/error-channel and final status independently rather than assuming a transient homing bit must be sampled.

**Do not run F on a physical machine.** A software `homed` flag is not independent position trust; a synchronized final homing move is not a dual-axis safety function.

## Reproducibility and classification checklist

- Confirm the exact commit and **blob SHAs** from the audit, or log deviations before interpreting a result.
- Confirm virtual `motor-pos-cmd→motor-pos-fb` feedback; do not claim real encoder, torque, racking or hard-limit behavior.
- Separate **SOURCE-CONFIRMED** source paths, **UPSTREAM TEST SOURCE INSPECTED** frozen assertions, **TEST-CONFIRMED** local output (only after a run), and **UNKNOWN** physical behavior.
- Keep LAB_COMPUTE_LOG unchanged until an authoritative job actually executes; record real timestamps then.
- Keep independent safety/evaluation gates and graduated levels unchanged.

**Fresh-AI transfer prompt (unscored):** If a test reports the right 2 mm return for J1 but J2 reaches its 3 mm bound, identify which upstream case fails, what source condition selects the peer return, and what additional trace distinguishes stale HAL observation from a missing `home_return` fanout. Do not use this as a sealed blind answer key.
