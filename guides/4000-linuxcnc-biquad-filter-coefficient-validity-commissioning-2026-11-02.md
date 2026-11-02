# LinuxCNC biquad filter commissioning — cutoff, enable edge and validity

**4000 LinuxCNC source exercise; 3100/3300/3400/3600 transfer.** This guide accompanies [BIQUAD-160](../research/4400_LINUXCNC_BIQUAD_160_NEGATIVE_CUTOFF_VALID_NONFINITE_COEFFICIENT_SOURCE_AUDIT_2026-11-02.md). All new cases **NOT RUN**.

## Read source before changing a filter

Read [stable v2.9.10 `biquad.comp`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/biquad.comp) and [pinned development](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/components/biquad.comp). The component's `enable` is **not** a generic freeze pin: when FALSE, input passes through; only a FALSE→TRUE edge generates type 1/2 coefficients and resets `s1,s2` after successful generation. `type=0` uses direct user coefficients. The `valid` flag reports the calculation's limited internal checks, **not** finite-output proof or input freshness.

The official [biquad(9) manual](https://www.linuxcnc.org/docs/devel/html/en/man/man9/biquad.9.html) has a source/documentation discrepancy: it describes `f0>sampleRate/2` in the validity sentence, while the source **rejects** values above half the sample rate and fails to reject negative cutoff. Preserve that conflict; do not design from the inverted prose.

## Predeclared disconnected test matrix

Extend, rather than replace, upstream [`tests/biquad/test.hal`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/biquad/test.hal). Its existing [expected trace](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/biquad/expected) is a `type=0` identity/pass-through test; it does not cover generated lowpass/notch coefficients. Use a separately qualified, physically disconnected local runner and retain raw HAL snapshots for each phase.

| Case | 1 ms period settings | Frozen source-derived expectation |
|---|---|---|
| A | `type=0`, direct defaults | Output follows input; preserve upstream existing oracle |
| B | `type=1, f0=100, Q=0.7071`; enable 0→1 | `valid=1`, finite coefficients expected |
| C | `type=1, f0=-250, Q=0.5`; enable 0→1 | No rejection; `a0≈0`; `valid=1` even if coefficients/output nonfinite |
| D | `type=1, f0=600, Q=0.7071`; enable 0→1 | `valid=0`; output bypasses to input |
| E | `type=1, f0=100` enabled, change `f0=200` without toggle | Coefficients remain from 100 Hz |
| F | Toggle `enable=0→1` after E | Recalculates for 200 Hz; `s1,s2` reset |
| G | `type=1, f0=100, Q=0.49`; enable 0→1 | `valid=0`; bypass |
| H | `type=2` valid positive cutoff | Distinguish notch branch from lowpass |

These are **predictions**, not reported measurements. For C, whether a particular runtime produces Inf, NaN, a floating-point trap or very large finite coefficients is **UNKNOWN** until executed. Capture `valid`, `n0,n1,n2,d1,d2`, `s1,s2`, `in`, `out` and exact callback period. If a harness fails to load, label **HARNESS INVALID**, not a confirmed LinuxCNC defect. Do not use physical spindle/torch/ram/servo outputs.

## Practical machine transfer

For a mill spindle vibration estimator, plasma voltage diagnostic, router load monitor or press-brake **display-only** sensor smoother, choose `f0` using the **actual servo sample rate** and validate `0 < f0 < sampleRate/2` before enabling a generated filter. Reject nonfinite and out-of-range configuration at the integration boundary; do not treat `biquad.valid` as comprehensive runtime validation. Specify the response to disabled/bypass filter and the response to stale input separately. When changing cutoff online, define an explicit edge/transition policy; a direct pin edit does not update coefficients until a re-enable.

The existing MOTION-144 isolated test remains first qualified executable priority. This BIQUAD-160 test is lower priority until independently verified `[self-hosted, openpressbrake]` isolation exists. No hosted Actions, physical-machine claim, independent safety substitution or automatic production build.
