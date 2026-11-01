# 4000-LC-LATHE-108 — G76 H-1 suppresses the final full-depth pass; R/E/L documentation-versus-parser boundary

**State:** SOURCE-CONFIRMED static and DOC/SOURCE-CONFLICT as marked; no interpreter execution, cut or physical proof. 3200 lathe / 4000 G-code validation and CAM-post integration. NON-GRADUATED. Inspected 2026-11-01.

## Why this is new, not LATHE-35 repeated

[LATHE-35](4400_LINUXCNC_LATHE_35_G76_G33_SYNC_FEED_FEASIBILITY_AND_OVERRUN_VERSION_SOURCE_AUDIT_2026-10-31.md) already establishes the depth formula, R floor and ordinary full-depth + H spring passes. This audit tests **invalid-input boundaries** and discovers that **H-1 is explicitly permitted by the lexical reader yet suppresses the only guaranteed full-depth pass**, and that other documented errors are normalized or not checked in the inspected path. Do not re-label the known degression formula as a new discovery.

## Immutable source and official docs

- Stable LinuxCNC [v2.9.10 interp_read.cc#L641-L655](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_read.cc#L641-L655), blob `93333860904996732f9fa96f239263c991b2dfd6`; [interp_check.cc#L253-L385](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_check.cc#L253-L385), blob `ee5164c895dd6610826b8621f64660c90de70233`; [interp_convert.cc#L5068-L5162](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L5068-L5162), blob `f01a359652d588d59c9e210fa441a99d2ee19598`; [G76 documentation#L1960-L2051](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/g-code.adoc#L1960-L2051), blob `461c9eae52a9baf4b69895a6b84df250491953cf`.
- Development immutable commit [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/commit/24e84c4506b41634240f7087f0295e361a954886): [interp_read.cc#L640-L654](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_read.cc#L640-L654), blob `6e58d1635dc88d92780e189b1b0b5dde0f06f1b7`; [interp_check.cc#L260-L396](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_check.cc#L260-L396), blob `b2c8bfc80b8e35f8acca3f2dfa535249a47a1712`; [interp_convert.cc#L5994-L6113](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L5994-L6113), blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`; [docs#L2373-L2479](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc#L2373-L2479), blob `46386681cce284fa0cc43e27192bee0aca208766`.
- Additional stable readers: `read_r` at interp_read.cc 2386–2400 accepts real R, `read_e` 444–458 accepts real E, `read_l` 1007–1021 rejects negative L but has no maximum. Development has the same relevant G76 converter logic except `TINY` margin and independent speed preflight.

## H-1: concrete source-derived counterexample

**SOURCE-CONFIRMED:** Both `read_h` implementations use `CHKS(value < -1)`, **not** `value < 0`. Therefore H-1 passes the H-word reader. `check_other_codes` permits H when G76 is the motion command and has no additional H>=0 validation. `convert_threading_cycle` uses `spring_cuts=block->h_number` when H is supplied, and then:

```cpp
// both versions, with unchanged logical structure
while (depth < end_depth) { threading_pass(...); depth = ...; }
for (int i = 0; i < spring_cuts + 1; i++) { threading_pass(...full depth...); }
```

With **H-1**, `spring_cuts + 1 = 0`: the full-depth loop executes **zero times**. The roughing loop is strictly below the full target depth; therefore the converter's normal full-depth pass is omitted. The final rapid to the programmed endpoint still follows. This is a program-path statement, **not** proof of actual cut geometry.

**Numerical witness in G8 radius mode, R1:** J=0.2 mm, K=1.0 mm, I=-0.5 mm. The roughing loop schedules relative thread depths 0.2, 0.4, 0.6, 0.8 mm, then reaches 1.0 and exits. H0 schedules one final 1.0 mm pass. H-1 schedules **no** 1.0 mm pass. G7 would halve the I/J/K numbers internally; keep G8 for this witness. This conflicts with both tagged G76 manuals' statement that negative H is an error.

## Other mismatches (not automatically runtime failures)

| Input | Reader/checker/converter behavior, both inspected versions | Documentation conflict / limit |
|---|---|---|
| R0.5 or R0 | `read_r` accepts; `check_other_codes` permits R with G76; converter changes R<1 to **1.0**. | Tagged G76 docs say R<1 is an error; source instead silently chooses constant-depth progression. The R floor itself was previously recorded in LATHE-35. |
| E negative | `read_e` accepts; converter changes negative taper distance to **0**. | Not a demonstrated G-code rejection. |
| E larger than half the drive-line length | Reader and checker do not enforce this length; converter uses E in taper geometry without comparing to `abs(end_z-start_z)/2`. | Both tagged docs list E>half as an error. Geometry/other runtime consequences are untested. |
| L4 (or other nonnegative value outside 0..3) | `read_l` accepts nonnegative integers; converter computes `entry_taper=L&1`, `exit_taper=L&2`; L4 produces neither. | Docs define L0..L3; source has no explicit max. |
| H0 | One full-depth pass, no additional spring passes. | Matches docs. |
| H1 | One full-depth pass plus one spring pass. | Matches docs. |

**Scope discipline:** This traces the actual `read_*` → `check_other_codes` → `convert_threading_cycle` G76 path. A subsequent Task/motion limit, spindle readiness or machine fault may still prevent actual motion. No executable parser verdict or physical thread quality is claimed.

## Practical impact for 3200 and CAM postprocessors

A postprocessor should **validate before emitting G76** rather than assume the interpreter will reject all documented invalid words: require finite positive P/J/K, I≠0, K>J, integer H>=0, R>=1 if supplied, E>=0 and E<=half the absolute programmed Z travel if supplied, and L in {0,1,2,3}. This is a conservative **CAM-side policy**, not a claim that every such check is performed by LinuxCNC or that satisfying it proves the thread is safe. G7/G8 changes dimensional meaning; independent spindle encoder/index and machine-specific clearances remain essential.

## Reproducible discriminators — all NOT RUN

- **L108-A:** In a disconnected G8 lathe interpreter/simulator, compare H-1 versus H0 on J0.2 K1 R1. Inspect canonical synchronized-pass counts, not only exit status. Expected source-derived last depth: 0.8 versus 1.0 mm.
- **L108-B:** Compare R0.5 versus R1.0; source predicts same depth schedule. Preserve actual parser exit status and canonical sequence.
- **L108-C:** Compare E greater than half the Z travel, with L2; record parser acceptance separately from emitted geometry and motion limits.
- **L108-D:** Compare L4 versus L0; source predicts neither taper branch selected.
- **L108-E:** Confirm H-2 fails at `read_h`, while H-1 reaches conversion; preserve exact diagnostic.

No qualified isolated `[self-hosted, openpressbrake]` runner has been established for this session. No hosted Actions fallback, LinuxCNC build, simulation, machine operation, external evaluator or new authoritative job runtime. These findings do not reopen graduated levels or change independent personnel-safety authority.

## Upstream ngcgui consumer — partial preflight, not a general validator

Pinned development [nc_files/ngcgui_lib/lathe/g76base.ngc#L17-L46](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/nc_files/ngcgui_lib/lathe/g76base.ngc#L17-L46), blob `f07045f171ee32c4a5aa1d0543576f9c1ad89b15`, exposes H, R, E and L as user arguments. It explicitly rejects L values outside 0..3 (lines 41–46), but has **no corresponding H>=0, R>=1 or E<=half-length validation** before emitting the [G76 block at line 113](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/nc_files/ngcgui_lib/lathe/g76base.ngc#L107-L113). The same wrapper does not expose development D. This is a source-confirmed **partial consumer validation** pattern, not proof that any installed ngcgui actually ran H-1 or that its UI permits all typed values. A new CAM post should not copy this wrapper as a complete G76 input validator.
