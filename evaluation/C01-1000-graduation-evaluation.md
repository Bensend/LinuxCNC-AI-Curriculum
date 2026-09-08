# C01 1000-level adversarial, handoff, and graduation evaluation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Course-level objective

A graduating learner must be able to explain and trace how a duplicated coordinate is represented by `trivkins`, distinguish world-coordinate command fan-out from independent joint/plant synchronization, configure a four-joint simulated duplicated-Y fixture, select a valid observation domain for a simultaneous invariant, and identify which stronger synchronization/safety questions belong downstream.

## Adversarial exam

### 1. Misleading premise

**Prompt:** "Joint 1 and joint 3 have the same Y coordinate in `trivkins`, so LinuxCNC automatically checks that their feedback stays aligned. Where is that check?"

**Answer:** The premise is false. The C01 source trace shows duplicated inverse kinematics fans one world-Y command to both joint coordinates. The tested ideal loopbacks make their simulated feedback equal by wiring, not because `trivkins` implements an anti-racking comparator. Independent disagreement detection belongs in downstream feedback/control logic.

**Score:** PASS.

### 2. Source-navigation question

**Prompt:** What source-level mechanism explains why both duplicated Y joints receive the same coordinated command?

**Answer:** Pinned `trivkins` parses the coordinate map and inverse kinematics assigns the relevant Cartesian coordinate (`pos->tran.y`) to each joint whose coordinate-map entry is Y. The same inverse call therefore emits one Y value into both duplicated joint slots.

**Score:** PASS.

### 3. Failure/evidence-path trace

**Prompt:** During motion, four sequential `hal.get_value()` calls show joint 1 and joint 3 differ by exactly one servo-period worth of distance. Is duplicated kinematics disproven?

**Answer:** No. A simultaneous invariant cannot be tested by sequential userspace reads while realtime state changes between calls. Attempt 1 demonstrated exactly this failure mode. The valid response is HARNESS INVALID unless the observation skew is bounded by the requirement. C01 corrected the oracle to a realtime `sampler` row scheduled after `motion-controller` and retained the frozen tolerance.

**Score:** PASS.

### 4. Version-sensitive question

**Prompt:** Can the course claim this behavior for every LinuxCNC release?

**Answer:** No. The verified claim is scoped to pinned revision `8bf4605...`; current official documentation is corroborative but does not replace source/version scope. Other revisions require review if behavior or configuration semantics matter.

**Score:** PASS.

### 5. Small configuration change task

**Prompt:** Add direct same-cycle observation of the two duplicated command signals without changing the motion behavior.

**Answer:** Load `sampler` with float channels, attach joint 1 and joint 3 command signals to separate sampler pins, schedule `sampler.0` after `motion-controller` in `servo-thread`, drain the FIFO with `halsampler`, reject overruns/discontinuities, and compare values within each row. Do not widen the equality tolerance to accommodate sequential userspace reads.

**Score:** PASS.

### 6. Ambiguous evidence

**Prompt:** A GUI world-Y display reaches 5.000 and in-position becomes true. Does that prove joint 3 moved five inches?

**Answer:** No. That proves the controller's world-coordinate/status path reached the target. Gate G specifically requires direct joint-3 evidence and forbids substituting world Y for joint 3.

**Score:** PASS.

### 7. Safety boundary

**Prompt:** If the two software command signals match exactly for every servo sample, may a press-brake designer omit independent ram-position comparison?

**Answer:** No. Equal software commands establish neither independent encoder agreement nor physical alignment, hydraulic response, or a safety-rated protective function.

**Score:** PASS.

### 8. Community warning interpretation

**Prompt:** Why can duplicated-coordinate gantry joints still rack in joint mode even though coordinated commands fan out equally?

**Answer:** Joint mode can address joints independently; coordinated world-coordinate fan-out is not a global invariant across every operating mode. That is precisely why homing/joint-mode behavior and physical anti-racking safeguards must be reasoned about separately.

**Score:** PASS.

### 9. Experiment-integrity question

**Prompt:** The first corrected harness had a shell variable typo and exited before runtime. Should it count as evidence against LinuxCNC?

**Answer:** No. It is a preserved HARNESS INVALID preflight. Its compute counts, but it supplies no behavioral verdict.

**Score:** PASS.

### 10. Workflow-versus-artifact question

**Prompt:** The accepted workflow is red, yet the artifact has inner exit code zero. Which is authoritative?

**Answer:** For the experiment, the published lab artifact is authoritative because it preserves the inner process exit code and raw outputs. The workflow's later repository-commit step failed because concurrent curriculum commits moved `main`; that post-lab publication race does not change the completed lab behavior.

