# D01-004 — Atomic Cartesian-feedback observer design

Status: **DESIGN COMPLETE / NOT YET IMPLEMENTED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Problem

Frozen D01-002 Gate F requires Cartesian Y feedback in the **same realtime atomic evidence stream** as the duplicated joints' command, feedback and following-error state.

`emcmotStatus->carte_pos_fb` is produced inside realtime motion, but it is not exposed as an ordinary realtime HAL output pin analogous to `joint.N.f-error`. HALUI/NML/display position is a userspace status surface with different publication and observation timing; sampling it beside realtime joint pins would violate the frozen atomicity contract.

## Pinned publication point

`control.c::do_forward_kins()` runs after `process_inputs()` and before `check_for_faults()` in the servo controller cycle. It obtains current joint feedback values and calls `kinematicsForward(..., &emcmotStatus->carte_pos_fb, ...)` for the relevant kinematics modes. The function completes before `process_probe_inputs()` and `check_for_faults()` consume that Cartesian feedback/fault state.

Therefore the least ambiguous observation point is **at the end of `do_forward_kins()` after its kinematics-mode switch**. A test-only HAL output copied there records exactly the Cartesian feedback value produced by that cycle before later fault consequence processing.

## Minimal retained test-only patch

The authoritative harness should make an intentionally tiny, reviewable patch to the pinned LinuxCNC build:

1. Add one test-only `hal_real_t` handle to `emcmot_hal_data_t`, e.g. `d01_carte_y_fb`.
2. In normal motion HAL export setup, create one `HAL_OUT` real pin, e.g. `motion.d01-carte-y-fb`, using the same `hal_pin_new_real()` API as existing motion outputs.
3. At the end of `do_forward_kins()`, write `emcmotStatus->carte_pos_fb.tran.y` to that HAL output with `hal_set_real()`.
4. Do not change kinematics inputs, kinematics output, joint state, enable state, ferror limits, planner state, Task/NML state, or production fault logic.
5. Retain the exact source diff, build log and object/source provenance with the experiment artifact.

## Perturbation argument

This patch adds one HAL real output and one realtime scalar write per servo cycle. It observes an already-computed value after forward kinematics; it does not participate in the calculation or feed a production input. This is lower perturbation and better ordered than polling NML/HALUI from userspace.

It is still instrumentation, not production evidence. The D01 authoritative report must explicitly state that the experiment proves pinned software semantics **under this observer patch**. If the observer changes compilation, timing or behavior materially, the run is invalid rather than silently accepted.

## Ordering requirement for sampler

The sampler must execute after `motion-controller`, because the test-only Cartesian pin is written inside that controller function. The duplicate-feedback plant function also needs an explicitly retained order because its output becomes motion feedback on the next servo-cycle `process_inputs()` call.

A separate phase sequencer may be added, but frozen D01-002 requires phase visibility before each mutation. Function order must therefore make the phase marker observable before changing the low/high offset. The earlier C06 phase-label race must not be repeated.

## Source-integrity gate refinement

Frozen Gate A already permits an explicitly retained test-only fixture patch. For D01 that allowance is now constrained to this observer-only purpose. The final authoritative source-integrity check should assert that the diff is confined to:

- the one HAL-data field,
- one HAL-output export,
- one post-forward-kinematics scalar write,
- and separately retained test fixture files/components.

Any modification to `kinematicsForward`, `process_inputs`, following-error calculation, `check_for_faults`, `set_operating_mode`, planner/trajectory behavior, or production duplicated-coordinate semantics invalidates the authoritative run.

## Why not infer Cartesian Y from the principal joint in analysis?

Pinned source analysis predicts that ordinary duplicated-coordinate `trivkins` will publish principal-joint Y as Cartesian Y. Recomputing that value from joint feedback in the test analyzer would therefore bake the claim under test into the measurement. Gate F deliberately requires observing LinuxCNC's actual published kinematics result, not restating the source prediction.

## Next use

Only after the real duplicated-coordinate plant preflight passes should this observer patch be implemented and subjected to a **non-authoritative compile/load/atomic-order preflight**. One authoritative D01-002 run may then be declared in advance and scored against the unchanged Gates A–J.