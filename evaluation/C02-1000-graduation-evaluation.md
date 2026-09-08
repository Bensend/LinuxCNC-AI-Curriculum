# C02 — 1000-level adversarial, handoff, and graduation evaluation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Course-level objective: trace and verify that two LinuxCNC control loops can share a command while retaining independent feedback, error, plant, and control-output state; recognize observation-stage traps; trace a disabled-loop path; and identify explicit synchronization and safety mechanisms as downstream work rather than implied PID behavior.

The ten prompts were frozen before C02-024 result reconciliation in `evaluation/C02-adversarial-exam-draft.md` at commit `d965ae32911d688556222e42aaf180a53068be7d`.

## Adversarial exam

### Q1 — misleading premise

There is **no stock PID source mechanism** that automatically compares the feedback of two PID instances merely because their command pins receive one shared HAL signal. Each exported PID realtime function is bound to its own `hal_pid_t`; `calc_pid()` has no peer-instance pointer/read. An explicit comparator/cross-coupling architecture would have to be added downstream.

**Score: PASS.**

### Q2 — instance ownership

`loadrt pid names=a,b` causes allocation/export of separate PID instance structures. `export_pid()` creates per-instance pins/state and exports a per-instance realtime function whose argument is that instance. The scheduler/thread period and any HAL signal intentionally connected to both instances can be shared externally; command, feedback, error history, integrator, derivative/history state, gains, saturation state, enable and output are not implicitly shared by the component.

**Score: PASS.**

### Q3 — asymmetric disturbance

With one command feeding both loops but plant B slowed, feedback A/B may diverge; because each PID reads its own feedback, error A/B may diverge; consequently output A/B may diverge. C02-024 observed exactly this under a B-only plant-gain change. That is evidence of independent state paths because no peer-feedback correction appeared; it is not evidence that independent loops are a complete tandem-machine architecture.

**Score: PASS.**

### Q4 — observation-stage trap

No. In the frozen servo order the PID functions calculate using feedback that exists before the plant functions run. Plant A/B then update and `sampler` observes the post-plant state. Therefore sampled same-row `command - post-plant feedback` need not equal the PID error computed earlier in that same servo invocation. The function stage must be modeled before declaring arithmetic failure.

**Score: PASS.**

### Q5 — `error-previous-target` trap

At the pinned revision `error-previous-target` initializes true, so published error may use the previous command target rather than the current command. A current-target arithmetic experiment must explicitly set `a.error-previous-target false` and `b.error-previous-target false` before collecting evidence. C02-024 does this.

**Score: PASS.**

### Q6 — disabled-loop failure path

Pinned source requires a disabled PID instance to reset its integral state and force its output to zero. C02's accepted trace confirmed zero B output in 1,011 realtime rows that also sampled A enabled/B disabled. Forbidden conclusions: this does not prove drive power is removed, hydraulic energy is isolated, a physical actuator cannot move, the mechanism cannot rack, or a safety-rated stop exists.

**Score: PASS.**

### Q7 — diagnostic disagreement modification

Add a realtime diagnostic component or primitive arithmetic path that receives feedback A and B, calculates signed/absolute disagreement, and exports the result; schedule it at a defined point in the servo thread and sample its inputs/result in the same realtime domain. Do not feed the diagnostic result into either PID yet. For safety-rated anti-racking, this still lacks hazard analysis, validated limits/timing, independent safety architecture as required, fault coverage, actuator-energy isolation, diagnostics, and validation to the applicable machinery-safety requirements.

**Score: PASS.**

### Q8 — following-error confusion

A joint following-error stop compares that joint's commanded and reported motion state according to motion's following-error rules. It can detect that a joint is not tracking its own command. That is not the same mechanism as PID A reading PID B feedback and correcting relative A/B alignment; C02 source shows no such stock peer comparison. A following-error trip can be useful fault evidence without becoming cross-coupling evidence.

**Score: PASS.**

### Q9 — topology failure

If both `pid.feedback` pins are tied to one HAL signal, the experiment no longer proves **independent feedback paths**, even if two PID names/structures still exist. Acceptance requires topology evidence showing separate plant outputs/signals drive separate feedback pins, separate PID outputs drive separate plants, and the B-only disturbance is applied only to B. Runtime names alone are insufficient.

**Score: PASS.**

### Q10 — transfer scenario

With equal software commands and independent encoders, a frozen B encoder can cause B's computed feedback/error/output behavior to differ from A. C01/C02 allow us to infer only that command equality does not guarantee feedback/physical equality and that independent loop state can diverge. We cannot infer actual ram alignment, sensor correctness, actuator response, safe continuation, or the correct trip/correction strategy. C03 or another explicitly designed synchronization/disagreement mechanism must decide whether/how relative error changes control or triggers a fault; safety authority remains separate.

**Score: PASS.**

**Adversarial result: 10/10.**

## Experiment-driven corrections incorporated

1. Attempt 1 mixed userspace enable-state observation with realtime output evidence. It was classified harness-invalid rather than used to contradict pinned PID disable behavior.
2. Enable A/B were moved into the same realtime sampler row as outputs without changing frozen gates/thresholds.
3. A passing correction still failed the durable-evidence requirement because raw files were copied outside the workflow artifact path. It was not accepted merely because the summary said PASS.
4. A publication-only rerun retained the complete raw trace under `lab-results/c02-024-evidence/`; workflow `34225190610`, job `102057466102`, artifact `10055529544` is the accepted C02-024 evidence.
5. The guide explicitly preserves the servo-stage distinction and the pinned `error-previous-target` default trap.

