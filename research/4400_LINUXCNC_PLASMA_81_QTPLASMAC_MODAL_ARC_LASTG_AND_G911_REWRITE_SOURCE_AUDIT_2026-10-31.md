# 4000-LC-PLASMA-81 — QtPlasmaC filter's remembered G word is not the interpreter's modal motion

**2026-10-31 | LinuxCNC-first 3300 plasma CAM/post integration | NON-GRADUATED, SOURCE-ONLY.** A distinct **filter state and rewrite** finding, not a physical machine incident or a repeat of [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md). This matters when a CAM post suppresses repeated modal G2/G3 words.

## Exact provenance and source trace

- LinuxCNC stable **v2.9.10**, [`src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `4cdae156b94b607bd2514b1573baabc83f396f23`: `process_file` ~169–255 → `parse_code` ~257–383 → `set_last_gcode` ~534–546; `do_arc` ~789–799.
- LinuxCNC development commit **`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`**, [same file](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`: `parse_code` ~313–459 → `set_last_gcode` ~619–631; same mechanism.
- Stable LinuxCNC [`src/emc/rs274ngc/interp_internal.cc::Interp::enhance_block`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_internal.cc#L165-L215), blob `829591161dfd9bf444cce5ef9d2b9a0a903dedff`: **lines 212–214 explicitly set `motion_to_be=settings->motion_mode` for IJK-only blocks when modal motion is G2/G3**, and [`interp_check.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_check.cc#L286-L303), blob `ee5164c895dd6610826b8621f64660c90de70233`, permits I/J for arc motion. Pinned development `interp_internal.cc` blob `bcccebe27c2a1ee55073bf734b1a68d64e4bbf80` retains the branch ~218–220. This is an independent interpreter-side **source oracle**, not a runtime pass.
- [Official LinuxCNC G-code modal groups](https://www.linuxcnc.org/docs/2.9/html/gcode/overview.html) distinguish motion G2/G3 from G90/G91 linear distance and G90.1/G91.1 arc-center modes; [QtPlasmaC docs](https://www.linuxcnc.org/docs/2.9/html/plasma/qtplasmac.html) describe automatic G2/G3 hole sensing. Do not assume a post's modal compression is transparent to the QtPlasmaC filter.

### P1 — An intervening G91.1 can cause an axis-only line to be prefixed with G91

In both revisions, `set_last_gcode(data, previous)` takes `data.rfind('G')`, then reads **only the integer digits immediately after that last G**. It does **not** restrict itself to modal motion-group G words, and it discards a decimal suffix. `parse_code` then prefixes lines beginning `X/Y/Z/A/B` (development also C) with `G{self.lastG}` before processing distance modes.

Source-only thought experiment (assume initial XY=(0,0); the first arc's center/radius are consistent; separate NC lines):
```gcode
G90 G91.1
G3 X10 Y10 I10 J0
G91.1
X0 Y0 I0 J-10
```
The filter remembers `lastG=3` after the explicit arc, then **overwrites it with 91** after `G91.1`. The next axis-first line is rewritten to begin **`G91 X0 Y0 I0 J-10`**, not `G3 ...`. Its own `distMode` changes to 91 because the rewritten line contains G91 without the decimal. This is a **SOURCE-CONFIRMED conditional rewrite**, not a captured filter run. The interpreter's eventual response, actual motion, and whether the source program's modal arc is otherwise legal remain **NOT TESTED**. The post should avoid relying on axis-only modal compression across G90.1/G91.1 boundaries.

### P2 — An intervening non-motion G64 can be remembered as the next line's motion prefix

Likewise, after `G3...`, then `G64 P0.05`, an axis-first line is rewritten to begin `G64 X... Y...` because `lastG=64`. This is not equivalent to re-emitting `G3`. **SOURCE-CONFIRMED filter text transformation**; whether the LinuxCNC interpreter rejects the resulting combination or treats the axis words through retained modal motion is **UNKNOWN** until isolated interpreter evidence. Do not claim a crash, collision, or universal rejection.

### P3 — Modal I/J-only full-circle lines are not expanded for the hole filter

`parse_code` prefixes only lines whose first character is in the listed *axis* letters, **not** `I` or `J`. The auto-hole processing branch invokes `do_arc` only when the resulting text begins `G02` or `G03` (stable ~363–365, development ~439–441). Thus after a previous explicit G3, a subsequent **`I-5 J0`** line retains its I-leading text and does **not** enter QtPlasmaC's automatic hole branch. This is a **SOURCE-CONFIRMED filter recognition gap** for the specified input text; **the interpreter explicitly recognizes an IJK-only block as modal G2/G3 motion** in `Interp::enhance_block` when the previously active motion mode is G2/G3; full arc geometry validation and actual execution still require independent testing. A post emitting an explicit `G3 I-5 J0` takes the inspected filter branch, subject to the already known prior-position/hole-mode constraints.

## Why this matters to nesting/CAM

[Nesting-to-NC CAM-80](4400_LINUXCNC_CAM_80_QTPLASMAC_G1_TESSELLATED_HOLES_VS_G2_G3_AUTO_PROCESS_SOURCE_AUDIT_2026-10-31.md) shows that G1 tessellation removes the G2/G3 auto-hole trigger. **This audit adds a different failure mode:** even when the post retains arcs, suppressing repeated G2/G3 or inserting non-motion G codes can prevent correct automatic recognition or rewrite subsequent lines. A post contract for QtPlasmaC should explicitly emit **G2/G3 on every hole arc** and maintain explicit G90/G91 and G90.1/G91.1 state; do not assume ordinary interpreter modal rules and the Python filter's `lastG` heuristic are identical.

This is an **integration requirement for this pinned filter**, not a claim that all LinuxCNC G-code must repeat G2/G3 or that arbitrary modal compression is invalid in the interpreter.

## Frozen acceptance and evidence ledger

| Case | Input | Source prediction | Independent oracle still needed |
|---|---|---|---|
| P1 | `G3` → `G91.1` → axis-first arc line | Filter injects G91 and switches its own linear distance mode | actual filtered output; interpreter canonical/status |
| P2 | `G3` → `G64 P0.05` → axis-first arc line | Filter injects G64 instead of G3 | actual filtered output and interpreter acceptance |
| P3 | `G3` → `I-5 J0` modal full circle | No filter `do_arc`; interpreter `enhance_block` selects modal G3 | filter M67 output; independent complete arc/interpreter execution |

All three **NOT RUN**. Do not use physical plasma, torch, machine I/O, or an unverified self-hosted panel PC. The [practical guide](../guides/4000-linuxcnc-nesting-dxf-svg-plasma-handoff-acceptance-2026-10-31.md) includes these as P1–P3, with a [precise checkpoint](../checkpoints/20261031T214200Z-4000-linuxcnc-nesting-cam-next.md). No independent evaluator, graduated level or personnel-safety gate changed.
