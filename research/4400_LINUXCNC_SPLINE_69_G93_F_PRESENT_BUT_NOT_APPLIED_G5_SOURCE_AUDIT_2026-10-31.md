# 4000-LC-SPLINE-69 — G93 F accepted on G5/G5.1 but no per-spline inverse-time conversion
**2026-10-31; source-confirmed conditional integration finding; NOT TESTED.**

## Source trace and exact scope
In stable v2.9.10 [`interp_convert.cc::convert_spline`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L217), G93 requires `block->f_flag` but then calls `NURBS_FEED` for G5/G5.1. The function does **not** call `inverse_time_rate_straight`, `inverse_time_rate_arc`, `SET_FEED_RATE`, or read `block->f_number` to compute a spline-specific feed. Ordinary `execute_block` skips direct F conversion under G93. [Stable canonical `NURBS_FEED`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1362) approximates the curve with biarcs; the helper invokes `ARC_FEED` or `STRAIGHT_FEED`, using the canonical feed state already present.

Pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` [`convert_spline`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_convert.cc#L554) still checks only F *presence* for G93 and forwards control points to `NURBS_G5_FEED`; it likewise contains no `block->f_number` use or `inverse_time_rate*` call in this conversion path. [Development canonical `NURBS_G5_FEED`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L1558) also generates biarcs, with no per-spline F argument. Both canonical layers' [`SET_FEED_RATE`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L619) are invoked when an explicit rate is enqueued elsewhere, not by this spline conversion.

**Zero-prior-feed consequence:** A fresh canonical session has zero feed. [Stable `flush_segments`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L888) and [development `flush_segments`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L944) omit ordinary zero-velocity linear moves while advancing canonical endpoint. [Stable `ARC_FEED`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1482) and [development `ARC_FEED`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L2480) likewise gate zero-velocity arcs but advance endpoints. Therefore a G93 G5/G5.1 block with F present but no previous positive canonical feed has a **source-confirmed command-omission/endpoint-advance path**. The installed Task and physical consequences remain untested; other programs may have previous feed state.

This is distinct from G1/G2/G3: [`interp_inverse.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_inverse.cc#L47) computes `length × F` on those moves. Official [G93 docs](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/gcode/g-code.adoc#L3180) promise inverse-time behavior for G1/G2/G3, **not explicitly for G5/G5.1**; therefore this is a **CAM compatibility boundary**, not a demonstrated violation of that specific G93 guarantee. Official [G5/G5.1 examples](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/g-code.adoc#L545) provide valid geometric fixture shapes.

## Prediction / falsifier (not executed)
Start from a known canonical feed rate set by `G93 G1 X10 F2`, then move to X0 Y0 by G0 (does not reset feed), and run the same documented G5 geometry twice in separate fresh simulations, changing only the G5 block's F2 versus F200. **Source prediction:** both runs retain the same prior canonical feed state when G5 begins; changing G5's F alone does not enqueue a new rate. The two spline runs may differ for other reasons only if another path modifies the feed; instrument `SET_FEED_RATE` events to falsify the prediction. Do not infer identical physical cycle times without runtime traces.

### Minimal disconnected G-code fixture (one file per F variant)
```ngc
G21 G90 G17 G40 G94
G0 X0 Y0
G93
G1 X10 Y0 F2
G0 X0 Y0
G5 I0 J3 P0 Q-3 X1 Y1 F2  (change only this F to 200 in second fixture)
G94 F100
M2
```
If a specific version refuses the G5 block, record parser status and do not treat it as evidence of feed equality. If it accepts, compare **canonical rate events**, not just GUI estimated time.

## Consequence / design rule
For open-source CAD/CAM integration, avoid emitting G5/G5.1 under G93 as if each spline's F controls its duration. Prefer explicit G94 speed with known geometry, or tessellate to G1/G2/G3 with a verified per-segment inverse-time post and independently check total timing. No compulsory product build or physical trial is warranted by this static finding.

## Uncertainty
The precise spline segmentation, lookahead, actual speed, feed override and physical motion remain UNKNOWN. Runtime test needed to classify behavior as TEST-CONFIRMED; personnel safety is a separate authority.
