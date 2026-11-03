# MOTION-191 — G64 P/Q interpreter conversion and canonical ordering (2026-11-03)

**Scope:** 4000 implementation research, NON-GRADUATED. Pinned LinuxCNC v2.9.10 commit `86cdca76`; primary source [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/rs274ngc/interp_convert.cc), `Interp::convert_control_mode` and `Interp::convert_g`; canonical source [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc), `SET_MOTION_CONTROL_MODE` and `SET_NAIVECAM_TOLERANCE`. Compared with [MOTION-190](4400_LINUXCNC_MOTION_190_NAIVECAM_JOIN_AND_G61_G64_BOUNDARY_2026-11-03.md). All observations SOURCE-CONFIRMED at this revision, **not executed**.

## Key findings

1. `convert_g` invokes `convert_control_mode(block->g_modes[GM_CONTROL_MODE], block->p_number, block->q_number, settings)` when an explicit control-mode G code is present. A G1 block without G61/G64 does not itself invoke this conversion. The interpreter's `ONCE(STEP_CONTROL_MODE)` guard concerns execution ordering of the current block, not suppression of a repeated G64 in another block.
2. G64 with P>=0 uses P as TP tolerance. When P is absent (negative sentinel), the tolerance is **zero**. Q>=0 uses Q as naive-CAM tolerance; when Q is absent and P>=0, Q **inherits P**; when both absent, Q becomes **zero**. Thus G64 P0.1 (without Q) sets **both** tolerances to 0.1, not only planner P. G64 P0.1 Q0 sets TP tolerance 0.1 but disables canonical polyline joining. G64 with no parameters resets both to zero in the interpreter. These are assignments on each explicit G64 conversion, not a persistent Q from an earlier G64.
3. Every explicit G64 conversion calls `SET_MOTION_CONTROL_MODE(CANON_CONTINUOUS, tolerance)` **then** `SET_NAIVECAM_TOLERANCE(naivecam_tolerance)`. Canonical mode setter flushes buffered segments before changing mode and emitting `EMC_TRAJ_SET_TERM_COND`; naive-CAM setter updates local tolerance separately. Therefore even G64-to-G64 changes create a canonical flush boundary; the old buffered geometry is not retrospectively simplified with the new Q.
4. G61 maps to CANON_EXACT_PATH and G61.1 to CANON_EXACT_STOP. Neither branch calls `SET_NAIVECAM_TOLERANCE`; canonical naive-CAM tolerance may retain its old numeric value, but `linkable` also requires continuous mode, so joining is disabled while exact modes are active. A subsequent explicit G64 recomputes Q.
5. `convert_control_mode` checks cutter radius compensation and rejects changing control mode while compensation is active. This is an interpreter rejection path, not evidence of a realtime trajectory-planner rejection.

## Independent upstream fixture reconciliation

[tests/interp/g6164/expected](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/tests/interp/g6164/expected) contains `SET_MOTION_CONTROL_MODE(CANON_CONTINUOUS, 0)` / `SET_NAIVECAM_TOLERANCE(0)`, then `SET_MOTION_CONTROL_MODE(CANON_CONTINUOUS, 1)` / `SET_NAIVECAM_TOLERANCE(1)`, then repeated continuous mode 1 / naive-CAM 2, followed by exact-path and exact-stop calls. This **independently corroborates** the repeated same-mode setter and independent Q update, but it is a retained upstream expected transcript, **not a new runtime test**. No trajectory geometry or HAL feedback can be inferred from this fixture.

## Minimal disconnected experiment specification (NOT RUN)

Use an interpreter canonical-output harness at pinned revision. Feed `G21 G90 F600` then:
- A: `G64 P0.1`, short zigzag G1 moves, `M2`; expect canonical mode 0.1, naive-CAM 0.1.
- B: `G64 P0.1 Q0` with same moves; expect mode 0.1, naive-CAM 0 and no naive-CAM joining; TP blending remains possible.
- C: `G64 P0.1 Q0.02`, G1, `G64 P0.1 Q0`, G1; expect two mode-setter events and a flush before the second Q takes effect.
- D: `G64 P0.1 Q0.02`, `G61`, `G64`; expect exact-path transition and final continuous mode with both tolerances 0.
- E: same as D but `G61.1`; expect exact-stop instead of exact-path.
- F: activate cutter radius compensation in a valid compensated contour, attempt G64; expect interpreter error (exact error and sequencing require independent run).

**Separate measurement layers:** canonical setter/event transcript; `EMC_TRAJ_LINEAR_MOVE` message counts; TP queue segments; joint commanded positions; HAL feedback. The upstream g6164 fixture only verifies the first layer. A simulated joint's feedback may be wired to command and is not independent encoder evidence. No claim is made about the actual geometry, number of emitted moves, servo timing or physical behavior.

## Evidence ledger and gaps

| Claim | Status | Provenance | Remaining gate |
|---|---|---|---|
| G64 P without Q assigns Q=P | SOURCE-CONFIRMED | `Interp::convert_control_mode` | independent pinned interpreter run |
| Repeated G64 emits mode setter | SOURCE-CONFIRMED + upstream expected transcript | `convert_g`, `convert_control_mode`, `tests/interp/g6164/expected` | runtime geometry oracle |
| Same-mode G64 flushes canonical buffer | SOURCE-CONFIRMED | `SET_MOTION_CONTROL_MODE` in `emccanon.cc` | observe queued move count |
| G61/G61.1 do not explicitly reset Q | SOURCE-CONFIRMED | `convert_control_mode` | check alternate startup paths |
| Sim feedback independent of command | UNKNOWN | sim HAL file path from checkpoint was NOT_FOUND | locate actual INI and HAL include chain |
| Physical path following | UNKNOWN | no machine | separate qualified machine verification |

**Provenance caution:** the prior checkpoint's `configs/sim/axis/core_sim.hal` was not found at the pinned revision. Do not claim simulation wiring until a real path is located and the HAL net direction inspected. No builds, GitHub Actions, lab compute or machine tests performed. MOTION-144 isolation gate remains in force; independent personnel safety, graduated levels and blind evaluation unchanged.

## Next

Locate the exact pinned sim configuration and HAL include chain using repository tree discovery; establish whether position feedback is a command loopback. Then write a geometry-sensitive canonical-output fixture that distinguishes P-only Q-inheritance from P/Q separation, with a frozen oracle before permitted execution. If source-only work stops gaining evidence, rotate to a machine-specific LinuxCNC configuration.
