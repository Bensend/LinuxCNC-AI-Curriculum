# F02 adversarial exam — compound-fault diagnosis and recovery

Status: **FROZEN BEFORE ANSWERS**
Course level: 2000
Pinned LinuxCNC revision for exact source claims: `8bf4605ae81042248add031e94c77300406e0413`
Total: 20 points
Critical-fail questions: Q1, Q3, Q5, Q7.

Use source/evidence boundaries explicitly. Do not infer physical truth from software state alone.

## Q1 — misleading green diagnostics (3 points, critical)

A Mesa Ethernet fault occurred during motion. Thirty seconds later `io_error` is clear, the HostMot2 watchdog is no longer bitten, an internal step-generator accumulator changes, and two encoders agree numerically. The application saved the pre-fault motion command and proposes replaying it automatically.

Is automatic replay justified? Identify at least four distinct facts/authorities that the premise improperly collapses, and give the minimum generic recovery sequence F02 permits.

## Q2 — source-navigation task (2 points)

At the pinned revision, identify the LinuxCNC Task function that clears pending command/interpreter execution during abort and state which lower-level abort it invokes first. Explain why this source path matters to a stale-command recovery claim.

## Q3 — compound symptom/root-cause trap (3 points, critical)

A retained episode records `TRANSPORT_INVALID` on invocation N and `FOLLOWING_ERROR` on N+1. A community report says lost Ethernet communication can cause stale feedback and a following error. May the diagnostic UI label the episode root cause `ETHERNET CAUSED FOLLOWING ERROR` as a source-confirmed fact? What may it say safely, and why retain both bits?

## Q4 — recorder-integrity trap (2 points)

During a compound machine fault the HAL recorder reports overruns, but an independent realtime interlock already revoked ordinary motion authority. Does recorder failure mean the machine necessarily continued moving? Does it mean the interlock necessarily failed? What exact class of conclusion is degraded?

## Q5 — same-cycle evidence claim (3 points, critical)

An engineer claims: “The Python log shows the communication fault at 12:00:00.100 and the HAL log shows authorization false at 12:00:00.101, therefore LinuxCNC revoked authority on the very next servo cycle.” No shared generation identifier exists.

Evaluate the claim. Specify the evidence topology needed to support a same-cycle or one-cycle revocation statement.

## Q6 — version-sensitive question (2 points)

A machine is labelled only “LinuxCNC 2.9”. A field engineer asks for the exact `hm2_eth` retry/error-recovery behavior and exact watchdog-reset consequences. What must be obtained before making exact source claims, and what can still be said generically from the F02 evidence?

## Q7 — reconciliation interrupted by a second fault (3 points, critical)

Transport and watchdog have recovered and reconciliation has begun. Before reconciliation completes, a required interlock drops. An HMI implementation continues reconciliation, then changes to READY because the position reference check passed.

Evaluate this behavior against F02-001. State the required state transition and what happens to diagnostic history and rearm state.

## Q8 — small implementation-change task (2 points)

A prototype currently stores only:

```text
faulted = any_fault_now
if not faulted:
    authorized = true
```

Give the smallest conceptual state/data redesign that makes it consistent with F02 without inventing machine-specific safety logic. Your answer must explicitly cover current conditions, latched diagnostic history, evidence validity, reconciliation, explicit rearm and stale command ownership.
