# MOTION-190 — canonical naive-CAM joining and termination-mode boundaries (2026-11-03)

**Scope:** 4000 LinuxCNC implementation; NON-GRADUATED. LinuxCNC upstream v2.9.10 pinned commit `86cdca76`; `src/emc/task/emccanon.cc` blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`. Read after MOTION-189. SOURCE-CONFIRMED code; predictions not executed.

## The two distinct tolerances

[SET_MOTION_CONTROL_MODE L1193–1218](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1193-L1218) flushes pending canonical segments **before** changing `canon.motionMode`, and emits `EMC_TRAJ_SET_TERM_COND`: continuous → BLEND with `canon.motionTolerance`, exact-path → EXACT, exact-stop → STOP. [SET_NAIVECAM_TOLERANCE L1220–1223](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1220-L1223) separately sets `canon.naivecamTolerance`. These are distinct controls: the trajectory planner's termination tolerance is not the canonical polyline simplifier's tolerance. A mode change forces a boundary even when geometry would otherwise join.

## Exact source predicates for joining

[`linkable` L966–1003](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L966-L1003) returns false unless: (1) `CANON_CONTINUOUS` and nonzero naive-CAM tolerance; (2) the existing chain has **at most 100** points; (3) each of A/B/C/U/V/W equals the last chained point; (4) the proposed XYZ endpoint differs from the canonical `endPoint`; and (5) every existing chained XYZ point lies within naive-CAM tolerance of the line segment from canonical `endPoint` to the new endpoint. Each point is projected onto the candidate segment and its parameter clamped to [0,1], then Euclidean deviation is compared with tolerance using strict `>`. Thus a non-collinear corner can be simplified if its perpendicular distance is within Q; a long segment that backtracks or projects outside the endpoint interval can fail even when it lies on the same infinite line. The `>100` check permits a chain of 101 existing points to be evaluated, but blocks adding a further point to that chain.

[`see_segment` L1005–1027](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1005-L1027) flushes an existing chain when `linkable` fails, then pushes the new endpoint. A change to ABC or UVW immediately flushes the new chain. [`FINISH` and `ON_RESET` L1029–1035](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1029-L1035) differ: FINISH flushes; ON_RESET **drops** buffered segments without publishing them. Do not infer that an aborted interpreter's previously seen G1 necessarily entered Task or TP.

## Concrete ordering / flush boundaries

[`STRAIGHT_TRAVERSE` L1038–1046](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1038-L1046) flushes before a rapid; [`STRAIGHT_PROBE` L1140–1154](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1140-L1154) before probing; [`DWELL` L1849–1857](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1849-L1857) before a dwell. Feed-mode changes and changed feed-rate flush ([L518–545](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L518-L545)); spindle synchronization start/stop flush ([L1247–1266](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1247-L1266)). G61/G64 mode changes flush before the new termination condition. Arc handling includes both special midpoint `see_segment` calls and an ordinary flush path; do not assume all arcs are canonical linear messages ([L1516–1532](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1516-L1532)).

## Disconnected minimal discrimination exercise — NOT RUN

Review-only NGC, on an appropriately configured **simulation only** with metric units and no actual machine:

```ngc
G21 G90 G17
G0 X0 Y0
G64 P0.10 Q0.05
F600
G1 X10 Y0
G1 X20 Y0.02
G1 X30 Y0
G61
G1 X40 Y0
G64 P0.10 Q0
G1 X50 Y0
G1 X60 Y0
M2
```

**Precommitted qualitative predictions (source-based, not an executed oracle):** Q0.05 permits potential canonical merging of the first three short-deviation G1 blocks, depending on actual canonical endpoint state and any intervening flush. G61 flushes pending motion before emitting a new termination command; its following G1 cannot join across that boundary. Q0 disables canonical joining under continuous mode even though P0.10 still requests TP blending. Count emitted `EMC_TRAJ_LINEAR_MOVE` messages independently of TP `tpAddLine` queue entries and interpolated joint commands. Do not use AXIS graphical path as a message-count oracle. Record exact interpreted units, offsets, feed, and termination messages.

**Counterexample:** If a prior chained point is beyond the candidate segment endpoint, the clamped projection can exceed Q even if all points are collinear; geometric collinearity alone is not sufficient for joining. Another discriminator: a rotary-axis change forces an immediate flush.

## Existing upstream test limitation

[`tests/interp/g6164/test.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/tests/interp/g6164/test.ngc) consists of `G64; G64P1; G64P1Q2; G61; G61.1; M2`. It exercises mode interpretation, **not** a multi-segment contour or servo deviation. Its existence must not be cited as runtime proof of polyline simplification or corner error. The [AXIS simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/configs/sim/axis/axis.ini) specifies separate Task 1 ms, servo 1 ms, and display 100 ms clocks, with `trivkins`, XYZ and a list of HAL files; simulation feedback wiring must be audited before any actual-versus-commanded interpretation.

## Evidence/next experiment contract

1. Inspect upstream `tests/interp/g6164` complete expected output and `core_sim.hal` feedback nets. Establish an instrumented *canonical-message-count* oracle independent of the UI.
2. Verify interpreter G64 P/Q conversion and modal handling against `interp_convert.cc` and the official G-code documentation; specifically determine whether a same-mode G64 P/Q update always calls the canonical setter.
3. Only after independently qualifying disconnected `[self-hosted, openpressbrake]` runner isolation, execute a minimal test; compare G64 P/Q, G61, G61.1 and a backtracking control. MOTION-144 remains the first executable priority, subject to predecessor scan of lab records.
4. Rotate to another LinuxCNC subsystem if this path yields no additional evidence. Do not promote a review-only NGC or source prediction to TEST-CONFIRMED.

**No build, tests, hardware, Actions, or compute in this investigation.** No graduated level reopened; blind challenge bank untouched; independent personnel-safety gates and OpenPressBrake physical HOLD preserved.
