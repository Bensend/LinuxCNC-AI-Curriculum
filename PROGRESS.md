# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T04 — GUI integration boundaries** are **GRADUATED at 1000 level**. **T05 — custom operator interface patterns** is the highest-priority unblocked module and is active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

Repository artifacts, not chat history, remain authoritative.

## T03 retained boundary

T03-020 workflow `34182846956`, job `101925247534`, passed frozen Gates A-G. An ESTOP-invalid `AUTO_STEP` was assigned/echoed serial 3 while matching aggregate status and `wait_complete()` were `RCS_ERROR`, with independent operator-error evidence preserved before any later serial.

Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 graduated evidence

T04-021 workflow `34186879941`, authoritative job `101936899842`, artifact `10040862703`, exit `0`, passed frozen Gates A-H. Independent controller state advanced while a deliberately failed GUI status observation left GStat invalid and presentation stale; recovery caught up on the next successful observation.

Retained T04 rule: **a rendered GUI value is a presentation claim. Identify its source and freshness before treating it as current controller state; controller/HAL/physical/safety evidence remain separate.**

## T05 source/call-flow state

Durable artifacts now include:

- `guides/T05-custom-operator-interface-research.md`;
- `call-flows/T05-custom-operator-interface-boundaries.md`;
- frozen `experiments/T05-022-startup-freshness-gating-plan.md`;
- `lab-jobs/022-t05-startup-freshness-gating.sh`.

Pinned HALUI source establishes the representative path:

```text
HAL input transition -> check_hal_changes() -> send*() -> emcCommandSend() -> Task
NML status -> updateStatus() -> modify_hal_pins() -> halui.* status output
```

HALUI command inputs are generally edge/momentary intent. Its output pins are userspace projections of the most recently received `emcStatus`, not realtime/safety-rated truth.

Pinned QtVCP startup establishes the key T05 lifecycle boundary:

```text
build widgets -> handler initialized__() -> STATUS.forced_update() -> status timer -> HAL ready -> show/event loop
```

Therefore custom handler `initialized__()` runs before QtVCP's explicit forced controller-status synchronization. Construction-time widget defaults are not evidence that a valid controller observation has occurred.

QtVCP `Status` is a singleton around GStat and owns one error channel with explicit polling arbitration. Direct Python examples similarly instantiate command/status/error interfaces separately; cross-producer result correlation remains an explicit architecture responsibility.

Community reports support two failure hypotheses: HALUI MDI mode/order surprises should be debugged against actual status rather than UI assumptions, and `wait_complete()` cannot serve as a completion oracle for commands issued by another producer. These remain community evidence where not already established by T03 source work.

## T05-022 frozen experiment

T05-022 was frozen before implementation. It compares two custom presentation policies during a deliberately failed **first** QtVCP/GStat status observation:

- deliberately unsafe default: action begins enabled;
- freshness-gated: action begins disabled and may enable only after a successful, policy-satisfying observation.

Frozen Gates A-H require pinned provenance, independent controller baseline, proof that handler initialization precedes forced status observation, an isolated failed first observation with invalid status, unsafe-default exposure, gated hold, recovery after removing only the injected failure, and explicit preservation of these boundaries:

```text
widget enabled != fresh controller observation
fresh controller observation != command acceptance
command acceptance != physical action
GUI gating != safety-rated enforcement
```

Implementation commit `33a210d3618ca2174eec8523ac2c52cfcee92075` triggered authoritative workflow **`34189716347`**. It was queued at the current checkpoint. Do not launch a duplicate while it is active.

## Exact next-work checkpoint

1. Inspect workflow `34189716347` final status, job identity, exit code, stdout/stderr, and preserved provenance/output.
2. Reconcile **unchanged** T05-022 Gates A-H. A harness/provenance failure is not evidence for or against the prediction.
3. If valid and passing, write the accepted result and update `LAB_COMPUTE_LOG.md` from authoritative Actions job start/end timestamps when available.
4. Perform T05 adversarial exam including startup default-state, multi-producer command ownership, diagnostic-consumer ownership, HALUI status projection freshness, and the misleading premise that disabled GUI controls constitute a safety function.
5. Produce a fresh-AI handoff and counterfactual promotion audit; graduate T05 only if the 1000-level evidence floor is satisfied.

## T05 promotion queue

- multi-command-producer correlation/races — 2000 HIGH unless T05-022 exposes a current-level contradiction; does not block the startup/freshness ownership objective;
- error-channel fan-out/multiple consumers — 2000 HIGH; source establishes ownership concern, but full arbitration design is beyond the 1000-level pattern objective;
- remote UI/NML reconnect and packet/timing failures — 2000 HIGH;
- physical pendant/HALUI latency and failure behavior — 2000 MEDIUM, hardware-dependent aspects promoted;
- safety-HMI architecture/certification — specialized higher-level study; 1000-level teaching explicitly forbids treating GUI/HALUI as safety-rated evidence.

## Blind-feedback checkpoint

The development-bank blind baseline required after T03 remains due before leaving the current Phase-9 module cluster for a later major cluster. Preserve genuine evaluator/learner information separation; do not manufacture a contaminated score.

## Laboratory compute checkpoint

T03-020 and T04-021 repository metadata contain inner script timestamps, but `LAB_COMPUTE_LOG.md` requires authoritative Actions job start/end timestamps. Record T05-022 authoritative job runtime after workflow completion if the job endpoint exposes it; do not substitute lesson time.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.
