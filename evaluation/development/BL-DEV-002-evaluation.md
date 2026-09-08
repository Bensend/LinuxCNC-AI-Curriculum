# BL-DEV-002 evaluation — motion following-error threshold

Date UTC: `2026-09-08`

Blind validity: **VALID**

Precommit: `evaluation/development/BL-DEV-002-precommit.md`, committed before oracle inspection.

Pinned oracle revision: `8bf4605ae81042248add031e94c77300406e0413`

## Oracle

Pinned `src/emc/motion/control.c` computes the active limit as:

```text
if vel_limit > 0:
    ferror_limit = max_ferror * abs(vel_cmd) / vel_limit
else:
    ferror_limit = 0

if ferror_limit < min_ferror:
    ferror_limit = min_ferror

if abs_ferror > ferror_limit:
    set joint following-error flag
else:
    clear it
```

For the challenge values:

```text
max_ferror = 1.0 in
abs(vel_cmd) = 2.0 in/s
vel_limit = 4.0 in/s
raw velocity-scaled limit = 0.5 in
min_ferror = 0.01 in, so clamp does not alter it
abs_ferror = 0.30 in < 0.50 in
```

Therefore the learner's top-level prediction **NO TRIP at that instant** is correct.

## Discrepancy

The learner remembered the threshold as interpolation between `MIN_FERROR` and `FERROR`:

```text
MIN_FERROR + fraction * (FERROR - MIN_FERROR)
```

That would yield `0.505 in`, but pinned source instead scales `FERROR` directly by velocity fraction and only afterward floors the result at `MIN_FERROR`, yielding exactly `0.5 in` here.

This is a mechanism-level precision miss, not an outcome miss. It matters most at low/intermediate velocity where the two formulas can differ materially.

## Score

| Dimension | Score | Rationale |
|---|---:|---|
| Prediction / diagnosis | 2/2 | Correct no-trip prediction. |
| Mechanism | 1/2 | Correct velocity-dependent concept but wrong exact interpolation formula. |
| Diagnostic efficiency | 2/2 | Proposed the direct pinned motion source path and the relevant branch/variables. |
| Uncertainty / safety boundary | 2/2 | Correctly separated ordinary LinuxCNC fault handling from safety-rated position monitoring. |
| Confidence calibration | 2/2 | 88% was reasonable for a correct outcome with a modest mechanism-memory risk. |
| **Total** | **9/10** | |

Primary error class: **retrieval precision / incorrect source interpretation of the exact formula**.

## Minimal correction required

Do not teach a generic endpoint interpolation formula. The durable retrieval cue should be:

```text
ferror_limit = max(MIN_FERROR,
                   FERROR * abs(vel_cmd) / joint_vel_limit)
```

for the inspected pinned path, with the ordinary version-scope caveat.

The correction should also emphasize the strict comparison: the flag is set when `abs_ferror > ferror_limit`, not merely when equal.

## Transfer requirement

Because this was a partial mechanism miss, schedule a **novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons**, using different values or a low-speed case where direct-scaling-plus-floor and endpoint interpolation produce noticeably different predictions. Do not repeat this surface problem immediately.
