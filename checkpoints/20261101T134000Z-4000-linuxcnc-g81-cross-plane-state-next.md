# 2026-11-01 ~13:40Z — G81/G98 cross-plane state checkpoint

**Active:** 4000 LinuxCNC source implementation; 3100 mill / 3400 router CAM-post transfer; NON-GRADUATED. Previous [G73/G83 peck checkpoint](20261101T123500Z-4000-linuxcnc-peck-clearance-next.md) remains open for qualified disconnected execution; do not repeat its static audit without new evidence.

## Durable findings and source boundaries

- [CYCLE-119 source audit](../research/4400_LINUXCNC_CYCLE_119_G17_G18_G98_INITIAL_LEVEL_STICKY_AXIS_SOURCE_AUDIT_2026-11-01.md) pins stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` and development `06864e23559e70463fc7112d5ce77138bcbc288c`. `convert_set_plane` updates plane without clearing `cycle_il_flag`, `cycle_il`, `cycle_cc`, `cycle_r` or modal G81; only a non-cycle group-1 motion (such as G80) clears the initial-level flag in `convert_motion`. G18 XZ drilling consumes Y as the perpendicular axis, but can reuse the preceding G17 initial Z as OLD_Y and preceding Z depth as sticky Y depth.
- Source-derived discriminator: initial `(X,Y,Z)=(0,0,20)`, G17/G98/G81 Z-2 R5, then G18/G81 X10 Z10 Y-2 R5 **without G80** predicts rapid to **Y20**, then Y5, feed Y-2, final retract Y20. With **G80 before G18**, new Y initial=0 and predicted final retract **Y5**. A modal `G18` followed by `X10 Z10` without G81/Y/R can inherit G81, old Z-2 as Y-depth and old R5. These are **canonical INFERENCES**, not measured physical motion or runtime logs.
- [Practical CAM post / disconnected acceptance guide](../guides/3100-4000-linuxcnc-canned-cycle-plane-transition-cam-preflight-2026-11-01.md) and [A fixture](../examples/4000_cycle_plane_transition/without_g80.ngc) / [B control](../examples/4000_cycle_plane_transition/with_g80.ngc) specify one narrow A/B test. Existing upstream G17/G98/G81 and G18/G98/G81 tests cover single-plane baselines only. All tests **NOT RUN**.

## Governance and evidence

START_HERE, mission, level order, work selection, curriculum, source policy, module template, PROGRESS, LESSON_LOG, blind protocol/score and compute ledger consulted. Direct historical PROGRESS synonym scan and predecessor CYCLE-115/118 inspection found no earlier cross-plane `cycle_il`/`cycle_cc` state-lifetime audit. No build, interpreter execution, simulator, connected machine, evaluator, Actions workflow or lab compute. Hosted/self-hosted Actions **0/0 min** this session; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Closed 1000/2000/F02/3000, independent personnel-safety authority, selected OpenPressBrake G0/G1 HOLD and enabled hourly curriculum unchanged.

## Precise next checkpoint

1. Only if an independently verified **physically disconnected**, qualified `[self-hosted, openpressbrake]` runner is available and the exact interpreter test job is reviewed, run existing upstream G17/G98 and G18/G98 baselines and the two minimal A/B files in separate clean interpreter processes. Capture `rs274 -g` canonical lines, stdout/stderr, exit status, exact revision/INI and authoritative job start/end/runtime. Do not use hosted runners or a connected panel PC. No automatic push-trigger or unreviewed script.
2. Compare **Y20 vs Y5** predicted G98 returns. If mismatch, correct the audit from actual observed behavior; do not invent a physical failure. If A/B agrees, one optional `G18` + axis-only `X10 Z10` case tests sticky Y-depth/R reuse. Keep this as one narrow test, not a large unrun suite.
3. If qualified compute remains unavailable, rotate to a **distinct LinuxCNC-first** realtime, HAL, HostMot2/Mesa, EtherCAT, kinematics, machine config or interpreter problem with direct predecessor scan. Prefer resolving new source mechanisms or integrating real configs over generating more tests for the same canned-cycle state.
4. Preserve prior peck-clearance, G10, G76, NURBS and TWP execution debts as branch-local; do not reopen graduated levels or routine safety-course gates.
