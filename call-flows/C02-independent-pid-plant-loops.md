# C02 — independent PID → plant loop call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **SOURCE-CONFIRMED architecture; experiment pending**.

## Minimal deterministic plant

Use two instances of upstream `integ.comp`. Each instance is a discrete realtime integrator with independent HAL/runtime state. Its function takes the current instance's `out`, and on each invocation either resets it to zero or advances it by:

```text
out += gain * in * fperiod
```

then applies that instance's min/max limits. There is no peer-instance read and no hidden shared plant state in the component function.

For a position-loop simulation, PID output is treated as plant velocity and `integ.out` as simulated position feedback. This is deliberately a simple software plant, not a claim about hydraulic dynamics.

## Required servo-thread order

```text
motion-command-handler
motion-controller
pid.0.do-pid-calcs
pid.1.do-pid-calcs
integ.0
integ.1
sampler.0
```

HAL topology:

```text
shared duplicated Y command premise
  +--> pid.0.command
  |      pid.0.feedback <---------------- integ.0.out
  |      pid.0.output -------------------> integ.0.in
  |
  +--> pid.1.command
         pid.1.feedback <---------------- integ.1.out
         pid.1.output -------------------> integ.1.in

sampler.0 runs after both plant instances and captures command, both feedbacks,
both PID errors/outputs, enable state, and the disturbance control in one
realtime observation domain.
```

The order is intentional. Each PID calculates from feedback produced by the previous servo cycle; then each plant advances once from the newly calculated output. `sampler` observes the resulting same-cycle post-plant state. This one-cycle controller/plant staging must not be misdescribed as an observation tear.

## Asymmetric disturbance

C02-024 will disturb only loop B. The preferred mechanism is to change only `integ.1.gain` from 1.0 to a smaller positive value while both PID command inputs remain on the same signal. This creates a deterministic plant-response asymmetry without modifying the command premise or contaminating loop A.

Expected causal chain:

```text
integ.1.gain reduced
 -> for equal controller effort, plant B position advances less per cycle
 -> pid.1.feedback falls behind shared command relative to pid.0.feedback
 -> pid.1.error differs from pid.0.error
 -> pid.1.output responds according to its own state/gains
 -> pid.0 never reads pid.1 feedback/error/output
```

A difference between outputs is evidence of two independent closed-loop responses. It is **not** evidence of cross-coupled synchronization: neither PID compares the two plant positions.

## Failure path

For a separately bounded phase, deassert `pid.1.enable` while keeping `pid.0.enable` asserted. Pinned PID behavior forces loop B output to zero and resets its integral state while loop A continues according to its own state. This is a useful independence/failure oracle but is not a safety-rated single-side-disable recommendation.

## Evidence boundary

`integ` source establishes deterministic per-instance state and update semantics. The runtime experiment must still verify that the actual loaded topology contains two distinct instances/signals and that the asymmetric disturbance affects only the intended plant path.

Retained boundary:

```text
shared command + two independent feedback loops
!= cross-loop comparison
!= gantry/beam synchronization controller
!= following-error policy
!= hydraulic coupling model
!= safety-rated anti-racking
```
