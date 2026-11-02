# 3100 / 3400 / 3600 / 4000 — PID zero-limit transition: real-source regression

**Status:** SOURCE-CONFIRMED prediction; all execution cases **NOT RUN**. Companion to [PID-152](../research/4400_LINUXCNC_PID_152_ZERO_MAXOUTPUT_STALE_SATURATION_AND_INTEGRATOR_GATE_SOURCE_AUDIT_2026-11-02.md). No physical machine, amplifier or actuator is required or authorized.

## Purpose

LinuxCNC's stock `pid.N.maxoutput` is a dynamically tunable HAL float pin. Its documented zero value disables **internal PID output limiting**, not the loop or downstream drive. A stale `limit_state` after a finite→zero change can make `pid.N.saturated` report a nonexistent current PID limit and keep the anti-windup integrator gate active. This matters for mills, routers and press-brake actuator simulations that use PID telemetry to distinguish commanded effort from actual final-element authority.

## Executable source-extraction fixture (stable v2.9.10)

The [Python driver](../examples/4000_pid_152/test_pid_maxoutput_transition.py) reads an **existing local checkout** of pinned LinuxCNC v2.9.10 `src/hal/components/pid.c`, checks the **Git blob SHA**, extracts the original `calc_pid` function with balanced braces, compiles that exact C function with mock HAL pin storage, and compares original with a two-line candidate correction. It uses `cc`, not a reimplementation of the PID algorithm. It does **not** use an installed LinuxCNC process, real-time scheduler or any HAL-connected hardware.

On a positively qualified, disconnected `[self-hosted, openpressbrake]` runner only:

~~~sh
python3 examples/4000_pid_152/test_pid_maxoutput_transition.py \
  --source /path/to/pinned/linuxcnc/src/hal/components/pid.c
~~~

Verify the local LinuxCNC commit and blob before execution. **Do not dispatch GitHub-hosted Actions.** No test has been run by this lesson.

## Frozen comparison cases

| ID | Transition | Original source prediction | Corrected source prediction |
|---|---|---|---|
| A | `enable=1, P=2, error=1, maxoutput=1` | output 1, saturated TRUE | same |
| B | Change `maxoutput=0` | output 2, saturated **still TRUE** | output 2, saturated **FALSE** |
| C | Set finite `maxoutput=3` | output 2, saturated FALSE | same |
| D | Set `maxoutput=0` again | output 2, saturated FALSE | same |
| E | Re-enter saturation with nonzero I, then remove limit | integral held on first zero-limit callback in **both** variants | same |
| F | Second zero-limit callback with positive error | integral remains held, saturated TRUE | integral increases, saturated FALSE |
| G | Disable PID | output zero, saturation clears, integrator resets | same |

The compiled harness should assert A–F and print exact measured C outputs. A real HAL-runner follow-up should verify G and collect `pid.0.output`, `pid.0.saturated`, `pid.0.saturated-s`, `pid.0.saturated-count`, `pid.0.errorI` (with `debug=1`), `pid.0.maxoutput`, `pid.0.enable`, and the callback period in **the same phase**. The source-extraction harness is a narrower algorithm oracle, not a substitute for HAL execution.

## Patch review and compatibility

The [stable v2.9.10 minimal patch](../examples/4000_pid_152/pid_maxoutput_zero_clear_limit_state_v2910.patch) resets `limit_state` only when limiting is disabled by a zero `maxoutput`. It deliberately does not reset `errorI` or change the PID output value. The development branch has the same conceptual issue but uses `hal_get_real`/`hal_set_real`; review its separate implementation before proposing upstream. Negative `maxoutput` and downstream actuator clipping are separate questions, not claims of this lesson.

**Acceptance:** source blob pinned; original and corrected cases pass their *different* expected oracles; HAL integration separately shows finite→zero behavior; no new controller-side side effects; machine qualification is a separate owner-controlled process. If the fixture fails to compile or a source pin differs, classify as **HARNESS INVALID**, not a LinuxCNC behavioral verdict.

## Next work

First executable priority remains [MOTION-144 disconnected amplifier-fault/re-enable](../research/4400_LINUXCNC_MOTION_144_AMP_FAULT_REENABLE_ONE_SERVO_ENABLE_PULSE_SOURCE_AUDIT_2026-11-02.md). PID-152 source-extracted C verification is a lower-cost next option when qualified compute is available. If no qualified runner exists, rotate to a distinct LinuxCNC source/config question rather than manufacturing more unrun cases. Do not reopen graduated levels or change independent safety gates.
