# F02-001 — compound-fault arbitration and recovery contract

Status: **FROZEN BEFORE IMPLEMENTATION / EXECUTION**
Date frozen: 2026-09-11
Course level: 2000
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test only the generic integration policy learned from D01/S02/E20/X01/X02:

- preserve multiple simultaneous/secondary fault observations;
- keep control authorization, evidence validity, diagnostic history and recovery state separate;
- reject stale-command auto-resume;
- require current prerequisites, explicit reconciliation and explicit rearm before READY/RUNNING returns.

This is a deterministic **ordinary-control policy** test. It is not a motor, network, hydraulic, safety-rated or physical-machine simulation.

## Inputs

Each invocation supplies:

- `run_request`
- `transport_ok`
- `watchdog_clear`
- `feedback_valid`
- `feedback_independent_or_revalidated`
- `reference_valid`
- `required_interlocks_ok`
- `following_error`
- `recorder_valid`
- `reconcile_request`
- `reconcile_complete`
- `explicit_rearm`

## Retained outputs / evidence

Each invocation must retain atomically in one CSV row:

- monotonic invocation `seq`
- phase
- previous and new recovery state
- every input above
- `motion_authorized`
- `stale_command_present`
- current-fault bitset
- latched episode-history bitset
- `evidence_valid`
- `rearm_latched`
- `reconcile_required`
- fault/revocation transition witness

The harness must use deterministic input sequences and preserve every invocation. No post-hoc sampling is allowed.

## State contract

States: `READY`, `RUNNING`, `FAULTED`, `RECONCILE`.

1. `READY -> RUNNING` requires `run_request`, all current control prerequisites valid, no unresolved reconciliation requirement, and a valid explicit rearm latch.
2. Any control-authority prerequisite becoming false while RUNNING causes `RUNNING -> FAULTED` in that invocation and sets `motion_authorized=0`.
3. `following_error` is independently latched as a diagnostic observation. It may also revoke motion, but its coexistence with transport loss must not be rewritten as independent root-cause proof.
4. `recorder_valid=0` independently sets `evidence_valid=0` and latches `RECORDER_INVALID`; recorder invalidity alone is not defined here as a machine-motion fault.
5. Entering FAULTED invalidates stale run ownership: `stale_command_present=0` and clears the rearm latch.
6. FAULTED may enter RECONCILE only on `reconcile_request` when immediate control prerequisites are currently valid enough to reconcile. A second control fault during RECONCILE returns immediately to FAULTED.
7. `reconcile_complete` may establish `feedback_independent_or_revalidated/reference_valid` only when supplied by the test case; the arbiter never invents them from transport recovery.
8. RECONCILE completion returns to READY, never directly to RUNNING.
9. READY remains unauthorized until `explicit_rearm` has occurred after the fault episode/reconciliation.
10. No old `run_request` or stale command may spontaneously restart motion after fault recovery.

## Diagnostic bit classes

Current/latched observation bits:

- `TRANSPORT_INVALID`
- `WATCHDOG_NOT_CLEAR`
- `FEEDBACK_INVALID`
- `FEEDBACK_NOT_REVALIDATED`
- `REFERENCE_INVALID`
- `INTERLOCK_INVALID`
- `FOLLOWING_ERROR`
- `RECORDER_INVALID`

The latched episode-history set is additive during an episode. Clearing a current input must not erase its historical bit until an explicit new-episode reset after successful recovery/rearm.

## Frozen cases

### P0 — nominal start

Start READY with valid prerequisites and explicit rearm. A run request enters RUNNING and authorizes motion.

### P1 — transport loss followed by following error

While RUNNING, `transport_ok` becomes false. Motion must be revoked immediately and `TRANSPORT_INVALID` latched. On the next invocation `following_error` becomes true as well. The history must contain **both** bits; the test must not claim two independent root causes.

### P2 — transport recovers while watchdog/revalidation remain invalid

Restore `transport_ok=1` but leave `watchdog_clear=0`, `feedback_independent_or_revalidated=0`, and `reference_valid=0`. Authorization must stay false. Transport recovery must not clear the episode history.

