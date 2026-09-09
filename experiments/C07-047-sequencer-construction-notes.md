# C07-047 — Test-Only Sequencer Construction Notes

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **DESIGN NOTES ONLY — implementation remains blocked on the non-authoritative preflight**

These notes translate the already-frozen C07-047 phase/gate plan into a minimal test-only sequencer without modifying the frozen prediction, phases, or Gates A–J.

## Required external inputs

The test sequencer should consume status rather than invent it:

- `start_authorize` — lab-only explicit authorization edge/level, separate from LinuxCNC status.
- `machine_is_on` — sourced from `halui.machine.is-on`.
- `estop_is_activated` — sourced from `halui.estop.is-activated`.
- optional `all_required_homed` — only if the chosen first experiment includes homing; otherwise the post-ON state must be named `ON_CONFIRMED`, not READY.
- fault/readiness input for experiment injection — `motion.enable` is controlled by the harness, but the sequencer should preferably react to loss of achieved `machine_is_on`, not merely mirror the injected cause. This preserves the distinction between cause injection and achieved-state observation.

## Required outputs

- `machine_on_request` -> `halui.machine.on`.
- optional `machine_off_request` for deterministic cleanup, not as a substitute for observing status.
- `cycle_permission` or equivalent lab-only state output proving whether active continuation is allowed.
- numeric `state_id` and `phase_id` outputs for ordered evidence.

## Minimal state model

Suggested IDs are predeclared here for deterministic observation but are not frozen gates by themselves:

```text
0 = INIT
1 = WAIT_START
2 = ON_REQUEST_PULSE
3 = WAIT_ON_CONFIRM
4 = ON_CONFIRMED
5 = RECOVERY_REQUIRED
6 = RECOVERY_WAIT_START
```

### INIT -> WAIT_START
Transition only after the lab establishes out-of-estop, machine-off baseline. `cycle_permission=0`.

### WAIT_START -> ON_REQUEST_PULSE
Requires a **fresh** `start_authorize`. The sequencer must not latch a start forever through later faults. Capture/consume the authorization as part of this transition.

### ON_REQUEST_PULSE -> WAIT_ON_CONFIRM
Raise `machine_on_request` for exactly one sequencer update interval or otherwise guarantee a clean 0->1->0 HALUI edge. Drop it before waiting. Do not enter `ON_CONFIRMED` from the request itself.

### WAIT_ON_CONFIRM -> ON_CONFIRMED
Only if `machine_is_on=true` is observed. If the blocked preflight confirms `motion.enable=false` prevents achieved ON, this state should remain stable indefinitely during P2/P3 and after P4 prerequisite restoration until a new request is emitted.

The frozen P4 no-implicit-retry behavior requires an experiment/harness action that gives the sequencer permission to emit a **new** request only in P5. Therefore the sequencer should not internally retry on a timer during P3/P4.

### ON_CONFIRMED -> RECOVERY_REQUIRED
If `machine_is_on` becomes false, revoke `cycle_permission` in the same sequencer evaluation and enter recovery. The state machine must not rely on remembering that it previously requested ON.

### RECOVERY_REQUIRED -> RECOVERY_WAIT_START
May occur after the injected fault input is removed / LinuxCNC is again eligible to enable, but `cycle_permission` remains false and any previous `start_authorize` is considered consumed.

### RECOVERY_WAIT_START -> ON_REQUEST_PULSE
Requires a **fresh post-fault** authorization. This is the mechanism tested by P7/P8: restoration of `motion.enable` alone cannot return to the active state.

## No-auto-retry invariant

The first C07 experiment should deliberately avoid automatic machine-on retry. A retry timer would blur two mechanisms:

1. HALUI's pinned rising-edge command contract; and
2. the capstone policy choice about whether/when to retry.

For 1000-level evidence, the clearer rule is:

```text
one authorization -> one request edge -> wait for achieved state
failed/blocked attempt -> no hidden retry
recovery -> fresh authorization required
```

A higher-level module may later compare bounded automatic retry policies if justified.

## Observation design

Decisive evidence should make ordering explicit for:

- phase ID;
- sequencer state ID;
- `start_authorize`;
- `machine_on_request`;
- `motion.enable` injection;
- `motion.motion-enabled` if available as a realtime intermediate;
- `halui.machine.is-on` achieved Task status;
- `cycle_permission`.

HALUI is userspace, so a pure realtime `sampler` cannot necessarily sample all fields directly in one servo-thread stream. Two acceptable designs remain open pending preflight:

1. a timestamped userspace observer with one process sampling all relevant HAL objects at a rate well above Task/HALUI update intervals, with monotonic timestamps and transition-order checks; or
2. split realtime/userspace traces joined only if a synchronization marker proves ordering well enough for Gates D–I.

Do not reuse C06's realtime sampler merely for familiarity if it cannot observe HALUI userspace outputs atomically.

## Phase-publication rule carried forward

For each P0–P8 mutation, publish/record the phase label before the mutation it is intended to identify. C06 showed why this matters: a source mutation preceding its observable phase label can contaminate phase scoring even when the behavior is otherwise correct.

## Preflight-to-authoritative integrity

Before the authoritative run:

- retain the exact selected INI/HAL modifications;
- retain production-source hashes;
- prove `motion.enable` has one controllable writer;
- prove HALUI request/status objects are real, not inferred from `halcmd show` exit status alone;
- prove the blocked request and no-implicit-retry topology;
- then implement the sequencer once against the frozen state policy above.

If the preflight falsifies the assumed topology, redesign the topology while leaving the frozen **behavioral question** and Gates A–J unchanged unless source evidence demonstrates the experiment itself is invalid. Any necessary gate change must be a new experiment version, never a post-result edit.

## Safety boundary

`cycle_permission` here is a lab policy bit, not a safety-rated output. Its purpose is to test restart/state-integrity logic only. A real machine needs independently engineered E-stop/energy-removal, physical-state validation, and restart interlocks.
