# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T05 — custom operator interface patterns** are **GRADUATED at 1000 level**. Phase 9 is complete.

The next curriculum module is **C01 — simulated dual-actuator machine**, but Phase 10 activation is currently gated by the required **blind development-bank baseline** specified in `evaluation/BLIND_FEEDBACK_PROTOCOL.md`. That baseline has not been fabricated because genuine evaluator/learner information separation is required.

Repository artifacts, not chat history, remain authoritative.

## T03 retained boundary

T03-020 workflow `34182846956`, job `101925247534`, passed frozen Gates A-G. An ESTOP-invalid `AUTO_STEP` was assigned/echoed serial 3 while matching aggregate status and `wait_complete()` were `RCS_ERROR`, with independent operator-error evidence preserved before any later serial.

Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 retained boundary

T04-021 workflow `34186879941`, job `101936899842`, artifact `10040862703`, exit `0`, passed frozen Gates A-H. Independent controller state advanced while a deliberately failed GUI status observation left GStat invalid and presentation stale; recovery caught up on the next successful observation.

Retained rule: **a rendered GUI value is a presentation claim. Identify its source and freshness before treating it as current controller state; controller/HAL/physical/safety evidence remain separate.**

## T05 graduated evidence

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable artifacts include:

- `guides/T05-custom-operator-interface-research.md`;
- `call-flows/T05-custom-operator-interface-boundaries.md`;
- frozen `experiments/T05-022-startup-freshness-gating-plan.md`;
- rejected-run analysis `experiments/T05-022-attempt1-harness-diagnosis.md`;
- corrected `lab-jobs/022-t05-startup-freshness-gating.sh`;
- accepted result `experiments/T05-022-accepted-result.md`;
- `exams/T05-custom-operator-interface-adversarial.md`;
- `checkpoints/T05-fresh-ai-handoff.md`;
- `checkpoints/T05-graduation-decision.md`.

### Source/call-flow result

Representative HALUI paths:

```text
HAL input transition -> check_hal_changes() -> send*() -> emcCommandSend() -> Task
NML status -> updateStatus() -> modify_hal_pins() -> halui.* status output
```

HALUI input pins represent operator intent; HALUI status pins are userspace projections of received controller status, not direct realtime/physical/safety truth.

Pinned QtVCP screen startup proves handler `initialized__()` precedes the explicit `STATUS.forced_update()` synchronization point. T05-022 attempt 1 then exposed an important nuance: `_GStat.__init__()` itself can make a best-effort `stat.poll()+merge()` while `_status_active` remains false. The guide was corrected accordingly.

Retained startup rule:

```text
GStat construction / retained cache
!= validated/current observation
!= command acceptance
!= physical action
!= safety authority
```

### T05-022 attempt history

Attempt 1 — workflow `34189716347`, job `101945103662`, artifact `10041831379`, exit `24`: **HARNESS INVALID**. The proxy was blocked before GStat construction, so constructor and tested update both failed; the implementation also adapted the policy to the observed baseline. No behavioral verdict was taken.

Attempt 2 — workflow `34193926426`, job `101957458393`, artifact `10043263546`, source commit `593f30df11611c76b7707d90b2a4a94b7b796104`, exit `0`: **TEST-CONFIRMED**. Frozen Gates A-H passed unchanged.

Decisive evidence included:

```text
independent-controller-state=0 policy-required-state-on=4
gstat-construction attempts=1 failures=0 cached-state=0 valid=0
first-tested-observation valid=0 attempt-delta=1 failure-delta=1 events=['periodic']
gate-D=PASS
gate-E=PASS
gate-F=PASS
recovery valid=1 cached-state=0 independent-state=0 gated-enabled=0 expected-enabled=0
gate-G=PASS
gate-H=PASS
T05-022 overall=PASS
```

The experiment supports the 1000-level policy: **start controller-dependent UI actions fail-defined and require explicit successful/current observation evidence for advisory enablement. Construction cache and GUI responsiveness are not freshness certificates.**

### T05 graduation checks

- source mechanism and representative call flows: PASS;
- official documentation and community pass: PASS;
- predeclared experiment with independent runtime evidence: PASS;
- failure/harness correction: PASS;
- adversarial exam: 10/10 PASS;
- fresh-AI novel scenario: PASS;
- higher-level promotion queue: populated;
- counterfactual promotion test: PASS;
- minimum 1000-level evidence floor: PASS.

## T05 promotion queue

- multi-command-producer correlation/races — 2000 HIGH;
- error-channel fan-out/multiple consumers — 2000 HIGH;
- remote UI/NML reconnect and packet/timing failures — 2000 HIGH;
- physical pendant/HALUI latency and failure behavior — 2000 MEDIUM;
- safety-HMI architecture/certification — specialized higher level.

None can overturn the central 1000-level separation between presentation, freshness, semantic result, physical truth and safety authority.

## Blind-feedback checkpoint — current blocker before Phase 10

The development-bank blind baseline required after T03 remains unscored. `evaluation/FEEDBACK_SCORE_LOG.md` is intentionally empty rather than contaminated.

**Exact next-work checkpoint:** establish a genuinely blind challenge with evaluator/learner information separation; expose only the challenge packet and allowed resources; commit the learner's prediction/diagnosis/mechanism/observable result/diagnostic path/falsifier/confidence/time/resources **before** revealing the hidden oracle; then obtain the external result, score all five dimensions, record error class/correction/transfer plan, append `evaluation/FEEDBACK_SCORE_LOG.md`, and only then activate **C01 — simulated dual-actuator machine**.

If the runtime cannot provide an information-separated evaluator/oracle, do not fake a baseline or inspect a hidden answer in the learner role.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` now exactly backfills T02-019 through T05-022 attempt 2: **18.1 minutes (0.30 h)** of authoritative job time, plus unbackfilled historical usage. T05 attempt 1 is counted despite being harness-invalid.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.
