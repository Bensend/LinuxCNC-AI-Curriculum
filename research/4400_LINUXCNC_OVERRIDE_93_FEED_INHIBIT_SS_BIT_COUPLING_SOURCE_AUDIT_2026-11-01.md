# 4000-LC-OVERRIDE-93 — `motion.feed-inhibit` depends on spindle-override bit 0

**2026-11-01 | NON-GRADUATED | source audit; no runtime or machine test.** LinuxCNC stable `v2.9.10` and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. This is a **new cross-subsystem mask interaction**, not a repetition of [FEED-JOG-01](4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) or [OVERRIDE-SCOPE-01](4400_OVERRIDE_SCOPE_01_LINUXCNC_2910_M48_M49_M51_DOLLAR_SELECTION_SOURCE_DOC_CONFLICT_2026-10-29.md).

## Question and source chain

Can `M51 P0`, which is documented to disable **spindle speed override**, change the effectiveness of the separately named `motion.feed-inhibit` input?

1. **Flag definition:** [stable `motion.h` lines 420–426](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h#L420-L426), blob `f789f59cda93502e35e5ee156e6254d1d6591629`, and [development lines 429–436](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.h#L429-L436), blob `1a48aa02f5772b8fd5e50862e13b097f1b789cc4`, define `SS_ENABLED=0x01`, `FS_ENABLED=0x02`, `AF_ENABLED=0x04`, `FH_ENABLED=0x08`. The flags are **not** a boolean.
2. **Initialization:** [stable `motion.c` lines 894–897](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c#L894-L897) and [development lines 908–911](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.c#L908-L911) initialize `enables_new` and `enables_queued` to `FS_ENABLED|SS_ENABLED|FH_ENABLED = 0x0b`.
3. **Interpreter → Task → motion:** [stable `interp_convert.cc` lines 3632–3657](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3632-L3657) emits `DISABLE_SPEED_OVERRIDE` for `M51 P0`. [`emccanon.cc` lines 2305–2313](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L2305-L2313) creates `EMC_TRAJ_SET_SO_ENABLE(mode=0)`; [Task lines 1821–1823](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1821-L1823) calls `emcTrajSetSOEnable(mode)`; [`taskintf.cc` lines 1245–1250](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc#L1245-L1250) sends `EMCMOT_SS_ENABLE`; [`command.c` lines 1269–1277](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1269-L1277) clears `SS_ENABLED`. Development [Task lines 1909–1911](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emctaskmain.cc#L1909-L1911) and [motion command lines 1408–1425](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L1408-L1425) preserve this global-bit behavior.
4. **Crucial expression:** [stable `control.c` lines 362–420](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L362-L420), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, computes `if (enables & *feed_inhibit) scale=0;`. [Development lines 424–492](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L424-L492), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, uses the same expression with `hal_get_bool`. A HAL bool is 0 or 1. Thus `enables & 1` tests **only the spindle override bit**, not whether any enable bit is present.
5. **Documentary conflict:** [stable `core-components.adoc` lines 126–129](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc#L126-L129) and [development `motion.9.adoc` lines 156–170](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/man/man9/motion.9.adoc#L156-L170) describe feed-inhibit as inhibiting G-code motion, with spindle-synchronized completion caveat, but do not document an M51 spindle-override prerequisite.

## Arithmetic discriminator (source-derived, NOT RUN)

| Effective enable mask | HAL `feed-inhibit` | Expression `mask & bool` | Expected `net_feed_scale` from this gate |
|---|---:|---:|---|
| Default `0x0b` | 1 | 1 | forced to zero |
| `0x0a` after spindle override disabled | 1 | 0 | **not forced to zero** |
| `0x0a` | 0 | 0 | not forced to zero |
| `0x09` after feed override disabled but spindle override enabled | 1 | 1 | forced to zero |
| `0x02` (only feed override enabled) | 1 | 0 | not forced to zero |

`motion.feed-hold` has its own `FH_ENABLED` gate and can independently zero the scale. The table isolates the feed-inhibit branch; it is **not** a prediction of actual velocity if another gate, machine state, or synchronized move intervenes.

## Timing and scope

`process_inputs` chooses `enables_queued` in coordinated mode and `enables_new` otherwise. Therefore a current queued move may retain an earlier bitmask; do **not** assert instantaneous `M51` effects across a motion boundary without observing Task/motion status. A spindle-synchronized move has separately documented completion semantics. Wheel-jog and command-jog exceptions were established by FEED-JOG-01 and are not reclassified here.

**Engineering interpretation:** This is an apparent mask-coupling defect: disabling spindle speed override can make a logically unrelated ordinary feed-inhibit input ineffective. It is **not** a safety-rated stop in either condition. Independent protective functions retain separate authority. No actual machine, motion, stopping time, or version-specific test result has been observed.

**Evidence:** SOURCE-CONFIRMED exact expression, bit values, flag update, and mask selection; DOC-CONFIRMED published intent; INFERENCE conditional operational consequence; TEST-CONFIRMED **none**. See [OVERRIDE-94](4400_LINUXCNC_OVERRIDE_94_SPINDLE_INHIBIT_SS_BIT_SPEED_ON_SOURCE_AUDIT_2026-11-01.md), [OVERRIDE-95](4400_LINUXCNC_OVERRIDE_95_M51_SELECTED_SPINDLE_DROPPED_AT_TASK_SOURCE_AUDIT_2026-11-01.md), and [acceptance guide](../guides/4000-linuxcnc-m51-inhibit-coupling-disconnected-acceptance-2026-11-01.md).
