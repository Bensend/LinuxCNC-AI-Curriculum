# PLASMA-199 — QtPlasmaC conversational producer and real postprocessed NC contract (2026-11-04 UTC)

**Status:** NON-GRADUATED; SOURCE-CONFIRMED for inspected upstream development files, review-only examples; NO EXECUTION. This is a continuation of PLASMA-197/198. Active course level: 3300 plasma, with 3600 press-brake transfer boundaries.

## Provenance
- LinuxCNC upstream commit `cdf957bd00bbcc4c569f01e7eed5b154422b816c` (development snapshot); `lib/python/plasmac/line.py` blob `67b55456c25ffc9c6b6723cc9ad8cb06154d066d`. Symbols: `first_segment`, `next_segment`, `last_segment`, `do_arc_3_points`, `do_arc_2_points_radius`.
- Same commit `nc_files/plasmac/metric_ramp_pierce.ngc` blob `4acab021e39c53e62a89a701acc0fa5e760980ca` and `imperial_ramp_pierce.ngc` blob `1556620cbeb30ac92628c8975b47ed1a8861622a`. These files identify themselves as output of `LinuxCNC PlasmaC.scpost rev: 0.5`. **Important:** the .scpost *generator source was not inspected*; these are inspectable postprocessor outputs, not proof of its internal implementation.
- Prior PLASMA-198 pinned ezdxf commit `c498560bb491c357deda538360ed0c8fdb11f5a7` for DXF bulges; LinuxCNC v2.9.10 tag commit `86cdca76fa2a36274c432caa21952b23c267989a`. Do not silently treat this development source as stable 2.9.10.

## Actual upstream conversational producer
`first_segment` writes `M190 P{matNumber}`, then `M66 P3 L3 Q1`, then `F#<_hal[plasmac.cut-feed-rate]>`, a G0 start move, and `M03 $0 S1`. `last_segment` appends motion code, `M05 $0`, postamble and `M02`. `next_segment` copies until the first `M05 $0` and truncates for a continued contour; it does **not** independently restart a torch. This is an actual producer contract, not merely a suggested format. **SOURCE-CONFIRMED.**

`do_arc_3_points` selects G03 versus G02 by the 2D cross-product of start→middle and start→end and emits I/J = center minus *start*. `do_arc_2_points_radius` instead constructs a center from endpoints/radius, then emits G02/G03 according to the supplied `arcType`; its `radius < height` guard compares signed radius against positive half-chord, which would reject negative radii if supplied. These APIs should not be conflated with DXF bulge traversal. **SOURCE-CONFIRMED branch logic; runtime outcomes untested.**

## Independent inspectable CAM output, not its generator
The metric sample declares `G21 G40 G90`, `G64 P0.254 Q0.025`, `M52 P1`, `M65 P2/P3`, `M68 E3 Q0`; supplies custom `m159 p601...p608` ramp-pierce parameters; selects `T0 M6`, `G43 H0`, material settings in an `(o=...,kw=...,ph=...,fr=...)` comment, `F#<_hal[plasmac.cut-feed-rate]>`, then `G0`, `M3 $0 S1`, `G1`, `m159 p609`, `M5 $0`, and `M30`. **SOURCE-CONFIRMED sample content; not a general guarantee for all postprocessors.**

The imperial sample uses `G20`, `#<scale> = 25.4`, and explicit divisions by scale for several motion/pierce quantities; it has `G64 P0.005` without Q. Consequently the metric and imperial samples are not a byte-for-byte units translation of trajectory tolerance, and a converter must not assume identical G64 P/Q semantics. **SOURCE-CONFIRMED text; INFERENCE about equivalence.**

**Critical integration boundary:** `m159` ramp-pierce commands and HAL `plasmac.*` expressions are *machine-specific integration dependencies*, not plain geometry. A generic LinuxCNC mill, router, or press-brake profile must not receive them without verified remap/component support. Conversely an external DXF/CAM producer should not omit material handshake, torch start/stop, or cut-feed-rate binding when targeting this QtPlasmaC workflow. **INFERENCE based on source.**

## Proposed practical review fixture (NOT RUN)
```gcode
(PLASMA-199 REVIEW ONLY — QtPlasmaC-specific; do not run on a machine)
G21 G17 G90 G91.1 G40
G64 P0.254 Q0.025
M190 P0
M66 P3 L3 Q1
F#<_hal[plasmac.cut-feed-rate]>
G0 X0 Y0
M3 $0 S1
G1 X10 Y0
G3 X10 Y10 I0 J5
M5 $0
M2
```
The example's arc has center (10,5), radius 5 and travels from (10,0) to (10,10) CCW through the right side; the explicit `G91.1` avoids inheriting absolute I/J mode. It is **not** a verified cutting program: pierce settings, lead-in, kerf, THC, material configuration, cut envelope and machine-specific behavior remain unverified.

## Disconnected verification matrix (NOT RUN)
1. Confirm both producer and interpreter agree on M190/M66 handshake; distinguish timeout from material acceptance.
2. Confirm M3/M5 torch lifecycle and feed-rate binding in the actual QtPlasmaC simulation, not only in NC text.
3. Parse positive and negative bulge semicircles and compare G3/G2 plus start-relative I/J; test mirrored INSERT and closed LWPOLYLINE final segment.
4. Compare G64 P/Q modal behavior for metric and imperial samples after normalizing units.
5. Reject missing `m159` remap on a generic profile; never infer it is a built-in G-code.
6. Inspect an actual .scpost or other CAM postprocessor source, then pin its commit/blob and compare emitted arc, kerf and pierce conventions against the upstream outputs.
7. Confirm simulation feedback is synthetic before using following-error results as machine evidence.

## Claims and gaps
| Claim | Class | Evidence | Missing |
|---|---|---|---|
| QtPlasmaC conversational producer emits material wait, HAL feed, torch lifecycle | SOURCE-CONFIRMED | pinned `line.py:first_segment/last_segment` | runtime |
| Three-point arcs use cross product and relative I/J | SOURCE-CONFIRMED | pinned `line.py:do_arc_3_points` | geometry execution |
| Upstream example scpost output includes custom ramp pierce | SOURCE-CONFIRMED (output only) | pinned metric/imperial .ngc | scpost source |
| Portable DXF geometry and machine-specific plasma postprocessing should be separate | INFERENCE | producer + samples + PLASMA-198 | real post integration |
| Any particular plasma machine executes these files correctly | UNKNOWN | none | isolated simulator, then separately qualified hardware |

No runner dispatched, no physical machine, no new lab compute, no blind evaluation. Independent personnel-safety authority, graduated levels and OpenPressBrake physical G0/G1 HOLD unchanged.
