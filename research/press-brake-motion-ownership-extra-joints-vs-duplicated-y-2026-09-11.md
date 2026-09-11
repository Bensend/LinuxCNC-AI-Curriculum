# Press-brake motion ownership — extra joints versus duplicated Y joints

Date: 2026-09-11

Status: **RESEARCH / SOURCE ANALYSIS — architecture discriminator established; no physical-machine prescription**

Course context: 4600 Press Brakes preparation while F02 remains blocked on information-separated S02/E20/X01/X02 handoffs.

Pinned LinuxCNC source for source-level claims: `8bf4605ae81042248add031e94c77300406e0413`.

## Why this question matters

Recent LinuxCNC press-brake builders have explored both ordinary motion/joint ownership and custom realtime press-state components. One current retrofit discussion also considers LinuxCNC `extra joints` for machine mechanisms. For a tandem hydraulic ram, however, `extra joints` and duplicated-coordinate joints have materially different motion semantics. Treating them as interchangeable would erase exactly the independent following-error/feedback behavior that PB-PREP-001 is studying.

This note separates documented/source-confirmed LinuxCNC behavior from community architecture experience.

## Official documentation findings

### Duplicated coordinates

Current `kins(9)` documentation says `trivkins` may duplicate an axis letter, for example `coordinates=xyyzw`, assigning two joints to one Y coordinate. `kinstype=B` / KINEMATICS_BOTH supports joint-mode independent movement and coordinated world-mode movement. The documentation explicitly presents this as a gantry-style multiple-joints/one-coordinate arrangement.

Sources:

- https://linuxcnc.org/docs/html/man/man9/kins.9.html
- https://www.linuxcnc.org/docs/html/motion/kinematics.html

Classification: **DOC-CONFIRMED**.

### Extra joints

Current `motion(9)` documentation says `num_extrajoints` joints participate in homing but are not used by the kinematics transformations. After homing, control transfers to `joint.N.posthome-cmd`; motor feedback is ignored by motion, and the extra joints require their own independent planner/controller.

Source:

- https://linuxcnc.org/docs/html/man/man9/motion.9.html

Classification: **DOC-CONFIRMED**.

## Pinned-source trace

### Coordinated kinematics excludes extra joints

`src/emc/motion/control.c` at `8bf4605ae81042248add031e94c77300406e0413` uses `NO_OF_KINS_JOINTS` when copying inverse-kinematics output into joint structures and when interpolating coordinated joint commands. This is distinct from `ALL_JOINTS`.

Relevant path:

`tpRunCycle -> tpGetPos -> kinematicsInverse -> for joint_num < NO_OF_KINS_JOINTS -> cubicAddPoint -> cubicInterpolate -> joint->pos_cmd`

Classification: **SOURCE-CONFIRMED**.

### Homed extra-joint output authority transfers to `posthome-cmd`

In `control.c::output_to_hal()`, ordinary joint output first forms `motor_pos_cmd` from `joint->pos_cmd + backlash_filt + motor_offset`. The homed-extra-joint branch then overrides the exported motor command with:

```text
joint.N.motor-pos-cmd = joint.N.posthome-cmd + motor_offset
```

and continues out of the joint loop.

The corresponding extra-joint HAL pin is exported by `motion.c::export_extrajoint()`.

Classification: **SOURCE-CONFIRMED**.

### Homed extra-joint following error is deliberately not a motion discriminator

The pinned control implementation special-cases following error:

```text
if (IS_EXTRA_JOINT(joint_num) && get_homed(joint_num))
    joint->ferror = 0; // not relevant for homed extrajoints
else
    joint->ferror = joint->pos_cmd - joint->pos_fb;
```

Therefore a homed extra joint does not preserve the ordinary motion-level `pos_cmd - pos_fb` following-error semantics that PB-PREP-001 relies on for independently supervised Y1/Y2 sides.

Classification: **SOURCE-CONFIRMED**.

## Architecture consequence

### Duplicated-Y ram interpretation

A `trivkins coordinates=...YY... kinstype=BOTH` architecture gives two kinematic joints a common Cartesian Y request while retaining per-joint command/feedback state. This is the software topology already used by PB-PREP-001 to ask whether differential correction consumes motion following-error margin.

Classification: **SOURCE-CONFIRMED for LinuxCNC topology; INFERENCE for press-brake suitability**.

### Extra-joint ram interpretation

A homed extra joint is intentionally outside coordinated inverse kinematics after homing, takes its motor command from `posthome-cmd`, and has motion following error forced irrelevant. A design may still build a perfectly capable external controller around those pins, but it is no longer asking LinuxCNC motion to supervise that side with the same per-joint ferror semantics as a duplicated kinematic joint.

Classification: **SOURCE-CONFIRMED for LinuxCNC behavior; INFERENCE for architecture tradeoff**.

### Current working discriminator

Do **not** treat `num_extrajoints` as a drop-in synonym for duplicated Y1/Y2 ram joints in the 4600 playbook. Before selecting it for a tandem ram, the architecture must explicitly answer who owns:

1. common Y trajectory generation;
2. each side's position command;
3. independent feedback comparison;
4. following-error/fault authority after homing;
5. differential synchronization correction;
6. coordinated disable/recovery behavior.

By contrast, extra joints may be a much more natural fit for genuinely independent auxiliary mechanisms that need LinuxCNC homing integration but are subsequently commanded by another planner/controller—for example some backgauge auxiliary axes. That is an **INFERENCE**, not yet a prescribed 4600 design rule.

## Community evolution leads

