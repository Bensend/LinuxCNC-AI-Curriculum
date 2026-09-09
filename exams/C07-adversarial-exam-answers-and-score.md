# C07 — State-Machine Sequencing — Adversarial Exam Answers / Score

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Questions were frozen before authoritative C07-049 output inspection in `exams/C07-adversarial-exam-questions.md`. This is an internal module exam, not a blind external-feedback-bank challenge.

## A1 — Misleading premise: command means state

The statement is wrong. At the pinned revision, the `halui.machine.on` input is an edge-triggered **request** surface. HALUI detects the 0->1 change, `sendMachineOn()` sends `EMC_TASK_SET_STATE(ON)` through NML, Task dispatches `emcTaskSetState(ON)`, which calls `emcTrajEnable()`, and realtime Motion receives `EMCMOT_ENABLE`. That command may still be rejected: the pinned realtime command handler explicitly refuses enable when the actual `motion.enable` HAL input is false.

Even an accepted realtime command is not the same as Task/HALUI achieved state. The motion controller establishes `EMCMOT_MOTION_ENABLE_BIT`; Task-side trajectory status derives `enabled` from that returned motion flag; `determineState()` derives Task ON from achieved trajectory enable plus out-of-E-stop status; HALUI then publishes the received Task state as `halui.machine.is-on`.

Therefore the earliest evidence supporting the exam's logical `ON_CONFIRMED` state is the **returned achieved-state predicate chosen by the sequencer**, here observed `halui.machine.is-on=true` (plus any additional required readiness predicates if the application defines them). The sequencer must not set ready/cycle permission merely because it toggled its own command pin.

## A2 — Blocked enable and stale authorization

The first authorization causes one valid HALUI rising edge. HALUI consumes that edge and sends one Task state request. Realtime Motion rejects the enable because `motion.enable=false`; the request does not become a continuously retried desired-state level inside HALUI. When `motion.enable` later becomes true, the original `halui.machine.on` edge is history. With the request pin already returned low, no new 0->1 transition exists and HALUI has nothing new to send.

A robust 1000-level policy is therefore:

```text
one fresh authorization -> one fresh request edge -> wait for achieved status
blocked/failed request -> no hidden timer retry
recovery/retry -> consume old authorization and require a fresh authorization
```

This separates LinuxCNC request semantics from the higher-level policy decision of whether another attempt is permitted.

## A3 — Active-state interruption

With machine ON achieved, realtime `check_for_faults()` observes a false `motion.enable` and clears the internal enabling request. Controller state logic clears the actual motion-enable flag; Task-side status observes trajectory disabled; `determineState()` no longer derives ON; HALUI eventually publishes `halui.machine.is-on=false`.

The sequencer's logical transition out of `ON_CONFIRMED` should primarily key from its **achieved-state predicate**, not merely mirror the injected test cause. This preserves a clean architectural rule: many different causes can revoke the same achieved state, and the higher-level state variable should represent what LinuxCNC actually reports. A real design may additionally revoke permission immediately on a trusted fault input to reduce reaction latency, but it still must not treat cause restoration as proof that achieved ON returned.

C07-049 independently showed the tested sequencer revoking cycle permission and entering recovery in the same sequencer evaluation tick in which its observer saw achieved machine-ON become false.

## A4 — Abort / recovery state integrity

Pinned `emcTaskAbort()` does not preserve a pristine resumable copy of the previous execution intent. It clears pending Task command/interpreter list and execution state, paused/single-step state, line/command bookkeeping and related plan state, then resynchronizes/closes/resets planning as appropriate. OFF/ESTOP-style state transitions also perform motion/I/O/spindle abort/disable actions and synchronization.

Consequently, clearing the initiating fault input proves only that one prerequisite may again be eligible. It neither reconstructs invalidated Task/interpreter state nor grants permission to continue a hazardous physical cycle. The higher-level controller should consume pre-fault start authorization when entering recovery and require a fresh explicit recovery/start authorization after it re-observes all required logical/physical readiness predicates.

## A5 — Homing misconception / configuration sensitivity

The first half is false because OFF/ESTOP uses the `emcJointUnhome(-2)` path that applies to joints configured for **volatile home**; it is not a universal “unhome every joint” rule. Homing loss therefore depends on machine configuration and the relevant state transition.

