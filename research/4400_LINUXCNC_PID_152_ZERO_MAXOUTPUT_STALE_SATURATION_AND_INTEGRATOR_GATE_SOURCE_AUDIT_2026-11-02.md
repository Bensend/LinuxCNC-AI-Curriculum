# PID-152 — Zero maxoutput retains stale PID saturation and anti-windup state

**Status:** 4000 LinuxCNC-first, 3100/3400/3600 transfer, NON-GRADUATED. Inspected 2026-11-02 UTC. **SOURCE-CONFIRMED static mechanism; runtime effects INFERENCE; TEST-CONFIRMED none; NOT RUN.** This is an internal PID limit-transition issue, not an independent personnel-safety control.

## Provenance and novelty

- Stable LinuxCNC **v2.9.10** [`src/hal/components/pid.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/pid.c), blob `2dc0b776be315b7c5cd71b980c3540dcaf1dd051`, `calc_pid` near lines 568–580 and 643–684.
- Inspected upstream development `master` on 2026-11-02, [`pid.c`](https://github.com/LinuxCNC/linuxcnc/blob/master/src/hal/components/pid.c), blob `fb0b7c87f615c748fb751802477d54cc7c192c31`; its HAL accessor syntax differs, but the nonzero-`maxoutput` branch still lacks an `else` resetting `limit_state`.
- Official stable [PID realtime-component documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/hal/rtcomps.adoc) (PID pins and saturation, around lines 423–445) says zero `max*` limits mean **no limit**, and gain/limit pins can be adjusted dynamically.
- Historical predecessor check: [PB-PREP-001 stock-PID saturation witness](PB-PREP-001-pinned-pid-saturation-witness-2026-09-11.md) and [PID downstream authority version check](pid-downstream-authority-version-check-2026-09-12.md) already establish `saturated` is the stock PID's internal-limit witness, **not** downstream actuator clipping. This investigation adds a distinct **dynamic finite→zero limit state-retention** question. Full PROGRESS/LESSON_LOG and LAB_COMPUTE_LOG were searched for `limit_state`, zero `maxoutput`, saturation and anti-windup; no exact predecessor found. Search negatives are not independent proof of absence.

## Source-level causal chain

In `calc_pid`, the integrator executes **before** current-cycle output limiting. It integrates only when `(error * pid->limit_state) <= 0`; this `limit_state` is the **previous cycle's** saturation sign. Later, while enabled, output clipping and `limit_state` assignment happen **only if `maxoutput != 0.0`**. The zero-limit branch skips both clipping and the reset of `limit_state`. Finally, the `saturated`, `saturated-s` and `saturated-count` outputs are derived from that retained state. Disabling PID resets `limit_state` and integral, but changing `maxoutput` to zero does not.

**Frozen arithmetic example, no feedback dynamics:** `enable=1`, `command=1`, `feedback=0`, `Pgain=2`, `Igain=0`, all FF/bias/D terms zero, 1 ms callback. At `maxoutput=1`, unclipped effort 2 is clipped to 1, `limit_state=+1`, `saturated=TRUE`. Change only `maxoutput` to 0. Next callback emits output **2 (unlimited)**, but leaves `limit_state=+1`, `saturated=TRUE`, and continues increasing the saturation-duration/count witnesses. With a persistent positive error, an enabled nonzero `Igain` also sees its `errorI` accumulation gated indefinitely while the stale positive state persists. Setting `maxoutput=3` for one callback clears the state; setting it back to zero then leaves saturation FALSE. **Identical instantaneous `maxoutput=0` and input values therefore produce different diagnostic/integrator behavior depending on limit history.**

| Transition | Stock predicted output | Stock `saturated` | Stock positive-error integral |
|---|---:|---|---|
| finite 1, command error +1, P=2 | 1 | TRUE | gated after first saturated callback |
| finite 1 → zero, same input | 2 | **remains TRUE** | **remains gated** |
| finite 1 → finite 3, same input | 2 | FALSE | resumes after state clear |
| finite 3 → zero, same input | 2 | FALSE | continues |
| disable, then enable at zero | 2 | FALSE | reset on disable, then resumes |

The integral is calculated before clipping: even the proposed correction permits **one last gated callback** on the first zero-limit pass; integration resumes on the next pass. Do not claim an immediate same-pass integrator correction.

## Minimal repair hypothesis

For the stable code, add an `else { pid->limit_state = 0.0; }` corresponding to `if (*(pid->maxoutput) != 0.0)`. Preserve the existing `enable=0` reset and the normal finite-limit sign/zero behavior. A reviewable patch and an **unexecuted extracted-real-`calc_pid` C harness** are in [PID-152 example](../examples/4000_pid_152/test_pid_maxoutput_transition.py). The harness is intentionally pinned to the stable source blob; the development accessor rewrite requires a separate build path, not a guessed same-patch claim.

## Evidence and engineering boundary

The expected stale TRUE status and integrator gate follow directly from inspected code, but **no compiler, HAL thread, PID loop, real drive, physical actuator or machine has been exercised**. A PID `saturated` bit is not a safety function or downstream actuator witness. For any real machine, independent stop/drive/physical authority remains mandatory. This finding does not alter graduated 1000/2000/F02/3000 levels or OpenPressBrake G0/G1 holds.

See [disconnected commissioning guide](../guides/3100-3400-3600-4000-linuxcnc-pid-maxoutput-transition-regression-2026-11-02.md) and [next checkpoint](../checkpoints/20261102T0740Z-4000-linuxcnc-pid-zero-limit-next.md).
