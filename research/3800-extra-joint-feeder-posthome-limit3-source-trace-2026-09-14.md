# 3800 — Extra-joint feeder / posthome / limit3 source trace

Date: 2026-09-14
LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-CONFIRMED / DOC-CONFIRMED

## Purpose

Continue 3800-F1 after the saw/ClassicLadder pass. The question is when a stock pusher, feeder, stop or loader slide should be represented as an **extra joint** rather than a coordinated G-code axis or a pure HAL state-machine mechanism.

## 1. LinuxCNC's explicit extra-joint contract

Pinned official motion documentation states that `num_extrajoints` designates joints that:

- participate in LinuxCNC homing;
- are not used by the active kinematics transformations;
- after homing, transfer command authority to the HAL input `joint.N.posthome-cmd`;
- ignore motor-feedback position for Motion's normal post-home command path;
- must be managed by an independent planner/controller, typically `limit3`;
- may be unhomed only when Motion is disabled.

Extra joints occupy the final joint numbers. For example, five total joints with two extras and XYZ kinematics means joints 0–2 are kinematic and joints 3–4 are extra.

### Transferable 3800 interpretation

An extra joint is a good candidate when a mechanism:

- needs LinuxCNC homing/reference handling;
- needs a bounded position target after homing;
- does **not** need to participate in the cutting/toolpath kinematics;
- does not need an independent coordinated multi-axis G-code channel.

Typical 3800 examples are a stock pusher, positioning stop, loader slide, simple clamp-position axis or one-axis feeder carriage.

It is **not** a second trajectory planner for arbitrary simultaneous machining.

## 2. Source-level post-home insertion

Pinned `src/emc/motion/control.c` explicitly special-cases a homed extra joint during HAL output generation:

```text
if (IS_EXTRA_JOINT(joint_num) && get_homed(joint_num)) {
    motor-pos-cmd = posthome-cmd + motor_offset;
    continue;
}
```

The important mechanism is therefore direct and narrow:

`external posthome target`
→ `joint.N.posthome-cmd`
→ `+ LinuxCNC motor_offset`
→ `joint.N.motor-pos-cmd`

This bypasses the normal kinematic joint position-command path after homing. Pinned documentation separately states that motor feedback is ignored by this extra-joint command path after homing.

Therefore **LinuxCNC Motion is not closing a normal position servo around `posthome-cmd` for the mechanism.** Any required position controller, stepgen position loop or drive-level servo remains outside that posthome passthrough.

## 3. Shipped LinuxCNC example — independent `limit3` planner

Pinned shipped config `configs/sim/axis/extrajoints/1extrajoint.hal` implements joint 4 as:

```text
loadrt limit3 names=j4.limit3
setp j4.limit3.min  [JOINT_4]MIN_LIMIT
setp j4.limit3.max  [JOINT_4]MAX_LIMIT
setp j4.limit3.maxv [JOINT_4]MAX_VELOCITY
setp j4.limit3.maxa [JOINT_4]MAX_ACCELERATION
addf j4.limit3 servo-thread

net J4:out <= j4.limit3.out
net J4:out => joint.4.posthome-cmd

net J4:enable <= joint.4.homed
net J4:enable => j4.limit3.enable
```

The example separately shows three downstream actuator styles:

- simulation loopback;
- stepgen in position mode;
- PID/motor-amplifier/encoder style control.

That separation matters: **extra-joint command generation and the physical motor-control loop are different layers.**

## 4. `limit3` behavior

Pinned `src/hal/components/limit3.comp` defines `limit3` as a position/velocity/acceleration limiter.

When enabled:

`out` follows `in` while respecting `min`, `max`, `maxv` and `maxa`.

When disabled:

`invalue` is internally forced to zero, so `out` returns toward zero **while still obeying velocity and acceleration constraints**.

The `load` input is an explicit exception: when true it immediately copies the bounded input to the output, bypassing max velocity and acceleration.

### Important feeder consequence

The shipped extra-joint example connects `limit3.enable` to `joint.N.homed`, not directly to machine-enable or an automatic-cycle permissive. Once the joint is homed, `limit3` remains logically enabled unless another config changes that wiring.

Therefore a production feeder should not mistake the shipped simulator wiring for a complete machine permissive. A feeder planner typically still needs explicit ownership for:

