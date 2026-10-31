# Practical guide — LinuxCNC G70/G71/G72 lathe profile/CAM acceptance

**Scope:** LinuxCNC v2.9.10 and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Software-only, disconnected, no physical axes/spindle/tool. **ALL CASES NOT RUN.** Evidence basis: [LATHE-61](../research/4400_LINUXCNC_LATHE_61_G7X_PROFILE_R_ARC_SIGN_AND_RADIUS_VALIDATION_SOURCE_AUDIT_2026-10-31.md), [LATHE-62](../research/4400_LINUXCNC_LATHE_62_G7X_PROFILE_SIDE_EFFECTS_PRELIMINARY_MOVE_AND_PASS_DRIFT_SOURCE_AUDIT_2026-10-31.md), official [G71/G72 docs](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html#gcode:g71-g72).

## Reproducible starting fixture
Start from the upstream pinned `nc_files/lathe_g70_71_demo.ngc` [v2.9.10 source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/lathe_g70_71_demo.ngc) rather than inventing undocumented O-subroutine syntax. The minimal structure is:

```ngc
G18 G21 G90 G40
F400
O100 SUB
  G0 X10 Z0
  G1 X9 Z-2
  G1 X8 Z-8
  G1 X8 Z-12
O100 ENDSUB
G71 Q100 X10 Z0 D0 I1 R0.3
M2
```

This is a **proposed fixture**, not a verified executable or cutting program. A Q profile's first move, tool position, and monotonicity must be checked against the actual interpreter and machine configuration. Use simulation-only output and record whether this baseline is valid before interpreting deltas.

## Frozen comparison matrix
| Case | Change from valid baseline | Source-predicted discriminator | Required oracle |
|---|---|---|---|
| L61-A | Profile G2 with R8, endpoints separated by 10 | Q-profile center follows G2 offset rule | canonical center and generated path |
| L61-B | Same G2 endpoints, R-8 | Q-profile center **identical** to R8, unlike ordinary arc sign convention | compare profile center, ordinary G2 center and G71 result |
| L61-C | Same endpoints, R4 | negative sqrt argument at Q-profile construction | exact error/exit and finite-coordinate check |
| L61-D | Use I/K arc instead of R | development performs extra `arc_data_ijk` validation; stable differs | versioned interpreter verdict |
| L62-P1 | Missing Q subroutine, G71 X/Z start differs from current | preliminary rapid is constructed before profile read; physical execution UNKNOWN | canonical queue, Task error and motion state |
| L62-P2 | Q profile assigns `#100=123` | assignment code is visited, persistence UNKNOWN | post-cycle interpreter parameter read |
| L62-P3 | Many small-I passes | stable repeated subtraction vs development top-minus-n-delta | generated pass-level CSV, max error |
| L62-P4 | Upstream G71.1/G71.2/G70 fixture | distinguish first-pocket and finishing paths | full canonical path per cycle |
| L62-P5 | Invalid contour after X/Z preliminary rapid | error ordering vs already-queued rapid | interpreter, Task, and realtime trace |

**Important:** L61-A/B require a Q profile with at least two nonzero segments and geometry accepted by the G7x monotonicity checks. If either variant fails before a contour is emitted, that is an *acceptance result*, not proof that the signed-R source finding is false. Use an instrumented interpreter path to inspect the constructed center when necessary. Never interpret a GUI preview or a successful process exit alone as the full motion oracle.

## Harness and evidence contract
1. Pin and log source tag/commit, exact INI/HAL, executable hash, G-code fixture hash, and interpreter exit code.
2. Run first with LinuxCNC simulation and **no connected machine outputs**. Capture interpreter canonical motion with line numbers, X/Z and I/K/R values; capture Task error stream and motion queue outcome separately.
3. Compare source-predicted geometry to observed output. Do not silently replace invalid test geometry with a new profile; version each revision.
4. For negative-R: calculate both candidate centers from the ordinary `arc_data_r` rule and compare to G7x's `r*r` path. For R4/chord10: check that the intermediate radicand is -0.09, then observe *whether* a finite-coordinate validation rejects it.
5. Keep a clear table: **SOURCE-CONFIRMED / TEST-CONFIRMED / INFERENCE / UNKNOWN**. Failed setup or a synthetic motion-logger pass is **HARNESS INVALID** for physical/Task conclusions.
6. Any CI compute must use **only** an approved isolated `[self-hosted, openpressbrake]` runner; no GitHub-hosted fallback. No physical machining. Personnel safety and independent evaluator remain separate.

## Handoff question (unscored)
A CAM post emits `G2 ... R-8` inside a G71 Q subroutine. Explain why the plain-G2 sign convention is not sufficient to predict the roughing contour; locate the exact two source branches and design a no-motion discriminator. Do not treat this public question as a blind evaluation.
