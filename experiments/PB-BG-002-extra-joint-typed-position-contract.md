# PB-BG-002 — extra-joint typed-position planner/ownership contract

Status: **FROZEN BEFORE EXECUTION**
Date frozen: 2026-09-11
Course context: 3600 press-brake preparation; F02 remains blocked on fresh-AI prerequisite handoffs.
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Evidence basis

PB-BG-001 already established mutually exclusive operator ownership, authorization-loss revocation, no automatic replay after a fault, and explicit reconciliation.

New source/community evidence establishes a more press-brake-specific target architecture:

- LinuxCNC extra joints home normally, then accept independent post-home position commands through `joint.N.posthome-cmd`;
- pinned `control.c` routes an extra joint's `posthome_cmd + motor_offset` directly to `joint.N.motor-pos-cmd` only after that joint is homed;
- LinuxCNC documentation recommends an independent planner/controller, typically `limit3`, for extra-joint post-home commands;
- the public Ursviken Pullmax retrofit chose six extra joints for its real mechanisms and documented a UI -> `limit3` -> `posthome-cmd` -> `motor-pos-cmd` -> PID/encoder path for a backgauge joint;
- `limit3` bounds position, velocity and acceleration, but its `load` input can deliberately bypass velocity/acceleration limiting and therefore must not be treated as a normal motion request mechanism.

## Purpose

Test the first-stage typed-position contract for an **extra-joint backgauge** without adding motor, brake, collision, hydraulic or structural physics.

The experiment asks whether a target owner and bounded planner can preserve:

- pre-home command isolation;
- post-home absolute target semantics;
- configured range limiting;
- bounded planner progress;
- completion as target + feedback convergence rather than command-copy acknowledgement;
- immediate logical revocation on authorization/feedback/drive/stall faults;
- stale-target non-replay through reconciliation;
- deliberate separation of normal planner motion from `limit3.load`/teleport-style behavior.

This is ordinary machine-control software evidence only, not functional-safety evidence.

## Frozen logical model

States/owners:

- `UNREFERENCED`
- `IDLE_REFERENCED`
- `TYPED_MOVE`
- `FAULTED`
- `RECONCILE`

Inputs/witnesses:

- `homed`
- `machine_authorized`
- `feedback_valid`
- `drive_ok`
- `stall_suspect`
- `typed_request`
- `typed_target`
- configured `min_target`
- configured `max_target`
- bounded planner output
- independent feedback position
- abstract `within_target_tolerance`
- `planner_at_target`
- `normal_planner_enabled`
- `load_bypass_requested`
- monotonically increasing invocation counter

Outputs/witnesses:

- `owner`
- `target_accepted`
- `posthome_command_effective`
- `planner_motion_active`
- `typed_move_complete`
- `fault_reason`
- `reconcile_required`
- `stale_target_replayed`
- `load_bypass_used`

No numeric velocity, acceleration, tolerance or stall thresholds are frozen here. Those are configuration/commissioning quantities, not generic curriculum truths.

## Frozen rules

1. A typed target may be stored/displayed before homing, but it may **not become an effective post-home motion command** while `homed=false`.
2. `TYPED_MOVE` may acquire ownership only when `homed && machine_authorized && feedback_valid && drive_ok` and the target lies within `[min_target,max_target]`.
3. Normal typed movement uses the bounded planner. `load_bypass_used` must remain false during every ordinary move.
4. Planner output may approach the target over multiple invocations; copying a target into planner input is not completion.
5. `typed_move_complete` requires `planner_at_target && within_target_tolerance && feedback_valid && drive_ok && machine_authorized`, with no fault/revocation episode active.
6. Loss of authorization, feedback validity or drive health, or assertion of `stall_suspect`, while `TYPED_MOVE` owns the axis drops ownership and enters `FAULTED` in that invocation.
7. A fault may not transition directly back to `TYPED_MOVE`. It must pass through `RECONCILE`.
8. A target interrupted by fault is no longer an executable request. After reconciliation a **new** typed request is required even if the numeric input field still shows the old number.
9. If homing/reference validity is lost during fault/reconciliation, recovery ends `UNREFERENCED` and typed positioning remains unavailable.
10. Targets below/above configured range are rejected, not silently accepted as completed requests. The planner's own min/max limiting remains a downstream bound but is not the UI's validation substitute.
11. `load_bypass_requested` during an ordinary typed move is rejected/test-failed. The experiment must not use `limit3.load` as a shortcut to satisfy target-completion gates.
12. Completion and fault witnesses must remain distinct: planner convergence alone is not feedback truth; feedback convergence alone is not authorization; drive health alone is not reference validity.

