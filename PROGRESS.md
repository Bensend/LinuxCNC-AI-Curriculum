# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T05 — custom operator interface patterns** are **GRADUATED at 1000 level**. Phase 9 is complete.

The required blind development baseline has now been completed validly, so Phase 10 is active. **C01 — simulated dual-actuator machine** is now **EXPERIMENT** at the frozen C01-023 checkpoint.

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
- frozen `experiments/C01-023-dual-joint-command-fanout-plan.md`.

Current official documentation confirms that duplicate coordinate letters may assign multiple joints to one axis coordinate and recommends `KINEMATICS_BOTH` where independent joint/world operation is needed. The legacy `gantry` component is documented as superseded by `trivkins`. Community gantry reports were used as investigation leads and reconciled against source/upstream examples.

### Frozen C01-023 prediction

A meaningful coordinated Y move in a running pinned `trivkins coordinates=XYZY kinstype=BOTH` fixture will cause both `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` to change and remain equal within `1e-9` machine units, while the joint endpoints remain separately observable.

The upstream simulation's per-joint command-to-feedback loopback is explicitly treated as an ideal fixture property. It cannot prove physical actuator synchronization, independent-loop behavior, fault tolerance, or functional safety.

**Exact next-work checkpoint:** implement `lab-jobs/023-c01-dual-joint-command-fanout.sh` exactly against frozen C01-023 Gates A-H, auto-launch it once, preserve the authoritative workflow/job/artifact and raw command/feedback trace, then reconcile the unchanged gates. If valid, continue C01 adversarial exam/fresh-AI handoff/graduation; if the runtime cannot establish world motion or provenance, classify HARNESS INVALID rather than weakening the gates.

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

`LAB_COMPUTE_LOG.md` exactly backfills T02-019 through T05-022 attempt 2: **18.1 minutes (0.30 h)** of authoritative job time, plus unbackfilled historical usage. No C01 lab compute has yet been consumed at this checkpoint.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.
