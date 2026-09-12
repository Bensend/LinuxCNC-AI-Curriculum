# PB-BG-003 — Backgauge command-episode identity and atomic `at_position`

Date frozen: 2026-09-12
Course context: dependency-safe 3600 press-brake preparation while F02 fresh-AI transfer remains information-separated
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`
Status: **FROZEN BEFORE IMPLEMENTATION**

## Question

Can a small deterministic ordinary-control state contract prevent stale or ambiguous backgauge completion from being accepted when LinuxCNC exposes the numeric extra-joint target/state witnesses but no native generation ID for `joint.N.posthome-cmd`?

The source prerequisite is `research/press-brake-backgauge-at-position-witness-source-trace-2026-09-12.md`. It establishes that LinuxCNC exposes `homed`, planner/activity, command/feedback, following-error and fault witnesses, but does not attach an episode/generation token to `posthome-cmd`.

## Scope boundary

This is **not** a motor, hydraulic, encoder, network, or safety simulation. It tests only application-owned episode/state semantics around a source-grounded witness interface. Numeric tolerance and settle values are represented as boolean witnesses supplied by a hypothetical commissioned lower layer.

No result from this experiment may establish physical encoder truth, stopping distance, switch repeatability, drive diagnostic coverage, or functional-safety performance.

## Predeclared prediction

A completion predicate that requires both current-state health and a valid application-owned episode will:

1. assert completion for a newly authorized episode only after reference, planner-complete, position-agreement and fault-clear witnesses are all true;
2. revoke completion immediately when authority/reference/fault validity is lost;
3. prevent a same-numeric-target reissue from inheriting completion from the prior episode;
4. prevent reference regain or transient-fault clearing from resurrecting a pre-invalidation episode;
5. require explicit reconciliation/new authorization before completion can become true again.

## Model inputs

Each invocation supplies:

- `authorize_new_target` — application authorizes a new target request;
- `target` — numeric target value (used only to demonstrate same-value ambiguity);
- `homed` — source-grounded reference-validity witness;
- `planner_complete` — bounded planner/activity completion witness;
- `position_agrees` — commissioned command/feedback/tolerance witness;
- `motion_authorized` — ordinary machine-control authority witness;
- `drive_ok` — application/drive diagnostic witness;
- `feedback_ok` — application feedback-validity/stall-supervision witness;
- `joint_fault_clear` — aggregate LinuxCNC joint error/ferror/fault/limit-clear witness;
- `reconcile` — explicit reconciliation action after an invalidation.

## State

Application-owned state is:

- monotonically increasing `episode_counter`;
- `active_episode` and `active_target`;
- `episode_valid` latch;
- `reconcile_required` latch;
- `last_completed_episode` diagnostic witness.

A new authorization increments `episode_counter`, replaces the active target/episode and clears prior completion identity. Authorization is accepted only when the ordinary validity prerequisites are true and reconciliation is not required.

Any loss of `homed`, `motion_authorized`, `drive_ok`, `feedback_ok`, or `joint_fault_clear` invalidates the active episode and latches `reconcile_required`. Clearing the raw fault does not clear this latch. Explicit `reconcile` may clear the latch only when all validity prerequisites are healthy; it does not resurrect the invalidated episode. A subsequent new authorization is required.

`at_position` is true only when all current validity witnesses are healthy, `episode_valid` is true, reconciliation is not required, planner completion and position agreement are true, and the completion identity equals the current active episode.

## Frozen phases

### P0 — nominal new episode
Authorize target `10.0` as episode 1. Before planner completion, `at_position=0`. Once planner-complete and position-agreement are true, `at_position=1` for episode 1.

### P1 — same numeric target reissue
Authorize target `10.0` again. Episode must advance to 2 and prior completion must not carry forward. `at_position` must return to 0 until episode 2 receives fresh planner-complete + position-agreement witnesses, then return to 1.

### P2 — reference loss and raw regain
While episode 2 is complete, drop `homed`. Episode 2 must become invalid, `at_position=0`, and reconciliation must latch. Restoring `homed` alone must not restore completion.

### P3 — reconcile then new authorization
With all raw validity witnesses healthy, explicit reconciliation clears the reconciliation latch but does not make episode 2 valid again. Authorize target `12.0`; it becomes episode 3. Completion may assert only after fresh planner-complete + position-agreement witnesses.

### P4 — drive fault after completion
Drop `drive_ok` after episode 3 completion. Completion must revoke and reconciliation latch. Restoring `drive_ok` alone must not restore the episode.

### P5 — transient invalidation invisible to a slower observer
After P4 reconciliation and a fresh episode 4 target `14.0` completes, inject `feedback_ok=0` for one invocation, then restore it. The later healthy snapshot must still show `episode_valid=0`, `reconcile_required=1`, `at_position=0`; transient loss cannot be erased by current health.

### P6 — LinuxCNC joint fault path
Reconcile, authorize episode 5 target `16.0`, complete it, then drop `joint_fault_clear`. Completion must revoke and latch reconciliation. Raw fault clearing alone must not restore episode 5.

### P7 — ordinary authorization loss
Reconcile, authorize episode 6 target `18.0`, complete it, then drop `motion_authorized`. Completion must revoke and latch reconciliation. Raw authorization regain alone must not resurrect episode 6.

## Frozen Gates A–J

A. Retained invocation sequence is strictly monotonic and complete for the emitted rows.

B. P0 asserts `at_position` only after planner completion + position agreement for valid episode 1.

C. P1 same-target reissue advances episode `1 -> 2` and immediately clears `at_position` despite unchanged numeric target.

D. P1 can reassert completion only for episode 2 after fresh completion witnesses.

E. P2 homed loss invalidates episode 2 and latches reconciliation; homed regain alone leaves `at_position=0`.

F. P3 reconciliation alone does not resurrect episode 2; a fresh authorization creates episode 3 before completion can reassert.

G. P4 drive fault revokes completion and raw drive recovery alone cannot restore the invalidated episode.

H. P5 one-invocation feedback invalidation remains visible through latched episode invalidation after the raw feedback witness becomes healthy again.

I. P6 LinuxCNC joint-fault witness and P7 ordinary authorization loss each revoke completion and require reconciliation/new authorization rather than auto-resume.

J. Every row with `at_position=1` has: `episode_valid=1`, `reconcile_required=0`, `homed=1`, `motion_authorized=1`, `drive_ok=1`, `feedback_ok=1`, `joint_fault_clear=1`, `planner_complete=1`, `position_agrees=1`, and `completed_episode == active_episode`.

Any failed frozen gate is a substantive FAIL unless a concrete harness/provenance defect is identified. Do not alter phase semantics or thresholds after observing results merely to obtain PASS.

## Required retained evidence

- complete invocation-level CSV containing all inputs, state and outputs;
- machine-readable summary with Gates A–J and the predeclared prediction result;
- explicit claims boundary.

## Decision rule

PASS supports only the bounded conclusion that an application-owned episode latch can prevent the enumerated stale-completion/replay errors in this deterministic ordinary-control contract. It does not prove the physical witnesses are truthful or timely.
