# 3200/4000 — LinuxCNC G76 lathe threading: versioned multi-start and CAM-post preflight

**Purpose:** A practical, source-inspectable review of how an ordinary G76 block becomes a sequence of spindle-synchronized X/Z moves, and why a CAM post or MDI form must not assume that LinuxCNC rejects every malformed threading word. **Not a ready-to-run machine program.** All examples are conceptual, disconnected/simulation-only. No machine operation or proof of safe clearance.

**Start with:** [LATHE-107 D-angle interpreter→Task→TP and UI trace](../research/4400_LINUXCNC_LATHE_107_G76_D_MULTISTART_VERSION_CANON_TP_UI_SOURCE_AUDIT_2026-11-01.md), [LATHE-108 H-1 and R/E/L validation](../research/4400_LINUXCNC_LATHE_108_G76_H_MINUS1_FULL_DEPTH_R_E_L_VALIDATION_SOURCE_DOC_AUDIT_2026-11-01.md), [LATHE-35 synchronized-feed feasibility](../research/4400_LINUXCNC_LATHE_35_G76_G33_SYNC_FEED_FEASIBILITY_AND_OVERRUN_VERSION_SOURCE_AUDIT_2026-10-31.md), and [SPINDLE-22 multi-spindle at-speed/index](../research/4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md). These are **NON-GRADUATED** source investigations.

## 1. Identify the actual controller and G-code contract

Check the installed LinuxCNC version and G76 documentation. Stable **v2.9.10** does **not** accept `D` on G76. The pinned **development 24e84c4506b41634240f7087f0295e361a954886** accepts D as spindle-index phase offset; this is not a promise that a released production installation has the feature. G76 is not Fanuc G76: LinuxCNC P is pitch (distance/revolution), I is signed thread-peak offset, J first cut, K full depth, R degression, Q compound infeed angle, H spring-pass count, E/L entry/exit taper. `$` selects the spindle, not a D offset.

Choose G7 **diameter** or G8 **radius** deliberately. The interpreter halves I/J/K under G7; it does not halve them under G8. Verify the active ZX plane (G18), absolute/incremental mode, tool offset, spindle index source and whether spindle at-speed is derived from real feedback. The TP may wait for **every configured spindle's at-speed** even though only the selected spindle's index is requested (SPINDLE-22). Neither status pin is an independent personnel-safety function.

## 2. Version-aware multi-start example

**Geometry only, not executable setup:**

```ngc
(ASSUMED: G18 G21 G8 G90, independently validated tool/clearance)
(ASSUMED: one genuine spindle index per revolution and correct spindle.N.revs)
(illustrative thread block for first start)
G76 P3.0 Z-20 I-0.5 J0.2 K1.0 R1.0 H0 E2.0 L2 D0
(illustrative second start in PINNED DEVELOPMENT ONLY)
G76 P3.0 Z-20 I-0.5 J0.2 K1.0 R1.0 H0 E2.0 L2 D180
```

