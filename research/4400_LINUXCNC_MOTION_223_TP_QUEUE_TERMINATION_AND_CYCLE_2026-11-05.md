# MOTION-223 — LinuxCNC v2.9.10 trajectory planner: queue, termination and cycle boundaries (4000, NON-GRADUATED)

2026-11-05 UTC. Rotation from MOTION-222: version-matched IgH receive-buffer behavior is still UNKNOWN; do not turn historical WC evidence into a stale-byte claim. This lesson instead studies a distinct LinuxCNC implementation surface.

## Provenance
- LinuxCNC tag `v2.9.10`, [src/emc/tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), Git blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`. Inspected symbols: `tpSetTermCond`, `tpAddLine`, `tpAddCircle`, `tpCheckEndCondition`, `tpRunCycle`, `tpHandleEmptyQueue`, `tpCompleteSegment`.
- [src/emc/tp/tp.h](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.h), blob `a50e39413b887e8748c6396dacb37e1d527cd2b3`: planner API, including `tpRunCycle(TP_STRUCT*,long)` and `tpSetTermCond`. These are source-specific findings, not claims about all versions.

## Mechanism
1. **Termination configuration:** `tpSetTermCond` accepts `TC_TERM_COND_PARABOLIC`, `TANGENT`, `EXACT`, and `STOP`, stores `termCond` and `tolerance`, and rejects other codes. Merely configuring a blend termination mode does not prove that any particular corner will blend.
2. **Queue admission:** `tpAddLine` constructs a `TC_LINEAR` segment, copies planner state and synchronized IO, constructs geometry from `goalPos` to endpoint, rejects `target < TP_POS_EPSILON`, clamps velocity by segment length, considers mode changes, conditionally calls `tpHandleBlendArc` when `arcBlendEnable`, finalizes previous segment, flags early stop, queues the segment, then runs optimization. `tpAddCircle` has analogous flow but checks `pmCircle9Init` before accepting a nonzero arc length.
3. **Servo-cycle execution:** `tpRunCycle` retrieves current and adjacent queue entries, handles empty queue, abort and at-speed waits, activates segment, performs spindle synchronization, clears flags, runs split or regular cycle, and completes the segment if `tc->remove`. Thus queued motion is not equivalent to executed displacement.
4. **Termination at the boundary:** `tpCheckEndCondition` tests distance-to-go. At `dx <= TP_POS_EPSILON`, it snaps progress to target and marks removal for STOP/EXACT or reverse-run. For other forward termination modes, it may instead schedule a split cycle; its calculations use current and final velocity, remaining distance and tangential acceleration. STOP/EXACT paths return without the forward blend split computation when not already at target.
5. **Queue empty:** `tpHandleEmptyQueue` resets queue, makes `goalPos=currentPos`, sets `done`, clears depth/abort/execution status, and resumes. This is a software planner state transition, not independent confirmation of physical axis position.

## Minimal reproducible inspection
At LinuxCNC tag v2.9.10: `git show v2.9.10:src/emc/tp/tp.c` and search for the seven symbols above. Trace `tpAddLine -> tpAddSegmentToQueue -> tpRunOptimization`, then `tpRunCycle -> tpHandleRegularCycle/tpHandleSplitCycle -> tpCompleteSegment`. Confirm each early return, particularly zero-length, empty queue, abort, at-speed wait and STOP/EXACT. Compare with `tp.h` signatures. No machine connection is required.

## Review oracles (analytical; NOT executed)
| Case | Expected source-path observation | What is NOT established |
|---|---|---|
| Zero-length line | `TP_ERR_ZERO_LENGTH` before enqueue | Interpreter acceptance of an entire G-code block |
| Nonempty queue, at-speed wait | `TP_ERR_WAITING` before regular/split cycle | Physical spindle state or latency |
| Empty queue | `TP_ERR_WAITING` after planner status reset | Encoder position matches commanded position |
| Near target, STOP | Progress snapped, segment marked remove | Servo motor instantly stops |
| Forward non-STOP termination | May compute split-cycle boundary | Corner velocity without geometry/limits |
| Arc with geometry-init error | Returns init error before queue | Specific interpreter error text |

## Application and boundaries
For a press-brake or plasma postprocessor, segment admission, blending, and actual toolpath execution are different stages. Do not assume a sequence of short G1 blocks is followed exactly at each vertex merely because the G-code lists the points; examine termination mode, planner blending configuration and physical limits. Conversely, a configured blending mode does not guarantee smooth nonzero corner speed. Personnel safety remains independently enforced outside trajectory planning.

**SOURCE-CONFIRMED:** listed functions and branches at pinned blob. **INFERENCE:** implications for machine-specific postprocessing. **UNKNOWN:** exact Task-to-TP mapping for G61/G61.1/G64, concrete corner speeds, realtime execution and v2.10/development parity. **TEST-CONFIRMED:** none. No build, simulation, Actions runner, lab compute or physical machine.

## Next checkpoint
Trace Task/canonical/interpreter handling of G61, G61.1, G64 and tolerance through to `tpSetTermCond`, including whether the tolerance affects geometric deviation. Pin exact source blobs, use a two-segment corner example and preserve source-only status until independent executable evidence exists. If no new behavior emerges, rotate to homing or machine-specific 3000-series configurations. Do not reopen graduated levels or change evaluation gates.
