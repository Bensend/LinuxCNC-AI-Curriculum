# 3600 Press Brake — Measurement-Only QtVCP/HAL Display Path

Date: 2026-09-12
Status: DEPENDENCY-SAFE PINNED-SOURCE IMPLEMENTATION NOTE
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Question

If a press-brake angle/geometry scale is measurement-only, how can an HMI display it without inventing a commanded LinuxCNC joint merely to obtain a DRO widget?

## Pinned-source answer

At the curriculum’s pinned LinuxCNC revision, `lib/python/qtvcp/widgets/hal_label.py::HALLabel` is a native QtVCP widget that creates a HAL **input** pin. The widget can be configured for HAL bit, float or s32 input; for a float pin, `value_changed` drives formatted display text through `_setText()`. It also allows an explicit pin name rather than forcing an axis/joint identity.

Therefore a measurement-only transducer has a native HMI route:

```text
physical sensor
 -> hardware driver / HAL producer
 -> scaling / validity logic as appropriate
 -> HAL signal
 -> QtVCP HALLabel float input (or custom widget/handler)
 -> formatted operator display
```

No fake W axis or dummy commanded joint is required merely to show a number.

## Important limitation

`HALLabel` formats and displays the incoming value; that alone does **not** supply the curriculum’s required freshness/provenance contract. A production press-brake UI should not collapse:

- measurement value;
- measurement validity/fault;
- freshness/generation;
- current BendStep/ExecutionEpisode association;
- phase qualification;
- correction acceptance state

into one numeric label.

A practical QtVCP design can display the numeric measurement through a HAL float input while exposing validity/stale/fault/provenance through separate pins/widgets and handler logic. The exact UI design remains application-specific.

## Why this is preferable to a fake joint

A LinuxCNC joint/axis implies command/reference/motion semantics. `HALLabel` demonstrates that HMI display convenience is not a technical reason to give those semantics to a measurement-only channel. This directly answers the representation problem seen in the public press-brake “Measurement Only Axes” discussion.

## Evidence classification

- `HALLabel` accepts HAL float input and updates display text: **SOURCE-CONFIRMED** at the pinned revision.
- Using a HAL measurement signal + independent validity/provenance state for press-brake angle display: **ENGINEERING INFERENCE**, consistent with the pinned widget interface and the established 2000/3600 freshness contracts.
- A specific production screen layout or operator color scheme: **OUT OF SCOPE / NOT ESTABLISHED**.

## Adversarial check

A green `90.0°` label is still not physical-truth evidence unless the UI separately establishes that the measurement is current, valid, belongs to the active bend/episode and is meaningful in the current process phase. Display transport and physical truth remain different authorities.
