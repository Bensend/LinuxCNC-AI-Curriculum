# 25C0 adversarial exercise — setup to automatic with held demand

## Scenario

A machine has an independent safety subsystem and an ordinary LinuxCNC/FPGA control subsystem.

During setup:

- the setup operating mode is valid;
- a three-position enabling device permits restricted setup motion;
- an ordinary jog input is asserted and remains physically asserted;
- the operator releases the enabling device, so the safety subsystem correctly removes motion permission and the machine stops;
- the ordinary jog input is never released;
- the operator leaves the safeguarded space, closes the guard, selects Automatic, and performs the required safety reset/rearm;
- all independent safety conditions become valid for Automatic.

The ordinary controller now sees `automatic_mode=true`, `safety_permission=true`, and the same ordinary motion/start input still true.

## Learner task

Review the transition without inventing a safety standard or controller behavior.

1. Identify which facts establish operating mode, safety permission, ordinary motion demand, command freshness, and physical final-element evidence.
2. Decide whether the held ordinary input may be treated as a fresh automatic start solely because automatic safety permission has returned.
3. Specify a conservative ordinary-control rule that prevents stale demand from crossing the authority transition.
4. Explain why this ordinary-control rule does not make LinuxCNC or the normal FPGA safety-rated.
5. State what remains UNKNOWN without the actual machine/controller input semantics.

## Expected reasoning constraints

A strong answer should preserve these distinctions:

- `automatic mode valid` is not `start requested`;
- `safety permission restored` is not `fresh command`;
- `input presently high` does not prove it transitioned high after the new authority became valid;
- a conservative implementation can cancel/invalidate pre-transition demand and require a post-eligibility release/reassert or other explicit fresh event;
- the exact acceptance algorithm is design-specific unless authoritative controller/machine evidence defines it;
- independent safety authority remains independent even if ordinary control adds a stricter no-stale-demand gate;
- return to productive operation still needs the applicable physical/safety evidence and deliberate production start sequence.

## Misleading premise

> The safety controller has re-enabled motion, so any command that is currently true is safe to execute.

Reject this premise. Safety permission establishes a permitted envelope; it does not manufacture a fresh ordinary motion request.

## Transfer variant

Replace the jog input with a maintained remote `cycle_request` from a cell controller. The request was asserted before a guard opening and remains asserted throughout reset. Ask whether a restored guard/safety permission may automatically consume that old request. Require the learner to classify the request semantics explicitly: edge, level, latched, queued, cancelled, tracked, or regenerated.

## Evidence anchor

Use `SIEMENS_ABB_SETUP_TO_AUTOMATIC_RETURN_AND_FRESH_START_BOUNDARY_2026-09-21.md`. Siemens provides an authoritative setup/automatic safety-monitoring example in which valid feedback makes a later Start action possible rather than constituting Start itself. ABB independently separates manual/automatic mode and Start. Neither source is authority for a universal held-input implementation; that limitation is part of the exercise.
