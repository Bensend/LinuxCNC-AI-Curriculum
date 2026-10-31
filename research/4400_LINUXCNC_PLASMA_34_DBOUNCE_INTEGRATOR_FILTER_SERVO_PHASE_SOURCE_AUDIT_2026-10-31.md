# 4400-LC-PLASMA-34 — QtPlasmaC dbounce is a saturating integrator, not a consecutive-sample qualifier

**Status:** 4000 SOURCE-CONFIRMED static algorithm/servo-phase analysis / NON-GRADUATED. No runtime or hardware tests. Date: 2026-10-31. Builds on [PLASMA-33](4400_LINUXCNC_PLASMA_33_REAL_7I96S_QTPLASMAC_SERVO_ORDER_AND_DPLL_SOURCE_AUDIT_2026-10-31.md).

## Source inventory

- [LinuxCNC v2.9.10 `src/hal/components/dbounce.comp`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/dbounce.comp), blob `e765fb3aa2056da4eefd78015a6272da00f651e0`; inspect `FUNCTION(_)`, `state`, `delay`, `out`.
- [Public 7i96S QtPlasmaC HAL](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.hal): `loadrt dbounce names=db_breakaway,db_float,db_ohmic,db_arc-ok`, `addf` after `plasmac` and `hm2.write`.
- [Public custom.hal](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/custom.hal): `db_float.delay=5`, `db_ohmic.delay=0`, `db_breakaway.delay=2`, `db_arc-ok.delay=5`.
- [Upstream v2.9.10 system `qtplasmac_comp.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal): `db_float.out → plasmac.float-switch`, `db_arc-ok.out → plasmac.arc-ok-in`, and other `db_*` outputs. **Version-qualified** because the machine's actual installed library file was not retrieved.

## Actual state machine

```text
if input == 1:
    if state < delay: state += 1
    else: out = 1
else:
    if state > 0: state -= 1
    else: out = 0
```

`state` is retained across servo calls and **increments on high, decrements on low**; it does not reset on every opposite sample. This is a saturating up/down accumulator with output hysteresis. It is **not** a requirement for `delay+1` consecutive identical samples.

### Deterministic edge table (source-derived, not executed)

Starting `state=0, out=0, delay=5`:

| Function call | Input | State after call | Output after call |
|---:|:---:|---:|:---:|
| 1 | H | 1 | 0 |
| 2 | H | 2 | 0 |
| 3 | H | 3 | 0 |
| 4 | H | 4 | 0 |
| 5 | H | 5 | 0 |
| 6 | L | 4 | 0 |
| 7 | H | 5 | 0 |
| 8 | H | 5 | **1** |

No six consecutive high samples occurred. Conversely, once `out=1,state=5`, six stable low calls are needed to clear the output. **A pulse shorter than six calls is not guaranteed to be rejected when the accumulator was already near threshold**. This distinction matters when evaluating noisy float, arc-OK, and breakaway inputs.

For a settled opposite input, the number of function invocations until output changes is `delay+1`: 6 for float/arc-OK, 3 for breakaway, 1 for ohmic. These are **nominal invocation counts**, not measured sensor response times. A bouncing waveform can change the count.

## Cross-component timing

Public machine HAL function order:

```text
hm2.read → motion-controller → pid.* → plasmac → hm2.write → db_float → db_ohmic → db_breakaway → db_arc-ok
```

If the physical input first appears in `hm2.read` on servo iteration `n`, `db_float` receives it at the end of iteration `n`. With `delay=5` and a sustained high input, its output becomes high on iteration `n+5`; `plasmac`, which has already executed that iteration, can first see it at `n+6`. At nominal 1 ms servo period this is **six iteration separations (nominally 6 ms) between input publication at read(n) and component consumption at plasmac(n+6)**. Sampling phase, Ethernet acquisition, sensor electrical response and OS jitter are not included; do not quote this as a measured physical latency.

For `delay=0`, `db_ohmic` sets its output at the end of iteration `n`, and `plasmac` first sees it at `n+1`. This is the **same scheduling penalty** even without filter accumulation. Moving dbounce before `plasmac` would remove the extra iteration for new filtered outputs, but requires an actual HAL edit/review and must preserve input freshness and independent safety boundaries.

A common misleading shortcut is to multiply the number of delay counts by a claimed fixed probe-position error. The physical Z position error is approximately `v_z × elapsed time` for a constant-velocity phase, and depends on the actual probing velocity, controller mode and sampling phase. The public `custom.hal` comment that each delay increment adds 0.001 mm should **not** be generalized to all speeds or machine conditions.

## Practical adversarial exercises (not executed)

1. Given `delay=5` and HHHHHLHH, predict the output after every call without resetting the accumulator on L. A naive consecutive-sample debounce model predicts the wrong final result.
2. Change the hypothetical `addf` order to `hm2.read → db_* → motion-controller → plasmac → hm2.write`. Which extra whole-cycle dependency disappears? Which filter-count latency remains?
3. At a hypothetical steady Z speed of 100 mm/min, 6 ms corresponds to 0.010 mm of motion **if** the stated interval and constant speed apply. Why does that not prove the physical probing error?
4. What evidence would falsify the version-specific wiring assumption? Answer: an effective installed `qtplasmac_comp.hal` or `halcmd show sig` that differs from v2.9.10.

## Verification plan and limits

A bounded software-only LinuxCNC test could load `dbounce` in a servo thread, feed a deterministic bit pattern with a realtime pattern generator, and capture input, `state` proxy/output, and a cycle counter in the **same realtime thread**. `state` is an internal variable, not a published HAL pin; do not claim it is directly observable without instrumentation. A userspace `halcmd setp` pulse loop is **not** a cycle-exact oracle. Freeze the expected table above before running any test. Use only positively verified isolated `[self-hosted, openpressbrake]` compute if justified; no GitHub-hosted fallback. No test was launched here.

**Evidence classification:** SOURCE-CONFIRMED algorithm and configuration, INFERENCE on combined installed runtime, TEST-CONFIRMED none, actual hardware behavior UNKNOWN. Existing graduated levels and independent personnel-safety gates unchanged.
