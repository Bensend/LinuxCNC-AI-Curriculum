# PB-PREP-001 — 077 independent-audit temporal alignment correction

Status: **FROZEN BEFORE ANY 077 BEHAVIORAL RESULT OR ARTIFACT WAS OBSERVED**

Date: 2026-09-11

Parent audit freeze: `experiments/PB-PREP-001-077-independent-audit-freeze.md`

Candidate workflow: `34557828294`, job `103134175120`.

## Why this correction exists

Independent source inspection of the already-retained 076 behavioral render exposed a temporal alignment detail in the **audit oracle**, not in the frozen experiment design.

The realtime thread order is:

```text
motion-command-handler
motion-controller
pb-prep.0.prepare
pb-pid1.do-pid-calcs
pb-pid2.do-pid-calcs
pb-prep.0.finish
sampler.0
```

`pb-prep.0.prepare` observes the current synthetic plant state and latches `e_diff_used`, requested correction and applied correction. `pb-prep.0.finish` computes pre-limit/final commands and then advances the two synthetic plant states in place. `sampler.0` executes after `finish`, so the retained row contains:

- current-cycle control quantities based on the **pre-update** plant state;
- final commands produced from that pre-update state;
- `y1/y2` after the synthetic plant has already advanced to its **next state**.

Therefore the original independent-audit wording for architecture C — recompute its common P effort directly from same-row sampled `r1/r2/y1/y2` — is temporally incorrect. That audit check would compare a pre-update control calculation against post-update state.

This finding was made while workflow 077 remained `in_progress`, before any 077 raw trace, analyzer result, classification, architecture metric or B/P6 discriminator result was visible.

## What is unchanged

This correction changes **no experiment behavior**:

- no LinuxCNC revision;
- no controller gain;
- no plant gain/alpha;
- no P2-P7 transition or duration;
- no `SYNC_GAIN`, `DIFF_MAX`, or `U_MAX`;
- no sampler topology;
- no threshold;
- no Gate A-J meaning;
- no outcome classification;
- no `B/P6 missing downstream-only saturation => INCONCLUSIVE` rule.

It corrects only how the independent evaluator reconstructs the state used by the already-frozen controller.

## Correct causal interpretation of one retained row

Let the sampled row contain the post-update states `y1_now`, `y2_now`, final commands `u1`, `u2`, and retained B-side `gain2`, `alpha2`.

The frozen plant is:

```text
y1_now = y1_prev + 0.05 * ((1.0 * u1) - y1_prev)
y2_now = y2_prev + alpha2 * ((gain2 * u2) - y2_prev)
```

For the frozen non-unity alphas, reconstruct the states seen by `prepare`/`finish` as:

```text
y1_prev = (y1_now - 0.05 * u1) / (1 - 0.05)
y2_prev = (y2_now - alpha2 * gain2 * u2) / (1 - alpha2)
```

The independent auditor must use these reconstructed pre-update states, or equivalently a causally aligned adjacent-row method, when checking a control-law equation that consumed plant state before `finish` advanced it.

## Corrected architecture-C oracle

For architecture C, reconstruct `y1_prev` and `y2_prev`, then calculate:

```text
common_expected = 6.0 * (((r1 - y1_prev) + (r2 - y2_prev)) / 2)
pre1_expected   = common_expected - corr_applied
pre2_expected   = common_expected + corr_applied
```

Verify retained `prelimit1/prelimit2` against these expectations at tolerance justified by `halsampler` printed precision. Then independently verify final clipping and final-saturation bits against `U_MAX=2.0`.

Do **not** calculate `common_expected` directly from same-row sampled post-update `y1/y2`.

## Architecture-A causal interpretation

The same-row identities among latched command-side quantities remain valid:

```text
pid1_ref = r1 - corr_applied
pid2_ref = r2 + corr_applied
```

because those quantities were all formed before the plant update and retained unchanged through sampling.

However, any claim relating that bias algebraically to same-row sampled `y1/y2` must account for the fact that sampled plant position is post-update. Joint motion ferror is an independent motmod witness calculated earlier in the servo cycle from the feedback that motion had at its own input-processing point. Report its observed value; do not pretend it is a same-instant algebraic function of the post-update plant sample.

## Architecture-B causal interpretation

The B/P6 discriminator remains directly same-row valid because stock PID saturation state, post-PID correction, pre-limit effort, final effort and final-saturation bits are all control/output witnesses for that cycle. The required discriminator remains:

```text
final_saturation == true
AND corresponding stock_pid_saturated == false
```

for at least one active P6 row, otherwise a valid fixture is **INCONCLUSIVE**.

## Other analyzer checks

The retained analyzer's `corr_req == e_diff_used` check is causally aligned because both are latched from the same pre-update state in `prepare`.

Final clamp/saturation recomputation is aligned because `prelimit`, `final` and final-saturation state are formed together before sampling.

State metrics using sampled `y1/y2` remain valid as sampled state metrics; they simply represent the post-update plant state for each retained cycle. Event interpretation must preserve that ordering.

## Audit discipline

This correction is an evidence-quality improvement required by the pre-existing rule that sequential realtime state updates must not be interpreted as simultaneous algebraic plant equations.

If 077 later fails a provenance/topology/recorder/construction check, it remains **HARNESS INVALID** and this correction creates no behavioral verdict. If the fixture is valid but B/P6 does not expose the frozen downstream-only saturation discriminator, the classification remains **INCONCLUSIVE** with no retuning.
