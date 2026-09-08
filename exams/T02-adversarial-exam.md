# T02 adversarial exam — Task layer and execution-state evidence

Status: **PASSED — 10/10 after T02-019 reconciliation**  
Pinned source basis: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test whether an AI can reason about the Task layer without collapsing interpreter progress, Task queue state, realtime motion state, physical position, or safety state into one another.

A passing answer must name the relevant evidence domain and reject circular or over-broad inferences.

## Q1 — current line fallacy

A UI reports `current_line = 40`, where line 40 is `G4 P0.75` immediately after a long `G1` move. An engineer concludes: “The G1 is finished because LinuxCNC is already on the dwell line.” Is the conclusion valid?

### Required answer

No. Task may have selected/dequeued the dwell while its precondition is still `WAITING_FOR_MOTION_AND_IO`, and interpreter/read-ahead may be still farther ahead. Line selection is not a motion-completion oracle. Check Task `exec_state` plus an independent motion state such as `inpos`/motion status (and, on real hardware, appropriate feedback provenance).

## Q2 — linear move postcondition trap

Pinned source says a queued `EMC_TRAJ_LINEAR_MOVE` has precondition `WAITING_FOR_IO` and postcondition `DONE`. Does Task `DONE` immediately after issuing the linear move prove the machine reached endpoint?

### Required answer

No. That `DONE` means Task is free to process the next queued command according to its preconditions. It is intentionally compatible with motion continuing in the subordinate trajectory subsystem.

## Q3 — dwell ordering

A `G4 P0.75` follows queued motion. Which state transition provides the important ordering guarantee in the representative pinned path?

### Required answer

The queued `EMC_TRAJ_DELAY` precondition is `WAITING_FOR_MOTION_AND_IO`. Task does not issue the delay until both motion and I/O report DONE; only after issue does the delay postcondition become `WAITING_FOR_DELAY` and the dwell timer run.

## Q4 — adversarial trace

A trace shows:

- 2.0 s: `current_line=4`, `exec_state=WAITING_FOR_MOTION_AND_IO`, `inpos=0`
- 9.9 s: `current_line=4`, `exec_state=WAITING_FOR_MOTION_AND_IO`, `inpos=0`
- 10.1 s: `current_line=4`, `exec_state=WAITING_FOR_DELAY`, `inpos=1`
- 10.84 s: `exec_state=DONE`

What does this trace demonstrate, and what does it not demonstrate?

### Required answer

It demonstrates the software ordering predicted for the simulated Task/motion system: the dwell command can be the current Task line while prior motion remains incomplete; its delay state begins only after the simulation reports in-position; and the observed delay span is approximately compatible with 0.75 s. It does not prove physical drive motion, encoder truth, transport integrity, or a safety-rated stop/interlock.

## Q5 — circular oracle

A test declares Gate D passed when `current_line==4`, then uses the same condition to assert the move must be complete before dwell. What is wrong?

### Required answer

The oracle is circular and contradicts the architecture. `current_line` is Task queue/selection evidence, not independent motion evidence. Gate D needs a separate subsystem observation (`inpos`, motion status, position evolution); physical claims need still more independent evidence.

## Q6 — source-vs-community conflict

A forum post says “G4 always stops read-ahead.” Pinned source inspection for this revision shows the queued delay's Task precondition and postcondition but no basis for treating ordinary G4 as the same interpreter queue-buster mechanism used for unpredictable results such as probing. Which evidence wins for the source-specific claim?

### Required answer

Pinned source and a reproducible pinned-build experiment. Community reports are useful field evidence and hypothesis generators, not authority over the exact revision. Also distinguish “Task waits for prior motion before issuing a delay” from “the interpreter necessarily stops read-ahead at G4”; they are different claims.

## Q7 — NML status vs physical truth

`linuxcnc.stat().exec_state == EXEC_WAITING_FOR_DELAY` and `inpos == 1`. Can an AI tell an operator that the physical axis is safely stationary?

### Required answer

Not from those observations alone. They show controller-reported Task/motion state. On a loopback simulation they are only simulator evidence. On hardware, physical-stationary and safe-state claims require trustworthy feedback/provenance and the machine's independent safety architecture as applicable.

## Q8 — abort boundary

Task enters `ERROR` because a subordinate status reports error; pinned Task code aborts motion/I/O/spindle work and clears/reset queues. Is this a safety function?

### Required answer

It is ordinary controller error/abort sequencing. It must not be represented as an independently safety-rated function unless an actual safety architecture with appropriate hardware, diagnostics, and validation establishes that claim.

## Q9 — novel sequence

Consider:

```text
G1 X100 F100
M66 E0 L0
G1 X0 F100
```

An AI sees the interpreter paused at the `M66` synchronization boundary and says the first move is physically complete. What should the AI do instead?

### Required answer

Identify the exact queue-buster semantics and Task/subordinate completion evidence for the pinned version, then check independent motion/feedback state. The fact that read-ahead is stopped at a queue-buster is useful ordering evidence, but a physical-position claim must not be inferred from interpreter state alone.

## Q10 — engineering transfer

A custom userspace component writes a PLC output as soon as `read_line` reaches a particular G-code line because the designer wants the output to occur after a move finishes. What is the architecture defect?

### Required answer

The component is coupling a physical sequencing action to interpreter/read-ahead progress rather than an execution-completion signal. The design should use a Task/canonical mechanism with defined ordering or a properly synchronized state/handshake whose completion evidence belongs to the needed subsystem; safety-critical sequencing must be implemented in the appropriate safety architecture.

## Passing rubric

Pass requires all of the following:

1. Reject line number/read-ahead as a motion-completion oracle.
2. Distinguish queued selection, issue, Task postcondition, subordinate completion, and physical truth.
3. Correctly explain `WAITING_FOR_MOTION_AND_IO -> issue delay -> WAITING_FOR_DELAY` for the pinned representative path.
4. Preserve the software/simulation/physical/safety evidence boundaries.
5. Prefer pinned source + reproducible experiment over conflicting informal claims.
6. Solve Q9/Q10 without merely repeating memorized state names.

Any answer that equates Task `DONE`, interpreter progress, or `current_line` with physical endpoint completion is a fail at 1000 level.

## Post-experiment grading

**Score: 10/10 — PASS.**

The accepted T02-019 trace independently supplied the most adversarial condition in the exam rather than merely matching a friendly happy path: `current_line` and `read_line` reached the dwell while `inpos=0`, while Task remained in `WAITING_FOR_MOTION_AND_IO`. Only after `inpos=1` did Task enter `WAITING_FOR_DELAY`; the observed delay-state span was `0.748012 s` for `G4 P0.75`.

The exam's answers correctly preserve five separate evidence domains: interpreter/read-ahead, Task queue selection/preconditions, subordinate motion status, physical-device truth, and safety state. Q9 and Q10 transfer the model to novel synchronization/integration cases rather than merely recalling T02-019 state names. No conceptual correction was required after the accepted experiment.
