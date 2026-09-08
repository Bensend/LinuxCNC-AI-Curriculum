# T02-019 — Task motion-gated delay experiment plan

Status: **FROZEN BEFORE IMPLEMENTATION**
Course level: 1000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Independently verify the pinned Task-layer claim that a queued trajectory delay/dwell following motion is selected by Task but is not issued until prior motion and I/O report completion, after which Task enters `WAITING_FOR_DELAY` for the dwell interval.

This experiment must also demonstrate why interpreter/Task line progress is not a physical-motion completion oracle.

## Fixture

Use a stock LinuxCNC simulation configuration at the pinned build with a single deterministic linear move slow/long enough to observe, followed by a dwell. Candidate program:

```gcode
G21 G90
G0 X0
G1 X20 F120
G4 P0.75
M2
```

Exact distance/feed may be adjusted only before first execution if the stock sim's configured velocity/limits require it. Once the harness is committed and first run begins, Gates A-G below are immutable for the attempt family.

## Independent sampler

A Python process using the pinned build's `linuxcnc` module will poll `linuxcnc.stat()` at a bounded interval substantially shorter than `[TASK] CYCLE_TIME` where practical and record monotonic timestamp plus at minimum:

- `exec_state`;
- `interp_state`;
- `read_line` / `current_line` / `motion_line` where exposed;
- `inpos`;
- commanded and actual position relevant to X;
- task/motion status fields needed to distinguish completion.

The sampler must record raw observations before reducing them to pass/fail gates.

## Frozen predictions

1. During the ordinary linear move, Task is permitted to remain/return `EXEC_DONE` after issuing the move; Task does not use a postcondition that waits for physical completion of every linear move.
2. Before the dwell is issued, Task reaches `EXEC_WAITING_FOR_MOTION_AND_IO` while prior motion is not yet complete (`inpos == false` and/or independent motion evidence says not done).
3. The dwell's timer state (`EXEC_WAITING_FOR_DELAY`) does not begin before the motion-completion barrier is satisfied.
4. After motion completes, Task transitions from the motion/I/O barrier to issuing the dwell and then exposes `EXEC_WAITING_FOR_DELAY` for a nonzero interval compatible with the programmed dwell.
5. Program completion eventually reaches Task/interpreter idle/done and motion in-position without controller error.

## Gates

### Gate A — provenance
PASS only if the harness records the LinuxCNC source revision/build provenance and it matches `8bf4605ae81042248add031e94c77300406e0413`. Ambiguous executable provenance is HARNESS_INVALID.

### Gate B — healthy baseline
PASS only if LinuxCNC starts normally, reaches machine ON / required simulated homing state, loads the fixture, and the sampler captures valid NML status before program start.

### Gate C — moving-state evidence
PASS only if the trace independently observes the commanded linear move in progress, using position/in-position or motion-status evidence rather than line number alone.

### Gate D — Task barrier observed
PASS only if `EXEC_WAITING_FOR_MOTION_AND_IO` is observed after the linear move was issued and before independent motion completion.

If the transition is too short to sample despite a valid deterministic slow move, classify HARNESS_INVALID rather than changing the expected state post hoc; improve sampling/fixture observability before another attempt.

### Gate E — dwell does not start early
PASS only if no `EXEC_WAITING_FOR_DELAY` sample occurs while independent motion evidence still shows the preceding move incomplete.

### Gate F — dwell state and duration
PASS only if `EXEC_WAITING_FOR_DELAY` is observed after motion completion and its measured interval is plausibly consistent with a 0.75 s requested dwell, allowing bounded Task polling/sampling quantization. Initial tolerance: observed WAITING_FOR_DELAY span must be >=0.60 s and <=1.10 s. This tolerance is frozen for the first attempt family.

### Gate G — completion/recovery
PASS only if the program reaches normal completion with Task/interpreter done/idle and motion in-position, with no Task/motion/I/O error state.

## Adversarial / anti-circular checks

The harness must explicitly calculate and report whether `current_line` or interpreter read-ahead reaches the dwell line before motion completion. Either result is acceptable; line advancement is not itself a gate. The forbidden inference is: `current_line == dwell_line => previous motion completed`.

The harness must preserve raw timestamped samples sufficient to audit every gate independently from its summary.

## Failure classifications

- LinuxCNC cannot start or pinned build cannot be proven: **HARNESS_INVALID**.
- Transition exists in source but polling misses it: **HARNESS_INVALID**, redesign observability rather than weakening Gate D.
- Task enters `WAITING_FOR_DELAY` before independent motion completion: **SUBSTANTIVE MISMATCH**, investigate source/runtime assumptions before rerun.
- subordinate motion/I/O reports ERROR: preserve trace and classify whether fixture/config failure or representative Task failure-path evidence.
- a run that changes the program, sampling semantics, or gates after observing results is not accepted as the same frozen attempt.

## Evidence boundaries

A passing simulation proves LinuxCNC's software Task/motion coordination at the pinned revision. It does not prove physical actuator completion, feedback correctness, transport freshness, or functional-safety behavior.
