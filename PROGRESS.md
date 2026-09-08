# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T05 — custom operator interface patterns** are **GRADUATED at 1000 level**. Phase 9 is complete.

The required blind development baseline has now been completed validly, so Phase 10 is active. **C01 — simulated dual-actuator machine** is now **CORRECTIONS** after C01-023 attempt 1 exposed a temporally torn userspace observation harness. The original frozen behavioral Gates A-H remain unchanged.

Repository artifacts, not chat history, remain authoritative.

## Blind development baseline — BL-DEV-001

The learner response was immutably committed in `evaluation/development/BL-DEV-001-precommit.md` at commit `2117ac7103f929a0d90b59551785500d2b59b874` before pinned implementation/documentation oracle inspection.

Challenge competency: HAL same-thread ordering and one-cycle stale-data propagation through a deliberately inverted producer/consumer schedule.

Result:

- blind validity: **VALID**;
- score: **10/10**;
- confidence: **92%**;
- solve time to immutable commit: **0.48 min**;
- error class: none;
- detailed evaluation: `evaluation/development/BL-DEV-001-evaluation.md`;
- score ledger updated in `evaluation/FEEDBACK_SCORE_LOG.md`.

No immediate corrective transfer retest is required because there was no miss/partial miss. A novel retention/development challenge should sample a different mechanism after roughly 10 subsequent lessons or about 24 hours, preserving the actual delay. One baseline score is not evidence of a study-method trend.

## C01 — simulated dual-actuator machine

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Current source result

C01 uses LinuxCNC's generalized duplicated-coordinate `trivkins` mechanism rather than the deprecated legacy `gantry` HAL component.

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

For the pinned upstream `XYZY` gantry fixture, Y maps to joint 1 and joint 3. `lib/hallib/gantrysim.hal` preserves distinct `joint.1.*` and `joint.3.*` command/feedback/enable/fault interfaces.

Important retained boundary: forward mapping uses the principal/first duplicated joint for the world coordinate; duplicated `trivkins` is therefore command fan-out, **not** an automatic two-joint disagreement detector or synchronization controller.

### Durable C01 artifacts

- `guides/C01-simulated-dual-actuator-research.md`;
- `call-flows/C01-world-coordinate-to-duplicate-joints.md`;
- frozen `experiments/C01-023-dual-joint-command-fanout-plan.md`;
- `lab-jobs/023-c01-dual-joint-command-fanout.sh` in commit `266d5d556861467497ebcf1d06a74c3ab219571a`;
- `results/C01-023-attempt-1-reconciliation.md` in commit `ffa05b04d70f6065e9376cbf179f146113707b07`.

Current official documentation confirms that duplicate coordinate letters may assign multiple joints to one axis coordinate and recommends `KINEMATICS_BOTH` where independent joint/world operation is needed. The legacy `gantry` component is documented as superseded by `trivkins`. Community gantry reports were used as investigation leads and reconciled against source/upstream examples. Community warnings about individually moving one side of an unhomed gantry are retained for the later adversarial exam; they do not alter C01-023's frozen runtime gates.

### Frozen C01-023 prediction

A meaningful coordinated Y move in a running pinned `trivkins coordinates=XYZY kinstype=BOTH` fixture will cause both `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` to change and remain equal within `1e-9` machine units, while the joint endpoints remain separately observable.

The upstream-style simulation's per-joint command-to-feedback loopback is explicitly treated as an ideal fixture property. It cannot prove physical actuator synchronization, independent-loop behavior, fault tolerance, or functional safety.

### C01-023 attempt 1 reconciliation

Authoritative attempt 1:

- workflow: `34199237041`;
- job: `101973964122`;
- artifact: `10045220748`;
- artifact digest: `sha256:66fa2611eef9fcebf61c68cc0497a6348f79dfb50ee46eab00f167fb6f48c688`;
- triggering commit: `266d5d556861467497ebcf1d06a74c3ab219571a`;
- lab interval: `2026-09-08T07:25:20Z`–`2026-09-08T07:28:39Z`;
- exit: `41`;
- disposition: **HARNESS INVALID**.

