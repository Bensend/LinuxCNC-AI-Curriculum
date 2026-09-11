# Ursviken Pullmax Optima — tandem Y1/Y2 field architecture trace

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 COMMUNITY/FIELD-EVIDENCE AUDIT**

## Purpose

Preserve the strongest currently located public evidence for a real LinuxCNC tandem press-brake Y1/Y2 control architecture while keeping the evidence class honest. This case is directly relevant to independent left/right linear feedback and differential synchronization, but the final working machine configuration has not yet been located as downloadable HAL/COMP/source.

## Public provenance

LinuxCNC forum build diary:

`Ursviken Pullmax Optima 130 press brake retrofit with 4 axis backgage`

https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

Useful chronological pages:

- page 1: machine architecture and initial LinuxCNC plan
- page 3: February 2026 architecture split between press state and machine-specific hydraulic interface
- page 4: first closed-loop Y1/Y2 tests and July 2026 successful-bend report

The author is forum user NWE. This artifact treats the posts as community/field evidence. It does not silently upgrade forum descriptions into source-confirmed implementation facts.

## Machine/control problem exposed by the diary

The retrofit has independent left/right ram control (Y1/Y2), multiple backgauge axes, proportional/servo hydraulic valves, discrete hydraulic spool logic, pressure/tonnage control and pedal-sensitive press sequencing.

The diary is valuable because the architecture changed as the author encountered actual LinuxCNC ownership problems rather than presenting a polished design after the fact.

## Architecture evolution

### Initial direction — use LinuxCNC motion services rather than recreate them all

The early discussion considers Y1/Y2 plus X/R/Z-style backgauge motion and the use of LinuxCNC joints/extra joints for axis behavior and homing. The author explicitly wanted LinuxCNC to supply mature motion/homing services instead of rebuilding every generic CNC behavior in a monolithic press controller.

This contrasts usefully with the Accurpress case, where removing MOTMOD moved homing/jogging into the custom press component and left homing as a long-lived field weakness.

**Evidence:** COMMUNITY-REPORTED architecture intent.

### February 2026 — monolithic machine component judged too high in the stack

By February 2026 the author identifies a practical ownership problem: a large `pullmax` component sitting above too much of the control stack interferes with using LinuxCNC's normal homing/motion behavior cleanly.

The proposed redesign separates:

1. a generic/reusable press-state layer for press-cycle semantics; and
2. a machine-specific `pullmax-optima` hydraulic/hardware interface placed around the lower-level joint/PID command surfaces.

The machine-specific interface can observe command polarity, pedal/state requests and set the actual spool/route valves required by this hydraulic manifold, while the PIDs remain responsible for proportional valve command.

A later post sketches semantic command surfaces such as common Y position/velocity/tonnage and a motion-type request, with the expectation that different press makes/models would implement different hydraulic decoders.

This independently reinforces the curriculum's layered-interface conclusion:

- common press-cycle intent should not be the same thing as machine-specific valve truth tables;
- generic LinuxCNC motion ownership should remain explicit;
- hydraulic decoding is inherently machine-specific.

**Evidence:** COMMUNITY-REPORTED design reasoning, not source-confirmed runtime behavior.

## First closed-loop tandem testing — February 13, 2026

The author reports a first closed-loop test using separate left/right ram loops. The post describes left and right ram valve commands and position/velocity PID paths and reports that the two sides synchronized reasonably, although the hydraulic system was still noisy/groaning and tuning was clearly incomplete.

This establishes that independent side control was being exercised on the physical machine, but it is not the mature architecture result.

**Evidence:** COMMUNITY-REPORTED physical test.

## July 2026 — electronic synchronization replacing hydraulic flow-divider behavior

By July 20, 2026 the author reports that the two Y servo valves are tee-fed from the pump and that the previous flow-divider function is being emulated electronically in LinuxCNC/HAL.

On July 22, 2026 the author reports bending an approximately 1.5 in × 10 in × 3/16 in steel piece to 90 degrees and says the current control works.

The reported final Y synchronization concept is:

- one position PID for Y1;
- one position PID for Y2;
- one additional synchronization PID;
- sync PID command = zero;
- sync PID feedback = Y1 minus Y2;
- synchronization action slows whichever side is ahead.

That is the strongest located real-machine evidence for the general concept of maintaining common position control while separately controlling differential error.

**Evidence:** COMMUNITY-REPORTED field operation. The bend result is a physical outcome reported by the builder, not independently reproduced by this curriculum.

## What this does prove for the curriculum

It supports these bounded conclusions:

1. A real LinuxCNC tandem press-brake builder has successfully used **independent side position control plus a separate differential synchronization loop** on a physical machine.
2. Differential synchronization is treated as a distinct control concern from common ram position.
3. The reported correction strategy is asymmetric in effect: it slows the side that is ahead rather than simply treating a common Cartesian Y value as sufficient.
4. Real hydraulic/manifold decoding remained machine-specific and motivated separation from higher-level press-cycle logic.
5. The project reinforces that Y1/Y2 synchronization, common motion, hydraulic mode selection and press-cycle sequencing are different ownership layers even when they execute in the same realtime system.

## What this does NOT prove

The forum report does **not** establish:

