# Press-brake cycle sequencing and timeout ownership — bounded research note

Date: 2026-09-11
Course context: dependency-safe 4600 preparation while F02 is blocked
Pinned LinuxCNC baseline for source-level conclusions elsewhere in this track: `8bf4605ae81042248add031e94c77300406e0413`

## Question

Where should press-cycle sequencing, waiting, timeout detection, and fault authority live when LinuxCNC is used for a hydraulic press brake?

## Evidence

### 1. Public Accurpress field report: keep ordinary trajectory execution in MOTION

Ted's April 26, 2022 Accurpress report says an early large custom component attempted to control the ram and state-machine the process. He reports that approach was jerky. The field release instead uses LinuxCNC MOTION for the ram and both backgauge axes and feeds simple sequences/interrupts through normal LinuxCNC motion/G-code. The same report distinguishes manual, semi-auto-repeat, and intended fully automatic sequencing, and says the fully automatic sequence feature was never completed.

Evidence class: `COMMUNITY-REPORTED FIELD EXPERIENCE`.

Source: https://forum.linuxcnc.org/show-your-stuff/45716-vertical-press-brake-interface-and-comp

Important boundary: this is evidence against casually rebuilding ordinary trajectory control inside a monolithic press-cycle component. It is not proof that all hydraulic state sequencing belongs in G-code, and it does not establish a safety architecture.

### 2. LinuxCNC M66 has explicit non-realtime wait/timeout semantics

Current official M-code documentation defines `M66` as waiting for a selected digital input event/state and allows a `Q` timeout. On timeout, execution resumes with `#5399 = -1`. The documentation explicitly says these inputs are **not monitored in realtime** and should not be used for timing-critical applications.

Evidence class: `DOC-CONFIRMED` for the documented interface; pinned-source confirmation remains a follow-up if M66 becomes part of a proposed 4600 architecture.

Source: https://linuxcnc.org/docs/html/gcode/m-code.html (M66 section; mirrored source is `docs/src/gcode/m-code.adoc`).

Engineering implication: M66 is a useful supervisory/program-sequencing primitive for bounded waits whose timing need not be servo-period deterministic. It is the wrong primitive for a fast hydraulic synchronization/fault loop or a safety-rated stop decision.

### 3. LinuxCNC homing demonstrates explicit state-machine abort ownership

Pinned/current LinuxCNC homing source provides a useful architecture pattern even though homing is not press cycling. `base_do_cancel_homing()` transitions an active joint to `HOME_ABORT`; the homing state machine owns the operation state and its abort path. Source comments also document that some state transitions may execute immediately in the same servo period while others wait for the next period.

Evidence class: `SOURCE-CONFIRMED` architectural pattern; exact press-brake behavior is an inference, not inherited from homing.

Source path: `src/emc/motion/homing.c`.

Engineering implication: a realtime operation that owns a multi-cycle state transition should also own its deterministic transition/abort bookkeeping rather than depending on an unrelated GUI timeout to infer that it stalled.

### 4. `timedelay` is a realtime qualification primitive, not a fault policy

LinuxCNC's `timedelay.comp` accumulates `fperiod` while its boolean input disagrees with its output and changes the output after the configured on/off delay. This is a deterministic realtime signal-conditioning primitive.

Evidence class: `SOURCE-CONFIRMED` for component behavior.

Source path: `src/hal/components/timedelay.comp`.

Engineering implication: realtime debounce/persistence qualification can be built near the signal path, but `timedelay` by itself does not define what a press should do when a qualified timeout/fault occurs. Detection and response authority must remain explicit.

### 5. Ursviken project exposes the cost of unclear subsystem ownership

The December 2, 2025 Ursviken/Pullmax thread records a transition from a standalone HAL/Glade application toward full LinuxCNC specifically to avoid reimplementing homing and slave-axis/ram behavior. The builder encountered `USRMOT: ERROR: command timeout` while integrating MOTMOD. Community advice pointed toward LinuxCNC extra joints, but later work ultimately used independent Y1/Y2 position loops plus a differential synchronization loop.

