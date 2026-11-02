# LIMIT3-158 — one-cycle `load` leaves a synthetic velocity in LinuxCNC's HAL limit3
**2026-11-02 | 4000 LinuxCNC implementation; 3100/3400/3600/3800 transfer; NON-GRADUATED**

## Evidence and scope
- **SOURCE-CONFIRMED:** LinuxCNC v2.9.10 tag object `4e7abeab3e764a42ef9def932333a1d4004e547b`, peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`; [`src/hal/components/limit3.comp`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/limit3.comp), blob `a2563e7543a64140b253a5e4dace12f0160cdcec`, especially lines 9–12, 30–36, 59–75, 90–98, 155–175.
- **SOURCE-CONFIRMED version comparison:** development commit `67437d8865e431a9a33f74cee912dbf891d3b4c5` (2026-11-01), `limit3.comp` blob `f0d79ea02e0df21ec777b3b26a02273f3508004a`. It changes HAL types and uses `out_set()` but retains `out_old = out` in `SET_NEXT_STATE` and invokes that macro in `load`.
- **DOC-CONFIRMED:** the component's `load` pin promises to immediately set output to input, ignoring velocity and acceleration; [official HAL examples](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/hal/hal-examples.adoc) describe `limit3` as limiting first and second derivatives.
- **Real integration context:** [upstream `1extrajoint.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/extrajoints/1extrajoint.hal) connects `j4.limit3.out` to `joint.4.posthome-cmd`; [upstream `hbm.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/hbm/hbm.hal) uses limit3 as simulated motor dynamics. Neither example demonstrates an asserted `load` input.
- **Existing upstream test inventory:** [`tests/limit3/`](https://github.com/LinuxCNC/linuxcnc/tree/v2.9.10/tests/limit3) has sunny-day, constraint, runaway, limit-velocity and overshoot cases. A bounded code search did not find a one-cycle `load` derivative-reset regression; **search absence is not proof no test exists**.
- **Predecessor/novelty check:** literal and synonymous scans of current `PROGRESS.md`, `LESSON_LOG.md` and `LAB_COMPUTE_LOG.md` found no previous `limit3` load/velocity-state case. Do not confuse with PID-152 maxoutput state or HAL-STREAM-156 FIFO wrap. No new runtime evidence.

## Exact source execution path
`limit3` is a realtime HAL component: `addf limit3.0 servo-thread` calls `FUNCTION(_)` each period. The persistent `out_old` is used to estimate current velocity, `(out-out_old)/fperiod`; `in_pos_old` estimates input velocity. Normal `SET_NEXT_STATE(new_out, new_in)` deliberately assigns **previous output** to `out_old`, then changes `out`, then remembers `in_pos_old` and returns.

The `load` branch (lines 71–75) clamps the input position to `[min,max]` and calls **the same macro**. That is correct for storing a previous sample during ordinary continuous motion, but it leaves `out_old` at the *pre-load* position after a discontinuous position initialization. On the first callback after `load` goes FALSE, the derivative therefore interprets the deliberate initialization jump as motion that occurred within one servo period.

The next bounds use `min_vel = max(out_vel-maxa*dt,-maxv)` and `max_vel = min(out_vel+maxa*dt,maxv)`. These independently clamp only one side each; a synthetic `out_vel` above `maxv` can make `min_vel > max_vel`. The source then computes `min_pos > max_pos` and uses those values in landing/overshoot branches. This is not merely a stale display bit: `SET_NEXT_STATE(min_pos,...)` can be selected and publish a new position command outside the intended velocity constraint.

## Hand-reproducible two-callback oracle (no executable result claimed)
Assume a 1 ms thread, `min=-100`, `max=100`, `maxv=1` unit/s, `maxa=10` unit/s², initial `in=out=out_old=in_pos_old=0`. Hold `in=10` for the following callbacks.

| Callback | load | out before | out_old before | out after | mechanism |
|---|---:|---:|---:|---:|---|
| baseline | 0 | 0 | 0 | 0 | steady state |
| **A** | **1** | 0 | 0 | **10** | intentional load jump; macro leaves `out_old=0` |
| **B** | **0** | 10 | 0 | **19.99999** | `out_vel=10000`; `min_vel=9999.99`, `max_vel=1`; `min_pos=19.99999`, `max_pos=10.001`; landing branch chooses `min_pos` |

For B: `in_vel=0`, `goal_pos_min=goal_pos_max=10`, `ach_pos_max=10.0505 > 10`, and `ach_pos_min` is much greater than 10. `VALID_NEXT(10)` is FALSE because `19.99999 <= 10 <= 10.001` is impossible. Therefore the first two goal checks fall through and the `ach_pos_min > goal_pos_min` branch publishes `min_pos`. The **additional** 9.99999-unit step in 1 ms exceeds `maxv=1` unit/s. This is a conditional, source-derived calculation, **not** an observed HAL trace or machine displacement.

A control with `load=TRUE` for **two consecutive callbacks** does not retain the initial jump as velocity: the second `load` call sets `out_old=10` before the first normal callback. This makes one-cycle versus two-cycle `load` an important discriminator. A no-load step from 0 to 10 is a separate ordinary constrained-motion control.

## Candidate correction and trade-off
[`examples/4000_limit3_158/limit3_load_derivative_reset_v2910.patch`](../examples/4000_limit3_158/limit3_load_derivative_reset_v2910.patch) replaces the `load`-branch macro call with direct assignment of `out` and `out_old` to the clamped loaded value and `in_pos_old` to the **raw effective input** (`invalue`), then returns. The normal macro and all other branches remain unchanged. On the next callback the estimated input and output velocities both start at zero for an unchanged input, so the unchanged in-range input is accepted as `out=10` without an extra jump. **Second source-state detail:** the original `load` macro also passes the *clamped* `in_pos_lim` as its stored input. If raw `invalue=150` and `max=100`, the next unchanged raw input is spuriously interpreted as `(150-100)/0.001 = 50,000` units/s. Storing `in_pos_old=invalue` avoids that separate synthetic input-derivative artifact. A clamped-target experiment should be added only if it gives a distinct observable output oracle.

**This is a proposed correction, not an accepted upstream fix.** It deliberately resets derivative history on `load`; any application depending on retaining pre-load velocity would need explicit review. For development, use `out_set(in_pos_lim)` rather than direct `out =` because its HAL pin API differs. Do not blindly apply the stable patch to development.

## Failure boundaries and questions
1. If `load` is continuously asserted, the component intentionally bypasses velocity/acceleration limits. The proposed change does **not** make `load` an ordinary constrained move.
2. If `min > max`, `maxv <= 0`, `maxa <= 0`, or nonfinite inputs are supplied, other validation issues exist; these are **out of scope** for this one-cause regression.
3. `limit3` is a normal HAL planning/filter component, not an independent safety-rated travel limiter. In real configurations `out` may feed a simulated motor or an extra joint; **physical actuator behavior is UNKNOWN**.
4. Verify against pinned stable original and corrected source with a 1 ms isolated software HAL stream; then compare development using a development-specific fix. Run the two-cycle-load and no-load controls. Inspect upstream `tests/limit3` before adding redundant test infrastructure.
5. If a trace disagrees with the numeric oracle, first inspect function order, sampler alignment, `load` pulse width, and the HAL-STREAM-156 stable FIFO boundary. Do not label the mechanism TEST-CONFIRMED without the retained raw trace.

**Status:** SOURCE-CONFIRMED state/arithmetic, DOC-CONFIRMED intended component purpose, conditional published-output INFERENCE from source; **TEST-CONFIRMED none; NOT RUN**. No LinuxCNC build, HAL execution, self-hosted or hosted Actions, machine, evaluator, or FPGA.
