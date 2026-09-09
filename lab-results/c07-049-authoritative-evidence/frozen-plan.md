# C07-047 — Request vs Achieved-State Sequencing Experiment — FROZEN PLAN

Status: **FROZEN BEFORE IMPLEMENTATION / OUTPUT INSPECTION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective
Demonstrate, in a deterministic software-only LinuxCNC simulation, that a capstone state machine must advance on **observed achieved state**, not on its own request edge. Exercise a deliberately blocked machine-on transition, successful retry after the prerequisite is restored, active-state interruption, and guarded recovery requiring a fresh explicit restart authorization.

This experiment is about ordinary LinuxCNC state integrity. It is not a functional-safety test.

## Source-grounded seam
Pinned source establishes:

1. HALUI command inputs such as `halui.machine.on` are rising-edge-triggered request surfaces.
2. `sendMachineOn()` sends `EMC_TASK_SET_STATE(ON)` through NML.
3. Task `emcTaskSetState(ON)` calls `emcTrajEnable()`.
4. `emcTrajEnable()` sends `EMCMOT_ENABLE` to realtime motion.
5. Realtime `command.c` rejects the enable when `motion.enable=false`, reporting `can't enable motion, enable input is false`; it sets the internal enabling request only when that HAL input is true.
6. The servo controller later sets the actual `EMCMOT_MOTION_ENABLE_BIT` on successful enable.
7. Task-side trajectory status is enabled only from that returned motion flag, and HALUI publishes `halui.machine.is-on` from derived Task state.

Therefore `motion.enable` is the frozen blocked-transition injection seam.

## Harness constraints
- Use an existing LinuxCNC simulation configuration at the pinned revision; do not modify production Task/Motion/HALUI source.
- Harness changes must be limited to test configuration/HAL wiring, an optional test-only sequencer component, observation script, and result analyzer.
- Preserve source SHA/provenance in artifacts.
- `motion.enable` must be directly controllable in the lab topology. If the selected sim already nets it to another writer, redesign the **preflight topology** before the authoritative run; do not force multiple writers or alter production source.
- Use `halui.machine.on` only as a request edge: drive 0 -> 1 -> 0 for each request.
- The sequencer must have a separate `start_authorize`/equivalent input so recovery cannot silently reuse pre-fault authorization.
- Prefer one ordered sampler/trace for decisive state evidence. If userspace NML/status timing prevents one realtime stream from containing every signal, retain a timestamped merged trace and prove monotonic ordering before scoring.

## Frozen phases

### P0 — Baseline reset/off
Prerequisites established for a normal out-of-estop but machine-not-on state. `motion.enable=true`; request pins low; sequencer not authorized to run. Verify `halui.machine.is-on=false` before starting the blocked-transition case.

### P1 — Block the prerequisite
Drive `motion.enable=false` while machine remains off. No machine-on request yet. Sequencer state must remain `WAIT_START`/equivalent.

### P2 — Issue machine-on request while blocked
Provide a fresh `start_authorize` and emit exactly one rising edge on `halui.machine.on`, then return the request low. The sequencer may record `ON_REQUESTED`/`WAIT_ON`, but **must not enter READY/RUNNING solely from the request**.

Expected source-grounded outcome: realtime motion rejects `EMCMOT_ENABLE`; `halui.machine.is-on` remains false.

### P3 — Hold blocked
Leave `motion.enable=false` for a bounded observation interval. No second request edge. The sequencer must remain waiting; holding prior authorization or request history must not cause state advancement or hidden retries.

### P4 — Restore prerequisite, still no retry
Set `motion.enable=true` but do not issue a new `halui.machine.on` rising edge. Because HALUI request semantics are edge-triggered and the first request was already consumed, the machine should remain not-on until a new request is emitted. The sequencer must not infer success merely because the prerequisite became true.

### P5 — Explicit retry
Emit a new fresh machine-on rising edge after the request pin was returned low. Wait for observed `halui.machine.is-on=true`. Only after that status appears may the sequencer advance to the next readiness state.

If homing is required by the chosen sim policy, do not label READY until the required homed status is also actually observed. If homing is deliberately excluded from this first experiment, label the post-ON state `ON_CONFIRMED` rather than overclaiming READY.

