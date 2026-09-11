# Accurpress press-brake architecture evolution — May 2021 rework

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 COMMUNITY/CONFIG/SOURCE ANALYSIS**

## Question

Did the later press-brake rework preserve the April 2021 hybrid MOTMOD/custom-command topology and planner-as-feedback ambiguity, or did it materially change ownership?

## Public provenance

Forum thread page containing the major rework and later machine HAL:
https://forum.linuxcnc.org/30-cnc-machines/42100-pressbrake-cnc-control-setup-questions?start=60

- `#208433`, 2021-05-09: Andy Pugh describes a “quite a major re-working,” adds homing support and up to four axes.
- `#209699`, 2021-05-20: machine owner reports the machine jogging and bending with the latest setup and attaches `bender.hal`.
- public `bender.hal`: https://forum.linuxcnc.org/media/kunena/attachments/19921/bender.hal

This artifact compares that public machine file to the earlier April `accurpress.hal` audited in `research/press-brake-accurpress-public-config-ownership-audit-2026-09-11.md`.

## Result: ownership changed materially

The May `bender.hal` no longer loads MOTMOD or KINS. Instead it loads a custom `press` component, two `simple_tp` trajectory planners, HostMot2/hm2_eth, three PID instances and an explicit realtime thread.

That directly follows the architectural direction discussed earlier in the thread: a standalone press controller rather than a half-MOTMOD / half-custom Y command chain.

**Classification:** CONFIG-CONFIRMED for the May file; COMMUNITY-REPORTED for the design rationale.

## Ram command and feedback flow

### Planner command is now position, not velocity

For ram axis 0:

```text
press.axis.0.pos-cmd-out
    -> simple-tp.0.target-pos

press.axis.0.vel-cmd
    -> simple-tp.0.maxvel

simple-tp.0.current-pos
    -> brake-pos-abs
    -> pid.0.command

hm2_7i97.0.encoder.00.position
    -> brake-fb-raw
    -> pid.0.feedback
```

This is dimensionally coherent with the current pinned `simple_tp` and `pid` semantics: planned **position** is compared with measured **position**.

The earlier April attachment instead connected `simple_tp.current-vel` to the Y PID command while feeding physical position to the PID feedback. That questionable transitional wiring is no longer present here.

**Classification:** CONFIG-CONFIRMED; current component semantics SOURCE/DOC-CONFIRMED at LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

## The press state machine now receives physical encoder truth

The May file contains:

```text
hm2_7i97.0.encoder.00.position
    -> brake-fb-raw
    -> press.axis.0.pos-fb-in

press.axis.0.pos-fb-out
    -> brake-fb
    -> pressgui.pos-fb
```

So the later custom press component receives the real encoder position at `pos-fb-in` rather than receiving `simple_tp.current-pos` as its “feedback.”

This is a concrete correction of the most important ambiguity in the April machine HAL. The cycle/homing component can now distinguish physical plant position from the trajectory planner's commanded position.

The later thread also shows that the component applies home-offset processing to this physical feedback, and the machine owner modified the sign of that offset calculation after finding the displayed/homed direction wrong. That is useful evidence that the feedback path was actively used for homing, not merely connected cosmetically.

**Classification:** CONFIG-CONFIRMED + COMMUNITY-REPORTED field debugging.

## Homing and jogging ownership moved into the custom press component

The May HAL supplies per-axis component inputs such as:

- `press.axis.0.index-enable`;
- `press.axis.0.home-switch`;
- `press.axis.0.home-offset`;
- `press.axis.0.home-search-velocity`;
- corresponding backstop axis-1 homing pins;
- `press.jog-counts`, `press.jog-select`, `press.jog-increment`, and `press.home-select`.

This shows the cost of the standalone custom-controller choice: once MOTMOD is removed, generic homing and jogging semantics have to be recreated or deliberately narrowed inside the component. That is exactly the pressure that caused the earlier forum discussion to reconsider whether a custom component had grown too broad.

The machine owner reported that ram and backstop jogging/bending worked with this version, but homing still required debugging. Later posts identify home-direction and home-offset sign issues.

**Classification:** CONFIG-CONFIRMED surface + COMMUNITY-REPORTED operation/debugging. Not sufficient to claim production robustness.

## Realtime execution order changed — and must still be audited

The May file creates `thread1` and adds functions in this order:

```text
press
simple-tp.0.update
simple-tp.1.update
hm2_7i97.0.read
hm2_7i97.0.write
pid.0.do-pid-calcs
pid.1.do-pid-calcs
pid.2.do-pid-calcs
```

LinuxCNC HAL executes same-thread functions in `addf` order.

For the ram this means, per invocation:

1. `press` runs first, seeing the encoder signal value left by the **previous** HostMot2 read.
2. `simple_tp` produces the current planned position.
3. HostMot2 reads fresh hardware encoder state.
4. HostMot2 writes the output value produced by the **previous** PID invocation.
5. The PID then calculates a new effort from the current planner position and the just-read physical encoder position.
6. That newly calculated PID effort cannot reach the hardware until the next `hm2.write` invocation.

