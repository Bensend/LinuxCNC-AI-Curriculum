# 3100/3200/3400/4000 — LinuxCNC feed/spindle inhibit versus override commissioning

**Source-linked companion to [INHIBIT-141](../research/4400_LINUXCNC_INHIBIT_141_FEED_SPINDLE_INHIBIT_SS_OVERRIDE_BITMASK_SOURCE_AUDIT_2026-11-02.md).** This is a *disconnected normal-control* exercise, **NOT RUN**, not a personnel-safety acceptance procedure.

## The machine-control question

A mill may use `motion.feed-inhibit` for an external pause request, while a QtDragon-style router uses `spindle.0.inhibit` to pause the spindle while applying a Z external offset. Neither should silently depend on whether the operator disabled spindle *speed override* with M51 P0. In v2.9.10 and pinned development, the current implementation evaluates `enables & inhibit_bit` where the TRUE inhibit is numeric 1 and SS_ENABLED is 0x01. The effect is conditional on the active segment's queued flags, not simply the most recent GUI display.

## Setup (qualified disconnected simulation only)

Use a LinuxCNC simulation with **no physical Mesa/EtherCAT/drive outputs** and no shared hardware I/O. Confirm `halcmd show pin motion.feed-inhibit motion.feed-hold spindle.0.inhibit`, the writer/reader direction, and the active HAL function ordering. If the pin is unconnected, `halcmd setp motion.feed-inhibit true` is possible; if connected, control the *upstream simulated writer*, not the input pin. Keep `motion.feed-hold=FALSE`, `motion.adaptive-feed=1`, `motion.feed-inhibit=TRUE`, and record machine-on/homed/coordinate state. Choose travel fully inside the simulated joint limits; **do not copy coordinates to a physical machine**.

Run the two [G-code fixtures](../examples/4000_inhibit_141/) independently with the same fresh interpreter startup state and pin states. They differ only in M51 P1 versus M51 P0. For each case, log requested G1, `motion.feed-upm`, commanded position, pin state and Task/motion state with monotonic timestamps. In the expected source-derived case, M51 P1 suppresses feed; M51 P0 allows the ordinary feed command to progress despite feed-inhibit TRUE. **These are predictions, not observations**. Abort the simulated test at a fixed time; an inhibited program is expected not to reach M2 while the pin remains asserted.

## Distinguishing matrix

| Case | M-code | Pin under test | Other conditions | Predicted source effect |
|---|---|---|---|---|
| A | M51 P1 | feed-inhibit TRUE | feed-hold FALSE | feed scale 0 |
| B | M51 P0 | feed-inhibit TRUE | feed-hold FALSE | feed scale not zeroed by inhibit |
| C | M49 | feed-inhibit TRUE | feed-hold FALSE | feed scale not zeroed by inhibit |
| D | M51 P1 | feed-inhibit FALSE | feed-hold FALSE | ordinary programmed feed |
| E | M51 P0 | spindle.0.inhibit TRUE | S nonzero, spindle on, no other stop | spindle scale not zeroed by inhibit |
| F | M51 P1 | spindle.0.inhibit TRUE | same as E | spindle scale 0 |
| G | M51 P0 | feed-inhibit TRUE | feed-hold TRUE, M53 P1 | feed-hold independently forces scale 0; **not discriminating** |

For E/F, a simulated spindle speed command/output is sufficient; do not infer physical deceleration or motor standstill. Also inspect `spindle.0.speed-out` and `spindle.0.on` separately: a speed request of zero does not prove a motor has stopped. G33/G33.1, jog, feed reverse and spindle-override-lock need separate cases because the source deliberately handles synchronized moves and flags differently.

## HAL diagnostics and source navigation

Inspect [motion flag definitions](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h#L421-L429), [M51 handler](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1268-L1279), [scale calculation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L362-L434), [TP active segment flags](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2596-L2627), and [QtDragon simulated spindle inhibit wiring](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtdragon/qtdragon_xyz/qtdragon_postgui.hal#L9-L18). Capture HAL scheduling with `halreport` and `halcmd show funct`; neither proves electrical feedback. The documented inhibit contract is in [core components](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc#L125-L132).

## Acceptance and limitations

A regression should establish: TRUE inhibit suppresses ordinary G-code feed and spindle command with M51 enabled *and disabled*, while the documented spindle-synchronized exception and normal M51 override semantics remain intact. Failures in a simulated output trace must be reported as controller-command behavior only. Do not convert this to an E-stop, interlock, physical retention, or safety-PLC design. Independent personnel-safety authority and existing OpenPressBrake G0/G1 HOLD remain unchanged. **No run, no new lab runtime, no external evaluation**.
