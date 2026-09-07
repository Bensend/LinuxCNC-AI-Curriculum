# S01 Lab 011 — Accepted External E-stop Boundary Result

## Scope

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.
Curriculum source commit: `95b81dc06bd70638849529b891597affe3452055`.
Workflow run: `34079407413`, attempt 1.
Job: `lab-jobs/011-s01-external-estop-boundary.sh`.
Artifact digest: `sha256:279a4dc9a537a6b7f236d036b38ae31902deb8a215160b67f38e58e23aa95db1`.
Lab UTC interval: `2026-09-07T03:22:14Z` to `2026-09-07T03:26:29Z`.
Lab exit code: `0`.

## Predeclared prediction

With a normally enabled simulated controller and a sole controlled writer driving the active-low external E-stop input, forcing `iocontrol.0.emc-enable-in` FALSE should cause Task to report ESTOP and motion to become disabled. Releasing the external condition should clear ESTOP but must not automatically restore Machine ON. `iocontrol.0.user-enable-out` was explicitly diagnostic-only because source analysis showed the external-input path does not call `emcAuxEstopOn()`.

## Observation

The fresh artifact identifies the expected source SHA and job. Before injection the signal wiring was:

`or2.0.out -> s01-external-permissive -> iocontrol.0.emc-enable-in`

Baseline was verified as `emc-enable-in=TRUE`, `motion-enabled=TRUE`, `user-enable-out=TRUE`, and controller `ESTOP OFF`.

After the controlled external assertion, the lab observed `emc-enable-in=FALSE`, `motion-enabled=FALSE`, `user-enable-out=TRUE`, and controller `ESTOP ON`. The acceptance gate `external-estop-to-motion-disable` passed.

After release, the lab observed `emc-enable-in=TRUE`, `motion-enabled=FALSE`, and controller `ESTOP OFF`; the `release-without-auto-motion-enable` gate passed.

Final wiring still showed the same sole signal path. The lab exited 0.

## Evidence classification

**TEST-CONFIRMED:** for this pinned userspace simulation, the external `emc-enable-in` condition propagated to controller ESTOP and disabled motion, and release did not automatically restore Machine ON.

**SOURCE-CONFIRMED:** `user-enable-out` is not an acceptance mirror for the external-input path; its remaining TRUE during this experiment agrees with the corrected source trace.

## Explicit non-claims

This experiment did not energize hardware and does not establish physical emergency-stop performance, STO state, zero torque, contactor/brake behavior, stopping distance/time, electrical category, PL, SIL, or any validated functional-safety function. It also does not measure Task-cycle-to-motion-disable latency distribution.

## Adversarial interpretation

A dangerous but incorrect reading would be: “ESTOP ON plus `motion.motion-enabled=FALSE` proves the machine is safe.” The experiment proves only controller-state behavior. Physical risk reduction requires a separately designed and validated machine safety architecture.

## Acceptance decision

PASS. Prediction matched independent runtime evidence without changing the source-derived safety boundary. This satisfies S01's bounded independent-verification requirement at the 1000 level.