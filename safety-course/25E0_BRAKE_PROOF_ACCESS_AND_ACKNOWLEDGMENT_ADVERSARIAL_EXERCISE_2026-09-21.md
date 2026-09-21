# 25E0 Adversarial Exercise — Brake Proof, Access, and Acknowledgment

## Scenario

A vertical-axis machine has two retaining brakes. Its safety architecture requires a brake proof before guarded personnel access after maintenance. The proof routine challenges each applied brake separately with configured motor torque and checks measured axis movement against an acceptance tolerance.

After maintenance:

1. Brake 1 passes.
2. Brake 2 fails because measured movement exceeds the allowed tolerance.
3. The drive enters its documented safe reaction and reports the brake-test fault.
4. A technician adjusts Brake 2 until its mechanical problem appears corrected.
5. The brake-test fault can now be acknowledged through the documented safety-option procedure.
6. The guard is still locked.
7. The ordinary controller's `cycle-start` input has remained physically TRUE since before the failed test.
8. The axis speed currently reads zero.

The technician proposes: "The brake problem is fixed, the safety error is acknowledged, speed is zero, and the guard is still locked. We can mark the brake proof good, unlock for access, then relock and let the held Cycle Start resume production."

## Required reasoning

A correct answer must reject the proposal and separate the evidence classes.

### 1. What did the failed proof establish?

It established that Brake 2 did not satisfy the configured challenge/response acceptance criterion during that test. The later mechanical adjustment does not retroactively turn that failed test into a pass.

### 2. What does acknowledgment establish?

Only the authority documented for the actual implementation: the safety-option error has been dispositioned sufficiently for the function to leave its fault handling path. **Acknowledgment is not a substitute for a successful physical proof.** If the application requires a positive proof before access, a valid new proof is required after the repair/adjustment.

### 3. What does zero speed establish?

Only the authority of the actual speed witness at that instant. It does not prove brake holding capability, future retention of a gravity load, absence of stored energy, guard/access safety, or a fresh production demand.

### 4. May the guard be unlocked merely because the fault was acknowledged?

No. In the stated architecture, access is conditioned on a positive brake proof. Fault acknowledgment and positive proof are different state transitions.

### 5. May the held Cycle Start resume automatically after the proof/access sequence?

Not by inference. Demand freshness is a separate ordinary-control property. A robust design should cancel/invalidate the pre-maintenance production request and require a deliberate fresh Start after the machine has completed the full return-to-production sequence. Safety reset/rearm must not itself become the production Start command.

### 6. What remains machine-specific?

The required proof torque, motion tolerance, proof interval, exact brake sequencing, whether both brakes must pass before access, required guarding during the test, stopping/retention mechanics, safe reset implementation, and the relationship between ordinary motion control and independent safety authority all require design-specific evidence.

## Misleading premise

"The fault is gone" is intentionally ambiguous. Cause corrected, diagnostic cleared, safety fault acknowledged, proof passed, safety rearmed, access authorized, and production start authorized are distinct claims.

## Freshness check

For every return path, explicitly ask:

- Was an ordinary demand already asserted before the invalid state?
- Is it edge-, level-, latched-, queued-, tracked-, cancelled-, or regenerated-demand logic?
- What event invalidates the old request?
- What deliberate post-rearm action creates a fresh production request?

## Grading target

Pass only if the learner keeps **physical proof**, **instantaneous motion witness**, **fault acknowledgment**, **access permission**, **safety rearm**, and **ordinary production demand** as distinct authority classes and refuses to infer unproven machine-specific thresholds or sequencing.
