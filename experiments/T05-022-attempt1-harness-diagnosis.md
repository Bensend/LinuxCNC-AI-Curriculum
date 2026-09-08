# T05-022 attempt 1 — harness diagnosis

Status: **HARNESS INVALID — no behavioral verdict**  
Workflow: `34189716347`  
Authoritative job: `101945103662`  
Artifact: `10041831379`  
Repository lab exit code: `24`  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## What the run established

The run proved pinned provenance and the lifecycle ordering gate before reaching its invalidity check:

- Gate A passed with checkout `8bf4605ae81042248add031e94c77300406e0413` and pinned module hashes.
- Gate C passed: `handler_instance.initialized__()` occurs before `self.STATUS.forced_update()` in the pinned QtVCP entry point.
- Gate B passed with an independent `linuxcnc.stat()` observer.

The decisive trace then reported:

```text
construction unsafe-enabled=1 gated-enabled=0 required-state=0
first-observation valid=0 attempts=2 failures=2 unsafe-enabled=1 gated-enabled=0
HARNESS_INVALID: decisive first poll failure not isolated
```

Therefore this attempt is not evidence for or against the frozen T05-022 prediction.

## Root cause 1 — GStat construction performs a poll

Pinned `lib/python/common/hal_glib.py`, `_GStat.__init__()`, calls:

```python
try:
    self.stat.poll()
    self.merge()
except:
    pass
```

before the later `update()` path. The attempt-1 `PollProxy` was blocked before constructing `GStat`, so it deliberately failed both:

1. the constructor's best-effort poll; and
2. the explicitly tested `g.update()` poll.

The frozen Gate D requires the **first tested/forced observation** to fail without silently substituting a successful merge. It does not require corrupting the constructor's best-effort initialization attempt. Attempt 2 will therefore allow construction to finish, record constructor poll behavior explicitly, then inject exactly one failure around the tested `update()` call and prove the attempt/failure deltas are exactly one.

This is a source-reading correction: QtVCP's explicit `STATUS.forced_update()` still occurs after handler `initialized__()`, but GStat/Status object construction can perform an earlier best-effort status poll. A custom-OI freshness rule must not equate "constructed status object" or retained cache contents with a validated post-initialization synchronization point.

## Root cause 2 — implementation drifted from the frozen policy premise

The frozen plan states that the independently established controller state should be one that keeps the chosen action unavailable. Attempt 1 instead set:

```python
required_state = actual
```

which makes the observed baseline state policy-satisfying by construction. That weakens the intended adversarial test and is not accepted.

Attempt 2 will use a fixed advisory policy: the modeled action requires `linuxcnc.STATE_ON`. The harness will independently verify that the fixture baseline is **not** `STATE_ON`; otherwise it will stop as harness-invalid rather than adapting the policy after observation.

## Unchanged frozen Gates A–H

No gate is weakened or rewritten. Attempt 2 preserves:

- pinned provenance;
- independent controller baseline;
- source-proved `initialized__()` before explicit `forced_update()`;
- exactly one deliberately failed tested observation with invalid status;
- unsafe-default exposure;
- fail-defined freshness gate holding;
- recovery by removing only the injected poll failure and matching the fixed policy;
- explicit separation of GUI presentation, observation freshness, command semantics, physical action, and safety-rated enforcement.

## Attempt count

This is materially similar attempt **1 of 3** under the repeated-experiment safeguard. It failed because of harness design, not LinuxCNC behavior. Attempt 2 is justified because the correction is source-grounded and does not alter the frozen behavioral question or gates.
