# 4000-LC-TP-30 — G64 P/Q, canonical geometry coalescing, and motion-synchronized output boundaries

**Date:** 2026-10-31. **Status:** SOURCE-CONFIRMED static conditional / DOC-CONFIRMED / UPSTREAM-TEST-DEFINED; **TEST-CONFIRMED none**. NON-GRADUATED. LinuxCNC-first 4000 work, applicable to mill, plasma, router and OpenPressBrake toolpath handoffs; not a production machine acceptance.

## Question and version pins

When a CAM post emits `G64 P… Q…`, which geometry does the realtime planner actually receive, and does an M62/M63 output marker preserve the programmed vertex?

Pinned LinuxCNC **v2.9.10**:
- [interpreter control mode](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L1633-L1668), blob `f01a359652d588d59c9e210fa441a99d2ee19598`;
- [canonical segment buffer and linkability](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L875-L1033), [arc chord conversion](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1269-L1294), [XY arc handling](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1496-L1531), [motion-output flush](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3137-L3175), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`;
- [TP synchronized output staging and activation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L1547-L1558), [parabolic overlap](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3039-L3067), [regular cycle](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3370-L3389), [DIO mask](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3618-L3629), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`;
- [official trajectory concepts](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/user/user-concepts.adoc#L65-L110) and [existing interpreter g6164 expected output](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/tests/interp/g6164/expected), blob `061d73ac742eb2886cc9a2c43bb964609ca6194a`.
- Compared development commit [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886): canonical `linkable`, XY chord test, and P/Q inheritance remain present. Development also adds a distinct G64 R planner-selection extension; see [TP-31](4400_LINUXCNC_TP_31_DEVELOPMENT_G64_R_PLANNER_SWITCH_DEFER_AND_REJECTION_SOURCE_AUDIT_2026-10-31.md).

## Source-to-motion trace

1. `Interp::convert_control_mode(G_64)` passes P to `SET_MOTION_CONTROL_MODE(CANON_CONTINUOUS, P)`. If Q is omitted but P is specified, **Q inherits P**; if neither is specified, both are zero in v2.9.10. `G64 P0` without Q therefore disables naive-CAM merging but does **not** mean exact-path mode. `G64 P0 Q>0` permits geometry coalescing with no positive planner corner-tolerance bound; do not confuse the two independent knobs.
2. Canonical `STRAIGHT_FEED` does not immediately send each programmed G1. It buffers points in `chained_points`. `linkable` requires continuous mode, nonzero Q, unchanged ABCUVW coordinates, no degenerate overall XYZ chord, and each buffered intermediate point within Q of the chord from the **last flushed canonical endpoint** to the new endpoint. It forces a flush when more than 100 points are already buffered. A successful chain is emitted as **one** `EMC_TRAJ_LINEAR_MOVE` to the last endpoint; intermediate programmed vertices are not separately queued TP segments.
3. **Diagnostics/state-tag consequence:** `flush_segments()` constructs the one surviving `EMC_TRAJ_LINEAR_MOVE` from `chained_points.back()`, takes its **last point's `line_no` and `StateTag`**, and calls `interp_list.set_line_number(line_no)` plus `tag_and_send(...,pos.tag)`. Thus intermediate G-code line identities are not each represented by a separate canonical move. A motion/status display that advances directly to the last line of a merged chain does not by itself prove the intermediate G1s were skipped by the interpreter; they may have been consumed by canonical simplification.
4. For XY G2/G3 in continuous mode, if `chord_deviation` is **strictly less than Q**, `ARC_FEED` substitutes start→arc-midpoint→end as two candidates for the same line-merging algorithm. This is not a universal conversion of every arc; other planes and larger deviations take the circular-move path. The chord helper uses the sign of `rotation` for its included-angle branch; this audit does not establish multi-turn-arc equivalence for every CAM representation.
5. Canonical `SET_MOTION_OUTPUT_BIT` / `CLEAR_MOTION_OUTPUT_BIT` **flush the buffered geometry before queuing the synchronized output command**. Thus an M62/M63 marker separates the preceding naive-CAM chain from subsequent geometry. It does **not** by itself request an exact stop or guarantee an output transition at the programmed vertex.
6. Motion stages output changes on the **next queued TC segment** via `tpSetupSyncedIO`. `tpSetDout` maintains a per-index mask; two writes to the **same** DIO before the next motion overwrite that index's staged value, whereas writes to distinct DIO indices can coexist. The old canonical comment saying multiple writes clear previous ones is too broad if read as applying to different indices.
7. `tpToggleDIOs(tc)` applies the staged values when TP chooses that segment for status/output. In a parabolic overlap, the code switches to `nexttc` when its current velocity is at least the previous segment's velocity; this may be **during the blend**, not at the exact geometric corner. Tangent-split handling has its own status selection. An output marker is a motion-associated timing boundary, **not an independent position-trigger or guaranteed vertex event**.

## Discriminating software-only acceptance cases (not executed)

Use disconnected simulation with units explicitly fixed (e.g., G21, G17, G90, G94), a known `F`, and inspect canonical `EMC_TRAJ_LINEAR_MOVE` messages and/or TP execution; do not infer from GUI preview alone.

| Case | P/Q | G1 path after starting at X0 Y0 | Predicted canonical behavior |
|---|---|---|---|
| A | `G64 P0.05 Q0.02` | X10 Y0 → X20 Y0.01 → X30 Y0 | Interior deviation <= 0.01 mm; chain can coalesce to one line to X30 Y0 (assuming no other flush). |
| B | `G64 P0.05 Q0.001` | same | Intermediate deviation near 0.005 mm exceeds Q; do not expect a single three-segment chain. |
| C | `G64 P0.05` | same | Q inherits 0.05 mm, so same chain eligibility as A. |
| D | `G64 P0.05 Q0` | same | No naive-CAM coalescing; TP blending can still occur. |
| E | A plus `M62 P0` before X20 Y0.01 | same | Flush before M62; staged DIO applies to subsequent motion, not necessarily at the X10 vertex in a blended execution. |
| F | `M62 P0` then `M63 P0` before next motion | any | Same-index staged value overwritten: no independently queued high-low pulse is guaranteed. |

For XY arc simplification, use a known-radius shallow G2/G3 and compare Q below/above the computed sagitta. Preserve actual canonical output, state tags, output transition traces and exit status if later executed. Separate **programmed geometry**, **canonical geometry**, **TP path**, and **measured tool position**.

## Consequence and evidence boundary

For plasma torch control, router outputs and press-brake integration, never infer that a nominal DXF vertex or M62 command means an exactly located physical edge. Explicitly specify geometry tolerance, postprocessor mode, HAL/servo timing and required synchronization; use hardware position capture or an independent controller when the application needs a stronger timing guarantee. Independent personnel-safety authority remains separate. **No runtime test, simulation, build, physical operation or independent evaluation was performed**; source statements above are conditional on the cited version and configuration.
