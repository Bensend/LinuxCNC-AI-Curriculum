# D01 adversarial exam — coupled-control stability and tandem-joint authority

Status: **FROZEN BEFORE AUTHORITATIVE RESULT REVIEW**

Pinned LinuxCNC revision for source-specific questions: `8bf4605ae81042248add031e94c77300406e0413`.

Do not weaken these questions after seeing the authoritative D01 artifact. Grade mechanism, evidence discipline, and safety boundaries rather than vocabulary.

## Questions

1. A duplicated-Y `trivkins coordinates=XYY` machine reports Cartesian Y = 10.000. Joint 1 feedback is 10.000 and joint 2 feedback is 10.020. Is Cartesian Y evidence that the tandem geometry is aligned? Explain the exact kinematic authority boundary.

2. Trace the significant servo-cycle path from per-joint feedback acquisition through following-error evaluation, forward-kinematics publication, and machine-wide fault consequence. Identify why ordering matters when interpreting one sampled row.

3. Misleading premise: "Because inverse kinematics sends the same Y command to both duplicated joints, a separate cross-axis/tandem disagreement monitor is redundant." Accept or reject, and justify from source/runtime behavior.

4. A duplicate joint is offset by less than its instantaneous following-error limit while the principal joint is correct. Predict what can simultaneously be true about duplicate ferror, duplicate fault state, Cartesian Y, and motion authority. State what evidence would discriminate the mechanism.

5. A duplicate joint crosses its following-error threshold while the principal joint remains clean. What LinuxCNC software consequence is expected, and what does that consequence *not* prove about physical stopping, squareness, or functional safety?

6. Debugging scenario: a userspace script executes `halcmd getp joint.1.motor-pos-fb`, then `halcmd getp joint.2.motor-pos-fb`, then `halcmd getp axis.y.pos-fb` and observes agreement. Why is this insufficient evidence for same-cycle tandem agreement? Propose the minimum stronger recorder arrangement.

7. Recorder adversary: `halsampler` tags are contiguous, but `sampler.0.overruns` is nonzero. May the trace be used as proof that no realtime samples were lost? Explain.

8. Restart scenario: after a duplicate-only feedback fault disables motion, the injected offset is cleared and both software feedback values agree again. Is that equivalent to restored physical geometry and fresh motion authorization? Separate cause-clear, software state, physical truth, and explicit reauthorization.

9. Version-sensitive reasoning: a newer LinuxCNC revision changes duplicated-coordinate forward kinematics to average duplicate feedback instead of selecting the principal mapping. Which D01 conclusions survive unchanged, which must be reverified, and why must the pinned-revision claim not silently transfer?

10. Bounded modification task: design a minimal realtime tandem-disagreement monitor for a generic duplicated-axis simulation. Specify inputs, computation, threshold/debounce behavior, output/fault interface, realtime placement, atomic evidence signals, and at least two failure modes or assumptions. Do not claim the monitor is safety-rated. Explain whether it should consume commanded position, measured feedback, or both and why.

## Required grading dimensions

Score each question 0–2: 0 incorrect/unsafe, 1 partially correct or missing an important boundary, 2 source/evidence-grounded and correctly bounded. Total 20.

Mandatory traps that must be rejected for a passing exam:

- Cartesian coordinate feedback authenticates duplicate-joint agreement;
- equal duplicated commands imply equal physical motion;
- homing/squaring establishes continuous runtime geometry truth;
- sequential userspace reads are atomic same-cycle evidence;
- contiguous consumer tags prove no producer loss;
- following-error shutdown proves a safety-rated stop;
- clearing a software/simulated cause proves physical safe restart;
- behavior from one LinuxCNC revision transfers silently to another.

Passing target: at least 18/20 with no mandatory trap accepted. Any safety-boundary miss requires correction before D01 graduation.