**Score:** PASS.

**Adversarial result: 10/10.**

## Fresh-AI handoff novel scenario

**Scenario:** A fresh engineer changes the simulation so joint 3 feedback comes from a separate simulated plant component that intentionally lags joint 1 by 8 ms. `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` remain equal in every same-cycle sampler row. The engineer claims C01 proves synchronization is still correct.

**Expected reasoning:**

1. C01's core mechanism still holds: duplicated coordinated commands can remain identical.
2. The new separate plant feedback invalidates the old Gate-F loopback assumption but does not invalidate the command-fanout result.
3. Synchronization must now be evaluated from independent feedback with a defined common-time/skew requirement.
4. An 8 ms physical/simulated plant lag can matter even when software commands are equal.
5. This is a C02-level feedback/disagreement problem, not evidence that `trivkins` changed.
6. Safety conclusions still require an independent safety analysis and appropriate hardware architecture.

**Handoff result:** PASS. The scenario is not answered verbatim by the original guide and requires applying the observation-domain and command-versus-plant distinctions.

## Corrections incorporated

C01 originally used sequential userspace HAL reads as though they formed a simultaneous snapshot. Attempt 1 produced a 0.001-inch artifact equal to one servo tick. The course corrected this by documenting the simultaneous-observation boundary and using realtime `sampler` capture after `motion-controller`. The frozen `1e-9` threshold was retained. A later shell-typo preflight was preserved as harness-invalid rather than hidden.

## Promotion / uncertainty queue

| Item | Current evidence | Destination | Priority | Blocks graduation? | Why safe to promote |
|---|---|---|---|---|---|
| Independent dual feedback and disagreement monitoring | C01 has only ideal per-joint HAL loopbacks | C02 / 1000 sequence | high | No | C01 explicitly teaches only command fan-out; downstream plant evidence is not used to justify the fan-out claim. |
| Following-error and synchronization fault response | Not implemented in C01 | C02/C03 | high | No | C01 makes no claim that duplicated kinematics detects misalignment. |
| Homing/squaring behavior for a physical dual-actuator machine | Docs/community warn about independent joint motion; no physical fixture | C03 and later hardware work | high | No | Command-fanout evidence remains valid and safety boundary explicitly says homing/squaring is separate. |
| Physical hydraulic interaction/load sharing | No physical hydraulic plant | capstone/hardware validation | high | No | No hydraulic behavior is taught as C01-confirmed. |
| Safety-rated anti-racking architecture | Outside C01 software-kinematics scope | capstone safety architecture | critical | No | C01 explicitly forbids treating command equality as safety evidence. |
| Behavior on revisions other than pinned SHA | Current docs corroborate concept; source/test pinned | 2000/version review | medium | No | Every C01 source/test claim carries explicit revision scope. |

## Counterfactual promotion test

If every promoted item behaved differently from current expectation, would a central C01 teaching become wrong, a downstream prerequisite become unreliable, the evidence chain become invalid, or an important safety boundary materially change?

**No.** The central C01 teaching is deliberately narrow: duplicated-coordinate kinematics can fan one coordinated command into distinct joint command interfaces, and software command equality is not independent plant/safety evidence. Unexpected plant lag, homing behavior, hydraulic coupling, or safety implementation would reinforce the need for the boundary rather than overturn the observed fan-out mechanism.

## Minimum graduation evidence floor

- [x] Core mechanism identified and traced from pinned source.
- [x] World-coordinate to duplicated-joint execution path documented.
- [x] Independent runtime verification completed with C01-023.
- [x] Invalid observation path understood through attempt 1.
- [x] Prediction frozen before confirming runtime evidence.
- [x] Fresh-AI novel-scenario handoff passed.
- [x] No promoted item can overturn the central command-fanout teaching.
- [x] No promoted item invalidates the downstream prerequisite: C02 must add independent feedback/plant reasoning.
- [x] Evidence chain remains valid under promoted uncertainty.
- [x] Safety boundary is explicit and conservative.
- [x] Every promoted item explains why promotion is safe.

## Graduation sufficiency decision

**C01 GRADUATED at 1000 level.**

The module meets the source, documentation/community, call-flow, prediction, runtime verification, invalid-path, adversarial, correction, fresh-AI handoff, promotion, and counterfactual requirements. The invalid attempt materially improved the course by revealing the observation-domain requirement. Physical synchronization and anti-racking are intentionally not claimed; they become explicit downstream work rather than hidden assumptions.
