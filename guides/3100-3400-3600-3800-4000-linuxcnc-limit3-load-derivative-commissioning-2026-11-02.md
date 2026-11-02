# 4000/3100/3400/3600/3800 — limit3 load transition regression and extra-joint handoff
**LIMIT3-158 | 2026-11-02 | disconnected software-only procedure; NOT RUN**

## Why it matters
LinuxCNC's `limit3` is used as a bounded velocity/acceleration signal follower, including the real upstream `configs/sim/axis/extrajoints/1extrajoint.hal` post-home command path and `configs/sim/axis/vismach/hbm/hbm.hal` simulated actuator feedback. The `load` input is an intentional instantaneous reinitialization. This exercise tests whether the first **subsequent** servo callback is properly initialized rather than misreading the jump as a velocity.

Pinned source and arithmetic: [LIMIT3-158 audit](../research/4400_LINUXCNC_LIMIT3_158_LOAD_ONE_CYCLE_DERIVATIVE_STATE_SOURCE_AUDIT_2026-11-02.md). Stable source blob `a2563e7543a64140b253a5e4dace12f0160cdcec`, LinuxCNC v2.9.10 commit `86cdca76fa2a36274c432caa21952b23c267989a`. Development commit `67437d8865e431a9a33f74cee912dbf891d3b4c5` is a separate build/test target.

## Preflight and reproducibility
Use only an **independently verified physically disconnected** `[self-hosted, openpressbrake]` environment if a LinuxCNC build/HAL run is justified and authorized; never dispatch a GitHub-hosted Actions job. This guide is a retained fixture, not a command to run a machine. Preserve exact LinuxCNC commit, component blob, compiler/build status, `halcmd show funct`, 1 ms thread period, raw streamer input, sampler output, stdout/stderr, and process exit codes. Do not claim real-time or physical validation from a software run.

Use the upstream test pattern `loadrt streamer cfg=fb` / `loadrt sampler cfg=ffb`, and run `streamer.0` **before** `limit3.0`, then `sampler.0` in one 1 ms floating-point thread. `f` is float and `b` is bit per the official `streamer(9)` manual. The provided `limit3_load_trace.hal` uses 64-slot streamer and 2048-slot sampler FIFOs to avoid a known stable wrapped-depth corner when fewer than 64 input rows are supplied. The input files contain 8 rows each.

### Suggested bounded execution on a qualified disconnected LinuxCNC RIP installation
From `examples/4000_limit3_158`, in a clean LinuxCNC HAL environment, run a single fixture using an upstream-test-style HAL script:
```sh
halrun -f limit3_load_trace.hal
```
The HAL file starts its thread, loads the 8-row streamer input, and collects 100 samples. Confirm that `halstreamer` has completed and that the capture includes the input `load` transition; a missing pulse makes the test **HARNESS INVALID**. The HAL file uses relative paths: run from this directory. If `halrun` in the installed build does not support `-f` in this form, invoke `halcmd -f limit3_load_trace.hal` inside the ordinary isolated `halrun` environment; do not substitute a physical machine INI.

For the two-cycle control, copy the fixture to a temporary file and change the streamer input filename to `load_two_cycles.txt`; retain both exact files and traces. To compare corrected source, build an isolated patched LinuxCNC revision; do not patch a production installation.

## Frozen discriminators
| Case | Input | Original source prediction | Corrected prediction |
|---|---|---|---|
| A | initial zero, no load | output remains zero | same |
| B | one-cycle load to 10 | load callback publishes 10 | same |
| C | first callback after one-cycle load | **19.99999** at 1 ms, with min/max ±100, maxv 1, maxa 10 | **10.00000** |
| D | two consecutive load cycles to 10 | first non-load callback remains 10 | same |
| E | input step 0→10 without load | constrained output, no instantaneous 10 | same |
| F | 10→10 with load held TRUE | direct loaded position; bypass is documented | same |
| G | new load at -10 | derivative sign reverses; inspect bounded trace | no post-load synthetic velocity |
| H | development build | verify same mechanism with `out_set` API | requires separately adapted patch |

A/B/C/D are the essential proof. A successful `halrun` exit without matching sample rows is not a pass. For C, identify the exact row where `load` falls to zero and use the **next** `limit3` output sampled in that same callback; do not mistake sample sequence or stale FIFO state for a source result. For E/G/H, freeze numeric inputs and acceptance tolerances before any additional execution.

## Implementation review
The [stable patch](../examples/4000_limit3_158/limit3_load_derivative_reset_v2910.patch) touches only the load branch. Review the state meaning of `out_old` (clamped output position) and `in_pos_old` (the **raw effective input**). When the raw input exceeds `min/max`, storing the clamped value as input history creates a second artificial input velocity on the next callback. Verify ordinary `SET_NEXT_STATE` behavior remains unchanged. Compare the actual output delta with `maxv*dt=0.001`; the load callback itself is intentionally exempt, the *next* callback is not.

## Scope boundaries
- Do not connect to a drive, motor, press brake, plasma torch, real Mesa outputs, EtherCAT hardware, or a machine configuration.
- This is **not** a functional-safety claim. Independent personnel-safety authority remains unchanged.
- Do not reopen graduated 1000/2000/3000 levels. The work is a non-graduated 4000 source/implementation extension.
- No existing blind evaluator answer is used; no independent score is claimed.