Therefore the later file fixed ownership/units but still has explicit one-period age boundaries in the press-feedback and output paths. This is not automatically unsafe or unstable at a 1 kHz-style servo rate, but it is architecturally observable and must be considered in tuning, diagnostics and same-cycle assertions.

A more conventional ordering for a simple software servo is typically conceptually:

```text
hardware read -> command generation -> controller -> hardware write
```

This audit does **not** claim that merely reordering the May file is safe; the custom component's internal expectations and the hardware interface would need a deliberate timing review first.

**Classification:** CONFIG-CONFIRMED ordering + DOC-CONFIRMED `addf` semantics; consequence beyond deterministic one-cycle age is INFERENCE until tested.

## Safety and ordinary-control boundary

The May file connects a GUI enable button to `press.interlock`, both simple planner enable and PID enable, and maps foot switches directly into the realtime `press` component. That is consistent with the forum goal of keeping pedal-sensitive ordinary control in realtime rather than in a GUI polling loop.

None of this makes the custom component or GUI enable chain a functional-safety system. The thread itself repeatedly flags unfinished safety thinking. Treat these as ordinary-control architecture only.

## Before/after architecture table

| Concern | April `accurpress.hal` | May `bender.hal` | Lesson |
|---|---|---|---|
| MOTMOD/KINS | loaded and still partly connected | absent | ownership was deliberately simplified toward standalone custom control |
| Ram PID command | `simple_tp.current-vel` | `simple_tp.current-pos` | later wiring restores position-command/position-feedback semantics |
| PID physical feedback | encoder position | encoder position | physical servo feedback retained |
| Press component position input | `simple_tp.current-pos` | raw physical encoder via `pos-fb-in` | later design distinguishes plant truth from planner state |
| Homing | MOTMOD surfaces present but unresolved | custom press-axis homing pins | removing MOTMOD transfers substantial behavior into custom code |
| Jogging | conventional HALUI/MOTMOD surfaces partly present/commented | custom jog count/select/increment | same ownership tradeoff |
| Thread timing | read -> motion -> PID -> write -> press -> planner | press -> planner -> read -> write -> PID | both have explicit state-age boundaries; topology alone is insufficient |
| Tandem Y1/Y2 | absent | absent | neither file provides tandem synchronization evidence |

## Function / call-flow documentation

### Command path

```text
GUI bend table / foot-pedal state
        |
        v
press component
  axis.0.pos-cmd-out + axis.0.vel-cmd
        |
        v
simple_tp.0.update
  current-pos = planned ram position
        |
        v
pid.0.command
        |
        +-----------------------------+
                                      |
physical encoder -> hm2.read -> pid.0.feedback
                                      |
                                      v
                              pid.0.do-pid-calcs
                                      |
                                      v
                              pid.0.output
                                      |
                                      v
                        [next invocation] hm2.write
                                      |
                                      v
                               PWM hardware
```

### Cycle/homing observation path

```text
physical encoder
      |
      v
hm2.read
      |
      v
brake-fb-raw
      |
      +-> pid.0.feedback
      |
      +-> press.axis.0.pos-fb-in
              |
              v
        home-offset / cycle state
              |
              v
        press.axis.0.pos-fb-out -> GUI
```

Because `press` executes before the same invocation's `hm2.read`, its physical observation is one thread period old even though the signal producer is now correct.

## Adversarial check

**Scenario:** A reviewer sees that both the press component and PID are now connected to the same encoder signal and concludes that they see the same sample in every servo invocation.

**Correct answer:** false. Signal identity does not imply same invocation age. The May `addf` order runs `press` before `hm2.read`, while PID runs after `hm2.read`; therefore the press component consumes the previous read value and PID consumes the current read value. Same-net reasoning without function-order reasoning is insufficient.

This extends the earlier lesson: first trace the producer, then trace execution order.

## Architecture conclusion

This real build diary supports a bounded general lesson rather than a prescription:

> Press-brake control architecture evolves under pressure from generic motion features. A custom realtime cycle component can cleanly own pedal-sensitive sequencing, but if it also absorbs generic homing, jogging, trajectory generation and axis semantics, the component becomes a second motion subsystem that must reproduce those services and their failure handling. Conversely, retaining MOTMOD while bypassing its command path creates ambiguous hybrid ownership. Either choice needs explicit boundaries.

The May rework is better structured than the April merge in two concrete ways: physical feedback reaches the press component, and planner position feeds the position PID. It still demonstrates why realtime function order and state age must be treated as part of the interface contract.

## Precise next-work checkpoint

1. Search later thread revisions (2021–2022) for whether the standalone custom component persisted, was replaced, or reintegrated with conventional LinuxCNC motion.
2. Track explicit pressure/tonnage handling and whether overpressure transitions became executable rather than proposed.
3. Locate a public tandem Y1/Y2 configuration with two independent scales; the Accurpress single-ram evidence cannot answer synchronization/final-authority questions.
4. Keep S02/E20/X01/X02 fresh-AI handoff separation intact; this 4600 research does not unblock F02.