## Fresh-AI handoff — novel scenario

**Scenario:** A new simulation keeps the same shared command and separate PID/plant paths, but encoder/feedback B is altered by a scale factor of `1.02` while physical/simulated plant B otherwise follows the same dynamics as A. A developer sees increasing A/B position disagreement and proposes subtracting `feedback_B` directly from PID-A's command as a quick synchronization fix.

**Expected fresh-AI reasoning:**

1. C02 predicts the scaled B feedback can create different measured error and therefore different B control effort even though the command is shared.
2. The observation must distinguish true plant displacement from a feedback-scale fault; disagreement alone does not identify which side/sensor is correct.
3. Feeding B disagreement into A changes the topology from independent loops to explicit cross-coupling and therefore moves into C03; C02 evidence cannot establish stability or correctness of that modification.
4. Before cross-coupling, define the synchronization objective, sign convention, observation stage, authority/limits, saturation behavior, and failure response.
5. A feedback-scale fault can make a controller drive a mechanically aligned plant out of alignment if a cross-coupler trusts the faulty signal, so sensor fault assumptions matter.
6. No software result here establishes safety-rated protection or the correct physical-machine response.

**Handoff result: PASS.** This scenario is not answered verbatim by the C02 guide and requires applying independent-state, sensor-truth, topology-change, observation-domain, and safety boundaries.

## Higher-level promotion / uncertainty queue

| Item | Current evidence | Destination | Priority | Blocks C02 graduation? | Why promotion is safe |
|---|---|---|---|---|---|
| Explicit relative-position cross-coupling law and tuning | C02 proves independence only | C03 / 1000 sequence | critical | No | C02's central claim is precisely the absence of implicit cross-coupling; C03 adds it explicitly. |
| Cross-coupler behavior under sensor scale/freeze/jump faults | Novel handoff identifies risk; not yet tested | C03/C05 | high | No | Unexpected behavior would affect the downstream design, not the verified independence of stock PID loops. |
| Joint following-error interaction with two independently simulated plants | Source background exists; not part of accepted C02 fixture | C04/C05 | high | No | C02 does not use following error as proof of peer synchronization. |
| Physical dual-actuator/hydraulic load sharing and mechanical racking | No physical plant in public curriculum fixture | capstone hardware validation | critical | No | No physical synchronization claim is used to graduate C02. |
| Safety-rated disagreement detection / energy isolation | Outside stock PID function | safety architecture / capstone | critical | No | C02 explicitly forbids equating PID behavior with safety authority. |
| Other LinuxCNC revisions / changed PID defaults | Source/test pinned to one SHA; current docs corroborate | 2000/version review | medium | No | All verified behavioral claims are revision-scoped. |
| Quantitative meaning of small baseline post-plant A/B sample offset | Explained by staged sequential plant execution; not used as the core oracle | 2000/realtime fixture analysis | low | No | Main independence evidence is source topology plus controlled 0.6499 disturbance and separate paths. |

## Counterfactual promotion test

If every promoted item behaved differently from current expectation, would a central C02 teaching become wrong, make C03's prerequisite unreliable, invalidate the accepted evidence chain, or materially change an important safety boundary?

**No.** C02 teaches a deliberately narrow negative/structural fact: two stock PID/plant paths remain independently stateful despite a shared command, and no implicit peer synchronization/safety function follows. A different optimal cross-coupler, sensor-fault response, physical hydraulic interaction, or safety architecture would change downstream engineering but not the pinned source topology or accepted asymmetric-disturbance observation. The safety boundary would remain conservative.

## Minimum graduation evidence floor

- [x] Core PID/plant independent-instance mechanism identified and traced from pinned source.
- [x] Shared-command -> PID A/B -> separate plant A/B -> separate feedback A/B path traced end-to-end.
- [x] Independent runtime verification completed with retained C02-024 evidence.
- [x] Representative failure/invalid paths understood: B disturbance, B disable, mixed-domain oracle defect, publication defect.
- [x] Prediction frozen before behavioral evidence.
- [x] Fresh-AI novel-scenario handoff passed.
- [x] No promoted item can overturn the shared-command/independent-state teaching.
- [x] No promoted item invalidates C03's prerequisite.
- [x] Evidence chain remains valid under promoted uncertainty.
- [x] Safety/reliability boundary remains explicit and conservative.
- [x] Every promoted item states why promotion is safe.

## Graduation evidence audit

- [x] 1000-level scope explicit.
- [x] Official documentation reviewed.
- [x] Community configurations/failure reports reviewed as non-normative leads.
- [x] Source inventory and significant PID/integ symbols traced.
- [x] Important call flow documented.
- [x] Claims/source/runtime evidence reconciled.
- [x] Reproducible frozen-gate experiment completed with durable raw evidence.
- [x] Similar failures were corrected rather than thresholds weakened; no three-attempt unresolved behavioral failure remains.
- [x] Failure modes documented.
- [x] Prediction check passed.
- [x] Adversarial exam passed 10/10.
- [x] Corrections incorporated.
- [x] Fresh-AI novel handoff passed.
- [x] Promotion queue and counterfactual test passed.

## Graduation sufficiency decision

**C02 GRADUATED at 1000 level.**

The evidence is sufficient to use independent dual-loop behavior as a prerequisite for C03. C02 does not claim a cross-coupling law, real-machine synchronization, hydraulic/mechanical validity, or safety-rated anti-racking. Those remain explicit downstream responsibilities rather than hidden assumptions.
