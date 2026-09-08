# T05-022 — accepted result: custom-OI startup freshness gating

Status: **TEST-CONFIRMED — Gates A-H PASS**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Authoritative workflow: `34193926426`  
Authoritative job: `101957458393`  
Workflow head: `593f30df11611c76b7707d90b2a4a94b7b796104`  
Artifact: `10043263546`  
Artifact digest: `sha256:0dc0841f9df4979a30dc6842d639712146d1d4e5d21f301ee626247737216716`  
Repository lab exit: `0`

## Attempt history

Attempt 1, workflow `34189716347`, exit `24`, was **HARNESS INVALID** and is preserved separately. It blocked the proxy before `GStat` construction, unintentionally failing both the constructor's best-effort poll and the explicitly tested `update()` poll. It also adapted the modeled policy to the observed state, weakening the frozen premise. No behavioral result was taken from attempt 1.

Attempt 2 corrected those harness defects without weakening frozen Gates A-H.

## Observed decisive trace

```text
checked-out-commit=8bf4605ae81042248add031e94c77300406e0413
gate-A=PASS
lifecycle-initialized-offset=14296 forced-update-offset=15543
gate-C=PASS
independent-controller-state=0 policy-required-state-on=4
gate-B=PASS
gstat-construction attempts=1 failures=0 cached-state=0 valid=0
handler-initialization unsafe-enabled=1 gated-enabled=0 required-state=4
first-tested-observation valid=0 attempt-delta=1 failure-delta=1 cached-state=0 events=['periodic'] unsafe-enabled=1 gated-enabled=0
gate-D=PASS
gate-E=PASS
gate-F=PASS
recovery valid=1 cached-state=0 independent-state=0 gated-enabled=0 expected-enabled=0 attempt-delta=1 failure-delta=0 events=['periodic']
gate-G=PASS
boundary: widget enabled != fresh controller observation
boundary: fresh controller observation != command acceptance
boundary: command acceptance != physical action
boundary: GUI gating != safety-rated enforcement
gate-H=PASS
T05-022 overall=PASS
T05-022 shell-harness=PASS
```

## Gate reconciliation

### Gate A — provenance: PASS

The harness checked out the exact pinned LinuxCNC revision and recorded the GStat and QtVCP module paths/hashes.

### Gate B — independent controller baseline: PASS

An independent `linuxcnc.stat()` observer established Task state `0`. The fixed modeled action policy required `linuxcnc.STATE_ON == 4`, so the baseline independently proved the action should not be available. The harness would have rejected a baseline already satisfying the policy rather than changing the policy after observation.

### Gate C — lifecycle ordering: PASS

Pinned `qtvcp.py` source proved handler `initialized__()` appears before the explicit `STATUS.forced_update()` synchronization point.

Attempt-1 source analysis adds an important nuance: `_GStat.__init__()` itself may make a best-effort `stat.poll()+merge()`. Therefore Gate C is correctly interpreted as screen-handler initialization preceding QtVCP's explicit forced update, not as a claim that no earlier constructor poll can occur.

### Gate D — failed first tested observation: PASS

After GStat construction was allowed to perform exactly one successful best-effort poll, the harness injected exactly one failure into the explicitly tested update. The deltas were one attempt and one failure, `_status_active` was false, and the only recorded signal was generic `periodic`; no state-change event was substituted.

### Gate E — unsafe default exposure: PASS

The deliberately default-enabled model remained enabled while the tested controller observation was invalid.

This is evidence of a presentation-policy error, not evidence that Task or machine safety was bypassed.

### Gate F — freshness gate holds: PASS

The fail-defined model started disabled and remained disabled because validity was false, even though the constructor had retained a plausible cached Task state.

This experimentally demonstrates the useful rule:

```text
cached value exists != fresh/validated observation
```

### Gate G — recovery: PASS

The harness removed only the injected poll failure. The next tested observation made status valid, cached state matched the independent controller baseline, and the fixed policy result remained correctly disabled because Task was not `STATE_ON`.

### Gate H — boundary discipline: PASS

The run explicitly retained all four frozen boundaries:

```text
widget enabled != fresh controller observation
fresh controller observation != command acceptance
command acceptance != physical action
GUI gating != safety-rated enforcement
```

## Conclusion

T05-022 supports the 1000-level custom-OI pattern:

**Controller-dependent operator actions should start fail-defined and become advisory-enabled only under an explicit successful/current observation policy. Retained cache, widget state, or GUI responsiveness are not freshness certificates.**

This result does not claim that QtVCP itself is unsafe, does not test hazardous motion, and does not elevate ordinary GUI gating into a safety function.

## Corrections incorporated

The experiment materially improved the teaching. The earlier shorthand that handler initialization precedes the “first valid status poll” was overbroad. Pinned source shows GStat construction may already poll and merge. The durable distinction is now:

```text
GStat construction/best-effort cache
!= explicit validated update/freshness contract
!= semantic command authority
!= physical state
!= safety authority
```

The call-flow guide and experiment harness were corrected accordingly.

## Promotion / uncertainty queue

- multi-command-producer correlation/races — **2000 HIGH**;
- error-channel fan-out/multiple consumers — **2000 HIGH**;
- remote UI/NML reconnect and packet/timing failure — **2000 HIGH**;
- physical pendant/HALUI latency/failure behavior — **2000 MEDIUM**;
- safety-HMI integrity/certification — specialized higher-level study.

### Counterfactual promotion test

If every promoted item behaved differently than currently expected, none would make these central 1000-level statements false:

- presentation state is not proof of observation freshness;
- observation freshness is not command acceptance;
- command acceptance is not physical action;
- ordinary GUI/HALUI state is not a safety-rated authority;
- multi-producer systems require explicit ownership/correlation rather than assuming one local UI owns global controller truth.

The promoted items may refine implementation choices and failure handling, but they do not invalidate the evidence chain or downstream prerequisite at this level. Promotion is therefore safe.
