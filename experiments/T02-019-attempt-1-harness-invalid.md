# T02-019 attempt 1 — HARNESS_INVALID

Workflow: `34179358988`  
Job: `101915092758`  
Harness commit: `7d310c87c2e9a678fcadd6e7c742e733c2c7417f`  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Workflow lab exit: `1` (uncaught startup timeout; semantic classification below)

## Classification

**HARNESS_INVALID — startup/homing orchestration failed before the T02 stimulus was loaded or executed.**

This run is not evidence for or against the frozen Task-layer prediction.

## Evidence

The run established the pinned-build provenance gate and brought the stock `linuxcncrsh` fixture to a responsive state. The Python API exposed the expected Task constants, and the setup commands for ESTOP reset, machine ON, and MANUAL mode completed.

The harness then issued `command.home(-1)` and waited for every reported joint to become homed. That predicate timed out. The T02 G-code was never accepted as the active program and the experiment never reached the motion/dwell stimulus.

Observed relevant output:

- `gate-A=PASS`
- `runtime-ready-probe=...`
- `constant-EXEC_DONE=1`
- `constant-EXEC_WAITING_FOR_MOTION_AND_IO=7`
- `constant-EXEC_WAITING_FOR_DELAY=9`
- ESTOP reset / machine ON / MANUAL command completion reported
- final failure: `RuntimeError: timeout waiting for all-homed`

## Gate reconciliation

| Gate | Attempt-1 result | Reason |
|---|---|---|
| A | PASS | Executable and Python module provenance were tied to the pinned work tree. |
| B | HARNESS_INVALID | Healthy startup did not complete the required homing phase. |
| C | NOT REACHED | No program motion was executed. |
| D | NOT REACHED | No Task barrier stimulus existed. |
| E | NOT REACHED | No dwell was issued. |
| F | NOT REACHED | No dwell interval was observed. |
| G | NOT REACHED | Program never ran. |

## Correction allowed without changing the frozen experiment

Gate B requires a healthy startup with homing; it does not prescribe `home(-1)` as the homing mechanism. The corrected harness will command each active joint explicitly in the fixture's configured homing sequence and independently wait for each joint's `homed` status before proceeding. It will also convert a startup timeout into an explicit HARNESS_INVALID exit rather than an unclassified Python exception.

The G-code stimulus, Task/motion observations, predictions, Gates A-G, the 0.60..1.10 s dwell tolerance, and the anti-circular line-number rule remain unchanged.

## Evidence-preservation correction

Attempt 1 wrote the high-rate CSV inside the ephemeral runner and printed only selected slices. Before a valid attempt, the harness will print the complete CSV between explicit raw-trace markers so the workflow's committed stdout preserves the raw sampled evidence. This changes evidence retention, not acceptance criteria.

## Attempt-family accounting

This is materially similar **attempt 1 of at most 3** for T02-019. A corrected second attempt is permitted. A third materially similar attempt, if needed, is the final one before mandatory ESSENTIAL NOW / PROMOTE / DROP classification.