### Accurpress / “Vertical Press Brake interface and comp”

Forum thread:

- https://forum.linuxcnc.org/show-your-stuff/45716-vertical-press-brake-interface-and-comp

The builder reported an early large custom component/state-machine approach for ram/backgauge control, then later moved the axes under LinuxCNC MOTION after repeated control iterations, reporting smoother/more stable behavior and using G-code for sequencing. This is useful architectural experience but is **COMMUNITY-REPORTED**, not a source-level guarantee.

Reusable question spawned: when does a custom press-state component coordinate LinuxCNC-owned motion versus replace too much motion ownership?

### Ursviken Pullmax Optima 130 retrofit

Forum thread:

- https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

The current retrofit reports Y1/Y2 ram axes with separate servo valves plus hydraulic mode spool valves and a proportional pressure/tonnage control, alongside X/R/Z-style backgauge axes. The discussion evolved from a larger custom `pullmax` component toward separating press sequencing from lower-level motion/servo ownership after homing and valve-coordination difficulties.

The important generalizable lead is not the builder's exact wiring. It is that press-state sequencing, hydraulic-mode selection, coordinated motion ownership, homing, and closed-loop actuator control have different responsibilities and become harder to reason about when collapsed into one monolithic component.

Classification: **COMMUNITY-REPORTED**; requires source/test reconciliation before becoming a generic design rule.

## Function / call-flow summary

### Duplicated kinematic joint path

```text
Task / motion request
  -> trajectory planner
  -> Cartesian commanded pose
  -> kinematicsInverse()
  -> duplicated coordinate maps same Cartesian Y to multiple kinematic joints
  -> per-joint cubic interpolation / joint->pos_cmd
  -> per-joint motor-pos-cmd
  -> external servo / plant
  -> distinct joint.N.motor-pos-fb
  -> per-joint pos_fb / ferror processing
```

### Homed extra-joint path

```text
LinuxCNC homing owns extra joint until homed
  -> after homing, coordinated inverse kinematics excludes extra joint
  -> external planner/controller writes joint.N.posthome-cmd
  -> output_to_hal overrides joint.N.motor-pos-cmd from posthome-cmd + offset
  -> motion following-error is explicitly not relevant for that homed extra joint
```

The second path can still be closed-loop outside motmod, but the feedback/fault authority must be supplied and verified there rather than assumed to remain LinuxCNC motion's ordinary joint ferror mechanism.

## Adversarial checks

- **Misleading premise:** “Both mechanisms export `joint.N.motor-pos-cmd`, so duplicated Y and extra joints are equivalent.” **Rejected.** Command ownership and ferror semantics differ after homing.
- **Failure-path question:** If a homed extra joint's external controller commands motion while its encoder freezes, ordinary motion following error cannot be assumed to trip from that joint because the source deliberately treats homed-extra-joint ferror as irrelevant. The external control/diagnostic design must provide an appropriate feedback-validity/fault mechanism.
- **Version boundary:** These source conclusions are pinned to `8bf4605ae81042248add031e94c77300406e0413`. Current documentation agrees conceptually, but later source must not be silently assumed identical.
- **Safety boundary:** None of these software mechanisms is evidence of functional-safety suitability. Hydraulic descent prevention, redundant monitoring, guarding, safety PLC/relay architecture, valve safety category, stopping behavior, and pressure hazards remain separate physical/safety engineering work.

## Claims ledger

| Claim | Classification | Evidence | Confidence | Next verification |
|---|---|---|---|---|
| `trivkins` can map one coordinate to multiple joints | DOC-CONFIRMED / SOURCE context | `kins(9)` + PB-PREP pinned topology | High | No immediate blocker |
| Extra joints are outside kinematics after homing | DOC-CONFIRMED / SOURCE-CONFIRMED | `motion(9)`, `control.c` loops bounded by `NO_OF_KINS_JOINTS` | High | Add focused software fixture only if a 4600 architecture actually proposes extra-joint ram control |
| Homed extra-joint command comes from `posthome-cmd` | DOC-CONFIRMED / SOURCE-CONFIRMED | `control.c::output_to_hal`, `motion.c::export_extrajoint` | High | None needed for current discriminator |
| Homed extra-joint ordinary motion ferror is not active | SOURCE-CONFIRMED | `control.c` special case sets ferror 0 | High | Inspect any later stable revision selected for 4600 implementation |
| Duplicated-Y is therefore automatically the best physical press-brake architecture | UNKNOWN / deliberately not claimed | Software evidence cannot establish hydraulic/safety suitability | — | Requires full 4600 architecture and machine-domain evidence |
| Backgauge auxiliaries may fit extra-joint semantics better than tandem ram sides | INFERENCE | semantics above | Medium | Compare against real public configs and needed coordinated-programming behavior |

## Next-work checkpoint

1. Finish and independently audit PB-PREP-001 077 under its already frozen raw-evidence audit; do not retune the experiment.
2. For 4600 architecture research, trace the exact pinned `motor-pos-fb -> pos_fb -> ferror/fault` path for ordinary kinematic joints beside the extra-joint special case, and trace duplicated-coordinate fanout through pinned `trivkins`/`kins_util.c` if not already fully captured by prior D01/PB-PREP artifacts.
3. Mine at least two additional public press-brake implementations for how they divide motion ownership, press/hydraulic sequencing, homing, and backgauge control.
4. Keep “ram duplicated joints versus external/extra-joint control” open until those architecture comparisons are reconciled. Do not turn the present discriminator into a physical-machine prescription.
