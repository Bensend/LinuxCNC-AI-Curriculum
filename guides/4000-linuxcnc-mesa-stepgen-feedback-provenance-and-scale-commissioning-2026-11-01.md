# Practical 4000 guide — Mesa stepgen feedback provenance, scaling and a real mill
**Read-only commissioning/diagnostic walkthrough. 2026-11-01. Not a physical machine acceptance or personnel-safety procedure.**

## Two feedback loops that look alike but prove different things
[STEPGEN-97](../research/4400_LINUXCNC_STEPGEN_97_MESA_POSITION_FEEDBACK_VS_PHYSICAL_AXIS_MR1_SOURCE_AUDIT_2026-11-01.md) traces LinuxCNC's HostMot2 16.16 FPGA step accumulator to `stepgen.N.position-fb`. [STEPGEN-98](../research/4400_LINUXCNC_STEPGEN_98_LIVE_SCALE_FEEDBACK_DISCONTINUITY_AND_ACCUMULATOR_WRAP_SOURCE_AUDIT_2026-11-01.md) traces live scaling and wrap. The official [HostMot2 manpage](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html) names pins and parameters; the pinned source defines their actual producer.

**Open-loop motor, closed-loop pulse generator:** `joint.motor-pos-cmd → [optional PID] → hm2.stepgen.velocity-cmd → FPGA step accumulator → hm2.stepgen.position-fb → joint.motor-pos-fb`. This closes a numerical loop around generated steps, **not** measured table displacement. The driver publishes `velocity-fb` from its limited velocity command, not from a separate encoder.

**Independent axis feedback:** `joint.motor-pos-cmd → controller/drive → actuator`; a separate axis encoder/scale → `joint.motor-pos-fb` (and the appropriate PID feedback when closed-loop control is intended). The actuator/feedback design, tuning, wiring and failure response must be engineered for the specific drive. Do not blindly replace HAL nets on a running machine.

## Real configuration inspection, reproducible without equipment
1. Open the public [MR-1 7i96S HAL at commit a41576f](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal). At lines 22–34, confirm `hm2.read` runs before motion/PID and `hm2.write` after.
2. At lines 73–119, trace `x-pos-cmd` from `joint.0.motor-pos-cmd` to `pid.x.command`, `x-pos-fb` from `hm2_7i96s.0.stepgen.00.position-fb` to **both** `pid.x.feedback` and `joint.0.motor-pos-fb`, and `pid.x.output` to `stepgen.00.velocity-cmd`. The HAL calls this section “closedloop stepper signals”; its *feedback provenance* is still the step accumulator.
3. At lines 317–339, trace the independent `encoder.00` to the **spindle**, not the X joint. Do not infer an X encoder from the presence of a Mesa encoder instance elsewhere in the HAL.
4. Contrast upstream [`hm2-stepper-rpspi.hal`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/configs/by_interface/mesa/hm2-stepper/hm2-stepper-rpspi.hal) lines 73–79: `joint.0.motor-pos-cmd → stepgen.00.position-cmd`, `stepgen.00.position-fb → joint.0.motor-pos-fb`, with **no external encoder**. Position-control and velocity-control modes are distinct, but both examples return generated-step position.
5. Review `[JOINT_0]STEP_SCALE`, `STEPLEN`, `STEPSPACE`, `STEPGEN_MAX_VEL`, `STEPGEN_MAXACCEL` against drive input specifications and machine kinematics; **do not infer physical velocity capacity** from the FPGA pulse ceiling.

## Inspectable numeric example (not an execution)
Assume 200 commanded steps/mm and `steplen=2500 ns`, `stepspace=2500 ns`. The source computes a timing-only ceiling of `1e9/(2500+2500)=200,000 steps/s`, i.e. `1000 mm/s` at this scale. A configured `maxvel=80 mm/s` is the tighter software clamp. Neither number establishes motor torque, resonance, axis acceleration, drive response, physical travel, or stopping distance.

If the step accumulator is 1,000 whole steps, the generated-step position is 5.0 mm. Reinterpret the same count at 400 steps/mm and the HAL reading becomes 2.5 mm with no axis displacement required. This is why changing `position-scale` live is not a harmless calibration tweak.

## Observability matrix
| Signal | What it can substantiate | What it cannot substantiate |
|---|---|---|
| `joint.N.motor-pos-cmd` | motion controller target | actual motor/axis travel |
| `pid.N.output` | control effort request | drive acceptance |
| `hm2.stepgen.N.velocity-fb` | driver-selected/ramped command | tachometer speed |
| `hm2.stepgen.N.position-fb` | FPGA step accumulator scaled into units | physical table position, coupling integrity |
| independent encoder/scale | measured location of **its own sensing element** | travel of a different uncoupled element |
| drive fault/status input | reported drive condition, if correctly wired | independent safety integrity by itself |

## Minimal *read-only* HAL inspection commands
For a **previously qualified isolated environment** with a correctly loaded HostMot2 instance, replace the board prefix with the actual discovered name; do not execute on an exposed physical machine:

```text
halcmd show pin '*stepgen*position-fb'
halcmd show pin 'joint.0.motor-pos-cmd'
halcmd show pin 'joint.0.motor-pos-fb'
halcmd show pin '*stepgen*velocity-fb'
halcmd show param '*stepgen*position-scale'
halcmd show sig
```

Read `show sig` to determine the **actual producers**, not just signal labels. A display named “actual” may simply show stepgen feedback. For a proposed ROS 2 or MTConnect bridge, publish separate provenance/age fields for generated-step position and physical transducer position; never silently promote the former to the latter.

## Acceptance boundaries and next verification
The above is an inspectable source/config walkthrough, **not an executed test**. The smallest useful software-only comparison is a simulated independent axis that intentionally fails to follow generated steps: expect the stepgen/joint loop to agree while the independent axis witness disagrees. A second software-only case holds the step accumulator constant while changing scale 200→400 and observes the source-derived feedback discontinuity. Preserve raw HAL, motion, and simulated-plant values separately. Only a positively qualified `[self-hosted, openpressbrake]` isolated runner may be used for such compute; never hosted Actions. No physical actuator, machine safety authority, or evaluator evidence is implied.

**Prerequisite links:** [DPLL timing predecessor](../research/4400_LINUXCNC_DPLL_21_TIMER_DEFAULTS_ENCODER_STEPGEN_ASYMMETRY_SOURCE_AUDIT_2026-10-31.md); [encoder timestamp predecessor](../research/4400_LINUXCNC_HM2_TIMESTAMP_76_ENCODER_16BIT_ROLLOVER_LATENCY_SOURCE_AUDIT_2026-10-31.md). Closed 1000/2000/3000 levels and independent safety/evaluation gates are unchanged.
