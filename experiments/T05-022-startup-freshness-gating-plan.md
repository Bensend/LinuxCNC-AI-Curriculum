# T05-022 — custom-OI startup freshness gating

Status: **FROZEN BEFORE IMPLEMENTATION**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

Can custom QtVCP handler logic make an operator action appear available before the first valid controller observation, and can an explicit freshness gate prevent that presentation error without pretending to replace Task/controller enforcement?

## Source-grounded reason

Pinned `qtvcp.py` invokes handler `initialized__()` before `STATUS.forced_update()` and before the periodic status timer is started. Therefore constructor/handler defaults are not evidence that the first framework status synchronization has succeeded.

## Frozen prediction

With controller Task state independently established as a state that should keep the chosen action unavailable, inject failure into the first QtVCP/GStat status poll.

1. A deliberately **unsafe-default** model initialized as enabled will remain enabled through the failed first observation because no valid status merge occurred.
2. A **freshness-gated** model initialized disabled and enabled only after a successful, policy-satisfying status observation will remain disabled while status validity is false.
3. After removing only the injected poll failure, a successful observation will update validity/state and the gated model will follow policy.
4. The experiment will not claim that disabled GUI state is a safety function or that enabled state guarantees semantic command acceptance.

## Harness design

Use the pinned QtVCP/GStat Python modules in the existing headless/offscreen laboratory pattern from T04-021. Do not require a human GUI.

Record monotonically ordered events for:

- independent controller state;
- handler/construction phase;
- unsafe-default enabled state;
- gated enabled state;
- injected status-poll outcome;
- `is_status_valid()` / `_status_active` evidence;
- cached/presented controller state;
- recovery poll outcome;
- emitted state event(s).

The action itself need not energize motion. The experiment tests presentation/ownership timing; Task semantic authority was already independently established in T03.

## Gates — frozen

### Gate A — provenance
Harness proves LinuxCNC source/build revision `8bf4605ae81042248add031e94c77300406e0413` and records the relevant QtVCP module paths/hashes.

### Gate B — independent controller baseline
Before the injected GUI observation failure, an independent `linuxcnc.stat()` observer successfully establishes the actual controller Task state used by the policy.

### Gate C — lifecycle ordering
Trace proves custom handler/model initialization occurs before the first forced status observation used by the test.

### Gate D — failed first observation
The first tested QtVCP/GStat observation is deliberately failed and status validity is false. No successful merge/state event may be silently substituted for it.

### Gate E — unsafe default exposure
During Gate D, the deliberately default-enabled model is still enabled even though its required fresh controller evidence is absent. This is a presentation-policy failure, not a controller safety failure.

### Gate F — freshness gate holds
During the same failed-observation interval, the freshness-gated model remains disabled because valid policy evidence is absent.

### Gate G — recovery
After removing only the injected observation failure, a successful poll makes status valid, updates the cached/presented controller state, and causes the gated model to match the declared advisory policy.

### Gate H — boundary discipline
Result reconciliation must explicitly state all of the following:

```text
widget enabled != fresh controller observation
fresh controller observation != command acceptance
command acceptance != physical action
GUI gating != safety-rated enforcement
```

## Adversarial checks

- Reject a harness that initializes the gated model from an unvalidated cached status value.
- Reject a harness that uses the same failed GStat object as the independent controller oracle.
- Reject a result that proves only widget state without proving observation validity.
- Reject a result that sends a hazardous motion command merely to demonstrate button enablement.
- Reject any post-hoc weakening of Gates A-H after seeing the run.

## Pass meaning

A pass supports the 1000-level custom-OI pattern: **start controller-dependent actions fail-defined (normally unavailable), and make freshness/validity an explicit prerequisite for advisory enablement.** Final command semantics and safety enforcement remain below the presentation layer.

## Failure meaning

A valid contradictory result blocks the current teaching and requires source/harness reconciliation. A harness/provenance failure is not evidence for or against the prediction.
