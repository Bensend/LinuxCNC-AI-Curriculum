# BIQUAD-160 — LinuxCNC biquad: negative cutoff passes validity check and can singularize filter coefficients

**2026-11-02; 4000 LinuxCNC HAL signal-processing implementation, 3100/3300/3400/3600 transfer; NON-GRADUATED.**

## Predecessor and immutable provenance

Direct full `PROGRESS.md` search found no `biquad` predecessor; LINC-159 concerns lookup-table segment caching, PID-152 concerns output saturation, and this investigation concerns **filter coefficient validity and enable-edge lifecycle**. Do not claim a physical failure or new scored competence.

- LinuxCNC **v2.9.10** commit `86cdca76fa2a36274c432caa21952b23c267989a`, [`src/hal/components/biquad.comp`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/biquad.comp), blob `156862ca0511d38875ef84951ed7098f1cbd0dcc`.
- LinuxCNC **development** commit `06864e23559e70463fc7112d5ce77138bcbc288c`, [same file](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/components/biquad.comp), blob `936a68368a401d0cbddcf76a18cff234e2037fb4`.
- Official [biquad(9)](https://www.linuxcnc.org/docs/devel/html/en/man/man9/biquad.9.html) describes transposed second-order IIR, `enable`, `valid`, `type`, `f0`, `Q`, coefficients and internal states. Its `valid` prose says `f0 > sampleRate/2` is required, while implementation explicitly **rejects** `f0 > sampleRate/2`; this is a DOC/SOURCE-CONFLICT, not a source-approved operating range.
- Actual upstream [`tests/biquad/test.hal`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/biquad/test.hal), blob `8ddd381c216116d7ab52c716581b2369b53853ad`, [`runstreamer`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/biquad/runstreamer) blob `fe553b69eb287c85657c1aad6abd7899d4105dd5`, and [`expected`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/biquad/expected) blob `738daa66ee048e235d61b568735edf3fb93d619f`: **important predecessor evidence**. They exercise the default `type=0` direct-coefficient identity/bypass and enable transitions, **not** the invalid negative-`f0` generated-coefficient path. Do not claim “no upstream biquad tests.”

## Source call/state path

`loadrt biquad` creates `biquad.N` and `addf biquad.0 <floating-point thread>` invokes `FUNCTION(_)` each realtime callback. It compares `data.lastEnable` with `enable`. Only on an edge to TRUE does it calculate coefficients for `type=1` lowpass or `type=2` notch; `type=0` uses user-supplied direct coefficients. On edge TRUE, non-direct types set `valid=0`, calculate `sampleRate=1/(period*1e-9)`, reject only `f0>sampleRate/2`, `Q>2`, or `Q<0.5`, then compute:

```text
w0 = 2*pi*f0/sampleRate
alpha = sin(w0)/(2*Q)
a0 = 1+alpha
n0,n1,n2,d1,d2 = b0,b1,b2,a1,a2 divided by a0
valid = 1
```

No `f0<=0`, finite-value or `a0==0` guard is visible in either pinned revision. `valid=1` is set after coefficient assignment **without checking their finiteness**. In the normal enabled/valid branch, output is `in*n0+s1` and state advances using `n1,n2,d1,d2`; otherwise the input is passed through. Changing `f0/Q/type` while `enable` remains TRUE does **not** recalculate coefficients; the manpage explicitly describes a false→true transition as the trigger. Development changes HAL type/setter syntax, not these branches.

## Conditional numeric counterexample

At a **hypothetical** 1 ms servo period (`sampleRate=1000 Hz`), set `type=1` lowpass, `f0=-250 Hz`, `Q=0.5` before the FALSE→TRUE enable edge:

- The rejection predicate is FALSE: `-250 > 500` is false, `0.5 > 2` false, `0.5 < 0.5` false.
- `w0≈-pi/2`, `sin(w0)≈-1`, `alpha≈-1`, and `a0≈0`. The lowpass numerator `b0=(1-cos(w0))/2≈0.5` is nonzero.
- The component divides the coefficients by `a0` without a guard and then sets `valid=TRUE`. Depending on floating-point rounding/runtime behavior, the coefficients can be extremely large or nonfinite, and the next output can be nonfinite.

**SOURCE-CONFIRMED:** negative cutoff is accepted by the predicate and no denominator/finiteness check precedes `valid=1`. **INFERENCE:** the near-singular numeric example and any resulting Inf/NaN; not a measured HAL trace or guaranteed particular floating-point exception. No claim that a valid positive cutoff behaves this way.

## Important controls and conflicts

- Positive `f0=100 Hz`, `Q=0.7071`, 1 ms period: predicate accepts; generated coefficients are expected finite (numeric control, **NOT RUN**).
- `f0=600 Hz` at 1 ms: predicate rejects, `valid=0`, and output bypasses to input. This directly contradicts the manpage's “f0>sampleRate/2” requirement wording.
- `Q=0.49`: rejects. Boundary `Q=0.5` and `Q=2` are accepted, despite manual's strict inequality text.
- Change `f0` while `enable` stays TRUE: no coefficient refresh. Toggle FALSE then TRUE to recalculate; this is **documented edge behavior**, not a new bug.
- `valid` is not a continuous input-health or physical sensor-freshness flag. On disabled pass-through, `valid` need not mean an active filter is being applied.

## Integration and evidence boundaries

This is a realtime HAL filter usable in ordinary sensor conditioning, feed-forward and control loops. A misconfigured cutoff could propagate a bad output into a PID or process estimator, but the actual downstream effect depends on wiring, limits, signal freshness and machine state. No real machine configuration was inspected claiming this exact invalid value. Independent personnel-safety authority remains outside LinuxCNC HAL.

[Practical source and acceptance guide](../guides/4000-linuxcnc-biquad-filter-coefficient-validity-commissioning-2026-11-02.md) reuses the existing upstream test rather than manufacturing a redundant new harness. **TEST-CONFIRMED for this new case: none; NOT RUN.** No LinuxCNC build, HAL run, physical machine, independent evaluator or Actions job; hosted/self-hosted 0/0 minutes. Blind and compute ledgers unchanged.

**Next discriminating evidence:** qualified, physically disconnected `[self-hosted, openpressbrake]` LinuxCNC test with predeclared valid/negative/above-Nyquist controls, raw `valid,n0,a0-proxy,out` trace and source version. Avoid live machine I/O and GitHub-hosted runners. A candidate fix would validate `0 < f0 < sampleRate/2`, finite inputs and `a0` before accepting coefficients, but exact boundary policy requires maintainer review; **no patch is proposed as verified**.
