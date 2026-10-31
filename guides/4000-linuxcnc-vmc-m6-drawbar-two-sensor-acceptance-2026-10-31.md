# LinuxCNC 4000 practical: upstream VMC M6 remap and two-sensor drawbar acceptance
**2026-10-31 · non-graduated source-grounded exercise · software-only proposal.** Companion: [MILL-36 pinned source audit](../research/4400_LINUXCNC_MILL_36_VMC_M6_REMAP_DRAWBAR_ACK_GAP_SOURCE_AUDIT_2026-10-31.md).

## Learning target
Given an INI-selected M6 remap, identify *exactly which HAL input* allows the macro to advance and which mechanical condition that input does **not** prove. Distinguish Task interpreter completion, HAL sensor levels, carousel component readiness and independent physical retention.

## Reproduce the source review (no LinuxCNC runtime required)
Use upstream LinuxCNC **v2.9.10**. Read, in order, `configs/sim/axis/vismach/VMC_toolchange/{vmc_graycode.ini,vmc_index.ini,toolchange.ngc,toolchange_gray.hal,toolchange_index.hal,sim_vmc.hal,vmc.hal}`, then `src/hal/components/{wcomp.comp,limit2.comp,carousel.comp}`, `nc_files/remap_lib/python-stdglue/stdglue.py`, and `docs/src/gcode/m-code.adoc`. Verify blob IDs in the companion audit rather than silently using a moving development branch.

Trace the selected `REMAP=M6` and `HALFILE` sequence. Draw a signal map for P0 (carousel), P1 (lock), P2/P4 (arm in/out), P3 (drawbar release), and the unused P5. Do not mistake `iocontrol.0.tool-changed` loopback for a physical completion sensor.

## Minimal acceptance matrix
| Case | Simulated `draw-pos` / pin conditions | Current upstream subroutine | Candidate two-sensor predicate | Classification |
|---|---|---|---|---|
| A | x=0; released=1; locked=0 | M66 P3 L4 waits | waits | SOURCE-derived |
| B | x=2; released=0; locked=0 | M66 P3 L4 can finish, then arm retract command | waits for locked=1 | SOURCE-derived |
| C | x=4; released=0; locked=1 | M66 P3 L4 can finish | both conditions satisfied | SOURCE-derived |
| D | released stuck=0; locked stuck=0 | release LOW alone can satisfy M66 immediately | second check times out (if sampled as expected) | CONDITIONAL prediction |
| E | released stuck=1; locked=1 | M66 P3 L4 times out | first check times out | CONDITIONAL prediction |
| F | locked feedback toggles falsely high without force | existing macro cannot see it | second check may pass; physical force still unproven | UNKNOWN hardware |

The comparator boundaries are inclusive at `x<=1` and `x>=4`; `x=2` is a **valid intermediate position with both sensors false**. `drawlim.maxv=10` and `SERVO_PERIOD=1000000` imply an idealized 0.01 unit/servo-call upper movement, but Task `M66` polling is not realtime and this is **not** an experimentally observed delay.

## Review-only wiring and NGC change
The upstream `vmc.hal` declares `num_dio=6`, allowing `motion.digital-in-05`. Both carousel variants must be modified consistently:

```hal
# append to toolchange_gray.hal AND toolchange_index.hal
net tool-locked motion.digital-in-05
```

In `toolchange.ngc`, after `M65 P3` and its existing `M66 P3 L4 Q2` timeout check, add:

```ngc
M66 P5 L3 Q2
O113 IF [#5399 LT 0]
    (abort, drawbar locked sensor not reached)
O113 ENDIF
```

Retain the original release-sensor check. The exact O-label must not collide with any other O-label in a local fork. This snippet is **not committed to LinuxCNC or deployed**; it is a candidate for isolated simulator verification and independent review.

## Required trace if an isolated test becomes available
Use a physically disconnected LinuxCNC RIP/simulator only after positive isolation and runner qualification. Freeze both original and candidate configurations; record LinuxCNC commit SHA, selected INI, HAL `show pin` output, `draw-pos`, `tool-release`, `tool-released`, `tool-locked`, `arm-act`, `arm-in`, `arm-out`, `carousel.0.ready`, `motion.digital-in-03`, `motion.digital-in-05`, M66 `#5399` results, M6 return and software tool number. Do not interpret a UI display or successful M6 alone as proof of retention.

Acceptance: (1) baseline exhibits x in (1,4) with released=0 and locked=0, and may advance; (2) candidate does not issue arm retraction while locked=0; (3) candidate fails with timeout on stuck locked=0; (4) normal simulated change still completes for both gray/index variants; (5) failures are visibly reported and software tool number is not incorrectly committed. Items (1)–(5) are **test specifications, not results**.

## Additional carousel rearm discriminator
A separate [MILL-37 source audit](../research/4400_LINUXCNC_MILL_37_CAROUSEL_UNHOME_STALE_READY_REARM_SOURCE_AUDIT_2026-10-31.md) found that the index-mode `carousel.comp` can retain `ready=1` when an externally asserted `unhome` clears `homed`, because the rehome branch bypasses the ordinary ready reset. The stock VMC index HAL **does not connect** `unhome`; this is a conditional component test, not an observed stock-machine fault. Add a disconnected rearm test: finish a move, lower enable, pulse unhome, re-enable without index, and observe `ready`, `homing`, `homed`, and `M66 P0 L3`. The test is not executed. A transaction-specific acknowledgment is preferable to treating a retained HIGH level as proof of the current move.

## Review questions for a fresh AI
1. Why does `M66 P3 L4` not prove that `tool-locked` is true?
2. Which two files require identical new HAL wiring, and why does `num_dio=6` matter?
3. What does `change_epilog` do after `endsub [1]`, and why is a software tool-number update not a force measurement?
4. If a new input is HIGH but a clamping spring is broken, what evidence is still missing?
5. The spindle is oriented by M19. Does that prove it is physically blocked? Consult the **already existing** [SPINDLE-ORIENT-01 source audit](../research/4400_SPINDLE_ORIENT_01_LINUXCNC_2910_CUMULATIVE_ACK_VS_PHYSICAL_LOCK_SOURCE_AUDIT_2026-10-28.md), not a new duplicate investigation.

**Scope:** LinuxCNC implementation learning, not machine safety certification. Preserve independent personnel-safety authority and existing OpenPressBrake gates; no physical toolchanger operation or Actions compute was authorized by this guide.
