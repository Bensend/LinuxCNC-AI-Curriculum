# LATHE-63 — G70 finishing P-count validation and pass generation

**2026-10-31 | LinuxCNC 4000 / lathe 3200 transfer | SOURCE-CONFIRMED conditional, NOT TESTED, NON-GRADUATED**

## Distinct question
After tracing G71/G72 profile geometry in LATHE-61/62, inspect G70 finishing-pass count as a **separate** CAM post contract. Official [LinuxCNC 2.9 G70 documentation](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html#gcode:g70) says P is the number of finishing passes, default 1; its listed error conditions do not expressly forbid P0 or noninteger P. This is not an argument that either is supported.

## Source
Pinned v2.9.10 `src/emc/rs274ngc/interp_g7x.cc` blob `4baa447054d7e0b27a14824f0c798dfa521f3ee3`, `Interp::convert_g7x` and `g7x::do_g70` ([source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_g7x.cc)); pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` blob `9056396be8644adb59af4bea961162a1e06bb970` ([source](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_g7x.cc)). Also inspected v2.9.10 `interp_check.cc::check_items` for P-word admission, which permits P with G70 but has no G70-specific positive-integer test in the inspected P path.

## Exact path
- Both versions initialize finishing pass count P to 1. Stable stores `double p=1` and copies `block->p_number`; development stores `int p=1` and uses `static_cast<int>(block->p_number)`.
- `g7x::do_g70` iterates `for(int pass=p; pass>0; pass--)`. Thus P0, or negative P, yields **zero generated finishing-pass iterations** at this source loop. This is not yet a verified end-to-end interpreter acceptance claim. The preliminary G0 and Q-profile scan occur before the loop.
- For fractional P, stable's loop counter truncates P to int while its distance denominator remains the original double P. Development truncates P before passing it to `do_g70`. Example D1 E0 P2.9: stable begins at pass=2 and calculates first offset `1/2.9 ≈ 0.3448276`; development begins at pass=2 with offset `1/2=0.5`. This is a **version-sensitive generated-offset difference if upstream validation accepts P2.9**. It is not a recommendation to use fractional P.
- `do_g70` temporarily disables cutter compensation for the initial rapid to the offset profile start, then restores it for subsequent path generation. This is why the finishing geometry and cutter-compensation mode need separate inspection; G70 permits compensation where G71/G72 reject it.

## Bounded discriminators (NOT RUN)
Starting from upstream `nc_files/lathe_g70_71_demo.ngc`, isolate G70 with Q100, D1, E0, and compare P omitted, P1, P0, P-1, P2, P2.9. Record parser error or acceptance, generated canonical move count and first offset, and whether any preliminary rapid was queued. Compare v2.9.10 and pinned development without connecting machine outputs. Treat an early parser rejection as a valid test result, not a contradiction of the conditional loop arithmetic. For a CAM post, require **positive integral P** as a post-side invariant rather than depending on undocumented truncation.

## Evidence/limits
**SOURCE-CONFIRMED:** G70 loop counts, casts, offset formula, source-level P0 no-pass branch. **DOC-CONFIRMED:** P is finishing-pass count with default 1. **UNKNOWN:** full interpreter acceptance of P0/P2.9, Task behavior, physical motion. No builds, simulation, machine operation, evaluator or Actions compute. The existing 3200 graduation and independent safety gates remain unchanged.