### P6 — Active-state fault interruption
While ON is confirmed, drive `motion.enable=false`. Expected realtime behavior: fault checking revokes `emcmotInternal->enabling`; motion enable flag clears; derived Task/HALUI machine-on status falls. The sequencer must revoke cycle permission and enter a fault/recovery state rather than retaining its pre-fault ON/READY state.

### P7 — Fault input restored but no restart authorization
Return `motion.enable=true`. Clear only software-visible states actually required by the chosen simulation, but do **not** provide a new `start_authorize` and do not emit a new machine-on request. The sequencer must remain recovery/not-running.

### P8 — Fresh recovery authorization and request
Provide a new explicit start/recovery authorization, emit a fresh machine-on rising edge, wait for observed `halui.machine.is-on=true`, and only then allow the sequencer to return to its post-ON state.

## Frozen prediction

At the pinned revision:

```text
request emitted while motion.enable=false
    -> no achieved machine ON

motion.enable later becomes true without a new HALUI rising edge
    -> still no achieved machine ON

fresh machine.on rising edge with motion.enable=true
    -> achieved machine ON may follow; sequencer advances only after status

motion.enable false while ON
    -> achieved ON revoked
    -> sequencer revokes run permission

fault input restoration alone
    -> no automatic pre-fault resume

fresh explicit authorization + fresh request + achieved-state confirmation
    -> guarded recovery permitted
```

## Frozen gates

### Gate A — Provenance/topology
PASS only if pinned SHA is recorded, production Task/Motion/HALUI files remain unmodified, exact test HAL/config is retained, and there is exactly one valid writer/topology for the injected `motion.enable` signal.

### Gate B — Observation integrity
PASS only if phase/state/request/status observations are ordered and retained with no unexplained gaps that can hide decisive transitions.

### Gate C — Baseline
P0 shows out-of-estop machine-off baseline and no spurious request/ON status.

### Gate D — Blocked request proves request != achieved state
During P2/P3 there is exactly one machine-on rising-edge request while `motion.enable=false`; `halui.machine.is-on` remains false; sequencer never advances to confirmed-on/ready/running.

### Gate E — Restoring prerequisite is not implicit retry
During P4 `motion.enable=true` but no new machine-on rising edge occurs; achieved machine-on remains false and sequencer remains waiting.

### Gate F — Explicit retry waits for achieved state
During P5 a fresh machine-on rising edge occurs; sequencer remains waiting until `halui.machine.is-on=true`, then advances. Any state advance preceding achieved status is FAIL/HARNESS INVALID depending on cause.

### Gate G — Active fault interrupts state
During P6 loss of `motion.enable` leads to loss of achieved machine-on and the sequencer revokes active permission/enters recovery. It must not remain logically READY/RUNNING after the status loss.

### Gate H — No automatic restart
During P7 restoration of `motion.enable` without fresh authorization/request does not restore active sequencer state.

### Gate I — Guarded explicit recovery
During P8 only a fresh authorization + fresh request + achieved `machine.is-on` confirmation allows return to post-ON state.

### Gate J — Safety-language boundary
Analyzer/report must not equate the demonstrated sequencing with functional safety and must state that real-machine restart needs physical state/energy/interlock verification outside this fixture.

## Harness-invalid conditions
- HALUI or Task/Motion production source modified to force the expected result.
- `motion.enable` has conflicting/multiple writers not accounted for.
- phase label is published after the mutation it is supposed to identify.
- request edge is not observable or is accidentally repeated.
- decisive status samples are missing/ambiguous.
- sequencer advances from its own output/request variable rather than status, making the test tautological.
- analyzer/gates changed after authoritative output is inspected.

## Preflight rule
Before an authoritative C07-047 run, a non-authoritative preflight must prove the selected sim can:

1. start HALUI and expose the named request/status pins;
2. make `motion.enable` controllable with a single valid writer;
3. demonstrate the blocked P2/P3 topology without scoring the full experiment;
4. capture the required ordered observables;
5. preserve production source hashes.

Only after that preflight passes may one authoritative run use these unchanged phase semantics and Gates A–J.

## What this experiment will and will not prove

If Gates A–J pass, C07 gains independent evidence that request edges and achieved state must be separated, that an actual realtime prerequisite can block a Task ON request, that active state can be revoked by a realtime fault input, and that explicit guarded recovery avoids automatic pre-fault resume in the tested sequencer.

It will **not** prove external E-stop relay behavior, actual drive/valve state, true physical position, safe stored-energy state, or compliance with any functional-safety standard.
