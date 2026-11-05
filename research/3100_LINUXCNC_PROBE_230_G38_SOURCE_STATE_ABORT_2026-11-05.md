# PROBE-230 — LinuxCNC v2.9.10 G38.x probe edge, abort, and feedback semantics (3100 mills; non-graduated)

## Scope and evidence
Read START_HERE, current mission, level order, work-selection policy, curriculum, source policy, blind feedback and compute ledgers, and MOTION-229 checkpoint. This is a **source-only** inspection of upstream LinuxCNC tag `v2.9.10`, not a live machine result. Immutable file blob IDs:
- [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc) blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `convert_probe` near lines 3893–3940.
- [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) blob `0b79061d39be915bbea548b2c33bb794d31ab302`, `EMCMOT_PROBE` near 1415–1480.
- [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c) blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, `emcmotController` near 249–253 and `process_probe_inputs` near 678–730.

## Mechanism established
Interpreter `convert_probe` computes `probe_type = g_code - G_38_2`; bit 0 suppresses failure errors and bit 1 selects break-contact instead of make-contact. G38.2 = 0 (make, error), G38.3 = 1 (make, suppress), G38.4 = 2 (break, error), G38.5 = 3 (break, suppress). Interpreter rejects cutter compensation, zero feed, feed-per-revolution and (for non-suppressed modes) a zero-length endpoint; it emits `TURN_PROBE_ON`, `STRAIGHT_PROBE(..., probe_type)`, `TURN_PROBE_OFF`, and sets the probe flag. This **does not** by itself prove the complete canonical→Task delivery path.

Motion `EMCMOT_PROBE` requires enabled coordinated mode, in-range endpoint and acceptable limits. For non-suppressed modes it rejects a probe already in the *target* state at command acceptance. It queues a trajectory line and marks `probing=1` only after successful admission.

During each controller cycle, `process_probe_inputs` samples `motion.probe-input` and uses `probeVal ^ probe_whenclears` to recognize the target state: HIGH for make-contact, LOW for break-contact. It latches `carte_pos_fb` as `probedPos`, sets `probeTripped=1`, clears `probing`, and calls `tpAbort`. On queue completion without a trigger it still latches feedback position; suppressed modes set `probeTripped=0`, while unsuppressed G38.2/G38.4 report a motion error. The *probe-position field being populated is therefore not evidence of a successful touch*. The source checks state, not a hardware timestamped edge; a transition between servo samples is not characterized here.

An additional, important branch: while not probing, a rising probe-input edge can abort an ongoing non-probe motion (and raise an error). A probe switch should not be treated as an independent personnel-safety input.

## Disconnected inspection / falsifiable oracles
Use a **non-machine** code-review fixture (no axes enabled, no HAL output or hardware connection). Compare these hypothetical sampled sequences, keeping the probe input stable at command admission:
| Command | Input at admission | Later samples | Expected source branch |
|---|---|---|---|
| G38.2 | 0 | 0,1 | touch, `probeTripped=1`, abort trajectory |
| G38.3 | 0 | 0,0 until queue empty | no touch, suppressed failure `probeTripped=0` |
| G38.4 | 1 | 1,0 | break-contact capture |
| G38.5 | 1 | 1 until queue empty | no touch, suppressed failure |
| G38.2 | 1 | not started | rejected at admission (non-suppressed) |
| G38.4 | 0 | not started | rejected at admission (non-suppressed) |
| non-probe move | 0 | 1 | rising edge may abort if queue active and not in-position |

The above are **analytical predictions from inspected branches**, not executed oracles. Do not infer sub-servo-cycle trigger accuracy, physical stopping distance, or actual pin debounce. A reproducible follow-up can inspect `motion.probe-input` wiring and compare a disconnected simulated HAL configuration and the official G38 test suite, using only authorized self-hosted compute if justified.

## Boundaries and next questions
1. Trace `STRAIGHT_PROBE` through canonical interface, Task, and motion message to establish exactly where `probe_type` is transferred and when `#5061`–`#5070` / `#5070` success status become visible.
2. Examine a **real** mill probing HAL/INI configuration and determine probe polarity, signal filtering, thread order and GUI/tool-setting expectations; distinguish source-defined from machine-specific assumptions.
3. Inspect abort/queue-completion races and feedback sampling relative to motion update; avoid promising an instantaneous stop or a hardware-captured contact coordinate.
4. Preserve independent personnel safety, graduated levels, blind evaluator separation and physical-machine HOLD. No compute, test, GitHub Actions or machine operation occurred.

## Evidence ledger
- SOURCE-CONFIRMED: bit encoding, interpreter guards, command admission, sampled state trigger, position latch, abort, unsuccessful completion behavior (three pinned files above).
- INFERENCE / ANALYTICAL: seven case matrix and possible sampling limitations.
- UNKNOWN: complete canonical/Task bridge, real Mesa probe configuration, edge timing/overshoot, tool-setting UI integration and executable behavior.
