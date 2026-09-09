# D01-006 — Redesigned preflight attempt 3: runtime PASS, evidence publication invalid

## Classification

**NON-AUTHORITATIVE RUNTIME PREFLIGHT PREDICATES PASS / FINAL EVIDENCE-PUBLICATION HARNESS INVALID.**

Frozen D01-002 Gates A–J remain **UNSCORED**. The `015 -> 016 -> 017` redesigned wrapper lineage has now consumed three attempts and is retired.

## Run identity

- Workflow: `34350408741`
- Job: `102462004744`
- Source commit: `8b6e67eab9113aaffe6e8212b3b5cca8097a1415`
- Job: `lab-jobs/017-d01-redesigned-observer-preflight-phase-helper-fix.sh`
- Artifact: `10103614029`
- Artifact digest: `sha256:28f99131a0d6aa7eb5030cb0d795a425f73f7e0ad26317fcefbb1ad0ee2aa2b6`
- Inner lab UTC: `2026-09-09T12:20:10Z`–`2026-09-09T12:24:38Z`
- Final exit: `129`

## Runtime evidence reached before the final harness error

The run reached the real pinned `motmod + trivkins` duplicated-Y fixture and the test-only Cartesian observer. Runtime topology retained both joint command/feedback paths, each joint's following error/limit/fault state, `motion.motion-enabled`, and `motion.d01-cart-y-observer`.

Servo-thread order was retained as:

```text
1 motion-command-handler
2 motion-controller
3 mux16.0
4 mux2.0
5 sum2.0
6 sampler.0
```

The normal `linuxcnc.command()` NML path successfully performed explicit homing and MDI:

```text
python-driver PASS homed=(1, 1, 1, 1) posY=10.0 actualY=10.0 task_state=4
```

The key numeric observations were:

```text
settled y1cmd=10 y2cmd=10 y1fb=10 y2fb=10 cartY=10 motion=TRUE
low y2-ferror=-0.02 lim=0.05 y2fault=FALSE cartY=10 motion=TRUE
high y1-ferror=0 y2-ferror=-0.2 y2lim=0.05 y1fault=FALSE y2fault=TRUE cartY=10 motion=FALSE
fresh-reenable observed task_state=4 enabled=True
sampler-overruns=0
sample-count 2200
analysis p3-pre=27 low-hidden=58 cart-low=58 p5-pre=26 high-trip=68 principal-clean=68 disabled=68 cmddup=927
D01-REDESIGNED-PREFLIGHT=PASS
```

This non-authoritatively validates the planned numeric fixture:

- duplicated Y joint commands really fan out together at the nonzero world command;
- duplicate-only offset `0.020` is measurably divergent but remains below the observed applicable `0.050` ferror limit;
- while that low divergence exists, Cartesian Y remains equal to the clean principal feedback and not the duplicate feedback;
- offset `0.200` drives duplicate ferror beyond its limit;
- the duplicate joint asserts following error while the principal does not;
- global motion enable is revoked while Cartesian Y still reports the clean principal value;
- the decisive stream had 2,200 rows and zero reported producer overruns;
- P3/P5 phase-before-mutation and the intended discriminator windows were found by the retained live analysis.

The numeric values `OFFSET_LOW=0.020`, `OFFSET_HIGH=0.200`, and observed relevant limit `0.050` are therefore frozen for the next evidence-retention redesign. They must not be tuned from subsequent authoritative output.

## Why this is still not an accepted preflight evidence package

After all runtime assertions passed, the script attempted its final observer-source provenance command after it had changed working directory from the LinuxCNC source tree into `/tmp/d01`:

```text
git diff "$LINUXCNC_COMMIT" -- src/emc/motion/...
```

Because the command no longer ran from the source repository, Git emitted usage/help and returned `129`. More importantly, the complete `/tmp/d01.samples` and other locally retained files were not copied into the workflow artifact path before termination. Thus the runtime behavior was observed and live-validated, but the complete evidence set required for frozen Gate J was not durably packaged.

This distinction is deliberate:

```text
runtime assertions passed != evidence package complete
live full trace existed != full trace durably retained
non-authoritative numeric validation != authoritative Gates A-J pass
```

## Three-attempt action

Do not repair D01-017 incrementally. The redesigned wrapper lineage is retired under the curriculum three-attempt rule.

The next fixture must be a clean standalone evidence-retaining harness. It should preserve the now-validated behavior implementation but make evidence ownership explicit from the beginning: capture the observer patch while still in the source repository; collect configuration/HAL/source patch/startup logs/topology/thread order/recorder health/full sample stream/analysis into an artifact-owned directory; and only then exit success.

A fresh non-authoritative **retention/provenance preflight** is required before the independent authoritative D01 run. That preflight is not permission to alter the frozen conceptual gates or the validated numeric values.

## Community cross-check retained this session

Community gantry/tandem discussions reinforce a separate architecture boundary: synchronized tandem homing can establish a reference/squared relationship, but it is not continuous runtime proof of mechanical alignment. See `guides/D01-community-tandem-homing-vs-runtime-authority.md`.

## Safety/evidence boundary

The runtime result concerns LinuxCNC software behavior in a simulated duplicated-coordinate fixture. Even eventual authoritative confirmation will not prove a physical press brake is square, hydraulically balanced, safely stopped, sensor-diverse, or functionally safety-certified.
