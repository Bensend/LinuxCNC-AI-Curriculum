# S06 reusable fault-injection result schema v1

Status: frozen for S06-016 before implementation.

## Purpose

Every fault-injection lab should make it mechanically obvious whether the evidence shows:

- the fault was actually injected;
- the target mechanism responded;
- recovery occurred;
- the capture/harness was valid;
- a conclusion is intentionally *not* supported.

A single process exit code is not enough for later AI handoff.

## Required top-level fields

```json
{
  "schema_version": "linuxcnc-ai-fi-v1",
  "module": "S06",
  "experiment": "S06-016",
  "linuxcnc_commit": "8bf4605ae81042248add031e94c77300406e0413",
  "fixture_revision": "<curriculum commit>",
  "attempt_family": "<name>",
  "overall": "PASS|BEHAVIOR_FAIL|HARNESS_INVALID",
  "exit_code": 0,
  "thread_order_verified": true,
  "capture_health": {
    "sampler_overruns": 0,
    "trace_rows": 0,
    "trace_complete_for_required_windows": true
  },
  "cases": [],
  "invalid_oracle_example": {},
  "recovery": {},
  "non_claims": []
}
```

## Required case record

Each case must have independent fields for **injection evidence** and **response evidence**.

```json
{
  "id": "freeze",
  "scheduled_window": "cycles 50-79",
  "expected": {
    "injection": "published sequence/value stop advancing while healthy reference advances",
    "response": "age detector asserts; value detector may assert once value delta exceeds threshold"
  },
  "injection_evidence": {
    "pass": true,
    "observations": ["raw sampled facts only"]
  },
  "response_evidence": {
    "pass": true,
    "observations": ["downstream stock observer outputs"]
  },
  "recovery_evidence": {
    "pass": true,
    "observations": ["fresh publication and detector clear after the fault window"]
  }
}
```

## Classification rules

### PASS

All predeclared behavioral gates pass, injection evidence is independently present, function order is verified, and capture-health criteria pass.

### BEHAVIOR_FAIL

The harness is valid and the intended injection is independently demonstrated, but a predeclared target-response or recovery prediction fails.

### HARNESS_INVALID

Use when the experiment cannot support a LinuxCNC behavior conclusion, including:

- fixture fails to load or start;
- required HAL topology/function order differs from the frozen plan;
- sampler overruns/lost rows invalidate exact-cycle analysis;
- the intended fault did not actually occur;
- required trace windows are missing;
- parser/result-generation failure prevents checking the frozen gates.

A HARNESS_INVALID attempt does **not** count as evidence against the product/stock HAL behavior.

## Oracle rule

An `injection_evidence` observation cannot consist only of the fixture's own mode/fault declaration. Example of an invalid circular oracle:

> `fault_mode == 2`, therefore a one-cycle jump occurred.

That proves only the scheduler believes it selected mode 2.

Acceptable evidence instead compares raw sampled values that must differ if the injection actually occurred, for example:

> healthy value = 1.00, published value = 6.00, healthy/published sequence equal on exactly one sampled cycle.

Likewise, changing an injected value and then reading that same value back is not enough to prove the downstream subsystem responded. The response evidence must come from the observer/target mechanism or an independently derived state.

## Trace requirement

The raw trace must preserve enough columns to independently recompute every accepted gate. For S06-016 this means at minimum:

- realtime cycle;
- healthy value;
- published value;
- healthy sequence represented as sampled numeric value;
- published sequence represented as sampled numeric value;
- fixture mode (metadata only; not sufficient as an oracle);
- value delta / absolute value delta;
- sequence/age delta / absolute age delta;
- downstream value detector;
- downstream age detector.

The experiment should print or persist its JSON result and the raw trace. The general lab runner already preserves stdout/stderr and workflow artifact directories; S06-016 may emit JSON into stdout and/or its run output while runner-level schema collection remains future tooling.

## Exit-code convention for S06-016

- `0` — all gates PASS.
- `20-39` — valid harness, behavioral gate failure.
- `60-79` — HARNESS INVALID.
- shell/build/setup failures outside the controlled classifier may use their natural nonzero code but must be classified in the result analysis before any product conclusion.

## Safety/non-claim requirement

Every result must carry explicit non-claims. For S06-016:

- no physical sensor fault coverage;
- no HostMot2/FPGA fault coverage;
- no Ethernet/packet-loss behavior;
- no safety integrity level, performance level, category, diagnostic coverage, or safe-stop validation;
- hosted userspace realtime timing is not physical-machine timing evidence.
