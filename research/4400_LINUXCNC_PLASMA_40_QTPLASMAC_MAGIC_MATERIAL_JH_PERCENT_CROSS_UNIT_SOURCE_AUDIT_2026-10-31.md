# 4000-LC-PLASMA-40 — QtPlasmaC magic-comment puddle-jump percentage versus cross-unit conversion

**2026-10-31 · SOURCE/DOC-CONFIRMED conditional, NON-GRADUATED; no runtime/physical test.** LinuxCNC QtPlasmaC material pipeline and CAM-post handoff. Separate from PLASMA-39 geometry and earlier M62 timing work.

## Pinned provenance
- Stable LinuxCNC **v2.9.10**, `src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py` blob `4cdae156b94b607bd2514b1573baabc83f396f23`, `set_default_units` ~548, `check_material_edit` ~994–1080, `write_one_material` ~1140.
- Development commit **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**, same file blob `aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`, `set_default_units` ~633, `check_material_edit` ~1139–1215, `write_one_material` ~1297.
- [QtPlasmaC material and magic-comment specification](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/plasma/qtplasmac.adoc#L1415-L1610) blob `9ed0e825ee543cb6a39ac15d18aa149c29a85b23`; [Puddle Jump is a **percentage of Pierce Height**, max 200%](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/plasma/qtplasmac.adoc#L2259-L2284).
- [plasmac.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/plasmac.comp#L110-L116) blob `8f22cf1789b8adb49fe0a8d7e7cd5bd33444bf6c`: `puddle_jump_height` pin explicitly describes **percentage**, `puddle_jump_percent` is integer (~272), assignment `puddle_jump_height == 0 ? 100 : puddle_jump_height` (~875–876), target `pierce_height * puddle_jump_percent * .01` (~1307).
- [QtPlasmaC GUI material wiring](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/share/qtvcp/screens/qtplasmac/qtplasmac_handler.py#L880-L890) blob `bbfff1eaa906a496aad19f1602464e8ff2828695`: `qtplasmac.puddle_jump_height-f` feeds `plasmac.puddle-jump-height`; material dictionary is loaded into that widget (~4871, ~4929).
- [Upstream metric simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc): `[FILTER]` invokes `qtplasmac_gcode` and `[TRAJ] LINEAR_UNITS=mm`. The reciprocal inch case must be separately configured.

## Call chain and versioned discrepancy
`[FILTER] qtplasmac_gcode` → `Filter.__init__` reads machine `[TRAJ] LINEAR_UNITS` → G20/G21 `set_default_units` sets `unitMultiplier` (25.4 when inch machine reads G21; 0.03937 when metric machine reads G20) → a G-code `(o=0, ..., ph=..., pd=..., ch=..., fr=..., jh=..., jd=...)` magic comment calls `check_material_edit` → `write_one_material` emits `PUDDLE_JUMP_HEIGHT` → GUI material load → HAL pin → realtime `plasmac.comp`.

`ph`, `ch`, `fr` and `kw` are dimensional quantities and their conversion can be appropriate. **`jh` is a dimensionless percentage, not a length.** Yet:
- **Stable v2.9.10:** parses `jh = float(item.split('=')[1])`, then when `unitMultiplier != 1` sets **`jh = ph / self.unitMultiplier`** (~1045–1047). This overwrites the user's percentage with the *already converted pierce height* divided again by the multiplier. It is both a wrong-variable and a wrong-dimension conversion.
- **Development 537cf2d765c9:** changes that line to **`jh = jh / self.unitMultiplier`** (~1189–1192), eliminating the wrong-variable dependency but still converting a percentage as though it were dimensional. **Do not call development fully fixed.**

### Concrete conditional numeric discriminator
For an inch-configured machine, `G21` before the magic comment sets `unitMultiplier=25.4`. With `ph=3.1` mm and `jh=150` (%), source arithmetic yields:
- Intended stored `PUDDLE_JUMP_HEIGHT = 150` (percent; the pierce height alone is converted to inches).
- Stable: `ph=3.1/25.4≈0.122047` inch, then `jh=0.122047/25.4≈0.004805` instead of 150.
- Development: `jh=150/25.4≈5.905512` instead of 150.
The realtime component assigns this HAL float to an integer percentage; precise downstream GUI clamping, validation and machine motion are **UNKNOWN**. Neither erroneous number should be accepted as an intended 150% jump. For same-unit G-code `unitMultiplier=1`, this particular conversion branch is bypassed.

**Why it matters:** a CAD/CAM post that emits material magic comments may appear to specify a valid 150% puddle jump but produce a different material value when the machine and program units differ. This is not an assertion that any particular physical machine moved unexpectedly.

## Separate verified postprocessor contract
Official QtPlasmaC examples use `M3 $0 S1` / `M5 $0` for torch, `$1` scribe and `$2` spot; the common HAL connects `spindle.0.on` to `plasmac.cutting-start`, `spindle.1.on` to `scribe-start` and `spindle.2.on` to `spotting-start` ([HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal#L10-L42)). Automatic material selection is **ordered** `M190 Pn` → `M66 P3 L3 Q1` → `F#<_hal[plasmac.cut-feed-rate]>` ([docs](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/plasma/qtplasmac.adoc#L1490-L1535)). The filter may insert M190/M66 itself for a temporary `(o=0,...)` material. OpenBuilds CAM's inspected generic `M3S...`/M5 output from [CAM-38](4400_LINUXCNC_CAM_38_OPENBUILDS_DXF_NESTED_INSERT_UNITS_GCODE_SOURCE_AUDIT_2026-10-31.md) is **not by itself proof of the explicit QtPlasmaC multi-spindle/material contract**; no incompatibility of all M3 forms is claimed.

## Disconnected acceptance matrix (not run)
| Machine INI | Program units | Magic `jh` | Expected material-file percentage | Why |
|---|---|---:|---:|---|
| mm | G21 | 150 | 150 | baseline same units |
| inch | G20 | 150 | 150 | baseline same units |
| inch | G21 | 150 | 150 | dimensional heights convert; percent does not |
| mm | G20 | 150 | 150 | reciprocal cross-unit case |
| inch | G21 | 0 | 0 in material file, realtime uses 100 default | zero sentinel should remain zero |
| inch | G21 | 200 | 200 | documented upper valid percentage |

Inspect the **generated material file**, not merely the input comment. Verify the selected `[TRAJ] LINEAR_UNITS`, order of G20/G21 relative to the comment, GUI widget, HAL value and realtime pin; distinguish the filter's parse from GUI/material reload. A safe candidate correction is `jh = float(...)` **without any unitMultiplier conversion**, retaining percent validation and the zero sentinel; independently test against both branches before proposing upstream.

**Evidence:** SOURCE-CONFIRMED wrong stable/dev transformations and HAL consumption; DOC-CONFIRMED percentage and ordered post interface; INFERENCE numerical consequences; TEST-CONFIRMED none. No build, workflow, machine operation, external evaluator or new compute runtime. [Acceptance guide](../guides/4000-linuxcnc-qtplasmac-cam-filter-coordinate-material-acceptance-2026-10-31.md). No graduated level or independent safety gate changed.
