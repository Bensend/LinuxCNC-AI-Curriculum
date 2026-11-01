# 3100/3200/4000 — LinuxCNC G33.1 rigid-tapping CAM/post and disconnected commissioning
**2026-11-01 | practical source-grounded implementation | NON-GRADUATED | ALL RUNTIME CHECKS NOT RUN**

## Objective and prerequisite boundary
A fresh AI machine integrator must distinguish G33.1 **programmed pitch K**, **return spindle-speed multiplier I**, **commanded S and override**, **measured spindle revolutions/index**, **per-axis feed capability**, **TP reversal state**, **canonical/GUI preview**, and **physical shaft behavior**. Do not substitute one for another. Read [TAP-124](../research/4400_LINUXCNC_TAP_124_G331_I_RETRACT_PREFLIGHT_CSS_RADIUS_VERSION_SOURCE_AUDIT_2026-11-01.md) and [TAP-125](../research/4400_LINUXCNC_TAP_125_G331_TP_REVERSAL_TEN_TURN_BOUND_AND_FEEDBACK_SOURCE_AUDIT_2026-11-01.md), then prior [SPINDLE-100/101](../research/4400_LINUXCNC_SPINDLE_101_EL8_SYNTHETIC_INDEX_WINDOW_AND_RIGID_TAPPING_SOURCE_AUDIT_2026-11-01.md) for an actual EtherCAT-derived index sampling problem. G84 floating-chuck tapping is not a substitute for G33.1 spindle-synchronized behavior.

## Controller-version and postprocessor contract
| Property | Stable v2.9.10 | Pinned development `06864e23559e` | CAM / commissioning rule |
|---|---|---|---|
| G33.1 I | Values <1 become 1; reverse spindle speed commanded by I | Same | Explicit I≥1, bound it by motor, drive and axis limits |
| Return axis velocity preflight | No per-axis check in inspected G33.1 converter | Checks `abs(K)*I*commanded RPM` projected onto each linear axis against available configured axis limits | **Post must check both versions**, not rely on interpreter |
| G96 X-inward preflight | No check | G33.1 uses start `abs(X)`, unlike G33 minimum radius across move | Avoid G96 for unqualified tapping; require documented spindle speed cap and independent path calculation |
| Reversal | Position-trend state machine, finite 10-revolution overrun target | Same mechanism | Verify measured reversal and tracking; never infer physical stop from M-code or GUI |
| Python geometric preview | `rigid_tap(x,y,z)` callback omits I | Same callback; separate time estimator retains I | Preview cannot validate I or reversal dynamics |

### Disconnected-only minimal G-code specimen
This is an **analytical fixture, not production G-code**, to be run only in an isolated simulator with explicit known axis velocity and spindle feedback. It is not a validated physical tap program:
```ngc
G21 G17 G90 G94 G40 G49 G80
G0 X0 Y0 Z5
S500 M3
G33.1 Z-10 K2 I3
M5
M2
```
Under a known simulated Z max 2500 mm/min, expected **source-derived** return rate is 3000 mm/min, plunge rate 1000 mm/min. Development is predicted to reject the G33.1 before queueing; stable does not contain that preflight. Without valid spindle index/revs and enabled coordinated mode, execution may fail or wait for other reasons. The fixture is intentionally NOT RUN.

### Practical implementation walkthrough
1. **Freeze versions and config.** Record LinuxCNC commit/tag, actual INI axis/joint maximum velocities, spindle min/max RPM, CSS mode, override state, thread pitch, tool path and machine units. Do not assume development-only checks exist on stable.
2. **Trace the producer.** The CAM post should emit G21/G20 explicitly, G90, known plane, a separate XY positioning move, S/M3 or M4, and a **Z-only** G33.1 where applicable. Reject accidental X/Y changes on a nominally axial tap. Treat G33.1 I as a speed multiplier, not a dwell or tool diameter.
3. **Preflight numerically.** For Z-only, compute `v_down = |K| * RPM`, `v_return = |K| * RPM * max(1,I)` in program distance/minute. Compare to the real Z-axis path capability, spindle acceleration/deceleration, feedback tracking and configured limits. For coordinated XYZ moves, project the path speed by each axis’s share of linear path length. Consider actual override, G96 and drive caps separately.
4. **Check HAL feedback provenance.** Map physical encoder and index to the selected `spindle.N.revs`, `spindle.N.index-enable` and at-speed/speed feedback. Confirm sign, scaling, direction changes, freshness, and that a generated index pulse cannot be missed at the servo sampling rate. Prior [SPINDLE-101](../research/4400_LINUXCNC_SPINDLE_101_EL8_SYNTHETIC_INDEX_WINDOW_AND_RIGID_TAPPING_SOURCE_AUDIT_2026-11-01.md) documents a source-derived window miss.
5. **Trace runtime layers.** `Interp::convert_straight → RIGID_TAP → EMC_TRAJ_RIGID_TAP → EMCMOT_RIGID_TAP → tpAddRigidTap → tpUpdateRigidTapState → tpCheckEndCondition`. Verify the initial ten-turn overrun target and the distinct `TAPPING/REVERSING/RETRACTION/FINAL_REVERSAL/FINAL_PLACEMENT` transitions. The single-sample encoder trend is not a zero-speed witness.
6. **Inspect preview independently.** The Python `rigid_tap` callback carries XYZ but **not I**; a matching visual trace does not establish safe retract speed. Development's separate time estimator receives I but is not proof of physical reversal.
7. **Separate protective authority.** HAL process signals, LinuxCNC commanded spindle speed and motion TP are not an independently validated personnel-safety system. Preserve the existing independent safety gates and do not run this curriculum specimen on an energized tap or exposed machine.

