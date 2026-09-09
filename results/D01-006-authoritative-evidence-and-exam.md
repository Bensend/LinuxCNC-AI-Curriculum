# D01-006 — authoritative evidence scoring and adversarial exam

Date: 2026-09-09

## Authoritative run

- workflow: `34375315740`
- job: `102546527680`
- artifact: `10113726545`
- conclusion: PASS
- frozen experiment: `results/D01-002-frozen-runtime-experiment.md`; P0–P8 and Gates A–J were not changed after launch.

The artifact was downloaded and inspected at file level rather than trusting workflow success alone. It contains the 2,200-row atomic sampler trace, observer patch (2076 bytes), pinned LinuxCNC SHA `6e20ea4c50208ae7b04d1aefaecc8f00a576e394`, INI/HAL, topology/thread-order evidence, LinuxCNC logs, collector state, and recorder-health evidence. Producer overruns were zero. Sample tags were contiguous from 0 through 2199.

### Frozen Gates A–J

| Gate | Result | Retained-evidence reason |
|---|---|---|
| A | PASS | Real `motmod + trivkins` duplicated-Y fixture retained; both Y joints command/settle at 10 before injection. |
| B | PASS | One atomic realtime stream contains phase, both Y commands/feedbacks, ferror/limits/fault bits, Cartesian observer, injection and motion-enable state. |
| C | PASS | Phase changes are retained before the corresponding injected mutation, preserving the frozen ordering contract. |
| D | PASS | Low disagreement is 0.020 with 0.050 ferror limit: duplicate joint disagrees while its fault bit remains clear. |
| E | PASS | During low disagreement the principal joint remains clean and the observed Cartesian Y remains principal-looking at 10. |
| F | PASS | High disagreement is 0.200 and produces duplicate-joint ferror/fault while the principal joint remains clean. |
| G | PASS | Cartesian Y remains 10 through the duplicate-side high disagreement/trip, demonstrating the principal-joint authority boundary. |
| H | PASS | Global motion enable revokes within the frozen <=3 servo-sample bound after the duplicate following-error assertion. |
| I | PASS | 2,200 retained rows, monotonic contiguous successful-enqueue tags, zero producer overruns, empty collector stderr. |
| J | PASS | Artifact retains trace, observer source patch, pinned SHA, INI/HAL, topology/order, logs and recorder-health evidence; independent post-download inspection reproduced the discriminators. |

**Authoritative score: 10/10 gates PASS.**

## Frozen adversarial exam execution

The exam in `evaluation/D01-adversarial-exam.md` was frozen before authoritative-result review. Answers below were produced against that frozen prompt.

1. `trivkins` duplicated-coordinate inverse mapping can issue the same Cartesian Y target to both mapped joints, while forward Cartesian Y is represented by the principal/first mapped joint. Therefore command agreement and apparently correct Cartesian feedback do not establish duplicate-side agreement.
2. The low-offset witness proves a joint-level tracking disagreement can exist below the configured following-error trip while Cartesian Y remains principal-looking. It does not prove acceptable physical squareness, stability margin, or safety.
3. The high-offset witness proves the duplicate joint can independently assert following error and revoke global motion even while the principal joint and Cartesian Y appear clean. It does not authenticate physical geometry or stopping performance.
4. Cartesian Y cannot be used as a tandem-agreement oracle because its forward-kinematic authority is not an independent comparison of both duplicated joints.
5. `motion.motion-enabled` is a global controller state/authority signal, not proof of physical actuator energy removal or certified safe state.
6. Homing/squaring establishes a reference relationship at that event; it does not continuously authenticate that the two physical sides remain geometrically aligned afterward.
7. A software disagreement monitor can compare independent joint feedbacks in realtime and revoke ordinary motion authority when a bounded threshold/time rule is violated; its threshold must be derived from plant/control evidence, not copied from this synthetic fixture.
8. The monitor must not consume the test observer or Cartesian Y as its duplicate-side truth source; it should use the independently available per-joint feedback channels and explicit validity/freshness state.
9. Servo-cycle ordering matters: a sampled fault and a later sampled global disable are distinct state transitions. The retained phase/fault/enable stream is needed to bound their separation without inventing atomicity.
10. Sequential `halcmd` reads are insufficient for the timing claim because values can come from different servo cycles.
11. Consumer sample-tag continuity alone is insufficient as a no-loss oracle: rejected producer writes need not create gaps in successful-enqueue tags. Producer-side overrun/full evidence is required.
12. Recorder health is part of the claim boundary. A trace with unbounded producer loss cannot establish the frozen <=3-sample transition claim.
13. The observer is instrumentation only: it copies `carte_pos_fb.tran.y` at a pinned point after forward kinematics and is not consumed by control. Conclusions depending on its placement remain pinned-version conclusions.
14. The source/runtime result must not be generalized across LinuxCNC versions without checking the relevant kinematics and motion update-order source or reproducing the fixture.
15. Request, achieved joint state, Cartesian representation and physical truth are separate authority domains; equality in one domain cannot silently substitute for another.
16. A common-cause feedback error can make two software feedback channels agree while physical geometry is wrong; D01 does not solve that and hands it to S02.
17. Loss of one feedback channel must not be converted into stale authorization. A disagreement monitor needs explicit validity/freshness semantics and a defined fail response.
18. Restart/re-enable semantics must require re-establishing the controller's prerequisites; clearing a fault bit alone is not evidence that physical tandem alignment or sensor integrity has been restored.
19. The smallest defensible retained evidence for the D01 timing claim is an atomic realtime stream of the causal phase/injection, per-joint tracking/fault state and global enable state, plus producer recorder-health evidence and enough topology/version provenance to interpret it.
20. D01 supports an ordinary LinuxCNC fault-containment contract for modeled per-joint tracking disagreement. It explicitly does not establish functional-safety authority, physical geometry authentication, actuator stopping performance, sensor diversity, or certification.

### Grading

Score: **20/20**. No predeclared conceptual/safety trap was accepted. No corrective teaching loop is required from this exam.

## Counterfactual / promotion test

Counterfactual: if Cartesian Y had been an aggregate or independently cross-checked representation of both duplicated joints, the low/high disagreement experiment would not have established the observed principal-looking Cartesian boundary; D01 would need a different authority model. The pinned source/runtime evidence instead supports the principal-authority interpretation for this revision.

Promotion result: D01 exposes a real prerequisite for S02—software per-joint agreement is still not physical truth under common-cause sensing/mechanics. It does **not** justify promoting custom FPGA/driver/distributed-realtime work to 3000. H30 remains only a candidate.

## D01 disposition

D01 is ready to graduate at 2000 level subject to course-state update. The next dependency-graph work is S02 feedback integrity/diversity/common-cause reasoning; F02 remains blocked by S02, E20 and X02.
