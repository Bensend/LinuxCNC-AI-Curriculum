# 4000-LC-MILL-36 — Upstream VMC M6 remap: drawbar release acknowledgement versus positive lock confirmation
**Date:** 2026-10-31 · **Status:** SOURCE / NON-GRADUATED · **Machine:** upstream LinuxCNC Vismach *simulation*, not a field installation.  
**Scope:** LinuxCNC v2.9.10 (tag), no executable run or physical verification. **Novelty:** real upstream VMC configuration, M6 remap and a specific two-sensor handoff gap; *not* a repeat of existing generic ATC physical-retention lessons or the already-published cumulative `orient.comp` audit.

## Question and upstream provenance
Can the upstream VMC tool-change subroutine advance to retract the arm and commit a tool change while its simulated drawbar **has not reached its separate locked sensor**? The complete path is inspectable at the v2.9.10 tag:

| File / exact blob | Relevant symbol, wiring or statement |
|---|---|
| [vmc_graycode.ini](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/vmc_graycode.ini) `36a99e6abfde2c425f7a7af270c0bd86f6abc1e2` | `[RS274NGC] REMAP=M6 ... prolog=change_prolog ngc=toolchange epilog=change_epilog`; `[HAL] HALFILE` order; `[EMCMOT] SERVO_PERIOD=1000000`. |
| [vmc_index.ini](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/vmc_index.ini) `5e98caa20f6a7865174b9f2111d75c92c1b25a50` | Same M6 remap and motion configuration; alternate carousel sensor encoding. |
| [toolchange.ngc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/toolchange.ngc) `d5ddf536734932fb1b553852a6c46267fdd9af0b` | `o<toolchange> sub`; unload/rotate/load; final `M65 P3; M66 P3 L4 Q2`, then `M65 P2; M66 P4 L3 Q5`, and `endsub [1]`. |
| [toolchange_gray.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/toolchange_gray.hal) `bcd57e388561f3bdd4b4ded9186cde31911e2b94` | `motion.digital-out-03 → tool-release`; `tool-released → motion.digital-in-03`; `tool-locked` is **not** linked to any motion input. `iocontrol.0.tool-change ↔ tool-changed` and prepare loopback. |
| [toolchange_index.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/toolchange_index.hal) `fe22f8d054c4a25fdf32390ab90ed596f6b2077e` | Same arm/drawbar/loopback I/O, different `carousel encoding=index`. |
| [sim_vmc.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/VMC_toolchange/sim_vmc.hal) `5c20572f0dcc2d4d7c13eecc0c7cfc37588b057b` | Simulated `drawpos` mux, `drawlim` slew limiter, `drawsw` comparator, `tool-released=drawsw.under`, `tool-locked=drawsw.over`. |
| [wcomp.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/wcomp.comp) `a960b0a59cf5d4f4037ac0f23fac65f9ec1b4af6` | `under=(in<=min)`, `over=(in>=max)`. |
| [limit2.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/limit2.comp) `eb9595e5a9eb90c81a926120d02c789d4e745481` | Slew limit `maxdelta=maxv*fperiod`; no instantaneous full-stroke movement. |
| [stdglue.py](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/remap_lib/python-stdglue/stdglue.py) `d501af0c2e2c6c812ef8744dc65fb25bf270c748` | `change_prolog` populates `selected_pocket` and `tool_in_spindle`; `change_epilog` commits `emccanon.CHANGE_TOOL` on positive NGC return. |
| [M-code documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc) `bd388ccd0da40c9a2df2910037ce34de1e47c820` | `M66 L3=HIGH`, `L4=LOW`, `#5399=-1` on timeout; M66 is not realtime timing-grade. |

## Source trace: the two different drawbar thresholds
In `sim_vmc.hal`, the drawbar's commanded target is 0 when `tool-release` is high and 5 when low. `drawlim.maxv=10` limits its nominal rate to 10 simulated position units/s. `drawsw.min=1`, `drawsw.max=4`; `tool-released` comes from `under` and `tool-locked` from `over`. From the actual `wcomp.comp` comparisons:

| Simulated drawbar coordinate x | `tool-released` | `tool-locked` |
|---|---|---|
| x ≤ 1 | TRUE | FALSE |
| 1 < x < 4 | FALSE | FALSE |
| x ≥ 4 | FALSE | TRUE |

**SOURCE-CONFIRMED:** the final `M66 P3 L4 Q2` accepts **LOW `tool-released`**, which occurs at x>1. It does **not** wait for the separately defined `tool-locked` to become HIGH at x≥4. The next line requests arm withdrawal. **INFERENCE from deterministic source values:** with an ideal 10-unit/s clamp travel starting at x=0, the first acceptance boundary is just beyond 0.1 s, while the lock comparator reaches x=4 at approximately 0.4 s; the nominal unverified interval is almost **0.3 s**. Servo function ordering, Task polling, state startup, scheduling, and physical actuator response can change measured timings. This is *not* a measured race or proof of a real tool drop.

