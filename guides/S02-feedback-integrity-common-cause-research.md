# S02 — feedback integrity, diversity and common-cause research

Status: RESEARCH / pre-freeze
Date: 2026-09-09
Pinned source baseline inherited from D01: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413` for source claims unless superseded by an explicit version matrix.

## Why S02 exists

D01 proved that per-joint software feedback is necessary evidence for duplicated-joint disagreement, but it did not prove that any feedback channel is physically truthful. S02 therefore treats **value**, **freshness**, **validity**, **independence**, and **physical truth** as separate properties.

## Pinned HostMot2 encoder source findings

`src/hal/drivers/mesa-hostmot2/encoder.c` exposes optional quadrature-sequence error handling. When `quadrature_error_enable` is true, the driver reports the FPGA quadrature-error state; when disabled it reports the HAL error pin false. The source describes the encoder module as supporting index/index-mask and velocity estimation and separately publishes A/B/index input states.

Important boundary: quadrature-sequence checking is not a general encoder-health oracle. An illegal A/B transition can be evidence of a signal/counting problem, but absence of such an error does not establish that the encoder is connected, moving when the plant moves, mechanically coupled to the intended member, correctly scaled, fresh, or independent of another channel.

The current source review has not identified a generic per-encoder `fresh`/`valid` pin that proves new physical information arrived in the current servo cycle. A numerically unchanged position can mean legitimately stationary hardware or a frozen/stale/disconnected measurement; value equality alone cannot distinguish those cases.

## Community evidence to preserve as non-authoritative leads

LinuxCNC forum discussion with Mesa developer PCW characterizes HostMot2 quadrature error detection as intentionally limited: it checks illegal transitions (roughly simultaneous A/B changes), is disabled by default, and must be connected in HAL to affect machine behavior. The same discussion says gross encoder errors are normally expected to become following errors, while quadrature checking is useful for noise/miscount problems. This reinforces—without elevating forum statements to source authority—that quadrature error and following error cover different symptom classes.

A 2025 community failure report describes one encoder input influencing another even with an encoder disconnected; the diagnosis focused on multiplexing/cable/card faults. This is a useful common-cause/adversarial pattern: two software channels can become correlated by shared acquisition infrastructure, so agreement/correlation does not prove independent physical sensing.

Other community reports show wiring, signal-level, filter and noise faults affecting encoder behavior. These are scenario-generation evidence, not proof of universal failure semantics.

## Authority model

```text
physical member pose
    -> mechanical coupling
    -> encoder transducer
    -> electrical A/B(/index) signals
    -> shared/independent input conditioning and acquisition
    -> HostMot2 count / error state
    -> LinuxCNC HAL position/velocity/error values
    -> motion joint feedback / ferror logic
    -> diagnostics and ordinary motion authority
```

A downstream value cannot authenticate all upstream arrows merely because it is plausible.

### Required distinctions

- **Value plausibility:** number lies in an expected range.
- **Freshness:** evidence establishes whether new source information has arrived within a defined bound.
- **Validity:** channel-specific diagnostics do not indicate a known-invalid condition.
- **Diversity/independence:** channels do not share every relevant failure cause.
- **Physical truth:** actual machine geometry/state; software-only evidence can bound claims about it but cannot silently substitute for independent physical evidence.

## Initial adversarial classes

1. **Differential disagreement:** one channel changes relative to another. Software comparison can detect this if both values are available and thresholds/time semantics are justified.
2. **Frozen/stale channel:** one channel holds a plausible old value. Differential monitoring may detect it only when the other side or commanded/plant state changes enough; at standstill, equality does not prove freshness.
3. **Common-mode false agreement:** both software channels report mutually consistent but wrong values because of shared acquisition, scaling, mechanical reference, wiring/mux, or model faults. Pure comparison of those two channels cannot prove the fault absent.
4. **Illegal quadrature/noise:** quadrature-error evidence may detect a subset of signal faults, but absence of that flag is not a general validity/freshness proof.
5. **Mechanical decoupling:** encoder remains electrically healthy while losing truthful coupling to the controlled member. Electrical diagnostics alone cannot authenticate the physical geometry.

## Pre-freeze questions

- Which HostMot2/transport-level surfaces can bound freshness of an entire board read, and which are only transport health rather than per-encoder physical freshness?
- What exact quadrature-error semantics exist across the pinned source and relevant Mesa firmware versions?
- Can a software-only fixture distinguish stale-channel behavior without smuggling in an independent oracle? If so, what oracle is legitimate (injected ground truth is acceptable for a model experiment but must remain explicitly synthetic)?
- What minimum diversity claim can be taught without hardware-specific assumptions?

## Experiment-freeze requirements

Before S02 implementation, freeze a model with at least three causes that can share coarse symptoms:

- ordinary differential disagreement;
- a stale/frozen feedback channel;
- common-mode false agreement where both reported feedback channels agree while modeled physical geometry is wrong.

The frozen gates must force the learner to state which cause is detectable from existing LinuxCNC feedback alone, which needs explicit freshness/validity evidence, and which is fundamentally unobservable without an independent physical/diverse reference. The common-mode case must not be allowed to pass merely because `feedback_A == feedback_B` or because Cartesian/following-error state is clean.

No S02 software experiment may claim functional-safety coverage or real-machine sensor independence.