- the exact HAL expression implementing the Y1−Y2 signal;
- whether the synchronization PID correction is injected before each position PID, after it, as a command offset, as a velocity reduction, or through another limiter/mux arrangement;
- exact gains, anti-windup behavior, derivative/filter settings or units;
- exact final command saturation/authority allocation;
- whether stock `pid.*.saturated` can see all downstream limiting;
- per-side MOTMOD following-error ownership in the final configuration;
- exact realtime `addf` ordering;
- behavior under one-side authority exhaustion, frozen feedback or communication faults;
- functional-safety architecture or performance level;
- general suitability of the same control law for another press.

Therefore this case **cannot** be labeled architecture A, B or C from PB-PREP-001 without the actual final nets/source. “Two position PIDs plus a sync PID” is not enough information to identify the correction insertion point.

## Relationship to PB-PREP-001

PB-PREP-001's synthetic A/B/C comparison ended **INCONCLUSIVE / no architecture recommendation** because the pre-frozen B/P6 discriminator was not exercised. This field report does not rescue or override that result.

The Ursviken case provides a new independent research lead:

> A field-proven builder found value in a differential sync loop that modifies side behavior while retaining independent position loops.

But until the actual final HAL/source is available, PB-PREP-001 questions about pre-PID/post-PID correction, final saturation visibility and authority exhaustion remain unresolved.

The correct evidence relationship is:

- PB-PREP-001: controlled synthetic experiment, inconclusive for architecture preference;
- Ursviken diary: real-machine community evidence that separated differential synchronization can work;
- future source/config audit: needed to determine the exact final command topology and failure witnesses.

## Source-availability check

As of this 2026-09-11 audit:

- the July 22 post says the author intends to share the configuration after remaining loose ends are addressed;
- no final downloadable Y1/Y2 configuration was found in the inspected build-diary pages;
- a bounded GitHub code search for `pullmax_optima` did not locate a public implementation.

This is a **negative search result**, not proof that no copy exists anywhere. It prevents the curriculum from fabricating source-level certainty from the forum prose.

## Mapping against the layered press-brake contract

| Layer | Ursviken evidence | Confidence |
|---|---|---|
| press-cycle coordinator | explicit press-state concept, pedal-sensitive realtime behavior | COMMUNITY-REPORTED, strong |
| LinuxCNC motion/joint owner | deliberate attempt to retain LinuxCNC motion/homing services | COMMUNITY-REPORTED |
| Y1/Y2 synchronization/final allocation | two side position PIDs + one Y1−Y2 sync PID, slows leader | COMMUNITY-REPORTED field result; exact insertion UNKNOWN |
| machine-specific hydraulic decoder | explicit `pullmax-optima` machine interface concept for spool/manifold behavior | COMMUNITY-REPORTED, strong architecture evidence |
| electrical/drive boundary | proportional servo-valve command surfaces described | COMMUNITY-REPORTED |
| functional safety | discussion exists, but no safety validation established by this audit | UNKNOWN / do not infer |

## Adversarial architecture check

### Misleading premise

> “The Ursviken builder says there are two position PIDs and one sync PID, so this proves PB-PREP-001 architecture C is the right design.”

**Reject.** The post establishes the existence and physical usefulness of a separate differential loop, but it does not expose enough final HAL/source to locate exactly where that correction enters relative to the two position controllers, command limiting and actuator saturation. It cannot discriminate the PB-PREP A/B/C structures.

### Failure-path question

> “If Y1 and Y2 are nearly equal, the beam is therefore at the commanded bend position.”

**Reject.** Small differential error proves only relative agreement. Both sides can agree while both are wrong relative to common trajectory. Independent common-position/following-error evidence is still required.

### Diagnostic-order question

If a later posted configuration becomes available, the first source audit should trace, in order:

1. producer of each physical Y scale;
2. producer of each nominal side position command;
3. producer and sign of the Y1−Y2 sync error;
4. exact consumer/insertion point of sync PID output;
5. every limiter/mux between position PID outputs and final valve commands;
6. final-side saturation/authority witness;
7. servo-thread function order;
8. per-side motion/following-error ownership;
9. disable/fault behavior when synchronization authority is exhausted.

Do not begin by copying gains.

## Correction to 4600 research strategy

The search priority should now be **architecture provenance before simulation depth**. The curriculum already has enough generic control theory to know that differential correction can be modeled many ways. What is more valuable now is identifying how successful real LinuxCNC press-brake builds actually partition trajectory, side loops, differential authority and hydraulic decoding—and where their field failures occurred.

This directly supports the user's earlier observation that the curriculum should prefer established engineering principles and real implementation evidence over unnecessary simulation of every step.

## Precise next-work checkpoint

1. Continue a bounded search for a later public Ursviken/Pullmax config or attachments posted after the July 22 success report. If found, audit the exact Y1/Y2 sync insertion, limits and realtime order.
2. If no final source is public, preserve this case as **COMMUNITY-REPORTED FIELD SUCCESS / SOURCE UNAVAILABLE** and do not spend repeated sessions searching the same surface.
3. Compare at least one other tandem/Y1-Y2 press implementation so the 4600 course does not overfit one builder's architecture.
4. Preserve PB-PREP-001 as INCONCLUSIVE; do not retune its frozen experiment after this field evidence.
5. Keep S02/E20/X01/X02 information-separated handoffs pending and F02 blocked until those independent evaluations occur.