The source includes a `tool-locked` simulated signal but neither carousel variant links it to `motion.digital-in`. Therefore the positive `o<toolchange> endsub [1]` is not conditioned on that lock signal. The `change_epilog` positive-return path then requests `CHANGE_TOOL`; the tool prepare/change loopbacks only complete the software I/O handshake, not physical drawbar retention.

## Call flow and failure boundary
`Tn M6` → `change_prolog` (validate prepared pocket) → `toolchange.ngc` (M19, G53, arm/carousel/drawbar commands and M66 waits) → `endsub [1]` → `change_epilog` (canonical CHANGE_TOOL) → iocontrol loopback. The macro checks several timeouts using `#5399 LT 0`; this checks that **the selected input condition was observed**, not that another sensor or a load-bearing mechanical state was achieved.

The carousel path is separately inspectable: `M68 E0 Q#<selected_pocket>` → `conv-float-s32.2` → `carousel.0.pocket-number`, `M64 P0` enables `carousel.0`, and `M66 P0 L3` waits for `carousel.0.ready`. In `carousel.comp` v2.9.10 (`0c8432acc93bda3c41c2686cb3a2f90bfecbca8f`), `ready` is published by the component state machine after its selected-position/alignment path. That **component-level ready** is not a separate physical proof of a locked drawbar.

## Explicitly not new: spindle orientation accumulator
The same macro starts with `M19 R0`; `spindle.hal` wires `orient.0.is-oriented` to `spindle.0.is-oriented`. The source's cumulative rather than consecutive tolerance counter was **already documented** in [SPINDLE-ORIENT-01](4400_SPINDLE_ORIENT_01_LINUXCNC_2910_CUMULATIVE_ACK_VS_PHYSICAL_LOCK_SOURCE_AUDIT_2026-10-28.md). This note records the **integration dependency** but makes no novelty claim for that previously studied mechanism. The simulated spindle and remap are educational examples, not independent personnel-safety functions.

## Practical correction hypothesis (not applied upstream)
Use an **additional** available digital input 5 (the VMC `vmc.hal` requests `num_dio=6`) for the existing `tool-locked` signal, and require both released=LOW and locked=HIGH before arm withdrawal. In each `toolchange_{gray,index}.hal` variant:
```hal
net tool-locked motion.digital-in-05
```
After `M65 P3` in `toolchange.ngc`:
```ngc
M66 P3 L4 Q2  (released sensor must become LOW)
O112 IF [#5399 LT 0]
    (abort, release sensor failed to clear)
O112 ENDIF
M66 P5 L3 Q2  (separate locked sensor must become HIGH)
O113 IF [#5399 LT 0]
    (abort, locked sensor not reached)
O113 ENDIF
```
This is a **review-only candidate**, not a deployed or runtime-tested patch. The second check improves the software state predicate but does not validate clamping force, tool retention, sensor independence, spindle stop, or personnel protection.

## Evidence ledger and discriminating acceptance
- **SOURCE-CONFIRMED:** INI selects remap; HAL pin mapping; two independent drawbar comparator thresholds; M66 L4 tests only the release signal; epilog commits after positive subroutine return; both carousel variants share the gap.
- **DOC-CONFIRMED:** M66 HIGH/LOW and timeout contract; M19 orientation acknowledgment semantics.
- **INFERENCE:** approximately 0.3 s simulated intermediate travel at maxv=10; the actual moment of arm retraction depends on Task/HAL scheduling.
- **UNKNOWN:** actual simulation trace, whether M19 without Q has a default timeout in this exact runtime, full toolchanger recovery after abort, real hardware wiring and independent force/retention.
- **TEST-CONFIRMED:** none. No build, LinuxCNC simulation, Actions workflow or physical operation.

**Software-only discriminator:** run both upstream `vmc_graycode.ini` and `vmc_index.ini` on an isolated non-machine environment. Capture `draw-pos`, `tool-released`, `tool-locked`, `arm-act`, `arm-in`, `motion.digital-in-03` and `motion.digital-in-05` (after candidate wiring), plus Task M6 state. Compare baseline to review-only patch; test normal clamp, stuck-release-low, stuck-lock-low, timeout and abort. Record raw timestamps and distinguish sample order from real elapsed time. Do **not** dispatch to a connected controller or assume runner isolation.

**Next checkpoint:** implement only a disconnected software acceptance test if qualified isolated runner access becomes available; otherwise inspect the upstream `carousel.comp` unhome/ready rearm boundary or rotate to an undercovered mill/press-brake CAD/CAM integration question. Graduated 1000/2000/F02/3000 and independent safety gates remain unchanged.
