# MOTION-225 — Canonical-to-motion termination bridge, LinuxCNC v2.9.10

2026-11-05 02:40 UTC. 4000-series implementation research; NON-GRADUATED. Closes the precise missing bridge from MOTION-224. No runtime or machine claims.

## Pinned source and complete mapping

All paths below refer to `LinuxCNC/linuxcnc` tag `v2.9.10`; Git blob IDs pin the inspected bytes.

| Stage | Source, blob, location | Verified behavior |
|---|---|---|
| Interpreter | [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), `f01a359652d588d59c9e210fa441a99d2ee19598`, `Interp::convert_control_mode` ~1633–1668 | G61 → CANON_EXACT_PATH; G61.1 → CANON_EXACT_STOP; G64 → CANON_CONTINUOUS with P tolerance; Q selects naive-CAM tolerance. |
| Canonical producer | [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc), `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, `SET_MOTION_CONTROL_MODE` 1193–1218 | Calls `flush_segments()` before mode change; maps CONTINUOUS → EMC_TRAJ_TERM_COND_BLEND, EXACT_PATH → EXACT, EXACT_STOP → STOP; converts P via `FROM_PROG_LEN` then `TO_EXT_LEN`; appends `EMC_TRAJ_SET_TERM_COND` to `interp_list`. |
| NML constants | [emc.hh](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/nml_intf/emc.hh), `2e311ffafd35cbbbc664dfec6c803afa2fa8f56d`, ~93–95 | STOP=0, EXACT=1, BLEND=2. |
| Task dispatch | [emctaskmain.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc), `7292a172023a5b42b023447c2458cb766c93fc9b`, ~1877–1880 | EMC_TRAJ_SET_TERM_COND_TYPE invokes `emcTrajSetTermCond(cond,tolerance)`. |
| Task→motion command | [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc), `96a041d1feef8560f37159a2f18b109171f084c3`, `emcTrajSetTermCond` 1407–1415 | Sets `EMCMOT_SET_TERM_COND`, copies `termCond` and `tolerance` without translation, calls `usrmotWriteEmcmotCommand`. |
| Motion dispatch | [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), `0b79061d39be915bbea548b2c33bb794d31ab302`, ~983–987 | Passes termCond/tolerance to `tpSetTermCond(&coord_tp,...)`. |
| TP accept | [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), `5768d6e6880569f72156ed9a761b5eee531c9fcf`, `tpSetTermCond` 644–665 | Accepts STOP, EXACT, PARABOLIC, TANGENT; stores condition/tolerance. |
| TP constants | [tc_types.h](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tc_types.h), `6b0dd8d534ad441312b2b20cd84ce251edc532a2`, 24–29 | STOP=0, EXACT=1, PARABOLIC=2, TANGENT=3. Thus canonical BLEND=2 is numerically TP PARABOLIC=2 in this revision. |

### Critical implementation distinction

The bridge does **not** translate a symbolic BLEND enum into a symbolic PARABOLIC enum. It passes integer 2 through `taskintf.cc`, which TP interprets as `TC_TERM_COND_PARABOLIC`. This is a version-specific **numeric ABI coupling**, not a generic assertion that the enum families are identical. A future renumbering on either side without translation would change behavior. A source-review regression guard should assert these three pairs at the build boundary or explicitly map symbols.

### P/Q and queued-segment behavior

In `interp_convert.cc` ~1657–1668, Q (if present) sets naive-CAM tolerance; otherwise, if P is supplied, Q defaults to P; otherwise naive-CAM tolerance is zero. `emccanon.cc` `SET_NAIVECAM_TOLERANCE` ~1220 updates `canon.naivecamTolerance` but **does not send another `EMC_TRAJ_SET_TERM_COND` message**. The canonical `SET_MOTION_CONTROL_MODE` first flushes accumulated segments, so mode switching cannot be assumed to retroactively rewrite all already queued segments. Q may influence canonical segment chaining before submission; it is not the same as the TP P tolerance. Actual blend deviation and speed remain unmeasured.

## Reproducible minimal inspection

At the pinned tag, inspect:
```sh
git checkout v2.9.10
git grep -n 'void SET_MOTION_CONTROL_MODE' -- src/emc/task/emccanon.cc
git grep -n 'int emcTrajSetTermCond' -- src/emc/task/taskintf.cc
git grep -n 'EMC_TRAJ_TERM_COND_' -- src/emc/nml_intf/emc.hh
git grep -n 'TC_TERM_COND_' -- src/emc/tp/tc_types.h
git grep -n 'case EMCMOT_SET_TERM_COND' -- src/emc/motion/command.c
```
Expected source oracle: G61→1, G61.1→0, G64→2, with 2 interpreted by TP as PARABOLIC. **These commands were specified, not executed in this session.**

## Review exercise (not a blind evaluator)

For `G21 G90 G64 P0.10 Q0.03`, predict two separate effects: TP receives BLEND(2) and P=0.10 in external length units; canonical naive-CAM tolerance is Q=0.03 in converted program units. Then change to `G61.1`: canonical flushes segments and sends STOP(0). Check the seven source sites above; do not infer corner speed or physical geometry. Falsifier: a v2.9.10 source path that remaps termCond between `taskintf.cc` and `tpSetTermCond`.

## Evidence ledger and limits

**SOURCE-CONFIRMED:** exact producer, dispatch, integer mapping, and Q's distinct canonical state. **INFERENCE:** enum numeric coupling merits a regression guard. **UNKNOWN:** detailed canonical chaining conditions, actual geometric P bound enforcement, runtime velocity/acceleration, behavior on development branch. **TEST-CONFIRMED:** none. No builds, simulations, compute, Actions, or physical operations. Historical lab ledger checked for predecessor evidence; this is a new narrow source bridge, not a claim that trajectory planning is untested overall.

Graduated levels, blind evaluator separation, independent personnel-safety authority, and machine restrictions remain unchanged.

## Next checkpoint

Rotate to a high-information-gain LinuxCNC homing internals or real 3000-series mill/plasma configuration investigation. If revisiting trajectory planning, trace Q-based `chained_points` flush/merge and P's geometric enforcement with a new executable oracle; do not repeat this integer bridge or MOTION-191.
