# C07 — Novel State-Sequencing Fresh-AI Handoff

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Handoff scope

A fresh AI is assumed to have only the C07 research/source/function/call-flow artifacts, frozen/accepted experiment artifacts, and the referenced pinned LinuxCNC source. It should be able to design and debug ordinary machine-state sequencing without inventing successful state transitions from command history and without confusing ordinary LinuxCNC state integrity with functional safety.

## Novel transfer scenario

This scenario is deliberately different from C07-047's `motion.enable` injection.

A generic LinuxCNC machine is already in logical `ON_CONFIRMED`, and a higher-level sequencer has set its non-safety-rated cycle permission. `motion.enable` remains **true**, but a joint amplifier fault occurs. Realtime Motion subsequently revokes its enabled state and returned `halui.machine.is-on` falls false. Several seconds later the amplifier fault input clears by itself; `motion.enable` never changed. The pre-fault `start_authorize` latch in a naive sequencer is still true.

Question for the fresh learner:

1. Should the sequencer stay `ON_CONFIRMED` because its original machine-ON request succeeded and `motion.enable` is still true?
2. Which evidence should drive exit from the active state?
3. Is the cleared amplifier fault sufficient to retry or restore cycle permission automatically?
4. What additional logical action is required before a new machine-ON request, and what must be observed before cycle permission can return?
5. What can and cannot be concluded about physical restart safety from these LinuxCNC states?

## Fresh-context reasoning result

**PASS.** The scenario transfers the C07 mechanism to a different fault cause without relying on the experiment's exact `motion.enable` seam.

The correct reasoning is:

- The sequencer must **not** remain active from request history. Pinned Motion fault handling has several possible causes that can revoke enabling, including joint amplifier faults. The high-level state should represent achieved LinuxCNC state, not the fact that an earlier request once succeeded.
- Returned `halui.machine.is-on=false` is the relevant achieved-state evidence for leaving `ON_CONFIRMED` in this generic policy. The sequencer should revoke cycle permission and enter recovery even though `motion.enable` itself never fell. This is exactly why the active transition should not be hard-coded to one injected cause.
- Clearing the amplifier-fault input only removes/changes one cause. It does not itself restore Task/Motion achieved ON, and it does not turn a stale pre-fault authorization into a legitimate retry.
- Entry into recovery consumes the old authorization. After all required readiness predicates are re-established, the policy requires a **fresh post-fault authorization**, emits one fresh machine-ON request, and waits for returned achieved ON before granting cycle permission again.
- None of those software states proves the machine's physical plant is safe to restart. Drive output state, mechanical position, stored energy, external E-stop/guard/interlock state, tooling/workpiece state and applicable functional-safety requirements remain machine-specific evidence outside this software fixture.

## Transfer discriminator

The novel scenario demonstrates that the learned rule is not merely:

```text
if motion.enable falls, go to recovery
```

The transferable rule is:

```text
request history is not achieved state
active permission depends on current achieved/readiness predicates
fault-cause restoration is not restart authorization
recovery consumes stale authorization
fresh request is status-gated again
```

## Handoff implementation checklist

A fresh AI should now be able to:

- locate HALUI request/status surfaces;
- trace machine ON request through NML/Task/Motion and back through returned status;
- identify multiple Motion fault causes that can revoke achieved enable;
- implement one-authorization/one-request/no-hidden-retry policy;
- separate cause inputs from achieved-state predicates;
- preserve homing/configuration sensitivity rather than inventing universal transitions;
- distinguish ordinary logical restart integrity from physical/functional-safety restart evidence.

**C07 fresh-AI novel-scenario handoff: PASS.**
