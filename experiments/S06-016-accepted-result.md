# S06-016 accepted result — deterministic fault-injection framework

- Module: S06 — fault injection framework
- Course level: 1000
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Fixture source commit: `c116c997e39506bb82bbae6cce777bde19015fde`
- Workflow run: `34146966388`
- Attempt family: `s06-016-deterministic-rt-source-v1`
- Attempt: 1
- Lab exit code: `0`
- Classification: **PASS / TEST-CONFIRMED within the stated HAL software boundary**

## Acceptance basis

The experiment plan and Gates A–J were committed before implementation/result inspection in `experiments/S06-016-framework-fixture-plan.md`. No acceptance criterion was weakened after the run.

The job-produced `linuxcnc-ai-fi-v1` result reports:

- `overall = PASS`;
- `exit_code = 0`;
- realtime thread order verified;
- `sampler_overruns = 0`;
- 170 trace rows with every required cycle window present;
- healthy baseline passed;
- freeze injection/response/recovery passed;
- single-cycle jump injection/response/recovery passed;
- one-cycle-age-skew injection/response/recovery passed;
- the deliberately circular oracle proposition was explicitly classified invalid.

## Gate reconciliation

### Gate A — topology/order and capture health: PASS

The fixture verified source -> stock value observer -> stock age observer -> sampler ordering before accepting behavior. `sampler.0.overruns` remained `0`; all 170 required rows were captured.

This is evidence-health, not product behavior, and is intentionally kept separate.

### Gate B — healthy baseline: PASS

Cycles 10–39 showed healthy and published value/sequence equal with both stock detector outputs clear.

### Gate C — frozen/stuck publication: PASS

Raw injection evidence is independent of the fixture's `mode` output:

- cycle 50 healthy sequence = 50 while published sequence = 49;
- published sequence remains 49 through cycle 79;
- healthy sequence continues to advance to 79;
- age mismatch therefore grows to 30 cycles;
- published value remains 0.49 while the healthy ramp advances.

The age comparator asserts throughout the freeze after the first stale cycle. The value comparator also asserts once accumulated numeric mismatch is above its threshold.

### Gate D — freeze recovery: PASS

At cycle 80 publication immediately returns to the healthy value/sequence and both detectors are clear. Cycles 80–89 remain healthy.

### Gates E/F — one-cycle jump and recovery: PASS

Cycle 100 independently shows:

- healthy value `1.00`;
- published value `6.00`;
- delta `+5.00`;
- healthy/published sequence both `100`;
- value detector asserted;
- age detector clear.

Cycles 99 and 101 are normal; cycle 101 therefore independently demonstrates immediate recovery.

### Gates G/H — deterministic one-cycle age skew and recovery: PASS

Cycles 130–139 independently show:

- published sequence exactly one behind healthy sequence;
- published value exactly the previous healthy ramp value;
- value mismatch `0.01`, below the `0.05` value threshold;
- age mismatch exactly `1.0`, above the `0.5` age threshold;
- value detector clear;
- age detector asserted.

Cycles 140 onward return to current publication and both detectors clear.

This TEST-CONFIRMS the S06 framework lesson that detectability depends on the observable chosen for the fault model. A numerically plausible stale value can evade a value-difference threshold while an independent age/sequence observable detects it.

### Gate I — invalid circular oracle: PASS

The machine-readable result explicitly rejects:

> fixture mode indicates fault, therefore injection and downstream response are proven

The accepted injection evidence is raw reference-versus-published value/sequence behavior. The accepted response evidence is the stock observer output.

### Gate J — machine-readable result: PASS

`lab-results/S06-016.result.json` conforms to the frozen `linuxcnc-ai-fi-v1` structure sufficiently for this experiment: version/experiment identity, attempt family, overall classification, exit code, thread-order flag, capture health, per-case injection/response/recovery, invalid-oracle example, and non-claims are all present.

## Important numerical observation

The human-formatted trace prints cycle 54 value mismatch as `0.050000` while the stock comparator output is already true. That does not contradict the pinned `comp` source's strict `in1 > in0` rule: the trace formatting rounds the internal floating value and is not an exact boundary oracle.

S06 did not predeclare an exact-floating-boundary test, so no result depends on deciding whether the unrounded value was infinitesimally above 0.05. This is a useful adversarial reminder: if exact floating threshold behavior is the claim, capture sufficient precision or compare the source values in the same realtime path rather than inferring equality from formatted decimal text.

## Prediction check

| Scenario | Predeclared prediction | Observation | Match? |
|---|---|---|---|
| Healthy | publication current; both detectors clear | matched cycles 10–39 | YES |
| Freeze | age detector + eventual value detector | matched; age grew to 30, value mismatch grew | YES |
| Freeze recovery | publication current; detectors clear | matched from cycle 80 | YES |
| One-cycle +5 jump | value detector only | matched cycle 100 | YES |
| Jump recovery | clear by cycle 101 | matched | YES |
| One-cycle stale ramp | age detector only because 0.01 < 0.05 | matched cycles 130–139 | YES |
| Skew recovery | both clear after cycle 139 | matched | YES |

## What is TEST-CONFIRMED

At the pinned LinuxCNC revision in the hosted userspace realtime software lab, a deterministic realtime test source plus stock HAL observer functions plus stock realtime sampler can produce and independently verify bounded value/freshness faults with separate injection, response, recovery, and capture-health evidence.

The machine-readable classification method successfully distinguishes the evidence categories needed by future curriculum fault experiments.

## Non-claims

This experiment does not establish:

- physical sensor fault coverage;
- device/FPGA/HostMot2 fault behavior;
- Ethernet/packet loss/reorder/delay behavior;
- physical-machine realtime timing;
- independence/common-cause coverage;
- diagnostic coverage;
- safe stopping;
- PL/SIL/category or any safety integrity property.

## Conclusion

S06-016 satisfies the module's independent-verification and predeclared-prediction requirements. The experiment succeeded on the first attempt, so the three-attempt safeguard was not invoked.