## Frozen phases

### P0 — pre-home isolation

- Begin unreferenced with a valid in-range numeric target present.
- Issue a typed request.
- Require no effective post-home command and no typed owner.
- Establish `homed=true` through an explicit abstract home-complete event.
- Require that the previously rejected request does **not** automatically start merely because homing became true.

### P1 — normal typed target and bounded progress

- From referenced idle, issue a new in-range typed request.
- Acquire `TYPED_MOVE` as sole owner.
- Advance planner output over multiple invocations before it reaches the target.
- Require `typed_move_complete=false` during approach.
- Converge planner and valid feedback; then and only then assert completion and return to referenced idle.
- `load_bypass_used` remains false.

### P2 — range adversaries

Test one target below `min_target` and one above `max_target`.

- Neither acquires ownership.
- Neither becomes an effective post-home command.
- A later valid target requires its own new request.

### P3 — authorization loss during approach

- Begin a normal typed move and leave planner/feedback short of target.
- Drop `machine_authorized`.
- Require owner/motion-request revocation and `FAULTED` in that invocation.
- Restore authorization without issuing a new target request.
- Require no replay.
- Reconcile explicitly, then remain idle until a new request.

### P4 — feedback, drive and stall fault separation

Run independent mid-move cases for:

- `feedback_valid=false`
- `drive_ok=false`
- `stall_suspect=true`

Each must revoke ownership and preserve a distinguishable fault reason. No case may infer the physical cause of `stall_suspect`.

### P5 — false completion adversaries

Reject completion in each case:

1. planner at target but feedback not within tolerance;
2. feedback appears within tolerance while planner still active/not at target;
3. planner + feedback at target but authorization false;
4. planner + feedback at target but drive faulted;
5. planner + feedback at target but feedback validity false.

### P6 — reference loss through recovery

- Fault a typed move.
- Clear health faults but set `homed=false` before reconciliation completes.
- Require recovery to `UNREFERENCED`.
- Ensure the old numeric target does not become effective after a later home unless a new typed request is issued.

### P7 — `limit3.load` bypass trap

- Assert an ordinary typed request with `load_bypass_requested=true`.
- The harness must reject the bypass or classify the request invalid; it may not count an instantaneous planner-output jump as a normal successful move.

This phase exists because LinuxCNC documents `limit3.load` as immediately setting output to input while ignoring max velocity and acceleration.

## Frozen gates A–J

A. No typed motion becomes effective while unhomed.
B. Homing alone never replays a pre-home typed request.
C. Only an in-range new request can acquire `TYPED_MOVE` ownership.
D. Normal planner progress is multi-invocation/bounded in the test; completion is not target-copy acknowledgement.
E. Completion requires both planner convergence and valid feedback convergence plus healthy authorization/drive state.
F. Authorization loss revokes an active typed move and the stale target does not replay after authorization returns.
G. Feedback, drive and stall-suspect faults remain distinguishable and all require reconciliation.
H. Reference loss during recovery returns the state to `UNREFERENCED` and prevents stale-target replay.
I. Range adversaries never acquire ownership or become effective post-home commands.
J. `load_bypass_used == false` for all ordinary typed-move rows; the load-bypass trap cannot earn a successful completion.

All A–J must pass unchanged for PB-BG-002 to be TEST-CONFIRMED.

## Evidence retention

Retain one invocation-level atomic CSV/table with every input, state/owner, target, planner output, feedback/completion witness, fault reason, range result, post-home-effective witness, stale-target witness and load-bypass witness needed to score A–J.

A deterministic in-process table is preferred. If asynchronous LinuxCNC sampling is introduced, X01 recorder-integrity rules apply before any absence/same-cycle claim may be scored.

## Adversarial interpretation boundary

A passing PB-BG-002 would not establish:

- real stopping distance/time;
- correct servo gains;
- safe speed/acceleration;
- encoder mechanical integrity;
- brake timing;
- hard-stop survivability;
- Z1/Z2 collision avoidance;
- safe homing geometry;
- numeric stall thresholds;
- functional-safety performance.

## Exact execution checkpoint

Implement the smallest deterministic PB-BG-002 harness that exercises P0-P7 and emits the atomic evidence required for frozen Gates A-J. Use normalized abstract planner increments solely to prove sequencing; do not treat their numeric values as machine recommendations. Do **not** add a motor simulation unless execution exposes a LinuxCNC-specific question that cannot be resolved from source/docs.