The second half is also false. A LinuxCNC joint's returned `is-homed` state is controller state; it is not independent metrology proving that the mechanism remained at the assumed physical coordinate through an unobserved disturbance, drive de-energization, coupling slip, external force, encoder reset, or other machine-specific event. A sequencer should observe homing state rather than infer it from command history, while a real restart policy separately decides whether physical conditions require revalidation/re-homing.

## A6 — Minimal bounded implementation

A suitable minimal policy is:

```text
WAIT_START
  fresh start_authorize edge:
    consume authorization
    emit exactly one 0->1->0 halui.machine.on request
    -> WAIT_ON_CONFIRM

WAIT_ON_CONFIRM
  machine_is_on=true:
    -> ON_CONFIRMED
    cycle_permission=true
  otherwise:
    stay; no timer retry
  a separately authorized retry may emit one new request only after a fresh auth edge

ON_CONFIRMED
  machine_is_on=false:
    cycle_permission=false
    consume/clear any stale authorization
    -> RECOVERY_REQUIRED

RECOVERY_REQUIRED
  after prerequisites are again eligible:
    -> RECOVERY_WAIT_START
    cycle_permission remains false

RECOVERY_WAIT_START
  fresh post-fault start_authorize edge:
    consume authorization
    emit exactly one new halui.machine.on pulse
    -> WAIT_ON_CONFIRM
```

The request pulse is an output action, never the success predicate. `cycle_permission` can be true only while the required achieved-state/readiness predicate is observed. There is no hidden retry timer and no reuse of a pre-fault authorization.

## A7 — Version-sensitive reasoning

The current-master spot-check legitimately supports only a narrow statement: master `64efb28cd77a16b45ade81e576c784cdc574f40e` still uses the same HALUI `check_bit_changed()` pattern for machine-state request inputs, so the rising-edge request surface remains present there.

It does **not** prove that every intermediate Task/NML/Motion implementation, status derivation, polling latency, failure branch, homing behavior, or configuration interaction is identical to pinned `8bf460...`. Exact cross-version behavioral equivalence requires corresponding source comparison and, where consequential, execution at the other revision. C07's authoritative experiment therefore remains scoped to the pinned revision.

## A8 — Safety boundary

The software-only evidence establishes ordinary state-integrity behavior: the sequencer distinguishes request from returned achieved state, revokes its non-safety-rated cycle permission when achieved ON is lost, avoids implicit retry, and requires fresh authorization before logical recovery.

It does not establish safe automatic restart of a physical hydraulic/servo machine. Missing evidence includes external E-stop/safety circuit state, contactor/drive/valve/output-stage state, stored hydraulic/pneumatic/electrical/mechanical energy, independent physical position, tooling/workpiece state, guards/interlocks, actuator fault reset semantics, operator visibility/control, and the machine's required safety-standard risk reduction. Those require machine-specific engineering and, where applicable, safety-rated architecture independent of this ordinary LinuxCNC/HAL policy.

## Scoring

| Question | Score | Reason |
|---|---:|---|
| Q1 | 2/2 | Correctly traces HALUI -> NML -> Task -> Motion -> returned status and names a real rejection seam. |
| Q2 | 2/2 | Correctly explains one-edge consumption, no implicit retry, and fresh authorization policy. |
| Q3 | 2/2 | Traces active-state revocation and distinguishes cause input from achieved-state policy. |
| Q4 | 2/2 | Correctly identifies Task/interpreter invalidation/resynchronization and rejects stale authorization reuse. |
| Q5 | 2/2 | Preserves `volatile_home` configuration sensitivity and physical-position uncertainty. |
| Q6 | 2/2 | Provides a bounded implementable state machine with status-gated advancement, authorization consumption and no hidden retry. |
| Q7 | 2/2 | Properly bounds the current-master spot-check instead of overgeneralizing cross-version equivalence. |
| Q8 | 2/2 | Cleanly separates ordinary sequencing evidence from physical/functional-safety restart evidence. |

**Result: 16/16 = 10/10 — PASS.** No central mechanism correction was exposed by the frozen adversarial exam.

## Corrections / retrieval reinforcement

No factual correction is required. Preserve these retrieval cues prominently in C07 handoff material:

```text
request != achieved state
prerequisite restored != request retried
fault cleared != achieved state restored
achieved state restored != stale start authorization valid
Task/HAL logical recovery != physical safe restart
```