Attempt 1 established provenance, four-joint duplicated-Y topology, distinct joint endpoints, homed/coordinated motion, 982 samples, nontrivial motion and no error-channel events before Gate E. It then reported:

```text
max-abs-j1-j3-command-diff=0.001
max-abs-j1-command-feedback-loopback-diff=0.001
max-abs-j3-command-feedback-loopback-diff=0.001
```

The apparent discrepancy is not a valid same-cycle comparison. The harness read `joint.1` command, `joint.3` command and both feedback pins using four sequential userspace `hal.get_value()` calls. The fixture servo period is 1 ms and the commanded speed is 60 in/min = 1 in/s. One servo update between two userspace reads therefore creates exactly 0.001 in of apparent separation — exactly the observed maximum. The direct command-to-feedback nets showed the same 0.001 signature, strongly exposing the temporal tear.

Pinned `position_to_mapped_joints()` independently assigns the same `pos->tran.y` value to every joint in `Y_joints_bitmap` during one inverse-kinematics call. Because the frozen plan explicitly classifies unreliable pin observation as HARNESS INVALID, Gate E remains at `1e-9`; it is **not** weakened post-result.

### Correction invariant

C01-023 attempt 2 must replace the equality oracle with a realtime same-thread snapshot using LinuxCNC `sampler`/`halsampler` (or equivalently proven pinned realtime HAL stream capture), added after `motion-controller` in `servo-thread`. Direct userspace reads remain suitable for endpoint-existence Gate C but are forbidden as the simultaneous equality oracle.

The corrected harness must also preserve raw realtime samples and perform controlled shutdown/Gate H evidence before returning a behavioral failure code, so a failed Gate E cannot suppress its own decisive trace.

**Exact next-work checkpoint:** correct only `lab-jobs/023-c01-dual-joint-command-fanout.sh` to use realtime same-servo-cycle sampling for joint 1/joint 3 command and loopback evidence, preserving frozen Gates A-H and the exact `1e-9` threshold. Commit the harness correction, run one authoritative attempt 2 against pinned `8bf4605ae81042248add031e94c77300406e0413`, preserve realtime samples plus cleanup evidence even if a behavioral gate fails, then reconcile the original Gates A-H. Do not graduate C01 from attempt 1.

## T03 retained boundary

T03-020 workflow `34182846956`, job `101925247534`, passed frozen Gates A-G. An ESTOP-invalid `AUTO_STEP` was assigned/echoed serial 3 while matching aggregate status and `wait_complete()` were `RCS_ERROR`, with independent operator-error evidence preserved before any later serial.

Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 retained boundary

T04-021 workflow `34186879941`, job `101936899842`, artifact `10040862703`, exit `0`, passed frozen Gates A-H. Independent controller state advanced while a deliberately failed GUI status observation left GStat invalid and presentation stale; recovery caught up on the next successful observation.

Retained rule: **a rendered GUI value is a presentation claim. Identify its source and freshness before treating it as current controller state; controller/HAL/physical/safety evidence remain separate.**

## T05 retained boundary / promotion queue

Pinned QtVCP/HALUI work established:

```text
GStat construction / retained cache
!= validated/current observation
!= command acceptance
!= physical action
!= safety authority
```

T05 higher-level promotions remain:

- multi-command-producer correlation/races — 2000 HIGH;
- error-channel fan-out/multiple consumers — 2000 HIGH;
- remote UI/NML reconnect and packet/timing failures — 2000 HIGH;
- physical pendant/HALUI latency and failure behavior — 2000 MEDIUM;
- safety-HMI architecture/certification — specialized higher level.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` exactly backfills T02-019 through T05-022 attempt 2: **18.1 minutes (0.30 h)** of authoritative job time, plus unbackfilled historical usage. C01-023 attempt 1 consumed 3m19s of inner-lab time (`07:25:20Z`–`07:28:39Z`); add it to the compute ledger during the next exact backfill rather than hiding the invalid attempt's cost.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.