# S04 — Stale/Frozen Feedback: Initial Research

Status: **RESEARCH**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Research refresh: 2026-09-07

## Objective

Teach a fresh AI to recognize that **stale/frozen feedback is a data-validity problem, not merely a transport-fault problem**.

S03 proved one concrete mechanism: persistent HostMot2 `io_error` can leave a last-published HAL value visible. S04 generalizes the problem to cases where a sensor path can freeze while no transport-specific fault is available.

The core diagnostic question changes from:

> "Did communication fail?"

to:

> "What evidence says this measurement is fresh and physically plausible right now?"

## Initial taxonomy

### A — Explicit invalid/fault state

Examples: hm2_eth `packet-error`/persistent `io_error`, drive/remote fault bits, component validity flags.

This is the easiest case because a separate signal already says the data path is suspect. A consumer should not silently continue labeling the numerical feedback as current.

### B — Frozen measurement under commanded/process motion

The measured number remains constant while independent command/process evidence predicts a meaningful change. This is where LinuxCNC joint following error can detect a consequential mismatch if command and feedback diverge beyond the configured threshold.

### C — Frozen measurement while the machine is genuinely stationary

A single numerical sensor stream cannot, by itself, distinguish "correctly unchanged" from "frozen at the same value." Detecting this requires additional evidence such as a sensor heartbeat/timestamp, independent measurement, excitation/motion expectation, or device-specific status.

This is an identifiability limit, not a threshold-tuning problem.

### D — Two measurements disagree

Independent/redundant sensors may provide a plausibility check even during otherwise ambiguous conditions. Exact voting/disagreement architecture belongs primarily to S05, but S04 must preserve the distinction between **freshness** and **agreement**: two sensors can agree and both be stale, or disagree while both are fresh.

## Pinned motion following-error path

Pinned `src/emc/motion/control.c::process_inputs()` reads each active joint's `motor_pos_fb` HAL input into `joint->motor_pos_fb`, computes compensated `joint->pos_fb`, then calculates:

`joint->ferror = joint->pos_cmd - joint->pos_fb`

For ordinary joints, the magnitude is compared with a velocity-dependent `ferror_limit`. The code scales the configured `max_ferror` by `abs(joint->vel_cmd) / joint->vel_limit`, then clamps that result no lower than `min_ferror`. If `abs_ferror > ferror_limit`, it sets the joint following-error flag.

Later in the same servo-cycle control path, `check_for_faults()` sees `GET_JOINT_FERROR_FLAG(joint)`, reports `joint N following error`, sets the joint error flag, and sets `emcmotInternal->enabling = 0`. `set_operating_mode()` then disables active joints/motion.

### What this can detect

If the command continues moving while `motor-pos-fb` freezes, command-minus-feedback normally grows. Once it exceeds the active threshold, the standard following-error mechanism faults motion.

### What this does not establish

Following error is not a generic freshness detector:

- it detects **position mismatch**, not "age of sample";
- a feedback stream frozen near the current command while command is stationary may never exceed the threshold;
- a slowly moving or quantized sensor can remain unchanged for legitimate intervals;
- thresholds intentionally tolerate ordinary servo lag/noise and vary with commanded velocity;
- a carefully fabricated/stale value that tracks command could evade this test;
- a following-error trip is ordinary LinuxCNC motion fault handling, not a safety-rated plausibility function.

## Current documentation reconciliation

Current LinuxCNC INI documentation describes `MIN_FERROR` as the low-speed permitted command-versus-sensed-position deviation and `FERROR` as the maximum allowable following error, with a velocity-dependent ramp between them. The documentation explicitly notes that a nonzero minimum avoids nuisance trips for stationary axes.

That reinforces an important S04 tradeoff: **making the threshold tiny is not equivalent to creating a freshness detector**. Normal vibration, servo lag, quantization, and timing must be tolerated.

Official reference: https://linuxcnc.org/docs/2.9/html/config/ini-config.html

## Generic HAL building blocks — useful but limited

### `ddt(9)`

`ddt` calculates the difference between current and previous input divided by elapsed function time. Current documentation warns that it works poorly when the input changes more slowly than every realtime invocation.

