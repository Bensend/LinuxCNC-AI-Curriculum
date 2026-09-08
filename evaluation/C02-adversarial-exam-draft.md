# C02 — adversarial exam draft

Status: **QUESTIONS FROZEN BEFORE C02-024 RESULT RECONCILIATION; NOT YET SCORED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

These questions are frozen now so the final evaluation cannot be tailored to whichever runtime result is observed.

## Q1 — misleading premise

Two PID instances receive the same position command. Therefore LinuxCNC will automatically compare their feedback values and correct whichever side falls behind. Identify the source mechanism that performs this comparison.

## Q2 — instance ownership

Trace how `loadrt pid names=a,b` results in separate runtime state and separate realtime functions. What data is shared, and what is not shared, by stock PID instances?

## Q3 — asymmetric disturbance

PID A and PID B receive one named shared command. Plant B is slowed while plant A is unchanged. Predict which signals may diverge and explain why this is evidence of independent loops rather than cross-coupled synchronization.

## Q4 — observation-stage trap

The servo order is PID A, PID B, plant A, plant B, sampler. A sampled row shows `command - feedback_A != pid_A.error`. Does that automatically falsify PID arithmetic? Explain the timing relationship that must be checked first.

## Q5 — `error-previous-target` version/configuration trap

At the pinned revision, a newly exported PID instance has `error-previous-target=true`. How can this change the meaning of `pid.error`, and what exact fixture setting is required if an experiment intends to reason about current `command - feedback`?

## Q6 — disabled-loop failure path

Only PID B is disabled. What does pinned source require for B's integrator and output? What conclusions are forbidden about physical actuator isolation and machine safety?

## Q7 — configuration modification

Starting from two independent loops, add a purely diagnostic same-cycle disagreement signal without yet changing either PID's control output. Specify a valid HAL/realtime observation architecture and explain what would still be missing for a safety-rated anti-racking function.

## Q8 — following-error confusion

A later machine fixture feeds the disturbed plant feedback into LinuxCNC joint feedback and motion aborts on following error. Why is it incorrect to describe that stop as proof that the two PID loops perform peer synchronization?

## Q9 — failure of independence proof

The two `pid.feedback` pins are accidentally tied to one HAL signal, but two differently named PID instances still exist. Which C02 claim becomes unproven, and what topology evidence is required before accepting the experiment?

## Q10 — transfer scenario

A two-side machine has equal software command signals and two independent encoders. Encoder B freezes while encoder A continues normally. Both PID loops keep computing. Using only C01/C02 boundaries, state what can be inferred, what cannot be inferred, and which downstream mechanism must decide whether/how to cross-couple or trip.

## Scoring requirements

A passing 1000-level answer set must distinguish source-confirmed PID instance behavior from fixture topology, respect the realtime observation stage, reject the shared-command-implies-synchronization premise, trace the disabled-loop path, and preserve the safety boundary. Final scoring must occur only after C02-024 is reconciled and any experiment-driven corrections are incorporated.