## Existing upstream test coverage — source inspected, NOT RUN
The stable and development [`tests/interp/g33.1/g33.1.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g33.1/g33.1.ngc) files are byte-identical (blob `94ee477582afe8353dd48f53d1c1ae3e42565bf4`). They contain only `G33.1 Z-1.2 K0.1` after S1000/M3; **no I, G96 or reversal-feedback injection**. Their expected canonical logs are also identical (blob `48169548637713707a5a315c922bae5351b54921`) and record `RIGID_TAP(0,0,-1.2)` without I, as the standalone `saicanon` output does not expose scale. The `test.sh` scripts invoke `rs274 -g`, not a realtime spindle/axis plant.

The [trajectory-planner `rigidtap_test.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/trajectory-planner/circular-arcs/nc_files/spindle/rigidtap_test.ngc) is a sample with three default-I taps and changed S/K; it is not evidence that the specific ten-turn non-reversal and single-sample glitch cases were executed. **Do not confuse** `tests/tap.0` with G33.1: its `tap.0` is the unrelated HAL `tap` signal component exercised by a Python pin-toggle test. Reuse the existing interpreter test as a baseline; add only targeted I/reversal discriminators when isolated compute is qualified. No upstream tests were run in this session.

## Disconnected verification matrix (all NOT RUN)
| Case | Input/condition | Expected discriminator, not observed |
|---|---|---|
| 1 | Stable, S500 K2 I3, simulated Z max 2500 | No G33.1 interpreter feed-feasibility rejection in stable branch; downstream behavior UNKNOWN |
| 2 | Development, same values | Predicted per-axis 3000>2500 error before canonical RIGID_TAP |
| 3 | Development, I1 | Predicted 1000<2500 pass of this check, other prerequisites may still fail |
| 4 | Development, G96 X20→X10, S60, no caps | Compare source start-radius check to independent end-radius calculation; controller result NOT RUN |
| 5 | Normal simulated spindle forward→reverse | Capture actual TP state transitions and encoder samples |
| 6 | Simulated encoder continues forward >10 rev after reverse command | Determine whether TP removes segment while REVERSING or another fault intervenes |
| 7 | One-sample negative encoder glitch after reversal command | Determine whether the state enters RETRACTION without physical direction reversal |
| 8 | Python preview G33.1 I1 versus I3 | Same three-argument geometric callback; compare independent development time-estimator output |
| 9 | Missing/stale spindle index | Record wait/fault; do not mistake spindle-at-speed for index validity |

For any qualified `[self-hosted, openpressbrake]` execution, capture source SHA, binary hash, exact INI/HAL, synthetic feedback sequence, raw stdout/stderr, exit status, TP state and authoritative job start/end; only then mark a case TEST-CONFIRMED. No GitHub-hosted Actions fallback, no machine output. Reuse upstream tests if they cover the mechanism; otherwise implement the smallest disconnected instrumented TP fixture.

## Fresh-AI transfer question (unscored)
A mill has a 1.5 mm/rev tap at 800 RPM, I2.5, and a Z limit of 2500 mm/min. Calculate commanded down/up feed requirements, explain whether stable or development rejects it in the interpreter, and identify two distinct reasons why even a passing interpreter check does not prove safe physical reversal. **Do not self-grade or reveal an independent evaluator key.**

## Scope
This is source/commissioning education, not a machine qualification, a validated CAM post, or a new graduated level. OpenPressBrake physical G0/G1 and personnel-safety authority remain unchanged.