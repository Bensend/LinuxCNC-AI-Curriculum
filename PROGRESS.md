# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T05 — custom operator interface patterns** and **C01 — simulated dual-actuator machine** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is now **C02 — independent feedback loops**, state **RESEARCH**.

Repository artifacts, not chat history, remain authoritative.

## Blind development baseline — BL-DEV-001

The learner response was immutably committed in `evaluation/development/BL-DEV-001-precommit.md` at commit `2117ac7103f929a0d90b59551785500d2b59b874` before pinned implementation/documentation oracle inspection.

Result: **VALID, 10/10, 92% confidence**. Detailed evaluation is in `evaluation/development/BL-DEV-001-evaluation.md`; the score ledger is `evaluation/FEEDBACK_SCORE_LOG.md`.

A novel retention/development challenge should sample a different mechanism after roughly 10 subsequent lessons or about 24 hours, preserving the actual delay. One baseline score is not evidence of a study-method trend.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Core source result

C01 uses generalized duplicated-coordinate `trivkins` rather than the deprecated legacy `gantry` HAL component.

Pinned source establishes:

```text
trivkins rtapi_app_main()
  -> allow_duplicates = 1
  -> identityKinematicsSetup()
      -> map_coordinates_to_jnumbers()

world pose
  -> trivkins::kinematicsInverse()
  -> identityKinematicsInverse()
  -> position_to_mapped_joints()
  -> duplicated coordinate copied into every mapped joint
```

For `coordinates=XYZY`, Y maps to joint 1 and joint 3. Forward mapping uses the principal/first duplicated joint for the world coordinate, so duplicated `trivkins` is command fan-out, **not** an automatic two-joint disagreement detector or synchronization controller.

### C01-023 accepted experiment

Frozen prediction: a meaningful coordinated Y move in a pinned `trivkins coordinates=XYZY kinstype=BOTH` fixture causes both `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` to change and remain equal within `1e-9`, while both endpoints remain separately observable.

Attempt 1 (`34199237041`, job `101973964122`, artifact `10045220748`) was **HARNESS INVALID**. Four sequential userspace HAL reads produced a 0.001-inch apparent divergence. At 60 in/min = 1 in/s with a 1 ms servo period, that is exactly one servo tick; the direct command-to-feedback loopbacks exhibited the same signature. The frozen plan already classified unreliable observation as harness-invalid, so Gate E was not weakened.

The observation layer was corrected to realtime `sampler.0`, scheduled after `motion-controller` in the same servo thread. The corrected behavioral run is:

- workflow: `34209185893`;
- job: `102005842122`;
- artifact: `10049218375`;
- source curriculum commit: `5b2309fb33e0a39b56f1cb7ea61b113cfacd95ae`;
- pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`;
- inner lab exit: **0**;
- result: **PASS / TEST-CONFIRMED, Gates A-H**.

Decisive evidence:

```text
runtime-joint-count=4
homed-vector=1,1,1,1
sampler-overruns=0
realtime-samples=5798
realtime-sample-first=0 last=5797
realtime-j1-command-span=5
realtime-j3-command-span=5
max-abs-j1-j3-command-diff=0
max-abs-j1-command-feedback-loopback-diff=0
max-abs-j3-command-feedback-loopback-diff=0
world-y-alone-used-as-joint3-proof=NO
gate-H=PASS
C01-023 overall=PASS
```

The GitHub workflow envelope is red only because its later readable-result commit raced with concurrent curriculum commits. The published artifact preserves the completed inner lab exit 0 and raw trace, so that post-lab publication race is not used as the behavioral oracle.

A separate first correction push (`34209095831`, job `102005554568`) contained a shell-variable typo and terminated before LinuxCNC behavior; it is preserved as **HARNESS INVALID preflight**, not hidden or counted as behavioral evidence.

### C01 durable artifacts

- `guides/C01-simulated-dual-actuator-research.md`
- `call-flows/C01-world-coordinate-to-duplicate-joints.md`
- `guides/C01-simultaneous-observation-boundary.md`
- frozen `experiments/C01-023-dual-joint-command-fanout-plan.md`
- `lab-jobs/023-c01-dual-joint-command-fanout.sh`
- `results/C01-023-attempt-1-reconciliation.md`
- `results/C01-023-realtime-correction-preflight.md`
- `results/C01-023-accepted-result.md`
- `evaluation/C01-1000-graduation-evaluation.md`

### C01 graduation result

Adversarial exam: **10/10**. Fresh-AI handoff: **PASS** on a novel scenario with one independently simulated plant lagging 8 ms while duplicated commands remain equal. Counterfactual promotion audit: **PASS**.

Retained boundary:

```text
same coordinated command
!= same observation instant
!= independent feedback agreement
!= same physical position
!= synchronized plant
!= safety-rated protection
```

Physical feedback, following-error/disagreement handling, homing/squaring, hydraulic interaction, and safety-rated anti-racking are downstream work and are not used to justify C01 graduation.

## C02 — independent feedback loops — RESEARCH

Pinned revision remains `8bf4605ae81042248add031e94c77300406e0413`.

First documentation/source pass is committed in `guides/C02-independent-feedback-loops-research.md`.

Current source-grounded findings:

- LinuxCNC `pid` can export multiple completely separate runtime instances.
- Each `hal_pid_t` owns its own command, feedback, error, previous-state, gain, output and saturation state.
- Each realtime `calc_pid(instance, period)` reads that instance's command and feedback once, computes its own error/output, and does not implicitly inspect a peer PID channel.
- When an instance is disabled, pinned source resets its integrator and forces its output to zero.
- Therefore sharing a command between two independent PID channels does **not** itself create cross-coupled synchronization or a disagreement trip.

Official PID documentation corroborates the independent-channel model. The official Dual Feedback PID example is relevant evidence that LinuxCNC supports separate feedback signals and multiple loops, but it addresses two sensors on one axis with summed effort; it is not treated as a ready-made two-actuator synchronization architecture.

**Exact next-work checkpoint:** continue C02 at SOURCE by inventorying a minimal pinned realtime simulated-plant component suitable for two deterministic independent channels. Trace its per-instance state and scheduling semantics and document the full `duplicated command -> pid A/B -> separate plant A/B -> separate feedback A/B` servo-thread order. Then freeze **C02-024** with same-cycle observation gates and an asymmetric one-feedback disturbance before writing the harness. Do not start C03 cross-coupling until C02 independently proves the two feedback/control paths remain separate.

## T03 retained boundary

T03-020 passed frozen Gates A-G. Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 retained boundary

T04-021 passed frozen Gates A-H. Retained rule: **a rendered GUI value is a presentation claim. Identify its source and freshness before treating it as current controller state; controller/HAL/physical/safety evidence remain separate.**

## T05 retained boundary / promotion queue

Pinned QtVCP/HALUI work established:

```text
GStat construction / retained cache
!= validated/current observation
!= command acceptance
!= physical action
!= safety authority
```

T05 higher-level promotions remain multi-command-producer correlation/races, error-channel fan-out/multiple consumers, remote UI/NML reconnect and packet/timing failures, physical pendant/HALUI latency/failure behavior, and specialized safety-HMI architecture/certification.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` now exactly backfills T02-019 through C01-023 attempt 2: **27.3 minutes (0.46 h)** of authoritative job time, plus unbackfilled historical usage. Invalid C01 runs are included rather than hiding their cost.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.