A zero `ddt` output is therefore not sufficient evidence of a frozen sensor: a truly stationary axis and a low-rate/quantized measurement can both legitimately produce zero.

Official reference: https://linuxcnc.org/docs/devel/html/en/man/man9/ddt.9.html

### `wcomp(9)` / `near(9)`-style comparators

Window/tolerance comparators can detect that an error signal lies outside an allowed band. They are useful ingredients for plausibility monitoring, but they do not create independent freshness evidence. Their validity depends on the selected reference, tolerances, timing, and process state.

Official `wcomp(9)` reference: https://www.linuxcnc.org/docs/2.9/html/man/man9/wcomp.9.html

## Diagnostic design rules emerging from research

1. **Carry validity separately from value.** A numeric position without freshness/validity context can be misleading.
2. **Use process context.** "Unchanged" is suspicious only when independent evidence says change should have occurred.
3. **Do not confuse derivative with freshness.** Zero rate can be correct.
4. **Do not confuse following error with sensor-age detection.** It is a command-vs-feedback plausibility limit.
5. **Prefer independent evidence.** Device heartbeat/timestamp, second sensor, or actuator/process response can close cases a single scalar cannot.
6. **Treat recovery as a state transition.** A sensor that starts changing again may need coherent-state checks before its value is trusted.
7. **Do not call ordinary HAL/motion diagnostics safety-rated.** Safety performance requires a separate architecture, failure analysis, and validation.

## Candidate representative call flow

For the first S04 source guide, trace the frozen-feedback-under-motion case:

`joint.N.motor-pos-fb` frozen  
→ `process_inputs()` reads same value  
→ `joint->pos_fb` stays fixed  
→ moving `joint->pos_cmd` increases `joint->ferror`  
→ velocity-scaled `ferror_limit` comparison  
→ `SET_JOINT_FERROR_FLAG`  
→ `check_for_faults()` sets joint error + clears enabling intent  
→ `set_operating_mode()` disables active joints/motion  
→ HAL/status publication shows fault/disable state.

The source trace must also record special cases such as homing index handling and extra joints so it is not over-generalized.

## Predeclared experiment direction

A bounded no-hardware experiment should use an ordinary simulated joint whose normal `motor-pos-fb` follows `motor-pos-cmd`, then insert a controllable test mux into the feedback path:

- healthy selection: command loopback reaches feedback;
- frozen selection: feedback is held at a known fixed/last value while command continues to move.

### Required gates

**Gate A — healthy baseline**
- machine enabled;
- commanded joint movement occurs in the simulation;
- feedback tracks command;
- no following error.

**Gate B — inject frozen feedback during motion**
- freeze selection changes only the feedback source;
- command continues far enough to exceed the predeclared active following-error limit.

**Gate C — expected fault**
- following error is observed;
- joint/motion disables through the normal production motion path;
- diagnostic is captured.

**Gate D — adversarial stationary control**
- repeat freeze while command is genuinely stationary;
- demonstrate that unchanged feedback alone does not necessarily trigger following error.

Gate D is essential: it proves the experiment teaches the **limitation** of mismatch-based detection rather than falsely presenting following error as a universal frozen-sensor detector.

## Evidence boundaries for the planned experiment

A pass can establish production LinuxCNC software/motion behavior for a simulated feedback freeze. It cannot establish:

- actual encoder hardware failure modes;
- independent sensor diagnostic coverage;
- physical stopping time;
- torque removal/STO/brake behavior;
- probability of dangerous failure;
- PL/SIL/category or any other functional-safety performance.

## Exact next checkpoint

Advance S04 to SOURCE by completing the pinned `process_inputs()` → following-error flag → `check_for_faults()` → `set_operating_mode()` → HAL/status publication call flow, including the exact exported pins/status fields that show following error and disabled state. Then predeclare numeric `MIN_FERROR`/`FERROR`, command distance/velocity, and observation gates for the simulated feedback-freeze experiment before implementing it. Preserve Gate D's stationary-frozen control so the lesson cannot overclaim that command/feedback mismatch is a universal freshness detector.