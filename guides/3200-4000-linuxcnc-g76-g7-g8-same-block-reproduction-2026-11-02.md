# 3200/4000 — Reproduce G7/G8 same-block G76 depth normalization without a machine

**Review-only, NOT RUN.** This guide exercises a LinuxCNC interpreter/RS274 canonical output, not physical threading, HAL, motion or spindle synchronization. Use a disposable offline build and a physically disconnected, independently qualified self-hosted environment before executing. Do not dispatch a GitHub-hosted runner or point any test at a connected lathe.

## Frozen question and expected discriminant

Do two program blocks that describe the same thread generate different canonical X paths when the G7/G8 modal change is placed on the G76 block instead of the previous line?

Inspect the four `.ngc` files in [examples/4000_g76_mode_173](../examples/4000_g76_mode_173/README.md). They share G21 G18 G90, tool 4, S500 M3, a 10-mm radial start X, P1, Z-5, R1, Q0, H0, no E/L taper. The only intended difference is modal placement and programmed diameter/radius units.

| Case | Modal change | I/J/K | Expected first canonical cutting X, original source inference | Expected full-depth X |
|---|---|---|---:|---:|
| A | G8 before cycle | -1/0.2/1 | 8.8 | 8.0 |
| B | G7 before cycle | -2/0.4/2 | 8.8 | 8.0 |
| C | G7 **on** G76 line | -2/0.4/2 | 9.4 | 9.0 |
| D | G8 **on** G76 line | -1/0.2/1 | 7.6 | 6.0 |

The expected results above are **source-derived predictions**, not observed outputs. Distinguish `STRAIGHT_TRAVERSE` (positioning) from `STRAIGHT_FEED` (cutting); in a no-taper G76 pass the first feed has the same X as the preceding infeed traverse. Preserve full canonical traces and exit codes rather than extracting one X and discarding context.

## Upstream baseline and proposed command sequence

Use the pinned LinuxCNC **v2.9.10** tree, including its existing `tests/interp/g76/test.tbl`. Its official `test.sh` runs `rs274 -t test.tbl -g g76only.ngc` and compares canonical output to `expected`. Run that upstream control **first** in the offline environment. From a directory with a copy of `test.tbl`, for each of A–D use the same interpreter binary and tool table, for example:

```sh
rs274 -t test.tbl -g g8_separate.ngc > A.canon 2> A.err
rs274 -t test.tbl -g g7_separate.ngc > B.canon 2> B.err
rs274 -t test.tbl -g g7_same_block.ngc > C.canon 2> C.err
rs274 -t test.tbl -g g8_same_block.ngc > D.canon 2> D.err
```

Capture exact interpreter build SHA, CLI exit status, stdout/stderr and first/last canonical `STRAIGHT_FEED` X for each. The relative fixture paths are illustrative; place the four files and upstream tool table together or use explicit paths. If the upstream baseline fails, mark the harness **INVALID** and do not score A–D. If any G7/G8+G76 line is rejected, preserve the diagnostic and classify that branch as rejected rather than assuming the source-derived coordinates were executed.

## Proposed patch evaluation

The [review-only stable patch](../examples/4000_g76_mode_173/stable_2910_g76_same_block_review_only.patch) deletes I/J/K conversion from `convert_lathe_diameter_mode` only; retain its X conversion. On an independently qualified isolated runner, make a disposable **separate** build of the patched source and rerun the same baseline and A–D matrix. **Acceptance hypothesis**: upstream baseline unchanged; A/B/C/D all yield first X=8.8 and full-depth X=8.0. Compare stable and pinned development separately; the patch is not yet validated against either build.

## Failure classification

- **Harness invalid:** missing interpreter, tool table, unsupported CLI, upstream baseline failure, invalid file path.
- **Interpreter rejection:** G7/G8 and G76 same-block combination is not accepted; the numeric branch was not exercised.
- **Hypothesis supported:** original A/B equal; C/D differ exactly as frozen; patched A–D equal.
- **Hypothesis refuted:** canonical paths do not match frozen arithmetic; inspect `read_x`, `convert_g`, modal state, G76 preflight and canonical coordinate transformations before revising.
- **Not established by any case:** physical tool engagement, thread profile, spindle-index integrity, machine safety, or qualified cutting procedure.

No new compute is justified while runner physical isolation is unverified. Existing 1000/2000/F02/3000 graduations and independent personnel-safety/OpenPressBrake G0/G1 holds remain intact.