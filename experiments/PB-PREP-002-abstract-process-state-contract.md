# PB-PREP-002 — abstract process-state ownership experiment contract

Date frozen: 2026-09-11
Status: **FROZEN DESIGN ONLY — simulation/software semantics, not deployable machine control**

## Objective

Test whether a small nonblocking state machine can preserve clear ownership of ordinary authorization, completion evidence, timeout handling, diagnostic classification, and reset/reconciliation.

This experiment deliberately excludes physical-machine dynamics. It does not model hydraulic valves, cylinders, pressure, forces, stopping distances, safeguarding, or safety-rated behavior.

## Abstract layers

1. process-state owner;
2. ordinary authorization gate;
3. abstract requested mode;
4. abstract final-authorized mode;
5. symbolic completion witness;
6. fault/timeout/reconciliation state;
7. retained diagnostic reason.

## Abstract states

- `IDLE`
- `PROCESS_A`
- `PROCESS_B`
- `HOLD`
- `PROCESS_C`
- `RETURN`
- `FAULT`
- `RECONCILE`

The labels intentionally avoid implying any real actuator behavior.

## Inputs

- `cycle_enable`
- `ordinary_authorized`
- `coordination_ok`
- `feedback_valid`
- `io_valid`
- `completion_witness`
- `intermediate_following_witness`
- `reset_request`
- `fperiod`

## Outputs / diagnostics

- `requested_mode`
- `final_authorized_mode`
- `state`
- `state_elapsed`
- `fault_latched`
- `fault_reason`
- `completion_seen`
- `last_good_state`

`requested_mode` and `final_authorized_mode` remain separate so the experiment can prove that intent is not the same as authorization or completion.

## Frozen rules

### R1 — live ordinary authorization

Every active state reevaluates ordinary authorization and validity inputs every invocation. Loss of a required predicate cannot be ignored until the state finishes.

### R2 — command is not completion

Changing an abstract command does not complete a state. A state transition that represents physical/process completion requires `completion_witness`.

### R3 — timeout includes a response

Bounded states accumulate `state_elapsed += fperiod`. Expiry without completion must cause an explicit transition to `FAULT`; a timer flag alone does not pass.

### R4 — diagnostic causes stay distinct

Loss of an intermediate-following witness, loss of coordination, loss of I/O validity, and ordinary process timeout must produce distinguishable diagnostic reasons.

### R5 — reset does not blind-resume

After prerequisites recover, reset may move `FAULT -> RECONCILE`. It must not jump directly back into the interrupted active state.

### R6 — safety boundary

A passing result proves only ordinary software-state semantics. It must not be described as a safety function or machine commissioning evidence.

## Frozen phases

### P0 — nominal sequence

With all validity inputs true, provide completion witnesses so the state machine traverses:

`IDLE -> PROCESS_A -> PROCESS_B -> HOLD -> PROCESS_C -> RETURN -> IDLE`.

Expected: no fault; each completion transition uses a completion witness.

### P1 — authorization loss during PROCESS_C

Enter `PROCESS_C` with completion false, then set `ordinary_authorized = false`.

Expected: state enters `FAULT`, reason `AUTHORIZATION_LOST`; completion remains false.

### P2 — command issued but completion absent

Keep authorization and validity true while withholding completion through the frozen state timeout.

Expected: `FAULT`, reason `PROCESS_TIMEOUT`; trace must show command/authorization existed but completion was not observed.

### P3 — intermediate-following witness lost

During an active state, set `intermediate_following_witness = false`.

Expected: `FAULT`, reason `INTERMEDIATE_NOT_FOLLOWING`; do not relabel it as process timeout.

### P4 — coordination witness lost

During `PROCESS_B`, set `coordination_ok = false`.

Expected: fault before the slower semantic timeout, reason `COORDINATION_INVALID`.

### P5 — I/O validity lost

During `RETURN`, set `io_valid = false` while completion remains false.

Expected: `FAULT`, reason `IO_INVALID`; no inferred completion.

### P6 — reset and reconciliation

For each P1–P5 fault, restore required inputs and assert reset.

Expected: `FAULT -> RECONCILE`, never directly to the interrupted active state.

## Frozen gates

- **A:** P0 traverses the exact nominal sequence.
- **B:** no state completes solely because a command changed.
- **C:** P1 detects live authorization loss.
- **D:** P2 produces an explicit timeout state transition.
- **E:** P2/P3/P4/P5 retain distinct diagnostic causes.
- **F:** coordination loss is detected independently of the slower process timeout.
- **G:** reset never blind-resumes an interrupted active state.
- **H:** retain raw invocation-level state/input/output evidence.
- **I:** retain executable provenance, revision, invocation period, and phase boundaries.
- **J:** result text explicitly states the simulation-only ordinary-control boundary.

## Adversarial assertions

The analyzer must reject these conclusions:

- abstract command changed -> physical device movement proven;
- timeout -> a named hardware component failed;
- authorization loss -> stored physical energy is safe;
- servo-thread execution -> functional safety proven;
- reset -> interrupted process may automatically resume;
- common request -> multiple physical feedback channels necessarily agree.

## Implementation preference

Use a tiny deterministic software transition function or purpose-built HAL test component. Retain raw traces. Do not add a numeric physical plant unless a later evidence-backed question specifically requires one.

## Pre-execution prediction

A small deterministic state model should be sufficient to verify ownership, interruptibility, diagnostic separation, timeout response, and reset/reconciliation semantics. If implementation requires invented physical parameters, the experiment has exceeded its intended abstraction boundary and should be redesigned rather than tuned.

## Next checkpoint

Implement this contract unchanged only when PB-PREP-002 becomes the highest-priority unblocked experimental task. Any material post-result redesign becomes a separately numbered experiment with an explicit rationale.
