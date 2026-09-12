# LinuxCNC axis-brake authority example — demo Mazak

Date: 2026-09-12
Evidence class: **SOURCE-CONFIRMED EXAMPLE / NOT GENERIC POLICY**
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Why inspect this

The Ursviken press-brake field failure showed why a controller must not assume a mechanically braked axis still has actuator authority. To avoid turning that field report directly into a design prescription, this pass looked for an independent in-tree LinuxCNC configuration that actually coordinates an axis brake with amplifier state.

## Source

`configs/attic/demo_mazak/demo_mazak.hal`

This is an historical/attic machine configuration. It is useful as an inspectable topology example, **not** as current universal best practice.

## Relevant topology

The configuration exports a common `servo-enable` signal from `joint.0.amp-enable-out` to the servo amplifier enable output. It reads X/Y/Z amplifier-running inputs separately. The Z amplifier-running signal is then also used to drive the Z-axis brake-release output:

- amplifier-running state is observed from hardware input;
- Z brake release follows the observed Z-amplifier-running signal;
- derived amplifier fault signals are separately presented to `joint.N.amp-fault-in`;
- motion has its own higher-level `motion.enable` interlock.

This is a materially different ownership shape from simply commanding the brake open whenever position error is nonzero or whenever a PID output exists.

## What the example establishes

At least one real LinuxCNC configuration explicitly made brake state depend on a drive/amp authority-related hardware observation rather than assuming the position controller itself proved actuator availability.

That corroborates the generic 3600 lesson from the Ursviken R-axis failure and pinned `pid.c` source:

`controller demand` and `physical actuator authority` are different signals and should be represented separately when the machine requires that distinction.

## What the example does not establish

It does not establish:

- correct brake timing for a press brake or backgauge;
- safety-rated brake control;
- whether amplifier-running should be the release predicate on another machine;
- a universal release-before-enable or enable-before-release sequence;
- acceptable drift, stopping distance, motor current or thermal limits;
- recovery behavior after brake/drive disagreement.

Those are machine-specific engineering and commissioning questions.

## Call-flow relevance

The example makes the ordinary-control layers visible:

`joint amplifier-enable request -> physical amplifier state observation -> brake output`

while amplifier fault and motion enable remain separate paths. That is exactly the kind of explicit authority provenance a press-brake backgauge or hydraulic actuator layer should preserve.

## Adversarial check

> Because demo Mazak releases the Z brake from amplifier-running, every LinuxCNC braked axis should do the same.

Reject. The file proves one inspectable machine topology only. The transferable lesson is separation and observation of authority, not the exact Boolean predicate or timing.

## Curriculum consequence

No additional synthetic brake/PID experiment is warranted. The combined evidence now includes:

1. a real press-brake field failure when mechanical authority and controller demand diverged;
2. pinned stock `pid.c` proving internal saturation/anti-windup cannot observe downstream authority;
3. an independent in-tree machine example that explicitly wires drive-state observation into brake release.

This is sufficient for the generic 3600 ownership lesson while keeping machine-specific timing/thresholds unclaimed.