- automatic/manual command source;
- cycle request freshness;
- machine/cell permissive;
- stock/clamp readiness;
- fault/abort behavior;
- downstream drive enable / safe state.

Do not infer that `joint.N.posthome-cmd` alone provides those semantics.

## 5. Disable / restart boundary

Pinned Motion source exposes `joint.N.amp-enable-out` from the joint enable flag for normal joint output handling, while the homed extra-joint branch directly writes `motor-pos-cmd = posthome-cmd + motor_offset` and continues.

The inspected source is sufficient to establish the **command-position** path but not, by itself, a universal physical drive-disable contract for every extra-joint hardware integration. Different configs can wire stepgen/servo enables and external contactors differently.

Accordingly preserve two separate states:

- `extra-joint position command state`;
- `physical actuator enable/safe-state authority`.

On a real feeder, machine OFF/E-stop/abort behavior must be verified through the actual downstream enable wiring. Do not assume that changing LinuxCNC machine state necessarily zeros the external `posthome-cmd` source or physically returns the mechanism to a neutral position.

## 6. Workpiece-position boundary

Even a perfectly controlled extra joint only proves mechanism position.

For a pusher/shuttle feeder:

`joint.N.motor-pos-cmd / motor position`

is not automatically:

`stock position`.

The Marvel V10A field chronology already demonstrated why: hydraulic leakage/creep can make mechanism and material stability differ from the momentary encoder target. Similar divergence can occur from clamp slip, stock loss, compliance or a pusher losing contact.

Therefore a production feeder using an extra joint still needs a machine-specific answer to:

- what physically couples the feeder to stock;
- what proves that coupling;
- what proves the stock has stopped/stabilized;
- when the receiving clamp takes ownership;
- when feeder position may be trusted as stock position.

## 7. Decision rule — coordinate axis vs extra joint vs sequence mechanism

### Use a coordinated axis when

The mechanism is part of the programmed geometric toolpath and must be interpolated with the cutting axes.

### Use an extra joint when

The mechanism needs LinuxCNC homing plus independently planned post-home point positioning, but is intentionally outside kinematics and coordinated G-code motion.

### Use a HAL/ClassicLadder state mechanism when

The actuator is primarily discrete or sequence-owned (clamp, binary hydraulic shuttle, solenoid, short indexed stroke) and representing it as continuous Motion position would add false precision or complexity.

### Use an external PLC/drive controller when

The mechanism/cell has substantial independent sequencing, existing industrial control infrastructure, timing/safety requirements, or must continue independently of LinuxCNC's single coordinated-motion channel.

### Use another LinuxCNC instance when

A station genuinely needs its own independent coordinated multi-axis CNC program concurrently with the first station.

This is an architecture rule, not a prohibition on hybrids.

## 8. Adversarial review

1. Does `num_extrajoints=1` create a second G-code channel? **No.**
2. Does `posthome-cmd` participate in the configured machine kinematics? **No after homing; that is the defining extra-joint distinction.**
3. Does Motion's normal feedback loop close around `posthome-cmd` after homing? **No; pinned docs explicitly say motor feedback is ignored by the post-home extra-joint path.**
4. Does `limit3.enable=0` freeze its current output? **No. It drives the output back toward zero under the configured constraints.**
5. Does the shipped example's `joint.N.homed -> limit3.enable` constitute a complete production feeder permissive? **No.**
6. Does a homed extra-joint encoder prove actual stock position? **No.** Mechanism/workpiece coupling remains separate evidence.
7. Does an extra-joint command path prove a safety-rated stop? **No.** Physical actuator/safety authority remains downstream and machine-specific.

Result: **7/7 boundaries preserved.**

## 9. Lab decision / next evidence

No lab is needed to prove the core posthome insertion or `limit3` disable behavior; both are directly source-visible.

A future lab is justified only for a concrete feeder architecture question, for example:

- whether a chosen command-source handshake can accept a stale target after re-homing;
- whether a proposed enable chain causes unwanted `limit3` return-to-zero motion;
- exact behavior of a candidate feeder command across machine OFF / re-enable;
- interaction between a real stepgen/servo enable and retained posthome target.

The next 3800 evidence target remains a real field implementation with explicit completion acknowledgement and partial-cycle recovery, or, if that source remains unavailable, an indexer with independent position and lock proof.