### P3 — recorder loss during the same episode

Set `recorder_valid=0` while already faulted. `RECORDER_INVALID` must be added to history and `evidence_valid=0`. Control remains faulted for its existing reasons; the experiment must not pretend recorder failure itself proves physical machine behavior.

### P4 — premature rearm

Assert `explicit_rearm=1` before successful reconciliation. It must not authorize motion or bypass RECONCILE.

### P5 — reconciliation, then second fault

With transport/watchdog/current feedback prerequisites restored, request reconciliation. Enter RECONCILE. Before completion, inject `required_interlocks_ok=0`; the arbiter must return to FAULTED immediately, retain all prior history, add `INTERLOCK_INVALID`, and clear any rearm attempt.

### P6 — successful reconciliation

Clear current faults, request reconciliation again, then supply independent feedback/reference revalidation and `reconcile_complete=1`. The state must become READY, not RUNNING. Motion remains unauthorized.

### P7 — explicit rearm and a new command

After P6, assert explicit rearm. The arbiter may become armed/READY but must not run until a **new** run request. A fresh run request may then enter RUNNING if all prerequisites remain valid.

### P8 — feedback agreement without independent revalidation

From a fresh fault episode, represent feedback values as internally valid/agreed but set `feedback_independent_or_revalidated=0`. Even with green transport and clear watchdog, reconciliation must not complete to a motion-ready condition solely from channel agreement.

### P9 — recorder-only degradation

From RUNNING with otherwise valid control prerequisites, set only `recorder_valid=0`. The contract must set `evidence_valid=0` and latch `RECORDER_INVALID` but must **not** invent a motion revocation unless some explicit control prerequisite also fails. This prevents conflating logging integrity with machine authorization.

## Frozen Gates A–J

- **A — nominal authority:** P0 reaches RUNNING only after valid prerequisites + rearm + run request.
- **B — same-invocation revocation:** P1 transport loss makes `motion_authorized=0` on the same retained invocation.
- **C — non-destructive compound history:** after P1/P3, history includes TRANSPORT_INVALID, FOLLOWING_ERROR and RECORDER_INVALID; none is erased by transport recovery.
- **D — layer separation:** P2 never reauthorizes from transport recovery while watchdog/revalidation/reference remain invalid.
- **E — evidence separation:** P3/P9 make `evidence_valid=0`; P9 alone does not invent a control-authority fault.
- **F — no premature rearm:** P4 cannot leave FAULTED/authorize motion.
- **G — reconciliation is interruptible:** P5 second fault returns RECONCILE -> FAULTED and adds INTERLOCK_INVALID.
- **H — no stale auto-resume:** P6 ends READY + unauthorized; no pre-fault run ownership survives.
- **I — explicit new authority:** only post-reconciliation explicit rearm plus a new run request can return P7 to RUNNING.
- **J — common-cause boundary:** P8 cannot authorize/reconcile merely because channels internally agree; independent revalidation remains required.

All ten gates must pass unchanged for F02-001 to be accepted.

## Predeclared prediction

The frozen prediction from the source/community pass is adopted unchanged: compound transport/following-error/recorder observations will remain separately retained; control authority will revoke on invalid control prerequisites; recorder integrity will independently gate evidentiary claims; transport recovery alone will not restore authorization; and a stale command will never resume without reconciliation, explicit rearm and a fresh run request.

## Rejection conditions

The run is **HARNESS INVALID** rather than behavioral FAIL if:

- invocation sequence is not strictly monotonic/complete;
- any input/output required above is absent from retained rows;
- test-case state leaks unintentionally between cases except where P1–P7 intentionally form one episode;
- gate logic is changed after observing a result;
- history is reconstructed after execution rather than retained by the arbiter.

A behavioral gate failure after a valid harness is a genuine F02 correction trigger.

## Evidence boundary

Passing F02-001 can validate only the deterministic policy contract implemented in the harness and its consistency with source-confirmed prerequisite boundaries. It cannot establish physical stopping time/distance, functional-safety performance, Ethernet reliability, actual encoder independence, machine-specific reconciliation, or causal root truth for a real compound fault.
