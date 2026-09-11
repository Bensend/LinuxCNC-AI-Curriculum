# PB-BG-001 — backgauge operator-mode ownership and revocation experiment

Status: **FROZEN BEFORE EXECUTION**
Date frozen: 2026-09-11
Course context: 3600 press-brake preparation; F02 remains blocked by fresh-AI prerequisite handoffs.
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test the first-stage manual backgauge software contract without inventing motor, hydraulic, force, or machine-geometry physics. The experiment asks whether typed positioning, hold-to-jog, homing/reference validity, ordinary authorization loss, and recovery can be represented with explicit mutually exclusive ownership and fail-closed revocation.

This is an ordinary machine-control experiment, not a functional-safety test.

## Frozen architecture under test

The harness shall model these logical owners/states only:

- `UNREFERENCED`
- `HOMING`
- `IDLE_REFERENCED`
- `JOG_CONT_POS`
- `JOG_CONT_NEG`
- `TYPED_MOVE`
- `FAULTED`
- `RECONCILE`

Inputs/witnesses:

- `machine_authorized`
- `feedback_valid`
- `drive_ok`
- `reference_valid`
- `jog_press_pos`
- `jog_press_neg`
- `jog_release`
- `typed_request`
- `typed_target_valid`
- `home_request`
- `home_complete_witness`
- `jog_stop_request`
- `stall_suspect` (abstract discriminator only; do not model motor physics)
- monotonic invocation counter

Outputs/witnesses:

- `owner`
- `jog_active`
- `typed_move_active`
- `home_active`
- `motion_request_active`
- `fault_reason`
- `reconcile_required`
- `auto_resume_attempted` (must remain false)

## Frozen rules

1. No motion owner may start unless `machine_authorized && feedback_valid && drive_ok`.
2. `TYPED_MOVE` additionally requires `reference_valid && typed_target_valid`.
3. Homing is a separate owner. Jog or typed ownership may not coexist with homing.
4. A jog press produces one logical continuous-jog ownership transition. The harness must not model repeated target writes as the mechanism of continued jogging.
5. `jog_release` or `jog_stop_request` revokes active jog ownership.
6. Loss of `machine_authorized`, `feedback_valid`, or `drive_ok` while any motion owner is active immediately transitions to `FAULTED` and drops all motion-owner outputs in that invocation.
7. `stall_suspect` while a motion owner is active also transitions to `FAULTED`; it is only an abstract fault input representing an independently detected command-versus-motion mismatch.
8. A faulted state may not directly transition back to the interrupted owner when fault inputs clear. It must go through `RECONCILE`.
9. `RECONCILE` requires explicit evidence that current feedback/drive state is healthy. If reference validity was lost or cannot be established, typed positioning remains unavailable until homing/re-reference completes.
10. No stored jog press or typed target may automatically resume after authorization returns. `auto_resume_attempted` must remain false in every test.
11. Conflicting simultaneous operator owners (e.g. typed request while jog active, both jog directions, home request during typed move) must be rejected or routed to a deterministic non-motion/fault outcome; they must never produce two owners.
12. The experiment does not assign numeric velocities, accelerations, distances, servo effort, pressure, force, or safety timing.

## Frozen test phases

### P0 — baseline/reference gating

- Start unreferenced with healthy authorization/feedback/drive.
- Verify typed request is denied while unreferenced.
- Complete abstract homing through an explicit completion witness.
- Verify referenced idle state is reached only after that witness.

### P1 — ordinary hold-to-jog

- From referenced idle, assert positive jog press.
- Verify exactly one owner becomes `JOG_CONT_POS` and remains active without repeated command input.
- Assert release.
- Verify jog ownership drops and state returns to referenced idle.

### P2 — authorization loss before button release

- Start continuous negative jog.
- Drop `machine_authorized` while the jog press remains logically held and before release.
- Require same-invocation motion-owner drop and `FAULTED` transition.
- Restore authorization while press remains held.
- Require no automatic jog resume.
- Require reconciliation before a new operator command can acquire ownership.

### P3 — independent jog-stop revoke

- Start continuous positive jog.
- Assert `jog_stop_request` without a UI release.
- Require jog owner to drop and no replacement owner to appear.
- This phase corresponds to LinuxCNC's independent ordinary-control jog-stop concept; it does not claim safety rating.

### P4 — feedback/drive/stall fault separation

Run three separate cases while a motion owner is active:

1. `feedback_valid=false`
2. `drive_ok=false`
3. `stall_suspect=true`

Each must drop ownership and preserve a distinguishable fault reason. The harness must not infer which physical failure produced `stall_suspect`.

### P5 — typed-position ownership

- With valid reference and healthy authorization, present one valid typed target.
- Acquire `TYPED_MOVE` as the sole owner.
- Inject authorization loss before completion.
- Verify fault + reconcile and no automatic continuation of the old typed target after authorization returns.
- After explicit reconciliation, require a **new** typed request before `TYPED_MOVE` may become active again.

### P6 — conflict/adversarial cases

At minimum:

- both jog directions asserted together;
- typed request while jog owner active;
- home request while typed owner active;
- typed target marked invalid/out-of-range;
- reference validity lost after a fault;
- authorization toggles false->true in adjacent invocations while a press/request remains asserted.

No case may produce overlapping owners or automatic replay of a pre-fault command.

## Frozen gates

A. Exactly one owner maximum on every invocation.
B. Typed positioning never activates without valid reference and valid target.
C. Continuous jog remains active without repeated target/command refresh.
D. Ordinary jog release revokes the jog.
E. Authorization loss revokes an active jog even without release.
F. Independent jog-stop revokes an active jog.
G. Feedback, drive, and stall-suspect faults are distinguishable.
H. Every active-motion fault passes through `FAULTED`/`RECONCILE`; no direct interrupted-owner resume.
I. `auto_resume_attempted == false` for every retained row.
J. Adversarial simultaneous requests never create two motion owners.

All A–J must pass for PB-BG-001 to be TEST-CONFIRMED.

## Evidence retention

Retain one invocation-level CSV or equivalent atomic table containing all state, input, output, fault and owner witnesses needed to score A–J. Retain harness source and SHA-256 or repository commit identity. If a sampler/stream recorder is used, retain producer-health evidence and deterministic invocation continuity; absence claims require no relevant recorder loss.

## Failure interpretation

A failed gate is not permission to weaken the gate after seeing results. Classify failure as harness defect, contract defect, or LinuxCNC-semantic mismatch. If a source-level LinuxCNC runtime experiment is later added, freeze that extension separately before execution.

## Evidence boundary

A passing result would support only the software ownership/revocation contract. It would not establish real backgauge stopping distance, servo sizing, stall thresholds, homing switch geometry, safe speed, physical collision avoidance, or functional-safety performance.

## Exact execution checkpoint

Implement the smallest deterministic harness that can emit the required invocation-level evidence and score frozen Gates A–J. Prefer a lightweight software state-machine test over a full LinuxCNC or motor simulation unless the lightweight result exposes a LinuxCNC-specific ambiguity that actually requires runtime verification.