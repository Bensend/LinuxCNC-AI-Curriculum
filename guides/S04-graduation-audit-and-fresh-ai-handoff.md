# S04 graduation audit and fresh-AI handoff

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Status: **GRADUATED** after accepted experiment `34127182365`

## Core competency

A fresh AI engineer must distinguish **position disagreement** from **measurement freshness**.

For the representative ordinary active-joint path, LinuxCNC following-error logic compares commanded and feedback position. If feedback freezes while command continues moving, mismatch can grow beyond the velocity-dependent runtime following-error limit, after which the source-traced fault path can set following-error/joint error and remove ordinary motion/joint enabling intent. But if both command and feedback remain equal while genuinely stationary, a numerically frozen feedback value can remain indistinguishable from a fresh but unchanged measurement unless another freshness/process signal exists.

Do not compress this into “LinuxCNC detects frozen encoders.” That statement is false without conditions.

## Source-level handoff

At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, the representative path documented in `call-flows/S04-frozen-feedback-to-following-error.md` is:

1. `process_inputs()` samples `joint.N.motor-pos-fb` and forms the feedback position used by motion.
2. It computes following error from commanded versus feedback position and derives the velocity-dependent runtime `ferror_limit` bounded by the configured following-error parameters.
3. When the absolute mismatch exceeds the limit, the joint following-error flag is asserted.
4. `check_for_faults()` turns that condition into joint error and clears enabling intent.
5. `set_operating_mode()` applies the disabled motion/joint state.
6. `output_to_hal()` publishes observables including `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

Important exceptions remain part of the competency: the homing index-search transition can substitute command position around index handling, and homed extra joints can force following error to zero. The ordinary equation/path is therefore not universal for all joints in all states.

## Independent evidence handoff

Accepted experiment: `experiments/S04-014-accepted-result.md`, workflow `34127182365`, lab exit code `0`.

The experiment deliberately tests both sides of the identifiability boundary in one runtime:

- **Stationary frozen control:** feedback frozen equal to command for 600 sampled servo cycles; no strict over-limit comparator, no following-error flag, no joint error, no motion disable, no amp-disable, zero sampler overruns.
- **Moving frozen fault:** healthy moving baseline, feedback frozen at a held value, stock realtime comparator proves strict `abs(f-error) > f-error-lim`, following-error diagnostic occurs, joint/motion ordinary enable state is removed, zero sampler overruns.

The runtime following-error limit—not a hand-computed estimate—is the experiment oracle. Rounded textual snapshots are insufficient to prove a strict transition; this was demonstrated by `text_crossed=0` while the realtime comparator recorded `rt_crossed=1`.

## Adversarial exam audit

`exams/S04-adversarial-exam-and-answer-key.md` was re-audited after the accepted experiment.

- Q1 source chain remains correct and appropriately bounded to the ordinary active-joint case.
- Q2 is directly TEST-CONFIRMED by the 600-cycle stationary frozen control.
- Q3's warning about rounded textual snapshots is directly TEST-CONFIRMED by the accepted moving run.
- Q4 correctly separates fault detection from later disable/state publication.
- Q5 preserves special-state exceptions and prevents a universalized formula.
- Q6 correctly treats source order, internal flags and experiment results as revision-specific.
- Q7 keeps scaling, execution delay and frozen feedback as competing hypotheses rather than symptom aliases.
- Q8 is appropriately limited to ordinary diagnostics, not safety-rated coverage.
- Q9 correctly rejects the inference from LinuxCNC software disable to validated physical STO or emergency stop.
- Q10 correctly hands disagreement/redundancy monitoring to S05 and fault-injection methodology to S06.

No correction to the answer key was required after the accepted experiment. The experiment instead strengthened Q2/Q3 by directly reproducing them.

## Fresh-AI novel scenario test

### Scenario

A dual-channel position system is stationary at 125.000 mm. Channel A reports exactly 125.000 for 2 seconds and provides no heartbeat, timestamp, sequence counter, or link-health metadata. Channel B also reports exactly 125.000 for 2 seconds, but a device-owned monotonic sample counter embedded in the same received frame advances every cycle. The controller commands zero velocity during the entire interval. At the end of the interval, the controller commands motion and A immediately begins changing while B continues changing and its counter continues advancing.

Question: what can a fresh AI infer before and after motion begins, and what may it not infer?

### Required reasoning

**Before motion begins:**

- A's constant numerical value is compatible with both a healthy stationary sensor and a sensor frozen at the correct value. Without independent freshness/process evidence, A freshness is **unidentifiable** from position alone.
- B has stronger ordinary diagnostic evidence of freshness because the device-owned counter advances in the same received sample path. That conclusion is still conditional on the counter's generation/transport semantics being understood; a host-generated counter unrelated to device acquisition would not prove the same thing.
- A and B agreeing numerically does not prove either sensor is independently fresh, because common frozen values are possible.
- None of this establishes safety-rated diagnostic coverage.

**After motion begins:**

- A's changing value is evidence that A is no longer numerically frozen during the observed interval, but it does not retroactively prove that every prior stationary sample was fresh.
- B's changing position plus continuing device counter strengthens ordinary freshness evidence for B during motion.
- If one channel later stops changing while meaningful motion is expected and the other continues, that becomes a disagreement/freshness diagnostic lead, but thresholds, persistence, common-cause failure and fault response belong to S05/S06.

### Result

**PASS.** The scenario is not answered verbatim by the source call flow yet can be solved from the S04 distinction between mismatch and freshness. It also avoids inventing a safety claim and identifies the correct downstream module boundary.

## Representative failure behavior

Failure case: feedback freezes during commanded motion. Detection is conditional: once command/feedback mismatch strictly exceeds the runtime following-error limit, LinuxCNC can assert following error, create joint error and remove ordinary motion/joint enable. Externally visible evidence includes the following-error/error and enable outputs listed above.

Counterexample: feedback freezes while command remains equal and stationary. Ordinary following-error logic may not detect it at all. Stronger freshness evidence must come from another mechanism such as device-owned sequence/timestamp/heartbeat information, cross-channel/process plausibility, or other diagnostics.

## Safety boundary

S04 establishes ordinary LinuxCNC diagnostic/control-state behavior. It does not establish physical torque removal, safe stopping time/distance, STO integrity, contactor state, encoder diagnostic coverage, PL/SIL/category, or validation of a complete machine safety function.

## Higher-level promotion / uncertainty queue

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks S04? | Why promotion is safe |
|---|---|---|---|---|---|---|---|
| Device-specific encoder heartbeat/timestamp/sequence semantics | Not generalized; depends on hardware/protocol | Hardware-specific | Changes strength of freshness evidence for that device, not S04's mismatch/freshness distinction | 2000 | HIGH | No | S04 explicitly teaches that stronger freshness claims require understanding the independent mechanism |
| False-positive/false-negative tradeoffs for zero/low-speed frozen-sensor diagnostics | Conceptual only | Requires chosen process/sensor/noise model | Affects design quality of a future diagnostic, not the tested following-error mechanism | S05/S06/2000 | HIGH | No | S04 makes no universal threshold recommendation |
| Safety-rated diagnostic coverage of redundant encoders | Outside ordinary LinuxCNC software evidence | Requires safety architecture, hardware and validation evidence | Could alter a machine safety claim | safety engineering / later specialized study | CRITICAL | No | S04 explicitly makes no safety-rated diagnostic claim |
| Special homing/extra-joint behavior beyond the identified exceptions | Source-located but not exhaustively experimentally covered | Deeper state-specific coverage | Could alter behavior in those states but not the bounded ordinary active-joint teaching | 2000 | MEDIUM | No | Core teaching is explicitly scoped away from universal all-state behavior |

## Counterfactual promotion test

If every promoted item above turned out differently from the current expectation, would a central S04 teaching become wrong, would the downstream prerequisite become unreliable, would the accepted experiment become invalid, or would an important safety/reliability boundary materially change?

**No**, because S04's central claims are deliberately narrower:

- following error is a command/feedback mismatch mechanism;
- unchanged position alone does not prove sample freshness;
- the representative moving-freeze fault path is source-traced and independently reproduced;
- device-specific freshness and safety-rated coverage require separate evidence and are not asserted here.

Therefore the promoted items do not block 1000-level graduation.

## Minimum graduation evidence floor

- [x] Core mechanism identified from pinned source.
- [x] Behaviorally significant frozen-feedback-to-disable execution path traced end-to-end.
- [x] Independent verification exists: accepted same-runtime S04-014 experiment, exit code 0.
- [x] Representative failure behavior understood and observed.
- [x] Predeclared prediction checked against evidence: stationary-frozen no-fault and moving-frozen threshold/fault behavior both matched.
- [x] Fresh-AI competency demonstrated on a novel device-counter scenario.
- [x] No critical uncertainty promoted.
- [x] Every promotion explains why it is safe.

## Graduation decision

**S04 GRADUATED at 1000 level.** The evidence floor is satisfied, the adversarial exam remains correct after experiment reconciliation, the novel handoff scenario passes, the counterfactual promotion test passes, and the remaining uncertainty does not overturn the central mismatch-versus-freshness teaching or the explicit safety boundary.

Next dependency: **S05 — disagreement/redundancy monitoring patterns**.
