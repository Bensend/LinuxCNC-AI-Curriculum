# 4000-LC-G93-67 — G93 inverse-time feed: F0, zero-length and compensated geometry
**2026-10-31; active 4000, NON-GRADUATED. Evidence: SOURCE/DOC-CONFIRMED static; runtime and physical timing UNKNOWN.**

## Why this is new
Full `PROGRESS.md` search before this investigation returned no prior `G93`, `inverse time`, `FEED_AXES` or `axisKinds` mechanism. Earlier CAM-58/59/60 cover cutter lead-in and FreeCAD G64 unit ordering, not inverse-time F conversion. Prior G95-SPEED-01 concerns spindle-synchronized feed, not G93. No previously graduated course level is reopened.

## Pinned evidence
- Official [G93/G94/G95 definition](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/gcode/g-code.adoc#L3180): in G93 a block's `F` means nominal duration `1/F` minutes; each G1/G2/G3 line (including implicit modal motion) needs its own F. G0 unaffected. Switching to G94/G95 requires a new feed.
- [Stable `interp_execute.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_execute.cc#L225) and [development](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_execute.cc#L227): feed mode is converted before motion; F in inverse-time mode is deliberately **not** handled by the ordinary per-block feed-rate converter.
- [Stable `interp_inverse.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_inverse.cc#L47) blob `adea71fa04960332f04a4c5533831c13e5b05d90`; [development](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_inverse.cc#L47) blob `2a8537dbf52ade281dc4816835fd53916ee7c211`. Both calculate `rate = length * block->f_number` and enqueue `SET_FEED_RATE(rate)` for straight and arc motion. When the calculated length is **exactly zero**, both instead enqueue **0.1** (the source cites upstream issue 2410).
- [Stable `interp_read.cc::read_f`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_read.cc#L498) rejects `value < 0`, not `value <= 0`. [Stable `convert_straight`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L4807) and [development `convert_straight`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_convert.cc#L5718) require `f_flag` under G93 but do **not** apply the G94/G95 zero-feed guard. The same F-presence distinction is in `convert_arc`.
- [Stable `convert_feed_mode`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L2246) resets stored feed to zero on G94/G95, but not on G93. [Stable `emccanon.cc::SET_FEED_RATE`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L528) converts the per-move rate from per-minute to per-second and linear/angular units before motion.
- [Stable `interp_find.cc::find_arc_length`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_find.cc#L68) uses arc length and helix rise; it does not take rotary-axis deltas. [Stable `convert_arc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L342) explicitly warns that cutter compensation may change the executed path length while inverse-time F is calculated from the **uncompensated** programmed arc.
- An upstream [five-axis impeller demo](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/5axis/table-rotary-tilting/demos/impeller-7bl-xyzac.ngc) actually emits `G93` and F on each XYZAC feed line; this is an inspected example, **not** a run.

## End-to-end execution path
`read_f` accepts nonnegative F → `execute_block` selects G93 → `convert_straight`/`convert_arc` validates presence of F → `inverse_time_rate_straight`/`inverse_time_rate_arc` computes **program-length × F** → canonical `SET_FEED_RATE` converts units → Task/trajectory planner applies axis velocity/acceleration constraints → hardware outputs. The F value is a *nominal duration request*, **not** a guarantee of elapsed wall time; feed override, short segments, blending, acceleration and rotary-axis limits can extend it.

## Source-derived examples (not executed)
| G-code geometry | G93 F | Length used by interpreter | Enqueued nominal rate | Nominal time if unconstrained |
|---|---:|---:|---:|---:|
| G1 X10 from X0 (mm) | 2 | 10 mm | 20 mm/min | 30 s |
| G1 A90 from A0, default angular A | 2 | 90 degrees | 180 deg/min | 30 s |
| G1 X10 A90 from zero | 2 | 10 mm (A excluded) | 20 mm/min | 30 s **only if** A can complete in time |
| G1 X10 from zero | 0 | 10 mm | **0 mm/min** | Undefined/infinite nominal duration; Task/motion response UNKNOWN |
| G1 X0 from X0 | 100 | 0 mm | **0.1 mm/min** fallback | No actual travel; do not interpret fallback as commanded displacement |

**Critical F0 distinction:** SOURCE-CONFIRMED that `G93 G1 X10 F0` passes the inspected interpreter's F-presence and nonnegative-F checks and enqueues zero rate; **NOT** proven that integrated Task accepts, executes or completes such a move. An invalid or zero-rate downstream motion path is an independent acceptance question. A CAM post must not generate nonpositive G93 F values.

**Compensated arcs:** source notes that the original arc's length determines F even when G41/G42 creates extra/modified geometry. The real compensated path can therefore take a different duration. Arc + rotary motion similarly needs an independent axis-limit/time check.

## Discriminating software-only acceptance
1. Freeze stable and development commit, INI, NC file, modal state, F, canonical `SET_FEED_RATE` stream, Task/motion outcome and timing.
2. Compare G93 F2 straight/arc with G94 F20; verify F presence enforcement, G94 reset and F0 conversion. Do not infer machine motion from interpreter acceptance.
3. Use non-motion zero-length G1 with F100 and capture canonical rate; verify the special 0.1 rate without claiming a real move.
4. Compare G41/G42 arc commanded time against actual emitted segment geometry and axis-limited runtime.
5. If no qualified isolated runner, leave all as **NOT RUN**, not TEST-CONFIRMED.

## Open questions / next
- Does integrated Task reject or stall a nonzero-length G93 F0 command? Require disconnected execution and independent motion-status oracle.
- Does G93 F conversion interact with compensated-path timing and short-segment blending in a measurable way?
- Exact physical motion and safety consequences are UNKNOWN; independent personnel-safety authority unchanged.