These are **not consecutive commands to execute**: each cycle needs a separately planned approach at the correct drive-line X/Z, clearance and return, and the example lacks machine setup. For a two-start thread with 3 mm **lead**, each start has 3 mm axial pitch and the two helices are offset by 180 degrees; the axial spacing between starts is 1.5 mm. Do not confuse lead and effective multi-start pitch. The older [2015 community method](https://forum.linuxcnc.org/20-g-code/29089-threading-multiple-start-is-possible) uses separate G76 cycles with a **1.5 mm Z start shift**, which is a different version-compatible way to create the offset. A production post must choose one supported method and prove its geometry in simulation, not combine D phase and axial shift blindly.

In pinned development, `D180` passes from the parser to canonical `angular_offset_degrees`, then to TP `pending_offset=0.5` revolution. `D450` becomes 1.25 revolutions and is **not** reduced modulo one turn. Do not assume `D` is supported just because the GUI offers a field: development Touchy lists D/$; development Gscreen's template does not, and the upstream ngcgui g76base subroutine emits neither D nor $. Manual G-code and customized interfaces may differ.

## 3. Source-derived pass-depth calculation

In G8 with `J0.2 K1.0 R1.0`, the converter uses `depth = abs(I)+J*pass^(1/R)` for roughing, then separately schedules full-depth `abs(I)+K`. Relative to the thread peak, rough depths are **0.2, 0.4, 0.6, 0.8 mm**, then H0 causes **one** 1.0 mm pass. H2 causes three full-depth passes total (one ordinary + two spring). **H-1**, although contrary to the manuals, passes the H reader and makes the full-depth loop empty: the last scheduled cutting depth is only **0.8 mm** in this example. This is source-derived canonical geometry, not a measured thread.

For `R2`, the rough-depth progression is `J*sqrt(pass)`, not a fixed increment. For `R0.5`, the converter silently substitutes R1.0 despite the manual listing R<1 as an error. An invalid input that happens to be accepted by the interpreter must still be rejected by a strict CAM post.

## 4. Minimal preflight contract for a CAM/post or operator review

Use the following **conservative application-side** conditions before emitting G76:

| Input / dependency | Preflight rule | Why |
|---|---|---|
| Version | Resolve exact binary/version and feature set; forbid G76 D on stable v2.9.10 | Stable parser rejects D; development feature is version-specific. |
| Units and coordinates | Explicit G20/G21, G18, G7/G8, coordinate datum and approach/retract | I/J/K change meaning between radius and diameter; final rapid and internal-bore exit require clearance. |
| P, I, J, K | Finite P>0, I≠0, J>0, K>J | Avoid invalid or nonsensical depth/synchronization requests. |
| H | Integer H>=0 | Source reader permits H-1, which suppresses the mandatory full-depth pass. |
| R | Omit or require finite R>=1 | R<1 is normalized, not rejected in inspected conversion. |
| E, L | E>=0 and E<=abs(Zfinal-Zstart)/2; L integer 0..3 | Source does not enforce the documented half-length cap; L4 masks to no taper. |
| D | If supported, finite angle, nonnegative; check 360+ semantics explicitly | D450 waits an extra revolution, not the same start timing as D90. |
| Spindle | One index per revolution, correct rev scale, at-speed logic, feedback freshness | TP index and phase are derived from those signals. |
| Velocity | Compare abs(pitch)*RPM with axis limits, including X/Z taper vector and G96 caps | Development preflight is conditional on available machine limits; stable lacks that guard. |
| Geometry | Independently review entry/exit relief, stock, shoulder, tool nose, boring clearance and any multi-start axial shift | Interpreter acceptance does not prove machinability. |

These are proposed application checks, **not a statement that LinuxCNC implements every row**. Preserve the unmodified post output and a separate human-approved machining plan. Ordinary LinuxCNC/Mesa controls must not replace independent personnel-safety authority.

## 5. Bounded disconnected acceptance — NOT RUN

Do **not** dispatch until the `[self-hosted, openpressbrake]` runner is positively qualified as disconnected from physical actuation. Never use a hosted Actions runner or a live machine.

**A — Version boundary:** Run identical G76 D180 input through stable v2.9.10 and pinned development standalone interpreters. Capture source/binary versions, diagnostics and exit codes; stable is predicted to reject D, development to accept the syntax. Standalone acceptance is **not** a physical-motion oracle or a sufficient axis-feasibility test (LATHE-35).

**B — H-1 full-depth:** Compare H-1/H0/H2 on G8 J0.2 K1 R1. Capture canonical synchronized feed segments and maximum scheduled cut depth; expected 0.8/1.0/1.0 mm and 0/1/3 full-depth passes respectively. Confirm no earlier validation rejects H-1 before calling this TEST-CONFIRMED.

**C — R/E/L checks:** Compare R0.5 vs R1, E>half with L2, and L4 vs L0. Record parse verdict **separately** from canonical geometry and subsequent motion/limit checks.

**D — Phase and exit taper:** In development only, capture the canonical `EMC_TRAJ_SET_SPINDLESYNC` angle for D180 entry, main and exit-taper segments, and the queued TC `angle_offset` plus `spindle.offset` continuity. A zero exit-taper TC angle is expected from source, but **do not** claim a physical phase discontinuity without a trace demonstrating it.

No cases have been executed, no job runtime is available, and `LAB_COMPUTE_LOG.md` remains unchanged. Do not graduate or alter evaluation gates on these static findings.

## 6. Fresh-engineer diagnostic exercise (unscored)

A CAM-generated G76 program previews an apparently valid thread but produces fewer passes than expected in a source-only review. The post emits `H-1 R0.5 L4`. Trace `read_h`, `check_other_codes`, `convert_threading_cycle`, then `threading_pass` and explain why **three independent transformations** matter: H suppresses the final full-depth pass, R normalizes to 1, and L4 selects neither taper. Identify the exact version, verify the spindle/index and limit path separately, and propose a strict preflight. This is a source-navigation exercise, not a blind test or a demonstrated cut.

**Next:** Validate only if isolated compute is qualified; otherwise move to a distinct LinuxCNC implementation topic rather than adding more unrun G76 cases.

### Preview-oracle warning

Pinned development [Python gcodemodule.cc#L645-L652](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/gcodemodule.cc#L645-L652) discards the G76 D-angle and spindle selector in its `START_SPEED_FEED_SYNCH` callback, retaining only pitch. Therefore **matching X/Z preview geometry for D0 and D180 does not validate multi-start phase**. Pinned [standalone saicanon.cc#L756-L764](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/sai/saicanon.cc#L756-L764) prints nonzero angle, which can distinguish interpreter canonical output but still cannot verify realtime spindle/index behavior. Use three separate observations: preview geometry, canonical phase record, and (only on qualified disconnected compute) TP/index state.
