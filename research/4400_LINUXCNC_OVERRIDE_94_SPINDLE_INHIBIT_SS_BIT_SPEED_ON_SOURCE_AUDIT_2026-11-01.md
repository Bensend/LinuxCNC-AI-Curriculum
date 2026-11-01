# 4000-LC-OVERRIDE-94 — `spindle.N.inhibit` is coupled to spindle override, and `spindle.N.on` is separate

**2026-11-01 | NON-GRADUATED | pinned source comparison, no execution.** Stable LinuxCNC `v2.9.10` and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`.

## Exact behavior traced

The spindle HAL pin is declared [stable `motion.c` lines 715–720](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c#L715-L720) and [development lines 722–731](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.c#L722-L731). [Official development motion manual lines 517–518](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/man/man9/motion.9.adoc#L517-L518) says asserting `spindle.N.inhibit` sets and holds spindle speed to zero; [stable core-components lines 209–212](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc#L209-L212) gives the same ordinary-control intent.

In [stable `control.c` lines 423–433](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L423-L433) and [development lines 494–507](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L494-L507), each spindle's `net_scale` begins at 1, optionally multiplies its override if `enables & SS_ENABLED`, then executes `if (enables & spindle_inhibit) scale=0;`. The pin is HAL BOOL 0/1, so the latter condition is effectively `(enables & 0x01) && inhibit`. The same bit that controls whether the *optional override multiplier* applies also controls whether the *separate inhibit input* applies. With `SS_ENABLED=0` after `M51 P0`, an asserted inhibit no longer zeroes `net_scale` in this path.

The command path then multiplies the spindle speed by `net_scale`: [development `control.c` lines 2014–2029](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L2014-L2029), with [HAL outputs at lines 2044–2053](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L2044-L2053). In particular, `spindle.N.speed-out` is set from the scaled requested speed, **but `spindle.N.on` is assigned from the spindle state and does not depend on `net_scale`**. Even when `spindle.N.inhibit` successfully zeroes the speed command, the ON command can remain asserted. Neither pin is actual RPM feedback.

## Two distinct predicted states (NOT RUN)

Assume ordinary M3 S1200, nonzero programmed spindle speed, no other limiting state, and stable mask at a new coordinated move:

| `SS_ENABLED` | `spindle.0.inhibit` | `net_scale` from examined code | `spindle.0.speed-out` expected | `spindle.0.on` |
|---:|---:|---:|---:|---|
| 1 | 0 | 1 × operator override | speed × override | remains ON |
| 1 | 1 | 0 | 0 RPM commanded | remains ON |
| 0 | 1 | 1 | **1200 RPM commanded** | remains ON |
| 0 | 0 | 1 | 1200 RPM commanded | remains ON |

A spindle controller may interpret zero speed and ON differently, so this is a **HAL command semantics** result, not proof of physical rotation or braking. On a real machine, motor enable, contactor, VFD state, actual encoder RPM, brake and independent safety stop must be observed separately.

The source comment calls this a non-maskable inhibit except during spindle-synchronized motion. Yet the actual boolean-mask expression makes the inhibit dependent on the ordinary spindle-override bit. Do not substitute the comment for the code.

**Evidence:** SOURCE-CONFIRMED pin, expression, scaling, `on` separation, version parity; DOC-CONFIRMED expected inhibit behavior; INFERENCE command-output behavior under specified inputs; TEST-CONFIRMED none. The [feed counterpart](4400_LINUXCNC_OVERRIDE_93_FEED_INHIBIT_SS_BIT_COUPLING_SOURCE_AUDIT_2026-11-01.md) and [disconnected guide](../guides/4000-linuxcnc-m51-inhibit-coupling-disconnected-acceptance-2026-11-01.md) define independent checks. Do not use these ordinary-control pins as personnel-safety authority.
