# MILL-269 — G38 probe admission and realtime state machine (LinuxCNC v2.9.10)

**Scope:** 3100 mill probing; source-confirmed, non-graduated, no runtime test. Date 2026-11-06. This is a source-first partial trace, **not** a claim of validation on a real mill. Read [HM2-268 checkpoint](../checkpoints/20261106T2132Z-4000-hm2-268-next.md) first for rotation rationale.

## Immutable version scope and inspected symbols
- [v2.9.10 interpreter `convert_probe`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3893-L3941): `probe_type = g_code - G_38_2`; cutter compensation, zero feed, feed/rev and (for error-reporting variants) zero-displacement guards; `STRAIGHT_PROBE` canonical call and `probe_flag`.
- [v2.9.10 motion command `EMCMOT_PROBE`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1413-L1479): coordinated/enabled, range and limit gates; initial contact-state gate conditional on bit 0; TP line admission.
- [v2.9.10 servo `process_probe_inputs`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L678-L721): read `motion.probe-input`, stop/record on target state, or mark failure at completed move.
- [v2.9.10 G38 documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/g-code.adoc#L1229-L1295): probe polarity, variants, #5061..#5069 and #5070 reporting. These tag links are revision-addressed but the tag-to-commit SHA was **not independently resolved** in this session; do not call them immutable blob hashes.

## End-to-end mechanism (source-confirmed within the inspected boundaries)
G38.2 and G38.3 seek probe input TRUE (contact); G38.4 and G38.5 seek FALSE (clear). `convert_probe` encodes the four forms into bit flags: 0 = .2, 1 = .3, 2 = .4, 3 = .5. Bit 0 suppresses a failure error; bit 1 reverses the target state. The interpreter calls `STRAIGHT_PROBE`, but the intervening canonical/Task-to-motion bridge has **not yet been inspected** here.

At motion command admission, coordinated mode, enable, range and limits are checked. Crucially, **the initial-state guard runs only when bit 0 is clear**: G38.2 rejects a probe already TRUE, G38.4 rejects a probe already FALSE. G38.3/G38.5 skip this guard. This is a meaningful asymmetry: do not teach that all four variants reject a wrong initial probe state. The motion controller then queues a probe line and sets `probing=1`.

Each servo cycle, `process_probe_inputs` samples `motion.probe-input`. While probing, `probeVal XOR probe_whenclears` indicates target state reached; it records `carte_pos_fb` as `probedPos`, sets `probeTripped=1`, clears probing and aborts TP. If motion finishes without target state, it records the final feedback position; suppressed variants set `probeTripped=0`, while error variants report a motion error. This is servo-sampled feedback position, **not** proof of exact physical contact location or probe-latency compensation. Documentation states #5070 success/failure and #5061..#5069 coordinates, but their Task/interpreter status transfer remains to be traced.

## Falsifiable worksheet (predictions, not executed observations)
| Case | Initial probe input | G-code variant | Source-derived expectation |
|---|---:|---|---|
| A | FALSE | G38.2 toward target, contact occurs | Command admitted; TRUE sample aborts probe, records feedback, success indication |
| B | FALSE | G38.2, no contact by endpoint | Motion error and failed probe |
| C | TRUE | G38.2 | `EMCMOT_COMMAND_BAD_EXEC` before TP admission |
| D | TRUE | G38.3 | Initial-state check skipped; realtime may observe TRUE and immediately terminate (actual timing needs execution) |
| E | TRUE | G38.4, input later FALSE | Command admitted; FALSE sample aborts probe and records feedback |
| F | FALSE | G38.4 | Initial-state guard rejects before TP admission |
| G | FALSE | G38.5 | Guard skipped; realtime may immediately see FALSE and terminate (execution needed) |
| H | TRUE | G38.5, remains TRUE to endpoint | No motion-error on no-contact-transition; failed status expected |

The source also checks for rising probe input during a non-probe move and may abort it; this is a distinct path, not evidence that G38.3 always behaves like G38.2.

## Minimal non-machine reproduction design (NOT RUN)
Use an isolated LinuxCNC simulator config with a synthetic HAL bit connected to `motion.probe-input`; require actual INI/HAL, kinematics and command acceptance to be pinned before execution. In MDI, use a small feed and short destination within travel limits, start with probe FALSE for G38.2, and toggle the bit from a **separate HAL writer** during the move. Record the commanded line, sampled probe state, motion error, TP queue, `probedPos`, #5070 and #5063. Repeat with wrong initial state and the suppress-error variant. Do not drive a physical machine from this worksheet; a simulated probe signal is not a personnel-safety device.

## Evidence limits / dependency queue
1. **HIGH** Trace `STRAIGHT_PROBE` through canonical/Task and completion to interpreter parameters #5061..#5070; check whether errors prevent parameter update.
2. **HIGH** Pin a public *real mill* INI/HAL and its actual `motion.probe-input` wiring. No real-mill config was verified in this session.
3. **MEDIUM** Inspect upstream probing regression tests and historical lab jobs before calling any new case untested or launching compute.
4. **MEDIUM** Verify initial-state asymmetry and servo timing with a reproducible simulator matrix on approved self-hosted compute only, if evidence gain justifies it.
5. **MEDIUM** Quantify sampling latency and probe coordinate uncertainty separately from nominal motion feedback.

**Classification:** SOURCE-CONFIRMED for cited source branches; DOC-CONFIRMED for documented parameter intent; INFERENCE for unexecuted scenario timing; UNKNOWN for Task bridge, real mill wiring and actual runtime. No promotion or graduation claimed. Existing blind evaluation and independent personnel-safety gates remain unchanged.