Evidence class: `COMMUNITY-REPORTED DEVELOPMENT HISTORY`.

Source: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

This supports the curriculum rule that adopting LinuxCNC is not merely about generating analog outputs: ownership of homing, trajectory, joint state, and machine-cycle semantics has to be chosen deliberately.

## Derived layered timeout/abort contract

The evidence supports the following **INFERENCE / design contract**, not a claim that LinuxCNC enforces this architecture automatically:

1. **Trajectory/joint layer** owns ordinary commanded motion, joint following-error state, homing state, and motion-level abort behavior supplied by LinuxCNC.
2. **Y1/Y2 synchronization layer** owns fast differential-error detection and whatever bounded correction/fault decision is required at servo-thread rate. It must observe physical side feedback, not merely a Cartesian/master position.
3. **Press-cycle layer** owns semantic states such as approach, working stroke, dwell, decompression/return, and completion only where those states are genuinely machine-process semantics rather than ordinary trajectory segments. Every multi-cycle wait needs an explicit success condition and an explicit failure/timeout transition.
4. **Program/supervisory layer** may use non-realtime waits such as M66 for events where its documented timing is sufficient. A timeout here should produce an explicit program/cycle failure result; it must not masquerade as the primary fast hydraulic fault detector.
5. **Hydraulic decoding/output layer** maps abstract allowed motion/mode requests to machine-specific valves/pumps only after authorization and fault state are known. Generic curriculum material must not invent valve truth tables or pressure thresholds.
6. **Functional-safety layer** remains separate. Neither a LinuxCNC state machine, M66 timeout, HAL timer, GUI watchdog, nor ordinary PC software is presumed safety-rated.

## Adversarial checks

- **Misleading premise:** “If M66 has a Q timeout, it can protect a tandem ram from one side lagging.” Rejected. M66 is documented non-realtime; tandem differential protection belongs in the realtime control/fault path, with safety functions separately justified.
- **Misleading premise:** “The cycle component should command every actuator directly because it knows the process state.” Rejected as a default. The Accurpress field history specifically reports poor results from a monolithic ram/process component and improved operation after returning ordinary axes to MOTION.
- **Failure-path check:** a wait with no explicit timeout/abort transition can strand the process state even if lower-level motion remains healthy. A timeout detector without explicit response ownership is likewise incomplete.
- **Observability check:** a GUI or supervisory timeout cannot prove whether the failure was trajectory starvation, stale feedback, hydraulic non-response, synchronization error, or a lost process input. Each layer needs a witness appropriate to its own responsibility.

## Open questions / next source work

1. Trace the exact pinned-source implementation path for `M66 Q` from interpreter command creation through Task/I/O wait completion and `#5399`, including abort behavior. This becomes necessary before recommending M66 in a 4600 implementation guide.
2. Inspect the available Accurpress component versions specifically for state dwell/timeout counters, reset behavior, and how ESTOP/machine-off interrupts active process states.
3. Inspect later Ursviken posts for explicit cycle-state timeout/fault behavior separate from Y1/Y2 synchronization.
4. Build a generic failure-ownership matrix: lost scale, following error, side mismatch, valve command saturation, pressure not achieved, pedal released, process input absent, Task/program wait timeout, field-I/O communication loss, and safety-chain removal. For each, identify detector, timing class, state owner, commanded response, and diagnostic witness without inventing machine-specific limits.

## Sufficiency decision

This bounded pass is sufficient to preserve a stronger architecture rule: **timeouts are not interchangeable merely because they all measure elapsed time. The layer that has the required timing and causal evidence should detect the condition, and the layer that owns the operation must have an explicit abort/failure transition.** Supervisory timeout mechanisms must not be promoted into realtime synchronization or functional-safety mechanisms.
