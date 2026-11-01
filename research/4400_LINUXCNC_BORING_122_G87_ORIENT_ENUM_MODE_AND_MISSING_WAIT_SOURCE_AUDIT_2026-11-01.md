# 4400-LC-BORING-122 — G87 back-boring orientation mode is not M19 mode (source audit)
**2026-11-01 | 4000 LinuxCNC interpreter/Task/HAL; 3100 mill transfer | NON-GRADUATED**

## Question and novelty
Does G87 guarantee the oriented spindle position before traversing a back-boring tool through a hole, and does its direction parameter mean the same thing as the M19 P parameter? This is a distinct source path from [SPINDLE-100/101](4400_LINUXCNC_SPINDLE_100_EL8_AT_SPEED_DEBOUNCE_AND_HAL_ORDER_SOURCE_AUDIT_2026-11-01.md), the earlier [VMC M6 study](4400_LINUXCNC_MILL_36_VMC_M6_REMAP_DRAWBAR_ACK_GAP_SOURCE_AUDIT_2026-10-31.md), and G81/G73/G83 studies. A full PROGRESS and research filename search found no prior G87 implementation trace. It is NOT a new graduated 3100 competency.

## Pinned source ledger
| Evidence | Revision / blob | Symbol and direct observation |
|---|---|---|
| [Stable interpreter](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc) | v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`, blob `3d3fd818ac1f36fd7a36620c654ad6b3677295be` | `Interp::convert_cycle_g87` ~line 541: STOP; ORIENT(0°, direction); **no WAIT**; rapid to bottom, lateral rapid, start spindle, feed up/down, second STOP/ORIENT, lateral/vertical rapid, restart. |
| [Development interpreter](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_cycles.cc) | `06864e23559e70463fc7112d5ce77138bcbc288c`, blob `bbebc0d6ed872688c701a12f5a1467bff5f4fd94` | Same G87 sequence, ~line 536. |
| [Canonical direction enum](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/nml_intf/canon.hh) | stable, ~line 92; development blob `9a0a4de911c37ddace624b175f7bc6992d4fb05b` | `CANON_STOPPED=1`, `CANON_CLOCKWISE=2`, `CANON_COUNTERCLOCKWISE=3`. |
| [Canonical Task commands](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) | stable blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, ~lines 1961–1981 | `ORIENT_SPINDLE` and `WAIT_SPINDLE_ORIENT_COMPLETE` are **separate** queued messages; the former does not implicitly enqueue the latter. |
| [Task pre/postconditions](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc) | stable blob `7292a172023a5b42b023447c2458cb766c93fc9b`, ~lines 1546, 2491, 2695 | ORIENT precondition waits for preceding motion/IO, but ORIENT postcondition is DONE. Only `EMC_SPINDLE_WAIT_ORIENT_COMPLETE` enters `WAITING_FOR_SPINDLE_ORIENTED` with timeout and state check. |
| [Stable orient HAL component](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/orient.comp) | blob `554153a58e29724ff005dc448ca931bd081f2f18`, ~line 81 | `switch(mode)` implements 0 shortest, 1 clockwise, 2 counterclockwise; **no case 3**. |
| [Development orient HAL component](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/components/orient.comp) | blob `d6359c61efbf1c33cb482eef71bfb9d1e7cb2255`, ~lines 89, 121 | Mode 3 starts **index search** then shortest-angle orient; mode 2 commands counterclockwise. |
| [Official G-code reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) | stable blob `461c9eae52a9baf4b69895a6b84df250491953cf`, ~line 2619; development blob `46386681cce284fa0cc43e27192bee0aca208766` | Both say G87 is accepted but *unimplemented/undefined*. The inspected interpreter **does** emit a defined sequence of canonical commands. |

## Exact call-flow / numeric discriminator
G17 G87 `convert_cycle_xy` requires I,J,K on first G87, passes the active spindle's `spindle_turning` enum to `convert_cycle_g87`; it does **not** translate the enum to M19 P semantics. `ORIENT_SPINDLE(spindle,0.0,direction)` flows through canonical Task `EMC_SPINDLE_ORIENT` to Motion `spindle.N.orient-mode`; the [motion command](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/command.c) copies the integer mode without remapping it. Stock `orient.comp` interprets the integer independently.

| Active spindle before G87 | Enum passed as orient mode | Stable stock orient.comp | Development stock orient.comp |
|---|---:|---|---|
| M3 / clockwise | 2 | Always **counterclockwise** to orient target | Always **counterclockwise** to orient target |
| M4 / counterclockwise | 3 | **No switch case 3**; command is not assigned on enable edge by that switch | **Index search**, then shortest move (requires an index-enable handshake) |

This is a **SOURCE-CONFIRMED numeric mismatch**, not a claim that every installation uses stock `orient.comp` or that a physical axis moved. The development mode-3 behavior is a version-specific functional change, not evidence of a corrected G87 mapping.

## The missing completion barrier
G87 issues ORIENT and immediately follows with traverse commands in the canonical sequence. It does not issue `WAIT_SPINDLE_ORIENT_COMPLETE` before either passage of the tool. Task's ORIENT postcondition is DONE; its separate WAIT command is what checks spindle orientation state and times out. A prior-motion/IO drain is not a spindle-position acknowledgement. Thus **the inspected stock command chain does not itself require `spindle.N.is-oriented` before the G87 clearance traverse**. Timing and actual command overlap require disconnected execution; no collision or failed bore has been reproduced.

## Documentation and evidence classification
- **DOC-CONFIRMED** both tagged G-code references warn G87 accepted but undefined. That warning is important for CAM post design.
- **SOURCE-CONFIRMED** both interpreter revisions generate explicit G87 canonical motion/spindle commands; G87 lacks the explicit orientation WAIT; the enum-to-orient-mode mismatch exists in both, with distinct stock HAL consequences.
- **INFERENCE** orientation may be incomplete or directionally wrong when the clearance traverse is issued; actual Task scheduling, spindle mechanics, HAL wiring, and machine envelope UNKNOWN.
- **TEST-CONFIRMED none**: no interpreter, Task, HAL, hardware or simulator run.

## Verification and disposition
Do **not** enable native G87 in a production CAM post on this source evidence. Prefer a separately designed, reviewed boring operation with explicit spindle-stop, verified orientation, independent clearance and appropriately sequenced motion. A bare M19 without Q is **not** an orientation-complete barrier; M19 Q introduces the documented wait but does not establish tool clearance or personnel safety. If a qualified, physically disconnected `[self-hosted, openpressbrake]` environment becomes available, instrument G87 canonical command order for M3/M4 and test stock orient mode 2/3 with simulated encoder/index; inspect Task state and timeout. Never run the fixture on an energized spindle or machine. Keep the separate independent personnel-safety authority and existing evaluation gates unchanged.
